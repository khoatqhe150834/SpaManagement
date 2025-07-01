/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.email;

import dao.AccountDAO;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service class for sending emails, particularly for password reset
 * functionality
 * 
 * @author quang
 */
public class EmailService {

  private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());

  // Email configuration - now uses EmailServiceConfig for environment switching
  private static final String SMTP_HOST = EmailServiceConfig.getSmtpHost();
  private static final String SMTP_PORT = EmailServiceConfig.getSmtpPort();
  private static final String EMAIL_USERNAME = EmailServiceConfig.getEmailUsername();
  private static final String EMAIL_PASSWORD = EmailServiceConfig.getEmailPassword();
  private static final String FROM_NAME = EmailServiceConfig.FROM_NAME;

  // Application URL for links
  private static final String APP_BASE_URL = EmailServiceConfig.APP_BASE_URL;

  /**
   * Sends a password reset email to the specified user
   * 
   * @param userEmail   The email address of the user
   * @param resetToken  The password reset token
   * @param contextPath The application context path to build the reset link
   * @return true if email was sent successfully, false otherwise
   */
  public boolean sendPasswordResetEmail(String userEmail, String resetToken, String contextPath) {
    String resetUrl = APP_BASE_URL + contextPath + "/verify-reset-token?token=" + resetToken;
    String subject = "Password Reset Request";

    try {
      // Get user's full name from database
      AccountDAO accountDAO = new AccountDAO();
      String userName = accountDAO.getFullNameByEmail(userEmail);

      Map<String, String> placeholders = Map.of(
          "userName", userName != null ? userName : "User",
          "resetLink", resetUrl);

      String emailContent = EmailTemplateUtil.loadAndPopulateTemplate("password-reset-email.html", placeholders);

      if (emailContent == null) {
        LOGGER.log(Level.SEVERE, "Could not load password reset email template.");
        return false;
      }

      return sendEmail(userEmail, subject, emailContent);
    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Error during password reset email preparation for " + userEmail, e);
      return false;
    }
  }

  /**
   * Creates an email session with SMTP configuration
   * 
   * @return Configured email session
   */
  private Session createEmailSession() {
    Properties props = new Properties();

    // Basic SMTP settings
    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.host", SMTP_HOST);
    props.put("mail.smtp.port", SMTP_PORT);
    props.put("mail.debug", "false"); // Disable debug mode for production
    props.put("mail.smtp.connectiontimeout", "10000"); // 10 seconds
    props.put("mail.smtp.timeout", "10000"); // 10 seconds
    props.put("mail.smtp.writetimeout", "10000"); // 10 seconds

    // Configure SSL/TLS based on environment
    if (EmailServiceConfig.isDevelopment()) {
      // Mailtrap typically doesn't require STARTTLS
      LOGGER.info("SMTP Properties configured for DEVELOPMENT (Mailtrap)");
    } else {
      // Production Gmail requires STARTTLS
      props.put("mail.smtp.starttls.enable", "true");
      props.put("mail.smtp.ssl.protocols", "TLSv1.2");
      props.put("mail.smtp.ssl.trust", SMTP_HOST);
      LOGGER.info("SMTP Properties configured for PRODUCTION (Gmail)");
    }

    return Session.getInstance(props, new Authenticator() {
      @Override
      protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
      }
    });
  }

  /**
   * Sends a confirmation email after successful password reset
   * 
   * @param userEmail The email address of the user
   * @param userName  The name of the user (optional, can be null)
   * @return true if email was sent successfully, false otherwise
   */
  public boolean sendPasswordResetConfirmationEmail(String userEmail, String userName) {
    try {
      Session session = createEmailSession();

      Message message = new MimeMessage(session);
      message.setFrom(new InternetAddress(EMAIL_USERNAME, FROM_NAME));
      message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail));
      message.setSubject("Password Reset Successful - Spa Management System");

      String emailContent = createPasswordResetConfirmationContent(userName);
      message.setContent(emailContent, "text/html; charset=utf-8");

      Transport.send(message);

      LOGGER.info("Password reset confirmation email sent successfully to: " + userEmail);
      return true;

    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Failed to send password reset confirmation email to: " + userEmail, e);
      return false;
    }
  }

  /**
   * Creates the HTML content for password reset confirmation email
   * 
   * @param userName The user's name (can be null)
   * @return HTML email content
   */
  private String createPasswordResetConfirmationContent(String userName) {
    String greeting = userName != null ? "Xin chào " + userName + "," : "Xin chào,";

    return "<!DOCTYPE html>" +
        "<html>" +
        "<head>" +
        "    <style>" +
        "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
        "        .container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
        "        .header { background-color: #4CAF50; color: white; padding: 20px; text-align: center; }" +
        "        .content { padding: 20px; background-color: #f9f9f9; }" +
        "        .footer { padding: 20px; text-align: center; font-size: 12px; color: #333; }" +
        "        .success { background-color: #d4edda; border: 1px solid #c3e6cb; padding: 10px; margin: 15px 0; border-radius: 4px; color: #155724; }"
        +
        "        .success strong { color: #0f5132; }" +
        "    </style>" +
        "</head>" +
        "<body>" +
        "    <div class=\"container\">" +
        "        <div class=\"header\">" +
        "            <h1>Đặt Lại Mật Khẩu Thành Công</h1>" +
        "        </div>" +
        "        <div class=\"content\">" +
        "            <p>" + greeting + "</p>" +
        "            <div class=\"success\">" +
        "                <strong>✓ Mật khẩu của bạn đã được đặt lại thành công!</strong>" +
        "            </div>" +
        "            <p>Mật khẩu của bạn trong Hệ Thống Quản Lý Spa đã được thay đổi thành công.</p>" +
        "            <p>Bạn có thể đăng nhập vào tài khoản của mình bằng mật khẩu mới.</p>" +
        "            <p>Nếu bạn không thực hiện thay đổi này, vui lòng liên hệ với đội ngũ hỗ trợ của chúng tôi ngay lập tức.</p>"
        +
        "        </div>" +
        "        <div class=\"footer\">" +
        "            <p>Email này được gửi từ Hệ Thống Quản Lý Spa.</p>" +
        "            <p>Nếu bạn có bất kỳ câu hỏi nào, vui lòng liên hệ với đội ngũ hỗ trợ của chúng tôi.</p>" +
        "        </div>" +
        "    </div>" +
        "</body>" +
        "</html>";
  }

  /**
   * Sends an email verification email to the specified user
   * 
   * @param userEmail         The email address of the user
   * @param verificationToken The verification token
   * @param userName          The name of the user (optional, can be null)
   * @return true if email was sent successfully, false otherwise
   */
  public boolean sendVerificationEmail(String userEmail, String verificationToken, String userName) {
    String verificationUrl = APP_BASE_URL + "/verify-email?token=" + verificationToken;
    String subject = "Xác thực tài khoản - Spa Hương Sen";

    Map<String, String> placeholders = Map.of(
        "userName", userName != null ? userName : "bạn",
        "verificationLink", verificationUrl);

    String emailContent = EmailTemplateUtil.loadAndPopulateTemplate("verification-email.html", placeholders);

    if (emailContent == null) {
      LOGGER.log(Level.SEVERE, "Could not load verification email template.");
      return false;
    }

    return sendEmail(userEmail, subject, emailContent);
  }

  private boolean sendEmail(String to, String subject, String htmlContent) {
    try {
      Session session = createEmailSession();
      Message message = new MimeMessage(session);
      message.setFrom(new InternetAddress(EMAIL_USERNAME, FROM_NAME));
      message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
      message.setSubject(subject);
      message.setContent(htmlContent, "text/html; charset=utf-8");

      LOGGER.info("Attempting to send email with subject '" + subject + "' to: " + to);
      Transport.send(message);
      LOGGER.info("Email sent successfully to: " + to);
      return true;

    } catch (AuthenticationFailedException e) {
      LOGGER.log(Level.SEVERE, "Gmail authentication failed. Check email credentials and app password.", e);
      return false;
    } catch (MessagingException e) {
      LOGGER.log(Level.SEVERE, "Email messaging error for: " + to, e);
      return false;
    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Failed to send email to: " + to, e);
      return false;
    }
  }

  /**
   * Test method to verify email configuration.
   * Sends both a password reset and a verification email.
   * Note: Make sure to configure EMAIL_USERNAME and EMAIL_PASSWORD before
   * testing.
   */
  public static void testEmailConfiguration() {
    EmailService emailService = new EmailService();

    System.out.println("=== Starting Email Service Test Suite ===");
    System.out.println(
        "Environment: " + (EmailServiceConfig.isDevelopment() ? "DEVELOPMENT (Mailtrap)" : "PRODUCTION (Gmail)"));
    System.out.println("SMTP Host: " + EmailServiceConfig.getSmtpHost());
    System.out.println("SMTP Port: " + EmailServiceConfig.getSmtpPort());
    System.out.println("Sending From: " + EmailServiceConfig.getEmailUsername());
    System.out.println("=========================================");

    // --- Test Parameters ---
    String testEmail = "quangkhoa5112@gmail.com"; // The email address that will RECEIVE the tests.
    String testResetToken = "test-reset-token-123456";
    String testVerificationToken = "test-verification-token-789012";
    String testUserName = "Test User Quang";
    String testContextPath = "/G1_SpaManagement"; // Mimics the application's context path.

    // --- Test 1: Password Reset Email ---
    System.out.println("\n--- Test 1: Sending Password Reset Email ---");
    System.out.println("To: " + testEmail);
    boolean resetSuccess = emailService.sendPasswordResetEmail(testEmail, testResetToken, testContextPath);
    if (resetSuccess) {
      System.out.println("✓ SUCCESS: Password reset email method completed without errors.");
      System.out.println("ACTION: Please check the inbox for \"" + testEmail
          + "\" for an email with the subject 'Password Reset Request'.");
    } else {
      System.out.println(
          "✗ FAILURE: Password reset email method returned false. Check logs above for detailed errors (e.g., authentication, connection).");
    }
    System.out.println("------------------------------------------");

    // --- Test 2: Account Verification Email ---
    System.out.println("\n--- Test 2: Sending Account Verification Email ---");
    System.out.println("To: " + testEmail);
    boolean verificationSuccess = emailService.sendVerificationEmail(testEmail, testVerificationToken, testUserName);
    if (verificationSuccess) {
      System.out.println("✓ SUCCESS: Account verification email method completed without errors.");
      System.out.println("ACTION: Please check the inbox for \"" + testEmail
          + "\" for an email with the subject 'Xác thực tài khoản - Spa Hương Sen'.");
    } else {
      System.out.println(
          "✗ FAILURE: Account verification email method returned false. Check logs above for detailed errors.");
    }
    System.out.println("----------------------------------------------");

    System.out.println("\n=== Email Service Test Suite Finished ===\n");
  }

  public static void main(String[] args) {
    // To run this test:
    // 1. Right-click this file in your IDE (NetBeans/IntelliJ/VSCode)
    // 2. Select "Run File" or a similar option.
    // 3. Check the console output for success or failure messages.
    // 4. Check the inbox of the `testEmail` address below.
    testEmailConfiguration();
  }
}
