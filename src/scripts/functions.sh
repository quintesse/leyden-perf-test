#!/bin/bash
set -euo pipefail

function compile_maven() {
    local repository=$1
	local opts=$2

    echo "Compiling application '$repository'..."
    pushd "apps/$repository" > /dev/null
    ./mvnw clean package -DskipTests $opts > /tmp/leyden-perf-test-build-$$.log 2>&1
    local result=$?
    if [ $result -ne 0 ]; then
       echo -e "   - \033[0;31m✗ '$repository' failed to build.\033[0m"
	   cat /tmp/leyden-perf-test-build-$$.log
    else 
       echo -e "   - \033[0;32m✓ '$repository' built.\033[0m"
	   rm /tmp/leyden-perf-test-build-$$.log
    fi
    popd > /dev/null
    return $result
}

function copy_build_artifacts() {
	local repository=$1
	local subfolder=$2
	local artifacts=( "${@:3}" )

	local dest="${TEST_BUILDS_DIR}/$repository/$subfolder"
	echo "Copying build artifacts for '$repository' to '$dest'..."
	rm -rf "${dest:?}"
	mkdir -p "$dest"
	pushd "$TEST_APPS_DIR/$repository" > /dev/null
	cp -a "${artifacts[@]}" "$dest"
	popd > /dev/null
}

function do_aot_test_run() {
	local NAME=$1
	local TEST_FUNC=$2
    local USE_AOT=${3:-false}

	TEST_AOT_OPTS=""
	if [[ "${USE_AOT}" == "true" ]]; then
		echo "AOT enabled, starting ${NAME} training run..."
		TEST_AOT_OPTS="-XX:AOTCacheOutput=${TEST_OUT_DIR}/${NAME}-app.aot -Xlog:aot+map=trace,aot+map+oops=trace:file=${TEST_OUT_DIR}/${NAME}-aot.map:none:filesize=0 -Xlog:aot+resolve*=trace,aot+codecache+exit=debug,aot=warning:file=${TEST_OUT_DIR}/${NAME}-training.log:level,tags"
		${TEST_FUNC} "${NAME}"-training
		echo "AOT enabled, starting ${NAME} test run..."
		TEST_AOT_OPTS="-XX:AOTCache=${TEST_OUT_DIR}/${NAME}-app.aot -Xlog:class+load=info,aot+codecache=debug:file=${TEST_OUT_DIR}/${NAME}-production.log:level,tags"
	fi
	${TEST_FUNC} "${NAME}"
}

function do_test_run_with_postgres() {
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

function do_test_run() {
	local NAME=$1
	local JAR_PATH=$2
	local TEST_FUNC=$3
	
	echo "Starting ${NAME} test application..."
	local outfile="${TEST_OUT_DIR}/${NAME}-app.out"
	local cmd="java ${TEST_JAVA_OPTS} ${TEST_AOT_OPTS} -jar \"${JAR_PATH}\""
	echo "Command: $cmd"
	echo "$cmd" > "$outfile"
	if [ $HARDWARE_CONFIGURED == true ];then
            java ${TEST_JAVA_OPTS} ${TEST_AOT_OPTS} -jar "${JAR_PATH}" >> "$outfile" 2>&1 &
	    JAVA_PID=$!
            taskset --pid -c $PROCESSORS_TO_USE $JAVA_PID &
            perf record --cpu $PROCESSORS_TO_USE -o ${TEST_OUT_DIR}/${NAME}.perf -p $JAVA_PID &
	else
	    java ${TEST_JAVA_OPTS} ${TEST_AOT_OPTS} -jar "${JAR_PATH}" >> "$outfile" 2>&1 &
	    JAVA_PID=$!
	fi
	
	wait_for_8080 ${NAME} "${TEST_OUT_DIR}/time-to-8080.csv"

	if kill -0 ${JAVA_PID} > /dev/null 2>&1; then
		echo "Running tests for ${NAME}..."
		${TEST_FUNC} "${NAME}" || true
		stop_process ${JAVA_PID} "${NAME}"
        JAVA_PID=""
	else
		echo "${NAME} test application not running"
		echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		cat "$outfile"
		echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	fi
}

function start_postgres() {
	local CONTAINER_NAME=$1
	local INITDB_PATH=$2

	echo "Starting PostgreSQL server..."
	# Using MSYS_NO_PATHCONV=1 to avoid Git Bash on Windows from messing up the volume mount path
	MSYS_NO_PATHCONV=1 ${ENGINE} run -d --rm --name "${CONTAINER_NAME}" -v "${INITDB_PATH}":/docker-entrypoint-initdb.d/ -p 5432:5432 -e POSTGRES_USER=fruits -e POSTGRES_PASSWORD=fruits -e POSTGRES_DB=fruits docker.io/library/postgres:17 > /dev/null
    CONTAINER_NM=${CONTAINER_NAME}

	echo "Waiting for PostgreSQL to be ready..."
	timeout 90s bash -c "until ${ENGINE} exec ${CONTAINER_NAME} pg_isready ; do sleep 5 ; done"
}

function stop_postgres() {
	local CONTAINER_NAME=$1
	
	echo "Stopping PostgreSQL database..."
	${ENGINE} stop "${CONTAINER_NAME}" || true
    CONTAINER_NM=""
}

function stop_process() {
	local pid=$1
	local name=$2

	echo "Stopping ${name} test application (#${pid})..."
	if [[ "${OS}" == "windows" ]]; then
		kill -INT "${pid}" || true
	else
		kill -TERM "${pid}" || true
	fi
	local CNT=0
	while kill -0 "${pid}" > /dev/null 2>&1 && [[ $CNT -lt 30 ]]; do
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

function save_jdk() {
	local currentJdkVersionString

	currentJdkVersionString=$(jbang jdk default 2>&1)
	export SAVEDJDKVERSION=${currentJdkVersionString##* }
}

function switch_jdk() {
	local version=$1

	echo "Switching JDK to ${version}..."
	./jbang jdk default "${version}"
}

function restore_jdk() {
    if [[ -v SAVEDJDKVERSION ]]; then
        echo "Restoring JDK to ${SAVEDJDKVERSION}..."
        switch_jdk "${SAVEDJDKVERSION}"
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


wait_for_8080() {
    local time=$(date +%s%N)
    local name=$1
    local file=$2
    echo "Waiting for port 8080..."
    for ((i=0; i<60; i++)); do
        # Using 127.0.0.1 is safer than localhost on macOS to avoid IPv6 ::1 mismatch
        if (echo > /dev/tcp/127.0.0.1/8080) >/dev/null 2>&1; then
            echo $name","$(expr $(date +%s%N) - $time) >> $file
            return 0
        fi
        sleep .3
    done
    echo "Timeout waiting for port 8080"
    return 1
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
