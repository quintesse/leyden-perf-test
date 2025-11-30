#!/bin/bash

# DESCRIPTION=List all available test profiles.

set -euo pipefail

if [[ ! -v TEST_SRC_DIR ]]; then
	echo "ERROR: Please run this script via './run list-profiles ...' from the leyden-perf-test root directory."
	exit 3
fi

if [[ $# -gt 0 && ( "$1" == "-h" || "$1" == "--help" ) ]]; then
	echo "This command lists all available test profiles."
	echo "Usage: ./run list-profiles"
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh

echo "Available test profiles:"
profiles_dir="${TEST_DIR}/profiles"
for profile_script in "$profiles_dir"/*.sh; do
	name=$(basename "$profile_script" .sh)
	if [[ "$name" == _* || ! -f "$profile_script" ]]; then
		continue
	fi
	description=$( (grep -m 1 '^# DESCRIPTION=' "$profile_script" || true) | cut -d'=' -f2-)
	if [[ -z "${description}" ]]; then
		echo -e "  ${BOLD}$name${NORMAL}"
	else
		echo -e "  ${BOLD}$name :${NORMAL} $description"
	fi
done
