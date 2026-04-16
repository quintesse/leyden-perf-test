#!/bin/bash

set -euo pipefail

function run_all_tests() {
	local testpat=$1
	local name_tag=${2:-}
	local preparefunccall=${3:-}

	local -a testfunccall
	local -a beforesuitefunccall
	local -a aftersuitefunccall
	local -a firstsuitefunccall
	local -a lastsuitefunccall

	testfunccall=("_run_test" "${name_tag}" "${preparefunccall}")
	beforesuitefunccall=("_run_test_suite_before" "${name_tag}")
	aftersuitefunccall=("_run_test_suite_after" "${name_tag}")
	firstsuitefunccall=("_run_test_suite_first")
	lastsuitefunccall=("_run_test_suite_last")
	run_suite_funcs "${testpat}" testfunccall beforesuitefunccall aftersuitefunccall firstsuitefunccall lastsuitefunccall
}

function _run_test() {
	local name_tag=${1:-}
	local preparefunccall=${2:-}

	source "${TEST_SUITE_DIR}/shared-vars.sh"

	local name="${TEST_SUITE_NAME}-${TEST_TEST_NAME}${name_tag:+-$name_tag}"
	export TEST_TEST_RUNID="${name}"

	if [[ -n "${preparefunccall}" ]]; then
		${preparefunccall}
	fi

	local result=0
	_run_command_for_test "infra" "Starting test infrastructure for" "start" "${name}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
	_run_command_for_driver "${TEST_DRIVER}" "Preparing test driver for" "prepare" "${name}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
	_run_command_for_test "app" "Starting test application for" "start" "${name}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi

	# Run the performance tests
	local result1=0
	_run_perf_tests || result1=$?
	# don't exit on error yet!

	local result2=0
	_run_command_for_test "app" "Stopping test application for" "stop" "${name}" || result2=$?
	
	# don't exit on error yet!
	local result3=0
	_run_command_for_test "infra" "Stopping test infrastructure for" "stop" "${name}" || result3=$?

	if [[ -f "${TEST_OUT_DIR}/${name}-profile.jfr" ]]; then
		# If we have JFR files, process them
		generate_profiling_results "${name}"
	fi
	
	result=$((result1 + result2 + result3))
	return $result
}

function _run_perf_tests() {
	_run_command_for_driver "${TEST_DRIVER}" "[TEST] Running tests for ${TEST_TEST_NAME} using ${TEST_DRIVER} driver..." "run" "${name}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
}

function _run_test_suite_before() {
	local name_tag=${1:-}

	source "${TEST_SUITE_DIR}/shared-vars.sh"

	local name="${TEST_SUITE_NAME}-${TEST_TEST_NAME}${name_tag:+-$name_tag}"
	export TEST_TEST_RUNID="${name}"

	local result=0
	_run_command_for_suite "infra" "Starting infrastructure for" "start" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
	_run_command_for_suite "app" "Starting test application for" "start" || result=$?
	return $result
}

function _run_test_suite_after() {
	local name_tag=${1:-}

	source "${TEST_SUITE_DIR}/shared-vars.sh"

	local name="${TEST_SUITE_NAME}-${TEST_TEST_NAME}${name_tag:+-$name_tag}"
	export TEST_TEST_RUNID="${name}"

	local result1=0
	_run_command_for_suite "app" "Stopping test application for" "stop" || result1=$?
	
	# don't exit on error yet!
	local result2=0
	_run_command_for_suite "infra" "Stopping infrastructure for" "stop" || result2=$?

	local result=$((result1 + result2))
	return $result
}

function _run_test_suite_first() {
	source "${TEST_SUITE_DIR}/shared-vars.sh"

	local result=0
	_run_command_for_suite "infra" "Starting initial infrastructure for" "first" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
	_run_command_for_suite "app" "Starting initial test application for" "first" || result=$?
	return $result
}

function _run_test_suite_last() {
	source "${TEST_SUITE_DIR}/shared-vars.sh"

	local result1=0
	_run_command_for_suite "app" "Stopping initial test application for" "last" || result1=$?
	# don't exit on error yet!
	local result2=0
	_run_command_for_suite "infra" "Stopping initial infrastructure for" "last" || result2=$?
	local result=$((result1 + result2))
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
