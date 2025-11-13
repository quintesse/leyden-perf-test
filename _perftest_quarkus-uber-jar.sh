#!/bin/bash
source ./_functions.sh

quarkus_uber_jar_test() {
	# We need to recompile first to build the uber-jar
	pushd "spring-quarkus-perf-comparison/quarkus3"
	./mvnw clean package -Dquarkus.package.jar.type=uber-jar -DskipTests
	popd
	do_aot_test_run quarkus-uber-jar quarkus_uber_jar_test_run "${TEST_USE_AOT:-false}"

}

quarkus_uber_jar_test_run() {
	local name=${1:-quarkus-uber-jar}
	do_test_run_with_postgres "${name}" ./spring-quarkus-perf-comparison/quarkus3/target/quarkus3-runner.jar perftest_quarkus_uber_jar fruits_db ./spring-quarkus-perf-comparison/scripts/dbdata
}

perftest_quarkus_uber_jar() {
    echo "[TEST] Time to First Request test..."
    oha -n 1 -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/quarkus-uber-jar-test-ttfr.json

    echo "[TEST] Running some warm-up tests..."
    oha -n 10 -u ms --no-tui --urls-from-file urls.txt > /dev/null 2>&1

    sleep 5

    echo "[TEST] Running perf tests..."
    oha -n 10000 -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/quarkus-uber-jar-test.json
}
