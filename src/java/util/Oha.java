//DEPS org.xerial:sqlite-jdbc:3.51.0.0

import java.sql.*;
import java.nio.file.Path;
import java.util.*;

public record Oha(
        String url,
        double start,
        // Note: startLatencyCorrection is an object (Double)
        // because the SQLite column is nullable (no NOT NULL constraint).
        Double startLatencyCorrection,
        double end,
        double duration,
        int status,
        long lenBytes,
        int run) {

    public static List<Oha> read(Path dbFile) throws SQLException {
        List<Oha> result = new ArrayList<>();
        try (Connection connection = DriverManager.getConnection("jdbc:sqlite:" + dbFile);
                Statement statement = connection.createStatement();) {
            statement.setQueryTimeout(30);
            ResultSet rs = statement.executeQuery("select * from oha");
            while (rs.next()) {
                Oha oha = new Oha(
                        rs.getString("url"),
                        rs.getDouble("start"),
                        rs.getObject("start_latency_correction") != null ? rs.getDouble("start_latency_correction") : null,
                        rs.getDouble("end"),
                        rs.getDouble("duration"),
                        rs.getInt("status"),
                        rs.getLong("len_bytes"),
                        rs.getInt("run"));
                result.add(oha);
            }
            return result;
        }
    }
}
