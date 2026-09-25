
app_setup() {
    echo "Dummy test app_setup action"
    echo "setup" >> "${TEST_OUT_DIR:-.}/test-app-${TEST_TEST_RUNID}.txt"
}

app_start() {
    echo "Dummy test app_start action"
    echo "start" >> "${TEST_OUT_DIR:-.}/test-app-${TEST_TEST_RUNID}.txt"
}

app_stop() {
    echo "Dummy test app_stop action"
    echo "stop" >> "${TEST_OUT_DIR:-.}/test-app-${TEST_TEST_RUNID}.txt"
}

infra_setup() {
    echo "Dummy test infra_setup action"
    echo "setup" >> "${TEST_OUT_DIR:-.}/test-infra-${TEST_TEST_RUNID}.txt"
}

infra_start() {
    echo "Dummy test infra_start action"
    echo "start" >> "${TEST_OUT_DIR:-.}/test-infra-${TEST_TEST_RUNID}.txt"
}

infra_stop() {
    echo "Dummy test infra_stop action"
    echo "stop" >> "${TEST_OUT_DIR:-.}/test-infra-${TEST_TEST_RUNID}.txt"
}

driver_setup() {
    echo "Dummy test driver_setup action"
    echo "setup" >> "${TEST_OUT_DIR:-.}/test-driver-${TEST_TEST_RUNID}.txt"
    if [[ "${TEST_DRIVER}" == "dummy" ]]; then
        setup_driver
    fi
}

driver_prime() {
    echo "Dummy test driver_prime action"
    echo "prime" >> "${TEST_OUT_DIR:-.}/test-driver-${TEST_TEST_RUNID}.txt"
    if [[ "${TEST_DRIVER}" == "dummy" ]]; then
        prime_driver
    fi
}

driver_run() {
    echo "Dummy test driver_run action"
    echo "run" >> "${TEST_OUT_DIR:-.}/test-driver-${TEST_TEST_RUNID}.txt"
    if [[ "${TEST_DRIVER}" == "dummy" ]]; then
        run_driver
    fi
}
