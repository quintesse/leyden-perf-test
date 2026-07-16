
TESTID=${1:-}

app_jar="${TEST_TEST_CACHE}/repo/quarkus3/target/quarkus-app/quarkus-run.jar"

app_start() {
    start_app "${TESTID}" "${app_jar}"
}

app_setup() {
    REPO_URL="https://github.com/quarkusio/spring-quarkus-perf-comparison.git"
    clone "${REPO_URL}"
    [[ $CLONE_CHANGED -eq 0 && -f "${app_jar}" ]] && return 0

    # Make sure we connect to the right server
    REPO_DIR="repo/quarkus3"
    test_repo_path="${TEST_TEST_CACHE}/${REPO_DIR}"
    sed -i "s/localhost:5432/${TEST_INFRA_HOST:-localhost}:5432/g" "$test_repo_path/src/main/resources/application.yml"

    # Compile Quarkus app normally
    require_java "25+"
    compile_maven "${REPO_DIR}" "-Dquarkus.package.jar.aot.enabled=true"
}

