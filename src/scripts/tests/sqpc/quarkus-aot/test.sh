
# The test.sh script handles all actions for the test.
# The first argument is the action to perform.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

ACTION=${1:-}
TESTID=${2:-}

app_jar="${TEST_TEST_CACHE}/repo/quarkus3/target/quarkus-app/quarkus-run.jar"

case "${ACTION}" in
    app_start)
        start_app "${TESTID}" "${app_jar}"
        ;;
    app_setup)
        REPO_URL="https://github.com/quarkusio/spring-quarkus-perf-comparison.git"
        clone "${REPO_URL}"
        [[ $CLONE_CHANGED -eq 0 && -f "${app_jar}" ]] && return 0
        # Compile Quarkus app normally
        require_java "25+"
        compile_maven "repo/quarkus3" "-Dquarkus.package.jar.aot.enabled=true"
        ;;
esac
