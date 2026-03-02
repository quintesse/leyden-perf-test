#!/bin/bash

# DESCRIPTION=Run performance/load tests using a containerized OHA driver.

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
URL="http:\/\/host.docker.internal:8080"
sed -e "s/^/$URL/" "${TEST_SUITE_DIR}/urls.txt" > $URL_FILE
DURATION=$((TOTAL_REQ/RATE))

# Prepare command prefix if CPU affinity is to be set
cpuopts=()
if [[ -v HARDWARE_CONFIGURED && "$HARDWARE_CONFIGURED" == true && -v TEST_DRIVER_CPUS && -n "${TEST_DRIVER_CPUS}" ]]; then
	cpuopts=("--cpuset-cpus=$TEST_DRIVER_CPUS")
fi

if [[ "$DETECTED_OS" == "windows" ]]; then
	HOST=$(ping -4 -n 1 "$(hostname)" | grep -E -o -m 1 '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
else
	HOST="host-gateway"
fi

cmd="${TEST_ENGINE} run -t --rm ${cpuopts[*]} --add-host=host.docker.internal:$HOST -v ${TEST_OUT_DIR:-.}:/test-results:z ghcr.io/hatoo/oha -q ${RATE} -z ${DURATION}s -c 50 -u ms --latency-correction -t=10s --no-tui --output-format json -o /test-results/${TEST_TEST_RUNID}-oha.json --db-url /test-results/${TEST_TEST_RUNID}-oha.db  --urls-from-file $URL_FILE"
echo "   - Driver command: ${cmd}"

MSYS_NO_PATHCONV=1 ${TEST_ENGINE} run -t --rm "${cpuopts[@]}" "--add-host=host.docker.internal:$HOST" -v "${TEST_OUT_DIR:-.}:/test-results:z" ghcr.io/hatoo/oha -q "${RATE}" -z "${DURATION}"s -c 50 -u ms --latency-correction -t=10s --no-tui --output-format json -o "/test-results/${TEST_TEST_RUNID}-oha.json" --db-url "/test-results/${TEST_TEST_RUNID}-oha.db"  --urls-from-file "${URL_FILE}"
