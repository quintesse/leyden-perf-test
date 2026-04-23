#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/testfuncs.sh

echo "   - Starting test run..."
run_all_tests "$1"
