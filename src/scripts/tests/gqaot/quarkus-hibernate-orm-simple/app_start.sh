#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/appfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

TEST_APP_JAVA=${TEST_APP_JAVA:-25+}

NAME=${1:-quarkus-qgaot-hibernate-orm-simple}

start_app "${NAME}" "${TEST_BUILDS_DIR}/${REPO_NAME}/quarkus-hibernate-orm-simple/quarkus-hibernate-orm-simple/quarkus-run.jar"
