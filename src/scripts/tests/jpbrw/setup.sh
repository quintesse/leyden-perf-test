#!/bin/bash


set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/buildfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

clone "${REPO_NAME}-benchmark" "${REPO_BENCHMARK_URL}"
clone "${REPO_NAME}-wrapper" "${REPO_WRAPPER_URL}"
