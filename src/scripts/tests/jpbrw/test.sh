
# The test.sh script handles all actions for the test.
# Actions are dispatched by scripts/launcher.sh. Positional args start with TESTID.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.


TESTID=${1:-}

app_jar="${TEST_TEST_CACHE}/wrapper/target/quarkus-app/quarkus-run.jar"

app_start() {
    start_app "${TESTID}" "${TEST_TEST_CACHE}/wrapper/target/quarkus-app/quarkus-run.jar"
}

app_stop() {
    stop_app "${TESTID}"
}

setup() {
    REPO_BENCHMARK_URL="https://github.com/ionutbalosin/jvm-performance-benchmarks.git"
    clone "${REPO_BENCHMARK_URL}" "benchmark"
    require_java "25"
    [[ $CLONE_CHANGED -eq 1 || ! -f "${app_jar}" ]] && compile_maven "benchmark"

    REPO_WRAPPER_URL="https://github.com/Delawen/jvm-performance-benchmarks-rest-wrapper.git"
    clone "${REPO_WRAPPER_URL}" "wrapper"
    require_java "25+"
    [[ $CLONE_CHANGED -eq 0 && -f "${app_jar}" ]] && return 0
    compile_maven "wrapper" "-Dquarkus.package.jar.type=aot-jar"
}

