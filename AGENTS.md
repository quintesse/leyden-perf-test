# AGENTS.md - Leyden Performance Test Harness

## Project Overview

### Purpose
This is a performance testing harness designed to evaluate JVM applications, with a primary focus on testing Project Leyden's Ahead-of-Time (AOT) compilation features. The harness enables systematic comparison of different JVM configurations, compilation strategies, and runtime behaviors across multiple Java versions.

### Primary Goals
1. **Benchmark Leyden AOT Performance**: Measure and compare the performance impact of Leyden's AOT compilation features
2. **Multi-Version Testing**: Support testing across multiple JVM versions (currently targeting JDK 25, 26+)
3. **Reproducible Results**: Provide consistent, reproducible performance measurements
4. **Extensibility**: Enable easy addition of new test suites, drivers, and strategies
5. **Automation-Friendly**: Design for both human operators and AI agents

### Current State
- **Status**: Active development
- **Maturity**: Stable for internal performance testing
- **Primary Use Case**: Evaluating Leyden JVM features and comparing JVM performance characteristics
- **Target Users**: AI agents, performance engineers, JVM developers

## Architecture

### Core Components

```
leyden-perf-test/
├── run                      # Main entry point - bash launcher
├── src/
│   ├── scripts/
│   │   ├── bin/             # Command implementations (test.sh, list.sh, etc.)
│   │   ├── drivers/         # Test drivers (oha, ohac, hyperfoil)
│   │   ├── strategies/      # Test strategies (normal, aot)
│   │   ├── *funcs.sh        # Shared function libraries
│   │   └── launcher.sh      # Core orchestration logic
│   ├── java/util/           # Java analysis utilities (Collate, Graph, etc.)
│   └── qdup/                # qdup configuration (alternative test runner)
├── tests/                   # Main test suites (production workloads)
├── tests-dummy/             # Dummy tests for harness validation
├── tests-template/          # Templates for creating new tests
├── profiles/                # Configuration profiles (lowmem, diagnostics, etc.)
├── verify/bats/             # Harness verification tests
├── test-results/            # Test output directory
└── cache/                   # Build artifacts and dependencies
```

### Key Concepts

#### 1. Test Suites
Hierarchical organization of tests:
- **Suite**: A collection of related tests (e.g., `sqpc`, `gqaot`, `jpbrw`)
- **Test**: Individual test case within a suite (e.g., `sqpc/spring-normal`)
- Each level can have:
  - `test.sh` - Executable script
  - `shared-vars.sh` - Shared variables
  - `DESCRIPTION` - Human-readable description

#### 2. Drivers
Drivers execute the actual load testing:
- **oha**: Default driver using the oha HTTP load testing tool
- **ohac**: Containerized version of oha
- **hyperfoil**: Uses Hyperfoil for complex load scenarios
- Located in: `src/scripts/drivers/<driver-name>/`

#### 3. Strategies
Strategies define how tests are executed:
- **normal**: Standard execution without special optimizations
- **aot**: Performs training run, then restarts with AOT cache
- Located in: `src/scripts/strategies/<strategy-name>/`

#### 4. Profiles
Profiles define environment variables and configuration:
- Set variables like `TEST_JAVA_OPTIONS`, `TEST_DRIVER_CPUS`
- Can affect application behavior, driver settings, or infrastructure
- Located in: `profiles/<profile-name>.sh`

## Building and Setup

### Prerequisites
```bash
# Required
- Bash 4.0+
- Java (auto-downloaded by JBang if needed)
- oha (https://github.com/hatoo/oha)
- Docker or Podman

# Optional
- bats-core (auto-installed to cache/_tools/bats/)
```

### Initial Setup
```bash
# Clone the repository
git clone <repository-url>
cd leyden-perf-test

# Verify the harness is working
./run verify

# List available tests
./run list

# Run a simple test to verify setup
./run test -j 25 -d dummy tests-dummy/dummy/empty
```

### Environment Variables
The harness automatically sets:
- `TEST_DIR`: Project root directory
- `TEST_SRC_DIR`: Source directory (./src)
- `TEST_CACHE_DIR`: Cache directory (./cache)
- `TEST_ENGINE`: Detected container engine (docker or podman)
- `DETECTED_OS`: Operating system (linux, mac, windows)

## Running Tests with qDup (Recommended for Production)

### Overview

qDup is an alternative test runner that provides **process isolation** for the most accurate performance measurements. It is the **primary focus for future development** and will eventually replace the standard `./run test` command for production testing.

### Why qDup?

**Problem**: When running all components (infrastructure, application, driver) on a single system, they compete for resources and add noise to performance measurements.

**Solution**: qDup distributes components across multiple servers:
- **Infrastructure Host**: Runs databases, message queues, etc.
- **Application Host**: Runs the application under test (isolated from other processes)
- **Driver Host**: Runs the load testing tool (isolated from the application)

This isolation ensures that performance measurements reflect only the application's behavior, not interference from other processes.

### Usage Modes

#### 1. Multi-Server Mode (Production)
For accurate performance testing, run components on separate physical or virtual machines:

```bash
# Run tests across multiple servers defined in hosts file
./run qdup -H production -j 25,26 sqpc/*

# With custom hosts configuration
./run qdup -H src/qdup/hosts/containers.yml -j 25 sqpc/spring-normal
```

**Requirements**:
- SSH access to all hosts
- Hosts file defining infrahost, apphost, driverhost
- Network connectivity between hosts
- All necessary files uploaded to each host

#### 2. Single-System Mode (Development/Testing)
For quick testing or validating new tests, run all components on localhost:

```bash
# Use default "local" hosts configuration
./run qdup -j 25 sqpc/spring-normal

# Explicitly specify local hosts
./run qdup -H local -j 25 sqpc/*
```

**Note**: Results will be less accurate due to resource contention, but this mode is useful for:
- Quick validation of new tests
- Development and debugging
- CI/CD environments with limited resources

### qDup Architecture

#### Roles and Coordination

qDup organizes test execution into three roles:

1. **infra** (Infrastructure)
   - Uploads test framework to infrahost
   - Runs `./run infra <test> setup`
   - Runs `./run infra <test> start`
   - Signals `INFRA_READY` when infrastructure is running
   - Waits for `TEST_END` signal
   - Runs `./run infra <test> stop`
   - Downloads results

2. **app** (Application)
   - Uploads test framework to apphost
   - Runs `./run app <test> setup`
   - Waits for `INFRA_READY` signal
   - Runs `./run app <test> start`
   - Signals `APP_READY` when application is running
   - Waits for `TEST_END` signal
   - Runs `./run app <test> stop`
   - Downloads results

3. **driver** (Load Testing)
   - Uploads test framework to driverhost
   - Runs `./run drive <test> setup`
   - Runs `./run drive <test> prime`
   - Waits for `APP_READY` signal
   - Runs `./run drive <test> run`
   - Signals `TEST_END` when testing completes
   - Downloads results

#### File Isolation Strategy

**Multi-Server Mode**:
- Each host receives a complete copy of the test framework
- Files are uploaded to isolated directories per role:
  - Infrastructure: `$TEST_HOME_BASE/infra/`
  - Application: `$TEST_HOME_BASE/app/`
  - Driver: `$TEST_HOME_BASE/driver/`
- Results are collected from each host to `$TEST_OUT_BASE/`
- No file conflicts between roles

**Single-System Mode**:
- All roles run on localhost but in isolated directories
- Each role uses its own working directory to prevent conflicts
- Results are collected to a shared output directory
- Prevents processes from overwriting each other's files or user files

### qDup Configuration

#### Hosts Files

Located in `src/qdup/hosts/`:

**local.yml** - Single system configuration:
```yaml
hosts:
  infrahost: localhost
  apphost: localhost
  driverhost: localhost
```

**containers.yml** - Container-based multi-host:
```yaml
hosts:
  infrahost: container1.example.com
  apphost: container2.example.com
  driverhost: container3.example.com
```

**Custom hosts file**:
```yaml
hosts:
  infrahost: 192.168.1.10
  apphost: 192.168.1.11
  driverhost: 192.168.1.12
```

#### Test Configuration

Located in `src/qdup/`:

- **test-normal.yml** - Main test configuration defining roles and execution flow
- **scripts.yml** - Reusable script definitions for setup, run, and cleanup

### qDup Command Options

```bash
./run qdup [options] [test-pattern]

Options:
  -H|--hosts <hosts>        Hosts file (default: local)
  -j|--java <versions>      Java versions (comma-separated)
  -d|--driver <driver>      Test driver (default: oha)
  -s|--strategy <strategy>  Test strategy (default: normal)
  -P|--profile <profile>    Configuration profile
  -t|--tag <tag>            Result folder tag
  -o|--output <path>        Output directory
  -T|--tests-root <path>    Test root directory
```

### Examples

```bash
# Single system, quick test
./run qdup -j 25 sqpc/spring-normal

# Multi-server production run
./run qdup -H production -j 25,26 sqpc/*

# With custom profile and tagging
./run qdup -H production -j 25 -P lowmem --tag experiment1 sqpc/*

# Multiple strategies
./run qdup -H production -j 25 -s normal,aot sqpc/*
```

### Current Status and Roadmap

**Current State**:
- ✅ Basic multi-server execution working
- ✅ Role-based process isolation
- ✅ Signal-based coordination
- ✅ File upload and result download
- 🔄 Working on feature parity with `./run test`

**In Progress**:
- Multiple strategy support (normal, aot)
- Profile support
- JDK tagging
- Advanced driver options

**Future Work**:
- qDup will become the primary test runner
- Enhanced monitoring and real-time status
- Better error handling and recovery
- Performance optimization for large test suites

### Troubleshooting qDup

**Issue**: SSH connection failures
```bash
# Verify SSH access to all hosts
ssh infrahost
ssh apphost
ssh driverhost
```

**Issue**: File upload failures
```bash
# Check disk space on remote hosts
ssh infrahost "df -h"
```

**Issue**: Signal timeout (waiting for INFRA_READY, APP_READY)
```bash
# Check logs on respective hosts
ssh infrahost "tail -f /tmp/leyden-perf-test/results/*-app.out"
```

**Issue**: Results not downloaded
```bash
# Manually download results
scp -r infrahost:/tmp/leyden-perf-test/results/* ./test-results/
```

## Running Tests (Standard Mode)

### Basic Usage
```bash
# Run all tests with specific JDK versions
./run test -j 25,26 all

# Run specific test suite
./run test -j 26 sqpc/spring-normal

# Run all tests in a suite
./run test -j 25 'sqpc/*'

# Run tests matching pattern
./run test -j 25,26 'sqpc/quarkus-*'
```

### Advanced Options
```bash
# Use specific driver
./run test -j 25 -d hyperfoil sqpc/*

# Use specific strategy
./run test -j 25 -s aot sqpc/*

# Apply profile
./run test -j 25 -P lowmem sqpc/*

# Tag results
./run test -j 25 --tag experiment1 sqpc/*

# Custom output path
./run test -j 25 -o /path/to/results sqpc/*

# Custom Java options
TEST_JAVA_OPTS="-Xms128m -Xmx256m" ./run test -j 25 sqpc/*
```

### Test Output Structure
```
test-results/test-run-YYYYMMDD-HHMMSS[-tag]/
├── test-run-info.txt                    # Test configuration summary
└── j<VERSION>-<STRATEGY>[-jdk-tag]/
    ├── <suite>-<test>-oha.json          # Performance metrics
    ├── <suite>-<test>-oha.db            # SQLite with request timings
    ├── <suite>-<test>-app.out           # Application console output
    └── time-to-8080.csv                 # Startup time measurements
```

## Verification and Testing

### Harness Verification
```bash
# Run all verification tests
./run verify

# Run Bats tests directly
./bats verify/bats

# Run specific Bats test
./bats verify/bats/dummy-output.bats
```

### Verification Tests
Located in `verify/bats/`, these tests validate:
- Action resolution precedence (suite vs test vs global)
- Output format correctness
- Harness behavior consistency

## Creating New Tests

### Creating a New Test Suite

1. **Copy the template**:
```bash
cp -r tests-template/suite_template tests/my-new-suite
```

2. **Edit suite-level files**:
```bash
# Edit description
echo "My new test suite description" > tests/my-new-suite/DESCRIPTION

# Edit shared variables (if needed)
vim tests/my-new-suite/shared-vars.sh

# Edit suite-level test.sh (if needed)
vim tests/my-new-suite/test.sh
```

3. **Create individual tests**:
```bash
cp -r tests-template/suite_template/example_test tests/my-new-suite/my-test
echo "My test description" > tests/my-new-suite/my-test/DESCRIPTION
vim tests/my-new-suite/my-test/test.sh
```

### Test Script Structure

Each `test.sh` file can implement these optional functions:

```bash
#!/bin/bash

# The app_setup action manages any work that needs to be done to prepare the
# application being tested for execution, such as compiling the code.
# This action is optional and can be removed if not needed
app_setup() {
    # Clone repos, compile code, prepare environment
}

# The app_start action starts the application to be tested.
# This action is optional and can be removed if not needed.
app_start() {
    # Start the application under test
    # Typical implementation:
    # start_app "${TESTID}" "path/to/your/app.jar"
}

# The app_stop action stops the application that was tested.
# This action is optional and can be removed if not needed.
app_stop() {
    # Clean shutdown of application
    # Typical implementation:
    # stop_app "${TESTID}"
}

# The infra_setup action manages any one-time setup work needed for the
# infrastructure used by this test, such as pulling container images
# or initializing databases.
# This action is optional and can be removed if not needed.
infra_setup() {
    # Pull container images, initialize databases
}

# The infra_start action starts any infrastructure services required by the application.
# IMPORTANT: This action should wait and return only when the infrastructure
# is fully started and ready to use!
# This action is optional and can be removed if not needed.
infra_start() {
    # Start databases, message queues, etc.
}

# The infra_stop action stops any infrastructure services required by the application.
# This action is optional and can be removed if not needed.
infra_stop() {
    # Stop infrastructure services
}
```

**Available Variables:**
- `TEST_SUITE_NAME`: Name of the test suite
- `TEST_SUITE_DIR`: Directory of the test suite
- `TEST_SUITE_CACHE`: Cache directory for the suite
- `TEST_TEST_NAME`: Name of the specific test
- `TEST_TEST_DIR`: Directory of the specific test
- `TEST_TEST_CACHE`: Cache directory for the test
- `TEST_TEST_RUNID`: Unique run identifier
- `TESTID`: Test identifier passed as first argument

### Advanced: Driver Override Functions

For specialized use cases, you can override driver behavior at any level (global, suite, or test) by implementing these optional functions:

```bash
driver_setup() {
    # Override driver setup behavior
    # Default implementation calls: setup_driver
}

driver_prime() {
    # Override driver prime behavior
    # Default implementation calls: prime_driver
}

driver_run() {
    # Override driver run behavior
    # Default implementation calls: run_driver
}
```

**Note**: These functions are rarely needed and are not included in the standard templates. They are only used in highly specialized situations where you need to customize driver behavior for specific tests or suites. The default implementations simply delegate to the corresponding driver functions (`setup_driver`, `prime_driver`, `run_driver`).

### Action Resolution Hierarchy

The harness resolves actions (setup, start, stop) in this order:
1. Test-specific `test.sh` (highest priority)
2. Suite-specific `test.sh`
3. Global `test.sh` in test root
4. Driver-specific defaults (lowest priority)

## Creating Custom Drivers

### Driver Structure
```
src/scripts/drivers/<driver-name>/
├── driver.sh           # Main driver implementation
└── DESCRIPTION         # One-line description
```

### Driver Interface

Implement these functions in `driver.sh`:

```bash
#!/bin/bash

set -euo pipefail

# This script can make use of the following env vars:
# - TEST_DRIVER_RATE_LIMIT env var to set rate limit (requests per second)
# - TEST_PERF_CNT env var to set number of requests

setup() {
    # Install tools, prepare environment
    # This action is required
}

prime() {
    # Perform any work required before the driver is run
    # This action is optional and can be removed if not needed
}

run() {
    # Execute load test
    # Output results to TEST_OUT_DIR
    # This action is required
}
```

### Available Variables
- `TEST_OUT_DIR`: Output directory for this test run
- `TEST_APP_URL`: URL of the application under test
- `TEST_DRIVER_*`: Driver-specific configuration from profiles

## Creating Custom Strategies

### Strategy Structure
```
src/scripts/strategies/<strategy-name>/
├── strategy.sh         # Main strategy implementation
└── DESCRIPTION         # One-line description
```

### Strategy Implementation

```bash
#!/bin/bash

# Main strategy execution
# This script is sourced and should orchestrate the test flow

# Example: AOT strategy
for testPath in $(resolve_tests "${testPat}"); do
    suite=$(get_suite_name "${testPath}")
    test=$(get_test_name "${testPath}")
    
    # Training run
    run_test_phase "setup" "${testPath}"
    run_test_phase "start" "${testPath}"
    run_test_phase "prime" "${testPath}"
    run_test_phase "run" "${testPath}"
    run_test_phase "stop" "${testPath}"
    
    # Production run with AOT cache
    run_test_phase "start" "${testPath}"
    run_test_phase "run" "${testPath}"
    run_test_phase "stop" "${testPath}"
done
```

## Creating Profiles

### Profile Structure
```bash
# profiles/my-profile.sh

# Java options for the application
export TEST_JAVA_OPTIONS="-Xms128m -Xmx256m"

# Driver-specific settings
export TEST_DRIVER_CPUS=2
export TEST_DRIVER_DURATION=30s

# Infrastructure settings
export TEST_INFRA_POSTGRES_MEM=512m

# Custom variables
export MY_CUSTOM_VAR="value"
```

### Activating Profiles
```bash
# Single profile
./run test -j 25 -P lowmem sqpc/*

# Multiple profiles (applied in order)
./run test -j 25 -P lowmem -P diagnostics sqpc/*

# Default profile (auto-activated if exists)
cp profiles/_template.sh profiles/default.sh
vim profiles/default.sh
```

## Analysis and Reporting

### Using Java Utilities

```bash
# Collate and compare results
jbang src/java/util/Collate.java test-results/test-run-YYYYMMDD-HHMMSS

# Generate graphs
jbang src/java/util/Graph.java test-results/test-run-YYYYMMDD-HHMMSS

# Analyze specific metrics
jbang src/java/util/Result.java test-results/test-run-YYYYMMDD-HHMMSS/j25-aot/sqpc-spring-normal-oha.json
```

### Output Formats
- **JSON**: Raw performance metrics from oha
- **SQLite**: Detailed per-request timing data
- **CSV**: Startup time measurements
- **HTML**: Profiling results (when profiling enabled)

## Manual Test Control

For debugging or custom workflows:

```bash
# Setup phase
./run app sqpc/spring-normal setup
./run infra sqpc/spring-normal setup
./run drive sqpc/spring-normal setup

# Start phase
./run infra sqpc/spring-normal start
./run drive sqpc/spring-normal prime
./run app sqpc/spring-normal start

# Run phase
./run drive sqpc/spring-normal run

# Stop phase
./run app sqpc/spring-normal stop
./run infra sqpc/spring-normal stop
```

## Code Patterns and Conventions

### Bash Scripting Standards
- Use `set -euo pipefail` at the start of scripts
- Quote all variables: `"${variable}"`
- Use functions for reusable logic
- Provide descriptive error messages
- Use `# DESCRIPTION=` comment for command descriptions

### Function Naming
- `test_*`: Test-specific functions
- `driver_*`: Driver-specific functions
- `app_*`: Application management functions
- `infra_*`: Infrastructure management functions
- `suite_*`: Suite-level functions

### Variable Naming
- `TEST_*`: Harness-level variables
- `DETECTED_*`: Auto-detected system properties
- Uppercase for exported variables
- Lowercase for local variables

### Error Handling
```bash
# Check prerequisites
if ! command -v oha >/dev/null 2>&1; then
    echo "Error: oha is not installed"
    exit 1
fi

# Validate arguments
if [[ $# -eq 0 ]]; then
    echo "Error: Missing required argument"
    exit 4
fi
```

## Dependency Management

### JBang Dependencies
- Automatically downloaded on first use
- Cached in `~/.jbang/`
- Specified in Java source files with `//DEPS` comments

### Maven Dependencies
- Cached in `cache/_mvn_repo/`
- Managed by individual test applications
- Use `local-settings.xml` for custom repository configuration

### Container Images
- Pulled automatically by Docker/Podman
- No version pinning by default (uses `latest`)
- Consider pinning versions in production profiles

### Tool Installation
- **oha**: Must be manually installed (see https://github.com/hatoo/oha)
- **bats-core**: Auto-installed to `cache/_tools/bats/` on first use
- **JBang**: Auto-downloaded if not present

## Troubleshooting

### Common Issues

**Issue**: Tests fail with "Neither podman nor docker can be found"
```bash
# Solution: Install Docker or Podman
# Ubuntu/Debian: sudo apt-get install docker.io
# Fedora: sudo dnf install podman
```

**Issue**: Application fails to start on port 8080
```bash
# Solution: Check if port is already in use
lsof -i :8080
# Kill the process or use a different port
```

**Issue**: Out of memory errors during tests
```bash
# Solution: Use lowmem profile or adjust Java options
./run test -j 25 -P lowmem sqpc/*
# Or set custom options
TEST_JAVA_OPTS="-Xmx512m" ./run test -j 25 sqpc/*
```

**Issue**: Inconsistent performance results
```bash
# Solution: Use hardware tweaks (Linux only)
# Edit hardware-tweaks.conf with your CPU settings
./hwtweaked-run test -j 25 sqpc/*
```

### Debug Mode

Enable verbose output:
```bash
# Bash debug mode
bash -x ./run test -j 25 sqpc/spring-normal

# Keep test artifacts for debugging
# Modify test.sh to preserve temporary files if needed
```

### Logs and Output

Check these locations for debugging:
- `test-results/test-run-*/j*/*-app.out` - Application logs
- `test-results/test-run-*/test-run-info.txt` - Test configuration
- `cache/` - Build artifacts and dependencies

## Performance Optimization

### For Stable Results
1. Use hardware tweaks (Linux): `./hwtweaked-run test ...`
2. Disable CPU frequency scaling
3. Disable turbo boost
4. Close unnecessary applications
5. Run tests multiple times and average results

### For Faster Execution
1. Use dummy driver for harness testing: `-d dummy`
2. Reduce test duration in profiles
3. Use cached builds (avoid clean builds)
4. Run tests in parallel (not currently supported, but possible to implement)

## Contributing Guidelines

### For AI Agents

When modifying this project:

1. **Understand the hierarchy**: Test → Suite → Global → Driver
2. **Follow templates**: Use `_template` directories as starting points
3. **Maintain consistency**: Follow existing naming and structure patterns
4. **Test changes**: Run `./run verify` after modifications
5. **Document**: Update DESCRIPTION files and comments
6. **Preserve compatibility**: Don't break existing tests or scripts
7. **Account for distributed execution**: The framework is designed to run components (app, infra, driver, qDup) on different hosts. **Never assume shared filesystem access or that files/information available on one host are accessible on another**. All inter-host communication must be explicit (via network, signals, or file uploads/downloads). Tests and framework code must work correctly whether running on a single system or distributed across multiple hosts.

### Adding New Features

1. **New test suite**: Copy from `tests-template/suite_template`
2. **New driver**: Copy from `src/scripts/drivers/_template`
3. **New strategy**: Copy from `src/scripts/strategies/_template`
4. **New profile**: Copy from `profiles/_template.sh`
5. **New command**: Add to `src/scripts/bin/` with `# DESCRIPTION=` comment

### Code Review Checklist

- [ ] Scripts use `set -euo pipefail`
- [ ] Variables are properly quoted
- [ ] Error messages are descriptive
- [ ] Functions have clear names and purposes
- [ ] DESCRIPTION files are updated
- [ ] Verification tests pass (`./run verify`)
- [ ] Manual testing completed
- [ ] Documentation updated (README.md, AGENTS.md)

## Known Limitations

1. **Windows Support**: No longer supported (Linux and macOS only)
2. **Parallel Execution**: Tests run sequentially (no parallel support)
3. **Container Networking**: May require additional configuration in some environments
4. **Resource Management**: Manual intervention may be needed if tests are interrupted (e.g., stopping containers, killing processes)
5. **JDK Version Detection**: Relies on JBang for JDK management

## Future Roadmap

Potential improvements and features:

1. **Parallel Test Execution**: Run multiple tests concurrently
2. **Cloud Integration**: Support for cloud-based test execution
3. **Real-time Monitoring**: Live dashboards during test execution
4. **Historical Comparison**: Compare results across multiple test runs
5. **CI/CD Integration**: GitHub Actions workflows for automated testing
6. **Additional Drivers**: Support for more load testing tools
7. **Container Orchestration**: Kubernetes-based test execution
8. **Result Database**: Centralized storage for test results

## Quick Reference

### Essential Commands
```bash
./run list                          # List all tests
./run list-drivers                  # List available drivers
./run list-strategies               # List available strategies
./run list-profiles                 # List available profiles
./run test -j 25,26 all            # Run all tests
./run verify                        # Verify harness
./bats verify/bats                  # Run Bats tests
```

### File Locations
- Tests: `tests/`
- Drivers: `src/scripts/drivers/`
- Strategies: `src/scripts/strategies/`
- Profiles: `profiles/`
- Results: `test-results/`
- Cache: `cache/`

### Key Variables
- `TEST_DIR`: Project root
- `TEST_OUT_DIR`: Current test output directory
- `TEST_APP_JAVA`: Java version for tests
- `TEST_DRIVER`: Selected driver
- `TEST_ENGINE`: Container engine (docker/podman)

## Support and Resources

- **Repository**: Check the README.md for basic usage
- **Templates**: Use `_template` directories for creating new components
- **Verification**: Run `./run verify` to check harness integrity
- **Examples**: See `tests-dummy/` for simple examples

---

**Last Updated**: 2026-07-30
**Version**: 1.0
**Maintained By**: AI agents and human developers
