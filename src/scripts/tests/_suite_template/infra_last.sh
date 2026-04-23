#!/bin/bash

# The infra_last script is run once after all tests in the suite have run.
# The script can write any debug output it wants to the TEST_OUT_DIR directory.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/infrafuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

# Perform any work required after all tests in the suite have run
# This file is optional and can be deleted if not needed
