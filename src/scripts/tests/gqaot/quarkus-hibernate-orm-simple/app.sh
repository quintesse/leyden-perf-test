#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/appfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

TEST_APP_JAVA=${TEST_APP_JAVA:-25+}

CMD=$1
NAME=${2:-quarkus-qgaot-hibernate-orm-simple}
	
case "${CMD}" in
	start)
	        cp "${TEST_SRC_DIR}"/scripts/tests/gqaot/quarkus-hibernate-orm-simple.url.txt "${TEST_SRC_DIR}"/scripts/tests/gqaot/urls.txt
		start_app "${NAME}" "${TEST_BUILDS_DIR}/${REPO_NAME}/quarkus-hibernate-orm-simple/quarkus-hibernate-orm-simple/quarkus-run.jar"
		;;
	stop)
		stop_app "${NAME}"
		;;
	*)
		echo "Usage: $0 {start|stop}"
		exit 1
		;;
esac
