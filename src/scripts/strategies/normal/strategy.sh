#!/bin/bash

set -euo pipefail

function _test() {
	local result=0

	_run_commands \
        "infra_setup" \
        "app_setup" \
        "driver_setup" \
        "infra_start/infra_stop" \
        "driver_prime" \
        "app_start/app_stop" \
        "driver_run" -- "${TEST_TEST_RUNID}" || result=$?

	if [[ -f "${TEST_OUT_DIR}/${TEST_TEST_RUNID}-profile.jfr" ]]; then
		# If we have JFR files, process them
		generate_profiling_results "${TEST_TEST_RUNID}"
	fi

	return $result
}

echo "   - Starting test run..."
testpattern=$1
run_for_suite "${testpattern}" "_test"
