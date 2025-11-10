#!/bin/bash
set -euo pipefail

do_aot_test_run() {
	local NAME=$1
	local TEST_FUNC=$2
    local USE_AOT=${3:-false}

	TEST_AOT_OPTS=""
	if [[ "${USE_AOT}" == "true" ]]; then
		echo "AOT enabled, starting ${NAME} training run..."
		TEST_AOT_OPTS="-XX:AOTCacheOutput=${TEST_OUT_DIR}/${NAME}-app.aot"
		${TEST_FUNC} "${NAME}"-training
		echo "AOT enabled, starting ${NAME} test run..."
		TEST_AOT_OPTS="-XX:AOTCache=${TEST_OUT_DIR}/${NAME}-app.aot"
	fi
	${TEST_FUNC} "${NAME}"
}

do_test_run_with_postgres() {
	local NAME=$1
	local JAR_PATH=$2
	local TEST_FUNC=$3
	local CONTAINER_NAME=$4
	local INITDB_PATH=$5

	stop_postgres "${CONTAINER_NAME}" > /dev/null 2>&1 # First make sure postgres not already running
	start_postgres "${CONTAINER_NAME}" "${INITDB_PATH}"

	do_test_run "${NAME}" "${JAR_PATH}" "${TEST_FUNC}"

	stop_postgres "${CONTAINER_NAME}"
}

do_test_run() {
	local NAME=$1
	local JAR_PATH=$2
	local TEST_FUNC=$3
	
	echo "Starting ${NAME} test application..."
	echo java "${TEST_JAVA_OPTS}" "${TEST_AOT_OPTS}" -jar "${JAR_PATH}" > "${TEST_OUT_DIR}"/"${NAME}"-app.out
	java "${TEST_JAVA_OPTS}" "${TEST_AOT_OPTS}" -jar "${JAR_PATH}" >> "${TEST_OUT_DIR}"/"${NAME}"-app.out 2>&1 &
	JAVA_PID=$!
	sleep 10
	if kill -0 ${JAVA_PID} > /dev/null 2>&1; then
		echo "Running tests for ${NAME}..."
		${TEST_FUNC} "${NAME}" || true
		stop_process ${JAVA_PID} "${NAME}"
        JAVA_PID=""
	else
		echo "${NAME}" test application not running
	fi
}

start_postgres() {
	local CONTAINER_NAME=$1
	local INITDB_PATH=$2

	echo "Starting PostgreSQL server..."
	# Using MSYS_NO_PATHCONV=1 to avoid Git Bash on Windows from messing up the volume mount path
	MSYS_NO_PATHCONV=1 ${ENGINE} run -d --rm --name "${CONTAINER_NAME}" -v "${INITDB_PATH}":/docker-entrypoint-initdb.d/ -p 5432:5432 -e POSTGRES_USER=fruits -e POSTGRES_PASSWORD=fruits -e POSTGRES_DB=fruits docker.io/library/postgres:17 > /dev/null
    CONTAINER_NM=${CONTAINER_NAME}

	echo "Waiting for PostgreSQL to be ready..."
	timeout 90s bash -c "until ${ENGINE} exec ${CONTAINER_NAME} pg_isready ; do sleep 5 ; done"
}

stop_postgres() {
	local CONTAINER_NAME=$1
	
	echo "Stopping PostgreSQL database..."
	${ENGINE} stop "${CONTAINER_NAME}" || true
    CONTAINER_NM=""
}

stop_process() {
	local pid=$1
	local name=$2

	echo "Stopping ${name} test application..."
	if [[ "${OS}" == "windows" ]]; then
		kill -INT "${pid}" || true
	else
		kill -TERM "${pid}" || true
	fi
	local CNT=0
	while kill -0 "${pid}" > /dev/null 2>&1 && [[ $CNT -lt 12 ]]; do
		echo "Waiting for ${name} test application to exit..."
		sleep 5
		CNT=$((CNT+1))
	done
	if kill -0 "${pid}" > /dev/null 2>&1; then
		echo "Killing ${name} test application..."
		kill -KILL "${pid}" || true
		sleep 5
	else
		echo "${name} test application exited cleanly"
	fi
}

function ctrl_c() {
	echo "Caught Ctrl-C, cleaning up..."
	if [[ -n ${JAVA_PID} ]]; then
		echo "Killing test application..."
		kill -KILL "${JAVA_PID}" || true
        JAVA_PID=""
	fi
	if [[ -n ${CONTAINER_NM} ]]; then
		stop_postgres "${CONTAINER_NM}" || true
	fi
	exit 1
}

case "$(uname -s)" in
  Linux*)
    export OS=linux
    ;;
  Darwin*)
    export OS=mac
    ;;
  CYGWIN*|MINGW*|MSYS*)
    export OS=windows
	;;
  *)
    export OS=
esac
