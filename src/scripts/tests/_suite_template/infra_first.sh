#!/bin/bash

# The infra_first script is run once before any of the tests in the suite are run.
# The script can write any debug output it wants to the TEST_OUT_DIR directory.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

# IMPORTANT: This script should wait and return only when the infrastructure
# is fully started and ready to use!

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/infrafuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

# Perform any work required before any tests in the suite are run
# This file is optional and can be deleted if not needed
