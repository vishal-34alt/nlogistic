package db_config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** One reliable connection entrypoint with support for environment variables in production. */
public final class GetConnection {

    private GetConnection() {}

    private static String getEnv(String name, String fallback) {
        String val = System.getenv(name);
        return (val != null && !val.trim().isEmpty()) ? val.trim() : fallback;
    }

    private static String getJdbcUrl() {
        // Direct custom JDBC URL if provided
        String directUrl = System.getenv("DB_URL");
        if (directUrl != null && !directUrl.trim().isEmpty()) {
            return directUrl.trim();
        }

        // Support standard DB_* and Railway/Render-style MYSQL* environment variables
        String host = getEnv("DB_HOST", getEnv("MYSQLHOST", "localhost"));
        String port = getEnv("DB_PORT", getEnv("MYSQLPORT", "3306"));
        String dbName = getEnv("DB_NAME", getEnv("MYSQLDATABASE", "n_logistic_test_db"));

        return "jdbc:mysql://" + host + ":" + port + "/" + dbName
                + "?connectTimeout=5000&allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
    }

    private static String getUser() {
        return getEnv("DB_USER", getEnv("MYSQLUSER", "root"));
    }

    private static String getPassword() {
        String pw = System.getenv("DB_PASSWORD");
        if (pw == null) {
            pw = System.getenv("MYSQLPASSWORD");
        }
        return pw != null ? pw : "";
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException missingDriver) {
            throw new SQLException("MySQL Connector/J is missing from WEB-INF/lib", "08001", missingDriver);
        }

        String url = getJdbcUrl();
        String user = getUser();
        String password = getPassword();

        try {
            return DriverManager.getConnection(url, user, password);
        } catch (SQLException connectionFailure) {
            String state = connectionFailure.getSQLState();
            if (state != null && !state.startsWith("08")) {
                throw connectionFailure;
            }
            throw new SQLException(
                    "Cannot connect to MySQL database at: " + url + " as user: " + user
                    + ". Check that the database server is running and reachable.",
                    "08001", connectionFailure);
        }
    }
}
