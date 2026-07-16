#!/bin/bash

set -euo pipefail

if [[ ${TEST_APP_JAVA} -lt 25 ]]; then
	echo "   - Skipping AOT strategy for Java ${TEST_APP_JAVA}."
	exit 1
fi

testpattern=$1

function _cmds() {
	_run_commands \
        "infra_setup" \
        "app_setup" \
        "driver_setup" \
        "infra_start/infra_stop" \
        "driver_prime" \
        "app_start/app_stop" \
        "driver_run" -- "${TEST_TEST_RUNID}"
}

function _train() {
	local result=0

	echo "   - AOT enabled, starting training run ${TEST_TEST_RUNID}..."
	export TEST_STRAT_OPTS="-XX:AOTCacheOutput=${TEST_OUT_DIR}/${TEST_SUITE_NAME}-${TEST_TEST_NAME}-app.aot -Xlog:aot+map=trace,aot+map+oops=trace:file=${TEST_OUT_DIR}/${TEST_TEST_RUNID}-aot.map:none:filesize=0 -Xlog:${TEST_LOG_LABEL:-}aot=warning:file=${TEST_OUT_DIR}/${TEST_TEST_RUNID}.log:level,tags"

	_cmds || result=$?

	return $result
}

function _test() {
	local result=0

	echo "   - AOT enabled, starting test run ${TEST_TEST_RUNID}..."
	export TEST_STRAT_OPTS="-XX:AOTMode=on -XX:AOTCache=${TEST_OUT_DIR}/${TEST_SUITE_NAME}-${TEST_TEST_NAME}-app.aot -Xlog:${TEST_LOG_LABEL:-}aot=warning:file=${TEST_OUT_DIR}/${TEST_TEST_RUNID}.log:level,tags"

	_cmds || result=$?

	if [[ -f "${TEST_OUT_DIR}/${TEST_TEST_RUNID}-profile.jfr" ]]; then
		# If we have JFR files, process them
		generate_profiling_results "${TEST_TEST_RUNID}"
	fi

	return $result
}

# First we do a training run to create an AOT cache
# We mark all output files with a "training" tag to differentiate them from the real run
echo "   - Starting training..."
run_for_suite "${testpattern}" "_train" "training"

# Now run again using the AOT cache
echo "   - Starting test run..."
run_for_suite "${testpattern}" "_test" "aot"
