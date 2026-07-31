#!/usr/bin/env bats

# Basic qDup functionality tests

setup() {
    # Store original directory
    export ORIGINAL_DIR="$(pwd)"
    
    # Change to project root
    cd "${BATS_TEST_DIRNAME}/../.."
    
    # Set up test output directory
    export TEST_OUTPUT_DIR="/tmp/qdup-test-$$"
    mkdir -p "${TEST_OUTPUT_DIR}"
}

teardown() {
    # Clean up test output
    if [[ -d "${TEST_OUTPUT_DIR}" ]]; then
        rm -rf "${TEST_OUTPUT_DIR}"
    fi
    
    # Return to original directory
    cd "${ORIGINAL_DIR}"
}

@test "qdup command exists and is executable" {
    [ -x "./run" ]
    ./run qdup --help
}

@test "qdup shows help with -h flag" {
    run ./run qdup -h
    [ "$status" -eq 2 ]
    [[ "$output" =~ "Usage: ./run qdup" ]]
}

@test "qdup shows help with --help flag" {
    run ./run qdup --help
    [ "$status" -eq 2 ]
    [[ "$output" =~ "Usage: ./run qdup" ]]
}

@test "qdup requires Java version to be specified" {
    run ./run qdup tests-dummy/dummy/empty
    [ "$status" -eq 4 ]
    [[ "$output" =~ "No Java versions specified" ]]
}

@test "qdup can run dummy/empty test with Java 25" {
    skip "Requires qDup binary and full test environment"
    run ./run qdup -j 25 -o "${TEST_OUTPUT_DIR}" tests-dummy/dummy/empty
    [ "$status" -eq 0 ]
}

@test "qdup creates output directory" {
    skip "Requires qDup binary and full test environment"
    ./run qdup -j 25 -o "${TEST_OUTPUT_DIR}/results" tests-dummy/dummy/empty
    [ -d "${TEST_OUTPUT_DIR}/results" ]
}

@test "qdup respects custom output directory" {
    skip "Requires qDup binary and full test environment"
    custom_dir="${TEST_OUTPUT_DIR}/custom-output"
    ./run qdup -j 25 -o "${custom_dir}" tests-dummy/dummy/empty
    [ -d "${custom_dir}" ]
}

@test "qdup accepts profile option" {
    run ./run qdup -j 25 -P lowmem tests-dummy/dummy/empty
    # Should not fail on profile validation
    [[ ! "$output" =~ "Profile 'lowmem' does not exist" ]]
}

@test "qdup rejects non-existent profile" {
    run ./run qdup -j 25 -P nonexistent tests-dummy/dummy/empty
    [ "$status" -eq 4 ]
    [[ "$output" =~ "Profile 'nonexistent' does not exist" ]]
}

@test "qdup accepts driver option" {
    run ./run qdup -j 25 -d oha tests-dummy/dummy/empty
    # Should not fail on driver validation
    [[ ! "$output" =~ "Test driver 'oha' does not exist" ]]
}

@test "qdup rejects non-existent driver" {
    run ./run qdup -j 25 -d nonexistent tests-dummy/dummy/empty
    [ "$status" -eq 4 ]
    [[ "$output" =~ "Test driver 'nonexistent' does not exist" ]]
}

@test "qdup accepts strategy option" {
    run ./run qdup -j 25 -s normal tests-dummy/dummy/empty
    # Should not fail on strategy validation
    [[ ! "$output" =~ "Strategy 'normal' does not exist" ]]
}

@test "qdup rejects non-existent strategy" {
    run ./run qdup -j 25 -s nonexistent tests-dummy/dummy/empty
    [ "$status" -eq 4 ]
    [[ "$output" =~ "Strategy 'nonexistent' does not exist" ]]
}

@test "qdup accepts hosts option" {
    run ./run qdup -j 25 -H local tests-dummy/dummy/empty
    # Should not fail on hosts validation (local is default)
    [ "$status" -ne 4 ] || [[ ! "$output" =~ "Hosts option" ]]
}

@test "qdup accepts multiple Java versions" {
    skip "Requires qDup binary and full test environment"
    run ./run qdup -j 25,26 -o "${TEST_OUTPUT_DIR}" tests-dummy/dummy/empty
    [ "$status" -eq 0 ]
}

@test "qdup accepts tag option" {
    skip "Requires qDup binary and full test environment"
    run ./run qdup -j 25 -t test-tag -o "${TEST_OUTPUT_DIR}" tests-dummy/dummy/empty
    [ "$status" -eq 0 ]
    # Output directory should contain the tag
    [[ -d "${TEST_OUTPUT_DIR}"*-test-tag ]] || [[ "$output" =~ "test-tag" ]]
}
