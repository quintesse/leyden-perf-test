# Leyden Performance Tests

These are some scripts to help with performance/load testing of different JVMs, especially focused on finding out the effect of the different Leyden AOT settings.

## Requirements

- Java (will be automatically downloaded by JBang if not present)
- [oha](https://github.com/hatoo/oha) - HTTP load testing tool
- Docker or Podman (for infrastructure services like PostgreSQL)

## Quick Start

The first time you need to set up the test applications:

```bash
./run setup
```

This will clone and compile all the test applications.

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

## Test Output

Test results are written to a folder in the `test-results/` directory with the format `test-run-YYYYMMDD-HHMMSS/j<VERSION>`. Each test produces:

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

Right now there's only a single driver, named `oha`, which is the driver that will be used if you don't specify this option.

When multiple drivers exist you can list the available ones running:

```bash
./run list-drivers
```

Currently existing drivers:

 - **oha** - Uses [oha](https://github.com/hatoo/oha) to perform load tests. Accepts an `TEST_DRIVER_OHA_RATE_LIMIT` env var to set a rate limit (requests per second) if so desired.

Custom drivers can be implemented by making a copy of the `_template.sh` file in the `./src/scripts/drivers`
directory, renaming it and editing it to add the desired implementation.

### Select Strategies

Strategies are responsible for the manner in which testing is performed. This includes things like which options are passed to the test application and in which order steps are performed.

```bash
./run test -s aot sqpc/*
```

Right now there are two strategies: "normal" and "aot".
If no strategies are supplied the default is to use both "normal" and "aot", in that order.
The "normal" strategy doesn't do anything special and will just run each test in turn.
The "aot" strategy first performs a training run for each test and will then restart the test whith the newly created AOT cache.

```bash
./run list-strategies
```

Custom strategies can be implemented by making a copy of the `_template.sh` file in the
`./src/scripts/strategies` directory, renaming it and editing it to add the desired implementation.

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

The activated profiles will be made part of the test output directory name so it will be easy to see which test runs where run with what profiles.

### Adding more tests

Adding a new suite of tests is best done by making a copy of the `_suite_template` directory that you can
find in the `./src/scripts/tests` directory and renaming it to something that will identify the tests that
you want to add (we recommend something short, you migh tbe typing the name a lot).

Once that copy is created take a look at each of the files in that directory, there's inline explanation in
each of them on how they are to be used. Edit them to perform the desired actions.

And finally for each of the tests that you want to add you make a copy of the `example_test` folder and
give it a unique (and short!) name. Like the suite itself there are files in the directory that you will
need to edit to run your tests in exactly the way you want them.

## Manual Test Control

You can manually control individual components:

```bash
# Manually start/stop infrastructure
./run infra sqpc/spring-normal start
./run infra sqpc/spring-normal stop

# Manually start/stop application
./run app sqpc/spring-normal start
./run app sqpc/spring-normal stop
```

## Available Test Suites

- **sqpc** - Spring Quarkus Performance Comparison
  - `spring-normal` - Spring Boot compiled normally
  - `spring-sbaot` - Spring Boot with Spring AOT optimization
  - `quarkus-normal` - Quarkus compiled normally
  - `quarkus-uberjar` - Quarkus packaged as uber-jar

Run `./run list` to see all available tests with descriptions.

## Creating New Tests

Tests are organized in a hierarchical structure under `src/scripts/tests/`:

```
tests/
  <suite-name>/
    setup.sh              # Suite-level setup (clone repos, etc.)
    infra.sh              # Suite-level infrastructure control
    shared-vars.sh        # Shared variables for all tests in suite
    urls.txt              # URLs to test with oha
    DESCRIPTION           # One-line description of the suite
    <test-name>/
      setup.sh            # Test-specific setup (compilation, etc.)
      app.sh              # Application start/stop control
      infra.sh            # Test-specific infrastructure (optional)
      DESCRIPTION         # One-line description of the test
```

See [`src/scripts/tests/_suite_template`](src/scripts/tests/_suite_template) for a complete template.

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
2. Run tests with: `./local-run-with-hardware-tweaks.sh test sqpc/*`

**Warning:** This script modifies CPU frequency scaling and turbo boost settings. Use with caution!
