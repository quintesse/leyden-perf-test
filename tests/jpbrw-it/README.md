# Integration-test-trained AOT benchmarks

Use the normal strategy for this suite:

```bash
./run test -j 25,26 -s normal 'jpbrw-it/*'
./run qdup -j 25,26 -s normal 'jpbrw-it/*'
```

`app_setup` builds the benchmark dependency and wrapper with the selected JDK,
then runs the workload's `@QuarkusIntegrationTest` class with Quarkus AOT
generation enabled. Setup always retrains, even when a JAR already exists,
because the test cache is shared across JDK selections and source updates.
Training happens before the measured driver run, on the application host in
qDup. No cache transfer between roles is needed.

`app_start` checks `wrapper/target/quarkus-app/app.aot` and its JDK record,
then launches with `-XX:AOTMode=on -XX:AOTCache=...`. Missing caches or a
different JDK installation/build require another setup. JDK 25 or newer is
required. The harness `aot` strategy is rejected because it supplies its own
training and cache options.

For manual setup/start, pass the same `-j` value to both commands. Keep the
generated application and cache together; do not rebuild between setup and
start. Successful Maven build logs are handled by the standard build helper.

The four workload classes are FibonacciBenchmarkIT, NQueensBenchmarkIT,
IfConditionalBranchBenchmarkIT, and DeadLoopEliminationBenchmarkIT. Only the
class matching the selected workload runs during training.
