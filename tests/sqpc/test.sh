
TESTID=${1:-}

app_stop() {
    stop_app "${TESTID}"
}

infra_start() {
    PG_INITDB_PATH="${TEST_TEST_CACHE}/repo/scripts/dbdata"
    POSTGRES_CONTAINER_OPTS="-v ${PG_INITDB_PATH}:/docker-entrypoint-initdb.d/:z -p 5432:5432 -e POSTGRES_USER=fruits -e POSTGRES_PASSWORD=fruits -e POSTGRES_DB=fruits"
    start_postgres "${PG_CONTAINER_NAME}" "${POSTGRES_CONTAINER_OPTS}"
}

infra_stop() {
    stop_postgres "${PG_CONTAINER_NAME}"
}

