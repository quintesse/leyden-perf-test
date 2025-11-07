
# Leyden Performance Tests

These are some scripts to help with performance testing of different JVMs, especially focused on finding out the effect of the different AOT settings.

The requirements are that you have both Java and [oha](https://github.com/hatoo/oha) installed and available on your PATH.

The first time you have to run:

```
$ ./setup.sh
```

After that you can run `./run.sh <version>...` passing in the versions that you're interested in testing, for example:

```
./run.sh 24 25 26
```

The results for each test run are written to a folder named `test-run-XXXXX/jdk<VERSION>` that gets created inside the `test-results` folder.
For each test the performance results are written to a `<TESTNAME>-test.json` file and the standard output of the tests are written to `<TESTNAME>-app.out` files.
When the selected Jdk version is at least 25 or higher, AOT versions of all tests are automatically run and their results stored in a folder named `jdk<VERSION>aot`.

NB: the script uses [JBang](jbang.dev) to automatically switch between the selected Jdks. It will of course also automatically download any Jdks that aren't locally installed yet. But if you want to use specific builds of the Jdks it's up to you to make sure that you've explicitly/manually installed the correct Jdk using JBang before running the tests.

If you want to pass specific Java options to the test applications, you can do so by setting the `TEST_JAVA_OPTS` environment variable. For example:

```
TEST_JAVA_OPTS="-Xms128m -Xmx256m" ./run.sh 24 25 26
```

NB: The `run.sh` script has an optional first parameter, `--tag <tag>` or `-t <tag>`, that is a user-defined "tag" that can be used to mark the test-run folder. It is simply added to the name of the folder, so for example running `TEST_JAVA_OPTS="-Xms128m -Xmx256m" ./run.sh -t lowmem 24 25 26` would create a folder like `test-run-XXXXX-lowmem`.
