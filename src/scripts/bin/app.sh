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
	echo "  -t|--tag <tag>         Tag to add to the test results folder name"
	echo "  --jdk-tag <tag>        Tag to add to the JDK folder name."
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
	local result=0
	if [[ "${action}" == "start" ]]; then
		local msg="Starting application for"
		for test in "${tests[@]}"; do
			_set_test_context "${test%%/*}" "${test#*/}"
			if [[ -z "${cursuite}" ]]; then
				_run_command_for_global "app_start" "${msg}"
			fi
			if [[ "${TEST_SUITE_NAME}" != "${cursuite}" ]]; then
				cursuite="${TEST_SUITE_NAME}"
				result=0
				_run_command_for_suite "app_start" "${msg}" || result=$?
				[[ $result -ne 0 ]] && continue
			fi
			result=0
			_run_command_for_test "app_start" "${msg}" || result=$?
		done
	else
		local msg="Stopping application for"
		for test in "${tests[@]}"; do
			local suitenm="${test%%/*}"
			local testnm="${test#*/}"
			if [[ "${suitenm}" != "${cursuite}" && "${cursuite}" != "" ]]; then
				_set_test_context "${cursuite}"
				_run_command_for_suite "app_stop" "${msg}" || result=$?
			fi
			cursuite="${suitenm}"
			_set_test_context "${suitenm}" "${testnm}"
			_run_command_for_test "app_stop" "${msg}" || result=$?
		done
		if [[ "${cursuite}" != "" ]]; then
			_set_test_context "${cursuite}"
			_run_command_for_suite "app_stop" "${msg}" || result=$?
			_run_command_for_global "app_stop" "${msg}"
		fi
	fi
}

resultTag=""
jdkTag=""
outputPath=""
profiles=()
export TEST_APP_JAVA=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--tag)
            shift
            if [[ $# -eq 0 ]]; then
                echo "Error: Tag option specified but no tag value provided."
                exit 4
            fi
            resultTag="$1"
            shift
            ;;
        --jdk-tag)
            shift
            if [[ $# -eq 0 ]]; then
                echo "Error: Tag option specified but no tag value provided."
                exit 4
            fi
            jdkTag="$1"
            shift
            ;;
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
        *)
            break
            ;;
    esac
done

javaVersion="${TEST_APP_JAVA:-Unknown}"

if [[ ! -v TEST_OUT_DIR || -z "${TEST_OUT_DIR}" ]]; then
	export TEST_OUT_BASE=${outputPath:-./test-results/test-run-$(date +%Y%m%d-%H%M%S)${resultTag:+-$resultTag}}
	mkdir -p "${TEST_OUT_BASE}"
	export TEST_OUT_DIR=${TEST_OUT_BASE}/j${javaVersion}${jdkTag:+-$jdkTag}
	mkdir -p "${TEST_OUT_DIR}"
	echo "   - Created test output folder ${TEST_OUT_DIR}"
fi
export TEST_TEST_RUNID

for profile in "${profiles[@]}"; do
	echo "   - Applying profile: ${profile}"
	source "${TEST_DIR}/profiles/${profile}.sh"
done

case "$2" in
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
