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

if ! command -v oha >/dev/null 2>&1
then
    echo -e "   - ${NORMAL}${RED}✗ oha   : Command not found, please install it, see https://github.com/hatoo/oha${NORMAL}"
else
    echo -e "   - ${NORMAL}${GREEN}✓ oha   : Command is installed.${NORMAL}"
fi

if [[ $# -gt 0 && "$1" == "--clean" ]]; then
	rm -rf "${TEST_APPS_DIR}" > /dev/null || true
	rm -rf "${TEST_BUILDS_DIR}" > /dev/null || true
	echo -e "   - ${NORMAL}${GREEN}✓ Cleaned 'apps' and 'builds' directories${NORMAL}"
	shift
fi

run_command "${1:-all}" "setup" "Setting up"
