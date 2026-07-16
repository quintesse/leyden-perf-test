#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/testfuncs.sh

# Run tests according to your strategy

# ... put your code implement your strategy here ...

# Strategies can use the TEST_STRAT_OPTS varaible to pass Java runtime options
# to the test applications being run. For example:
# export TEST_STRAT_OPTS=-XX:AOTCache=${TEST_OUT_DIR}/${TEST_TEST_RUNID}-app.aot

# The minimalist implementation (as used by the "normal" strategy) is simply:

# The tests to run is passed as the first parameter
testpattern=$1

# This is the function that will be run for each test in the suite.
# It should do all the setup, execution, and teardown necessary for the test.
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

	return $result
}

# This is the toplevel part of the strategy.
# It runs all tests matching the given pattern using the _test function defined above.
echo "   - Starting test run..."
run_for_suite "${testpattern}" "_test"
