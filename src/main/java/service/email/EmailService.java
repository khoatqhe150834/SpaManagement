/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.email;

import jakarta.mail.*;
import jakarta.mail.internet.*;
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
   * @param userEmail  The email address of the user
   * @param resetToken The password reset token
   * @param userName   The name of the user (optional, can be null)
   * @return true if email was sent successfully, false otherwise
   */
  public boolean sendPasswordResetEmail(String userEmail, String resetToken, String userName) {
    try {
      LOGGER.info("Attempting to send password reset email to: " + userEmail);
      LOGGER.info("Using SMTP server: " + SMTP_HOST + ":" + SMTP_PORT);
      LOGGER.info("From email: " + EMAIL_USERNAME);

      // Create email session
      Session session = createEmailSession();
      LOGGER.info("Email session created successfully");

      // Create the email message
      Message message = new MimeMessage(session);
      message.setFrom(new InternetAddress(EMAIL_USERNAME, FROM_NAME)); // Use actual email as from
      message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail));
      message.setSubject("Password Reset Request - Spa Management System");

      // Create the email content
      String emailContent = createPasswordResetEmailContent(resetToken, userName);
      message.setContent(emailContent, "text/html; charset=utf-8");

      LOGGER.info("Email message prepared, attempting to send...");

      // Send the email
      Transport.send(message);

      LOGGER.info("Password reset email sent successfully to: " + userEmail);
      return true;

    } catch (AuthenticationFailedException e) {
      LOGGER.log(Level.SEVERE,
          "Gmail authentication failed. Check email credentials and app password: " + e.getMessage(), e);
      return false;
    } catch (MessagingException e) {
      LOGGER.log(Level.SEVERE, "Email messaging error for: " + userEmail + ". Error: " + e.getMessage(), e);
      return false;
    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Failed to send password reset email to: " + userEmail, e);
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
    props.put("mail.debug", "true"); // Enable debug mode for troubleshooting
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
        LOGGER.info("Authenticating with Gmail SMTP");
        return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
      }
    });
  }

  /**
   * Creates the HTML content for the password reset email
   * 
   * @param resetToken The password reset token
   * @param userName   The user's name (can be null)
   * @return HTML email content
   */
  private String createPasswordResetEmailContent(String resetToken, String userName) {
    String resetUrl = APP_BASE_URL + "/verify-reset-token?token=" + resetToken;
    String greeting = userName != null ? "Xin chào " + userName + "," : "Xin chào,";

    return "<!DOCTYPE html>" +
        "<html>" +
        "<head>" +
        "    <style>" +
        "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
        "        .container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
        "        .header { background-color: #4CAF50; color: white; padding: 20px; text-align: center; }" +
        "        .content { padding: 20px; background-color: #f9f9f9; }" +
        "        .button { display: inline-block; padding: 12px 24px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 4px; margin: 20px 0; }"
        +
        "        .footer { padding: 20px; text-align: center; font-size: 12px; color: #333; }" +
        "        .warning { background-color: #fff3cd; border: 1px solid #ffeaa7; padding: 10px; margin: 15px 0; border-radius: 4px; color: #333; }"
        +
        "        .warning strong { color: #b8860b; }" +
        "        .url-box { word-break: break-all; background-color: #f0f0f0; padding: 10px; border-radius: 4px; color: #333; }"
        +
        "    </style>" +
        "</head>" +
        "<body>" +
        "    <div class=\"container\">" +
        "        <div class=\"header\">" +
        "            <h1>Yêu Cầu Đặt Lại Mật Khẩu</h1>" +
        "        </div>" +
        "        <div class=\"content\">" +
        "            <p>" + greeting + "</p>" +
        "            <p>Chúng tôi đã nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.</p>"
        +
        "            <p>Vui lòng nhấp vào nút bên dưới để đặt lại mật khẩu:</p>" +
        "            <div style=\"text-align: center;\">" +
        "                <a href=\"" + resetUrl + "\" class=\"button\">Đặt Lại Mật Khẩu</a>" +
        "            </div>" +
        "            <p>Hoặc sao chép và dán liên kết này vào trình duyệt của bạn:</p>" +
        "            <p class=\"url-box\">" +
        "                <a href=\"" + resetUrl + "\" style=\"color: #333; text-decoration: underline;\">" + resetUrl
        + "</a>" +
        "            </p>" +
        "            <div class=\"warning\">" +
        "                <strong>Quan trọng:</strong>" +
        "                <ul>" +
        "                    <li>Liên kết này sẽ hết hạn sau 1 giờ vì lý do bảo mật</li>" +
        "                    <li>Nếu bạn không yêu cầu đặt lại mật khẩu này, vui lòng bỏ qua email này</li>" +
        "                    <li>Mật khẩu của bạn sẽ không thay đổi trừ khi bạn nhấp vào liên kết trên</li>" +
        "                </ul>" +
        "            </div>" +
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
    try {
      LOGGER.info("Attempting to send verification email to: " + userEmail);
      LOGGER.info("Using SMTP server: " + SMTP_HOST + ":" + SMTP_PORT);
      LOGGER.info("From email: " + EMAIL_USERNAME);

      // Create email session
      Session session = createEmailSession();
      LOGGER.info("Email session created successfully");

      // Create the email message
      Message message = new MimeMessage(session);
      message.setFrom(new InternetAddress(EMAIL_USERNAME, FROM_NAME)); // Use actual email as from
      message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail));
      message.setSubject("Email Verification - Spa Management System");

      // Create the email content
      String emailContent = createVerificationEmailContent(verificationToken, userName);
      message.setContent(emailContent, "text/html; charset=utf-8");

      LOGGER.info("Email message prepared, attempting to send...");

      // Send the email
      Transport.send(message);

      LOGGER.info("Verification email sent successfully to: " + userEmail);
      return true;

    } catch (AuthenticationFailedException e) {
      LOGGER.log(Level.SEVERE,
          "Gmail authentication failed. Check email credentials and app password: " + e.getMessage(), e);
      return false;
    } catch (MessagingException e) {
      LOGGER.log(Level.SEVERE, "Email messaging error for: " + userEmail + ". Error: " + e.getMessage(), e);
      return false;
    } catch (Exception e) {
      LOGGER.log(Level.SEVERE, "Failed to send verification email to: " + userEmail, e);
      return false;
    }
  }

  /**
   * Creates the HTML content for the email verification email
   * 
   * @param verificationToken The verification token
   * @param userName          The user's name (can be null)
   * @return HTML email content
   */
  private String createVerificationEmailContent(String verificationToken, String userName) {
    String verifyUrl = APP_BASE_URL + "/verify-email?token=" + verificationToken;
    String greeting = userName != null ? "Xin chào " + userName + "," : "Xin chào,";

    return "<!DOCTYPE html>" +
        "<html>" +
        "<head>" +
        "    <style>" +
        "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
        "        .container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
        "        .header { background-color: #007bff; color: white; padding: 20px; text-align: center; }" +
        "        .content { padding: 20px; background-color: #f9f9f9; }" +
        "        .button { display: inline-block; padding: 12px 24px; background-color: #007bff; color: white; text-decoration: none; border-radius: 4px; margin: 20px 0; }"
        +
        "        .footer { padding: 20px; text-align: center; font-size: 12px; color: #333; }" +
        "        .warning { background-color: #fff3cd; border: 1px solid #ffeaa7; padding: 10px; margin: 15px 0; border-radius: 4px; color: #333; }"
        +
        "        .warning strong { color: #b8860b; }" +
        "        .url-box { word-break: break-all; background-color: #f0f0f0; padding: 10px; border-radius: 4px; color: #333; }"
        +
        "    </style>" +
        "</head>" +
        "<body>" +
        "    <div class=\"container\">" +
        "        <div class=\"header\">" +
        "            <h1>Xác Thực Email</h1>" +
        "        </div>" +
        "        <div class=\"content\">" +
        "            <p>" + greeting + "</p>" +
        "            <p>Cảm ơn bạn đã đăng ký tài khoản tại Spa Management System.</p>" +
        "            <p>Vui lòng nhấp vào nút bên dưới để xác thực email của bạn:</p>" +
        "            <div style=\"text-align: center;\">" +
        "                <a href=\"" + verifyUrl + "\" class=\"button\">Xác Thực Email</a>" +
        "            </div>" +
        "            <p>Hoặc sao chép và dán liên kết này vào trình duyệt của bạn:</p>" +
        "            <p class=\"url-box\">" +
        "                <a href=\"" + verifyUrl + "\" style=\"color: #333; text-decoration: underline;\">" + verifyUrl
        + "</a>" +
        "            </p>" +
        "            <div class=\"warning\">" +
        "                <strong>Lưu ý:</strong> Liên kết xác thực này sẽ hết hạn sau 24 giờ vì lý do bảo mật." +
        "            </div>" +
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
   * Test method to verify email configuration
   * Note: Make sure to configure EMAIL_USERNAME and EMAIL_PASSWORD before testing
   */
  public static void testEmailConfiguration() {
    EmailService emailService = new EmailService();

    System.out.println("=== Testing Email Configuration ===");

    // Test with a sample email (change this to your test email)
    String testEmail = "quangkhoa5112@gmail.com";
    String testToken = "sample-token-12345";
    String testUserName = "Test User";

    System.out.println("Attempting to send test password reset email...");
    boolean success = emailService.sendPasswordResetEmail(testEmail, testToken, testUserName);

    if (success) {
      System.out.println("✓ Test email sent successfully!");
      System.out.println("Check the email inbox for: " + testEmail);
    } else {
      System.out.println("✗ Failed to send test email.");
      System.out.println("Please check your email configuration:");
      System.out.println("- EMAIL_USERNAME: " + EMAIL_USERNAME);
      System.out.println("- SMTP_HOST: " + SMTP_HOST);
      System.out.println("- SMTP_PORT: " + SMTP_PORT);
    }
  }

  public static void main(String[] args) {

    testEmailConfiguration();
  }
}
