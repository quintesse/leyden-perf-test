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
for strategy_dir in "$strategies_dir"/*/; do
	name=$(basename "$strategy_dir")
	if [[ "$name" == _* || ! -d "$strategy_dir" ]]; then
		continue
	fi
	description=$(read_description "${strategy_dir}/DESCRIPTION")
	if [[ -z "${description}" ]]; then
		echo -e "  ${BOLD}$name${NORMAL}"
	else
		echo -e "  ${BOLD}$name :${NORMAL} $description"
	fi
done
