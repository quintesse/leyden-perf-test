#!/bin/bash

# DESCRIPTION=Example test strategy script. Put your description here.

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/testfuncs.sh

# Run tests according to your strategy

# ... put your code implement your strategy here ...

# Strategies can use the TEST_STRAT_OPTS varaible to pass Java runtime options
# to the test applications being run. For example:
# export TEST_STRAT_OPTS=-XX:AOTCache=${TEST_OUT_DIR}/${TEST_TEST_RUNID}-app.aot

# The minimalist implementation (as used by the "normal" strategy) is simply:
run_all_tests "$1"
