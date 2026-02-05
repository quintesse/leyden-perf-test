#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/buildfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

require_java "25+"
compile_maven "${REPO_NAME}/quarkus-simple-rest-aot-converters-issue" "clean package -Dquarkus.package.jar.appcds.enabled=true -Dquarkus.package.jar.appcds.use-aot=true"
copy_build_artifacts "${REPO_NAME}/quarkus-simple-rest-aot-converters-issue" "simple-rest-aot" "target/code-with-quarkus-1.0.0-SNAPSHOT-runner.jar" "target/quarkus-artifact.properties" "target/lib"
