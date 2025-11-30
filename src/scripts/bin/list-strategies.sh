#!/bin/bash

# DESCRIPTION=List all available tests suites and tests.

set -euo pipefail

if [[ ! -v TEST_SRC_DIR ]]; then
	echo "ERROR: Please run this script via './run list-strategies ...' from the leyden-perf-test root directory."
	exit 3
fi

if [[ $# -gt 0 && ( "$1" == "-h" || "$1" == "--help" ) ]]; then
	echo "This command lists all available test strategies."
	echo "Usage: ./run list-strategies"
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh

echo "Available test strategies:"
strategies_dir="${TEST_SRC_DIR}/scripts/strategies"
for strategy_script in "$strategies_dir"/*.sh; do
	name=$(basename "$strategy_script" .sh)
	if [[ "$name" == _* || ! -f "$strategy_script" ]]; then
		continue
	fi
	description=$( (grep -m 1 '^# DESCRIPTION=' "$strategy_script" || true) | cut -d'=' -f2-)
	if [[ -z "${description}" ]]; then
		echo -e "  ${BOLD}$name${NORMAL}"
	else
		echo -e "  ${BOLD}$name :${NORMAL} $description"
	fi
done
