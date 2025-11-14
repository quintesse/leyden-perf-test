public record Oha(
    String url,
    double start,
    Double startLatencyCorrection,
    double end,
    double duration,
    int status,
    long lenBytes,
    int run
) {
    // Note: startLatencyCorrection is an object (Double)
    // because the SQLite column is nullable (no NOT NULL constraint).
}
