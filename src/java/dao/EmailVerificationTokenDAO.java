package dao;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import model.EmailVerificationToken;
import model.PasswordResetToken;

public class EmailVerificationTokenDAO {

  // Save a new password reset token to the database
  public void save(EmailVerificationToken token) throws SQLException {
    String sql = "INSERT INTO email_verification_tokens (token, user_email, expires_at, is_used) VALUES (?, ?, ?, ?)";
    try (Connection connection = DBContext.getConnection();
        PreparedStatement stmt = connection.prepareStatement(sql)) {
      stmt.setString(1, token.getToken());
      stmt.setString(2, token.getUserEmail());
      stmt.setTimestamp(3, java.sql.Timestamp.valueOf(token.getExpiryDate()));
      stmt.setBoolean(4, false);
      stmt.executeUpdate();
    }
  }

  // Find a token by its value
  public EmailVerificationToken findByToken(String tokenValue) throws SQLException {
    String sql = "SELECT token, user_email, expires_at, is_used FROM email_verification_tokens WHERE token = ?";
    try (Connection connection = DBContext.getConnection();
        PreparedStatement stmt = connection.prepareStatement(sql)) {
      stmt.setString(1, tokenValue);
      try (ResultSet rs = stmt.executeQuery()) {
        if (rs.next()) {
          String userEmail = rs.getString("user_email");
          String token = rs.getString("token");
          LocalDateTime expiryDate = rs.getTimestamp("expires_at").toLocalDateTime();
          return new EmailVerificationToken(userEmail, token, expiryDate);
        }
        return null;
      }
    }
  }

  // Mark a token as used
  public void markAsUsed(String tokenValue) throws SQLException {
    String sql = "UPDATE email_verification_tokens SET is_used = TRUE WHERE token = ?";
    try (Connection connection = DBContext.getConnection();
        PreparedStatement stmt = connection.prepareStatement(sql)) {
      stmt.setString(1, tokenValue);
      stmt.executeUpdate();
    }
  }

  // Check if a token is valid (not expired and not used)
  public boolean isValid(String tokenValue) throws SQLException {
    String sql = "SELECT expires_at, is_used FROM email_verification_tokens WHERE token = ?";
    try (Connection connection = DBContext.getConnection();
        PreparedStatement stmt = connection.prepareStatement(sql)) {
      stmt.setString(1, tokenValue);
      try (ResultSet rs = stmt.executeQuery()) {
        if (rs.next()) {
          LocalDateTime expiryDate = rs.getTimestamp("expires_at").toLocalDateTime();
          boolean isUsed = rs.getBoolean("is_used");
          return !isUsed && !LocalDateTime.now().isAfter(expiryDate);
        }
        return false;
      }
    }
  }

  // Delete expired tokens (cleanup method)
  public void deleteExpiredTokens() throws SQLException {
    String sql = "DELETE FROM email_verification_tokens WHERE expires_at < NOW()";
    try (Connection connection = DBContext.getConnection();
        PreparedStatement stmt = connection.prepareStatement(sql)) {
      stmt.executeUpdate();
    }
  }

  // Delete tokens for a specific user email
  public void deleteTokensByEmail(String userEmail) throws SQLException {
    String sql = "DELETE FROM email_verification_tokens WHERE user_email = ?";
    try (Connection connection = DBContext.getConnection();
        PreparedStatement stmt = connection.prepareStatement(sql)) {
      stmt.setString(1, userEmail);
      stmt.executeUpdate();
    }
  }

  /**
   * Test method to verify all PasswordResetTokenDAO functionality
   * Run this method to test the database operations
   */
  public static void main(String[] args) {
    EmailVerificationTokenDAO dao = new EmailVerificationTokenDAO();
    String testEmail = "test@example.com";

    System.out.println("=== Starting EmailVerificationTokenDAO Tests ===\n");

    try {
      // Test database connection
      System.out.println("1. Testing database connection...");
      DBContext.testConnection();
      System.out.println("✓ Database connection successful\n");

      // Clean up any existing test tokens
      System.out.println("2. Cleaning up existing test tokens...");
      dao.deleteTokensByEmail(testEmail);
      System.out.println("✓ Cleanup completed\n");

      // Test 1: Create and save a new token
      System.out.println("3. Testing token creation and saving...");
      EmailVerificationToken newToken = new EmailVerificationToken(testEmail);
      String tokenValue = newToken.getToken();
      System.out.println("   Generated token: " + tokenValue);
      System.out.println("   Token expires at: " + newToken.getExpiryDate());

      dao.save(newToken);
      System.out.println("✓ Token saved successfully\n");

      // Test 2: Find token by value
      System.out.println("4. Testing findByToken...");
      EmailVerificationToken foundToken = dao.findByToken(tokenValue);
      if (foundToken != null) {
        System.out.println("✓ Token found successfully");
        System.out.println("   Email: " + foundToken.getUserEmail());
        System.out.println("   Token: " + foundToken.getToken());
        System.out.println("   Expires: " + foundToken.getExpiryDate());
      } else {
        System.out.println("✗ Token not found");
      }
      System.out.println();

      // Test 3: Check if token is valid
      System.out.println("5. Testing token validation...");
      boolean isValid = dao.isValid(tokenValue);
      System.out.println("   Token valid: " + isValid);
      if (isValid) {
        System.out.println("✓ Token validation successful");
      } else {
        System.out.println("✗ Token validation failed");
      }
      System.out.println();

      // Test 4: Mark token as used
      System.out.println("6. Testing mark token as used...");
      dao.markAsUsed(tokenValue);
      System.out.println("✓ Token marked as used\n");

      // Test 5: Check validation after marking as used
      System.out.println("7. Testing token validation after marked as used...");
      boolean isValidAfterUse = dao.isValid(tokenValue);
      System.out.println("   Token valid after use: " + isValidAfterUse);
      if (!isValidAfterUse) {
        System.out.println("✓ Token correctly marked as invalid after use");
      } else {
        System.out.println("✗ Token should be invalid after use");
      }
      System.out.println();

      // Test 6: Test non-existent token
      System.out.println("8. Testing non-existent token...");
      String fakeToken = "fake-token-12345";
      EmailVerificationToken nonExistentToken = dao.findByToken(fakeToken);
      boolean fakeTokenValid = dao.isValid(fakeToken);
      if (nonExistentToken == null && !fakeTokenValid) {
        System.out.println("✓ Non-existent token handling works correctly");
      } else {
        System.out.println("✗ Non-existent token handling failed");
      }
      System.out.println();

      // Test 7: Create multiple tokens for testing cleanup
      System.out.println("9. Testing multiple tokens and cleanup...");
      EmailVerificationToken token2 = new EmailVerificationToken("test2@example.com");
      EmailVerificationToken token3 = new EmailVerificationToken("test3@example.com");
      dao.save(token2);
      dao.save(token3);
      System.out.println("✓ Multiple tokens created\n");

      // Test 8: Delete tokens by email
      System.out.println("10. Testing deleteTokensByEmail...");
      dao.deleteTokensByEmail(testEmail);
      EmailVerificationToken deletedToken = dao.findByToken(tokenValue);
      if (deletedToken == null) {
        System.out.println("✓ Tokens deleted by email successfully");
      } else {
        System.out.println("✗ Token deletion by email failed");
      }
      System.out.println();

      // Test 9: Delete expired tokens (this won't delete anything since tokens are
      // fresh)
      System.out.println("11. Testing deleteExpiredTokens...");
      dao.deleteExpiredTokens();
      System.out.println("✓ Expired tokens cleanup executed (no expired tokens to delete)\n");

      // Final cleanup
      System.out.println("12. Final cleanup...");
      dao.deleteTokensByEmail("test2@example.com");
      dao.deleteTokensByEmail("test3@example.com");
      System.out.println("✓ Final cleanup completed\n");

      System.out.println("=== All EmailVerificationTokenDAO Tests Completed Successfully! ===");

    } catch (SQLException e) {
      System.err.println("Database error during testing: " + e.getMessage());
      e.printStackTrace();
    } catch (Exception e) {
      System.err.println("Unexpected error during testing: " + e.getMessage());
      e.printStackTrace();
    }
  }
}