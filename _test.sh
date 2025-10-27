#!/bin/bash
set -euo pipefail

trap ctrl_c INT

source ./_functions.sh
source ./_perftest_spring.sh
source ./_perftest_quarkus.sh

spring_test() {
	do_aot_test_run spring spring_test_run ${TEST_USE_AOT:-false}
}

spring_test_run() {
	local NAME=${1:-spring}
	do_test_run_with_postgres ${NAME} ./spring-quarkus-perf-comparison/springboot3/target/*.jar perftest_spring fruits_db ./spring-quarkus-perf-comparison/scripts/dbdata
}

quarkus_test() {
	do_aot_test_run quarkus quarkus_test_run ${TEST_USE_AOT:-false}
}

quarkus_test_run() {
	local NAME=${1:-quarkus}
	do_test_run_with_postgres ${NAME} ./spring-quarkus-perf-comparison/quarkus3/target/quarkus-app/quarkus-run.jar perftest_quarkus fruits_db ./spring-quarkus-perf-comparison/scripts/dbdata
}

if ! command -v oha >/dev/null 2>&1
then
    echo "Command 'oha' not found, please install it, see https://github.com/hatoo/oha"
    exit 1
fi

ENGINE=""
if command -v podman >/dev/null 2>&1; then
  ENGINE="podman"
elif command -v docker >/dev/null 2>&1; then
  ENGINE="docker"
else
  echo "Error: Neither podman nor docker can be found"
  exit_abnormal
fi

TEST_JAVA_OPTS=${TEST_JAVA_OPTS:-}
TEST_USE_AOT=${TEST_USE_AOT:-}
TEST_AOT_OPTS=${TEST_AOT_OPTS:-}
JAVA_PID=""
CONTAINER_NM=""

if [[ -z ${TEST_OUT_DIR:-} ]]; then
	TEST_OUT_DIR="."
fi

spring_test
quarkus_test

echo ""
echo Results for Spring Boot performance tests:
cat ${TEST_OUT_DIR}/spring-test.out || echo "No results found for Spring Boot"

echo ""
echo Results for Quarkus performance tests:
cat ${TEST_OUT_DIR}/quarkus-test.out || echo "No results found for Quarkus"
