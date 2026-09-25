
# The test.sh script handles all global actions across all test suites.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_SUITE_CACHE, TEST_TEST_NAME, TEST_TEST_DIR
# and TEST_TEST_RUNID.

app_setup() {
    echo "Dummy global app_setup action"
    echo "setup" >> "${TEST_OUT_DIR:-.}/global-app-${TEST_TEST_RUNID}.txt"
}

app_start() {
    echo "Dummy global app_start action"
    echo "start" >> "${TEST_OUT_DIR:-.}/global-app-${TEST_TEST_RUNID}.txt"
}

app_stop() {
    echo "Dummy global app_stop action"
    echo "stop" >> "${TEST_OUT_DIR:-.}/global-app-${TEST_TEST_RUNID}.txt"
}

infra_setup() {
    echo "Dummy global infra_setup action"
    echo "setup" >> "${TEST_OUT_DIR:-.}/global-infra-${TEST_TEST_RUNID}.txt"
}

infra_start() {
    echo "Dummy global infra_start action"
    echo "start" >> "${TEST_OUT_DIR:-.}/global-infra-${TEST_TEST_RUNID}.txt"
}

infra_stop() {
    echo "Dummy global infra_stop action"
    echo "stop" >> "${TEST_OUT_DIR:-.}/global-infra-${TEST_TEST_RUNID}.txt"
}

driver_setup() {
    echo "Dummy global driver_setup action"
    echo "setup" >> "${TEST_OUT_DIR:-.}/global-driver-${TEST_TEST_RUNID}.txt"
}

driver_prime() {
    echo "Dummy global driver_prime action"
    echo "prime" >> "${TEST_OUT_DIR:-.}/global-driver-${TEST_TEST_RUNID}.txt"
}

driver_run() {
    echo "Dummy global driver_run action"
    echo "run" >> "${TEST_OUT_DIR:-.}/global-driver-${TEST_TEST_RUNID}.txt"
}
