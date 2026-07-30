
TESTID=${1:-}

app_jar="${TEST_TEST_CACHE}/repo/springboot3/target/application/springboot3.jar"

app_start() {
    TEST_JAVA_OPTS="${TEST_JAVA_OPTS:-} -Dspring.aot.enabled=true -Dotel.sdk.disabled=true"
    start_app "${TESTID}" "${app_jar}"
}

app_setup() {
    clone "${REPO_URL}"
    [[ $CLONE_CHANGED -eq 0 && -f "${app_jar}" ]] && return 0

    # Make sure we connect to the right server
    REPO_DIR="repo/springboot3"
    test_repo_path="${TEST_TEST_CACHE}/${REPO_DIR}"
    sqpc_configure_db_host "$test_repo_path/src/main/resources/application.yml"

    # Compile Spring Boot app as Spring Boot Buildpack Executable
    # Which means preparing for AOT cache and production environment
    # As described in https://docs.spring.io/spring-boot/reference/packaging/efficient.html
    # and in https://docs.spring.io/spring-boot/reference/packaging/aot.html
    require_java "21+"
    compile_maven "${REPO_DIR}" "-Pnative"
    target="${TEST_TEST_CACHE}/${REPO_DIR}/target"
    sqpc_extract_spring_boot_jar "${target}/springboot3.jar" "${target}/application"
}

