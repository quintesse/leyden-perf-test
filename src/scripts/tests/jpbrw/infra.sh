#!/bin/bash

# The infra script manages the startup and shutdown of any infrastructure services
# required by the test suite. The script will receive a single argument:
# `first` which will happen before any of the tests in the suite  are run,
# 'start' to start the services for each test, and 'stop' to stop the services
# for each test and 'last' which will happen after all of the tests are run.
# The script can write any debug output it wants to the TEST_OUT_DIR directory.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

# IMPORTANT: The `start` command should wait and return only when the infrastructure
# is fully started and ready to use!

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/infrafuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

case "$1" in
	first)
		# Perform any work required before any tests in the suite are run
		;;
	start)
		# Perform any work required to start the infrastructure for each test
		;;
	stop)
		# Perform any work required to stop the infrastructure for each test
		;;
	last)
		# Perform any work required after all tests in the suite have run
		;;
	*)
		echo "Usage: $0 {first|start|stop|last}"
		exit 1
		;;
esac
