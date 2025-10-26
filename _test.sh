#!/bin/bash
set -euo pipefail

trap ctrl_c INT

spring_test() {
	DB_CONTAINER_NAME="fruits_db"
	DB_INITDB=./spring-quarkus-perf-comparison/scripts/dbdata
	stop_postgres > /dev/null 2>&1 # First make sure postgres not already running
	start_postgres
	echo "Starting Spring Boot test application..."
	java ${TEST_JAVA_OPTS} -jar ./spring-quarkus-perf-comparison/springboot3/target/*.jar > ${TEST_OUT_DIR}/spring-app.out &
	JAVA_PID=$!
	sleep 10
	if kill -0 $JAVA_PID > /dev/null 2>&1; then
		./_perftest_spring.sh || true
		echo "Stopping Spring Boot test application..."
		kill $JAVA_PID || true
		unset JAVA_PID
		sleep 3
	else
		echo Spring Boot application not running
	fi
	stop_postgres
}

quarkus_test() {
	DB_CONTAINER_NAME="fruits_db"
	DB_INITDB=./spring-quarkus-perf-comparison/scripts/dbdata
	stop_postgres > /dev/null 2>&1 # First make sure postgres not already running
	start_postgres
	echo "Starting Quarkus test application..."
	java -DleydenPerfTest=true ${TEST_JAVA_OPTS} -jar ./spring-quarkus-perf-comparison/quarkus3/target/quarkus-app/quarkus-run.jar > ${TEST_OUT_DIR}/quarkus-app.out &
	JAVA_PID=$!
	sleep 10
	if kill -0 $JAVA_PID > /dev/null 2>&1; then
		./_perftest_quarkus.sh || true
		echo "Stopping Quarkus test application..."
		kill $JAVA_PID || true
		unset JAVA_PID
		sleep 3
	else
		echo Quarkus application not running
	fi
	stop_postgres
}

start_postgres() {
  echo "Starting PostgreSQL server..."
  # Using MSYS_NO_PATHCONV=1 to avoid Git Bash on Windows from messing up the volume mount path
  MSYS_NO_PATHCONV=1 ${ENGINE} run -d --rm --name ${DB_CONTAINER_NAME} -v ${DB_INITDB}:/docker-entrypoint-initdb.d/ -p 5432:5432 -e POSTGRES_USER=fruits -e POSTGRES_PASSWORD=fruits -e POSTGRES_DB=fruits postgres:17 > /dev/null

  echo "Waiting for PostgreSQL to be ready..."
  timeout 90s bash -c "until ${ENGINE} exec $DB_CONTAINER_NAME pg_isready ; do sleep 5 ; done"
}

stop_postgres() {
  echo "Stopping PostgreSQL database..."
  ${ENGINE} stop ${DB_CONTAINER_NAME} || true
}

function ctrl_c() {
	echo "Caught Ctrl-C, cleaning up..."
	if [[ -n ${JAVA_PID} ]]; then
		echo "Stopping test application..."
		kill $JAVA_PID || true
	fi
	stop_postgres || true
	exit 1
}

if ! command -v oha >/dev/null 2>&1
then
    echo "Command 'oha' not found, please install it, see https://github.com/hatoo/oha"
    exit 1
fi

ENGINE=""
if command -v podman >/dev/null 2>&1; then
  ENGINE="podman"
elif command -v docker >/dev/null 2>&1; then
  ENGINE="docker"
else
  echo "Error: Neither podman nor docker can be found"
  exit_abnormal
fi

TEST_JAVA_OPTS=${TEST_JAVA_OPTS:-}
JAVA_PID=""

if [[ -z ${TEST_OUT_DIR:-} ]]; then
	TEST_OUT_DIR="."
	if [[ $1 ]]; then
		TEST_OUT_DIR="$1}"
	fi
fi

spring_test
quarkus_test

echo ""
echo Results for Spring Boot performance tests:
cat ${TEST_OUT_DIR}/spring-test.out || echo "No results found for Spring Boot"

echo ""
echo Results for Quarkus performance tests:
cat ${TEST_OUT_DIR}/quarkus-test.out || echo "No results found for Quarkus"
