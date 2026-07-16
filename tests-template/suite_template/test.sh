
# The test.sh script handles all actions for the test suite.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_SUITE_CACHE, TEST_TEST_NAME, TEST_TEST_DIR
# and TEST_TEST_RUNID.

TESTID=${1:-}

# The app_setup action manages any work that needs to be done to prepare a
# test for execution, again such as cloning repositories and compiling code.
# This action is optional and can be removed if not needed
app_setup() {
    :
}

# The app_start action starts the application to be tested.
# This action is optional and can be removed if not needed.
app_start() {
    :
}

# The app_stop action stops the application that was tested.
# This action is optional and can be removed if not needed.
app_stop() {
    :
}

# The infra_setup action manages any one-time setup work needed for the
# infrastructure used by this test suite, such as pulling container images
# or initializing databases.
# This action is optional and can be removed if not needed.
infra_setup() {
    :
}

# The infra_start action is run to start the infrastructure for each test.
# IMPORTANT: This action should wait and return only when the infrastructure
# is fully started and ready to use!
# This action is optional and can be removed if not needed.
infra_start() {
    :
}

# The infra_stop action is run to stop the infrastructure for each test.
# This action is optional and can be removed if not needed.
infra_stop() {
    :
}

