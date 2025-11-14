//SOURCES Result.java Graph.java
//JAVA 21+

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.TreeMap;
import java.util.Map;
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

        System.out.println("Total duration");
        System.out.println(Graph.graph(pick(results, r -> r.summary().total() * 1000d), "ms"));
        System.out.println();
        
        System.out.println("Slowest");
        System.out.println(Graph.graph(pick(results, r -> r.summary().slowest() * 1000d), "ms"));
        System.out.println();
        
        System.out.println("Fastest");
        System.out.println(Graph.graph(pick(results, r -> r.summary().fastest() * 1000d), "ms"));
        System.out.println();
        
        System.out.println("Average");
        System.out.println(Graph.graph(pick(results, r -> r.summary().average() * 1000d), "ms"));
        System.out.println();
    }

    private static Map<String, Result> readResults(Path resultsFolder) {
        Map<String, Result> results = new TreeMap<>();
        try (var paths = Files.walk(resultsFolder)) {
            paths.filter(path -> path.getFileName().toString().endsWith("-test.json"))
                 .forEach(path -> {
                     try {
                         Result result = Result.parse(path);
                         String key = path.getParent().getFileName() + "-" + path.getFileName().toString().replace("-test.json", "");
                         results.put(key, result);
                     } catch (Exception e) {
                         System.err.println("Failed to parse result file: " + path);
                         e.printStackTrace();
                     }
                 });
        } catch (Exception e) {
            System.err.println("Error walking results folder: " + resultsFolder);
            e.printStackTrace();
        }
        return results;
    }

    private static Map<String, Number> pick(Map<String, Result> data, Function<Result, Number> picker) {
        Map<String, Number> result = new TreeMap<>();
        data.forEach((k, v) -> result.put(k, picker.apply(v)));
        return result;
    }
}
