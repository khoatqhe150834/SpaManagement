package dao;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import service.email.PasswordResetToken;

public class PasswordResetTokenDAO {

  // Save a new password reset token to the database
  public void save(PasswordResetToken token) throws SQLException {
    String sql = "INSERT INTO password_reset_tokens (token, user_email, expires_at, is_used) VALUES (?, ?, ?, ?)";
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
  public PasswordResetToken findByToken(String tokenValue) throws SQLException {
    String sql = "SELECT token, user_email, expires_at, is_used FROM password_reset_tokens WHERE token = ?";
    try (Connection connection = DBContext.getConnection();
        PreparedStatement stmt = connection.prepareStatement(sql)) {
      stmt.setString(1, tokenValue);
      try (ResultSet rs = stmt.executeQuery()) {
        if (rs.next()) {
          String userEmail = rs.getString("user_email");
          String token = rs.getString("token");
          LocalDateTime expiryDate = rs.getTimestamp("expires_at").toLocalDateTime();
          return new PasswordResetToken(userEmail, token, expiryDate);
        }
        return null;
      }
    }
  }

  // Mark a token as used
  public void markAsUsed(String tokenValue) throws SQLException {
    String sql = "UPDATE password_reset_tokens SET is_used = TRUE WHERE token = ?";
    try (Connection connection = DBContext.getConnection();
        PreparedStatement stmt = connection.prepareStatement(sql)) {
      stmt.setString(1, tokenValue);
      stmt.executeUpdate();
    }
  }

  // Check if a token is valid (not expired and not used)
  public boolean isValid(String tokenValue) throws SQLException {
    String sql = "SELECT expires_at, is_used FROM password_reset_tokens WHERE token = ?";
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
    String sql = "DELETE FROM password_reset_tokens WHERE expires_at < NOW()";
    try (Connection connection = DBContext.getConnection();
        PreparedStatement stmt = connection.prepareStatement(sql)) {
      stmt.executeUpdate();
    }
  }

  // Delete tokens for a specific user email
  public void deleteTokensByEmail(String userEmail) throws SQLException {
    String sql = "DELETE FROM password_reset_tokens WHERE user_email = ?";
    try (Connection connection = DBContext.getConnection();
        PreparedStatement stmt = connection.prepareStatement(sql)) {
      stmt.setString(1, userEmail);
      stmt.executeUpdate();
    }
  }
}