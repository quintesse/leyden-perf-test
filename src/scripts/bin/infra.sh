#!/bin/bash

# DESCRIPTION=Starts/stops required infrastructure for the tests.

set -euo pipefail

if [[ ! -v TEST_SRC_DIR ]]; then
	echo "ERROR: Please run this script via './run infra ...' from the leyden-perf-test root directory."
	exit 3
fi

if [[ $# -gt 0 && ( "$1" == "-h" || "$1" == "--help" ) || $# -lt 2 ]]; then
	echo "This command starts/stops the required infrastructure for the tests."
	echo "Usage: ./run infra [<options>] <test-suite>/<test-name> start|stop"
	echo ""
	echo "Options:"
	echo "  -t|--tag <tag>               Tag to add to the test results folder name"
	echo "  -o|--output <path>           Path to the output folder where test results will be stored (default: ./test-results/test-run-<timestamp>)"
	echo "  -P|--profile <profile>       Test profile to use (can be specified multiple times)"
	echo ""
	echo "This script can be used to manually start/stop infrastructure, and is normally"
	echo "run with a <test-suite>/<test-name> argument referring to a single test. It is"
	echo "possible to pass 'all' or use wildcards but this honestly does not make much"
	echo "sense, it will just start/stop the infrastructure multiple times."
	echo ""
	echo "Run './run list' to see the list of available test suites and tests."
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh

function run_infra() {
	local testpat=$1
	local action=$2

	local tests=( $(select_tests "${testpat}") )
	export TEST_ROOT_DIR="${TEST_SRC_DIR}/scripts/tests"

	local cursuite=""
	local result=0
	if [[ "${action}" == "start" ]]; then
		local msg="Starting infrastructure for"
		for test in "${tests[@]}"; do
			_set_test_context "${test%%/*}" "${test#*/}"
			if [[ -z "${cursuite}" ]]; then
				_run_command_for_global "infra_first" "${msg}"
			fi
			if [[ "${TEST_SUITE_NAME}" != "${cursuite}" ]]; then
				cursuite="${TEST_SUITE_NAME}"
				result=0
				_run_command_for_suite "infra_first" "${msg}" || result=$?
				[[ $result -ne 0 ]] && continue
			fi
			result=0
			_run_command_for_suite "infra_start" "${msg}" || result=$?
			if [[ $result -eq 0 ]]; then
				_run_command_for_test "infra_start" "${msg}" || result=$?
			fi
		done
	else
		local msg="Stopping infrastructure for"
		for test in "${tests[@]}"; do
			local suitenm="${test%%/*}"
			local testnm="${test#*/}"
			if [[ "${suitenm}" != "${cursuite}" && "${cursuite}" != "" ]]; then
				_set_test_context "${cursuite}"
				_run_command_for_suite "infra_last" "${msg}" || result=$?
			fi
			cursuite="${suitenm}"
			_set_test_context "${suitenm}" "${testnm}"
			_run_command_for_test "infra_stop" "${msg}" || result=$?
			_run_command_for_suite "infra_stop" "${msg}" || result=$?
		done
		if [[ "${cursuite}" != "" ]]; then
			_set_test_context "${cursuite}"
			_run_command_for_suite "infra_last" "${msg}" || result=$?
			_run_command_for_global "infra_last" "${msg}"
		fi
	fi
}

resultTag=""
outputPath=""
profiles=()

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
        -o|--output)
            shift
            if [[ $# -eq 0 ]]; then
                echo "Error: Output option specified but no path provided."
                exit 4
            fi
            outputPath="$1"
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

if [[ ! -v TEST_OUT_DIR || -z "${TEST_OUT_DIR}" ]]; then
	export TEST_OUT_BASE=${outputPath:-./test-results/test-run-$(date +%Y%m%d-%H%M%S)${resultTag:+-$resultTag}}
	mkdir -p "${TEST_OUT_BASE}"
	export TEST_OUT_DIR=${TEST_OUT_BASE}/infra
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
		run_infra "${1:-all}" "start"
		;;
	stop)
		run_infra "${1:-all}" "stop"
		;;
	*)
		echo "ERROR: Second argument must be 'start' or 'stop'."
		exit 4
		;;
esac
