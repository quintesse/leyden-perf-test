
# The test.sh script handles all global actions across all test suites.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_SUITE_CACHE, TEST_TEST_NAME, TEST_TEST_DIR
# and TEST_TEST_RUNID.

TESTID=${1:-}

app_setup() {
    :
}

app_start() {
    :
}

app_stop() {
    :
}

infra_setup() {
    :
}

infra_start() {
    :
}

infra_stop() {
    :
}

driver_setup() {
    # Default implementation
    setup_driver
}

driver_prime() {
    # Default implementation
    prime_driver
}

driver_run() {
    # Default implementation
    run_driver
}
