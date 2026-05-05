#!/bin/bash

# DESCRIPTION=Setup the required applications and dependencies for the tests.

set -euo pipefail

if [[ ! -v TEST_SRC_DIR ]]; then
	echo "ERROR: Please run this script via './run setup ...' from the leyden-perf-test root directory."
	exit 3
fi

if [[ $# -gt 0 && ( "$1" == "-h" || "$1" == "--help" ) ]]; then
	echo "This command sets up the required applications and dependencies for the tests."
	echo "Usage: ./run setup [<test-suite>/<test-name>]"
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh

function run_setup() {
	local testpat=$1

	local tests=( $(select_tests "${testpat}") )
	export TEST_ROOT_DIR="${TEST_SRC_DIR}/scripts/tests"

	local cursuite=""
	local curtest=""
	local result=0
	local msg="Setting up"
	for test in "${tests[@]}"; do
		local suitenm="${test%%/*}"
		local testnm="${test#*/}"
		_set_test_context "${suitenm}" "${testnm}"
		result=0
		if [[ "${TEST_SUITE_NAME}" != "${cursuite}" ]]; then
			cursuite="${TEST_SUITE_NAME}"
			_run_command_for_suite "setup" "${msg}" "${testnm}" || result=$?
			[[ $result -ne 0 ]] && continue
		fi
		_run_command_for_test "setup" "${msg}" "${testnm}" || result=$?
	done
	return $result
}

if [[ $# -gt 0 && "$1" == "--clean" ]]; then
	rm -rf "${TEST_CACHE_DIR}" > /dev/null || true
	echo -e "   - ${NORMAL}${GREEN}✓ Cleaned 'cache' directory${NORMAL}"
	shift
fi

run_setup "${1:-all}"
