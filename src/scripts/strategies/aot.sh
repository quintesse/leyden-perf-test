#!/bin/bash

# DESCRIPTION=First does a training run, then runs tests using the AOT cache

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/testfuncs.sh

if [[ ${TEST_APP_JAVA} -lt 25 ]]; then
	echo "   - Skipping AOT strategy for Java ${TEST_APP_JAVA}."
	exit 1
fi

function prepare_aot_training {
	echo "   - AOT enabled, starting training run ${TEST_TEST_RUNID}..."
	#export TEST_STRAT_OPTS=-XX:AOTCacheOutput=${TEST_OUT_DIR}/${TEST_SUITE_NAME}-${TEST_TEST_NAME}-app.aot
	export TEST_STRAT_OPTS="-XX:AOTCacheOutput=${TEST_OUT_DIR}/${TEST_SUITE_NAME}-${TEST_TEST_NAME}-app.aot -Xlog:aot+map=trace,aot+map+oops=trace:file=${TEST_OUT_DIR}/${TEST_TEST_RUNID}-aot.map:none:filesize=0 -Xlog:aot+resolve*=trace,aot+codecache+exit=debug,aot=warning:file=${TEST_OUT_DIR}/${TEST_TEST_RUNID}.log:level,tags"
}

function prepare_aot_run {
	echo "   - AOT enabled, starting test run ${TEST_TEST_RUNID}..."
	#export TEST_STRAT_OPTS=-XX:AOTCache=${TEST_OUT_DIR}/${TEST_SUITE_NAME}-${TEST_TEST_NAME}-app.aot
	export TEST_STRAT_OPTS="-XX:AOTCache=${TEST_OUT_DIR}/${TEST_SUITE_NAME}-${TEST_TEST_NAME}-app.aot -Xlog:class+load=info,aot+codecache=debug:file=${TEST_OUT_DIR}/${TEST_TEST_RUNID}.log:level,tags"
}

# First we do a training run to create an AOT cache
# We mark all output files with a "training" tag to differentiate them from the real run
run_all_tests "$1" "training" "prepare_aot_training"

# Now run again using the AOT cache
run_all_tests "$1" "" "prepare_aot_run"
