///usr/bin/env jbang "$0" "$@" ; exit $?
//DEPS io.hyperfoil:hyperfoil-core:0.27.1
//DEPS io.hyperfoil:hyperfoil-http:0.27.1
//DEPS org.aesh:aesh:2.8.4
//DEPS io.netty:netty-transport-native-unix-common:4.2.1.Final

import io.hyperfoil.api.config.Benchmark;
import io.hyperfoil.api.config.BenchmarkBuilder;
import io.hyperfoil.api.config.PhaseBuilder;
import io.hyperfoil.api.connection.Request;
import io.hyperfoil.api.processor.RawBytesHandler;
import io.hyperfoil.api.session.Session;
import io.hyperfoil.core.impl.LocalSimulationRunner;
import io.hyperfoil.function.SerializableFunction;
import io.hyperfoil.http.api.HttpMethod;
import io.hyperfoil.http.api.HttpRequest;
import io.hyperfoil.http.config.HttpPluginBuilder;
import io.hyperfoil.http.config.Protocol;
import io.hyperfoil.http.steps.HttpStepCatalog;
import io.netty.buffer.ByteBuf;

import org.aesh.command.Command;
import org.aesh.command.CommandDefinition;
import org.aesh.command.CommandResult;
import org.aesh.command.invocation.CommandInvocation;
import org.aesh.command.option.Arguments;
import org.aesh.command.option.Option;
import org.aesh.AeshRuntimeRunner;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReference;
import java.util.concurrent.atomic.AtomicReferenceFieldUpdater;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.io.BufferedReader;

import sun.misc.Signal;
import sun.misc.SignalHandler;

@CommandDefinition(name = "hyperfoil-wrk", description = "wrk/wrk2-like benchmark using Hyperfoil with sample recording")
public class HyperfoilWrk implements Command<CommandInvocation> {

    @Arguments(description = "Target URL(s) — all must share the same host:port")
    private List<String> urls;

    @Option(shortName = 'f', name = "file", description = "File that contains the urls", defaultValue = "urls.txt")
    private File urlFile;

    @Option(shortName = 'c', name = "connections", description = "Number of connections", defaultValue = {"10"})
    private int connections;

    @Option(shortName = 't', name = "threads", description = "Number of threads", defaultValue = {"2"})
    private int threads;

    @Option(shortName = 'd', name = "duration", description = "Duration (e.g., 10s, 1m)", defaultValue = {"10s"})
    private String duration;

    @Option(shortName = 'R', name = "rate", description = "Target requests per second (0 = unlimited/closed-loop)", defaultValue = {"0"})
    private int rate;

    @Option(shortName = 'o', name = "output", description = "Test out dir", defaultValue = {"."})
    private String outputDirectory;

    @Option(shortName = 'm', name = "method", description = "HTTP method", defaultValue = {"GET"})
    private String method;

    @Option(name = "timeout", description = "Request timeout", defaultValue = {"60s"})
    private String timeout;

    @Option(shortName = 'i', name = "identifier", description = "Test identifier", defaultValue = {"unknown"})
    private String identifier;

    private static final long NIL_VALUE = System.nanoTime();
    private static final AtomicLong BASELINE_NANOS = new AtomicLong(NIL_VALUE);
    private SampleRecorder recorder;

    private Boolean youCanRestNow = false;

    public static void main(String[] args) {
        AeshRuntimeRunner.builder()
                .command(HyperfoilWrk.class)
                .args(args)
                .execute();
    }

    @Override
    public CommandResult execute(CommandInvocation invocation) throws InterruptedException {
        try {
            loadUris();
            URI firstUri = new URI(urls.get(0));
            String targetHost = firstUri.getHost() + ":" + (firstUri.getPort() > 0 ? firstUri.getPort()
                    : ("https".equalsIgnoreCase(firstUri.getScheme()) ? 443 : 80));
            invocation.println("Running benchmark against " + targetHost + " (" + urls.size() + " URL"
                    + (urls.size() > 1 ? "s" : "") + ")");
            for (String u : urls) {
                invocation.println("  -> " + u);
            }
            invocation.println("  " + threads + " threads, " + connections + " connections, " + duration + " duration");
            if (rate > 0) {
                invocation.println("  Target rate: " + rate + " req/s (open-loop)");
            } else {
                invocation.println("  Rate: unlimited (closed-loop)");
            }

            if (rate > 0) {
                long durationMs = parseDuration(duration);
                long expectedSamples = rate * ((durationMs + 999) / 1000);
                recorder = new SampleRecorder(expectedSamples);
            } else {
                recorder = new SampleRecorder();
            }

            Benchmark benchmark;
            try {
                benchmark = buildBenchmark();
            } catch (URISyntaxException e) {
                invocation.println("Invalid URL: " + e.getMessage());
                return CommandResult.FAILURE;
            }

            File f = new File(outputDirectory + File.separator + identifier + ".hyperfoil-ready");
            f.createNewFile();
            f.deleteOnExit();
            
            SignalHandler handler = new SignalHandler() {
                public void handle(Signal signal) {
                    try {
                        runBenchmark(invocation, benchmark, firstUri.getHost(), firstUri.getPort());
                    } catch (Exception e) {
                        invocation.println("Error: " + e.getMessage());
                    } finally {
                        youCanRestNow = true;
                    }
                }
            };
            Signal.handle(new Signal("CONT"), handler);

            while (!youCanRestNow) {
                Thread.sleep(100);
            }

            return CommandResult.SUCCESS;
        } catch (Exception e) {
            invocation.println("Error: " + e.getMessage());
            return CommandResult.FAILURE;
        }
    }

    private void runBenchmark(CommandInvocation invocation, Benchmark benchmark, String host, Integer port) throws IOException {
        long startTime = System.nanoTime();
        invocation.println("Waiting for port to open.");

        //Measure time to port open
        int attempts = 0;

        while (true) {
            if (attempts % 1000000 == 0 && System.nanoTime() - startTime > 60000000000l) {
                invocation.println("Timeout waiting for Time to port open after " + attempts + " attempts.");
                break;
            }
            try (Socket _ = new Socket(host, port)) {
                var endTime = System.nanoTime();
                writeTimeToPortCsv(endTime - startTime);
                invocation.println(identifier + " => Startime: " + startTime + " Attempts: " + attempts);
                startTime = endTime;
                break;
            } catch (IOException e) {
                // Connection failed, retry immediately      
            } finally {
                attempts++;
            }
        }
        
        LocalSimulationRunner runner = new LocalSimulationRunner(benchmark);
        runner.run();

        long endTime = System.nanoTime();

        long totalSamples = recorder.getTotalSamples();
        invocation.println("");
        invocation.println("Benchmark completed in " + (endTime - startTime) + " ns");
        invocation.println("Total samples recorded: " + totalSamples);

        writeCsv();
        invocation.println("Results written to " + outputDirectory);
    }

    private void loadUris() throws URISyntaxException {
        this.urls = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(urlFile)))) {
            String line;
            while ((line = br.readLine()) != null) {
                urls.add(line);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private Benchmark buildBenchmark() throws URISyntaxException {
        URI firstUri = new URI(urls.get(0));
        String host = firstUri.getHost();
        boolean isHttps = "https".equalsIgnoreCase(firstUri.getScheme());
        int port = firstUri.getPort();
        if (port < 0) {
            port = isHttps ? 443 : 80;
        }

        List<String> paths = new ArrayList<>();
        for (String rawUrl : urls) {
            URI uri = new URI(rawUrl);
            boolean uriHttps = "https".equalsIgnoreCase(uri.getScheme());
            int uriPort = uri.getPort();
            if (uriPort < 0) {
                uriPort = uriHttps ? 443 : 80;
            }
            if (!host.equalsIgnoreCase(uri.getHost()) || port != uriPort) {
                throw new URISyntaxException(rawUrl,
                        "All URLs must share the same host:port (expected " + host + ":" + port + ")");
            }
            String p = uri.getPath();
            if (p == null || p.isEmpty()) {
                p = "/";
            }
            if (uri.getQuery() != null) {
                p = p + "?" + uri.getQuery();
            }
            paths.add(p);
        }

        BenchmarkBuilder builder = BenchmarkBuilder.builder()
                .name("hyperfoil-wrk")
                .threads(threads)
                .addPlugin(HttpPluginBuilder::new)
                    .ergonomics()
                        .repeatCookies(false)
                        .userAgentFromSession(false)
                    .endErgonomics()
                    .http()
                        .protocol(isHttps ? Protocol.HTTPS : Protocol.HTTP)
                        .host(host)
                        .port(port)
                        .sharedConnections(connections)
                        .useHttpCache(false)
                    .endHttp()
                .endPlugin();

        long durationMs = parseDuration(duration);
        long timeoutMs = parseDuration(timeout);

        PhaseBuilder<?> phaseBuilder;
        if (rate > 0) {
            phaseBuilder = builder.addPhase("test").constantRate(rate)
                    .variance(false)
                    .maxSessions(rate * 15);
        } else {
            phaseBuilder = builder.addPhase("test").always(connections);
        }

        String[] pathArray = paths.toArray(new String[0]);
        int pathCount = pathArray.length;
        AtomicLong roundRobin = new AtomicLong(0);

        HashMap<String, Integer> tmp = new HashMap<>();
        for (int i = 0; i < pathCount; i++) {
            tmp.put(pathArray[i], i);
        }
        Map<String, Integer> pathToUrlId = Map.copyOf(tmp);

        var scenarioBuilder = phaseBuilder.duration(durationMs)
                .maxDuration(durationMs + timeoutMs)
                .scenario();
        scenarioBuilder.maxRequests(1);
        scenarioBuilder.maxSequences(1);

        scenarioBuilder.initialSequence("request")
                .step(HttpStepCatalog.class).httpRequest(HttpMethod.valueOf(method.toUpperCase()))
                    .path((SerializableFunction<Session, String>) session -> {
                        int idx = (int) (roundRobin.getAndIncrement() % pathCount);
                        return pathArray[idx];
                    })
                    .timeout(timeout)
                    .handler()
                        .rawBytes(new SampleRecordingHandler(recorder, pathToUrlId, BASELINE_NANOS))
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
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(outputDirectory + File.separator + identifier + ".csv"))) {
            //imitating OHA rows
            // url	start	start_latency_correction	end	duration
            writer.write("url,startTimeNanos,start_latency_correction,endTimeNanos,duration");
            writer.newLine();

            long baseline = BASELINE_NANOS.get();
            recorder.forEach((startTime, endTime, urlId) -> {
                try {
                    writer.write(urls.get(urlId));
                    writer.write(',');
                    writer.write(String.valueOf(startTime - baseline));
                    writer.write(',');
                    writer.write(',');
                    writer.write(String.valueOf(endTime - baseline));
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
     * Handler that records request start/end times using Hyperfoil's built-in timestamp.
     */
    public static class SampleRecordingHandler implements RawBytesHandler {
        private final SampleRecorder recorder;
        private final Map<String, Integer> pathToUrlId;
        private final AtomicLong baselineNanos;

        public SampleRecordingHandler(SampleRecorder recorder, Map<String, Integer> pathToUrlId, AtomicLong baselineNanos) {
            this.recorder = recorder;
            this.pathToUrlId = pathToUrlId;
            this.baselineNanos = baselineNanos;
        }

        @Override
        public void onRequest(Request request, ByteBuf buf, int offset, int length) {
            long startTime = request.startTimestampNanos();
            baselineNanos.updateAndGet(cur -> cur == NIL_VALUE ? startTime : Math.min(cur, startTime));
        }

        @Override
        public void onResponse(Request request, ByteBuf buf, int offset, int length, boolean isLastPart) {
            if (isLastPart && request.isValid()) {
                long startTimeNanos = request.startTimestampNanos();
                long endTimeNanos = System.nanoTime();
                short urlId = pathToUrlId.get(((HttpRequest) request).path).shortValue();
                recorder.record(startTimeNanos, endTimeNanos, urlId);
            }
        }
    }

    /**
     * Lock-free append-only sample recorder using linked chunks.
     * Algorithm inspired by AppendOnlyList from type-pollution-agent
     * (a mix of JCTools MpscUnboundedXaddArrayQueue and Michael-Scott queue).
     * Each chunk holds CHUNK_SIZE samples in a long[] of double capacity
     * (startTime at offset*2, endTime at offset*2+1) plus a short[] for urlIds.
     *
     * When expectedSamples > 0, all chunks are pre-allocated at construction,
     * so record() is just an atomic increment + plain array write with no CAS.
     */
    public static class SampleRecorder {
        private static final int CHUNK_SIZE = 4096;
        private static final int CHUNK_MASK = CHUNK_SIZE - 1;
        private static final int CHUNK_SHIFT = Integer.numberOfTrailingZeros(CHUNK_SIZE);

        private final AtomicLong appenderSequence = new AtomicLong();
        private final Chunk firstChunk;
        private final Chunk[] chunks;
        private final AtomicReference<Chunk> lastChunk;

        private static final class Chunk {
            private static final AtomicReferenceFieldUpdater<Chunk, Chunk> NEXT_UPDATER =
                    AtomicReferenceFieldUpdater.newUpdater(Chunk.class, Chunk.class, "next");
            final long[] data;
            final short[] urlIds;
            long id;
            Chunk prev;
            volatile Chunk next;

            Chunk(long id) {
                this(id, null);
            }

            Chunk(long id, Chunk prev) {
                this.data = new long[CHUNK_SIZE << 1];
                this.urlIds = new short[CHUNK_SIZE];
                this.id = id;
                this.prev = prev;
            }

            boolean trySetNext(Chunk next) {
                return NEXT_UPDATER.compareAndSet(this, null, next);
            }
        }

        public SampleRecorder() {
            firstChunk = new Chunk(0);
            chunks = null;
            lastChunk = new AtomicReference<>();
            lastChunk.lazySet(firstChunk);
        }

        public SampleRecorder(long expectedSamples) {
            int numChunks = (int) ((expectedSamples + CHUNK_SIZE - 1) >> CHUNK_SHIFT);
            if (numChunks < 1) {
                numChunks = 1;
            }
            chunks = new Chunk[numChunks];
            chunks[0] = new Chunk(0);
            for (int i = 1; i < numChunks; i++) {
                chunks[i] = new Chunk(i, chunks[i - 1]);
                chunks[i - 1].next = chunks[i];
            }
            firstChunk = chunks[0];
            lastChunk = null;
        }

        public void record(long startTime, long endTime, short urlId) {
            long pIndex = appenderSequence.getAndIncrement();
            int offset = (int) (pIndex & CHUNK_MASK);
            long chunkId = pIndex >> CHUNK_SHIFT;

            Chunk chunk;
            if (chunks != null) {
                chunk = chunks[(int) chunkId];
            } else {
                chunk = lastChunk.get();
                if (chunk.id != chunkId) {
                    chunk = producerChunkForIndex(chunk, chunkId);
                }
            }
            int base = offset << 1;
            chunk.data[base] = startTime;
            chunk.data[base + 1] = endTime;
            chunk.urlIds[offset] = urlId;
        }

        private Chunk producerChunkForIndex(Chunk initialChunk, long requiredChunkId) {
            Chunk currentChunk = initialChunk;
            long jumpBackward;
            Chunk tmpChunk = null;
            while (true) {
                if (currentChunk == null) {
                    currentChunk = lastChunk.get();
                }
                long currentChunkId = currentChunk.id;
                jumpBackward = currentChunkId - requiredChunkId;
                if (jumpBackward >= 0) {
                    break;
                }
                long nextChunkId = currentChunkId + 1;
                Chunk nextChunk;
                if ((nextChunk = currentChunk.next) != null) {
                    lastChunk.compareAndSet(currentChunk, nextChunk);
                    if (requiredChunkId == nextChunkId) {
                        return nextChunk;
                    }
                    currentChunk = null;
                } else {
                    if (tmpChunk == null) {
                        tmpChunk = new Chunk(nextChunkId, currentChunk);
                    } else {
                        tmpChunk.id = nextChunkId;
                        tmpChunk.prev = currentChunk;
                    }
                    if (currentChunk.trySetNext(tmpChunk)) {
                        lastChunk.compareAndSet(currentChunk, tmpChunk);
                        if (requiredChunkId == nextChunkId) {
                            return tmpChunk;
                        }
                        currentChunk = null;
                        tmpChunk = null;
                    } else {
                        tmpChunk.prev = null;
                        nextChunk = currentChunk.next;
                        lastChunk.compareAndSet(currentChunk, nextChunk);
                        if (requiredChunkId == nextChunkId) {
                            return nextChunk;
                        }
                        currentChunk = null;
                    }
                }
            }
            for (long i = 0; i < jumpBackward; i++) {
                currentChunk = currentChunk.prev;
            }
            return currentChunk;
        }

        public long getTotalSamples() {
            return appenderSequence.get();
        }

        public void forEach(SampleConsumer consumer) {
            long remaining = appenderSequence.get();
            if (remaining == 0) {
                return;
            }
            Chunk currentChunk = firstChunk;
            while (remaining > 0) {
                int batch = (int) Math.min(CHUNK_SIZE, remaining);
                for (int i = 0; i < batch; i++) {
                    int base = i << 1;
                    long startTime = currentChunk.data[base];
                    long endTime = currentChunk.data[base + 1];
                    if (startTime != 0) {
                        consumer.accept(startTime, endTime, currentChunk.urlIds[i]);
                    }
                }
                remaining -= batch;
                if (remaining > 0) {
                    currentChunk = currentChunk.next;
                }
            }
        }
    }
    
    private void writeTimeToPortCsv(Long time) throws IOException {

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(outputDirectory + File.separator + "time-to-8080.csv", true))) {
            writer.write(identifier);
            writer.write(',');
            writer.write(time.toString());
            writer.newLine();
        } 
    }


    @FunctionalInterface
    public interface SampleConsumer {
        void accept(long startTime, long endTime, short urlId);
    }
}
