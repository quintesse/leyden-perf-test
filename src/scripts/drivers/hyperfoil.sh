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
  TOTAL_USERS="$TEST_DRIVER_RATE_LIMIT"
else
  TOTAL_USERS=1000
fi

# Prepare configuration
URL="http://localhost:8080"
DURATION=$((TOTAL_REQ/TOTAL_USERS))

echo "Generating folder to store results: ""${TEST_OUT_DIR:-.}"/"${TEST_TEST_RUNID}"
mkdir "${TEST_OUT_DIR:-.}"/"${TEST_TEST_RUNID}"

BENCHMARK_YAML="${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}/${TEST_TEST_RUNID}-benchmark.hf.yaml"
rm -f "$BENCHMARK_YAML" > /dev/null 2>&1 || true
{
  echo "name: ${TEST_TEST_RUNID}"
  echo "http:"
  echo "  host: $URL"
  echo "  sharedConnections: 10"
  echo "duration: ${DURATION}s"
  echo "usersPerSec: ${TOTAL_USERS}"
  echo "scenario:"
} >> "$BENCHMARK_YAML"

INDEX=1
 while IFS= read -r p || [ -n "$p" ]; do
  {
    echo "- scenario-${INDEX}:"
    echo "  - httpRequest:"
    echo "      GET: ${p}"
  } >> "$BENCHMARK_YAML"
  INDEX=$((INDEX+1))
done < "${TEST_SUITE_DIR}/urls.txt"

cmd="${TEST_ENGINE} run -it --rm -v ${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}:/benchmarks:rw,Z,U --network=host quay.io/hyperfoil/hyperfoil run -o /benchmarks /benchmarks/${TEST_TEST_RUNID}-benchmark.hf.yaml"
echo "   - Driver command: ${cmd}"

"${preamble[@]}" "${TEST_ENGINE}" run -it --rm -v "${TEST_OUT_DIR:-.}/${TEST_TEST_RUNID}":/benchmarks:rw,Z,U --network=host quay.io/hyperfoil/hyperfoil run -o /benchmarks /benchmarks/"${TEST_TEST_RUNID}"-benchmark.hf.yaml

