#!/bin/bash

# DESCRIPTION=Starts/stops required infrastructure for the tests.

set -euo pipefail

if [[ ! -v TEST_SRC_DIR ]]; then
	echo "ERROR: Please run this script via './run infra ...' from the leyden-perf-test root directory."
	exit 3
fi

if [[ $# -gt 0 && ( "$1" == "-h" || "$1" == "--help" ) || $# -ne 2 ]]; then
	echo "This command starts/stops the required infrastructure for the tests."
	echo "Usage: ./run infra <test-suite>/<test-name> start|stop"
	echo ""
	echo "This script can be used to manually start/stop infrastructure, and is normally"
	echo "run with a <test-suite>/<test-name> argument referring to a single test. It is"
	echo "possible to pass 'all' or use wildcards but this honestly does not make much"
	echo "sense, it will just start/stop the infrastructure multiple times."
	echo ""
	echo "Run './run list' to see the list of available test suites and tests."
	exit 2
fi

source "${TEST_SRC_DIR}"/scripts/suitefuncs.sh

function run_infra() {
	local testpat=$1
	local action=$2

	local -a testfunccall
	local -a beforesuitefunccall
	local -a aftersuitefunccall
	local -a firstsuitefunccall
	local -a lastsuitefunccall

	local msg
	if [[ "${action}" == "start" ]]; then
		msg="Starting infrastructure for"
		testfunccall=("_run_command_for_test" "infra" "${msg}" "start")
		beforesuitefunccall=("_run_command_for_suite" "infra" "${msg}" "start")
		aftersuitefunccall=("_noop")
		firstsuitefunccall=("_run_command_for_suite" "infra" "${msg}" "first")
		lastsuitefunccall=("_noop")
	else
		msg="Stopping infrastructure for"
		testfunccall=("_run_command_for_test" "infra" "${msg}" "stop")
		beforesuitefunccall=("_noop")
		aftersuitefunccall=("_run_command_for_suite" "infra" "${msg}" "stop")
		firstsuitefunccall=("_noop")
		lastsuitefunccall=("_run_command_for_suite" "infra" "${msg}" "last")
	fi
	run_suite_funcs "${testpat}" testfunccall beforesuitefunccall aftersuitefunccall firstsuitefunccall lastsuitefunccall
}

case "$2" in
	start)
		run_infra "${1:-all}" "start"
		;;
	stop)
		run_infra "${1:-all}" "stop"
		;;
	*)
		echo "ERROR: Second argument must be 'start' or 'stop'."
		exit 4
		;;
esac
