
TESTID=${1:-}

app_stop() {
    stop_app "${TESTID}"
}

# Helper function for gqaot tests with database infrastructure
# Arguments:
#   $1 - test name (e.g., "quarkus-hibernate-orm-simple")
#   $2 - container name (e.g., "gqaot-simpleorm-db")
gqaot_infra_setup() {
    local test_name=$1
    clone "${REPO_URL}"
    
    # Prepare database init files on infra host
    test_repo_path="${TEST_TEST_CACHE}/repo/${test_name}"
    rm -rf "${test_repo_path:?}/db"
    mkdir -p "$test_repo_path/db"
    cp -a "${TEST_TEST_DIR}/initdb.sql" "$test_repo_path/db"
    echo -e "${CURUP}   - ${NORMAL}${GREEN}✓ SQL pre-seeding database script for '${test_name}' copied.${NORMAL}${CLREOL}"
}

gqaot_infra_start() {
    local test_name=$1
    local container_name=$2
    PG_INITDB_PATH="${TEST_TEST_CACHE}/repo/${test_name}/db"
    POSTGRES_CONTAINER_OPTS="-v ${PG_INITDB_PATH}:/docker-entrypoint-initdb.d/:z  -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=example -e POSTGRES_DB=gqaot"
    start_postgres "${container_name}" "${POSTGRES_CONTAINER_OPTS}"
}

gqaot_infra_stop() {
    local container_name=$1
    stop_postgres "${container_name}"
}
