
app_setup() {
    echo "Dummy suite app_setup action"
    echo "setup" >> "${TEST_OUT_DIR:-.}/suite-app-${TEST_TEST_RUNID}.txt"
}

app_start() {
    echo "Dummy suite app_start action"
    echo "start" >> "${TEST_OUT_DIR:-.}/suite-app-${TEST_TEST_RUNID}.txt"
}

app_stop() {
    echo "Dummy suite app_stop action"
    echo "stop" >> "${TEST_OUT_DIR:-.}/suite-app-${TEST_TEST_RUNID}.txt"
}

infra_setup() {
    echo "Dummy suite infra_setup action"
    echo "setup" >> "${TEST_OUT_DIR:-.}/suite-infra-${TEST_TEST_RUNID}.txt"
}

infra_start() {
    echo "Dummy suite infra_start action"
    echo "start" >> "${TEST_OUT_DIR:-.}/suite-infra-${TEST_TEST_RUNID}.txt"
}

infra_stop() {
    echo "Dummy suite infra_stop action"
    echo "stop" >> "${TEST_OUT_DIR:-.}/suite-infra-${TEST_TEST_RUNID}.txt"
}

driver_setup() {
    echo "Dummy suite driver_setup action"
    echo "setup" >> "${TEST_OUT_DIR:-.}/suite-driver-${TEST_TEST_RUNID}.txt"
}

driver_prime() {
    echo "Dummy suite driver_prime action"
    echo "prime" >> "${TEST_OUT_DIR:-.}/suite-driver-${TEST_TEST_RUNID}.txt"
}

driver_run() {
    echo "Dummy suite driver_run action"
    echo "run" >> "${TEST_OUT_DIR:-.}/suite-driver-${TEST_TEST_RUNID}.txt"
}
