package dao;

import db.DBContext;
import model.BookingSession;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingSessionDAO {
  private static final Logger LOGGER = Logger.getLogger(BookingSessionDAO.class.getName());

  // Create a new booking session
  public boolean create(BookingSession session) {
    String sql = "INSERT INTO booking_sessions (session_id, customer_id, session_data, current_step, expires_at) " +
        "VALUES (?, ?, ?, ?, ?)";

    try (Connection connection = DBContext.getConnection();
        PreparedStatement statement = connection.prepareStatement(sql)) {

      // Serialize data before saving
      session.serializeData();

      statement.setString(1, session.getSessionId());
      statement.setObject(2, session.getCustomerId());
      statement.setString(3, session.getSessionData());
      statement.setString(4, session.getCurrentStep().name());
      statement.setTimestamp(5, Timestamp.valueOf(session.getExpiresAt()));

      int rowsAffected = statement.executeUpdate();
      LOGGER.log(Level.INFO, "Created booking session: {0}, rows affected: {1}",
          new Object[] { session.getSessionId(), rowsAffected });
      return rowsAffected > 0;

    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error creating booking session: " + session.getSessionId(), e);
      return false;
    }
  }

  // Find session by session ID
  public BookingSession findBySessionId(String sessionId) {
    String sql = "SELECT session_id, customer_id, session_data, current_step, expires_at, created_at, updated_at " +
        "FROM booking_sessions WHERE session_id = ? AND expires_at > NOW()";

    try (Connection connection = DBContext.getConnection();
        PreparedStatement statement = connection.prepareStatement(sql)) {

      statement.setString(1, sessionId);
      ResultSet resultSet = statement.executeQuery();

      if (resultSet.next()) {
        return mapResultSetToBookingSession(resultSet);
      }

    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error finding booking session: " + sessionId, e);
    }

    return null;
  }

  // Find active session by customer ID (for logged-in users)
  public BookingSession findByCustomerId(Integer customerId) {
    String sql = "SELECT session_id, customer_id, session_data, current_step, expires_at, created_at, updated_at " +
        "FROM booking_sessions WHERE customer_id = ? AND expires_at > NOW() " +
        "ORDER BY updated_at DESC LIMIT 1";

    try (Connection connection = DBContext.getConnection();
        PreparedStatement statement = connection.prepareStatement(sql)) {

      statement.setInt(1, customerId);
      ResultSet resultSet = statement.executeQuery();

      if (resultSet.next()) {
        return mapResultSetToBookingSession(resultSet);
      }

    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error finding booking session for customer: " + customerId, e);
    }

    return null;
  }

  // Update existing booking session
  public boolean update(BookingSession session) {
    String sql = "UPDATE booking_sessions SET customer_id = ?, session_data = ?, current_step = ?, " +
        "expires_at = ?, updated_at = CURRENT_TIMESTAMP WHERE session_id = ?";

    try (Connection connection = DBContext.getConnection();
        PreparedStatement statement = connection.prepareStatement(sql)) {

      // Serialize data before saving
      session.serializeData();

      statement.setObject(1, session.getCustomerId());
      statement.setString(2, session.getSessionData());
      statement.setString(3, session.getCurrentStep().name());
      statement.setTimestamp(4, Timestamp.valueOf(session.getExpiresAt()));
      statement.setString(5, session.getSessionId());

      int rowsAffected = statement.executeUpdate();
      LOGGER.log(Level.INFO, "Updated booking session: {0}, rows affected: {1}",
          new Object[] { session.getSessionId(), rowsAffected });
      return rowsAffected > 0;

    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error updating booking session: " + session.getSessionId(), e);
      return false;
    }
  }

  // Delete booking session
  public boolean delete(String sessionId) {
    String sql = "DELETE FROM booking_sessions WHERE session_id = ?";

    try (Connection connection = DBContext.getConnection();
        PreparedStatement statement = connection.prepareStatement(sql)) {

      statement.setString(1, sessionId);
      int rowsAffected = statement.executeUpdate();
      LOGGER.log(Level.INFO, "Deleted booking session: {0}, rows affected: {1}",
          new Object[] { sessionId, rowsAffected });
      return rowsAffected > 0;

    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error deleting booking session: " + sessionId, e);
      return false;
    }
  }

  // Clean up expired sessions
  public int deleteExpiredSessions() {
    String sql = "DELETE FROM booking_sessions WHERE expires_at <= NOW()";

    try (Connection connection = DBContext.getConnection();
        PreparedStatement statement = connection.prepareStatement(sql)) {

      int rowsDeleted = statement.executeUpdate();
      LOGGER.log(Level.INFO, "Cleaned up {0} expired booking sessions", rowsDeleted);
      return rowsDeleted;

    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error cleaning up expired sessions", e);
      return 0;
    }
  }

  // Convert guest session to customer session after registration
  public boolean convertToCustomerSession(String sessionId, Integer customerId) {
    String sql = "UPDATE booking_sessions SET customer_id = ?, current_step = 'PAYMENT', " +
        "updated_at = CURRENT_TIMESTAMP WHERE session_id = ? AND customer_id IS NULL";

    try (Connection connection = DBContext.getConnection();
        PreparedStatement statement = connection.prepareStatement(sql)) {

      statement.setInt(1, customerId);
      statement.setString(2, sessionId);

      int rowsAffected = statement.executeUpdate();
      LOGGER.log(Level.INFO, "Converted guest session to customer session: {0} -> {1}, rows affected: {2}",
          new Object[] { sessionId, customerId, rowsAffected });
      return rowsAffected > 0;

    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error converting session to customer: " + sessionId, e);
      return false;
    }
  }

  // Find all sessions for a customer (for admin purposes)
  public List<BookingSession> findAllByCustomerId(Integer customerId) {
    String sql = "SELECT session_id, customer_id, session_data, current_step, expires_at, created_at, updated_at " +
        "FROM booking_sessions WHERE customer_id = ? ORDER BY created_at DESC";

    List<BookingSession> sessions = new ArrayList<>();

    try (Connection connection = DBContext.getConnection();
        PreparedStatement statement = connection.prepareStatement(sql)) {

      statement.setInt(1, customerId);
      ResultSet resultSet = statement.executeQuery();

      while (resultSet.next()) {
        sessions.add(mapResultSetToBookingSession(resultSet));
      }

    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error finding all sessions for customer: " + customerId, e);
    }

    return sessions;
  }

  // Get session statistics (for monitoring)
  public SessionStats getSessionStats() {
    String sql = "SELECT " +
        "COUNT(*) as total_sessions, " +
        "COUNT(CASE WHEN customer_id IS NULL THEN 1 END) as guest_sessions, " +
        "COUNT(CASE WHEN customer_id IS NOT NULL THEN 1 END) as customer_sessions, " +
        "COUNT(CASE WHEN expires_at <= NOW() THEN 1 END) as expired_sessions " +
        "FROM booking_sessions";

    try (Connection connection = DBContext.getConnection();
        PreparedStatement statement = connection.prepareStatement(sql)) {

      ResultSet resultSet = statement.executeQuery();

      if (resultSet.next()) {
        return new SessionStats(
            resultSet.getInt("total_sessions"),
            resultSet.getInt("guest_sessions"),
            resultSet.getInt("customer_sessions"),
            resultSet.getInt("expired_sessions"));
      }

    } catch (SQLException e) {
      LOGGER.log(Level.SEVERE, "Error getting session statistics", e);
    }

    return new SessionStats(0, 0, 0, 0);
  }

  // Helper method to map ResultSet to BookingSession object
  private BookingSession mapResultSetToBookingSession(ResultSet resultSet) throws SQLException {
    BookingSession session = new BookingSession();

    session.setSessionId(resultSet.getString("session_id"));
    session.setCustomerId((Integer) resultSet.getObject("customer_id"));
    session.setSessionData(resultSet.getString("session_data"));
    session.setCurrentStep(BookingSession.CurrentStep.valueOf(resultSet.getString("current_step").toUpperCase()));
    session.setExpiresAt(resultSet.getTimestamp("expires_at").toLocalDateTime());
    session.setCreatedAt(resultSet.getTimestamp("created_at").toLocalDateTime());
    session.setUpdatedAt(resultSet.getTimestamp("updated_at").toLocalDateTime());

    // Deserialize JSON data
    session.deserializeData();

    return session;
  }

  // Inner class for session statistics
  public static class SessionStats {
    public final int totalSessions;
    public final int guestSessions;
    public final int customerSessions;
    public final int expiredSessions;

    public SessionStats(int totalSessions, int guestSessions, int customerSessions, int expiredSessions) {
      this.totalSessions = totalSessions;
      this.guestSessions = guestSessions;
      this.customerSessions = customerSessions;
      this.expiredSessions = expiredSessions;
    }

    @Override
    public String toString() {
      return String.format("SessionStats{total=%d, guest=%d, customer=%d, expired=%d}",
          totalSessions, guestSessions, customerSessions, expiredSessions);
    }
  }
}