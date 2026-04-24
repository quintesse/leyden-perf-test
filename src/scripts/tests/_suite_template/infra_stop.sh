
# The infra_stop script is run to stop the infrastructure for each test.
# The script can write any debug output it wants to the TEST_OUT_DIR directory.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

# Perform any work required to stop the infrastructure for each test
# This file is optional and can be deleted if not needed
TESTID=$1
