#!/bin/bash

set -euo pipefail

# Lists test suites
# Arguments:
#   pat - (optional) pattern to match suites (default: */)
# Returns:
#   list of test suites
function list_test_suites() {
	local pat=${1:-*/}
	list_files_in_dir_except "${TEST_SRC_DIR}/scripts/tests" "$pat"
}

# Lists tests in a suite
# Arguments:
#   suite - suite name
#   pat   - (optional) pattern to match tests (default: */)
# Returns:
#   list of tests in the suite
function list_tests_in_suite() {
	local suite=$1
	local pat=${2:-*/}
	list_files_in_dir_except "${TEST_SRC_DIR}/scripts/tests/${suite}" "$pat"
}

# Lists files in a directory except those starting with '_'
# Arguments:
#   dir - directory path
#   pat - (optional) pattern to match files (default: */)
# Returns:
#   list of files in the directory matching the pattern except those starting with '_'
function list_files_in_dir_except() {
	local dir=$1
	local pat=${2:-*/}
	for nm in "${dir}/"${pat}; do
		if [[ -d "${nm}" ]]; then
			if [[ $(basename "$nm") != "_"* ]]; then
				bnm=$(basename "$nm")
				echo "$bnm"
			fi
		fi
	done
}

# Selects tests based on user pattern
# Arguments:
#   userpat - user pattern in the form suite/test, where suite or test can be 'all' or contain wildcards
# Returns:
#   list of selected tests in the form suite/test
function select_tests() {
	local userpat=${1:-all}
	local suitepat=${userpat%%/*}
	local testpat=${userpat#*/}
	if [[ $userpat != *"/"* ]]; then
		testpat=
	fi
	local suites=()
	if [[ "${userpat}" == "all" || "${suitepat}" == "all" ]]; then
		suites=( $(list_test_suites) )
	else
		# split testpat by / and take the first part as suite
		suites=( $(list_test_suites "$suitepat") )
	fi
	local selected_tests=()
	for suite in "${suites[@]}"; do
		local tests=()
		if [[ "${testpat}" == "all" ]]; then
			tests=( $(list_tests_in_suite "${suite}") )
		else
			tests=( $(list_tests_in_suite "${suite}" "$testpat") )
		fi
		for test in "${tests[@]}"; do
			selected_tests+=("${suite}/${test}")
		done
	done
	echo "${selected_tests[@]}"
}

# Reads test description from DESCRIPTION file
# Arguments:
#   suite - suite name
#   test  - (optional) test name
# Returns:
#   description string
function read_test_description() {
	local suite=$1
	local test=${2:-}
	if [[ -z "${test}" ]]; then
		read_description "${TEST_SRC_DIR}/scripts/tests/${suite}/DESCRIPTION"
	else
		read_description "${TEST_SRC_DIR}/scripts/tests/${suite}/${test}/DESCRIPTION"
	fi
}

# Reads the first line of a description file
# Arguments:
#   descfile - description file path
# Returns:
#   first line of the description file
function read_description() {
	local descfile=$1
	if [[ -f "${descfile}" ]]; then
		head -n 1 "${descfile}"
	fi
}

# Sets the test context environment variables.
# Arguments:
#   suite - suite name
#   test  - (optional) test name (empty string if not provided)
# Variables set:
#   TEST_SUITE_NAME, TEST_TEST_NAME, TEST_SUITE_DIR, TEST_TEST_DIR
function _set_test_context() {
	local suite=$1
	local test=${2:-}
	export TEST_SUITE_NAME="${suite}"
	export TEST_TEST_NAME="${test}"
	export TEST_SUITE_DIR="${TEST_ROOT_DIR}/${TEST_SUITE_NAME}"
	export TEST_SUITE_CACHE="${TEST_CACHE_DIR}/${TEST_SUITE_NAME}"
	if [[ -n "${test}" ]]; then
		export TEST_TEST_DIR="${TEST_ROOT_DIR}/${TEST_SUITE_NAME}/${TEST_TEST_NAME}"
		export TEST_TEST_CACHE="${TEST_CACHE_DIR}/${TEST_SUITE_NAME}/${TEST_TEST_NAME}"
	else
		export TEST_TEST_DIR=
		export TEST_TEST_CACHE=
	fi
}

# Runs a command for a specific test.
# Commands are actions handled by test.sh located in the TEST_TEST_DIR directory.
# Arguments:
#   cmd - command/action to run
#   msg - message to display
#   args - additional arguments
# Variables used:
#   TEST_SUITE_NAME - name of the test suite
#   TEST_TEST_NAME  - name of the test
#   TEST_TEST_DIR   - directory of the test
function _run_command_for_test() {
	local cmd=$1
	local msg=$2
	local args=("${@:3}")
	local launcher_path="${TEST_SRC_DIR}/scripts/launchers/tests/suite/test/test.sh"
	local cmd_path="${TEST_TEST_DIR}/test.sh"
	if [[ -f "${cmd_path}" ]]; then
		echo "   - ${msg} test: ${TEST_SUITE_NAME}/${TEST_TEST_NAME} ..."
		local result=0
		"${launcher_path}" "${cmd_path}" "${cmd}" "${args[@]}" || result=$?
		if [[ $result -ne 0 ]]; then
			echo -e "   - ${NORMAL}${RED}✗ ${msg} test ${TEST_SUITE_NAME}/${TEST_TEST_NAME}   : Failed.${NORMAL}"
			return $result
		fi
		echo -e "   - ${NORMAL}${GREEN}✓ ${msg} test ${TEST_SUITE_NAME}/${TEST_TEST_NAME}   : Done.${NORMAL}"
	fi
}

# Runs a command for a specific test suite.
# Commands are actions handled by test.sh located in the TEST_SUITE_DIR directory.
# Arguments:
#   cmd - command/action to run
#   msg - message to display
#   args - additional arguments
# Variables used:
#   TEST_SUITE_NAME - name of the test suite
#   TEST_SUITE_DIR  - directory of the test suite
function _run_command_for_suite() {
	local cmd=$1
	local msg=$2
	local args=("${@:3}")
	local launcher_path="${TEST_SRC_DIR}/scripts/launchers/tests/suite/test.sh"
	local cmd_path="${TEST_SUITE_DIR}/test.sh"
	if [[ -f "${cmd_path}" ]]; then
		echo "   - ${msg} test suite: ${TEST_SUITE_NAME} ..."
		local result=0
		"${launcher_path}" "${cmd_path}" "${cmd}" "${args[@]}" || result=$?
		if [[ $result -ne 0 ]]; then
			echo -e "   - ${NORMAL}${RED}✗ ${msg} test suite ${TEST_SUITE_NAME}   : Failed.${NORMAL}"
			return $result
		fi
		echo -e "   - ${NORMAL}${GREEN}✓ ${msg} test suite ${TEST_SUITE_NAME}   : Done.${NORMAL}"
	fi
}

# Runs a global command.
# Commands are actions handled by test.sh located in the TEST_ROOT_DIR directory.
# Arguments:
#   cmd - command/action to run
#   msg - message to display
#   args - additional arguments
function _run_command_for_global() {
	local cmd=$1
	local msg=$2
	local args=("${@:3}")
	local launcher_path="${TEST_SRC_DIR}/scripts/launchers/tests/test.sh"
	local cmd_path="${TEST_ROOT_DIR}/test.sh"
	if [[ -f "${cmd_path}" ]]; then
		echo "   - ${msg} global ..."
		local result=0
		"${launcher_path}" "${cmd_path}" "${cmd}" "${args[@]}" || result=$?
		if [[ $result -ne 0 ]]; then
			echo -e "   - ${NORMAL}${RED}✗ ${msg} global   : Failed.${NORMAL}"
			return $result
		fi
		echo -e "   - ${NORMAL}${GREEN}✓ ${msg} global   : Done.${NORMAL}"
	fi
}

# Runs a command for a specific driver.
# Commands are actions handled by driver.sh located in the drivers/<driver> directory.
# Arguments:
#   driver - driver name
#   action - action to run (prepare, run)
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
	local cmd_path="${TEST_SRC_DIR}/scripts/drivers/${driver}/driver.sh"
	if [[ -f "${cmd_path}" ]]; then
		echo "   - ${msg} test: ${TEST_SUITE_NAME}/${TEST_TEST_NAME} ..."
		local result=0
		"${cmd_path}" "${action}" "${args[@]}" || result=$?
		if [[ $result -ne 0 ]]; then
			echo -e "   - ${NORMAL}${RED}✗ ${msg} test ${TEST_SUITE_NAME}/${TEST_TEST_NAME}   : Failed.${NORMAL}"
			return $result
		fi
		echo -e "   - ${NORMAL}${GREEN}✓ ${msg} test ${TEST_SUITE_NAME}/${TEST_TEST_NAME}   : Done.${NORMAL}"
	fi
}

# Detects the Java version from java command on the user's PATH
# Returns:
#   Java version number (e.g., 8, 11, 17) or empty string if not found
function detectJavaVersion() {
	local java_cmd
	java_cmd=$(which java 2>/dev/null || true)
	if [[ -z "${java_cmd}" ]]; then
		return 1
	fi
	local java_home
	java_home=$(dirname "$(dirname "${java_cmd}")")
	local release_file="${java_home}/release"
	if [[ -f "${release_file}" ]]; then
		local version_line
		version_line=$(grep '^JAVA_VERSION=' "${release_file}" || true)
		if [[ -n "${version_line}" ]]; then
			local version
			version=$(echo "${version_line}" | cut -d'"' -f2 | cut -d'.' -f1)
			echo "${version}"
		fi
	fi
}

# Cleans up empty test output directories to avoid clutter
# Variables used:
#   TEST_OUT_DIR  - test output directory
#   TEST_OUT_BASE - base test output directory
function cleanup() {
    # We clean up empty folders to avoid clutter
	if [[ -v TEST_OUT_DIR && -n "${TEST_OUT_DIR}" ]]; then
        rmdir "${TEST_OUT_DIR}" >/dev/null 2>&1 || true
    fi
	if [[ -v TEST_OUT_BASE && -n "${TEST_OUT_BASE}" ]]; then
        rmdir "${TEST_OUT_BASE}" >/dev/null 2>&1 || true
    fi
    rmdir "./test-results" >/dev/null 2>&1 || true
}

# Handles Ctrl-C signal to clean up running applications and infrastructure
# Needs appfuncs.sh and infrafuncs.sh to be available
function ctrl_c() {
	echo "Caught Ctrl-C, cleaning up..."
	echo "Stopping all running test applications..."
	stop_all_apps
	echo "Stopping all running infrastructure containers..."
	stop_all_containers
	echo "Stopping all running drivers..."
	stop_all_drivers
	echo "Cleaning up test output directories..."
    cleanup
    exit 2
}
