
TESTID=${1:-}

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

    local preamble=""
    if [[ -v HARDWARE_CONFIGURED && "$HARDWARE_CONFIGURED" == true ]]; then
            export LD_PRELOAD=${ASYNC_PROFILER}
            export ASPROF_COMMAND=start,event=cpu,file=${TEST_OUT_DIR}/${results_name}-profile.jfr 
            preamble="taskset -c $TEST_DRIVER_CPUS "
    fi

    local outfile="${TEST_OUT_DIR}/${results_name}-app.out"
    echo "   - Command: $preamble$exec_path"
    echo "$preamble$exec_path" > "$outfile"

    local app_pid
    $preamble$exec_path  >> "$outfile" 2>&1 &
    app_pid=$!

    export LD_PRELOAD=
    export ASPROF_COMMAND=

    local pidfile="${TEST_OUT_DIR}/${results_name}-app.pid"
    echo "$app_pid" > "$pidfile"
}

app_jar="${TEST_TEST_CACHE}/repo/quarkus3/target/quarkus3-runner"

app_start() {
    start_app_native "${TESTID}" "${app_jar}"
}

app_setup() {
    clone "${REPO_URL}"
    [[ $CLONE_CHANGED -eq 0 && -f "${app_jar}" ]] && return 0

    # Make sure we connect to the right server
    REPO_DIR="repo/quarkus3"
    test_repo_path="${TEST_TEST_CACHE}/${REPO_DIR}"
    sed -i "s/localhost:5432/${TEST_INFRA_HOST:-localhost}:5432/g" "$test_repo_path/src/main/resources/application.yml"

    # Compile Quarkus app natively
    require_java "21+"
    # It should be -O2 additional build args
    compile_maven "${REPO_DIR}" "-Dnative -Dquarkus.native.debug.enabled -Dquarkus.native.additional-build-args=-O0,-H:-OmitInlinedMethodDebugLineInfo"
}

