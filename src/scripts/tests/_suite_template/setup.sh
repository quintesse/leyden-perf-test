#!/bin/bash

# The setup script manages any work that needs to be done to prepare the
# test suite for execution, such as cloning repositories and compiling code.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR.

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/buildfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

# Put your setup code here
echo "Cloning and compiling code for example test suite..."
