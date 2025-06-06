package listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import service.email.AsyncEmailService;
import java.util.logging.Logger;

/**
 * Application lifecycle listener that manages resources during
 * application startup and shutdown
 */
@WebListener
public class ApplicationLifecycleListener implements ServletContextListener {

  private static final Logger LOGGER = Logger.getLogger(ApplicationLifecycleListener.class.getName());

  @Override
  public void contextInitialized(ServletContextEvent sce) {
    LOGGER.info("SPA Management Application started");
    // Any initialization code can go here
  }

  @Override
  public void contextDestroyed(ServletContextEvent sce) {
    LOGGER.info("SPA Management Application shutting down...");

    // Shutdown the async email service thread pool
    try {
      AsyncEmailService.shutdown();
      LOGGER.info("Async email service shutdown completed");
    } catch (Exception e) {
      LOGGER.severe("Error shutting down async email service: " + e.getMessage());
    }

    LOGGER.info("SPA Management Application shutdown completed");
  }
}