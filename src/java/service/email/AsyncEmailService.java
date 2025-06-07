package service.email;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Asynchronous email service that handles email sending in background threads
 * to avoid blocking the main request thread and improve user experience
 */
public class AsyncEmailService {

  private static final Logger LOGGER = Logger.getLogger(AsyncEmailService.class.getName());

  // Thread pool for handling email sending
  private static final ExecutorService emailExecutor = Executors.newFixedThreadPool(5);

  // Timeout for email operations (in seconds)
  private static final int EMAIL_TIMEOUT_SECONDS = 30;

  private final EmailService emailService;

  public AsyncEmailService() {
    this.emailService = new EmailService();
  }

  /**
   * Send password reset email asynchronously
   * 
   * @param email       The recipient email address
   * @param token       The reset token
   * @param contextPath The application context path (can be null)
   * @return Future<Boolean> representing the email sending result
   */
  public Future<Boolean> sendPasswordResetEmailAsync(String email, String token, String contextPath) {
    return emailExecutor.submit(() -> {
      try {
        LOGGER.info("Starting async password reset email for: " + email);

        boolean result = emailService.sendPasswordResetEmail(email, token, contextPath);

        if (result) {
          LOGGER.info("Successfully sent password reset email to: " + email);
        } else {
          LOGGER.warning("Failed to send password reset email to: " + email);
        }

        return result;

      } catch (Exception e) {
        LOGGER.log(Level.SEVERE, "Error sending password reset email to: " + email, e);
        return false;
      }
    });
  }

  /**
   * Send password reset email and immediately return success message
   * The actual email sending happens in background
   * 
   * @param email       The recipient email address
   * @param token       The reset token
   * @param contextPath The application context path (can be null)
   */
  public void sendPasswordResetEmailFireAndForget(String email, String token, String contextPath) {
    emailExecutor.submit(() -> {
      try {
        LOGGER.info("Starting fire-and-forget password reset email for: " + email);

        boolean result = emailService.sendPasswordResetEmail(email, token, contextPath);

        if (result) {
          LOGGER.info("Successfully sent password reset email to: " + email);
        } else {
          LOGGER.warning("Failed to send password reset email to: " + email);
          // In a production environment, you might want to:
          // 1. Store failed emails in a retry queue
          // 2. Send notifications to administrators
          // 3. Log to monitoring systems
        }

      } catch (Exception e) {
        LOGGER.log(Level.SEVERE, "Error in fire-and-forget email sending to: " + email, e);
        // Handle error - could retry, store in database for manual retry, etc.
      }
    });
  }

  /**
   * Send email with callback for handling success/failure
   * 
   * @param email       The recipient email address
   * @param token       The reset token
   * @param contextPath The application context path
   * @param onSuccess   Callback for successful email sending
   * @param onFailure   Callback for failed email sending
   */
  public void sendPasswordResetEmailWithCallback(String email, String token, String contextPath,
      Runnable onSuccess, Runnable onFailure) {
    emailExecutor.submit(() -> {
      try {
        LOGGER.info("Starting callback-based password reset email for: " + email);

        boolean result = emailService.sendPasswordResetEmail(email, token, contextPath);

        if (result) {
          LOGGER.info("Successfully sent password reset email to: " + email);
          if (onSuccess != null) {
            onSuccess.run();
          }
        } else {
          LOGGER.warning("Failed to send password reset email to: " + email);
          if (onFailure != null) {
            onFailure.run();
          }
        }

      } catch (Exception e) {
        LOGGER.log(Level.SEVERE, "Error in callback-based email sending to: " + email, e);
        if (onFailure != null) {
          onFailure.run();
        }
      }
    });
  }

  /**
   * Check if an email sending task is still running
   * 
   * @param future The Future returned by sendPasswordResetEmailAsync
   * @return true if the task is still running
   */
  public boolean isEmailSending(Future<Boolean> future) {
    return future != null && !future.isDone();
  }

  /**
   * Wait for email sending to complete with timeout
   * 
   * @param future The Future returned by sendPasswordResetEmailAsync
   * @return true if email was sent successfully, false if failed or timeout
   */
  public boolean waitForEmailResult(Future<Boolean> future) {
    try {
      return future.get(EMAIL_TIMEOUT_SECONDS, TimeUnit.SECONDS);
    } catch (Exception e) {
      LOGGER.log(Level.WARNING, "Timeout or error waiting for email result", e);
      return false;
    }
  }

  /**
   * Shutdown the email executor service
   * Should be called when the application is shutting down
   */
  public static void shutdown() {
    emailExecutor.shutdown();
    try {
      if (!emailExecutor.awaitTermination(60, TimeUnit.SECONDS)) {
        emailExecutor.shutdownNow();
        if (!emailExecutor.awaitTermination(60, TimeUnit.SECONDS)) {
          LOGGER.severe("Email executor did not terminate gracefully");
        }
      }
    } catch (InterruptedException ie) {
      emailExecutor.shutdownNow();
      Thread.currentThread().interrupt();
    }
  }

  /**
   * Get statistics about the email queue
   * 
   * @return String with current email queue status
   */
  public String getEmailQueueStatus() {
    if (emailExecutor instanceof java.util.concurrent.ThreadPoolExecutor) {
      java.util.concurrent.ThreadPoolExecutor tpe = (java.util.concurrent.ThreadPoolExecutor) emailExecutor;
      return String.format("Email Queue - Active: %d, Queued: %d, Completed: %d",
          tpe.getActiveCount(), tpe.getQueue().size(), tpe.getCompletedTaskCount());
    }
    return "Email service is running";
  }

  /**
   * Send verification email asynchronously
   * 
   * @param email    The recipient email address
   * @param token    The verification token
   * @param userName The user's name (can be null)
   * @return Future<Boolean> representing the email sending result
   */
  public Future<Boolean> sendVerificationEmailAsync(String email, String token, String userName) {
    return emailExecutor.submit(() -> {
      try {
        LOGGER.info("Starting async verification email for: " + email);

        boolean result = emailService.sendVerificationEmail(email, token, userName);

        if (result) {
          LOGGER.info("Successfully sent verification email to: " + email);
        } else {
          LOGGER.warning("Failed to send verification email to: " + email);
        }

        return result;

      } catch (Exception e) {
        LOGGER.log(Level.SEVERE, "Error sending verification email to: " + email, e);
        return false;
      }
    });
  }
}