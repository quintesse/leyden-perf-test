#!/bin/bash

source "${TEST_SRC_DIR}"/scripts/functions.sh

quarkus_test() {
	do_aot_test_run quarkus quarkus_test_run "${TEST_USE_AOT:-false}"
}

quarkus_test_run() {
	local name=${1:-quarkus}
	do_test_run_with_postgres "${name}" "${TEST_BUILDS_DIR}/spring-quarkus-perf-comparison/quarkus3/quarkus3-normal/quarkus-app/quarkus-run.jar" perftest_quarkus fruits_db "${TEST_APPS_DIR}/spring-quarkus-perf-comparison/scripts/dbdata"
}

perftest_quarkus() {
    echo "[TEST] Time to First Request test..."
    oha -n 100 -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/quarkus-test-ttfr.json --db-url "${TEST_OUT_DIR:-.}"/quarkus-test-ttfr.db

    echo "[TEST] Running some warm-up tests..."
    oha -n 100 -u ms --no-tui --urls-from-file urls.txt > /dev/null 2>&1

    sleep 5

    echo "[TEST] Running perf tests..."
    oha -n 10000 -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/quarkus-test.json --db-url "${TEST_OUT_DIR:-.}"/quarkus-test.db
}
