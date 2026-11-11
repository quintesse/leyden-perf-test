#!/usr/bin/env bats

setup() {
    REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../.." && pwd)"
    export TEST_TEST_CACHE="${BATS_TEST_TMPDIR}/cache"
    export TEST_CACHE_DIR="${BATS_TEST_TMPDIR}/cache"
    export TEST_OUT_DIR="${BATS_TEST_TMPDIR}/output"
    export TEST_DIR="${REPO_ROOT}"
    export CALLS="${BATS_TEST_TMPDIR}/calls"
    mkdir -p "${TEST_TEST_CACHE}/repo" "${TEST_OUT_DIR}"
    : > "${CALLS}"
    source "${REPO_ROOT}/src/scripts/buildfuncs.sh"
    info() { printf '%s\n' "$*"; }
    success() { printf '%s\n' "$*"; }
    fail() { printf '%s\n' "$*" >&2; }
    git() {
        printf '%s\n' "$1" >> "${CALLS}"
        case "$1" in
            reset)
                if [[ "${RESET_FAIL:-0}" == 1 ]]; then
                    echo "reset failed" >&2
                    return 7
                fi
                ;;
            rev-parse)
                if [[ -f "${BATS_TEST_TMPDIR}/pulled" ]]; then
                    echo "${AFTER_HEAD:-before}"
                else
                    echo before
                fi
                ;;
            pull)
                if [[ "${PULL_FAIL:-0}" == 1 ]]; then
                    echo "pull failed" >&2
                    return 8
                fi
                touch "${BATS_TEST_TMPDIR}/pulled"
                ;;
        esac
    }
}

@test "failed pushd reports the error and does not pop the directory stack" {
    pushd() { echo "pushd failed" >&2; return 6; }
    popd() { echo "unexpected popd" >&2; return 9; }
    run clone example
    [[ "${status}" -eq 6 ]]
    [[ "${output}" == *"Repository 'example' failed to update"* ]]
    [[ "${output}" == *"pushd failed"* ]]
    [[ "${output}" != *"unexpected popd"* ]]
    [[ ! -s "${CALLS}" ]]
}

@test "failed reset reports the error and restores the working directory" {
    RESET_FAIL=1
    original_dir="${PWD}"
    if clone example > "${BATS_TEST_TMPDIR}/result" 2>&1; then
        result=0
    else
        result=$?
    fi
    [[ "${result}" -eq 7 ]]
    grep -q "Repository 'example' failed to update" "${BATS_TEST_TMPDIR}/result"
    grep -q "reset failed" "${BATS_TEST_TMPDIR}/result"
    [[ "${PWD}" == "${original_dir}" ]]
    [[ "${CLONE_CHANGED}" -eq 0 ]]
    ! grep -q '^pull$' "${CALLS}"
}

@test "successful update records whether HEAD changed" {
    AFTER_HEAD=after
    original_dir="${PWD}"
    clone example
    [[ "${CLONE_CHANGED}" -eq 1 ]]
    [[ "${PWD}" == "${original_dir}" ]]
    AFTER_HEAD=before
    clone example
    [[ "${CLONE_CHANGED}" -eq 0 ]]
}

@test "failed pull continues to report its error" {
    PULL_FAIL=1
    run clone example
    [[ "${status}" -eq 8 ]]
    [[ "${output}" == *"Repository 'example' failed to update"* ]]
    [[ "${output}" == *"pull failed"* ]]
}

@test "failed Maven pushd reports the error without popping the directory stack" {
    pushd() { echo "pushd failed" >&2; return 6; }
    popd() { echo "unexpected popd" >&2; return 9; }
    run compile_maven
    [[ "${status}" -eq 6 ]]
    [[ "${output}" == *"'repo' failed to build"* ]]
    [[ "${output}" == *"pushd failed"* ]]
    [[ "${output}" != *"unexpected popd"* ]]
}

@test "failed Maven build reports the error and restores the working directory" {
    cat > "${TEST_TEST_CACHE}/repo/mvnw" <<'EOF'
#!/bin/bash
echo "Maven failed" >&2
exit 7
EOF
    chmod +x "${TEST_TEST_CACHE}/repo/mvnw"
    original_dir="${PWD}"
    if compile_maven > "${BATS_TEST_TMPDIR}/result" 2>&1; then
        result=0
    else
        result=$?
    fi
    [[ "${result}" -eq 7 ]]
    grep -q "'repo' failed to build" "${BATS_TEST_TMPDIR}/result"
    grep -q "Maven failed" "${BATS_TEST_TMPDIR}/result"
    [[ "${PWD}" == "${original_dir}" ]]
    [[ -f "${TEST_OUT_DIR}/unknown-build-$$.log" ]]
}

@test "successful Maven build restores the working directory and removes its log" {
    cat > "${TEST_TEST_CACHE}/repo/mvnw" <<'EOF'
#!/bin/bash
echo "Maven succeeded"
EOF
    chmod +x "${TEST_TEST_CACHE}/repo/mvnw"
    original_dir="${PWD}"
    compile_maven
    [[ "${PWD}" == "${original_dir}" ]]
    [[ ! -f "${TEST_OUT_DIR}/unknown-build-$$.log" ]]
}
