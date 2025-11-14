//DEPS com.google.code.gson:gson:2.10.1

import java.io.IOException;
import java.io.Reader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;

import com.google.gson.Gson;

public record Result(
    Summary summary,
    Map<String, Integer> responseTimeHistogram,
    LatencyPercentiles latencyPercentiles,
    Rps rps,
    Details details,
    Map<String, Integer> statusCodeDistribution,
    Map<String, Integer> errorDistribution
) {
    public record Summary(
        double successRate,
        double total,
        double slowest,
        double fastest,
        double average,
        double requestsPerSec,
        int totalData,
        int sizePerRequest,
        double sizePerSec
    ) {}

    public record LatencyPercentiles(
        double p10,
        double p25,
        double p50,
        double p75,
        double p90,
        double p95,
        double p99,
        double p99_9,
        double p99_99
    ) {}

    public record Rps(
        double mean,
        double stddev,
        double max,
        double min,
        Percentiles percentiles
    ) {
        public record Percentiles(
            double p10,
            double p25,
            double p50,
            double p75,
            double p90,
            double p95,
            double p99,
            double p99_9,
            double p99_99
        ) {}
    }

    public record Details(
        DNSDialup DNSDialup,
        DNSLookup DNSLookup
    ) {
        public record DNSDialup(
            double average,
            double fastest,
            double slowest
        ) {}

        public record DNSLookup(
            double average,
            double fastest,
            double slowest
        ) {}
    }

    public static Result parse(Path jsonPath) throws IOException {
        // Read and parse file using Gson
        Gson gson = new Gson();
        try (Reader reader = Files.newBufferedReader(jsonPath)) {
            return gson.fromJson(reader, Result.class);
        }
    }
}