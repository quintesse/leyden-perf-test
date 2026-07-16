#!/bin/bash

# DESCRIPTION=Start/stop required infrastructure for the tests.

set -euo pipefail

if [[ ! -v TEST_SRC_DIR ]]; then
	echo "ERROR: Please run this script via './run infra ...' from the leyden-perf-test root directory."
	exit 3
fi

if [[ $# -gt 0 && ( "$1" == "-h" || "$1" == "--help" ) || $# -lt 2 ]]; then
	echo "This command starts/stops the required infrastructure for the tests."
	echo "Usage: ./run infra [<options>] <test-suite>/<test-name> setup|start|stop"
	echo ""
	echo "Options:"
	echo "  -o|--output <path>      Path to the output folder where test results will be stored (default: ./test-results/test-run-<timestamp>)"
	echo "  -P|--profile <profile>  Test profile to use (can be specified multiple times)"
	echo "  -T|--tests-root <path>  Path to the test root folder (default: ./tests)"
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

outputPath="test-results/manual_run"
profiles=()
testsRootDir="${TEST_DIR}/tests"

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
        -T|--tests-root)
			shift
			if [[ $# -eq 0 ]]; then
				echo "Error: Tests root option specified but no path provided."
				exit 4
			fi
			testsRootDir="$1"
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

export TEST_ROOT_DIR="${testsRootDir}"

_setup_test_output_dir "" "${outputPath}"
export TEST_TEST_RUNID

for profile in "${profiles[@]}"; do
	echo "   - Applying profile: ${profile}"
	source "${TEST_DIR}/profiles/${profile}.sh"
done

case "${2:-}" in
	setup)
		run_suite_commands_for_tests "${1:-all}" "Setting up infrastructure for" "infra_setup"
		;;
	start)
		run_suite_commands_for_tests "${1:-all}" "Starting infrastructure for" "infra_start"
		;;
	stop)
		run_suite_commands_for_tests "${1:-all}" "Stopping infrastructure for" "infra_stop"
		;;
	*)
		echo "ERROR: Second argument must be 'setup', 'start' or 'stop'."
		exit 4
		;;
esac
