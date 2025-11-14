#!/bin/bash
set -euo pipefail

trap ctrl_c INT

source "${TEST_SRC_DIR}"/scripts/tests/spring-quarkus-perf-comparison/spring-normal.sh
source "${TEST_SRC_DIR}"/scripts/tests/spring-quarkus-perf-comparison/spring-buildpack.sh
source "${TEST_SRC_DIR}"/scripts/tests/spring-quarkus-perf-comparison/quarkus-normal.sh
source "${TEST_SRC_DIR}"/scripts/tests/spring-quarkus-perf-comparison/quarkus-uberjar.sh

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
spring_buildpack_test
quarkus_test
quarkus_uberjar_test
