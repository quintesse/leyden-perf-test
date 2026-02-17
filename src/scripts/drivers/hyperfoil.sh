#!/bin/bash

# DESCRIPTION=Run performance/load tests using Hyperfoil driver. Accepts TEST_DRIVER_RATE_LIMIT env var to set rate limit (requests per second). Accepts TEST_PERF_CNT env var to set number of requests.

set -euo pipefail

source "${TEST_SRC_DIR}/scripts/appfuncs.sh"

wait_for_8080 "${TEST_TEST_RUNID}"

# Prepare command prefix if CPU affinity is to be set
declare -a preamble=()
if [[ -v HARDWARE_CONFIGURED && "$HARDWARE_CONFIGURED" == true && -v TEST_DRIVER_CPUS && -n "${TEST_DRIVER_CPUS}" ]]; then
	preamble=("taskset" "-c" "$TEST_DRIVER_CPUS")
fi

if [[ -v TEST_PERF_CNT && -n "$TEST_PERF_CNT"	]] ; then
	TOTAL_REQ="$TEST_PERF_CNT"
else
	TOTAL_REQ=10000
fi

if [[ -v TEST_DRIVER_RATE_LIMIT && -n "$TEST_DRIVER_RATE_LIMIT"	]] ; then
  RATE="$TEST_DRIVER_RATE_LIMIT"
else
  RATE=1000
fi

# Prepare configuration
URL="http://localhost:8080"
DURATION=$((TOTAL_REQ/RATE))

 while IFS= read -r p || [ -n "$p" ]; do
    echo "${preamble[@]}" "jbang src/scripts/drivers/HyperfoilWrk.java -R ${RATE} -d ${DURATION}s -t 1 -o ${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}.csv ${URL}${p}"
    "${preamble[@]}" jbang src/scripts/drivers/HyperfoilWrk.java -R "${RATE}" -t 1 -d "${DURATION}"s -o "${TEST_OUT_DIR:-.}"/"${TEST_TEST_RUNID}".csv "${URL}""${p}"
done < "${TEST_SUITE_DIR}/urls.txt"
