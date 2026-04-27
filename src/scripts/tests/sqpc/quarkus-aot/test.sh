
# The test.sh script handles all actions for the test.
# The first argument is the action to perform.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

ACTION=${1:-}
TESTID=${2:-}

case "${ACTION}" in
    app_start)
        start_app "${TESTID}" "${TEST_BUILDS_DIR}/${REPO_NAME}/quarkus3/quarkus3-jar/quarkus-app/quarkus-run.jar"
        ;;
    setup)
        # Compile Quarkus app normally
        require_java "25+"
        compile_maven "${REPO_NAME}/quarkus3" "-Dquarkus.package.jar.aot.enabled=true"
        copy_build_artifacts "${REPO_NAME}/quarkus3" "quarkus3-jar" "target/quarkus-app"
        ;;
esac
