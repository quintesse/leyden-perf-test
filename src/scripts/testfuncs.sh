#!/bin/bash

set -euo pipefail

# This function runs all tests matching a given pattern, optionally with a name tag and a preparation function.
# Arguments:
#   testpat - pattern to match tests in the form suite/test
#   name_tag - (optional) tag to append to the test run ID
# Variables used:
#   TEST_ROOT_DIR - root directory where test suites are located
# Returns:
#   exit code of the last command run
function run_all_tests() {
	local testpat=$1
	local name_tag=${2:-}

	run_for_suite "${testpat}" "_run_full_test" "${name_tag}"
}

function _run_full_test() {
	local suitenm="$1"
	local testnm="$2"

	local result=0
	_run_commands "infra_setup" "app_setup" "driver_setup" "infra_start/infra_stop" "driver_prime" "app_start/app_stop" "driver_run" -- "${TEST_TEST_RUNID}" || result=$?

	if [[ -f "${TEST_OUT_DIR}/${TEST_TEST_RUNID}-profile.jfr" ]]; then
		# If we have JFR files, process them
		generate_profiling_results "${TEST_TEST_RUNID}"
	fi

	return $result
}

function generate_profiling_results() {
	local name=$1
	local jar="tools.profiler:jfr-converter:LATEST"
	local opts="-R=-Xss2M"
	"${TEST_DIR}/jbang" "$opts" "$jar" "${TEST_OUT_DIR}/${name}-profile.jfr" "${TEST_OUT_DIR}/${name}-profile.html"
	"${TEST_DIR}/jbang" "$opts" "$jar" "${TEST_OUT_DIR}/${name}-profile.jfr" "${TEST_OUT_DIR}/${name}-profile.otlp"	
	"${TEST_DIR}/jbang" "$opts" "$jar" "${TEST_OUT_DIR}/${name}-profile.jfr" "${TEST_OUT_DIR}/${name}-profile.pprof"	
}
