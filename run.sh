#!/bin/bash
set -uo pipefail

trap ctrl_c INT

source ./_functions.sh

run_jdk_tests() {
	local version=${1}
    local extra=${2}

	echo "Switching to JDK ${version}..."
    switch_jdk "${version}"
    
    export TEST_OUT_DIR=${TEST_OUT_BASE}/j${version}${extra}
    mkdir -p ${TEST_OUT_DIR}
    echo "Created test output folder ${TEST_OUT_DIR}"

    ./_test.sh

    cleanup
}

run_jdkaot_tests() {
	local version=${1}

    export TEST_USE_AOT=false
    run_jdk_tests "${version}" ""

    if ([ "${version}" -lt 25 ]); then
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
    rmdir "${TEST_OUT_DIR}" >/dev/null 2>&1 || true
}

switch_jdk() {
	local version=$1

	./jbang jdk default ${version}
}

function restorejdk() {
    echo "Restoring JDK to ${currentJdkVersion}..."
    switch_jdk "${currentJdkVersion}"
}

function ctrl_c() {
	echo "Caught Ctrl-C, cleaning up..."
    cleanup
    restorejdk
    exit 2
}

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

userExtra=""
if ! [[ $1 =~ '^[0-9]+$' ]] ; then
    userExtra="$1"
    shift
fi

TEST_OUT_BASE=./test-results/test-run-$(date +%Y%m%d-%H%M%S)${userExtra:+-$userExtra}

currentJdkVersionString=$(jbang jdk default 2>&1)
currentJdkVersion=${currentJdkVersionString##* }

run_all_tests "$@"

echo "Tests completed. Results can be found in ${TEST_OUT_BASE}:"
ls -R ${TEST_OUT_BASE}

restorejdk
