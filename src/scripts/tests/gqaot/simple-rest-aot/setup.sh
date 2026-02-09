#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/buildfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

require_java "25+"
compile_maven "${REPO_NAME}/quarkus-simple-rest-aot" "-Dquarkus.package.jar.type=aot-jar -Dquarkus.package.jar.appcds.use-aot=true"
copy_build_artifacts "${REPO_NAME}/quarkus-simple-rest-aot" "simple-rest-aot" "target/quarkus-app/app" "target/quarkus-app/lib" "target/quarkus-app/quarkus" "target/quarkus-app/quarkus-app-dependencies.txt" "target/quarkus-app/quarkus-run.jar"
