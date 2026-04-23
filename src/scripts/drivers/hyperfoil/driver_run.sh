#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}/scripts/appfuncs.sh"

kill -s SIGCONT $(pgrep -f HyperfoilWrk)	

while [ -f "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}.hyperfoil-ready" ]; do
	sleep 0.5
done
