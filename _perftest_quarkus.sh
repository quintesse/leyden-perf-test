#!/bin/bash
source ./_functions.sh

quarkus_test() {
	do_aot_test_run quarkus quarkus_test_run "${TEST_USE_AOT:-false}"
}

quarkus_test_run() {
	local name=${1:-quarkus}
	do_test_run_with_postgres "${name}" ./spring-quarkus-perf-comparison/quarkus3/target/quarkus-app/quarkus-run.jar perftest_quarkus fruits_db ./spring-quarkus-perf-comparison/scripts/dbdata
}

perftest_quarkus() {
    echo "[TEST] Time to First Request test..."
    oha -n 1 -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/quarkus-test-ttfr.json

    echo "[TEST] Running some warm-up tests..."
    oha -n 10 -u ms --no-tui --urls-from-file urls.txt > /dev/null 2>&1

    sleep 5

    echo "[TEST] Running perf tests..."
    oha -n 10000 -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/quarkus-test.json
}
