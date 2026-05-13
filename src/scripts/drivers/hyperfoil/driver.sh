#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}/scripts/appfuncs.sh"

ACTION=${1:-}

case "${ACTION}" in
    prepare)
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

        echo "${preamble[*]} jbang --java-options="${EXP_OPTS}" --java-options=\"-Dio.hyperfoil.cpu.watchdog.idle.threshold=0.0\" --java-options=\"-Dio.hyperfoil.gc.check.enabled=false\" --java-options=\"-XX:+DisableExplicitGC\" --java-options=\"-Xmx1G\" --java-options=\"-Xms1G\" --java-options=\""${GC}"\" --java-options=\"-XX:+AlwaysPreTouch\" src/scripts/drivers/hyperfoil/HyperfoilWrk.java -R ${RATE} -d ${DURATION}s -c 50 -o ${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}.csv -f ${URLS_FIXED_FILE}" -i "${TEST_TEST_RUNID}" 
        "${preamble[@]}" jbang --java-options="${EXP_OPTS}" --java-options="-Dio.hyperfoil.cpu.watchdog.idle.threshold=0.0" --java-options="-Dio.hyperfoil.gc.check.enabled=false" --java-options="-XX:+DisableExplicitGC" --java-options="-Xmx1G" --java-options="-Xms1G" --java-options="${GC}" --java-options="-XX:+AlwaysPreTouch" src/scripts/drivers/hyperfoil/HyperfoilWrk.java -R "${RATE}" -d "${DURATION}"s -t 1 -o "${TEST_OUT_DIR:-.}" -f "${URLS_FIXED_FILE}" -i "${TEST_TEST_RUNID}" > "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}"-hyperfoil.log &
        pidstat -t -p $(pgrep -f HyperfoilWrk) 1  > "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-hyperfoil-pidstat.log" &
        rm -f "${TEST_OUT_DIR:-.}"/hyperfoil.did
        pgrep -f HyperfoilWrk > "${TEST_OUT_DIR:-.}"/hyperfoil.did
        while [ ! -f "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}.hyperfoil-ready" ]; do
            :
        done
        ;;
    run)
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
        ;;
esac
