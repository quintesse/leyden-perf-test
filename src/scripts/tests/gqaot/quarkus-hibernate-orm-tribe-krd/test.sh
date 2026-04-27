
# The test.sh script handles all actions for the test.
# The first argument is the action to perform.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

ACTION=${1:-}
TESTID=${2:-}

PG_CONTAINER_NAME="gqaot-tribekrd-db"

case "${ACTION}" in
    app_start)
        start_app "${TESTID}" "${TEST_BUILDS_DIR}/${REPO_NAME}/quarkus-hibernate-orm-tribe-krd/quarkus-hibernate-orm-tribe-krd/quarkus-run.jar"
        ;;
    infra_start)
        PG_INITDB_PATH="${TEST_BUILDS_DIR}/${REPO_NAME}/${TEST_TEST_NAME}/${TEST_TEST_NAME}/db"
        POSTGRES_CONTAINER_OPTS="-v ${PG_INITDB_PATH}:/docker-entrypoint-initdb.d/:z  -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=example -e POSTGRES_DB=gqaot"
        start_postgres "${PG_CONTAINER_NAME}" "${POSTGRES_CONTAINER_OPTS}"
        ;;
    infra_stop)
        stop_postgres "${PG_CONTAINER_NAME}" 
        ;;
    setup)
        test_repo_path=${TEST_APPS_DIR}/${REPO_NAME}/quarkus-hibernate-orm-tribe-krd
        test_build_path="${TEST_BUILDS_DIR}/${REPO_NAME}/quarkus-hibernate-orm-tribe-krd/quarkus-hibernate-orm-tribe-krd"

        sed -i 's/localhost:5433/localhost:5432/g' "$test_repo_path/src/main/resources/application.properties"
        sed -i 's/quarkus-tribe-krd/gqaot/g' "$test_repo_path/src/main/resources/application.properties"
        sed -i 's/999-SNAPSHOT/3.32.0/g' "$test_repo_path/pom.xml"

        require_java "25+"
        compile_maven "${REPO_NAME}/quarkus-hibernate-orm-tribe-krd" "-Dquarkus.package.jar.type=aot-jar -Dquarkus.package.jar.appcds.use-aot=true"
        copy_build_artifacts "${REPO_NAME}/quarkus-hibernate-orm-tribe-krd" "quarkus-hibernate-orm-tribe-krd" "target/quarkus-app/app" "target/quarkus-app/lib" "target/quarkus-app/quarkus" "target/quarkus-app/quarkus-app-dependencies.txt" "target/quarkus-app/quarkus-run.jar"

        rm -rf "${test_build_path:?}/db"
        mkdir -p "$test_build_path/db"
        cp -a "${TEST_TEST_DIR}/initdb.sql" "$test_build_path/db"
        echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ SQL pre-seeding database script for 'quarkus-hibernate-orm-tribe-krd' copied.${NORMAL}${CLREOL}"
        ;;
esac
