package dao;

import db.DBContext;
import java.sql.*;
import java.util.List;
import java.util.Optional;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO implements BaseDAO<User, Integer> {

  @Override
  public <S extends User> S save(S entity) {
    throw new UnsupportedOperationException("Not supported yet.");
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

  public User getUserByEmailAndPassword(String email, String password) {
    User user = null;
    try (Connection connection = DBContext.getConnection();
        PreparedStatement ps = connection
            .prepareStatement("SELECT * FROM Users WHERE email = ?")) {

      ps.setString(1, email);
      ResultSet rs = ps.executeQuery();

      if (rs.next()) {
        String storedHash = rs.getString("password_hash");
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
}