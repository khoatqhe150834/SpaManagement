package dao;

import db.DBContext;
import java.sql.*;
import java.util.List;
import java.util.Optional;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO implements BaseDAO<User, Integer> {

  @Override
  public <S extends User> S save(S user) {
    String sql = "INSERT INTO users (role_id, full_name, email, hash_password, phone_number, gender, birthday, avatar_url, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    try (Connection conn = DBContext.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
      ps.setInt(1, user.getRoleId());
      ps.setString(2, user.getFullName());
      ps.setString(3, user.getEmail());
      ps.setString(4, user.getHashPassword());
      ps.setString(5, user.getPhoneNumber());
      ps.setString(6, user.getGender());
      ps.setDate(7, user.getBirthday() != null ? new java.sql.Date(user.getBirthday().getTime()) : null);
      ps.setString(8, user.getAvatarUrl());
      ps.setBoolean(9, user.getIsActive());

      int rows = ps.executeUpdate();
      if (rows > 0) {
        try (ResultSet rs = ps.getGeneratedKeys()) {
          if (rs.next()) {
            user.setUserId(rs.getInt(1));
          }
        }
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return user;
  }

  @Override
  public Optional<User> findById(Integer id) {
    throw new UnsupportedOperationException("Not supported yet.");
  }

  @Override
  public List<User> findAll() {
    throw new UnsupportedOperationException("Not supported yet.");
  }

  @Override
  public boolean existsById(Integer id) {
    throw new UnsupportedOperationException("Not supported yet.");
  }

  @Override
  public void deleteById(Integer id) {
    throw new UnsupportedOperationException("Not supported yet.");
  }

  @Override
  public <S extends User> S update(S entity) {
    throw new UnsupportedOperationException("Not supported yet.");
  }

  @Override
  public void delete(User entity) {
    throw new UnsupportedOperationException("Not supported yet.");
  }

  public boolean isExistsByEmail(String email) {
    boolean isExists = false;
    if (email == null || email.trim().isEmpty()) {
      return false;
    }

    try (Connection connection = DBContext.getConnection();
        PreparedStatement ps = connection.prepareStatement("SELECT * FROM users WHERE email = ?")) {
      ps.setString(1, email);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
        isExists = true;
      }
    } catch (SQLException e) {
      throw new RuntimeException("Error checking email existence: " + e.getMessage(), e);
    }
    return isExists;
  }

  public boolean isExistsByPhone(String phone) {
    boolean isExists = false;
    if (phone == null || phone.trim().isEmpty()) {
      return false;
    }
    try (Connection connection = DBContext.getConnection();
        PreparedStatement ps = connection.prepareStatement("SELECT COUNT(*) FROM users WHERE phone_number = ?")) {
      ps.setString(1, phone);
      ResultSet rs = ps.executeQuery();
      if (rs.next() && rs.getInt(1) > 0) {
        isExists = true;
      }
    } catch (SQLException e) {
      throw new RuntimeException("Error checking phone existence: " + e.getMessage(), e);
    }
    return isExists;
  }

  public boolean validateAccount(String email, String password) {
    try (Connection connection = DBContext.getConnection();
        PreparedStatement ps = connection.prepareStatement("SELECT hash_password FROM users WHERE email = ?")) {
      ps.setString(1, email);
      ResultSet rs = ps.executeQuery();

      if (rs.next()) {
        String storedHash = rs.getString("hash_password");
        return BCrypt.checkpw(password, storedHash);
      }
    } catch (SQLException e) {
      throw new RuntimeException("Error validating account: " + e.getMessage(), e);
    }
    return false;
  }

  public Optional<User> findUserByEmail(String email) {
    if (email == null || email.trim().isEmpty()) {
      return Optional.empty();
    }

    try (Connection connection = DBContext.getConnection();
        PreparedStatement ps = connection.prepareStatement("SELECT * FROM users WHERE email = ?")) {
      ps.setString(1, email);
      ResultSet rs = ps.executeQuery();

      if (rs.next()) {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setRoleId(rs.getInt("role_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setHashPassword(rs.getString("hash_password"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setIsActive(rs.getBoolean("is_active"));
        user.setGender(rs.getString("gender"));
        user.setBirthday(rs.getDate("birthday"));
        user.setAvatarUrl(rs.getString("avatar_url"));
        user.setLastLoginAt(rs.getDate("last_login_at"));
        user.setCreatedAt(rs.getDate("created_at"));
        user.setUpdatedAt(rs.getDate("updated_at"));

        return Optional.of(user);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return Optional.empty();
  }

  public boolean updatePassword(String email, String newPassword) throws SQLException {
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

  public User getUserByEmailAndPassword(String email, String password) {
    User user = null;
    try (Connection connection = DBContext.getConnection();
        PreparedStatement ps = connection.prepareStatement("SELECT * FROM users WHERE email = ?")) {
      ps.setString(1, email);
      ResultSet rs = ps.executeQuery();

      if (rs.next()) {
        String storedHash = rs.getString("hash_password");
        if (BCrypt.checkpw(password, storedHash)) {
          user = new User();
          user.setUserId(rs.getInt("user_id"));
          user.setRoleId(rs.getInt("role_id"));
          user.setFullName(rs.getString("full_name"));
          user.setEmail(rs.getString("email"));
          user.setPhoneNumber(rs.getString("phone_number"));
          user.setIsActive(rs.getBoolean("is_active"));
          user.setGender(rs.getString("gender"));
          user.setBirthday(rs.getDate("birthday"));
          user.setAvatarUrl(rs.getString("avatar_url"));
        }
      }
    } catch (SQLException e) {
      return null;
    }
    return user;
  }

    public boolean updateProfile(User user) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}