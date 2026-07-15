
# The test.sh script handles all actions for the test.
# Actions are dispatched by scripts/launcher.sh. Positional args start with TESTID.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_SUITE_CACHE, TEST_TEST_NAME, TEST_TEST_DIR,
# TEST_TEST_CACHE and TEST_TEST_RUNID.


TESTID=${1:-}

# The app_setup action manages any work that needs to be done to prepare the
# application being tested for execution, such as compiling the code.
# This action is optional and can be removed if not needed
app_setup() {
    # Put your setup code here
    echo "Compiling example_test..."
}

# The app_start action starts the application to be tested.
# This action is optional and can be removed if not needed.
app_start() {
    # Typical implementation:
    #start_app "${TESTID}" "path/to/your/app.jar"
    :
}

# The app_stop action stops the application that was tested.
# This action is optional and can be removed if not needed.
app_stop() {
    # Typical implementation:
    stop_app "${TESTID}"
}

# The infra_setup action manages any one-time setup work needed for the
# infrastructure used by this test, such as pulling container images
# or initializing databases.
# This action is optional and can be removed if not needed.
infra_setup() {
    :
}

# The infra_start action starts any infrastructure services required by the application.
# IMPORTANT: This action should wait and return only when the infrastructure
# is fully started and ready to use!
# This action is optional and can be removed if not needed.
infra_start() {
    :
}

# The infra_stop action stops any infrastructure services required by the application.
# This action is optional and can be removed if not needed.
infra_stop() {
    :
}

