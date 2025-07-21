package db;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Logger;

public class DataSource {

  private static final Logger LOGGER = Logger.getLogger(DataSource.class.getName());
  private static HikariDataSource dataSource;

  public static void initialize() {
    if (dataSource == null) {
      LOGGER.info("Initializing Connection Pool...");
      HikariConfig config = new HikariConfig();

      // --- Database Configuration ---
      config.setJdbcUrl(
          "jdbc:mysql://localhost:3306/spamanagement?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
      config.setUsername("root");
     config.setPassword("root");
      // config.setPassword("12345");

      // --- Pool Settings ---
      config.setDriverClassName("com.mysql.cj.jdbc.Driver");
      config.setMaximumPoolSize(10); // Max number of connections
      config.setMinimumIdle(5); // Min number of idle connections
      config.setConnectionTimeout(30000); // Max wait time for a connection (30s)
      config.setIdleTimeout(600000); // Max idle time for a connection (10min)
      config.setMaxLifetime(1800000); // Max lifetime of a connection (30min)

      // --- Optimization Settings ---
      config.addDataSourceProperty("cachePrepStmts", "true");
      config.addDataSourceProperty("prepStmtCacheSize", "250");
      config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

      dataSource = new HikariDataSource(config);
      LOGGER.info("Connection Pool Initialized Successfully.");
    }
  }

  public static synchronized Connection getConnection() throws SQLException {
    if (dataSource == null) {
      initialize();
    }
    return dataSource.getConnection();
  }

  public static void close() {
    if (dataSource != null) {
      LOGGER.info("Closing Connection Pool...");
      dataSource.close();
      LOGGER.info("Connection Pool Closed.");
    }
  }

  /**
   * Logs current statistics about the connection pool
   */
  public static void logPoolStatistics() {
    if (dataSource != null) {
      LOGGER.info(String.format("""
          Connection Pool Statistics:
          - Active Connections: %d
          - Idle Connections: %d
          - Total Connections: %d
          - Waiting Threads: %d
          """,
          dataSource.getHikariPoolMXBean().getActiveConnections(),
          dataSource.getHikariPoolMXBean().getIdleConnections(),
          dataSource.getHikariPoolMXBean().getTotalConnections(),
          dataSource.getHikariPoolMXBean().getThreadsAwaitingConnection()));
    }
  }
}