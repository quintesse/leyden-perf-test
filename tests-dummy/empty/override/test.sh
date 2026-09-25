
app_setup() {
    echo "Empty test app_setup action"
    echo "setup" >> "${TEST_OUT_DIR:-.}/test-app-${TEST_TEST_RUNID}.txt"
}

app_start() {
    echo "Empty test app_start action"
    echo "start" >> "${TEST_OUT_DIR:-.}/test-app-${TEST_TEST_RUNID}.txt"
}

app_stop() {
    echo "Empty test app_stop action"
    echo "stop" >> "${TEST_OUT_DIR:-.}/test-app-${TEST_TEST_RUNID}.txt"
}

infra_setup() {
    echo "Empty test infra_setup action"
    echo "setup" >> "${TEST_OUT_DIR:-.}/test-infra-${TEST_TEST_RUNID}.txt"
}

infra_start() {
    echo "Empty test infra_start action"
    echo "start" >> "${TEST_OUT_DIR:-.}/test-infra-${TEST_TEST_RUNID}.txt"
}

infra_stop() {
    echo "Empty test infra_stop action"
    echo "stop" >> "${TEST_OUT_DIR:-.}/test-infra-${TEST_TEST_RUNID}.txt"
}

driver_setup() {
    echo "Empty test driver_setup action"
    echo "setup" >> "${TEST_OUT_DIR:-.}/test-driver-${TEST_TEST_RUNID}.txt"
}

driver_prime() {
    echo "Empty test driver_prime action"
    echo "prime" >> "${TEST_OUT_DIR:-.}/test-driver-${TEST_TEST_RUNID}.txt"
}

driver_run() {
    echo "Empty test driver_run action"
    echo "run" >> "${TEST_OUT_DIR:-.}/test-driver-${TEST_TEST_RUNID}.txt"
}
