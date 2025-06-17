package dao;

import db.DBContext;
import model.Checkin;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * DAO for managing check-in operations
 * 
 * @author quang
 */
public class CheckinDAO extends DBContext implements BaseDAO<Checkin, Integer> {

  @Override
  public <S extends Checkin> S save(S entity) {
    String sql = "INSERT INTO checkins (appointment_id, customer_id, checkin_time, status, notes) VALUES (?, ?, ?, ?, ?)";

    try {
      Connection conn = DBContext.getConnection();
      PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

      stmt.setInt(1, entity.getAppointmentId());
      stmt.setInt(2, entity.getCustomerId());
      stmt.setTimestamp(3, Timestamp.valueOf(entity.getCheckinTime()));
      stmt.setString(4, entity.getStatus());
      stmt.setString(5, entity.getNotes());

      int affectedRows = stmt.executeUpdate();
      if (affectedRows > 0) {
        ResultSet rs = stmt.getGeneratedKeys();
        if (rs.next()) {
          entity.setCheckinId(rs.getInt(1));
          return entity;
        }
      }
    } catch (SQLException e) {
      System.out.println("Error saving checkin: " + e.getMessage());
      e.printStackTrace();
    } finally {
      closeConnection();
    }

    return null;
  }

  @Override
  public Optional<Checkin> findById(Integer id) {
    String sql = "SELECT * FROM checkins WHERE checkin_id = ?";

    try {
      Connection conn = DBContext.getConnection();
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setInt(1, id);

      ResultSet rs = stmt.executeQuery();
      if (rs.next()) {
        return Optional.of(getFromResultSet(rs));
      }
    } catch (SQLException e) {
      System.out.println("Error finding checkin by ID: " + e.getMessage());
    } finally {
      closeConnection();
    }

    return Optional.empty();
  }

  public boolean existsByAppointmentId(Integer appointmentId) {
    String sql = "SELECT COUNT(*) FROM checkins WHERE appointment_id = ?";

    try {
      Connection conn = DBContext.getConnection();
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setInt(1, appointmentId);

      ResultSet rs = stmt.executeQuery();
      if (rs.next()) {
        return rs.getInt(1) > 0;
      }
    } catch (SQLException e) {
      System.out.println("Error checking checkin existence: " + e.getMessage());
    } finally {
      closeConnection();
    }

    return false;
  }

  public Optional<Checkin> findByAppointmentId(Integer appointmentId) {
    String sql = "SELECT * FROM checkins WHERE appointment_id = ? ORDER BY checkin_time DESC LIMIT 1";

    try {
      Connection conn = DBContext.getConnection();
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setInt(1, appointmentId);

      ResultSet rs = stmt.executeQuery();
      if (rs.next()) {
        return Optional.of(getFromResultSet(rs));
      }
    } catch (SQLException e) {
      System.out.println("Error finding checkin by appointment ID: " + e.getMessage());
    } finally {
      closeConnection();
    }

    return Optional.empty();
  }

  public List<Checkin> findByCustomerId(Integer customerId) {
    List<Checkin> checkins = new ArrayList<>();
    String sql = "SELECT * FROM checkins WHERE customer_id = ? ORDER BY checkin_time DESC";

    try {
      Connection conn = DBContext.getConnection();
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setInt(1, customerId);

      ResultSet rs = stmt.executeQuery();
      while (rs.next()) {
        checkins.add(getFromResultSet(rs));
      }
    } catch (SQLException e) {
      System.out.println("Error finding checkins by customer ID: " + e.getMessage());
    } finally {
      closeConnection();
    }

    return checkins;
  }

  @Override
  public List<Checkin> findAll() {
    List<Checkin> checkins = new ArrayList<>();
    String sql = "SELECT * FROM checkins ORDER BY checkin_time DESC";

    try {
      Connection conn = DBContext.getConnection();
      PreparedStatement stmt = conn.prepareStatement(sql);

      ResultSet rs = stmt.executeQuery();
      while (rs.next()) {
        checkins.add(getFromResultSet(rs));
      }
    } catch (SQLException e) {
      System.out.println("Error finding all checkins: " + e.getMessage());
    } finally {
      closeConnection();
    }

    return checkins;
  }

  @Override
  public boolean existsById(Integer id) {
    String sql = "SELECT COUNT(*) FROM checkins WHERE checkin_id = ?";

    try {
      Connection conn = DBContext.getConnection();
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setInt(1, id);

      ResultSet rs = stmt.executeQuery();
      if (rs.next()) {
        return rs.getInt(1) > 0;
      }
    } catch (SQLException e) {
      System.out.println("Error checking checkin existence by ID: " + e.getMessage());
    } finally {
      closeConnection();
    }

    return false;
  }

  @Override
  public void deleteById(Integer id) {
    String sql = "DELETE FROM checkins WHERE checkin_id = ?";

    try {
      Connection conn = DBContext.getConnection();
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setInt(1, id);

      stmt.executeUpdate();
    } catch (SQLException e) {
      System.out.println("Error deleting checkin: " + e.getMessage());
    } finally {
      closeConnection();
    }
  }

  @Override
  public <S extends Checkin> S update(S entity) {
    String sql = "UPDATE checkins SET appointment_id = ?, customer_id = ?, checkin_time = ?, status = ?, notes = ? WHERE checkin_id = ?";

    try {
      Connection conn = DBContext.getConnection();
      PreparedStatement stmt = conn.prepareStatement(sql);

      stmt.setInt(1, entity.getAppointmentId());
      stmt.setInt(2, entity.getCustomerId());
      stmt.setTimestamp(3, Timestamp.valueOf(entity.getCheckinTime()));
      stmt.setString(4, entity.getStatus());
      stmt.setString(5, entity.getNotes());
      stmt.setInt(6, entity.getCheckinId());

      int affectedRows = stmt.executeUpdate();
      if (affectedRows > 0) {
        return entity;
      }
    } catch (SQLException e) {
      System.out.println("Error updating checkin: " + e.getMessage());
    } finally {
      closeConnection();
    }

    return null;
  }

  @Override
  public void delete(Checkin entity) {
    if (entity.getCheckinId() != null) {
      deleteById(entity.getCheckinId());
    }
  }

  private Checkin getFromResultSet(ResultSet rs) throws SQLException {
    Checkin checkin = new Checkin();
    checkin.setCheckinId(rs.getInt("checkin_id"));
    checkin.setAppointmentId(rs.getInt("appointment_id"));
    checkin.setCustomerId(rs.getInt("customer_id"));
    checkin.setCheckinTime(rs.getTimestamp("checkin_time").toLocalDateTime());
    checkin.setStatus(rs.getString("status"));
    checkin.setNotes(rs.getString("notes"));
    checkin.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
    checkin.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

    return checkin;
  }
}