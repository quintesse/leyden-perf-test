#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/infrafuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

case "$1" in
	first)
		# Not doing anything here, we want a clean infra state before each test
		;;
	start)
		;;
	stop)
		;;
	last)
		# Not used
		;;
	*)
		echo "Usage: $0 {first|start|stop|last}"
		exit 1
		;;
esac
