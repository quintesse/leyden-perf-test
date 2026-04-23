#!/bin/bash

# The infra script manages the startup and shutdown of any infrastructure services
# required by the application being tested. The script will receive a single argument:
# 'start' to start the services, and 'stop' to stop them.
# The script can write any debug output it wants to the TEST_OUT_DIR directory.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

# IMPORTANT: The `start` command should wait and return only when the infrastructure
# is fully started and ready to use!

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/infrafuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

case "$1" in
	start)
		# Perform any work required to start the infrastructure
		;;
	stop)
		# Perform any work required to stop the infrastructure
		;;
	*)
		echo "Usage: $0 {start|stop}"
		exit 1
		;;
esac
