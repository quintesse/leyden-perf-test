#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/appfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

NAME=${1:-sqpc-quarkus-native}

stop_app "${NAME}"
