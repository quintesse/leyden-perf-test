
# The test.sh script handles all actions for the test suite.
# Actions are dispatched by scripts/launcher.sh. Positional args start with TESTID.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_SUITE_CACHE, TEST_TEST_NAME, TEST_TEST_DIR
# and TEST_TEST_RUNID.


TESTID=${1:-}

app_setup() {
    echo "Dummy suite app_setup action"
}

app_start() {
    echo "Dummy suite app_start action"
}

app_stop() {
    echo "Dummy suite app_stop action"
}

infra_setup() {
    echo "Dummy suite infra_setup action"
}

infra_start() {
    echo "Dummy suite infra_start action"
}

infra_stop() {
    echo "Dummy suite infra_stop action"
}

