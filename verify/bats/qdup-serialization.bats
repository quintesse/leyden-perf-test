#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../.." && pwd)"
  PROBE_DIR="$(mktemp -d)"
  mkdir -p "${PROBE_DIR}/infra" "${PROBE_DIR}/app" "${PROBE_DIR}/driver"
  cat > "${PROBE_DIR}/run" <<'SH'
#!/bin/bash
set -euo pipefail
probe_dir="$(dirname "$0")"
role=$1
action=${!#}
printf '%s %s\n' "${role}" "${action}" >> "${probe_dir}/events"
if [[ "${action}" == start ]]; then
  # A second start before stop completes must fail, like a named container.
  mkdir "${probe_dir}/${role}-active"
  if [[ "${role}" == app ]]; then
    printf '%s\n' "${TEST_STRAT_OPTS:-}" >> "${probe_dir}/app-options"
  fi
elif [[ "${action}" == stop ]]; then
  sleep 0.3
  # Simulate the training JVM writing its cache at shutdown.
  if [[ "${role}" == app && "${TEST_STRAT_OPTS:-}" == -XX:AOTCacheOutput=* && ! -f "${probe_dir}/omit-cache" ]]; then
    cache_path=${TEST_STRAT_OPTS#-XX:AOTCacheOutput=}
    cache_path=${cache_path%% *}
    printf 'AOT cache\n' > "${cache_path}"
  fi
  rmdir "${probe_dir}/${role}-active"
  printf '%s stopped\n' "${role}" >> "${probe_dir}/events"
fi
SH
  chmod +x "${PROBE_DIR}/run"
}

teardown() {
  rm -rf "${PROBE_DIR}"
}

run_aot_probe() {
  local timeout_cmd=()
  if command -v timeout >/dev/null 2>&1; then
    timeout_cmd=(timeout --foreground 60)
  fi
  # Exercise the actual YAML and qDup engine with isolated stub commands.
  # Skip upload/setup and final cleanup, which would touch real harness paths.
  run "${timeout_cmd[@]}" "${REPO_ROOT}/src/qdup/bin/qdup" \
    "${REPO_ROOT}/src/qdup/hosts/local.yml" \
    "${REPO_ROOT}/src/qdup/scripts.yml" \
    "${REPO_ROOT}/src/qdup/test-aot.yml" \
    --skip-stages Setup --skip-stages Cleanup -B "${PROBE_DIR}/results" \
    -S "TEST_DIR=${REPO_ROOT}" \
    -S "WORK_DIR=${PROBE_DIR}" -S TEST_SUBDIR=serialization \
    -S TEST=dummy/empty -S "USR_CACHE_DIR=${PROBE_DIR}" \
    -S INFRA_HOST=localhost -S APP_HOST=localhost \
    -S "INFRA_RUN_CMD=${PROBE_DIR}/run" \
    -S "APP_RUN_CMD=${PROBE_DIR}/run" \
    -S "DRIVER_RUN_CMD=${PROBE_DIR}/run" \
    -S "INFRA_TEST_OUT=${PROBE_DIR}/infra" \
    -S "APP_TEST_OUT=${PROBE_DIR}/app" \
    -S "DRIVER_TEST_OUT=${PROBE_DIR}/driver"
  echo "${output}"
}

@test "qdup AOT waits for training shutdown and passes phase-specific JVM options" {
  run_aot_probe
  [ "${status}" -eq 0 ]

  local cache_path="${PROBE_DIR}/app/dummy-empty-app.aot"
  local training_opts measured_opts
  training_opts="$(sed -n '1p' "${PROBE_DIR}/app-options")"
  measured_opts="$(sed -n '2p' "${PROBE_DIR}/app-options")"
  [[ "${training_opts}" == "-XX:AOTCacheOutput=${cache_path} "* ]]
  [[ "${training_opts}" == *"file=${PROBE_DIR}/app/dummy-empty-training-aot.map:none:filesize=0"* ]]
  [[ "${training_opts}" == *"file=${PROBE_DIR}/app/dummy-empty-training.log:level,tags" ]]
  [ "${measured_opts}" = "-XX:AOTMode=on -XX:AOTCache=${cache_path} -Xlog:aot=warning:file=${PROBE_DIR}/app/dummy-empty-aot.log:level,tags" ]
  [ "$(wc -l < "${PROBE_DIR}/app-options")" -eq 2 ]

  # Both passes must run, and ALL second-pass work must follow BOTH stops.
  awk '
    $2 == "stopped" { stopped[$1]++; next }
    {
      count[$0]++
      if (count[$0] == 2 && (stopped["infra"] < 1 || stopped["app"] < 1))
        failed = 1
    }
    END {
      exit (failed || count["infra start"] != 2 || count["app start"] != 2 ||
            count["drive prime"] != 2 || count["drive run"] != 2 ||
            stopped["infra"] != 2 || stopped["app"] != 2)
    }
  ' "${PROBE_DIR}/events"
}

@test "qdup AOT aborts before the measured pass if training produces no cache" {
  touch "${PROBE_DIR}/omit-cache"
  run_aot_probe
  [ "${status}" -ne 0 ]
  [[ "${output}" == *"Error: AOT training did not produce a non-empty cache:"* ]]
  [ "$(grep -c '^app start$' "${PROBE_DIR}/events")" -eq 1 ]
  [ "$(grep -c '^infra start$' "${PROBE_DIR}/events")" -eq 1 ]
  [ "$(grep -c '^drive run$' "${PROBE_DIR}/events")" -eq 1 ]
}
