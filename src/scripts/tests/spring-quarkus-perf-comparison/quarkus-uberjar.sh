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
	rm -f "${TEST_OUT_DIR:-.}"/quarkus-uberjar-test.db
    echo "[TEST] Running perf tests..."
    oha -n "${TEST_PERF_CNT:-10000}" -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/quarkus-uberjar-test.json --db-url "${TEST_OUT_DIR:-.}"/quarkus-uberjar-test.db
}
