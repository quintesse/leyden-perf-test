
# The test.sh script handles all actions for the test.
# The first argument is the action to perform.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

ACTION=${1:-}
TESTID=${2:-}

app_jar="${TEST_TEST_CACHE}/repo/springboot3/target/application/springboot3.jar"

case "${ACTION}" in
    app_start)
        TEST_JAVA_OPTS="${TEST_JAVA_OPTS:-} -Dspring.aot.enabled=true" start_app "${TESTID}" "${app_jar}"
        ;;
    app_setup)
        REPO_URL="https://github.com/quarkusio/spring-quarkus-perf-comparison.git"
        clone "${REPO_URL}"
        [[ $CLONE_CHANGED -eq 0 && -f "${app_jar}" ]] && return 0
        # Compile Spring Boot app as Spring Boot Buildpack Executable
        # Which means preparing for AOT cache and production environment
        # As described in https://docs.spring.io/spring-boot/reference/packaging/efficient.html
        # and in https://docs.spring.io/spring-boot/reference/packaging/aot.html
        require_java "21+"
        compile_maven "repo/springboot3" "-Pnative"
        echo "   - Extracting Spring Boot Buildpack Executable..."
        target="${TEST_TEST_CACHE}/repo/springboot3/target"
        rm -rf "${target}/application" > /dev/null 2>&1
        java -Djarmode=tools -jar "${target}/springboot3.jar" extract --destination "${target}/application" > /dev/null
        ;;
esac
