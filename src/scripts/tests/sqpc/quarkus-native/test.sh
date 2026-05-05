
# The test.sh script handles all actions for the test.
# The first argument is the action to perform.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

ACTION=${1:-}
TESTID=${2:-}

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

case "${ACTION}" in
    app_start)
        start_app_native "${TESTID}" "${app_jar}"
        ;;
    setup)
        REPO_URL="https://github.com/quarkusio/spring-quarkus-perf-comparison.git"
        clone "${REPO_URL}"
        [[ $CLONE_CHANGED -eq 0 && -f "${app_jar}" ]] && return 0
        # Compile Quarkus app natively
        require_java "21+"
        # It should be -O2 additional build args
        compile_maven "repo/quarkus3" "-Dnative -Dquarkus.native.debug.enabled -Dquarkus.native.additional-build-args=-O0,-H:-OmitInlinedMethodDebugLineInfo"
        ;;
esac
