# Leyden Performance Test Harness

A performance testing harness designed to evaluate JVM applications, with a primary focus on testing Project Leyden's Ahead-of-Time (AOT) compilation features. The harness enables systematic comparison of different JVM configurations, compilation strategies, and runtime behaviors across multiple Java versions.

## Quick Start

### Requirements

- Bash 4.0+
- Java (will be automatically downloaded by JBang if not present)
- [oha](https://github.com/hatoo/oha) - HTTP load testing tool
- Docker or Podman (for infrastructure services like PostgreSQL)

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
./run test -j 25 tests-dummy/dummy/empty
```

## Running Tests

### Standard Mode (Single System)

The test framework supports running individual tests or entire test suites on a single system:

```bash
# List all available test suites and tests
./run list

# Run all tests with JDKs 25 and 26
./run test -j 25,26 all

# Run a specific test suite with JDK 26
./run test -j 26 sqpc/spring-normal

# Run all tests in a suite with JDK 25
./run test -j 25 'sqpc/*'

# Run tests matching a pattern with JDKs 25 and 26
./run test -j 25,26 'sqpc/quarkus-*'
```

### qDup Mode (Multi-Server, Recommended for Production)

**qDup** is the recommended test runner for production performance testing. It provides **process isolation** by distributing components across multiple servers for the most accurate measurements.

#### Why qDup?

When running all components (infrastructure, application, driver) on a single system, they compete for resources and add noise to performance measurements. qDup solves this by distributing components:

- **Infrastructure Host**: Runs databases, message queues, etc.
- **Application Host**: Runs the application under test (isolated)
- **Driver Host**: Runs the load testing tool (isolated)

#### Usage

```bash
# Single system mode (for development/testing)
./run qdup -j 25 sqpc/spring-normal

# Multi-server production mode
./run qdup -H production -j 25,26 sqpc/*

# With custom hosts configuration
./run qdup -H src/qdup/hosts/containers.yml -j 25 sqpc/spring-normal

# With profile and tagging
./run qdup -H production -j 25 -P lowmem --tag experiment1 sqpc/*
```

**Note**: Multi-server mode requires SSH access to all hosts and a hosts configuration file. See `src/qdup/hosts/` for examples.

## Architecture Overview

### Core Components

```
leyden-perf-test/
├── run                      # Main entry point
├── src/
│   ├── scripts/
│   │   ├── bin/             # Command implementations
│   │   ├── drivers/         # Test drivers (oha, ohac, hyperfoil)
│   │   ├── strategies/      # Test strategies (normal, aot)
│   │   └── *funcs.sh        # Shared function libraries
│   ├── java/util/           # Analysis utilities (Collate, Graph, etc.)
│   └── qdup/                # qDup configuration
├── tests/                   # Main test suites
├── tests-dummy/             # Harness validation tests
├── tests-template/          # Templates for new tests
├── profiles/                # Configuration profiles
├── verify/bats/             # Harness verification tests
├── test-results/            # Test output directory
└── cache/                   # Build artifacts and dependencies
```

### Key Concepts

- **Test Suites**: Collections of related tests (e.g., `sqpc`, `gqaot`, `jpbrw`)
- **Drivers**: Execute load testing (oha, ohac, hyperfoil)
- **Strategies**: Define test execution approach (normal, aot)
- **Profiles**: Configuration presets for different scenarios

## Repository Test Layout

This project contains several test-related roots with distinct purposes:

- `tests/` - Main performance workload definitions used for regular runs
- `tests-dummy/` - Lightweight dummy suites used to validate harness behavior
- `tests-template/` - Templates for creating new suites and tests

## Available Test Suites

- **sqpc** - Spring Quarkus Performance Comparison
  - `spring-normal` - Spring Boot compiled normally
  - `spring-sbaot` - Spring Boot compiled with Spring AOT optimization
  - `quarkus-aot` - Quarkus compiled and packaged with the AOT jar
  - `quarkus-native` - Quarkus natively compiled and packaged

- **gqaot** - Sample Quarkus applications
  - `quarkus-hibernate-orm-simple`
  - `quarkus-hibernate-orm-spacefox`
  - `quarkus-hibernate-orm-tribe-krd`
  - `simple-rest`

- **jpbrw** - Java Performance Benchmarks
  - `dead-loop`
  - `fibonacci`
  - `if-conditional-branch`
  - `nqueens`

Run `./run list` to see all available tests with descriptions.

## Advanced Options

### Drivers

Drivers are responsible for load testing the applications. Available drivers:

- **oha** (default) - Uses [oha](https://github.com/hatoo/oha) for HTTP load testing
- **ohac** - Containerized version of oha
- **hyperfoil** - Uses [Hyperfoil](https://hyperfoil.io) for complex scenarios
- **dummy** - No-op driver for harness testing

```bash
# Use specific driver
./run test -j 25 -d hyperfoil sqpc/*

# List available drivers
./run list-drivers
```

Custom drivers can be created by copying `src/scripts/drivers/_template/`.

### Strategies

Strategies define how tests are executed:

- **normal** - Standard execution without special optimizations
- **aot** - Performs training run, then restarts with AOT cache

```bash
# Use specific strategy
./run test -j 25 -s aot sqpc/*

# Use multiple strategies
./run test -j 25 -s normal,aot sqpc/*

# List available strategies
./run list-strategies
```

If no strategy is specified, both "normal" and "aot" are used by default.

Custom strategies can be created by copying `src/scripts/strategies/_template/`.

### Profiles

Profiles define environment variables and configuration for different scenarios:

```bash
# Apply a profile
./run test -j 25 -P lowmem sqpc/*

# Apply multiple profiles
./run test -j 25 -P lowmem -P diagnostics sqpc/*

# List available profiles
./run list-profiles
```

Available profiles:
- `lowmem` - Reduced memory settings
- `diagnostics` - Enhanced logging and diagnostics

Create custom profiles by copying `profiles/_template.sh` to `profiles/<name>.sh`.

**Note**: If a `default` profile exists and no profile is explicitly specified with `-P`, it will be automatically activated.

### Custom Java Options

```bash
TEST_JAVA_OPTS="-Xms128m -Xmx256m" ./run test -j 25 sqpc/*
```

### Tagging Results

```bash
# Add a tag to the result folder name
./run test --tag experiment1 sqpc/*
```

Results will be saved to `test-results/test-run-YYYYMMDD-HHMMSS-experiment1`.

### Custom Output Path

```bash
./run test -o /path/to/results sqpc/*
```

## Test Output

Test results are written to `test-results/test-run-YYYYMMDD-HHMMSS[-tag]/`:

```
test-results/test-run-YYYYMMDD-HHMMSS[-tag]/
├── test-run-info.txt                    # Test configuration summary
└── j<VERSION>-<STRATEGY>[-jdk-tag]/
    ├── <suite>-<test>-oha.json          # Performance metrics
    ├── <suite>-<test>-oha.db            # SQLite with request timings
    ├── <suite>-<test>-app.out           # Application console output
    └── time-to-8080.csv                 # Startup time measurements
```

## Performance Analysis

Use the included Java utilities to analyze test results:

```bash
# Collate and compare results across multiple test runs
jbang src/java/util/Collate.java test-results/test-run-YYYYMMDD-HHMMSS

# Generate graphs
jbang src/java/util/Graph.java test-results/test-run-YYYYMMDD-HHMMSS

# Analyze specific metrics
jbang src/java/util/Result.java test-results/test-run-YYYYMMDD-HHMMSS/j25-aot/sqpc-spring-normal-oha.json
```

This will display graphs comparing:
- Total duration
- Requests per second
- Response time percentiles
- Request timing breakdowns

## Creating New Tests

### Quick Start

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

### Test Structure

Tests are organized hierarchically:

```
tests/
  test.sh                 # Global script
  <suite-name>/
    test.sh               # Suite-specific script
    shared-vars.sh        # Shared variables for all tests in suite
    DESCRIPTION           # One-line description of the suite
    <test-name>/
      test.sh             # Test-specific script
      DESCRIPTION         # One-line description of the test
```

Each `test.sh` file can implement these optional functions:

- `app_setup()` - Prepare the application (compile, clone repos, etc.)
- `app_start()` - Start the application under test
- `app_stop()` - Stop the application
- `infra_setup()` - One-time infrastructure setup (pull images, etc.)
- `infra_start()` - Start infrastructure services (databases, etc.)
- `infra_stop()` - Stop infrastructure services

See `tests-template/suite_template/example_test/test.sh` for detailed examples.

## Manual Test Control

For debugging or custom workflows, you can manually control individual components:

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

## Harness Verification

This repository includes verification tests to validate harness behavior:

```bash
# Run all verification tests
./run verify

# Run Bats tests directly
./bats verify/bats

# Run specific Bats test
./bats verify/bats/dummy-output.bats
```

By default, `./bats` installs bats-core into `cache/_tools/bats/` on first run.

The verification tests validate:
- Action resolution precedence (suite vs test vs global)
- Output format correctness
- Harness behavior consistency

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
6. Use qDup multi-server mode for production testing

### For Faster Execution

1. Use dummy driver for harness testing: `-d dummy`
2. Reduce test duration in profiles
3. Use cached builds (avoid clean builds)

### Hardware Tweaks (Linux Only)

For more stable performance testing on Linux:

1. Edit [`hardware-tweaks.conf`](hardware-tweaks.conf) with your system's CPU settings
2. Run tests with: `./hwtweaked-run test sqpc/*`

**Warning:** This script modifies CPU frequency scaling and turbo boost settings. Use with caution!

## Known Limitations

1. **Platform Support**: Linux and macOS only (Windows no longer supported)
2. **Sequential Execution**: Tests run sequentially, one at a time. This ensures:
   - Consistent, reproducible performance measurements
   - No resource contention between tests
   - Simplified infrastructure and debugging
   - Reliable cleanup between test runs
3. **Container Networking**: May require additional configuration in some environments
4. **Resource Management**: Manual intervention may be needed if tests are interrupted
5. **JDK Version Detection**: Relies on JBang for JDK management

## Dependency Management

- **JBang**: Auto-downloaded if not present, cached in `~/.jbang/`
- **Maven**: Dependencies cached in `cache/_mvn_repo/`
- **Container Images**: Pulled automatically by Docker/Podman
- **oha**: Must be manually installed (see https://github.com/hatoo/oha)
- **bats-core**: Auto-installed to `cache/_tools/bats/` on first use

## Additional Resources

- **AGENTS.md** - Comprehensive documentation for AI agents and advanced users
- **Templates** - Use `_template` directories for creating new components
- **Examples** - See `tests-dummy/` for simple examples

## Contributing

When creating new tests or modifying the harness:

1. Follow existing naming and structure patterns
2. Use templates as starting points
3. Run `./run verify` after modifications
4. Update DESCRIPTION files
5. Test changes thoroughly

For detailed contribution guidelines, see AGENTS.md.

---

**Version**: 1.0  
**Last Updated**: 2026-07-30