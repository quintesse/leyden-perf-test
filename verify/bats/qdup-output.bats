#!/usr/bin/env bats

# qDup output validation tests

setup() {
    # Store original directory
    export ORIGINAL_DIR="$(pwd)"
    
    # Change to project root
    cd "${BATS_TEST_DIRNAME}/../.."
    
    # Set up test output directory
    export TEST_OUTPUT_DIR="/tmp/qdup-output-test-$$"
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

@test "qdup output directory structure matches expected format" {
    skip "Requires qDup binary and full test environment"
    
    ./run qdup -j 25 -o "${TEST_OUTPUT_DIR}/test-run" tests-dummy/dummy/empty
    
    # Check that output directory exists
    [ -d "${TEST_OUTPUT_DIR}/test-run" ]
    
    # Check for expected files (adjust based on actual qDup output)
    # This is a placeholder - actual files depend on qDup implementation
    # [ -f "${TEST_OUTPUT_DIR}/test-run/test-run-info.txt" ]
}

@test "qdup creates cache directory" {
    skip "Requires qDup binary and full test environment"
    
    cache_dir="${TEST_OUTPUT_DIR}/cache"
    
    # Run qdup (it should create cache directory)
    ./run qdup -j 25 -o "${TEST_OUTPUT_DIR}/results" tests-dummy/dummy/empty
    
    # Check that cache directory was created
    [ -d "./cache" ] || [ -d "${cache_dir}" ]
}

@test "qdup results are downloadable" {
    skip "Requires qDup binary and full test environment"
    
    ./run qdup -j 25 -o "${TEST_OUTPUT_DIR}/results" tests-dummy/dummy/empty
    
    # Check that results directory exists and contains files
    [ -d "${TEST_OUTPUT_DIR}/results" ]
    [ "$(ls -A ${TEST_OUTPUT_DIR}/results)" ]
}

@test "qdup output includes test information" {
    skip "Requires qDup binary and full test environment"
    
    run ./run qdup -j 25 -o "${TEST_OUTPUT_DIR}" tests-dummy/dummy/empty
    
    # Output should mention the test being run
    [[ "$output" =~ "dummy/empty" ]] || [[ "$output" =~ "Running test" ]]
}

@test "qdup output includes strategy information" {
    skip "Requires qDup binary and full test environment"
    
    run ./run qdup -j 25 -s normal -o "${TEST_OUTPUT_DIR}" tests-dummy/dummy/empty
    
    # Output should mention the strategy
    [[ "$output" =~ "normal" ]] || [[ "$output" =~ "strategy" ]]
}

@test "qdup with profile shows profile extraction" {
    skip "Requires qDup binary and full test environment"
    
    run ./run qdup -j 25 -P lowmem -o "${TEST_OUTPUT_DIR}" tests-dummy/dummy/empty
    
    # Output should mention profile extraction
    [[ "$output" =~ "Extracting variables from profile" ]] || [[ "$output" =~ "lowmem" ]]
}

@test "qdup respects test-results default directory" {
    skip "Requires qDup binary and full test environment"
    
    # Run without -o flag
    run ./run qdup -j 25 tests-dummy/dummy/empty
    
    # Should create results in ./test-results/
    [ -d "./test-results" ]
}
