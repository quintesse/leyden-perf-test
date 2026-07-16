#!/bin/bash

# DESCRIPTION=Run harness self-check scripts.

set -euo pipefail

checks_root="${TEST_DIR}/harness-checks"

if [[ ! -d "${checks_root}" ]]; then
	echo "No harness checks found at ${checks_root}."
	exit 0
fi

shopt -s nullglob
checks=("${checks_root}"/*/check.sh)

if [[ ${#checks[@]} -eq 0 ]]; then
	echo "No harness check scripts found under ${checks_root}."
	exit 0
fi

failures=0
for check in "${checks[@]}"; do
	check_name=$(basename "$(dirname "${check}")")
	echo "   - Running harness check: ${check_name}"
	if "${check}"; then
		echo -e "   - ${NORMAL}${GREEN}✓ Harness check ${check_name}: Passed.${NORMAL}"
	else
		failures=$((failures + 1))
		echo -e "   - ${NORMAL}${RED}✗ Harness check ${check_name}: Failed.${NORMAL}"
	fi
done

if [[ ${failures} -gt 0 ]]; then
	echo "${failures} harness check(s) failed."
	exit 1
fi

echo "All harness checks passed."
