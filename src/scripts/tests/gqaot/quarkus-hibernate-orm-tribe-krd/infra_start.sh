
export PG_CONTAINER_NAME="gqaot-tribekrd-db"
export PG_INITDB_PATH="${TEST_BUILDS_DIR}/${REPO_NAME}/${TEST_TEST_NAME}/${TEST_TEST_NAME}/db"
export POSTGRES_CONTAINER_OPTS="-v ${PG_INITDB_PATH}:/docker-entrypoint-initdb.d/:z  -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=example -e POSTGRES_DB=gqaot"

start_postgres "${PG_CONTAINER_NAME}" "${POSTGRES_CONTAINER_OPTS}"
