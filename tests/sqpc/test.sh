
TESTID=${1:-}

app_stop() {
    stop_app "${TESTID}"
}

infra_setup() {
    clone "${REPO_URL}"
}

# Helper function to configure database connection for sqpc tests
# Arguments:
#   $1 - path to the application.yml file
sqpc_configure_db_host() {
    local app_yml_path=$1
    sed -i "s/localhost:5432/${TEST_INFRA_HOST:-localhost}:5432/g" "$app_yml_path"
}

# Helper function to extract Spring Boot buildpack executable
# Arguments:
#   $1 - path to the Spring Boot jar file (e.g., "${target}/springboot3.jar")
#   $2 - destination directory (e.g., "${target}/application")
sqpc_extract_spring_boot_jar() {
    local jar_path=$1
    local dest_dir=$2
    echo "   - Extracting Spring Boot Buildpack Executable..."
    rm -rf "${dest_dir}" > /dev/null 2>&1
    java -Djarmode=tools -jar "${jar_path}" extract --destination "${dest_dir}" > /dev/null
}

infra_start() {
    PG_INITDB_PATH="${TEST_TEST_CACHE}/repo/scripts/dbdata"
    POSTGRES_CONTAINER_OPTS="-v ${PG_INITDB_PATH}:/docker-entrypoint-initdb.d/:z -p 5432:5432 -e POSTGRES_USER=fruits -e POSTGRES_PASSWORD=fruits -e POSTGRES_DB=fruits"
    start_postgres "${PG_CONTAINER_NAME}" "${POSTGRES_CONTAINER_OPTS}"
}

infra_stop() {
    stop_postgres "${PG_CONTAINER_NAME}"
}

