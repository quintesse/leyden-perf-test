
# The test.sh script handles all actions for the test suite.
# The first argument is the action to perform.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR.

ACTION=${1:-}
TESTID=${2:-}

case "${ACTION}" in
    app_stop)
        stop_app "${TESTID}"
        ;;
    setup)
        REPO_BENCHMARK_URL="https://github.com/ionutbalosin/jvm-performance-benchmarks.git"
        REPO_WRAPPER_URL="https://github.com/Delawen/jvm-performance-benchmarks-rest-wrapper.git"
        clone "${REPO_NAME}-benchmark" "${REPO_BENCHMARK_URL}"
        clone "${REPO_NAME}-wrapper" "${REPO_WRAPPER_URL}"
        ;;
esac
