
# The test.sh script handles all actions for the test suite.
# The first argument is the action to perform.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR.

ACTION=${1:-}
TESTID=${2:-}

case "${ACTION}" in
    app_stop)
        stop_app "${TESTID}"
        ;;
    infra_start)
        PG_INITDB_PATH="${TEST_TEST_CACHE}/repo/scripts/dbdata"
        POSTGRES_CONTAINER_OPTS="-v ${PG_INITDB_PATH}:/docker-entrypoint-initdb.d/:z -p 5432:5432 -e POSTGRES_USER=fruits -e POSTGRES_PASSWORD=fruits -e POSTGRES_DB=fruits"
        start_postgres "${PG_CONTAINER_NAME}" "${POSTGRES_CONTAINER_OPTS}"
        ;;
    infra_stop)
        stop_postgres "${PG_CONTAINER_NAME}"
        ;;
    setup)
        REPO_URL="https://github.com/quarkusio/spring-quarkus-perf-comparison.git"
        clone "${REPO_URL}"
        ;;
esac
