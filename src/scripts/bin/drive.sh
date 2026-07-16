#!/bin/bash

# DESCRIPTION=Run the driver (performance tests) against a running test application.

set -euo pipefail

trap ctrl_c INT

if [[ ! -v TEST_SRC_DIR ]]; then
	echo "ERROR: Please run this script via './run drive ...' from the leyden-perf-test root directory."
	exit 3
fi

if [[ $# -gt 0 && ( "$1" == "-h" || "$1" == "--help" ) || $# -eq 0 ]]; then
	echo "This command runs the driver (performance tests) against a running test application."
	echo "Usage: ./run drive [<options>] <test-suite>/<test-name>"
	echo ""
	echo "Options:"
	echo "  -o, --output <path>    Path to the output folder."
	echo "  -j, --java <version>   Java version used to tag the output folder."
	echo "  -d|--driver <driver>   Test driver to use (default: oha)."
	echo "  -P|--profile <profile> Test profile to use (can be specified multiple times)."
	echo "  -T|--tests-root <path> Path to the test root folder (default: ./tests)."
	echo ""
	echo "This script can be used to manually run the test driver against an already running"
	echo "test application. It is normally run with a <test-suite>/<test-name> argument"
	echo "referring to a single test."
	echo ""
	echo "Run './run list' to see the list of available test suites and tests."
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh
source "${TEST_SRC_DIR}"/scripts/appfuncs.sh
source "${TEST_SRC_DIR}"/scripts/driverfuncs.sh

outputPath="test-results/manual_run"
profiles=()
testsRootDir="${TEST_DIR}/tests"
export TEST_APP_JAVA=""
export TEST_DRIVER="oha"

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
        -d|--driver)
			shift
			if [[ $# -eq 0 ]]; then
				echo "Error: Driver option specified but no value provided."
				exit 4
			fi
			if [[ ! -f "${TEST_SRC_DIR}/scripts/drivers/$1/driver.sh" ]]; then
				echo "Error: Test driver '$1' does not exist."
				echo "Use './run list-drivers' to see the list of available drivers."
				exit 4
			fi
			TEST_DRIVER="$1"
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
		setup_driver
		;;
	prime)
		run_suite_commands "${1:-all}" "Priming ${TEST_DRIVER} test driver for" "driver_prime"
		;;
	run)
		run_suite_commands "${1:-all}" "Running tests using ${TEST_DRIVER} driver for" "driver_run"
		;;
	*)
		echo "ERROR: Second argument must be 'setup', 'prime' or 'run'."
		exit 4
		;;
esac
