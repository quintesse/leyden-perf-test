
# The test.sh script handles all global actions across all test suites.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_SUITE_CACHE, TEST_TEST_NAME, TEST_TEST_DIR
# and TEST_TEST_RUNID.

TESTID=${1:-}

app_setup() {
    echo "Dummy global app_setup action"
}

app_start() {
    echo "Dummy global app_start action"
}

app_stop() {
    echo "Dummy global app_stop action"
}

infra_setup() {
    echo "Dummy global infra_setup action"
}

infra_start() {
    echo "Dummy global infra_start action"
}

infra_stop() {
    echo "Dummy global infra_stop action"
}

driver_setup() {
    echo "Dummy global driver_setup action"
}

driver_prime() {
    echo "Dummy global driver_prime action"
}

driver_run() {
    echo "Dummy global driver_run action"
}
