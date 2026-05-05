#!/bin/bash

set -euo pipefail

function run_all_tests() {
	local testpat=$1
	local name_tag=${2:-}
	local preparefunccall=${3:-}

	local tests=( $(select_tests "${testpat}") )
	export TEST_ROOT_DIR="${TEST_SRC_DIR}/scripts/tests"

	local result=0
	local cursuite=""
	local curtest=""
	local skip_suite=false
	for test in "${tests[@]}"; do
		local suitenm="${test%%/*}"
		local testnm="${test#*/}"
		if [[ "${suitenm}" != "${cursuite}" ]]; then
			skip_suite=false
			if [[ "${cursuite}" != "" ]]; then
				_set_test_context "${cursuite}" "${curtest}" "${name_tag}"
				_run_test_suite_last
			fi
			cursuite="${suitenm}"
			curtest="${testnm}"
			_set_test_context "${suitenm}" "${testnm}" "${name_tag}"
			result=0
			_run_test_suite_first || result=$?
			if [[ $result -ne 0 ]]; then
				skip_suite=true
				continue
			fi
		elif [[ "${skip_suite}" == true ]]; then
			continue
		fi
		_set_test_context "${suitenm}" "${testnm}" "${name_tag}"
		if [[ -n "${preparefunccall}" ]]; then
			${preparefunccall}
		fi
		result=0
		_run_before_test || result=$?
		if [[ $result -eq 0 ]]; then
			_run_test || result=$?
			_run_after_test || result=$?
		fi
	done
	if [[ "${cursuite}" != "" ]]; then
		_set_test_context "${cursuite}" "${curtest}" "${name_tag}"
		_run_test_suite_last
	fi
}

function _run_test() {
	local result=0
	_run_command_for_driver "${TEST_DRIVER}" "prepare" "Preparing ${TEST_DRIVER} test driver for" "${TEST_TEST_RUNID}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
	_run_command_for_suite "app_start" "Starting test application for" "${TEST_TEST_RUNID}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
	_run_command_for_test "app_start" "Starting test application for" "${TEST_TEST_RUNID}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi

	# Run the performance tests
	local result1=0
	_run_perf_tests || result1=$?
	# don't exit on error yet!

	local result2=0
	_run_command_for_test "app_stop" "Stopping test application for" "${TEST_TEST_RUNID}" || result2=$?

	local result3=0
	_run_command_for_suite "app_stop" "Stopping test application for" "${TEST_TEST_RUNID}" || result3=$?

	if [[ -f "${TEST_OUT_DIR}/${TEST_TEST_RUNID}-profile.jfr" ]]; then
		# If we have JFR files, process them
		generate_profiling_results "${TEST_TEST_RUNID}"
	fi
	
	result=$((result1 + result2 + result3))
	return $result
}

function _run_perf_tests() {
	_run_command_for_driver "${TEST_DRIVER}" "run" "[TEST] Running tests for ${TEST_TEST_NAME} using ${TEST_DRIVER} driver..." "${TEST_TEST_RUNID}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
}

function _run_before_test() {
	local result=0
	_run_command_for_suite "setup" "Setting up" "${TEST_TEST_RUNID}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
	_run_command_for_test "setup" "Setting up" "${TEST_TEST_RUNID}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
	_run_command_for_suite "infra_start" "Starting infrastructure for" "${TEST_TEST_RUNID}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
	_run_command_for_test "infra_start" "Starting test infrastructure for" "${TEST_TEST_RUNID}" || result=$?
	return $result
}

function _run_after_test() {
	local result1=0
	_run_command_for_test "infra_stop" "Stopping test infrastructure for" "${TEST_TEST_RUNID}" || result1=$?
	
	# don't exit on error yet!
	local result2=0
	_run_command_for_suite "infra_stop" "Stopping infrastructure for" "${TEST_TEST_RUNID}" || result2=$?

	local result=$((result1 + result2))
	return $result
}

function _run_test_suite_first() {
	local result=0
	_run_command_for_suite "setup_first" "Initial setup for" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
	_run_command_for_suite "infra_first" "Starting initial infrastructure for" || result=$?
	return $result
}

function _run_test_suite_last() {
	local result=0
	_run_command_for_suite "infra_last" "Stopping initial infrastructure for" || result=$?
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
