#!/bin/bash

# DESCRIPTION=Run performance/load tests using a containerized OHA driver. Accepts TEST_DRIVER_OHA_RATE_LIMIT env var to set rate limit (requests per second).

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

URL="http://host.docker.internal:8080/fruits"

cpuopts=()
if [[ -v HARDWARE_CONFIGURED && "$HARDWARE_CONFIGURED" == true && -v TEST_DRIVER_CPUS && -n "${TEST_DRIVER_CPUS}" ]]; then
	cpuopts=("--cpuset-cpus=$TEST_DRIVER_CPUS")
fi

if [[ "$(detectOs)" == "windows" ]]; then
	HOST=$(ping -4 -n 1 "$(hostname)" | grep -E -o -m 1 '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
else
	HOST="host-gateway"
fi

cmd="${TEST_ENGINE} run -t --rm ${cpuopts[*]} --add-host=host.docker.internal:$HOST -v ${TEST_OUT_DIR:-.}:/test-results:z ghcr.io/hatoo/oha -n ${TEST_PERF_CNT:-10000} ${RATE_ARG[*]} -u ms --no-tui --output-format json -o /test-results/${TEST_TEST_RUNID}-oha.json --db-url /test-results/${TEST_TEST_RUNID}-oha.db ${URL}"
echo "   - Driver command: ${cmd}"

MSYS_NO_PATHCONV=1 ${TEST_ENGINE} run -t --rm "${cpuopts[@]}" "--add-host=host.docker.internal:$HOST" -v "${TEST_OUT_DIR:-.}:/test-results:z" ghcr.io/hatoo/oha -n "${TEST_PERF_CNT:-10000}" "${RATE_ARG[@]}" -u ms --no-tui --output-format json -o "/test-results/${TEST_TEST_RUNID}-oha.json" --db-url "/test-results/${TEST_TEST_RUNID}-oha.db" "${URL}"
