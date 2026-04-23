#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/appfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

TEST_APP_JAVA=${TEST_APP_JAVA:-21+}

NAME=${1:-sqpc-spring-sbaot}

TEST_JAVA_OPTS="${TEST_JAVA_OPTS:-} -Dspring.aot.enabled=true" start_app "${NAME}" "${TEST_BUILDS_DIR}/${REPO_NAME}/springboot3/spring-buildpack/application/springboot3.jar"
