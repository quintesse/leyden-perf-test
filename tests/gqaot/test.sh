
# The test.sh script handles all actions for the test suite.
# Actions are dispatched by scripts/launcher.sh. Positional args start with TESTID.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR.


TESTID=${1:-}

app_stop() {
    stop_app "${TESTID}"
}

