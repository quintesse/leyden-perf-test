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
    run ./run qdup --help
    [ "$status" -eq 2 ]
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
    run ./run qdup -C tests-dummy dummy/empty
    [ "$status" -eq 4 ]
    [[ "$output" =~ "No Java versions specified" ]]
}

@test "qdup can run dummy/empty test with Java 25" {
    run ./run qdup -j 25 -o "${TEST_OUTPUT_DIR}" -C tests-dummy dummy/empty
    [ "$status" -eq 0 ]
}

@test "qdup creates output directory" {
    ./run qdup -j 25 -o "${TEST_OUTPUT_DIR}/results" -C tests-dummy dummy/empty
    [ -d "${TEST_OUTPUT_DIR}/results" ]
}

@test "qdup respects custom output directory" {
    custom_dir="${TEST_OUTPUT_DIR}/custom-output"
    ./run qdup -j 25 -o "${custom_dir}" -C tests-dummy dummy/empty
    [ -d "${custom_dir}" ]
}

@test "qdup accepts profile option" {
    run ./run qdup -j 25 -P lowmem -C tests-dummy dummy/empty
    # Should not fail on profile validation
    [[ ! "$output" =~ "Profile 'lowmem' does not exist" ]]
}

@test "qdup rejects non-existent profile" {
    run ./run qdup -j 25 -P nonexistent -C tests-dummy dummy/empty
    [ "$status" -eq 4 ]
    [[ "$output" =~ "Profile 'nonexistent' does not exist" ]]
}

@test "qdup accepts driver option" {
    run ./run qdup -j 25 -d oha -C tests-dummy dummy/empty
    # Should not fail on driver validation
    [[ ! "$output" =~ "Test driver 'oha' does not exist" ]]
}

@test "qdup rejects non-existent driver" {
    run ./run qdup -j 25 -d nonexistent -C tests-dummy dummy/empty
    [ "$status" -eq 4 ]
    [[ "$output" =~ "Test driver 'nonexistent' does not exist" ]]
}

@test "qdup accepts strategy option" {
    run ./run qdup -j 25 -s normal -C tests-dummy dummy/empty
    # Should not fail on strategy validation
    [[ ! "$output" =~ "Strategy 'normal' does not exist" ]]
}

@test "qdup rejects non-existent strategy" {
    run ./run qdup -j 25 -s nonexistent -C tests-dummy dummy/empty
    [ "$status" -eq 4 ]
    [[ "$output" =~ "Strategy 'nonexistent' does not exist" ]]
}

@test "qdup accepts hosts option" {
    run ./run qdup -j 25 -H local -C tests-dummy dummy/empty
    # Should not fail on hosts validation (local is default)
    [ "$status" -ne 4 ] || [[ ! "$output" =~ "Hosts option" ]]
}

@test "qdup accepts multiple Java versions" {
    run ./run qdup -j 25,26 -o "${TEST_OUTPUT_DIR}" -C tests-dummy dummy/empty
    [ "$status" -eq 0 ]
}

@test "qdup accepts tag option" {
    run ./run qdup -j 25 -t test-tag -o "${TEST_OUTPUT_DIR}" -C tests-dummy dummy/empty
    [ "$status" -eq 0 ]
    # Output directory should contain the tag
    [[ -d "${TEST_OUTPUT_DIR}"*-test-tag ]] || [[ "$output" =~ "test-tag" ]]
}
