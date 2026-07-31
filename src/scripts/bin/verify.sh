#!/bin/bash

# DESCRIPTION=Run Bats-based harness verification tests.

set -euo pipefail

bats_root="${TEST_DIR}/verify/bats"
qdup_only=false

# Parse arguments
while [[ $# -gt 0 ]]; do
	case "$1" in
		--qdup)
			qdup_only=true
			shift
			;;
		*)
			echo "Unknown option: $1"
			echo "Usage: ./run verify [--qdup]"
			echo "  --qdup    Run only qDup verification tests"
			exit 1
			;;
	esac
done

run_bats_checks() {
	local pattern="$1"
	local description="$2"
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

	echo "   - Running ${description} from ${bats_root}"
	if (cd "${TEST_DIR}" && "${bats_cmd[@]}" "${bats_root}"/${pattern}); then
		echo -e "   - ${NORMAL}${GREEN}✓ ${description} passed.${NORMAL}"
		return 0
	fi

	echo -e "   - ${NORMAL}${RED}✗ ${description} failed.${NORMAL}"
	return 1
}

if [[ "${qdup_only}" == "true" ]]; then
	echo "Running qDup verification tests only..."
	run_bats_checks "qdup-*.bats" "qDup tests"
else
	echo "Running all verification tests..."
	run_bats_checks "*.bats" "Bats checks"
fi

echo "All verification checks passed."
