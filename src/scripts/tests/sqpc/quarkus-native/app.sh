#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/appfuncs.sh
source "${TEST_SUITE_DIR}/shared-vars.sh"

CMD=$1
NAME=${2:-sqpc-quarkus-native}


# Starts a native test application in background.
# The PID of the application is written to a file in the TEST_OUT_DIR.
# Arguments:
#   results_name - Base name to use for output files
#   exec_path     - Path to the application to run
# Variables used:
#   TEST_OUT_DIR        - Directory where output files are written
#   HARDWARE_CONFIGURED - If set to true, use taskset and perf to monitor the application
#   TEST_APP_CPUS       - CPU cores to use with taskset and perf (if HARDWARE_CONFIGURED is true)
function start_app_native() {
	local results_name=$1
	local exec_path=$2

	local preamble=()
	if [[ -v HARDWARE_CONFIGURED && "$HARDWARE_CONFIGURED" == true ]]; then
		preamble=("taskset" "-c" "$TEST_DRIVER_CPUS" " ")
	fi
	
	local outfile="${TEST_OUT_DIR}/${results_name}-app.out"
	echo "   - Command: $exec_path"
	echo "${preamble[@]}" "'$exec_path'" > "$outfile"

	local app_pid
	eval "${preamble[@]}" "'$exec_path'" >> "$outfile" 2>&1 &
	app_pid=$!

	if [[ -v HARDWARE_CONFIGURED && "$HARDWARE_CONFIGURED" == true ]]; then
		perf record --cpu "$TEST_APP_CPUS" -o "${TEST_OUT_DIR}/${results_name}-app.perf" -p $app_pid &
	fi

	local pidfile="${TEST_OUT_DIR}/${results_name}-app.pid"
	echo "$app_pid" > "$pidfile"
}


case "${CMD}" in
	start)
		start_app_native "${NAME}" "${TEST_BUILDS_DIR}/${REPO_NAME}/quarkus3/quarkus3-native/quarkus3-runner"
		;;
	stop)
		stop_app "${NAME}"
		;;
	*)
		echo "Usage: $0 {start|stop}"
		exit 1
		;;
esac
