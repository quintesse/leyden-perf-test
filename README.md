# Leyden Performance Tests

These are some scripts to help with performance/load testing of different JVMs, especially focused on finding out the effect of the different Leyden AOT settings.

## Requirements

- Java (will be automatically downloaded by JBang if not present)
- [oha](https://github.com/hatoo/oha) - HTTP load testing tool
- Docker or Podman (for infrastructure services like PostgreSQL)

## Running Tests

The test framework supports running individual tests or entire test suites:

```bash
# List all available test suites and tests
./run list

# Run all tests with Jdks 25 and 26
./run test -j 25,26 all

# Run a specific test suite with Jdk 26
./run test -j 26 sqpc/spring-normal

# Run all tests in a suite with Jdk 25
./run test -j 25 'sqpc/*'

# Run tests matching a pattern with Jdks 25 and 26
./run test -j 25,26 'sqpc/quarkus-*'
```

## Repository Test Layout

This project contains several test-related roots with distinct purposes:

- `tests/` - main performance workload definitions used for regular runs
- `tests-dummy/` - lightweight dummy suites used to validate harness behavior
- `tests-template/` - templates for creating new suites and tests

## Harness Checks

This repository is itself a test harness. Harness verification tests live under `verify/bats/`.
The repository includes a local `./bats` launcher script so you do not need
to install bats-core globally.

Run all harness checks with:

```bash
./run verify
```

`./run verify` runs the Bats verification suite from `verify/bats/*.bats`.

Run only the Bats checks directly with:

```bash
./bats verify/bats
```

By default, `./bats` installs bats-core into `cache/_tools/bats/` on first run.
Set `BATS_VERSION` to override the default version.

The `dummy-output` Bats test validates action-resolution precedence by running:

```bash
./run test -j 25 -d dummy -s normal -T tests-dummy all
```

It asserts these expected output families:

- `dummy/override` -> `Dummy test ...`
- `dummy/empty` -> `Dummy suite ...`
- `empty/override` -> `Empty test ...`
- `empty/empty` -> `Dummy global ...`

## Test Output

Test results are written to a folder in the `test-results/` directory with the format `test-run-YYYYMMDD-HHMMSS/j<VERSION>-<STRATEGY>`. Each test produces:

- `<testname>-oha.json` - Performance metrics from oha
- `<testname>-oha.db` - SQLite database with detailed request timings
- `<testname>-app.out` - Application console output
- `time-to-8080.csv` - Application startup times

## Advanced Options

### Custom Java Options

```bash
TEST_JAVA_OPTS="-Xms128m -Xmx256m" ./run test sqpc/*
```

### Tagging Results

```bash
# Add a tag to the result folder name
./run test --tag lowmem sqpc/*
```

Will result in the results of the tests being saved to `test-results/test-run-YYYYMMDD-HHMMSS-lowmem`.

### Custom Output Path

```bash
./run test -o /path/to/results sqpc/*
```

### Select Driver

Drivers are responsible for actually testing, or "driving", the test applications. You can select the one you want to use like this:

```bash
./run test -d oha sqpc/*
```

If no driver is specified, `oha` will be used by default.

You can list the available drivers by running:

```bash
./run list-drivers
```

Currently existing drivers:

 - **oha** - Uses [oha](https://github.com/hatoo/oha) to perform load tests.
 - **ohac** - Like `oha`, but runs the load tester inside a container.
 - **hyperfoil** - Uses [Hyperfoil](https://hyperfoil.io) to perform load tests.

Custom drivers can be implemented by making a copy of the `_template` directory in `./src/scripts/drivers`,
renaming it and editing it to add the desired implementation.

### Select Strategies

Strategies are responsible for the manner in which testing is performed. This includes things like which options are passed to the test application and in which order steps are performed.

```bash
./run test -s aot sqpc/*
```

Right now there are two strategies: "normal" and "aot".
If no strategies are supplied the default is to use both "normal" and "aot", in that order.
The "normal" strategy doesn't do anything special and will just run each test in turn.
The "aot" strategy first performs a training run for each test and then restarts the test with the newly created AOT cache.

```bash
./run list-strategies
```

Custom strategies can be implemented by making a copy of the `_template` folder in the
`./src/scripts/strategies` directory, renaming it and editing the files inside it to add the desired implementation.

### Profiles

Profiles are source files defining sets of variables that can be passed to the test framework to make it behave in a certain way.
Certain variables might affect the test applications themselves (eg. `TEST_JAVA_OPTIONS` for passing custom option to the Java runtime),
others might affect the driver (eg. `TEST_DRIVER_CPUS`). If no profile is given the profile named `default` will be activated
automatically if it exists (by default it does _not_, you will have to create it yourself, for example by making a copy of the provided
`_template.sh` file in the `./profiles` directory, renaming it to `default.sh` and editing its contents).

The available profiles can be listed with:

```bash
./run list-profiles
```

And activated by running:

```bash
./run test -P lowmem sqpc/*
```

The activated profiles are added to the test output directory name so it is easy to see which test runs were executed with which profiles.

## Manual Test Control

You can manually control individual components:

```bash
# Do necessary setup (eg install commands, clone repos, compile)
./run app sqpc/spring-normal setup
./run infra sqpc/spring-normal setup
./run drive sqpc/spring-normal setup

# Start infrastructure & test app (also give driver chance to prepare)
./run infra sqpc/spring-normal start
./run drive sqpc/spring-normal prime
./run app sqpc/spring-normal start

# Run the tests
./run drive sqpc/spring-normal run

# And finally stop everything again
./run app sqpc/spring-normal stop
./run infra sqpc/spring-normal stop
```

## Available Test Suites

- **gqaot** - Some sample Quarkus applications
  - `quarkus-hibernate-orm-simple`
  - `quarkus-hibernate-orm-spacefox`
  - `quarkus-hibernate-orm-tribe-krd`
  - `simple-rest`
- **jpbrw**
  - `dead-loop`
  - `fibonacci`
  - `if-conditional-branch`
  - `nqueens`
- **sqpc** - Spring Quarkus Performance Comparison
  - `spring-normal` - Spring Boot compiled normally
  - `spring-sbaot` - Spring Boot compiled with Spring AOT optimization
  - `quarkus-aot` - Quarkus compiled and packaged with the AOT jar
  - `quarkus-native` - Quarkus natively compiled and packaged

Run `./run list` to see all available tests with descriptions.

## Creating New Tests

Main workloads are organized in a hierarchical structure under `tests/`:

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

To create a new suite, copy [`tests-template/suite_template`](tests-template/suite_template)
into `tests/<your-suite-name>` (we recommend a short name because you will type it often).

Once copied, review each file in your new suite directory. The templates include inline guidance
on what to customize.

For each test in that suite, copy
[`tests-template/suite_template/example_test`](tests-template/suite_template/example_test)
to `tests/<your-suite-name>/<your-test-name>` and edit it for your scenario.

If you want to validate harness behavior (rather than workload behavior), add checks under
`verify/bats/` and, if needed, dummy fixtures under `tests-dummy/`.

## Performance Analysis

Use the included Java utilities to analyze test results:

```bash
# Collate and compare results across multiple test runs
jbang src/java/util/Collate.java test-results/test-run-YYYYMMDD-HHMMSS
```

This will display graphs comparing:
- Total duration
- Requests per second
- Response time percentiles
- Request timing breakdowns

## Hardware Tweaks (Advanced)

For more stable performance testing on Linux, you can use hardware tweaks:

1. Edit [`hardware-tweaks.conf`](hardware-tweaks.conf) with your system's CPU settings
2. Run tests with: `./hwtweaked-run test sqpc/*`

**Warning:** This script modifies CPU frequency scaling and turbo boost settings. Use with caution!
