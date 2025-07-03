package dao;

import db.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Checkin;

/**
 * DAO for managing check-in operations
 * 
 * @author quang
 */
public class CheckinDAO implements BaseDAO<Checkin, Integer> {
  private static final Logger LOGGER = Logger.getLogger(CheckinDAO.class.getName());

  @Override
  public <S extends Checkin> S save(S entity) {
    String sql = "INSERT INTO checkins (appointment_id, customer_id, checkin_time, status, notes) VALUES (?, ?, ?, ?, ?)";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
      conn = getConnection();
      stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

      stmt.setInt(1, entity.getAppointmentId());
      stmt.setInt(2, entity.getCustomerId());
      stmt.setTimestamp(3, Timestamp.valueOf(entity.getCheckinTime()));
      stmt.setString(4, entity.getStatus());
      stmt.setString(5, entity.getNotes());

      int affectedRows = stmt.executeUpdate();
      if (affectedRows > 0) {
        rs = stmt.getGeneratedKeys();
        if (rs.next()) {
          entity.setCheckinId(rs.getInt(1));
          return entity;
        }
      }
    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error saving checkin", e);
    } finally {
      closeResources(rs, stmt, conn);
    }

    return null;
  }

  @Override
  public Optional<Checkin> findById(Integer id) {
    String sql = "SELECT * FROM checkins WHERE checkin_id = ?";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
      conn = getConnection();
      stmt = conn.prepareStatement(sql);
      stmt.setInt(1, id);

      rs = stmt.executeQuery();
      if (rs.next()) {
        return Optional.of(getFromResultSet(rs));
      }
    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error finding checkin by ID: " + id, e);
    } finally {
      closeResources(rs, stmt, conn);
    }

    return Optional.empty();
  }

  public boolean existsByAppointmentId(Integer appointmentId) {
    String sql = "SELECT COUNT(*) FROM checkins WHERE appointment_id = ?";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
      conn = getConnection();
      stmt = conn.prepareStatement(sql);
      stmt.setInt(1, appointmentId);

      rs = stmt.executeQuery();
      if (rs.next()) {
        return rs.getInt(1) > 0;
      }
    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error checking checkin existence for appointment: " + appointmentId, e);
    } finally {
      closeResources(rs, stmt, conn);
    }

    return false;
  }

  public Optional<Checkin> findByAppointmentId(Integer appointmentId) {
    String sql = "SELECT * FROM checkins WHERE appointment_id = ? ORDER BY checkin_time DESC LIMIT 1";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
      conn = getConnection();
      stmt = conn.prepareStatement(sql);
      stmt.setInt(1, appointmentId);

      rs = stmt.executeQuery();
      if (rs.next()) {
        return Optional.of(getFromResultSet(rs));
      }
    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error finding checkin by appointment ID: " + appointmentId, e);
    } finally {
      closeResources(rs, stmt, conn);
    }

    return Optional.empty();
  }

  public List<Checkin> findByCustomerId(Integer customerId) {
    List<Checkin> checkins = new ArrayList<>();
    String sql = "SELECT * FROM checkins WHERE customer_id = ? ORDER BY checkin_time DESC";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
      conn = getConnection();
      stmt = conn.prepareStatement(sql);
      stmt.setInt(1, customerId);

      rs = stmt.executeQuery();
      while (rs.next()) {
        checkins.add(getFromResultSet(rs));
      }
    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error finding checkins by customer ID: " + customerId, e);
    } finally {
      closeResources(rs, stmt, conn);
    }

    return checkins;
  }

  @Override
  public List<Checkin> findAll() {
    List<Checkin> checkins = new ArrayList<>();
    String sql = "SELECT * FROM checkins ORDER BY checkin_time DESC";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
      conn = getConnection();
      stmt = conn.prepareStatement(sql);

      rs = stmt.executeQuery();
      while (rs.next()) {
        checkins.add(getFromResultSet(rs));
      }
    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error finding all checkins", e);
    } finally {
      closeResources(rs, stmt, conn);
    }

    return checkins;
  }

  @Override
  public boolean existsById(Integer id) {
    String sql = "SELECT COUNT(*) FROM checkins WHERE checkin_id = ?";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
      conn = getConnection();
      stmt = conn.prepareStatement(sql);
      stmt.setInt(1, id);

      rs = stmt.executeQuery();
      if (rs.next()) {
        return rs.getInt(1) > 0;
      }
    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error checking checkin existence by ID: " + id, e);
    } finally {
      closeResources(rs, stmt, conn);
    }

    return false;
  }

  @Override
  public void deleteById(Integer id) {
    String sql = "DELETE FROM checkins WHERE checkin_id = ?";

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
      conn = getConnection();
      stmt = conn.prepareStatement(sql);
      stmt.setInt(1, id);

      stmt.executeUpdate();
    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error deleting checkin with ID: " + id, e);
    } finally {
      closeResources(null, stmt, conn);
    }
  }

  @Override
  public <S extends Checkin> S update(S entity) {
    String sql = "UPDATE checkins SET appointment_id = ?, customer_id = ?, checkin_time = ?, status = ?, notes = ? WHERE checkin_id = ?";

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
      conn = getConnection();
      stmt = conn.prepareStatement(sql);

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
      LOGGER.log(Level.SEVERE, "Error updating checkin: " + entity.getCheckinId(), e);
    } finally {
      closeResources(null, stmt, conn);
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