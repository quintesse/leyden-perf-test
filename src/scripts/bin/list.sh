#!/bin/bash

# DESCRIPTION=List all available tests suites and tests.

set -euo pipefail

if [[ ! -v TEST_SRC_DIR ]]; then
	echo "ERROR: Please run this script via './run list ...' from the leyden-perf-test root directory."
	exit 3
fi

if [[ $# -gt 0 && ( "$1" == "-h" || "$1" == "--help" ) ]]; then
	echo "This command lists all available test suites and tests."
	echo "Usage: ./run list [<pattern>]"
	echo "  If a pattern is provided, only tests matching the pattern are listed."
	echo "  The pattern can be in the form of 'suite/*' to list all tests in a suite,"
	echo "  or 'suite/test' to list a specific test. Partial matches are supported."
	echo "  Use 'all' as a wildcard to match all suites or tests."
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh

if [[ $# -gt 0 ]]; then
	tests=$(select_tests "$1")
	if [[ -z "${tests}" ]]; then
		echo "No tests match the pattern '$1'."
		exit 1
	fi
	echo "Selected tests:"
	for test in $tests; do
		suitenm=${test%%/*}
		testnm=${test#*/}
		description=$(read_test_description "$suitenm" "$testnm")
		if [[ -z "${description}" ]]; then
			echo -e "    ${BOLD}$test${NORMAL}"
		else
			echo -e "    ${BOLD}$test :${NORMAL} $description"
		fi
	done
	exit 0
fi

echo "Available test suites and tests:"
suites=$(list_test_suites)
for suite in $suites; do
	if [[ "$suite" == "_"* ]]; then
		continue
	fi
	description=$(read_test_description "$suite")
	if [[ -z "${description}" ]]; then
			echo -e "${BOLD}$suite${NORMAL}"
		else
			echo -e "${BOLD}$suite :${NORMAL} $description"
	fi
	tests=$(list_tests_in_suite "$suite")
	for test in $tests; do
		description=$(read_test_description "$suite" "$test")
		if [[ -z "${description}" ]]; then
			echo -e "    ${BOLD}$suite/$test${NORMAL}"
		else
			echo -e "    ${BOLD}$suite/$test :${NORMAL} $description"
		fi
	done
done
