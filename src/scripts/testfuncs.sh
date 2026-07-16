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

	run_for_all_tests "${testpat}" "_run_full_test" "${name_tag}"
}

# This function loops over all tests matching a given pattern, sets up the test context
# and runs the specified function for each test.
# Arguments:
#   testpat - pattern to match tests in the form suite/test
#   testfunc - function that will be called for all tests
#   name_tag - (optional) tag to append to the test run ID
# Variables used:
#   TEST_ROOT_DIR - root directory where test suites are located
# Returns:
#   0 if all tests passed, non-zero if any test failed
function run_for_all_tests() {
	local testpat=$1
	local testfunc=$2
	local name_tag=${3:-}

	local tests=( $(select_tests "${testpat}") )

	local result=0
	local finalresult=0
	local cursuite=""
	local curtest=""
	for test in "${tests[@]}"; do
		local suitenm="${test%%/*}"
		local testnm="${test#*/}"
		_set_test_context "${suitenm}" "${testnm}" "${name_tag}"
		result=0
		${testfunc} "${suitenm}" "${testnm}" || result=$?
		finalresult=$((finalresult + result))
	done
	return $finalresult
}

function _run_full_test() {
	local suitenm="$1"
	local testnm="$2"

	_run_before_test || return $?
	local result1=0
	_run_test || result1=$?
	local result2=0
	_run_after_test || result2=$?
	return $((result1 + result2))
}

function _run_test() {
	local result=0
	_run_command "driver_prime" "Priming driver for" "${TEST_TEST_RUNID}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
	_run_command "app_start" "Starting test application for" "${TEST_TEST_RUNID}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi

	# Run the performance tests
	local result1=0
	_run_perf_tests || result1=$?
	# don't exit on error yet!

	local result2=0
	_run_command "app_stop" "Stopping test application for" "${TEST_TEST_RUNID}" || result2=$?

	if [[ -f "${TEST_OUT_DIR}/${TEST_TEST_RUNID}-profile.jfr" ]]; then
		# If we have JFR files, process them
		generate_profiling_results "${TEST_TEST_RUNID}"
	fi
	
	result=$((result1 + result2))
	return $result
}

function _run_perf_tests() {
	_run_command "driver_run" "Running driver for" "${TEST_TEST_RUNID}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
}

function _run_before_test() {
	local result=0
	_run_command "infra_setup" "Setting up infrastructure for" "${TEST_TEST_RUNID}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
	_run_command "app_setup" "Setting up application for" "${TEST_TEST_RUNID}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
	_run_command "infra_start" "Starting infrastructure for" "${TEST_TEST_RUNID}" || result=$?
	return $result
}

function _run_after_test() {
	local result1=0
	_run_command "infra_stop" "Stopping infrastructure for" "${TEST_TEST_RUNID}" || result1=$?
	local result=$result1
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
