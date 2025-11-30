#!/bin/bash

# DESCRIPTION=Starts/stops a test application.

set -euo pipefail

trap ctrl_c INT

if [[ ! -v TEST_SRC_DIR ]]; then
	echo "ERROR: Please run this script via './run app ...' from the leyden-perf-test root directory."
	exit 3
fi

if [[ $# -gt 0 && ( "$1" == "-h" || "$1" == "--help" ) || $# -eq 0 ]]; then
	echo "This command starts/stops a test application."
	echo "Usage: ./run app [<options>] <test-suite>/<test-name> start|stop"
	echo ""
	echo "Options:"
	echo "  -o, --output <path>   Path to the output folder."
	echo "  -j, --java <version>  Java version to use for the test application."
	echo "  --result-tag <tag>    Tag to add to the result folder name."
	echo "  --jdk-tag <tag>       Tag to add to the JDK folder name."
	echo ""
	echo "This script can be used to manually start/stop a test application, and is normally"
	echo "run with a <test-suite>/<test-name> argument referring to a single test. It is"
	echo "possible to pass 'all' or use wildcards but this means multiple applications may be"
	echo "started/stopped which might not even be possible (e.g. if they use the same ports)."
	echo ""
	echo "Run './run list' to see the list of available test suites and tests."
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh
source "${TEST_SRC_DIR}"/scripts/appfuncs.sh
source "${TEST_SRC_DIR}"/scripts/infrafuncs.sh

function run_app() {
	local testpat=$1
	local action=$2

	local -a testfunccall
	local -a beforesuitefunccall
	local -a aftersuitefunccall
	local -a firstsuitefunccall
	local -a lastsuitefunccall

	local msg
	if [[ "${action}" == "start" ]]; then
		msg="Starting application for"
		testfunccall=("_run_command_for_test" "app" "${msg}" "start")
		beforesuitefunccall=("_run_command_for_suite" "app" "${msg}" "start")
		aftersuitefunccall=("_noop")
		firstsuitefunccall=("_run_command_for_suite" "app" "${msg}" "first")
		lastsuitefunccall=("_noop")
	else
		msg="Stopping application for"
		testfunccall=("_run_command_for_test" "app" "${msg}" "stop")
		beforesuitefunccall=("_noop")
		aftersuitefunccall=("_run_command_for_suite" "app" "${msg}" "stop")
		firstsuitefunccall=("_noop")
		lastsuitefunccall=("_run_command_for_suite" "app" "${msg}" "last")
	fi
	run_suite_funcs "${testpat}" testfunccall beforesuitefunccall aftersuitefunccall firstsuitefunccall lastsuitefunccall
}

resultTag=""
jdkTag=""
outputPath=""
export TEST_APP_JAVA=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--tag)
            shift
            if [[ $# -eq 0 ]]; then
                echo "Error: Tag option specified but no tag value provided."
                exit 4
            fi
            resultTag="$1"
            shift
            ;;
        --jdk-tag)
            shift
            if [[ $# -eq 0 ]]; then
                echo "Error: Tag option specified but no tag value provided."
                exit 4
            fi
            jdkTag="$1"
            shift
            ;;
        -o|--output)
            shift
            if [[ $# -eq 0 ]]; then
                echo "Error: Output option specified but no path provided."
                exit 4
            fi
            outputPath="$1"
            shift
            ;;
        -j|--java)
            shift
			if [[ $# -eq 0 ]]; then
				echo "Error: Java version option specified but no version value provided."
				exit 4
			fi
			TEST_APP_JAVA="$1"
			shift
			;;
        *)
            break
            ;;
    esac
done

javaVersion="${TEST_APP_JAVA:-Unknown}"

export TEST_OUT_DIR
if [[ ! -v TEST_OUT_DIR || -z "${TEST_OUT_DIR}" ]]; then
	TEST_OUT_BASE=${outputPath:-./test-results/test-run-$(date +%Y%m%d-%H%M%S)${resultTag:+-$resultTag}}
	TEST_OUT_DIR=${TEST_OUT_BASE}/j${javaVersion}${jdkTag:+-$jdkTag}
	mkdir -p "${TEST_OUT_DIR}"
	echo "   - Created test output folder ${TEST_OUT_DIR}"
fi

case "$2" in
	start)
		run_app "${1:-all}" "start"
		;;
	stop)
		run_app "${1:-all}" "stop"
		;;
	*)
		echo "ERROR: Second argument must be 'start' or 'stop'."
		exit 4
		;;
esac
