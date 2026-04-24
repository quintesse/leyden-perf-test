#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}/scripts/appfuncs.sh"

kill -s SIGCONT $(pgrep -f HyperfoilWrk)	

app_pid=$(get_app_pid "${TEST_TEST_RUNID}")

while [ -f "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}.hyperfoil-ready" ]; do
	sleep 0.5
	if ! kill -0 "${app_pid}" > /dev/null 2>&1; then
		echo -e "   - ${BOLD}${RED}✗ Application process has exited unexpectedly${NORMAL}"
		echo -e "   - ${BOLD}${RED}✗ ${TEST_TEST_RUNID} test application not running${NORMAL}"
		sleep 2 # give time for output to be flushed
		echo -e "   - ${RED}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${NORMAL}"
		outfile="${TEST_OUT_DIR}/${TEST_TEST_RUNID}-app.out"
		cat "$outfile" 2>/dev/null || true
		echo -e "   - ${RED}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${NORMAL}"
		kill -9 "$(pgrep -f HyperfoilWrk)" || true
		rm -f "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}.hyperfoil-ready"  || true
	fi
done
