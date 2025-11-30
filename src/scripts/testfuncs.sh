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

	_run_command_for_test "app" "Starting test application for" "start" "${name}"

	# Run the performance tests
	_run_perf_tests

	_run_command_for_test "app" "Stopping test application for" "stop" "${name}"
}

function _run_perf_tests() {
	echo "   - [TEST] Running tests for ${TEST_TEST_NAME} using ${TEST_DRIVER} driver..."
	"${TEST_SRC_DIR}/scripts/drivers/${TEST_DRIVER}.sh"
}

function _run_test_suite_before() {
	local name_tag=${1:-}

	source "${TEST_SUITE_DIR}/shared-vars.sh"

	local name="${TEST_SUITE_NAME}-${TEST_TEST_NAME}${name_tag:+-$name_tag}"
	export TEST_TEST_RUNID="${name}"

	_run_command_for_suite "infra" "Starting infrastructure for" "start"
	_run_command_for_suite "app" "Starting test application for" "start"
}

function _run_test_suite_after() {
	local name_tag=${1:-}

	source "${TEST_SUITE_DIR}/shared-vars.sh"

	local name="${TEST_SUITE_NAME}-${TEST_TEST_NAME}${name_tag:+-$name_tag}"
	export TEST_TEST_RUNID="${name}"

	_run_command_for_suite "app" "Stopping test application for" "stop"
	_run_command_for_suite "infra" "Stopping infrastructure for" "stop"
}

function _run_test_suite_first() {
	source "${TEST_SUITE_DIR}/shared-vars.sh"
	_run_command_for_suite "infra" "Starting initial infrastructure for" "first"
	_run_command_for_suite "app" "Starting initial test application for" "first"
}

function _run_test_suite_last() {
	_run_command_for_suite "app" "Stopping initial test application for" "last"
	_run_command_for_suite "infra" "Stopping initial infrastructure for" "last"
}
