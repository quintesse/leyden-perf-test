///usr/bin/env jbang "$0" "$@" ; exit $?
//DEPS io.hyperfoil:hyperfoil-core:0.27.1
//DEPS io.hyperfoil:hyperfoil-http:0.27.1
//DEPS info.picocli:picocli:4.7.5

import io.hyperfoil.api.config.Benchmark;
import io.hyperfoil.api.config.BenchmarkBuilder;
import io.hyperfoil.api.config.PhaseBuilder;
import io.hyperfoil.api.connection.Request;
import io.hyperfoil.api.processor.RawBytesHandler;
import io.hyperfoil.core.impl.LocalSimulationRunner;
import io.hyperfoil.http.api.HttpMethod;
import io.hyperfoil.http.config.HttpPluginBuilder;
import io.hyperfoil.http.config.Protocol;
import io.hyperfoil.http.steps.HttpStepCatalog;
import io.netty.buffer.ByteBuf;

import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;
import picocli.CommandLine.Parameters;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.concurrent.Callable;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReferenceArray;
import java.util.concurrent.locks.LockSupport;

@Command(name = "hyperfoil-wrk", mixinStandardHelpOptions = true, version = "1.0",
        description = "wrk/wrk2-like benchmark using Hyperfoil with sample recording")
public class HyperfoilWrk implements Callable<Integer> {

    private static final int CHUNK_SIZE = 4096;
    private static final int SAMPLES_PER_CHUNK = CHUNK_SIZE * 2;

    @Parameters(index = "0", description = "Target URL")
    private String url;

    @Option(names = {"-c", "--connections"}, description = "Number of connections", defaultValue = "10")
    private int connections;

    @Option(names = {"-t", "--threads"}, description = "Number of threads", defaultValue = "2")
    private int threads;

    @Option(names = {"-d", "--duration"}, description = "Duration (e.g., 10s, 1m)", defaultValue = "10s")
    private String duration;

    @Option(names = {"-R", "--rate"}, description = "Target requests per second (0 = unlimited/closed-loop)", defaultValue = "0")
    private int rate;

    @Option(names = {"-o", "--output"}, description = "Output CSV file", defaultValue = "results.csv")
    private String outputFile;

    @Option(names = {"-m", "--method"}, description = "HTTP method", defaultValue = "GET")
    private String method;

    @Option(names = {"--timeout"}, description = "Request timeout", defaultValue = "60s")
    private String timeout;

    private static final SampleRecorder RECORDER = new SampleRecorder();
    private static volatile Throwable benchmarkError = null;

    public static void main(String[] args) {
        int exitCode = new CommandLine(new HyperfoilWrk()).execute(args);
        System.exit(exitCode);
    }

    @Override
    public Integer call() throws Exception {
        System.out.printf("Running benchmark against %s%n", url);
        System.out.printf("  %d threads, %d connections, %s duration%n", threads, connections, duration);
        if (rate > 0) {
            System.out.printf("  Target rate: %d req/s (open-loop)%n", rate);
        } else {
            System.out.println("  Rate: unlimited (closed-loop)");
        }

        Benchmark benchmark;
        try {
            benchmark = buildBenchmark();
        } catch (URISyntaxException e) {
            System.err.println("Invalid URL: " + e.getMessage());
            return 1;
        }

        long startTime = System.currentTimeMillis();

        LocalSimulationRunner runner = new LocalSimulationRunner(benchmark);
        runner.run();

        long endTime = System.currentTimeMillis();

        long totalSamples = RECORDER.getTotalSamples();
        System.out.printf("%nBenchmark completed in %d ms%n", endTime - startTime);
        System.out.printf("Total samples recorded: %d%n", totalSamples);

        writeCsv();
        System.out.printf("Results written to %s%n", outputFile);

        return 0;
    }

    private Benchmark buildBenchmark() throws URISyntaxException {
        URI uri = new URI(url);
        String host = uri.getHost();
        int port = uri.getPort();
        String path = uri.getPath();
        if (path == null || path.isEmpty()) {
            path = "/";
        }
        if (uri.getQuery() != null) {
            path = path + "?" + uri.getQuery();
        }

        boolean isHttps = "https".equalsIgnoreCase(uri.getScheme());
        if (port < 0) {
            port = isHttps ? 443 : 80;
        }

        BenchmarkBuilder builder = BenchmarkBuilder.builder();
        builder.name("hyperfoil-wrk");
        builder.threads(threads);

        HttpPluginBuilder httpPlugin = builder.addPlugin(HttpPluginBuilder::new);
        httpPlugin.http()
                .host(host)
                .port(port)
                .sharedConnections(connections);

        if (isHttps) {
            httpPlugin.http().protocol(Protocol.HTTPS);
        }

        long durationMs = parseDuration(duration);
        int sessionsPerThread = Math.max(1, connections / threads);

        final String requestPath = path;

        PhaseBuilder<?> phaseBuilder;
        if (rate > 0) {
            int ratePerThread = Math.max(1, rate / threads);
            phaseBuilder = builder.addPhase("test").constantRate(ratePerThread)
                    .maxSessions(sessionsPerThread * 10);
        } else {
            phaseBuilder = builder.addPhase("test").always(sessionsPerThread);
        }

        SampleRecordingHandler sampleHandler = new SampleRecordingHandler(RECORDER);

        phaseBuilder.duration(durationMs)
                .scenario()
                .initialSequence("request")
                .step(HttpStepCatalog.class).httpRequest(HttpMethod.valueOf(method.toUpperCase()))
                .path(requestPath)
                .timeout(timeout)
                .handler()
                .rawBytes(sampleHandler)
                .endHandler()
                .endStep()
                .endSequence();

        return builder.build();
    }

    private long parseDuration(String duration) {
        duration = duration.trim().toLowerCase();
        long multiplier = 1000;
        String numPart = duration;

        if (duration.endsWith("ms")) {
            multiplier = 1;
            numPart = duration.substring(0, duration.length() - 2);
        } else if (duration.endsWith("s")) {
            multiplier = 1000;
            numPart = duration.substring(0, duration.length() - 1);
        } else if (duration.endsWith("m")) {
            multiplier = 60 * 1000;
            numPart = duration.substring(0, duration.length() - 1);
        } else if (duration.endsWith("h")) {
            multiplier = 60 * 60 * 1000;
            numPart = duration.substring(0, duration.length() - 1);
        }

        return Long.parseLong(numPart.trim()) * multiplier;
    }

    private void writeCsv() throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(outputFile))) {
            writer.write("url,startTimeNanos,start_latency_correction,endTimeNanos,duration");
            writer.newLine();

            //imitating OHA rows
            // url	start	start_latency_correction	end	duration
            RECORDER.forEach((startTime, endTime) -> {
                try {
                    writer.write(url);
                    writer.write(',');
                    writer.write(String.valueOf(startTime));
                    writer.write(',');
                    writer.write(',');
                    writer.write(String.valueOf(endTime));
                    writer.write(',');
                    writer.write(String.valueOf(endTime - startTime));
                    writer.newLine();
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            });
        }
    }

    /**
     * Handler that records request start/end times using Request identity hash as key.
     */
    public static class SampleRecordingHandler implements RawBytesHandler {
        private final SampleRecorder recorder;
        // Map request identity to sample position - uses identity hash
        private final ConcurrentHashMap<Integer, Long> requestToPosition = new ConcurrentHashMap<>();

        public SampleRecordingHandler(SampleRecorder recorder) {
            this.recorder = recorder;
        }

        @Override
        public void onRequest(Request request, ByteBuf connection, int offset, int length) {
            long position = recorder.recordStart();
            requestToPosition.put(System.identityHashCode(request), position);
        }

        @Override
        public void onResponse(Request request, ByteBuf byteBuf, int offset, int length, boolean isLastPart) {
            if (isLastPart) {
                Long position = requestToPosition.remove(System.identityHashCode(request));
                if (position != null) {
                    recorder.recordEnd(position);
                }
            }
        }
    }

    /**
     * Lock-free chunked sample recorder.
     */
    public static class SampleRecorder {
        private final AtomicLong index = new AtomicLong(0);
        private final AtomicReferenceArray<long[]> chunks;
        private final AtomicLong allocatingMask = new AtomicLong(0);

        private static final int MAX_CHUNKS = 1024;

        public SampleRecorder() {
            this.chunks = new AtomicReferenceArray<>(MAX_CHUNKS);
            this.chunks.set(0, new long[SAMPLES_PER_CHUNK]);
        }

        public long recordStart() {
            long startTime = System.nanoTime();
            long idx = index.getAndAdd(2);

            int chunkIndex = (int) (idx / SAMPLES_PER_CHUNK);
            int positionInChunk = (int) (idx % SAMPLES_PER_CHUNK);

            long[] chunk = getOrCreateChunk(chunkIndex);
            chunk[positionInChunk] = startTime;

            return idx;
        }

        public void recordEnd(long position) {
            long endTime = System.nanoTime();
            int chunkIndex = (int) (position / SAMPLES_PER_CHUNK);
            int positionInChunk = (int) (position % SAMPLES_PER_CHUNK);

            long[] chunk = chunks.get(chunkIndex);
            if (chunk != null) {
                chunk[positionInChunk + 1] = endTime;
            }
        }

        private long[] getOrCreateChunk(int chunkIndex) {
            if (chunkIndex >= MAX_CHUNKS) {
                throw new IllegalStateException("Exceeded maximum sample capacity");
            }

            long[] chunk = chunks.get(chunkIndex);
            if (chunk != null) {
                return chunk;
            }

            long mask = 1L << (chunkIndex & 63);
            while (true) {
                long current = allocatingMask.get();
                if ((current & mask) != 0) {
                    chunk = chunks.get(chunkIndex);
                    while (chunk == null) {
                        LockSupport.parkNanos(50);
                        chunk = chunks.get(chunkIndex);
                    }
                    return chunk;
                }

                if (allocatingMask.compareAndSet(current, current | mask)) {
                    try {
                        chunk = chunks.get(chunkIndex);
                        if (chunk == null) {
                            chunk = new long[SAMPLES_PER_CHUNK];
                            chunks.set(chunkIndex, chunk);
                        }
                        return chunk;
                    } finally {
                        allocatingMask.getAndUpdate(v -> v & ~mask);
                    }
                }
            }
        }

        public long getTotalSamples() {
            return index.get() / 2;
        }

        public void forEach(SampleConsumer consumer) {
            long totalSlots = index.get();

            for (long i = 0; i < totalSlots; i += 2) {
                int chunkIndex = (int) (i / SAMPLES_PER_CHUNK);
                int positionInChunk = (int) (i % SAMPLES_PER_CHUNK);

                long[] chunk = chunks.get(chunkIndex);
                if (chunk != null) {
                    long startTime = chunk[positionInChunk];
                    long endTime = chunk[positionInChunk + 1];
                    if (startTime != 0 && endTime != 0) {
                        consumer.accept(startTime, endTime);
                    }
                }
            }
        }
    }

    @FunctionalInterface
    public interface SampleConsumer {
        void accept(long startTime, long endTime);
    }
}