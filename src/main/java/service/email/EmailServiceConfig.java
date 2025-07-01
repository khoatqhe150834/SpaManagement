package service.email;

/**
 * Email service configuration
 * Switch between development and production email settings
 */
public class EmailServiceConfig {

  // Set to true for development (uses Mailtrap), false for production (uses
  // Gmail)
  private static final boolean IS_DEVELOPMENT = false;

  // Production Gmail settings
  public static final String PROD_SMTP_HOST = "smtp.gmail.com";
  public static final String PROD_SMTP_PORT = "587";
  public static final String PROD_EMAIL_USERNAME = "quangkhoa5112@gmail.com";
  public static final String PROD_EMAIL_PASSWORD = "yxjn zgbu grpu hnxv";

  // Development Mailtrap settings (configured)
  public static final String DEV_SMTP_HOST = "sandbox.smtp.mailtrap.io";
  public static final String DEV_SMTP_PORT = "2525";
  public static final String DEV_EMAIL_USERNAME = "bfd168076b23fc";
  public static final String DEV_EMAIL_PASSWORD = "53152a674304e2";

  // Common settings
  public static final String FROM_NAME = "Spa Online";
  public static final String APP_BASE_URL = "http://localhost:8080/spa";

  // Get current configuration based on environment
  public static String getSmtpHost() {
    return IS_DEVELOPMENT ? DEV_SMTP_HOST : PROD_SMTP_HOST;
  }

  public static String getSmtpPort() {
    return IS_DEVELOPMENT ? DEV_SMTP_PORT : PROD_SMTP_PORT;
  }

  public static String getEmailUsername() {
    return IS_DEVELOPMENT ? DEV_EMAIL_USERNAME : PROD_EMAIL_USERNAME;
  }

  public static String getEmailPassword() {
    return IS_DEVELOPMENT ? DEV_EMAIL_PASSWORD : PROD_EMAIL_PASSWORD;
  }

  public static boolean isDevelopment() {
    return IS_DEVELOPMENT;
  }
}