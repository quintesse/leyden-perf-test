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

		if [[ -n "${ASYNC_PROFILER}" ]]; then
			TEST_JAVA_OPTS="${TEST_JAVA_OPTS} -agentpath:${ASYNC_PROFILER}=start,event=cpu,file=${TEST_OUT_DIR}/${results_name}-profile.jfr"
		fi
	fi
	
	local outfile="${TEST_OUT_DIR}/${results_name}-app.out"
	local cmd="java ${TEST_JAVA_OPTS} ${TEST_STRAT_OPTS} -jar \"${jar_path}\""
	echo "   - Command: $cmd"
	echo "$cmd" > "$outfile"
	java -version >> "$outfile" 2>&1

	if [[ "$DETECTED_OS" == "linux" ]]; then
		echo "Flushing disk buffers..."
		sudo sync

		echo "Purging RAM caches..."
		echo 3 | sudo tee /proc/sys/vm/drop_caches

		echo "Clearing Swap..."
		sudo swapoff -a && sudo swapon -a
	elif [[ "$DETECTED_OS" == "mac" ]]; then
		echo "Flushing disk buffers..."
		sudo sync

		echo "Purging RAM caches..."
		sudo purge
	fi

	local app_pid
	"${preamble[@]}" java ${TEST_JAVA_OPTS} ${TEST_STRAT_OPTS} -jar "${jar_path}" >> "$outfile" 2>&1 &
	app_pid=$!
	
	sleep 5 # give the application some time to start and potentially fail before we check the PID
	check_app_process "${app_pid}" "${results_name}" || return 2

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
	kill -TERM "${pid}" || true
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

# Checks if the application process is still running.
# Arguments:
#   pid          - PID of the application process
#   results_name - (optional) Base name to use for output files
# Returns:
#   0 if the process is running, 2 if it has exited
function check_app_process() {
	local pid=$1
	local results_name=$2

	if [[ -n "${app_pid}" ]] && ! kill -0 "${app_pid}" > /dev/null 2>&1; then
		echo -e "   - ${BOLD}${RED}✗ Application process has exited unexpectedly${NORMAL}"
		if [[ -n "${results_name}" ]]; then
			echo -e "   - ${BOLD}${RED}✗ ${results_name} test application not running${NORMAL}"
			sleep 2 # give time for output to be flushed
			echo -e "   - ${RED}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${NORMAL}"
			local outfile="${TEST_OUT_DIR}/${results_name}-app.out"
			cat "$outfile" 2>/dev/null || true
			echo -e "   - ${RED}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${NORMAL}"
		fi
		return 2
	fi

	return 0
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

	# Only check for the application when the caller process and application are on the same host
	local app_pid=""
	local app_host="${TEST_APP_HOST:-localhost}"
	if [[ "${app_host}" == "${HOSTNAME}" || "${app_host}" == "localhost" ]]; then
		echo "   - Waiting for port 8080..."
		app_pid=$(get_app_pid "${results_name}")
		if [[ "${app_pid}" != "" ]]; then
			echo -e "   - ${BOLD}${GREEN}✓ Application process found${NORMAL}"
		else
			echo -e "   - ${BOLD}${RED}✗ Application process not found${NORMAL}"
			return 2
		fi
	else
		echo "   - Waiting for port 8080 on ${TEST_APP_HOST:-localhost}..."
	fi

    local time=$(date +%s%N)
    for ((i=0; i<100000000; i++)); do
		check_app_process "${app_pid}" "${results_name}" || return 2
        # Using 127.0.0.1 is safer than localhost on macOS to avoid IPv6 ::1 mismatch
        if (echo -n < /dev/tcp/127.0.0.1/8080) >/dev/null 2>&1; then
			local final_time=$(($(date +%s%N) - time))
            echo "${results_name},${final_time}" >> "${TEST_OUT_DIR}/time-to-8080.csv"
			echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ Port open for ${results_name} (${i} attempts, ${final_time} ns).${NORMAL}${CLREOL}"
            return 0
        fi
    done
    echo "   - Timeout waiting for port 8080"
    return 1
}

# Ensures that the specified JDK is available and set as active.
# Arguments:
#   version - JDK to activate (either version number or path to JAVA_HOME)
# Variables used:
#   TEST_DIR - Root directory of leyden-perf-test project
function require_java() {
	local version=$1
	echo "   - Ensuring Java $version is available..."
	if [[ $1 =~ ^[0-9]+\+?$ ]]; then
		eval "$("${TEST_DIR}"/jbang jdk env "$version")"
	else
		export JAVA_HOME=$version
		export PATH="${JAVA_HOME}/bin:${PATH}"
	fi
	echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ Java $version set as active.${NORMAL}${CLREOL}"
}
