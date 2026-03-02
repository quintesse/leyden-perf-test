#!/bin/bash

# DESCRIPTION=Run performance/load tests using OHA driver.

set -euo pipefail

source "${TEST_SRC_DIR}/scripts/appfuncs.sh"

wait_for_8080 "${TEST_TEST_RUNID}"

# Supporting TEST_DRIVER_OHA_RATE_LIMIT too
if [[ -v TEST_DRIVER_OHA_RATE_LIMIT && -n "$TEST_DRIVER_OHA_RATE_LIMIT"	]] ; then
	TEST_DRIVER_RATE_LIMIT=${TEST_DRIVER_OHA_RATE_LIMIT}
fi

# Remove existing OHA database file, in case it exists
rm -f "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-oha.db" > /dev/null 2>&1 || true

if [[ -v TEST_PERF_CNT && -n "$TEST_PERF_CNT"	]] ; then
	TOTAL_REQ=${TEST_PERF_CNT}
else
	TOTAL_REQ=10000
fi

if [[ -v TEST_DRIVER_OHA_RATE_LIMIT && -n "$TEST_DRIVER_OHA_RATE_LIMIT"	]] ; then
  RATE=${TEST_DRIVER_OHA_RATE_LIMIT}
else
  RATE=1000
fi

# Prepare list of urls to use
URL_FILE="${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-urls.txt"
rm -f "$URL_FILE" > /dev/null 2>&1 || true
URL="http:\/\/localhost:8080"
sed -e "s/^/$URL/" "${TEST_SUITE_DIR}/urls.txt" > $URL_FILE
DURATION=$((TOTAL_REQ/RATE))

# Prepare command prefix if CPU affinity is to be set
declare -a preamble=()
if [[ -v HARDWARE_CONFIGURED && "$HARDWARE_CONFIGURED" == true && -v TEST_DRIVER_CPUS && -n "${TEST_DRIVER_CPUS}" ]]; then
	preamble=("taskset" "-c" "$TEST_DRIVER_CPUS")
fi

cmd="oha -q ${RATE} -z ${DURATION}s -c 50 -u ms --latency-correction -t=10s --no-tui --output-format json -o ${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-oha.json --db-url ${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-oha.db --urls-from-file $URL_FILE"
echo "   - Driver command: ${cmd}"

"${preamble[@]}" oha -q "${RATE}" -z "${DURATION}"s -c 50 -u ms --latency-correction -t=10s --no-tui --output-format json -o "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-oha.json" --db-url "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-oha.db" --urls-from-file "${URL_FILE}"
