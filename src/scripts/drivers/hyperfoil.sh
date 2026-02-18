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

# Prepare list of urls to use
URL_FILE="${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-urls.txt"
URL="http:\/\/localhost:8080"
sed -e "s/^/$URL/" "${TEST_SUITE_DIR}/urls.txt" > $URL_FILE
DURATION=$((TOTAL_REQ/RATE))

sleep 2 && pidstat -t -p $(pgrep -f HyperfoilWrk) 1  > "${TEST_OUT_DIR:-.}"/"${TEST_TEST_RUNID}"-hyperfoil-pidstat.log &

JAVA_OPTS="-Xmx1G -Xms1G -XX:TieredStopAtLevel=1 -XX:+UseSerialGC"
echo "${preamble[@]}" "jbang --java-options="${JAVA_OPTS}" src/scripts/drivers/HyperfoilWrk.java -R ${RATE} -d ${DURATION}s -t 1 -o ${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}.csv -f ${URL_FILE}"
"${preamble[@]}" jbang --java-options="-Dio.hyperfoil.cpu.watchdog.idle.threshold=0.0" --java-options="-Xmx1G" --java-options="-Xms1G" --java-options="-XX:+UseSerialGC" --java-options="-XX:TieredStopAtLevel=1" src/scripts/drivers/HyperfoilWrk.java -R "${RATE}" -d "${DURATION}"s -t 1 -o "${TEST_OUT_DIR:-.}"/"${TEST_TEST_RUNID}".csv -f "${URL_FILE}" > "${TEST_OUT_DIR:-.}"/"${TEST_TEST_RUNID}"-hyperfoil.log

