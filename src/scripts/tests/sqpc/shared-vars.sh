#!/bin/bash

export REPO_NAME="sqpc"
export REPO_URL="https://github.com/quarkusio/spring-quarkus-perf-comparison.git"

export PG_CONTAINER_NAME="fruits_db"
export PG_INITDB_PATH="${TEST_APPS_DIR}/${REPO_NAME}/scripts/dbdata"
export POSTGRES_CONTAINER_OPTS="-v ${PG_INITDB_PATH}:/docker-entrypoint-initdb.d/:z -p 5432:5432 -e POSTGRES_USER=fruits -e POSTGRES_PASSWORD=fruits -e POSTGRES_DB=fruits"
