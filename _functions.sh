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
		${TEST_FUNC} ${NAME}-training
		echo "AOT enabled, starting ${NAME} test run..."
		TEST_AOT_OPTS="-XX:AOTCache=${TEST_OUT_DIR}/${NAME}-app.aot"
	fi
	${TEST_FUNC} ${NAME}
}

do_test_run_with_postgres() {
	local NAME=$1
	local JAR_PATH=$2
	local TEST_FUNC=$3
	local CONTAINER_NAME=$4
	local INITDB_PATH=$5

	stop_postgres ${CONTAINER_NAME} > /dev/null 2>&1 # First make sure postgres not already running
	start_postgres ${CONTAINER_NAME} ${INITDB_PATH}

	do_test_run ${NAME} ${JAR_PATH} ${TEST_FUNC}

	stop_postgres ${CONTAINER_NAME}
}

do_test_run() {
	local NAME=$1
	local JAR_PATH=$2
	local TEST_FUNC=$3
	
	echo "Starting ${NAME} test application..."
	java -DleydenPerfTest=true ${TEST_JAVA_OPTS} ${TEST_AOT_OPTS} -jar ${JAR_PATH} > ${TEST_OUT_DIR}/${NAME}-app.out &
	JAVA_PID=$!
	sleep 10
	if kill -0 $JAVA_PID > /dev/null 2>&1; then
		${TEST_FUNC} ${NAME} || true
		echo "Stopping ${NAME} test application..."
		kill $JAVA_PID || true
        JAVA_PID=""
		sleep 3
	else
		echo ${NAME} application not running
	fi
}

start_postgres() {
	local CONTAINER_NAME=$1
	local INITDB_PATH=$2

	echo "Starting PostgreSQL server..."
	# Using MSYS_NO_PATHCONV=1 to avoid Git Bash on Windows from messing up the volume mount path
	MSYS_NO_PATHCONV=1 ${ENGINE} run -d --rm --name ${CONTAINER_NAME} -v ${INITDB_PATH}:/docker-entrypoint-initdb.d/ -p 5432:5432 -e POSTGRES_USER=fruits -e POSTGRES_PASSWORD=fruits -e POSTGRES_DB=fruits postgres:17 > /dev/null
    CONTAINER_NM=${CONTAINER_NAME}

	echo "Waiting for PostgreSQL to be ready..."
	timeout 90s bash -c "until ${ENGINE} exec ${CONTAINER_NAME} pg_isready ; do sleep 5 ; done"
}

stop_postgres() {
	local CONTAINER_NAME=$1
	
	echo "Stopping PostgreSQL database..."
	${ENGINE} stop ${CONTAINER_NAME} || true
    CONTAINER_NM=""
}

function ctrl_c() {
	echo "Caught Ctrl-C, cleaning up..."
	if [[ -n ${JAVA_PID} ]]; then
		echo "Stopping test application..."
		kill $JAVA_PID || true
        JAVA_PID=""
	fi
	if [[ -n ${CONTAINER_NM} ]]; then
		stop_postgres ${CONTAINER_NM} || true
	fi
	exit 1
}
