#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/appfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

TEST_APP_JAVA=${TEST_APP_JAVA:-21+}

CMD=$1
NAME=${2:-sqpc-spring-normal}
	
case "${CMD}" in
	start)
		start_app "${NAME}" "${TEST_BUILDS_DIR}/${REPO_NAME}/springboot3/spring-normal/application/springboot3.jar"
		;;
	stop)
		stop_app "${NAME}"
		;;
	*)
		echo "Usage: $0 {start|stop}"
		exit 1
		;;
esac
