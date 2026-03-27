#!/bin/bash

# DESCRIPTION=Run performance/load tests using Hyperfoil driver.

set -euo pipefail

sleep 2 && pidstat -t -p $(pgrep -f HyperfoilWrk) 1  > "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-hyperfoil-pidstat.log" &
source "${TEST_SRC_DIR}/scripts/appfuncs.sh"

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

DURATION=$((TOTAL_REQ/RATE))

URLS_FILE="${TEST_TEST_DIR}/urls.txt"
if [[ ! -f "$URLS_FILE" ]]; then
	URLS_FILE="${TEST_SUITE_DIR}/urls.txt"
	if [[ ! -f "$URLS_FILE" ]]; then
		echo "ERROR: URLs file not found: $URLS_FILE"
		exit 1
	fi
fi

# Prepare list of urls to use
URLS_FIXED_FILE="${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-urls.txt"
rm -f "$URLS_FIXED_FILE" > /dev/null 2>&1 || true
URL="http:\/\/localhost:8080"
sed -e "s/^/$URL/" "$URLS_FILE" > "$URLS_FIXED_FILE"


echo "${preamble[*]} jbang --java-options=\"-Dio.hyperfoil.cpu.watchdog.idle.threshold=0.0\" --java-options=\"-Xmx1G\" --java-options=\"-Xms1G\" --java-options=\"-XX:+UseParallelGC\" --java-options=\"-XX:+AlwaysPreTouch\" src/scripts/drivers/HyperfoilWrk.java -R ${RATE} -d ${DURATION}s -c 50 -o ${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}.csv -f ${URLS_FIXED_FILE}"
"${preamble[@]}" jbang --java-options="-Dio.hyperfoil.cpu.watchdog.idle.threshold=0.0" --java-options="-Xmx1G" --java-options="-Xms1G" --java-options="-XX:+UseParallelGC" --java-options="-XX:+AlwaysPreTouch" src/scripts/drivers/HyperfoilWrk.java -R "${RATE}" -d "${DURATION}"s -t 1 -i "${TEST_TEST_RUNID}" -o "${TEST_OUT_DIR:-.}"/"${TEST_TEST_RUNID}".csv -p "${TEST_OUT_DIR:-.}"/time-to-8080.csv -f "${URLS_FIXED_FILE}" > "${TEST_OUT_DIR:-.}"/"${TEST_TEST_RUNID}"-hyperfoil.log

