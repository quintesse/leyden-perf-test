#!/bin/bash
set -uo pipefail

trap ctrl_c INT

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

export TEST_SRC_DIR=${script_dir}/src
export TEST_APPS_DIR=${script_dir}/apps
export TEST_BUILDS_DIR=${script_dir}/builds

source "${TEST_SRC_DIR}"/scripts/functions.sh

run_jdk_tests() {
	local version=${1}
    local extra=${2}

    switch_jdk "${version}"
    
    export TEST_OUT_DIR=${TEST_OUT_BASE}/j${version}${extra}
    mkdir -p "${TEST_OUT_DIR}"
    echo "Created test output folder ${TEST_OUT_DIR}"

    "${TEST_SRC_DIR}"/scripts/test.sh

    cleanup
}

run_jdkaot_tests() {
	local version=${1}

    export TEST_USE_AOT=false
    run_jdk_tests "${version}" ""

    if [ "${version}" -lt 25 ]; then
        # AOT not supported before JDK 25
        return
    fi

    export TEST_USE_AOT=true
    run_jdk_tests "${version}" "aot"
}

run_all_tests() {
    for v in "$@"; do
        run_jdkaot_tests "$v"
    done
}

function cleanup() {
    # We clean up empty folders to avoid clutter
	if [[ -v TEST_OUT_DIR && -n "${TEST_OUT_DIR}" ]]; then
        rmdir "${TEST_OUT_DIR}" >/dev/null 2>&1 || true
    fi
	if [[ -v TEST_OUT_BASE && -n "${TEST_OUT_BASE}" ]]; then
        rmdir "${TEST_OUT_BASE}" >/dev/null 2>&1 || true
    fi
    rmdir "./test-results" >/dev/null 2>&1 || true
}

function ctrl_c() {
	echo "Caught Ctrl-C, cleaning up..."
    cleanup
    restorejdk
    exit 2
}

userExtra=""
if [[ $# -gt 0 && ("$1" == "-t" || "$1" == "--tag") ]] ; then
    shift
    if [[ $# -eq 0 ]]; then
        echo "Error: Tag option specified but no tag value provided."
        exit 4
    fi
    userExtra="$1"
    shift
fi

if [ $# -eq 0 ]; then
    echo "No JDK versions supplied, please provide at least one JDK version to test."
    echo "Try for example: ./run.sh 25 26"
    echo "For versions 25 and up, tests will be run twice, once without AOT and once with AOT."
    exit 3
fi

if ! command -v oha >/dev/null 2>&1
then
    echo "Command 'oha' not found, please install it, see https://github.com/hatoo/oha"
    exit 1
fi

TEST_OUT_BASE=./test-results/test-run-$(date +%Y%m%d-%H%M%S)${userExtra:+-$userExtra}

save_jdk

run_all_tests "$@"

restore_jdk

echo ""
echo "--------------------------------------------------------------"
echo "Tests completed. Results can be found in ${TEST_OUT_BASE}:"
ls -R "${TEST_OUT_BASE}"

echo ""
jbang "${TEST_SRC_DIR}"/java/util/Collate.java "${TEST_OUT_BASE}"
