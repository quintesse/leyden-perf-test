#!/usr/bin/env bats

setup() {
    REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../.." && pwd)"
    export TEST_TEST_CACHE="${BATS_TEST_TMPDIR}/cache"
    export TEST_OUT_DIR="${BATS_TEST_TMPDIR}/output"
    export TEST_TEST_NAME=fibonacci TEST_TEST_RUNID=jpbrw-it-fibonacci
    export TEST_APP_JAVA=26 JAVA_HOME=/fake/jdk26
    export TEST_STRAT_OPTS="" TEST_STRATEGY=normal TEST_RUN_TAG=""
    export MOCK_CACHE=true MOCK_BUILD_FAILURE=false MOCK_CLONE_CHANGED=1
    export CALLS="${BATS_TEST_TMPDIR}/calls"
    : > "${CALLS}"
    unset CLONE_CHANGED
    source "${REPO_ROOT}/tests/jpbrw-it/shared-vars.sh"
    source "${REPO_ROOT}/tests/jpbrw-it/test.sh"
    require_java() { printf 'jdk %s\n' "${1:-${TEST_APP_JAVA}}" >> "${CALLS}"; }
    clone() {
        printf 'clone %s\n' "$2" >> "${CALLS}"
        CLONE_CHANGED=${MOCK_CLONE_CHANGED}
    }
    compile_maven() {
        printf 'build %s %s\n' "$1" "${2:--DskipTests}" >> "${CALLS}"
        [[ "${MOCK_BUILD_FAILURE}" == false ]] || return 7
        if [[ "$1" == wrapper ]]; then
            mkdir -p "$(dirname "${app_jar}")"
            printf jar > "${app_jar}"
            if [[ "${MOCK_CACHE}" == true ]]; then
                printf cache > "${app_aot}"
            fi
        fi
    }
    fail() { printf '%s\n' "$*" >&2; }
    info() { printf '%s\n' "$*"; }
    start_app() { printf 'start %s %s %s\n' "$1" "${TEST_APP_JAVA}" "${TEST_STRAT_OPTS}" >> "${CALLS}"; }
    stop_app() { printf 'stop %s\n' "$1" >> "${CALLS}"; }
    prime_driver() { printf 'prime\n' >> "${CALLS}"; }
    run_driver() { printf 'drive\n' >> "${CALLS}"; }
}

@test "setup builds dependencies and start trains with the requested JDK and consumes its cache" {
    app_setup
    grep -q '^jdk 25$' "${CALLS}"
    grep -q '^build benchmark ' "${CALLS}"
    ! grep -q '^build wrapper ' "${CALLS}"
    app_start
    grep -q '^jdk 26$' "${CALLS}"
    grep -q -- '-DskipITs=false -P Fibonacci ' "${CALLS}"
    grep -q -- '-Dquarkus.package.jar.aot.enabled=true' "${CALLS}"
    grep -qF "start jpbrw-it-fibonacci 26 -XX:AOTMode=on -XX:AOTCache=${app_aot}" "${CALLS}"
    [[ -s "${app_aot}" ]]
}

@test "setup rebuilds dependencies only when the repository changed or application is missing" {
    MOCK_CLONE_CHANGED=0
    app_setup
    grep -q '^build benchmark ' "${CALLS}"
    app_start
    : > "${CALLS}"
    app_setup
    ! grep -q '^build ' "${CALLS}"
    MOCK_CLONE_CHANGED=1
    app_setup
    grep -q '^build benchmark ' "${CALLS}"
}

@test "start retrains existing artifacts and rejects missing cache output" {
    app_start
    MOCK_CACHE=false
    run app_start
    [[ "${status}" -ne 0 ]]
    [[ "${output}" == *'did not produce'* ]]
    [[ ! -f "${app_aot}" ]]
    [[ "$(grep -c '^start ' "${CALLS}")" -eq 1 ]]
}

@test "failed dependency build stops setup" {
    MOCK_BUILD_FAILURE=true
    run app_setup
    [[ "${status}" -eq 7 ]]
    ! grep -q '^build wrapper ' "${CALLS}"
}

@test "failed training invalidates the old cache and does not launch the application" {
    app_start
    : > "${CALLS}"
    MOCK_BUILD_FAILURE=true
    run app_start
    [[ "${status}" -ne 0 ]]
    [[ ! -f "${app_aot}" ]]
    ! grep -q '^start ' "${CALLS}"
}

@test "suite skips harness AOT training actions and runs the measured phase" {
    TEST_STRATEGY=aot TEST_RUN_TAG=training
    app_setup
    app_start
    app_stop
    driver_prime
    driver_run
    [[ ! -s "${CALLS}" ]]
    TEST_RUN_TAG=aot
    app_setup
    app_start
    app_stop
    driver_prime
    driver_run
    grep -q '^start ' "${CALLS}"
    grep -q '^stop ' "${CALLS}"
    grep -q '^prime$' "${CALLS}"
    grep -q '^drive$' "${CALLS}"
}

@test "normal strategy primes and runs the driver even with a training tag" {
    TEST_RUN_TAG=training
    driver_prime
    driver_run
    [[ "$(cat "${CALLS}")" == $'prime\ndrive' ]]
}

@test "each workload selects its own training profile" {
    local mapping
    for mapping in nqueens:NQueens fibonacci:Fibonacci if-conditional-branch:Conditional dead-loop:DeadLoo; do
        TEST_TEST_NAME="${mapping%%:*}"
        : > "${CALLS}"
        app_start
        grep -q -- "-P ${mapping#*:} " "${CALLS}"
    done
}

@test "unknown workloads fail before training or launching" {
    TEST_TEST_NAME=unknown
    run app_start
    [[ "${status}" -ne 0 ]]
    [[ "${output}" == *'Unknown jpbrw-it workload'* ]]
    [[ ! -s "${CALLS}" ]]
}
