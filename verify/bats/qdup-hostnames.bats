#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../.." && pwd)"
  PROBE_DIR="$(mktemp -d)"
  cat > "${PROBE_DIR}/probe.yml" <<'YAML'
scripts:
  # Replace uploads with distinct hostnames on local shells. Delay infra so
  # application setup would race ahead without the hostname barrier.
  upload_code:
    - sh: |
        export HOSTNAME="$(basename "${{TEST_HOME}}").example"
        if [[ "${HOSTNAME}" == infrahost.example ]]; then
          sleep 1
        fi
YAML
  cat > "${PROBE_DIR}/run" <<'SH'
#!/bin/bash
set -euo pipefail
probe_dir="$(dirname "$0")"
[[ "${!#}" == setup ]]
printf '%s\n' "${TEST_INFRA_HOST:-unset}" "${TEST_APP_HOST:-unset}" > "${probe_dir}/$1-hosts"
SH
  chmod +x "${PROBE_DIR}/run"
}

teardown() {
  rm -rf "${PROBE_DIR}"
}

assert_setup_hostnames() {
  local strategy=$1
  local timeout_cmd=()
  if command -v timeout >/dev/null 2>&1; then
    timeout_cmd=(timeout --foreground 60)
  fi
  # Run the actual setup scripts in qDup, without builds or remote uploads.
  run "${timeout_cmd[@]}" "${REPO_ROOT}/src/qdup/bin/qdup" \
    "${PROBE_DIR}/probe.yml" \
    "${REPO_ROOT}/src/qdup/scripts.yml" \
    "${REPO_ROOT}/src/qdup/hosts/local.yml" \
    "${REPO_ROOT}/src/qdup/test-${strategy}.yml" \
    --skip-stages Run --skip-stages Cleanup -B "${PROBE_DIR}/results" \
    -S "WORK_DIR=${PROBE_DIR}" -S "USR_CACHE_DIR=${PROBE_DIR}" \
    -S TEST=dummy/empty -S TEST_SUBDIR=hostnames \
    -S "INFRA_RUN_CMD=${PROBE_DIR}/run" \
    -S "APP_RUN_CMD=${PROBE_DIR}/run" \
    -S "DRIVER_RUN_CMD=${PROBE_DIR}/run"
  echo "${output}"
  [ "${status}" -eq 0 ]
  [ "$(head -n 1 "${PROBE_DIR}/app-hosts")" = infrahost.example ]
  [ "$(cat "${PROBE_DIR}/drive-hosts")" = $'infrahost.example\napphost.example' ]
  [ -f "${PROBE_DIR}/infra-hosts" ]
}

@test "qdup normal shares hostnames before application and driver setup" {
  assert_setup_hostnames normal
}

@test "qdup AOT shares hostnames before application and driver setup" {
  assert_setup_hostnames aot
}
