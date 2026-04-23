#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/infrafuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

stop_postgres "${PG_CONTAINER_NAME}"
