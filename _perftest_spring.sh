#!/bin/bash

source ./_functions.sh

spring_test() {
	# We need to recompile to clean the AOT version of Spring
	pushd "spring-quarkus-perf-comparison/springboot3"
	./mvnw clean package -DskipTests > /dev/null
	popd
	do_aot_test_run spring spring_test_run "${TEST_USE_AOT:-false}"
}

spring_test_run() {
	local name=${1:-spring}
	do_test_run_with_postgres ${name} ./spring-quarkus-perf-comparison/springboot3/target/*.jar perftest_spring fruits_db ./spring-quarkus-perf-comparison/scripts/dbdata
}

perftest_spring() {
    echo "[TEST] Time to First Request test..."
    oha -n 1 -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/spring-test-ttfr.json

    echo "[TEST] Running some warm-up tests..."
    oha -n 10 -u ms --no-tui --urls-from-file urls.txt > /dev/null 2>&1

    sleep 5

    echo "[TEST] Running perf tests..."
    oha -n 10000 -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/spring-test.json
}
