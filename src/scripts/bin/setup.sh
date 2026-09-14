#!/bin/bash

# DESCRIPTION=Setup the required applications and dependencies for the tests.

set -euo pipefail

if [[ ! -v TEST_SRC_DIR ]]; then
	echo "ERROR: Please run this script via './run setup ...' from the leyden-perf-test root directory."
	exit 3
fi

if [[ $# -gt 0 && ( "$1" == "-h" || "$1" == "--help" ) ]]; then
	echo "This command sets up the required applications and dependencies for the tests."
	echo "Usage: ./run setup [<options>] [<test-suite>/<test-name>]"
	echo ""
	echo "Options:"
	echo "  --clean                      Clean cache directory before setup"
	echo "  -C|--catalog <name>          Name of the tests catalog to use (default: tests)"
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh

cleanCache=false
testsCatalog="tests"

while [[ $# -gt 0 ]]; do
	case "$1" in
		--clean)
			cleanCache=true
			shift
			;;
		-C|--catalog)
			shift
			if [[ $# -eq 0 ]]; then
				echo "Error: Tests catalog option specified but no value provided."
				exit 4
			fi
			testsCatalog="$1"
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

export TEST_CATALOG="${testsCatalog}"
export TEST_ROOT_DIR="${TEST_DIR}/${testsCatalog}"

if [[ "${cleanCache}" == true ]]; then
	rm -rf "${TEST_CACHE_DIR}" > /dev/null || true
	echo -e "   - ${NORMAL}${GREEN}✓ Cleaned 'cache' directory${NORMAL}"
fi

run_suite_commands_for_tests "${1:-all}" "Setting up infrastructure for" "infra_setup"
run_suite_commands_for_tests "${1:-all}" "Setting up application for" "app_setup"
