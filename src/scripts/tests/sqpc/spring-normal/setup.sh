#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/buildfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

# Compile Spring Boot app normally
require_java "21+"
compile_maven "${REPO_NAME}/springboot3" ""
echo "   - Extracting Spring Boot Buildpack Executable..."
target="${TEST_APPS_DIR}/${REPO_NAME}/springboot3/target"
rm -rf "${target}/application" > /dev/null 2>&1
java -Djarmode=tools -jar "${target}/springboot3.jar" extract --destination "${target}/application" > /dev/null
copy_build_artifacts "${REPO_NAME}/springboot3" "spring-normal" "target/application"
