
# Leyden Performance Tests

These are some scripts to help with performance testing of different JVMs, especially focused on finding out the effect of the different AOT settings.

The requiremtns are that you have both Java and [oha](https://github.com/hatoo/oha) installed and available on your PATH.

The first time you have to run:

```
$ ./setup.sh
```

After that you can activate the JVM you're interested in testing and run

```
./run.sh
```

The test results for each application are written to `*.out` files in a `test-results` folder.

To enable AOT run:

```
TEST_USE_AOT=true ./run.sh
```
