#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}/scripts/appfuncs.sh"

ACTION=${1:-}

if [[ "$ACTION" == "setup" ]]; then
    if ! command -v oha >/dev/null 2>&1; then
        echo -e "   - ${NORMAL}  oha   : Downloading 'oha' command...${NORMAL}"
        mkdir -p "${TEST_CACHE_DIR}"
        curl -Lf --no-progress-meter -o "${TEST_CACHE_DIR}/oha" https://github.com/hatoo/oha/releases/download/v1.14.0/oha-linux-amd64
        chmod +x "${TEST_CACHE_DIR}/oha"
        echo -e "   - ${NORMAL}${GREEN}✓ oha   : Command installed correctly.${NORMAL}"
        exit 0
    else
        echo -e "   - ${NORMAL}${GREEN}✓ oha   : Command is installed.${NORMAL}"
        exit 0
    fi
fi

if [[ "${ACTION}" != "run" ]]; then
    exit 0
fi

OHA_CMD=""
if command -v oha >/dev/null 2>&1; then
    OHA_CMD=oha
elif [[ -f "${TEST_CACHE_DIR}/oha" ]]; then
    OHA_CMD="${TEST_CACHE_DIR}/oha"
else
    echo "Error: 'oha' command not found, please run with 'setup' action first.${NORMAL}"
    exit 1
fi

wait_for_8080 "${TEST_TEST_RUNID}"

# Supporting TEST_DRIVER_OHA_RATE_LIMIT too
if [[ -v TEST_DRIVER_OHA_RATE_LIMIT && -n "$TEST_DRIVER_OHA_RATE_LIMIT" ]] ; then
    TEST_DRIVER_RATE_LIMIT=${TEST_DRIVER_OHA_RATE_LIMIT}
fi

# Remove existing OHA database file, in case it exists
rm -f "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-oha.db" > /dev/null 2>&1 || true

if [[ -v TEST_PERF_CNT && -n "$TEST_PERF_CNT"   ]] ; then
    TOTAL_REQ=${TEST_PERF_CNT}
else
    TOTAL_REQ=10000
fi

if [[ -v TEST_DRIVER_OHA_RATE_LIMIT && -n "$TEST_DRIVER_OHA_RATE_LIMIT" ]] ; then
    RATE=${TEST_DRIVER_OHA_RATE_LIMIT}
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

# Prepare command prefix if CPU affinity is to be set
declare -a preamble=()
if [[ -v HARDWARE_CONFIGURED && "$HARDWARE_CONFIGURED" == true && -v TEST_DRIVER_CPUS && -n "${TEST_DRIVER_CPUS}" ]]; then
    preamble=("taskset" "-c" "$TEST_DRIVER_CPUS")
fi

cmd="$OHA_CMD -q ${RATE} -z ${DURATION}s -c 50 -u ms --latency-correction -t=10s --no-tui --output-format json -o ${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-oha.json --db-url ${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-oha.db --urls-from-file $URLS_FIXED_FILE"
echo "   - Driver command: ${cmd}"

"${preamble[@]}" $OHA_CMD -q "${RATE}" -z "${DURATION}"s -c 50 -u ms --latency-correction -t=10s --no-tui --output-format json -o "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-oha.json" --db-url "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}-oha.db" --urls-from-file "${URLS_FIXED_FILE}"
