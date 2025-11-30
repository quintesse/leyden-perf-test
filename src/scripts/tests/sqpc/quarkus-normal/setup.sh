#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/buildfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

# Compile Quarkus app normally
require_java "21+"
compile_maven "${REPO_NAME}/quarkus3"
copy_build_artifacts "${REPO_NAME}/quarkus3" "quarkus3-normal" "target/quarkus-app"