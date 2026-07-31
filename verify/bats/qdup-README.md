# qDup Verification Tests

This directory contains Bats-based verification tests for the qDup test runner.

## Test Files

### qdup-basic.bats
Tests basic qDup functionality:
- Command existence and help output
- Argument validation (Java versions, profiles, drivers, strategies)
- Option parsing and error handling
- Basic execution flow

### qdup-output.bats
Tests qDup output and directory structure:
- Output directory creation and structure
- Cache directory handling
- Results download and preservation
- Output format and content validation

## Running Tests

### Run all verification tests (including qDup tests):
```bash
./run verify
```

### Run only qDup tests:
```bash
./run verify --qdup
```

### Run specific test file:
```bash
./bats verify/bats/qdup-basic.bats
```

## Test Status

Most tests are currently **skipped** because they require:
- qDup binary installed and available
- Full test environment setup
- Network connectivity (for multi-host tests)
- Container engine (Docker/Podman)

The non-skipped tests validate:
- Command-line argument parsing
- Help text and usage information
- Error handling for invalid inputs
- Profile, driver, and strategy validation

## Future Enhancements

As outlined in the implementation plan (important-issues.md), future testing improvements include:

1. **Integration Tests** (`verify/qdup/` directory):
   - Local mode execution tests
   - Strategy testing (normal, aot)
   - Driver testing (oha, hyperfoil)
   - Profile application tests

2. **Container-Based Multi-Host Tests** (`verify/qdup/containers/`):
   - Docker Compose setup for test hosts
   - Multi-host execution validation
   - Role isolation testing
   - Signal coordination verification

3. **CI/CD Integration**:
   - GitHub Actions workflow for automated testing
   - Container-based tests in CI environment
   - Regression detection

## Test Development Guidelines

When adding new tests:

1. **Use descriptive test names** that clearly state what is being tested
2. **Skip tests that require full environment** using `skip "reason"`
3. **Clean up test artifacts** in teardown functions
4. **Use unique temporary directories** to avoid conflicts
5. **Test both success and failure cases**
6. **Validate error messages** for user-facing errors

## Example Test Structure

```bash
@test "descriptive test name" {
    # Skip if requires full environment
    skip "Requires qDup binary and full test environment"
    
    # Run the command
    run ./run qdup -j 25 -o "${TEST_OUTPUT_DIR}" tests-dummy/dummy/empty
    
    # Validate exit code
    [ "$status" -eq 0 ]
    
    # Validate output
    [[ "$output" =~ "expected text" ]]
    
    # Validate file system state
    [ -d "${TEST_OUTPUT_DIR}" ]
}
```

## Contributing

When implementing new qDup features:
1. Add corresponding tests to validate the feature
2. Update existing tests if behavior changes
3. Run `./run verify --qdup` to ensure tests pass
4. Document any new test requirements in this README
