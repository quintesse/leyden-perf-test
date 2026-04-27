
# The test.sh script handles all actions for the test.
# The first argument is the action to perform.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

ACTION=${1:-}
TESTID=${2:-}

case "${ACTION}" in
    app_start)
        start_app "${NAME}" "${TEST_BUILDS_DIR}/${REPO_NAME}/springboot3/spring-normal/application/springboot3.jar"
        ;;
    setup)
        # Compile Spring Boot app normally
        require_java "21+"
        compile_maven "${REPO_NAME}/springboot3" ""
        echo "   - Extracting Spring Boot Buildpack Executable..."
        target="${TEST_APPS_DIR}/${REPO_NAME}/springboot3/target"
        rm -rf "${target}/application" > /dev/null 2>&1
        java -Djarmode=tools -jar "${target}/springboot3.jar" extract --destination "${target}/application" > /dev/null
        copy_build_artifacts "${REPO_NAME}/springboot3" "spring-normal" "target/application"
        ;;
esac
