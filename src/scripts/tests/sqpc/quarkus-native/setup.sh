#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/buildfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

# Compile Quarkus app natively
require_java "21+"
# It should be -O2 additional build args
compile_maven "${REPO_NAME}/quarkus3" "-Dnative -Dquarkus.native.debug.enabled -Dquarkus.native.additional-build-args=-O0,-H:-OmitInlinedMethodDebugLineInfo"
copy_build_artifacts "${REPO_NAME}/quarkus3" "quarkus3-native" "target/quarkus3-runner"
