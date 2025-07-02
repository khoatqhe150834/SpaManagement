package db;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {
    private static final Logger LOGGER = Logger.getLogger(DBContext.class.getName());

    public static Connection getConnection() throws SQLException {
        // All connection requests are now routed through the HikariCP pool
        return DataSource.getConnection();
    }

    /**
     * Tests the database connection by attempting to get a connection from the pool
     * and executing a simple query.
     * 
     * @return true if connection is successful, false otherwise
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            // If we can get a connection and it's valid, return true
            if (conn != null && conn.isValid(5)) { // 5 second timeout
                LOGGER.info("Database connection test successful");
                return true;
            }
            LOGGER.warning("Database connection test failed - connection is invalid");
            return false;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database connection test failed", e);
            return false;
        }
    }
}