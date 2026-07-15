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

The activated profiles will be made part of the test output directory name so it will be easy to see which test runs where run with what profiles.

## Manual Test Control

You can manually control individual components:

```bash
# Do necessary setup (eg install commands, clone repos, compile)
./run app sqpc/spring-normal setup
./run infra sqpc/spring-normal setup
./run drive sqpc/spring-normal setup

# Start infrastructure & test app (also give driver chance to prepare)
./run infra sqpc/spring-normal start
./run drive sqpc/spring-normal prepare
./run app sqpc/spring-normal start

# Run the tests
./run drive sqpc/spring-normal run

# And finally start everything again
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
  - `quarkus` - Simple Quarkus app
- **sqpc** - Spring Quarkus Performance Comparison
  - `spring-normal` - Spring Boot compiled normally
  - `spring-sbaot` - Spring Boot compiled with Spring AOT optimization
  - `quarkus-aot` - Quarkus compiled and packaged with the AOT jar
  - `quarkus-native` - Quarkus natively compiled and packaged

Run `./run list` to see all available tests with descriptions.

## Creating New Tests

Tests are organized in a hierarchical structure under `tests/`:

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

Adding a new suite of tests is best done by making a copy of the [`_suite_template`](tests/_suite_template) 
directory and renaming it to something that will identify the tests that you want to add (we recommend something short,
you migh tbe typing the name a lot).

Once that copy is created take a look at each of the files in that directory, there's inline explanation in
each of them on how they are to be used. Edit them to perform the desired actions.

And finally for each of the tests that you want to add you make a copy of the [`example_test`](tests/_suite_template/example_test)
folder and give it a unique (and short!) name. Like the suite itself there are files in the directory that you will
need to edit to run your tests in exactly the way you want them.

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
