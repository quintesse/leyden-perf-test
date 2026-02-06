#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/appfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

TEST_APP_JAVA=${TEST_APP_JAVA:-21+}

CMD=$1
NAME=${2:-gqaot-simple-rest-aot}
	
case "${CMD}" in
	start)
		start_app "${NAME}" "${TEST_BUILDS_DIR}/${REPO_NAME}/quarkus-simple-rest-aot-converters-issue/simple-rest-aot/code-with-quarkus-1.0.0-SNAPSHOT-runner.jar"
		;;
	stop)
		stop_app "${NAME}"
		;;
	*)
		echo "Usage: $0 {start|stop}"
		exit 1
		;;
esac
