#!/bin/bash

# DESCRIPTION=Performs a normal (non-AOT) test run

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/testfuncs.sh

echo "   - Starting test run..."
run_all_tests "$1"
