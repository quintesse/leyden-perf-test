//SOURCES Bar.java

import java.util.Map;

public class Graph {
    private final Number minValue;
    private final Number maxValue;
    private final int width;
    
    
    public Graph(Number minValue, Number maxValue) {
        this(minValue, maxValue, 40);
    }

    public Graph(Number minValue, Number maxValue, int width) {
        // Initialize graph parameters
        this.minValue = minValue;
        this.maxValue = maxValue;
        this.width = width;
    }

    public String render(Map<String, Number> data, String unit) {
        StringBuilder sb = new StringBuilder();
        for (var entry : data.entrySet()) {
            String label = entry.getKey();
            Number value = entry.getValue();
            String bar = Bar.bar(value, minValue, maxValue, width);
            sb.append(String.format("%-15s | %5.1f%s | %s%n", label, value, unit, bar));
        }
        return sb.toString();
    }

    public static String graph(Map<String, Number> data, String unit) {
        double maxValue = data.values().stream().mapToDouble(Number::doubleValue).max().orElse(1);
        return new Graph(0, maxValue).render(data, unit);
    }
}
