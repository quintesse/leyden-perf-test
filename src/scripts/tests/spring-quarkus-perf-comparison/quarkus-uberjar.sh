#!/bin/bash

source "${TEST_SRC_DIR}"/scripts/functions.sh

quarkus_uberjar_test() {
	do_aot_test_run quarkus-uberjar quarkus_uberjar_test_run "${TEST_USE_AOT:-false}"
}

quarkus_uberjar_test_run() {
	local name=${1:-quarkus-uberjar}
	do_test_run_with_postgres "${name}" "${TEST_BUILDS_DIR}/spring-quarkus-perf-comparison/quarkus3/quarkus3-uberjar/quarkus3-runner.jar" perftest_quarkus_uberjar fruits_db "${TEST_APPS_DIR}/spring-quarkus-perf-comparison/scripts/dbdata"
}

perftest_quarkus_uberjar() {
    echo "[TEST] Time to First Request test..."
    oha -n 1 -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/quarkus-uberjar-test-ttfr.json

    echo "[TEST] Running some warm-up tests..."
    oha -n 10 -u ms --no-tui --urls-from-file urls.txt > /dev/null 2>&1

    sleep 5

    echo "[TEST] Running perf tests..."
    oha -n 10000 -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/quarkus-uberjar-test.json
}
