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
	local curtest=""
	local result=0
	if [[ "${action}" == "start" ]]; then
		local msg="Starting infrastructure for"
		for test in "${tests[@]}"; do
			local suitenm="${test%%/*}"
			local testnm="${test#*/}"
			_set_test_context "${suitenm}" "${testnm}"
			result=0
			if [[ "${TEST_SUITE_NAME}" != "${cursuite}" ]]; then
				cursuite="${TEST_SUITE_NAME}"
				_run_command_for_suite "infra_first" "${msg}" "${testnm}" || result=$?
				[[ $result -ne 0 ]] && continue
			fi
			_run_command_for_suite "infra_start" "${msg}" "${testnm}" || result=$?
			[[ $result -ne 0 ]] && continue
			_run_command_for_test "infra_start" "${msg}" "${testnm}" || result=$?
		done
	else
		local msg="Stopping infrastructure for"
		for test in "${tests[@]}"; do
			local suitenm="${test%%/*}"
			local testnm="${test#*/}"
			if [[ "${suitenm}" != "${cursuite}" && "${cursuite}" != "" ]]; then
				_set_test_context "${cursuite}" "${curtest}"
				_run_command_for_suite "infra_last" "${msg}" "${curtest}" || result=$?
			fi
			cursuite="${suitenm}"
			curtest="${testnm}"
			_set_test_context "${suitenm}" "${testnm}"
			_run_command_for_test "infra_stop" "${msg}" "${testnm}" || result=$?
			_run_command_for_suite "infra_start" "${msg}" "${testnm}" || result=$?
		done
		if [[ "${cursuite}" != "" ]]; then
			_set_test_context "${cursuite}" "${curtest}"
			_run_command_for_suite "infra_last" "${msg}" "${curtest}" || result=$?
		fi
	fi
	return $result
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
        -*)
            echo "Error: Unknown option: $1"
			exit 4
            ;;
        *)
            break
            ;;
    esac
done

_setup_test_output_dir "infra" "${outputPath}" "${resultTag}"
export TEST_TEST_RUNID

for profile in "${profiles[@]}"; do
	echo "   - Applying profile: ${profile}"
	source "${TEST_DIR}/profiles/${profile}.sh"
done

case "${2:-}" in
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
