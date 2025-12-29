#!/bin/bash

# The setup script manages any work that needs to be done to prepare the
# application being tested for execution, such as compiling the code.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/buildfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

# Compile Quarkus app normally
require_java "25"
compile_maven "${REPO_NAME}-benchmark"
require_java "25+"
compile_maven "${REPO_NAME}-wrapper" "-Dquarkus.package.jar.type=uber-jar"
copy_build_artifacts "${REPO_NAME}-wrapper" "quarkus-uberjar" "target/jvm-performance-benchmarks-rest-wrapper-1.0.0-SNAPSHOT-runner.jar"