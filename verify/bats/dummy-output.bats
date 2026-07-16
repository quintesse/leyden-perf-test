#!/usr/bin/env bats

# Validates action-resolution precedence using tests-dummy fixtures.

setup_file() {
  local timeout_sec

  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../.." >/dev/null 2>&1 && pwd)"
  TMP_DIR="$(mktemp -d)"
  LOG_FILE="${TMP_DIR}/run.log"
  OUT_DIR="${TMP_DIR}/results"
  timeout_sec="${VERIFY_SETUP_TIMEOUT_SEC:-120}"

  if command -v timeout >/dev/null 2>&1; then
    if ! timeout --foreground "${timeout_sec}" bash -c 'cd "$1" && ./run test -j 25 -d dummy -s normal -T tests-dummy all -o "$2" > "$3" 2>&1' _ "${REPO_ROOT}" "${OUT_DIR}" "${LOG_FILE}"; then
      echo "Dummy harness setup failed (or timed out after ${timeout_sec}s)." >&2
      cat "${LOG_FILE}" >&2 || true
      return 1
    fi
  else
    if ! bash -c 'cd "$1" && ./run test -j 25 -d dummy -s normal -T tests-dummy all -o "$2" > "$3" 2>&1' _ "${REPO_ROOT}" "${OUT_DIR}" "${LOG_FILE}"; then
      echo "Dummy harness setup failed." >&2
      cat "${LOG_FILE}" >&2 || true
      return 1
    fi
  fi

  export REPO_ROOT TMP_DIR LOG_FILE OUT_DIR
}

teardown_file() {
  rm -rf "${TMP_DIR}"
}

extract_test_block() {
  local log_file=$1
  local test_id=$2

  awk -v test_id="${test_id}" '
    index($0, "Running infra_setup for test: " test_id " ...") { capture = 1 }
    capture { print }
    index($0, "Running infra_stop for test: " test_id " ...") { stop_seen = 1 }
    stop_seen && index($0, ": Done.") { exit }
  ' "${log_file}"
}

extract_action_lines() {
  grep -E '^(Dummy|Empty) (global|suite|test) (infra_setup|app_setup|driver_setup|infra_start|driver_prime|app_start|driver_run|app_stop|infra_stop) action$'
}

assert_expected_lines() {
  local actual=$1
  shift
  local expected=("$@")
  local idx

  mapfile -t actual_lines <<< "${actual}"
  [ "${#actual_lines[@]}" -eq "${#expected[@]}" ]

  for idx in "${!expected[@]}"; do
    [ "${actual_lines[idx]}" = "${expected[idx]}" ]
  done
}

assert_mapping_for_test() {
  local log_file=$1
  local test_id=$2
  shift 2
  local block
  local actions

  block="$(extract_test_block "${log_file}" "${test_id}")"
  [ -n "${block}" ]

  actions="$(printf '%s\n' "${block}" | extract_action_lines)"
  assert_expected_lines "${actions}" "$@"
}

@test "dummy/override uses test-level actions" {
  assert_mapping_for_test "${LOG_FILE}" "dummy/override" \
    "Dummy test infra_setup action" \
    "Dummy test app_setup action" \
    "Dummy test driver_setup action" \
    "Dummy test infra_start action" \
    "Dummy test driver_prime action" \
    "Dummy test app_start action" \
    "Dummy test driver_run action" \
    "Dummy test app_stop action" \
    "Dummy test infra_stop action"
}

@test "dummy/empty falls back to suite-level actions" {
  assert_mapping_for_test "${LOG_FILE}" "dummy/empty" \
    "Dummy suite infra_setup action" \
    "Dummy suite app_setup action" \
    "Dummy suite driver_setup action" \
    "Dummy suite infra_start action" \
    "Dummy suite driver_prime action" \
    "Dummy suite app_start action" \
    "Dummy suite driver_run action" \
    "Dummy suite app_stop action" \
    "Dummy suite infra_stop action"
}

@test "empty/override uses empty test-level actions" {
  assert_mapping_for_test "${LOG_FILE}" "empty/override" \
    "Empty test infra_setup action" \
    "Empty test app_setup action" \
    "Empty test driver_setup action" \
    "Empty test infra_start action" \
    "Empty test driver_prime action" \
    "Empty test app_start action" \
    "Empty test driver_run action" \
    "Empty test app_stop action" \
    "Empty test infra_stop action"
}

@test "empty/empty falls back to global actions" {
  assert_mapping_for_test "${LOG_FILE}" "empty/empty" \
    "Dummy global infra_setup action" \
    "Dummy global app_setup action" \
    "Dummy global driver_setup action" \
    "Dummy global infra_start action" \
    "Dummy global driver_prime action" \
    "Dummy global app_start action" \
    "Dummy global driver_run action" \
    "Dummy global app_stop action" \
    "Dummy global infra_stop action"
}
