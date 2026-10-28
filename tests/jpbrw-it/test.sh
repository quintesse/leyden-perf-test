#!/bin/bash

set -euo pipefail

app_jar="${TEST_TEST_CACHE}/wrapper/target/quarkus-app/quarkus-run.jar"
app_aot="${TEST_TEST_CACHE}/wrapper/target/quarkus-app/app.aot"
app_aot_jdk="${app_aot}.jdk"

skip_aot_training() {
    if [[ "${TEST_STRATEGY:-}" == "aot" && "${TEST_RUN_TAG:-}" == "training" ]]; then
        info "jpbrw-it generates its own AOT cache; skipping aot strategy training." >&2
        return 1
    fi
}

app_start() {
    skip_aot_training || return 0

    local wrapper_profile
    case "${TEST_TEST_NAME}" in
        nqueens) wrapper_profile=NQueens ;;
        fibonacci) wrapper_profile=Fibonacci ;;
        if-conditional-branch) wrapper_profile=Conditional ;;
        dead-loop) wrapper_profile=DeadLoo ;;
        *) echo "Error: Unknown jpbrw-it workload: ${TEST_TEST_NAME}" >&2; return 1 ;;
    esac

    # Always retrain: the shared test cache is reused across JDKs and runs.
    # Invalidate first so a failed build cannot leave a usable stale cache.
    rm -f "${app_aot}" "${app_aot_jdk}"

    require_java
    compile_maven "wrapper" "-Dquarkus.package.jar.aot.enabled=true -DskipITs=false -P ${wrapper_profile} -Dquarkus.package.jar.aot.additional-recording-args=-XX:+UseG1GC "
    if [[ ! -s "${app_jar}" || ! -s "${app_aot}" ]]; then
        fail "jpbrw-it training did not produce the application and a non-empty AOT cache." >&2
        return 1
    fi
    export TEST_STRAT_OPTS="-XX:AOTMode=on -XX:AOTCache=${TEST_TEST_CACHE}/wrapper/target/quarkus-app/app.aot -Xlog:${TEST_LOG_LABEL:-}aot=warning:file=${TEST_OUT_DIR}/${TEST_TEST_RUNID}.log:level,tags"
    start_app "${TEST_TEST_RUNID}" "${app_jar}"
}

app_stop() {
    skip_aot_training || return 0
    stop_app "${TEST_TEST_RUNID}"
}

app_setup() {
    skip_aot_training || return 0

    clone "${REPO_WRAPPER_URL}" "wrapper"

    clone "${REPO_BENCHMARK_URL}" "benchmark"
    if [[ $CLONE_CHANGED -ne 0 || ! -f "${app_jar}" ]]; then
        require_java "25"
        compile_maven "benchmark"
    fi
}

driver_run() {
    skip_aot_training || return 0
    run_driver
}
