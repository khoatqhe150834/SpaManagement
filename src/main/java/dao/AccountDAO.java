package dao;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import org.mindrot.jbcrypt.BCrypt;

/**
 * Shared DAO for operations that span both Customer and User tables
 * Handles system-wide checks and cross-table operations
 */
public class AccountDAO {

  // Account type constants

  /**
   * Checks if an email exists in either customers or users table
   * 
   * @param email The email to check
   * @return true if email exists in either table
   */
  public boolean isEmailTakenInSystem(String email) {
    if (email == null || email.trim().isEmpty()) {
      return false;
    }
    String sql = "SELECT 1 FROM customers WHERE email = ? UNION SELECT 1 FROM users WHERE email = ? LIMIT 1";
    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, email);
      ps.setString(2, email);
      try (ResultSet rs = ps.executeQuery()) {
        return rs.next();
      }
    } catch (SQLException e) {
      throw new RuntimeException("Error checking email existence in system: " + e.getMessage(), e);
    }
  }

  /**
   * Checks if a phone number exists in either customers or users table
   * 
   * @param phone The phone number to check
   * @return true if phone exists in either table
   */
  public boolean isPhoneTakenInSystem(String phone) {
    if (phone == null || phone.trim().isEmpty()) {
      return false;
    }
    String sql = "SELECT 1 FROM customers WHERE phone_number = ? UNION SELECT 1 FROM users WHERE phone_number = ? LIMIT 1";
    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, phone);
      ps.setString(2, phone);
      try (ResultSet rs = ps.executeQuery()) {
        return rs.next();
      }
    } catch (SQLException e) {
      throw new RuntimeException("Error checking phone existence in system: " + e.getMessage(), e);
    }
  }

  /**
   * Determines which table (customer or user) contains the given email
   * 
   * @param email The email to check
   * @return ACCOUNT_TYPE_CUSTOMER, ACCOUNT_TYPE_USER, or null if not found
   */

  /**
   * Determines which table (customer or user) contains the given phone number
   * 
   * @param phone The phone number to check
   * @return ACCOUNT_TYPE_CUSTOMER, ACCOUNT_TYPE_USER, or null if not found
   */

  /**
   * Checks if an email exists in the customers table specifically
   * 
   * @param email The email to check
   * @return true if email exists in customers table
   */
  public boolean isCustomerEmailExists(String email) {
    if (email == null || email.trim().isEmpty()) {
      return false;
    }
    String sql = "SELECT 1 FROM customers WHERE email = ? LIMIT 1";
    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, email);
      try (ResultSet rs = ps.executeQuery()) {
        return rs.next();
      }
    } catch (SQLException e) {
      throw new RuntimeException("Error checking customer email existence: " + e.getMessage(), e);
    }
  }

  /**
   * Checks if an email exists in the users table specifically
   * 
   * @param email The email to check
   * @return true if email exists in users table
   */
  public boolean isUserEmailExists(String email) {
    if (email == null || email.trim().isEmpty()) {
      return false;
    }
    String sql = "SELECT 1 FROM users WHERE email = ? LIMIT 1";
    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, email);
      try (ResultSet rs = ps.executeQuery()) {
        return rs.next();
      }
    } catch (SQLException e) {
      throw new RuntimeException("Error checking user email existence: " + e.getMessage(), e);
    }
  }

  /**
   * Checks if a phone exists in the customers table specifically
   * 
   * @param phone The phone number to check
   * @return true if phone exists in customers table
   */
  public boolean isCustomerPhoneExists(String phone) {
    if (phone == null || phone.trim().isEmpty()) {
      return false;
    }
    String sql = "SELECT 1 FROM customers WHERE phone_number = ? LIMIT 1";
    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, phone);
      try (ResultSet rs = ps.executeQuery()) {
        return rs.next();
      }
    } catch (SQLException e) {
      throw new RuntimeException("Error checking customer phone existence: " + e.getMessage(), e);
    }
  }

  /**
   * Checks if a phone exists in the users table specifically
   * 
   * @param phone The phone number to check
   * @return true if phone exists in users table
   */
  public boolean isUserPhoneExists(String phone) {
    if (phone == null || phone.trim().isEmpty()) {
      return false;
    }
    String sql = "SELECT 1 FROM users WHERE phone_number = ? LIMIT 1";
    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, phone);
      try (ResultSet rs = ps.executeQuery()) {
        return rs.next();
      }
    } catch (SQLException e) {
      throw new RuntimeException("Error checking user phone existence: " + e.getMessage(), e);
    }
  }

  public boolean updateUserPassword(String email, String newPassword) throws SQLException {
    if (email == null || email.trim().isEmpty() || newPassword == null || newPassword.trim().isEmpty()) {
      return false;
    }

    String sql = "UPDATE users SET hash_password = ?, updated_at = ? WHERE email = ?";

    try (Connection connection = DBContext.getConnection();
        PreparedStatement stmt = connection.prepareStatement(sql)) {

      // Hash the password using BCrypt (same as used in registration)
      String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

      stmt.setString(1, hashedPassword);
      stmt.setTimestamp(2, java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
      stmt.setString(3, email);

      int rowsAffected = stmt.executeUpdate();
      return rowsAffected > 0;
    }
  }

  public boolean updateCustomerPassword(String email, String newPassword) {
    if (email == null || email.trim().isEmpty() || newPassword == null || newPassword.trim().isEmpty()) {
      return false;
    }
    String sql = "UPDATE customers SET hash_password = ?, updated_at = ? WHERE email = ?";
    try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, BCrypt.hashpw(newPassword, BCrypt.gensalt()));
      ps.setTimestamp(2, Timestamp.valueOf(java.time.LocalDateTime.now()));
      ps.setString(3, email);
      int rowsAffected = ps.executeUpdate();
      return rowsAffected > 0;
    } catch (SQLException e) {
      throw new RuntimeException("Error updating password: " + e.getMessage(), e);
    }
  }

  /**
   * Gets the current password hash for a customer
   * 
   * @param email The customer's email
   * @return The current password hash, or null if customer not found
   * @throws SQLException if database error occurs
   */
  public String getCustomerPasswordHash(String email) throws SQLException {
    if (email == null || email.trim().isEmpty()) {
      return null;
    }
    String sql = "SELECT hash_password FROM customers WHERE email = ?";
    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, email);
      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          return rs.getString("hash_password");
        }
      }
    }
    return null;
  }

  /**
   * Gets the current password hash for a user
   * 
   * @param email The user's email
   * @return The current password hash, or null if user not found
   * @throws SQLException if database error occurs
   */
  public String getUserPasswordHash(String email) throws SQLException {
    if (email == null || email.trim().isEmpty()) {
      return null;
    }
    String sql = "SELECT hash_password FROM users WHERE email = ?";
    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, email);
      try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
          return rs.getString("hash_password");
        }
      }
    }
    return null;
  }

}