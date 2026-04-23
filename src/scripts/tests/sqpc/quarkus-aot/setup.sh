#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/buildfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

# Compile Quarkus app normally
require_java "25+"
compile_maven "${REPO_NAME}/quarkus3" "-Dquarkus.package.jar.aot.enabled=true"
copy_build_artifacts "${REPO_NAME}/quarkus3" "quarkus3-jar" "target/quarkus-app"