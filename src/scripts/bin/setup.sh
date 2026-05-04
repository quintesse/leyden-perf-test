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
	local msg=$2

	local tests=( $(select_tests "${testpat}") )
	export TEST_ROOT_DIR="${TEST_SRC_DIR}/scripts/tests"

	local cursuite=""
	local result=0
	for test in "${tests[@]}"; do
		_set_test_context "${test%%/*}" "${test#*/}"
		if [[ -z "${cursuite}" ]]; then
			_run_command_for_global "setup" "${msg}"
		fi
		if [[ "${TEST_SUITE_NAME}" != "${cursuite}" ]]; then
			cursuite="${TEST_SUITE_NAME}"
			_run_command_for_suite "setup" "${msg}" || result=$?
		fi
		_run_command_for_test "setup" "${msg}" || result=$?
	done
	return $result
}

if ! command -v oha >/dev/null 2>&1
then
    echo -e "   - ${NORMAL}${RED}✗ oha   : Command not found, please install it, see https://github.com/hatoo/oha${NORMAL}"
else
    echo -e "   - ${NORMAL}${GREEN}✓ oha   : Command is installed.${NORMAL}"
fi

if [[ $# -gt 0 && "$1" == "--clean" ]]; then
	rm -rf "${TEST_CACHE_DIR}" > /dev/null || true
	echo -e "   - ${NORMAL}${GREEN}✓ Cleaned 'cache' directory${NORMAL}"
	shift
fi

run_setup "${1:-all}" "Setting up"
