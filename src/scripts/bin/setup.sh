#!/bin/bash

# DESCRIPTION=Setup the required applications and dependencies for the tests.

set -euo pipefail

if [[ ! -v TEST_SRC_DIR ]]; then
	echo "ERROR: Please run this script via './run setup ...' from the leyden-perf-test root directory."
	exit 3
fi

if [[ $# -gt 0 && ( "$1" == "-h" || "$1" == "--help" ) ]]; then
	echo "This command sets up the required applications and dependencies for the tests."
	echo "Usage: ./run setup [<test-suite>/<test-name>]"
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh

if [[ $# -gt 0 && "$1" == "--clean" ]]; then
	rm -rf "${TEST_CACHE_DIR}" > /dev/null || true
	echo -e "   - ${NORMAL}${GREEN}✓ Cleaned 'cache' directory${NORMAL}"
	shift
fi

run_suite_start_commands "${1:-all}" "Setting up infrastructure for" "infra_setup" "" "infra_setup"
run_suite_start_commands "${1:-all}" "Setting up application for" "app_setup" "" "app_setup"
