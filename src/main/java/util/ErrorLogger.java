package util;

import jakarta.servlet.http.HttpServletRequest;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ErrorLogger {
  private static final Logger LOGGER = Logger.getLogger(ErrorLogger.class.getName());

  /**
   * Log an error with full context information
   * 
   * @param request The HTTP request that triggered the error
   * @param error   The exception that occurred
   * @param context Additional context information (e.g., "Processing customer
   *                list")
   */
  public static void logError(HttpServletRequest request, Throwable error, String context) {
    StringBuilder logMessage = new StringBuilder();
    logMessage.append("\n=== Error Details ===\n");
    logMessage.append("Context: ").append(context).append("\n");
    logMessage.append("URI: ").append(request.getRequestURI()).append("\n");
    logMessage.append("Method: ").append(request.getMethod()).append("\n");
    logMessage.append("User Agent: ").append(request.getHeader("User-Agent")).append("\n");
    logMessage.append("Remote Address: ").append(request.getRemoteAddr()).append("\n");

    // Add session info if available
    if (request.getSession(false) != null) {
      Object user = request.getSession().getAttribute("user");
      Object customer = request.getSession().getAttribute("customer");
      logMessage.append("Session ID: ").append(request.getSession().getId()).append("\n");
      logMessage.append("User Type: ").append(user != null ? "Staff" : (customer != null ? "Customer" : "Anonymous"))
          .append("\n");
    }

    LOGGER.log(Level.SEVERE, logMessage.toString(), error);
  }

  /**
   * Log an error without HTTP request context
   * 
   * @param error   The exception that occurred
   * @param context Additional context information
   */
  public static void logError(Throwable error, String context) {
    LOGGER.log(Level.SEVERE, "Context: " + context, error);
  }
}