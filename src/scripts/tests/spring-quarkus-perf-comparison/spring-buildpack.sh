#!/bin/bash

source "${TEST_SRC_DIR}"/scripts/functions.sh

spring_buildpack_test() {
	do_aot_test_run spring-buildpack spring_buildpack_test_run "${TEST_USE_AOT:-false}"

}

spring_buildpack_test_run() {
	local name=${1:-spring-buildpack}
	TEST_JAVA_OPTS="${TEST_JAVA_OPTS} -Dspring.aot.enabled=true" do_test_run_with_postgres "${name}" "${TEST_BUILDS_DIR}/spring-quarkus-perf-comparison/springboot3/spring-buildpack/application/springboot3.jar" perftest_spring_buildpack fruits_db "${TEST_APPS_DIR}/spring-quarkus-perf-comparison/scripts/dbdata"
}

perftest_spring_buildpack() {
    echo "[TEST] Time to First Request test..."
    oha -n "${TEST_TTFR_CNT:-100}" -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/spring-buildpack-test-ttfr.json --db-url "${TEST_OUT_DIR:-.}"/spring-buildpack-test-ttfr.db

    echo "[TEST] Running some warm-up tests..."
    oha -n "${TEST_WARMUP_CNT:-100}" -u ms --no-tui --urls-from-file urls.txt > /dev/null 2>&1

    sleep 5

    echo "[TEST] Running perf tests..."
    oha -n "${TEST_PERF_CNT:-10000}" -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/spring-buildpack-test.json --db-url "${TEST_OUT_DIR:-.}"/spring-buildpack-test.db
}
