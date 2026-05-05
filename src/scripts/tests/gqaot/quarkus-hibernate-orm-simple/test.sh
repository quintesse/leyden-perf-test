
# The test.sh script handles all actions for the test.
# The first argument is the action to perform.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

ACTION=${1:-}
TESTID=${2:-}

PG_CONTAINER_NAME="gqaot-simpleorm-db"

app_jar="${TEST_TEST_CACHE}/repo/quarkus-hibernate-orm-simple/target/quarkus-app/quarkus-run.jar"

case "${ACTION}" in
    app_start)
        start_app "${TESTID}" "${app_jar}"
        ;;
    infra_start)
        PG_INITDB_PATH="${TEST_TEST_CACHE}/repo/quarkus-hibernate-orm-simple/db"
        POSTGRES_CONTAINER_OPTS="-v ${PG_INITDB_PATH}:/docker-entrypoint-initdb.d/:z  -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=example -e POSTGRES_DB=gqaot"
        start_postgres "${PG_CONTAINER_NAME}" "${POSTGRES_CONTAINER_OPTS}"
        ;;
    infra_stop)
        stop_postgres "${PG_CONTAINER_NAME}" 
        ;;
    setup)
        REPO_URL="https://github.com/gsmet/quarkus-aot.git"
        clone "${REPO_URL}"
        [[ $CLONE_CHANGED -eq 0 && -f "${app_jar}" ]] && return 0

        test_repo_path="${TEST_TEST_CACHE}/repo/quarkus-hibernate-orm-simple"

        sed -i 's/localhost:5434/localhost:5432/g' "$test_repo_path/src/main/resources/application.properties"
        sed -i 's/quarkus-simple/gqaot/g' "$test_repo_path/src/main/resources/application.properties"
        sed -i 's/999-SNAPSHOT/3.32.0/g' "$test_repo_path/pom.xml"

        require_java "25+"
        compile_maven "repo/quarkus-hibernate-orm-simple" "-Dquarkus.package.jar.type=aot-jar -Dquarkus.package.jar.appcds.use-aot=true"

        rm -rf "${test_repo_path:?}/db"
        mkdir -p "$test_repo_path/db"
        cp -a "${TEST_TEST_DIR}/initdb.sql" "$test_repo_path/db"
        echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ SQL pre-seeding database script for 'quarkus-hibernate-orm-simple' copied.${NORMAL}${CLREOL}"
        ;;
esac
