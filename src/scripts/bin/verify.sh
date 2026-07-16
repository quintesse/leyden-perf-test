#!/bin/bash

# DESCRIPTION=Run Bats-based harness verification tests.

set -euo pipefail

bats_root="${TEST_DIR}/verify/bats"

run_bats_checks() {
	local bats_cmd=()

	if [[ ! -d "${bats_root}" ]]; then
		echo "No Bats checks found at ${bats_root}."
		return 0
	fi

	if [[ -f "${TEST_DIR}/bats" ]]; then
		bats_cmd=("bash" "${TEST_DIR}/bats")
	elif command -v bats >/dev/null 2>&1; then
		bats_cmd=("bats")
	else
		echo "Skipping Bats checks: bats command not found."
		echo "Use ${TEST_DIR}/bats to bootstrap a local bats installation."
		return 0
	fi

	echo "   - Running Bats checks from ${bats_root}"
	if (cd "${TEST_DIR}" && "${bats_cmd[@]}" "${bats_root}"); then
		echo -e "   - ${NORMAL}${GREEN}✓ Bats checks passed.${NORMAL}"
		return 0
	fi

	echo -e "   - ${NORMAL}${RED}✗ Bats checks failed.${NORMAL}"
	return 1
}

run_bats_checks

echo "All verification checks passed."
