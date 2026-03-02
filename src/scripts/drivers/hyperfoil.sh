#!/bin/bash

# DESCRIPTION=Run performance/load tests using Hyperfoil driver.

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

echo "${preamble[@]}" "jbang --java-options=\"-Dio.hyperfoil.cpu.watchdog.idle.threshold=0.0\" --java-options=\"-Xmx1G\" --java-options=\"-Xms1G\" --java-options=\"-XX:+UseParallelGC\" --java-options=\"-XX:+AlwaysPreTouch\" src/scripts/drivers/HyperfoilWrk.java -R ${RATE} -d ${DURATION}s -c 50 -o ${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}.csv -f ${URL_FILE}"
"${preamble[@]}" jbang --java-options="-Dio.hyperfoil.cpu.watchdog.idle.threshold=0.0" --java-options="-Xmx1G" --java-options="-Xms1G" --java-options="-XX:+UseParallelGC" --java-options="-XX:+AlwaysPreTouch" src/scripts/drivers/HyperfoilWrk.java -R "${RATE}" -d "${DURATION}"s -t 1 -o "${TEST_OUT_DIR:-.}"/"${TEST_TEST_RUNID}".csv -f "${URL_FILE}" > "${TEST_OUT_DIR:-.}"/"${TEST_TEST_RUNID}"-hyperfoil.log

