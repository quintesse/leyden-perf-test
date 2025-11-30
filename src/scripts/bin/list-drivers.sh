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

echo "Available test drivers:"
drivers_dir="${TEST_SRC_DIR}/scripts/drivers"
for driver_script in "$drivers_dir"/*.sh; do
	name=$(basename "$driver_script" .sh)
	if [[ "$name" == _* || ! -f "$driver_script" ]]; then
		continue
	fi
	description=$( (grep -m 1 '^# DESCRIPTION=' "$driver_script" || true) | cut -d'=' -f2-)
	if [[ -z "${description}" ]]; then
		echo -e "  ${BOLD}$name${NORMAL}"
	else
		echo -e "  ${BOLD}$name :${NORMAL} $description"
	fi
done
