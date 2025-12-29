#!/bin/bash

# The app script manages the startup and shutdown of the application to be tested.
# The script will receive a single argument: 'start' to start the application, and
# 'stop' to stop it.
# The script can write any debug output it wants to the TEST_OUT_DIR directory.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/appfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

TEST_APP_JAVA=${TEST_APP_JAVA:-25+}

CMD=$1
NAME=${2:-jpbrw-quarkus-normal}

case "${CMD}" in
	start)
		start_app "${NAME}" "${TEST_BUILDS_DIR}/${REPO_NAME}-wrapper/quarkus-uberjar/jvm-performance-benchmarks-rest-wrapper-1.0.0-SNAPSHOT-runner.jar"
		;;
	stop)
		stop_app "${NAME}"
		;;
	*)
		echo "Usage: $0 {start|stop}"
		exit 1
		;;
esac
