#!/bin/bash
source ./_functions.sh

spring_buildpack_executable_test() {
	# Prepare for AOT cache and production environment
	# As described in https://docs.spring.io/spring-boot/reference/packaging/efficient.html
	# and in https://docs.spring.io/spring-boot/reference/packaging/aot.html
	pushd "spring-quarkus-perf-comparison/springboot3"
	./mvnw clean  -Pnative package -DskipTests > /dev/null
	java -Djarmode=tools -jar target/springboot3.jar extract --destination target/application > /dev/null
	popd
	do_aot_test_run spring-buildpack-executable spring_buildpack_executable_test_run "${TEST_USE_AOT:-false}"

}

spring_buildpack_executable_test_run() {
	local name=${1:-spring-buildpack-executable}
	TEST_JAVA_OPTS="${TEST_JAVA_OPTS} -Dspring.aot.enabled=true" do_test_run_with_postgres ${name} ./spring-quarkus-perf-comparison/springboot3/target/application/springboot3.jar perftest_spring_buildpack_executable fruits_db ./spring-quarkus-perf-comparison/scripts/dbdata
}

perftest_spring_buildpack_executable() {
    echo "[TEST] Time to First Request test..."
    oha -n 1 -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/spring-buildpack-executable-test-ttfr.json

    echo "[TEST] Running some warm-up tests..."
    oha -n 10 -u ms --no-tui --urls-from-file urls.txt > /dev/null 2>&1

    sleep 5

    echo "[TEST] Running perf tests..."
    oha -n 10000 -u ms --no-tui --urls-from-file urls.txt --output-format json -o "${TEST_OUT_DIR:-.}"/spring-buildpack-executable-test.json
}
