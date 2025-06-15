package db;

import util.DatabaseConfig;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Alternative DBContext for Heroku deployment that uses environment variables
 * Use this class in production (Heroku) and keep DBContext.java for local
 * development
 */
public class DBContextHeroku {
  private static Connection connection = null;

  // Private constructor to prevent instantiation
  private DBContextHeroku() {
  }

  /**
   * Get database connection (supports both local MySQL and Heroku JawsDB)
   * 
   * @return Connection object
   * @throws SQLException if connection fails
   */
  public static Connection getConnection() throws SQLException {
    if (connection == null || connection.isClosed()) {
      try {
        // Register JDBC driver
        Class.forName(DatabaseConfig.getDriverClassName());

        // Open a connection using DatabaseConfig
        connection = DriverManager.getConnection(
            DatabaseConfig.getJdbcUrl(),
            DatabaseConfig.getUsername(),
            DatabaseConfig.getPassword());
        System.out.println("Database connected successfully");
      } catch (ClassNotFoundException e) {
        throw new SQLException("MySQL JDBC Driver not found.", e);
      }
    }
    return connection;
  }

  /**
   * Close database connection
   */
  public static void closeConnection() {
    if (connection != null) {
      try {
        connection.close();
        System.out.println("Database connection closed");
      } catch (SQLException e) {
        System.out.println("Error closing database connection: " + e.getMessage());
      }
    }
  }

  /**
   * Test database connection
   */
  public static void testConnection() {
    try {
      Connection conn = getConnection();
      if (conn != null && !conn.isClosed()) {
        System.out.println("Database connection test successful!");
        System.out.println("Using database URL: " + DatabaseConfig.getJdbcUrl());
      }
    } catch (SQLException e) {
      System.out.println("Database connection test failed: " + e.getMessage());
    }
  }

  public static void main(String[] args) {
    DBContextHeroku.testConnection();
  }
}