
TESTID=${1:-}

PG_CONTAINER_NAME="gqaot-tribekrd-db"

app_jar="${TEST_TEST_CACHE}/repo/quarkus-hibernate-orm-tribe-krd/target/quarkus-app/quarkus-run.jar"

app_start() {
    start_app "${TESTID}" "${app_jar}"
}

infra_setup() {
    gqaot_infra_setup "quarkus-hibernate-orm-tribe-krd"
}

infra_start() {
    gqaot_infra_start "quarkus-hibernate-orm-tribe-krd" "${PG_CONTAINER_NAME}"
}

infra_stop() {
    gqaot_infra_stop "${PG_CONTAINER_NAME}"
}

app_setup() {
    clone "${REPO_URL}"
    [[ $CLONE_CHANGED -eq 0 && -f "${app_jar}" ]] && return 0

    # Test-specific configuration (must run before compilation)
    test_repo_path="${TEST_TEST_CACHE}/repo/quarkus-hibernate-orm-tribe-krd"
    sed -i "s/localhost:5433/${TEST_INFRA_HOST:-localhost}:5432/g" "$test_repo_path/src/main/resources/application.properties"
    sed -i 's/quarkus-tribe-krd/gqaot/g' "$test_repo_path/src/main/resources/application.properties"
    sed -i 's/999-SNAPSHOT/3.32.0/g' "$test_repo_path/pom.xml"

    require_java "25+"
    compile_maven "repo/quarkus-hibernate-orm-tribe-krd" "-Dquarkus.package.jar.type=aot-jar -Dquarkus.package.jar.appcds.use-aot=true"
}

