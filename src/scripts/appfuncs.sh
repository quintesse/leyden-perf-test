#!/bin/bash

set -euo pipefail

# Starts a Java test application in background.
# The PID of the application is written to a file in the TEST_OUT_DIR.
# Arguments:
#   results_name - Base name to use for output files
#   jar_path     - Path to the JAR file to run
# Variables used:
#   TEST_APP_JAVA       - Java version to use (if set)
#   TEST_JAVA_OPTS      - Additional Java options to use (if set)
#   TEST_STRAT_OPTS     - Additional options added by strategies (if set)
#   TEST_OUT_DIR        - Directory where output files are written
#   HARDWARE_CONFIGURED - If set to true, use taskset and perf to monitor the application
#   TEST_APP_CPUS       - CPU cores to use with taskset and perf (if HARDWARE_CONFIGURED is true)
function start_app() {
	local results_name=$1
	local jar_path=$2
	
	if [[ -v TEST_APP_JAVA ]]; then
		require_java "${TEST_APP_JAVA}"
	fi

	TEST_JAVA_OPTS=${TEST_JAVA_OPTS:-}
	TEST_STRAT_OPTS=${TEST_STRAT_OPTS:-}

	local preamble=()
	if [[ -v HARDWARE_CONFIGURED && "$HARDWARE_CONFIGURED" == true ]]; then
		preamble=("taskset" "-c" "$TEST_DRIVER_CPUS")
	fi
	
	local outfile="${TEST_OUT_DIR}/${results_name}-app.out"
	local cmd="java ${TEST_JAVA_OPTS} ${TEST_STRAT_OPTS} -jar \"${jar_path}\""
	echo "   - Command: $cmd"
	echo "$cmd" > "$outfile"
	java -version >> "$outfile" 2>&1

	local app_pid
	"${preamble[@]}" java ${TEST_JAVA_OPTS} ${TEST_STRAT_OPTS} -jar "${jar_path}" >> "$outfile" 2>&1 &
	app_pid=$!

	if [[ -v HARDWARE_CONFIGURED && "$HARDWARE_CONFIGURED" == true ]]; then
		perf record --cpu "$TEST_APP_CPUS" -o "${TEST_OUT_DIR}/${results_name}-app.perf" -p $app_pid &
	fi

	local pidfile="${TEST_OUT_DIR}/${results_name}-app.pid"
	echo "$app_pid" > "$pidfile"
}

# Stops a running test application.
# This will read the PID from the pid file in TEST_OUT_DIR and attempt to stop the process.
# After stopping, the pid file is removed.
# Arguments:
#   results_name - Base name to use for output files
# Variables used:
#   TEST_OUT_DIR - Directory where pid files can be found
function stop_app() {
	local results_name=$1
	local app_pid
	app_pid=$(get_app_pid "${results_name}")
	if [[ "${app_pid}" == "" ]]; then
		return
	fi
	stop_process "${app_pid}" "${results_name}"
	local pidfile="${TEST_OUT_DIR}/${results_name}-app.pid"
	rm -f "${pidfile}" > /dev/null 2>&1 || true
}

# Stops all running test applications by reading pid files from TEST_OUT_DIR.
# Variables used:
#   TEST_OUT_DIR - Directory where pid files can be found
function stop_all_apps() {
	for pidfile in "${TEST_OUT_DIR}"/*-app.pid; do
		if [[ -f "${pidfile}" ]]; then
			local name
			name=$(basename "${pidfile}" "-app.pid")
			stop_app "${name}"
		fi
	done
}

# Gets the PID of a running test application.
# Arguments:
#   results_name - Base name to use for output files
# Variables used:
#   TEST_OUT_DIR - Directory where pid files can be found
# Returns:
#   PID of the application, or empty string if not found
function get_app_pid() {
	local results_name=$1
	local pidfile="${TEST_OUT_DIR}/${results_name}-app.pid"
	if [[ ! -f "${pidfile}" ]]; then
		# No pid file found, assume not running
		return
	fi
	local app_pid
	app_pid=$(cat "${pidfile}")
	if [[ ! "${app_pid}" =~ ^[0-9]+$ ]]; then
		# Not a valid PID, can't do anything anyway
		return
	fi
	echo "${app_pid}"
}

# Stops a running process by PID.
# Arguments:
#   pid          - PID of the process to stop
#   display_name - Name of the test (used for logging)
function stop_process() {
	local pid=$1
	local display_name=$2

	echo "   - Stopping ${display_name} test application (#${pid})..."
	if [[ "$(detectOs)" == "windows" ]]; then
		kill -INT "${pid}" || true
	else
		kill -TERM "${pid}" || true
	fi
	local CNT=0
	while kill -0 "${pid}" > /dev/null 2>&1 && [[ $CNT -lt 30 ]]; do
		echo "   - Waiting for ${display_name} test application to exit..."
		sleep 5
		CNT=$((CNT+1))
	done
	if kill -0 "${pid}" > /dev/null 2>&1; then
		echo "   - Killing ${display_name} test application..."
		kill -KILL "${pid}" || true
		sleep 5
	else
		echo "   - ${display_name} test application exited cleanly"
	fi
}

# Waits for the application to start listening on port 8080.
# Arguments:
#   results_name - Base name to use for output files
# Variables used:
#   TEST_OUT_DIR - Directory where output files are written
# Returns:
#   0 if port 8080 is open, 1 on timeout, 2 if application process is not running
function wait_for_8080() {
    local results_name=$1
	local app_pid
	app_pid=$(get_app_pid "${results_name}")
	if [[ "${app_pid}" == "" ]]; then
		return 2
	fi
    local time=$(date +%s%N)
    echo "   - Waiting for port 8080..."
    for ((i=0; i<60; i++)); do
		if ! kill -0 "${app_pid}" > /dev/null 2>&1; then
			echo "   - Application process has exited unexpectedly"
			sleep 2 # give time for output to be flushed
			echo "${results_name} test application not running"
			echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
			local outfile="${TEST_OUT_DIR}/${results_name}-app.out"
			cat "$outfile" 2>/dev/null || true
			echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
			return 2
        fi
        # Using 127.0.0.1 is safer than localhost on macOS to avoid IPv6 ::1 mismatch
        if (echo > /dev/tcp/127.0.0.1/8080) >/dev/null 2>&1; then
            echo "${results_name},$(($(date +%s%N) - time))" >> "${TEST_OUT_DIR}/time-to-8080.csv"
            return 0
        fi
		sleep 0.05
    done
    echo "   - Timeout waiting for port 8080"
    return 1
}

# Ensures that the specified Java version is available and set as active.
# Arguments:
#   version - Java version to require
# Variables used:
#   TEST_DIR - Root directory of leyden-perf-test project
function require_java() {
	local version=$1
	echo "   - Ensuring Java $version is available..."
	eval "$("${TEST_DIR}"/jbang jdk env "$version")"
	echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ Java $version set as active.${NORMAL}${CLREOL}"
}

# Detects the operating system.
# Returns:
#   "linux", "mac", or "windows"
function detectOs() {
	case "$(uname -s)" in
		Linux*)	echo linux;;
		Darwin*) echo mac;;
		CYGWIN*|MINGW*|MSYS*) echo windows;;
	esac
}
