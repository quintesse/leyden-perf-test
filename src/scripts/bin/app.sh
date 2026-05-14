#!/bin/bash

# DESCRIPTION=Starts/stops a test application.

set -euo pipefail

trap ctrl_c INT

if [[ ! -v TEST_SRC_DIR ]]; then
	echo "ERROR: Please run this script via './run app ...' from the leyden-perf-test root directory."
	exit 3
fi

if [[ $# -gt 0 && ( "$1" == "-h" || "$1" == "--help" ) || $# -eq 0 ]]; then
	echo "This command starts/stops a test application."
	echo "Usage: ./run app [<options>] <test-suite>/<test-name> start|stop"
	echo ""
	echo "Options:"
	echo "  -o, --output <path>    Path to the output folder."
	echo "  -j, --java <version>   Java version to use for the test application."
	echo "  -P|--profile <profile> Test profile to use (can be specified multiple times)"
	echo ""
	echo "This script can be used to manually start/stop a test application, and is normally"
	echo "run with a <test-suite>/<test-name> argument referring to a single test. It is"
	echo "possible to pass 'all' or use wildcards but this means multiple applications may be"
	echo "started/stopped which might not even be possible (e.g. if they use the same ports)."
	echo ""
	echo "Run './run list' to see the list of available test suites and tests."
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh
source "${TEST_SRC_DIR}"/scripts/appfuncs.sh
source "${TEST_SRC_DIR}"/scripts/infrafuncs.sh

function run_app() {
	local testpat=$1
	local action=$2

	local tests=( $(select_tests "${testpat}") )
	export TEST_ROOT_DIR="${TEST_SRC_DIR}/scripts/tests"

	local cursuite=""
	local curtest=""
	local result=0
	if [[ "${action}" == "start" ]]; then
		local msg="Starting application for"
		for test in "${tests[@]}"; do
			local suitenm="${test%%/*}"
			local testnm="${test#*/}"
			_set_test_context "${suitenm}" "${testnm}"
			result=0
			if [[ "${TEST_SUITE_NAME}" != "${cursuite}" ]]; then
				cursuite="${TEST_SUITE_NAME}"
				_run_command_for_suite "app_start" "${msg}" "${TEST_TEST_RUNID}" || result=$?
				[[ $result -ne 0 ]] && continue
			fi
			_run_command_for_test "app_start" "${msg}" "${TEST_TEST_RUNID}" || result=$?
		done
	else
		local msg="Stopping application for"
		for test in "${tests[@]}"; do
			local suitenm="${test%%/*}"
			local testnm="${test#*/}"
			if [[ "${suitenm}" != "${cursuite}" && "${cursuite}" != "" ]]; then
				_set_test_context "${cursuite}" "${curtest}"
				_run_command_for_suite "app_stop" "${msg}" "${TEST_TEST_RUNID}" || result=$?
			fi
			cursuite="${suitenm}"
			curtest="${testnm}"
			_set_test_context "${suitenm}" "${testnm}"
			_run_command_for_test "app_stop" "${msg}" "${TEST_TEST_RUNID}" || result=$?
		done
		if [[ "${cursuite}" != "" ]]; then
			_set_test_context "${cursuite}" "${curtest}"
			_run_command_for_suite "app_stop" "${msg}" "${TEST_TEST_RUNID}" || result=$?
		fi
	fi
	return $result
}

outputPath="test-results/manual_run"
profiles=()
export TEST_APP_JAVA=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -o|--output)
            shift
            if [[ $# -eq 0 ]]; then
                echo "Error: Output option specified but no path provided."
                exit 4
            fi
            outputPath="$1"
            shift
            ;;
        -j|--java)
            shift
			if [[ $# -eq 0 ]]; then
				echo "Error: Java version option specified but no version value provided."
				exit 4
			fi
			TEST_APP_JAVA="$1"
			shift
			;;
        -P|--profile)
			shift
			if [[ $# -eq 0 ]]; then
				echo "Error: Profile option specified but no value provided."
				exit 4
			fi
			if [[ -f "${TEST_DIR}/profiles/$1.sh" ]]; then
				profiles+=("$1")
			else
				echo "Error: Profile '$1' does not exist."
				echo "Use './run list-profiles' to see the list of available profiles."
				exit 4
			fi
			shift
			;;
        -*)
            echo "Error: Unknown option: $1"
			exit 4
            ;;
        *)
            break
            ;;
    esac
done

javaVersion="${TEST_APP_JAVA:-Unknown}"

_setup_test_output_dir "" "${outputPath}"
export TEST_TEST_RUNID

for profile in "${profiles[@]}"; do
	echo "   - Applying profile: ${profile}"
	source "${TEST_DIR}/profiles/${profile}.sh"
done

case "${2:-}" in
	start)
		run_app "${1:-all}" "start"
		;;
	stop)
		run_app "${1:-all}" "stop"
		;;
	*)
		echo "ERROR: Second argument must be 'start' or 'stop'."
		exit 4
		;;
esac
