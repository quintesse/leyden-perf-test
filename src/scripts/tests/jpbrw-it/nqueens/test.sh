
# The test.sh script handles all actions for the test.
# The first argument is the action to perform.
# Variables defined in shared-vars.sh are available to this script, as well as
# TEST_SUITE_NAME, TEST_SUITE_DIR, TEST_TEST_NAME, TEST_TEST_DIR and TEST_TEST_RUNID.

ACTION=${1:-}
TESTID=${2:-}

app_jar="${TEST_TEST_CACHE}/wrapper/target/quarkus-app/quarkus-run.jar"

case "${ACTION}" in
    app_start)
        if [[ -v TEST_APP_JAVA ]]; then
          require_java "${TEST_APP_JAVA}"
        fi
        eval $(jbang jdk java-env)
        compile_maven "wrapper" " -Dquarkus.package.jar.aot.enabled=true -DskipITs=false -P NQueens -Dquarkus.package.jar.aot.additional-recording-args=-XX:+UseG1GC "
        export TEST_STRAT_OPTS="-XX:AOTMode=on -XX:AOTCache=${TEST_TEST_CACHE}/wrapper/target/quarkus-app/app.aot -Xlog:${TEST_LOG_LABEL:-}aot=warning:file=${TEST_OUT_DIR}/${TEST_TEST_RUNID}.log:level,tags"
        start_app "${TESTID}" "${TEST_TEST_CACHE}/wrapper/target/quarkus-app/quarkus-run.jar"
        ;;
    app_stop)
        stop_app "${TESTID}"
        ;;
    app_setup)
        REPO_BENCHMARK_URL="https://github.com/ionutbalosin/jvm-performance-benchmarks.git"
        clone "${REPO_BENCHMARK_URL}" "benchmark"
        require_java "25"
        [[ $CLONE_CHANGED -eq 1 || ! -f "${app_jar}" ]] && compile_maven "benchmark"

        REPO_WRAPPER_URL="https://github.com/Delawen/jvm-performance-benchmarks-rest-wrapper.git"
        clone "${REPO_WRAPPER_URL}" "wrapper"
        require_java "25+"
        [[ $CLONE_CHANGED -eq 0 && -f "${app_jar}" ]] && return 0
        compile_maven "wrapper" "-Dquarkus.package.jar.aot.enabled=true -DskipITs=false"
        ;;
esac
