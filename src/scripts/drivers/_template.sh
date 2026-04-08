#!/bin/bash

# DESCRIPTION=Example driver script. Put your description here.

set -euo pipefail

# It must make use of TEST_DRIVER_RATE_LIMIT env var to set rate limit (requests per second) and TEST_PERF_CNT env var to set number of requests.

case "$1" in
	prepare)
		# Perform any work required before any tests in the suite are run
		;;
	run)
    # ... put your code to run performance tests here ...
		;;
	*)
		echo "Usage: $0 {prepare|run}"
		exit 1
		;;
esac