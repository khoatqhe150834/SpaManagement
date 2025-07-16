package listener;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

import db.DataSource;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import service.email.AsyncEmailService;

/**
 * Application lifecycle listener that manages resources during
 * application startup and shutdown
 */
@WebListener
public class ApplicationLifecycleListener implements ServletContextListener {

  private static final Logger LOGGER = Logger.getLogger(ApplicationLifecycleListener.class.getName());
  private ScheduledExecutorService scheduler;

  @Override
  public void contextInitialized(ServletContextEvent sce) {
    LOGGER.info("SPA Management Application started");
    // Any initialization code can go here
    System.out.println("Application Starting Up...");
    DataSource.initialize();

    // Start connection pool monitoring
    scheduler = Executors.newScheduledThreadPool(1);
    scheduler.scheduleAtFixedRate(() -> {
      try {
        DataSource.logPoolStatistics();
      } catch (Exception e) {
        LOGGER.log(Level.WARNING, "Error logging pool statistics", e);
      }
    }, 0, 5, TimeUnit.MINUTES);

    LOGGER.info("Connection pool initialized and monitoring started");
  }

  @Override
  public void contextDestroyed(ServletContextEvent sce) {
    LOGGER.info("SPA Management Application shutting down...");

    // Shutdown the connection pool monitoring
    if (scheduler != null) {
      scheduler.shutdown();
      try {
        if (!scheduler.awaitTermination(60, TimeUnit.SECONDS)) {
          scheduler.shutdownNow();
        }
        LOGGER.info("Connection pool monitoring shutdown completed");
      } catch (InterruptedException e) {
        scheduler.shutdownNow();
        Thread.currentThread().interrupt();
        LOGGER.warning("Connection pool monitoring shutdown interrupted");
      }
    }

    // Shutdown the async email service thread pool
    try {
      AsyncEmailService.shutdown();
      LOGGER.info("Async email service shutdown completed");
    } catch (Exception e) {
      LOGGER.severe("Error shutting down async email service: " + e.getMessage());
    }

    System.out.println("Application Shutting Down...");
    DataSource.close();
    LOGGER.info("Connection pool shutdown completed");

    LOGGER.info("SPA Management Application shutdown completed");
  }
}