#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/sharedfuncs.sh
source "${TEST_SRC_DIR}"/scripts/appfuncs.sh

setup() {
    if ! command -v pidstat >/dev/null 2>&1; then
        fail "${BOLD}Warning: pidstat command not found! Statistics collection will not work."
    fi
}

prime() {
    # Prepare command prefix if CPU affinity is to be set
    declare -a preamble=()
    if [[ -v HARDWARE_CONFIGURED && "$HARDWARE_CONFIGURED" == true && -v TEST_DRIVER_CPUS && -n "${TEST_DRIVER_CPUS}" ]]; then
        preamble=("taskset" "-c" "$TEST_DRIVER_CPUS")
    fi

    if [[ -v TEST_PERF_CNT && -n "$TEST_PERF_CNT"   ]] ; then
        TOTAL_REQ="$TEST_PERF_CNT"
    else
        TOTAL_REQ=10000
    fi

    if [[ -v TEST_DRIVER_RATE_LIMIT && -n "$TEST_DRIVER_RATE_LIMIT" ]] ; then
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
    URL="http:\/\/${TEST_APP_HOST:-localhost}:8080"
    sed -e "s/^/$URL/" "$URLS_FILE" > "$URLS_FIXED_FILE"

    EXP_OPTS=""
    #GC="-XX:+UseG1GC"
    #GC="-XX:+UseSerialGC"
    #GC="-XX:+UseZGC"
    #GC="-XX:+UseParallelGC"
    GC="-XX:+UseEpsilonGC"
    EXP_OPTS="-XX:+UnlockExperimentalVMOptions"

    local hyperfoil_pid
    local hyperfoil_java="${TEST_SRC_DIR}/scripts/drivers/hyperfoil/HyperfoilWrk.java"
    echo "${preamble[*]} jbang --java-options="${EXP_OPTS}" --java-options=\"-Dio.hyperfoil.cpu.watchdog.idle.threshold=0.0\" --java-options=\"-Dio.hyperfoil.gc.check.enabled=false\" --java-options=\"-XX:+DisableExplicitGC\" --java-options=\"-Xmx1G\" --java-options=\"-Xms1G\" --java-options=\""${GC}"\" --java-options=\"-XX:+AlwaysPreTouch\" ${hyperfoil_java} -R ${RATE} -d ${DURATION}s -c 50 -o ${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}.csv -f ${URLS_FIXED_FILE}" -i "${TEST_TEST_RUNID}" 
    "${preamble[@]}" jbang --java-options="${EXP_OPTS}" --java-options="-Dio.hyperfoil.cpu.watchdog.idle.threshold=0.0" --java-options="-Dio.hyperfoil.gc.check.enabled=false" --java-options="-XX:+DisableExplicitGC" --java-options="-Xmx1G" --java-options="-Xms1G" --java-options="${GC}" --java-options="-XX:+AlwaysPreTouch" "${hyperfoil_java}" -R "${RATE}" -d "${DURATION}"s -t 1 -o "${TEST_OUT_DIR:-.}" -f "${URLS_FIXED_FILE}" -i "${TEST_TEST_RUNID}" > "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}"-hyperfoil.log &
    record_app "hyperfoil-driver" hyperfoil_pid

    if command -v pidstat >/dev/null 2>&1; then
        pidstat -t -p "${hyperfoil_pid}" 1  > "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-hyperfoil-pidstat.log" &
    fi

    local ready_file="${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}.hyperfoil-ready"
    local ready_deadline=$((SECONDS + 60))
    while [[ ! -f "${ready_file}" ]]; do
        if (( SECONDS >= ready_deadline )); then
            fail "Timed out after 60 seconds waiting for Hyperfoil ready file: ${ready_file}. Check ${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-hyperfoil.log"
            stop_app "hyperfoil-driver"
            return 1
        fi
        sleep 0.5
    done
}

run() {
    local hyperfoil_pid
    get_app_pid "hyperfoil-driver" hyperfoil_pid

    kill -s SIGCONT "${hyperfoil_pid}"

    # Allow the workload duration plus 60 seconds for completion and output.
    local run_duration="${DURATION:-$(( ${TEST_PERF_CNT:-10000} / ${TEST_DRIVER_RATE_LIMIT:-1000} ))}"
    local run_timeout=$((run_duration + 60))
    local run_deadline=$((SECONDS + run_timeout))
    while [ -f "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}.hyperfoil-ready" ]; do
        if (( SECONDS >= run_deadline )); then
            fail "Timed out after ${run_timeout} seconds waiting for Hyperfoil to finish. Check ${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-hyperfoil.log"
            stop_app "hyperfoil-driver"
            rm -f "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}.hyperfoil-ready" || true
            return 2
        fi
        sleep 0.5
    done

    stop_app "hyperfoil-driver"
}
