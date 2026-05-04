
# The test.sh script handles all actions for the test.
# The first argument is the action to perform.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

ACTION=${1:-}
TESTID=${2:-}

case "${ACTION}" in
    app_start)
        start_app "${TESTID}" "${TEST_TEST_CACHE}/wrapper/target/quarkus-app/quarkus-run.jar"
        ;;
    setup)
        REPO_BENCHMARK_URL="https://github.com/ionutbalosin/jvm-performance-benchmarks.git"
        clone "${REPO_BENCHMARK_URL}" "benchmark"
        require_java "25"
        [[ $CLONE_CHANGED -eq 1 ]] && compile_maven "benchmark"

        REPO_WRAPPER_URL="https://github.com/Delawen/jvm-performance-benchmarks-rest-wrapper.git"
        clone "${REPO_WRAPPER_URL}" "wrapper"
        require_java "25+"
        [[ $CLONE_CHANGED -eq 1 ]] || return 0
        compile_maven "wrapper" "-Dquarkus.package.jar.type=aot-jar"
        ;;
esac
