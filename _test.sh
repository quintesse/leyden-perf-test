#!/bin/bash
set -euo pipefail

trap ctrl_c INT

source ./_perftest_spring.sh
source ./_perftest_spring-buildpack-executable.sh
source ./_perftest_quarkus.sh
source ./_perftest_quarkus-uber-jar.sh

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
spring_buildpack_executable_test
quarkus_test
quarkus_uber_jar_test
