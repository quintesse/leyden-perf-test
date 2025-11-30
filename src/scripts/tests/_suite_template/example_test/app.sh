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

case "$1" in
	start)
		# Start the application to be tested
		;;
	stop)
		# Stop the application that was tested
		;;
	*)
		echo "Usage: $0 {start|stop}"
		exit 1
		;;
esac
