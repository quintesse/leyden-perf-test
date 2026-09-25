
app_jar="${TEST_TEST_CACHE}/wrapper/target/quarkus-app/quarkus-run.jar"

app_start() {
    start_app "${TEST_TEST_RUNID}" "${TEST_TEST_CACHE}/wrapper/target/quarkus-app/quarkus-run.jar"
}

app_stop() {
    stop_app "${TEST_TEST_RUNID}"
}

app_setup() {
    clone "${REPO_BENCHMARK_URL}" "benchmark"
    require_java "25"
    [[ $CLONE_CHANGED -eq 1 || ! -f "${app_jar}" ]] && compile_maven "benchmark"

    clone "${REPO_WRAPPER_URL}" "wrapper"
    require_java "25+"
    [[ $CLONE_CHANGED -eq 0 && -f "${app_jar}" ]] && return 0
    compile_maven "wrapper" "-Dquarkus.package.jar.type=aot-jar"
}

