//SOURCES Result.java Oha.java Graph.java
//JAVA 21+

import java.nio.file.*;
import java.util.*;
import java.util.function.Function;

public class Collate {
    public static void main(String[] args) {
        if (args.length != 1) {
            System.err.println("Usage: jbang Collate.java <test-results-folder>");
            System.exit(1);
        }
        Path resultsFolder = Path.of(args[0]);
        if (!Files.isDirectory(resultsFolder)) {
            System.err.println("Provided path does not exist or is not a directory: " + resultsFolder);
            System.exit(1);
        }
        Map<String, Result> results = readResults(resultsFolder);

        System.out.println("Total duration (lower is better)");
        System.out.println(Graph.graph(pick(results, r -> r.summary().total() * 1000d), "%6.1fms"));
        System.out.println();

        System.out.println("Requests per second (higher is better)");
        System.out.println(Graph.graph(pick(results, r -> r.summary().requestsPerSec()), "%6.0fr/s"));
        System.out.println();

        System.out.println("Slowest (lower is better)");
        System.out.println(Graph.graph(pick(results, r -> r.summary().slowest() * 1000d), "%6.1fms"));
        System.out.println();

        System.out.println("Fastest (lower is better)");
        System.out.println(Graph.graph(pick(results, r -> r.summary().fastest() * 1000d), "%6.1fms"));
        System.out.println();

        System.out.println("Average (lower is better)");
        System.out.println(Graph.graph(pick(results, r -> r.summary().average() * 1000d), "%6.1fms"));
        System.out.println();

        Map<String, List<Oha>> requests = readRequests(resultsFolder);

        for (int limit : List.of(10, 100, 1000, 10000)) {
            requests.forEach((k, ohas) -> {
                System.out.println("Timings for first " + limit + " requests for " + k);
                Map<String, Number> avgDurations = avgRequestDurations(ohas, 10, limit);
                System.out.println(Graph.graph(avgDurations, "%6.1fms"));
                System.out.println();
            });
        }
    }

    // Collapse a list of requests and return a list of durations of maximum
    // `maxEntries` entries, calculating the average duration for each entry.
    // The key of each entry is either its index in the original list, or if
    // we have more than `maxEntries` entries, a range like "21-30"
    private static Map<String, Number> avgRequestDurations(List<Oha> requests, int maxEntries, int limit) {
        Map<String, Number> result = new LinkedHashMap<>();
        int size = Math.min(requests.size(), limit);
        if (size == 0) return result;

        if (size <= maxEntries) {
            for (int i = 0; i < size; i++) {
                result.put(String.valueOf(i + 1), requests.get(i).duration() * 1000d);
            }
        } else {
            int groupSize = (int) Math.ceil(size / (double) maxEntries);
            for (int i = 0; i < maxEntries; i++) {
                int startIdx = i * groupSize;
                int endIdx = Math.min(startIdx + groupSize, size);
                if (startIdx >= endIdx) break;
                double avg = 0;
                for (int j = startIdx; j < endIdx; j++) {
                    avg += requests.get(j).duration() * 1000d;
                }
                avg /= (endIdx - startIdx);
                String key = (startIdx + 1) + "-" + endIdx;
                result.put(key, avg);
            }
        }
        return result;
    }

    private static Map<String, Result> readResults(Path resultsFolder) {
        Map<String, Result> results = new TreeMap<>();
        try (var paths = Files.walk(resultsFolder)) {
            paths.filter(path -> path.getFileName().toString().endsWith("-test.json"))
                    .forEach(path -> {
                        try {
                            Result result = Result.parse(path);
                            String key = path.getParent().getFileName() + "-"
                                    + path.getFileName().toString().replace("-test.json", "");
                            results.put(key, result);
                        } catch (Exception e) {
                            System.err.println("Failed to parse result file: " + path);
                            e.printStackTrace();
                        }
                    });
        } catch (Exception e) {
            System.err.println("Error walking results folder OHA json files: " + resultsFolder);
            e.printStackTrace();
        }
        return results;
    }

    private static Map<String, List<Oha>> readRequests(Path resultsFolder) {
        Map<String, List<Oha>> result = new TreeMap<>();
        try (var paths = Files.walk(resultsFolder)) {
            paths.filter(path -> path.getFileName().toString().endsWith("-test.db"))
                    .forEach(path -> {
                        try {
                            List<Oha> ohaList = Oha.read(path);
                            String key = path.getParent().getFileName() + "-"
                                    + path.getFileName().toString().replace("-test.db", "");
                            result.put(key, ohaList);
                        } catch (Exception e) {
                            System.err.println("Failed to read OHA database file: " + path);
                            e.printStackTrace();
                        }
                    });
        } catch (Exception e) {
            System.err.println("Error walking results folder for OHA databases: " + resultsFolder);
            e.printStackTrace();
        }
        return result;
    }

    private static Map<String, Number> pick(Map<String, Result> data, Function<Result, Number> picker) {
        Map<String, Number> result = new TreeMap<>();
        data.forEach((k, v) -> result.put(k, picker.apply(v)));
        return result;
    }
}
