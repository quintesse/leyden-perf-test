#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/infrafuncs.sh

export PG_INITDB_PATH="${TEST_SRC_DIR}/scripts/tests/gqaot/db/"
export PG_CONTAINER_NAME="db-trike-krd"
export POSTGRES_CONTAINER_OPTS="-v ${PG_INITDB_PATH}:/docker-entrypoint-initdb.d/:z  -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=example -e POSTGRES_DB=quarkus-tribe-krd"

case "$1" in
	first)
		# Not doing anything here, we want a clean infra state before each test
		;;
	start)
		start_postgres "${PG_CONTAINER_NAME}" "${POSTGRES_CONTAINER_OPTS}"
		;;
	stop)
		stop_postgres "${PG_CONTAINER_NAME}"
		;;
	last)
		# Not used
		;;
	*)
		echo "Usage: $0 {first|start|stop|last}"
		exit 1
		;;
esac
