#!/bin/bash

# DESCRIPTION=List all available test drivers.

set -euo pipefail

if [[ ! -v TEST_SRC_DIR ]]; then
	echo "ERROR: Please run this script via './run list-drivers ...' from the leyden-perf-test root directory."
	exit 3
fi

if [[ $# -gt 0 && ( "$1" == "-h" || "$1" == "--help" ) ]]; then
	echo "This command lists all available test drivers."
	echo "Usage: ./run list-drivers"
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh

echo "All drivers accept the following variables:"
echo " - TEST_DRIVER_RATE_LIMIT env var to set rate limit (requests per second)."
echo " - TEST_PERF_CNT env var to set number of requests."

echo "Available test drivers:"
drivers_dir="${TEST_SRC_DIR}/scripts/drivers"
for driver_dir in "$drivers_dir"/*/; do
	name=$(basename "$driver_dir")
	if [[ "$name" == _* || ! -d "$driver_dir" ]]; then
		continue
	fi
	description=$(read_description "${driver_dir}/DESCRIPTION")
	if [[ -z "${description}" ]]; then
		echo -e "  ${BOLD}$name${NORMAL}"
	else
		echo -e "  ${BOLD}$name :${NORMAL} $description"
	fi
done
