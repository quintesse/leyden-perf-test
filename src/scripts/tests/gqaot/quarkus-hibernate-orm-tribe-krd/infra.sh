#!/bin/bash

set -euo pipefail

source "${TEST_SRC_DIR}"/scripts/infrafuncs.sh

export REPO_NAME="gqaot"
export PG_INITDB_PATH="${TEST_BUILDS_DIR}/${REPO_NAME}/${TEST_TEST_NAME}/${TEST_TEST_NAME}/db"
export PG_CONTAINER_NAME="gqaot-tribekrd-db"
export POSTGRES_CONTAINER_OPTS="-v ${PG_INITDB_PATH}:/docker-entrypoint-initdb.d/:z  -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=example -e POSTGRES_DB=gqaot"

case "$1" in
	first)
		# Not doing anything here, we want a clean infra state before each test
		;;
	start)
		start_postgres "${PG_CONTAINER_NAME}" "${POSTGRES_CONTAINER_OPTS}"
		;;
	stop)
		if [ -d "$PG_INITDB_PATH" ]; then
			stop_postgres "${PG_CONTAINER_NAME}" 
		fi
		;;
	last)
		# Not used
		;;
	*)
		echo "Usage: $0 {first|start|stop|last}"
		exit 1
		;;
esac
