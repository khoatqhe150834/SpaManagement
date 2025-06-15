package util;

import java.net.URI;
import java.net.URISyntaxException;

public class DatabaseConfig {

  public static String getJdbcUrl() {
    String databaseUrl = System.getenv("JAWSDB_URL");

    if (databaseUrl != null) {
      // Heroku JawsDB MySQL - Add performance optimizations
      String optimizedUrl = databaseUrl +
          "?useConnectionPooling=true" +
          "&autoReconnect=true" +
          "&useSSL=false" +
          "&serverTimezone=UTC" +
          "&cachePrepStmts=true" +
          "&useServerPrepStmts=true" +
          "&prepStmtCacheSize=250" +
          "&prepStmtCacheSqlLimit=2048" +
          "&useLocalSessionState=true" +
          "&rewriteBatchedStatements=true";
      return optimizedUrl;
    } else {
      // Local MySQL
      return "jdbc:mysql://localhost:3306/spamanagement?useSSL=false&serverTimezone=UTC";
    }
  }

  public static String getUsername() {
    String databaseUrl = System.getenv("JAWSDB_URL");

    if (databaseUrl != null) {
      // Extract username from JawsDB URL
      try {
        URI uri = new URI(databaseUrl);
        String userInfo = uri.getUserInfo();
        return userInfo.split(":")[0];
      } catch (URISyntaxException e) {
        throw new RuntimeException("Invalid JAWSDB_URL", e);
      }
    } else {
      // Local MySQL
      return "root";
    }
  }

  public static String getPassword() {
    String databaseUrl = System.getenv("JAWSDB_URL");

    if (databaseUrl != null) {
      // Extract password from JawsDB URL
      try {
        URI uri = new URI(databaseUrl);
        String userInfo = uri.getUserInfo();
        return userInfo.split(":")[1];
      } catch (URISyntaxException e) {
        throw new RuntimeException("Invalid JAWSDB_URL", e);
      }
    } else {
      // Local MySQL (match your DBContext.java)
      return "root";
    }
  }

  public static String getDriverClassName() {
    String databaseUrl = System.getenv("JAWSDB_URL");

    if (databaseUrl != null) {
      return "com.mysql.cj.jdbc.Driver";
    } else {
      return "com.mysql.cj.jdbc.Driver";
    }
  }

}