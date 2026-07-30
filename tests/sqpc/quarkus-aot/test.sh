
TESTID=${1:-}

app_jar="${TEST_TEST_CACHE}/repo/quarkus3/target/quarkus-app/quarkus-run.jar"

app_start() {
    start_app "${TESTID}" "${app_jar}"
}

app_setup() {
    clone "${REPO_URL}"
    [[ $CLONE_CHANGED -eq 0 && -f "${app_jar}" ]] && return 0

    # Make sure we connect to the right server
    REPO_DIR="repo/quarkus3"
    test_repo_path="${TEST_TEST_CACHE}/${REPO_DIR}"
    sqpc_configure_db_host "$test_repo_path/src/main/resources/application.yml"

    # Compile Quarkus app normally
    require_java "25+"
    compile_maven "${REPO_DIR}" "-Dquarkus.package.jar.aot.enabled=true"
}

