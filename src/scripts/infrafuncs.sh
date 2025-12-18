#!/bin/bash

set -euo pipefail

# Starts a PostgreSQL container and waits for it to be ready.
# Arguments:
#   container_name          - name of the container
#   postgres_container_opts - additional arguments to pass to the PostgreSQL container
function start_postgres() {
	local container_name=$1
	local postgres_container_opts=$2

	local postgres_conf="-c fsync=off -c synchronous_commit=off -c autovacuum=off -c full_page_writes=off -c wal_level=minimal -c archive_mode=off -c max_wal_senders=0 -c max_wal_size=4GB -c track_counts=off -c checkpoint_timeout=1h -c work_mem=32MB -c maintenance_work_mem=256MB"

	local result=0
	start_container "PostgreSQL database" "${container_name}"  "ghcr.io/quarkusio/postgres-17-perf:main" "${postgres_container_opts}" "${postgres_conf}" || result=$?
	if [[ $result -ne 0 ]]; then
		return $result
	fi
	wait_postgres "${container_name}"
}

# Waits for PostgreSQL to be ready in the specified container.
# Arguments:
#   container_name - name of the container
# Variables used:
#   TEST_ENGINE    - container runtime to use (docker or podman)
function wait_postgres() {
	local container_name=$1
	echo "Waiting for PostgreSQL to be ready..."
	timeout 90s bash -c "until ${TEST_ENGINE} exec ${container_name} pg_isready ; do sleep 5 ; done"
}

# Stops a PostgreSQL container.
# Arguments:
#   container_name - name of the container
function stop_postgres() {
	local container_name=$1
	stop_container "PostgreSQL database" "${container_name}"
}

# Starts a container for the specified application.
# Arguments:
#   display_name   - name of the application
#   container_name - name of the container
#   image          - container image to use
#   container_opts - additional options to pass to the container runtime
#   container_args - additional arguments to pass to the container
# Variables used:
#   TEST_OUT_DIR        - output directory for storing container IDs
#   TEST_TEST_RUNID     - id of the current test run (used for file names)
#   TEST_SUITE_NAME     - name of the current test suite (used as fallback for TEST_TEST_RUNID)
#   TEST_ENGINE         - container runtime to use (docker or podman)
#   HARDWARE_CONFIGURED - whether hardware tweaks can be applied
#   TEST_INFRA_CPUS     - CPUs to assign to infrastructure containers
function start_container() {
	local display_name=$1
	local container_name=$2
	local image=$3
	local container_opts=$4
	local container_args=$5

	# First make sure the container is not already running
	stop_container "${display_name}" "${container_name}" > /dev/null 2>&1 || true

	echo "Starting ${display_name}..."

	local cpuopts=()
	if [[ -v HARDWARE_CONFIGURED && "$HARDWARE_CONFIGURED" == true && -v TEST_INFRA_CPUS && -n "${TEST_INFRA_CPUS}" ]]; then
		cpuopts=("--cpuset-cpus=$TEST_INFRA_CPUS")
	fi
	
	local outfile="${TEST_OUT_DIR}/${TEST_TEST_RUNID:-${TEST_SUITE_NAME}}-${container_name}-infra.out"
	local cmd="${TEST_ENGINE} run -d --rm --name ${container_name} ${cpuopts[*]} ${container_opts} ${image} ${container_args}"
	echo "   - Container: $cmd"
	echo "$cmd" > "$outfile"
	# Using MSYS_NO_PATHCONV=1 to avoid Git Bash on Windows from messing up any volume mount paths
	local result=0
	MSYS_NO_PATHCONV=1 ${TEST_ENGINE} run -d --rm --name "${container_name}" "${cpuopts[@]}" ${container_opts} "${image}" ${container_args} >> "$outfile" 2>&1 || result=$?
	if [[ $result -ne 0 ]]; then
		echo -e "   - ${NORMAL}${RED}Error: Failed to start container ${display_name}.${NORMAL}"
		cat "$outfile" 2>/dev/null || true
		return $result
	fi

	local cidfile="${TEST_OUT_DIR}/${TEST_TEST_RUNID:-${TEST_SUITE_NAME}}-${container_name}.cid"
	echo "${container_name}" >> "${cidfile}"
}

# Stops a container for the specified application.
# Arguments:
#   display_name   - name of the application
#   container_name - name of the container
# Variables used:
#   TEST_OUT_DIR    - output directory for storing container IDs
#   TEST_TEST_RUNID - id of the current test run (used for file names)
#   TEST_SUITE_NAME - name of the current test suite (used as fallback for TEST_TEST_RUNID)
#   TEST_ENGINE     - container runtime to use (docker or podman)
function stop_container() {
	local display_name=$1
	local container_name=$2
	echo "Stopping ${display_name}..."
	${TEST_ENGINE} stop "${container_name}" || true
	local cidfile="${TEST_OUT_DIR}/${TEST_TEST_RUNID:-${TEST_SUITE_NAME}}-${container_name}.cid"
	rm -f "${cidfile}" > /dev/null 2>&1 || true
}

# Stops all running containers started during the test run.
# Variables used:
#   TEST_OUT_DIR   - output directory for storing container IDs
function stop_all_containers() {
	for cidfile in "${TEST_OUT_DIR}"/*.cid; do
		if [[ -f "${cidfile}" ]]; then
			local container_name
			read -r container_name < "${cidfile}"
			stop_container "container" "${container_name}"
		fi
	done
}
