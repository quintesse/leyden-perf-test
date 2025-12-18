#!/bin/bash

# DESCRIPTION=Run performance/load tests using OHA driver. Accepts TEST_DRIVER_OHA_RATE_LIMIT env var to set rate limit (requests per second).

set -euo pipefail

source "${TEST_SRC_DIR}/scripts/appfuncs.sh"

wait_for_8080 "${TEST_TEST_RUNID}"

# Remove existing OHA database file, in case it exists
rm -f "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-oha.db" > /dev/null 2>&1 || true

if [[ -v TEST_DRIVER_OHA_RATE_LIMIT && -n "$TEST_DRIVER_OHA_RATE_LIMIT"	]] ; then
	RATE_ARG=("-q" "$TEST_DRIVER_OHA_RATE_LIMIT")
else
	RATE_ARG=()
fi

# Prepare command prefix if CPU affinity is to be set
declare -a preamble=()
if [[ -v HARDWARE_CONFIGURED && "$HARDWARE_CONFIGURED" == true && -v TEST_DRIVER_CPUS && -n "${TEST_DRIVER_CPUS}" ]]; then
	preamble=("taskset" "-c" "$TEST_DRIVER_CPUS")
fi

URL="http://localhost:8080/fruits"

cmd="oha -n ${TEST_PERF_CNT:-10000} ${RATE_ARG[*]} -u ms --latency-correction --no-tui --output-format json -o ${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-oha.json --db-url ${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-oha.db $URL"
echo "   - Driver command: ${cmd}"

"${preamble[@]}" oha -n "${TEST_PERF_CNT:-10000}" "${RATE_ARG[@]}" -u ms --latency-correction --no-tui --output-format json -o "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-oha.json" --db-url "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-oha.db" "$URL"
