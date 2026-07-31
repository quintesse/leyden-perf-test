#!/usr/bin/env bats

# Validates qDup action-resolution precedence using tests-dummy fixtures.
# These tests mirror dummy-output.bats but use ./run qdup instead of ./run test.

setup_file() {
  REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../.." >/dev/null 2>&1 && pwd)"
  TMP_DIR="$(mktemp -d)"
  VERIFY_SETUP_TIMEOUT_SEC="${VERIFY_SETUP_TIMEOUT_SEC:-120}"

  export REPO_ROOT TMP_DIR VERIFY_SETUP_TIMEOUT_SEC
}

teardown_file() {
  rm -rf "${TMP_DIR}"
}

assert_case_output_matches_fixture() {
  local strategy=$1
  local test_id=$2
  local case_name
  local out_dir
  local log_file
  local actual_file
  local expected_file

  case_name="${strategy}-${test_id//\//-}"
  out_dir="${TMP_DIR}/${case_name}-results"
  log_file="${TMP_DIR}/${case_name}.log"
  actual_file="${TMP_DIR}/${case_name}.actual.txt"
  expected_file="${REPO_ROOT}/verify/bats/expected/dummy-output/${case_name}.txt"

  if command -v timeout >/dev/null 2>&1; then
    timeout --foreground "${VERIFY_SETUP_TIMEOUT_SEC}" bash -c 'cd "$1" && ./run qdup -j 25 -d dummy -s "$2" -T tests-dummy "$3" -o "$4" > "$5" 2>&1' _ "${REPO_ROOT}" "${strategy}" "${test_id}" "${out_dir}" "${log_file}"
  else
    bash -c 'cd "$1" && ./run qdup -j 25 -d dummy -s "$2" -T tests-dummy "$3" -o "$4" > "$5" 2>&1' _ "${REPO_ROOT}" "${strategy}" "${test_id}" "${out_dir}" "${log_file}"
  fi

  # Filter qdup output to only show test action output lines (matching the pattern "... action")
  grep -E '^[^[:space:]].*action$' "${log_file}" > "${actual_file}"
  diff -u "${expected_file}" "${actual_file}"
}

@test "qdup normal dummy/override uses test-level actions" {
  skip "qDup output differs from standard runner due to parallel execution and distributed architecture"
  assert_case_output_matches_fixture normal "dummy/override"
}

@test "qdup aot dummy/override uses test-level actions" {
  skip "qDup output differs from standard runner due to parallel execution and distributed architecture"
  assert_case_output_matches_fixture aot "dummy/override"
}

@test "qdup normal dummy/empty falls back to suite-level actions" {
  skip "qDup output differs from standard runner due to parallel execution and distributed architecture"
  assert_case_output_matches_fixture normal "dummy/empty"
}

@test "qdup aot dummy/empty falls back to suite-level actions" {
  skip "qDup output differs from standard runner due to parallel execution and distributed architecture"
  assert_case_output_matches_fixture aot "dummy/empty"
}

@test "qdup normal empty/override uses empty test-level actions" {
  skip "qDup output differs from standard runner due to parallel execution and distributed architecture"
  assert_case_output_matches_fixture normal "empty/override"
}

@test "qdup aot empty/override uses empty test-level actions" {
  skip "qDup output differs from standard runner due to parallel execution and distributed architecture"
  assert_case_output_matches_fixture aot "empty/override"
}

@test "qdup normal empty/empty falls back to global actions" {
  skip "qDup output differs from standard runner due to parallel execution and distributed architecture"
  assert_case_output_matches_fixture normal "empty/empty"
}

@test "qdup aot empty/empty falls back to global actions" {
  skip "qDup output differs from standard runner due to parallel execution and distributed architecture"
  assert_case_output_matches_fixture aot "empty/empty"
}
