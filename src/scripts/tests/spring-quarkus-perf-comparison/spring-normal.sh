#!/bin/bash

source "${TEST_SRC_DIR}"/scripts/functions.sh

spring_test() {
	do_aot_test_run spring spring_test_run "${TEST_USE_AOT:-false}"
}

spring_test_run() {
	local name=${1:-spring}
	do_test_run_with_postgres "${name}" "${TEST_BUILDS_DIR}/spring-quarkus-perf-comparison/springboot3/spring-normal/application/springboot3.jar" perftest_spring fruits_db "${TEST_APPS_DIR}/spring-quarkus-perf-comparison/scripts/dbdata"
}

perftest_spring() {
    echo "[TEST] Time to First Request test..."
    oha -n 100 -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/spring-test-ttfr.json --db-url "${TEST_OUT_DIR:-.}"/spring-test-ttfr.db

    echo "[TEST] Running some warm-up tests..."
    oha -n 100 -u ms --no-tui --urls-from-file urls.txt > /dev/null 2>&1

    sleep 5

    echo "[TEST] Running perf tests..."
    oha -n 10000 -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/spring-test.json --db-url "${TEST_OUT_DIR:-.}"/spring-test.db
}
