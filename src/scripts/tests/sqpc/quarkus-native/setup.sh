#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/buildfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

# Compile Quarkus app natively
require_java "21+"
compile_maven "${REPO_NAME}/quarkus3" "-Dnative"
copy_build_artifacts "${REPO_NAME}/quarkus3" "quarkus3-native" "target/quarkus3-runner"
