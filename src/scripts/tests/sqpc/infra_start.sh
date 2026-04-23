#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/infrafuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

start_postgres "${PG_CONTAINER_NAME}" "${POSTGRES_CONTAINER_OPTS}"
