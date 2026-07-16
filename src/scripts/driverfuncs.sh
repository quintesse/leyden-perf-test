#!/bin/bash

set -euo pipefail

function setup_driver() {
    _run_command_for_driver "${TEST_DRIVER}" "setup" "Setting up ${TEST_DRIVER} test driver"
}

function prime_driver() {
    _run_command_for_driver "${TEST_DRIVER}" "prime" "Priming ${TEST_DRIVER} test driver for" "${TEST_TEST_RUNID}"
}

function run_driver() {
    _run_command_for_driver "${TEST_DRIVER}" "run" "Running tests using ${TEST_DRIVER} driver for" "${TEST_TEST_RUNID}"
}

# Runs a command for a specific driver.
# Commands are actions handled by driver.sh located in the drivers/<driver> directory.
# Arguments:
#   driver - driver name
#   action - action to run (setup, prime, run)
#   msg    - message to display
#   args   - additional arguments
# Variables used:
#   TEST_SUITE_NAME - name of the test suite
#   TEST_TEST_NAME  - name of the test
#   TEST_SRC_DIR    - directory of the sources
function _run_command_for_driver() {
	local driver=$1
	local action=$2
	local msg=$3
	local args=("${@:4}")
	local launcher_path="${TEST_SRC_DIR}/scripts/launcher.sh"
	local cmd_path="${TEST_SRC_DIR}/scripts/drivers/${driver}/driver.sh"
	local ctx="${TEST_SUITE_NAME:-}/${TEST_TEST_NAME:-}"
	if [[ -f "${cmd_path}" ]]; then
		echo "   - ${msg} test: ${ctx} ..."
		local result=0
		"${launcher_path}" "${cmd_path}" -- "${action}" "${args[@]}" || result=$?
		if [[ $result -ne 0 ]]; then
			echo -e "   - ${NORMAL}${RED}✗ ${msg} test ${ctx}   : Failed.${NORMAL}"
			return $result
		fi
		echo -e "   - ${NORMAL}${GREEN}✓ ${msg} test ${ctx}   : Done.${NORMAL}"
	fi
}
