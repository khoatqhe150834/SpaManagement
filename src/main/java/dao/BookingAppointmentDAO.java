package dao;

import db.DBContext;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import model.BookingAppointment;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.time.LocalDateTime;

/**
 * DAO for BookingAppointment entity using booking_appointments table
 * Based on the actual database structure from Dump20250617.sql
 */
public class BookingAppointmentDAO extends DBContext implements BaseDAO<BookingAppointment, Integer> {

  @Override
  public <S extends BookingAppointment> S save(S entity) {
    String sql = "INSERT INTO booking_appointments (booking_group_id, service_id, therapist_user_id, start_time, end_time, service_price, status, service_notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

      stmt.setInt(1, entity.getBookingGroupId());
      stmt.setInt(2, entity.getServiceId());
      stmt.setInt(3, entity.getTherapistUserId());
      stmt.setObject(4, entity.getStartTime());
      stmt.setObject(5, entity.getEndTime());
      stmt.setBigDecimal(6, entity.getServicePrice());
      stmt.setString(7, entity.getStatus());
      stmt.setString(8, entity.getServiceNotes());

      int rowsAffected = stmt.executeUpdate();
      if (rowsAffected > 0) {
        try (ResultSet rs = stmt.getGeneratedKeys()) {
          if (rs.next()) {
            entity.setAppointmentId(rs.getInt(1));
          }
        }
        return entity;
      }
    } catch (SQLException e) {
      System.err.println("Error saving booking appointment: " + e.getMessage());
    }

    return null;
  }

  @Override
  public Optional<BookingAppointment> findById(Integer id) {
    String sql = "SELECT appointment_id, booking_group_id, service_id, therapist_user_id, start_time, end_time, service_price, status, service_notes, created_at, updated_at FROM booking_appointments WHERE appointment_id = ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, id);
      try (ResultSet rs = stmt.executeQuery()) {
        if (rs.next()) {
          return Optional.of(getFromResultSet(rs));
        }
      }
    } catch (SQLException e) {
      System.err.println("Error finding booking appointment by ID: " + e.getMessage());
    }

    return Optional.empty();
  }

  @Override
  public List<BookingAppointment> findAll() {
    List<BookingAppointment> appointments = new ArrayList<>();
    String sql = "SELECT appointment_id, booking_group_id, service_id, therapist_user_id, start_time, end_time, service_price, status, service_notes, created_at, updated_at FROM booking_appointments ORDER BY appointment_id";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery()) {

      while (rs.next()) {
        appointments.add(getFromResultSet(rs));
      }
    } catch (SQLException e) {
      System.err.println("Error finding all booking appointments: " + e.getMessage());
    }

    return appointments;
  }

  /**
   * Find appointments by therapist and time range for conflict checking
   */
  public List<BookingAppointment> findByTherapistAndTimeRange(int therapistUserId, LocalDateTime startTime,
      LocalDateTime endTime) {
    List<BookingAppointment> appointments = new ArrayList<>();
    String sql = "SELECT appointment_id, booking_group_id, service_id, therapist_user_id, start_time, end_time, service_price, status, service_notes, created_at, updated_at "
        +
        "FROM booking_appointments " +
        "WHERE therapist_user_id = ? " +
        "AND status IN ('SCHEDULED', 'IN_PROGRESS') " +
        "AND (" +
        "  (start_time < ? AND end_time > ?) OR " + // Existing appointment overlaps start
        "  (start_time < ? AND end_time > ?) OR " + // Existing appointment overlaps end
        "  (start_time >= ? AND end_time <= ?)" + // New appointment completely contains existing
        ")";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, therapistUserId);
      stmt.setObject(2, endTime); // end_time > start_time (overlap start)
      stmt.setObject(3, startTime); // start_time < start_time (overlap start)
      stmt.setObject(4, endTime); // end_time > end_time (overlap end)
      stmt.setObject(5, startTime); // start_time < end_time (overlap end)
      stmt.setObject(6, startTime); // start_time >= start_time (contains)
      stmt.setObject(7, endTime); // end_time <= end_time (contains)

      try (ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
          appointments.add(getFromResultSet(rs));
        }
      }
    } catch (SQLException e) {
      System.err.println("Error finding appointments by therapist and time range: " + e.getMessage());
    }

    return appointments;
  }

  /**
   * Find appointments by customer and time range for conflict checking
   */
  public List<BookingAppointment> findByCustomerAndTimeRange(int customerId, LocalDateTime startTime,
      LocalDateTime endTime) {
    List<BookingAppointment> appointments = new ArrayList<>();
    String sql = "SELECT ba.appointment_id, ba.booking_group_id, ba.service_id, ba.therapist_user_id, ba.start_time, ba.end_time, ba.service_price, ba.status, ba.service_notes, ba.created_at, ba.updated_at "
        +
        "FROM booking_appointments ba " +
        "JOIN booking_groups bg ON ba.booking_group_id = bg.booking_group_id " +
        "WHERE bg.customer_id = ? " +
        "AND ba.status IN ('SCHEDULED', 'IN_PROGRESS') " +
        "AND (" +
        "  (ba.start_time < ? AND ba.end_time > ?) OR " + // Existing appointment overlaps start
        "  (ba.start_time < ? AND ba.end_time > ?) OR " + // Existing appointment overlaps end
        "  (ba.start_time >= ? AND ba.end_time <= ?)" + // New appointment completely contains existing
        ")";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, customerId);
      stmt.setObject(2, endTime); // end_time > start_time (overlap start)
      stmt.setObject(3, startTime); // start_time < start_time (overlap start)
      stmt.setObject(4, endTime); // end_time > end_time (overlap end)
      stmt.setObject(5, startTime); // start_time < end_time (overlap end)
      stmt.setObject(6, startTime); // start_time >= start_time (contains)
      stmt.setObject(7, endTime); // end_time <= end_time (contains)

      try (ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
          appointments.add(getFromResultSet(rs));
        }
      }
    } catch (SQLException e) {
      System.err.println("Error finding appointments by customer and time range: " + e.getMessage());
    }

    return appointments;
  }

  /**
   * Check for buffer time conflicts
   */
  public List<BookingAppointment> findByTherapistAndBufferTimeRange(int therapistUserId, LocalDateTime bufferStart,
      LocalDateTime appointmentStart, LocalDateTime appointmentEnd, LocalDateTime bufferEnd) {
    List<BookingAppointment> appointments = new ArrayList<>();
    String sql = "SELECT appointment_id, booking_group_id, service_id, therapist_user_id, start_time, end_time, service_price, status, service_notes, created_at, updated_at "
        +
        "FROM booking_appointments " +
        "WHERE therapist_user_id = ? " +
        "AND status IN ('SCHEDULED', 'IN_PROGRESS') " +
        "AND (" +
        "  (end_time > ? AND start_time < ?) OR " + // Check before appointment
        "  (start_time < ? AND end_time > ?)" + // Check after appointment
        ")";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, therapistUserId);
      stmt.setObject(2, bufferStart); // end_time > bufferStart
      stmt.setObject(3, appointmentStart); // start_time < appointmentStart
      stmt.setObject(4, bufferEnd); // start_time < bufferEnd
      stmt.setObject(5, appointmentEnd); // end_time > appointmentEnd

      try (ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
          appointments.add(getFromResultSet(rs));
        }
      }
    } catch (SQLException e) {
      System.err.println("Error finding appointments by therapist and buffer time range: " + e.getMessage());
    }

    return appointments;
  }

  /**
   * Update appointment status
   */
  public boolean updateStatus(Integer appointmentId, String newStatus) {
    String sql = "UPDATE booking_appointments SET status = ? WHERE appointment_id = ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setString(1, newStatus);
      stmt.setInt(2, appointmentId);

      int rowsAffected = stmt.executeUpdate();
      return rowsAffected > 0;
    } catch (SQLException e) {
      System.err.println("Error updating booking appointment status: " + e.getMessage());
    }

    return false;
  }

  @Override
  public boolean existsById(Integer id) {
    String sql = "SELECT 1 FROM booking_appointments WHERE appointment_id = ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, id);
      try (ResultSet rs = stmt.executeQuery()) {
        return rs.next();
      }
    } catch (SQLException e) {
      System.err.println("Error checking if booking appointment exists: " + e.getMessage());
    }

    return false;
  }

  @Override
  public void deleteById(Integer id) {
    String sql = "DELETE FROM booking_appointments WHERE appointment_id = ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, id);
      stmt.executeUpdate();
    } catch (SQLException e) {
      System.err.println("Error deleting booking appointment: " + e.getMessage());
    }
  }

  @Override
  public <S extends BookingAppointment> S update(S entity) {
    String sql = "UPDATE booking_appointments SET booking_group_id = ?, service_id = ?, therapist_user_id = ?, start_time = ?, end_time = ?, service_price = ?, status = ?, service_notes = ? WHERE appointment_id = ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, entity.getBookingGroupId());
      stmt.setInt(2, entity.getServiceId());
      stmt.setInt(3, entity.getTherapistUserId());
      stmt.setObject(4, entity.getStartTime());
      stmt.setObject(5, entity.getEndTime());
      stmt.setBigDecimal(6, entity.getServicePrice());
      stmt.setString(7, entity.getStatus());
      stmt.setString(8, entity.getServiceNotes());
      stmt.setInt(9, entity.getAppointmentId());

      int rowsAffected = stmt.executeUpdate();
      if (rowsAffected > 0) {
        return entity;
      }
    } catch (SQLException e) {
      System.err.println("Error updating booking appointment: " + e.getMessage());
    }

    return null;
  }

  @Override
  public void delete(BookingAppointment entity) {
    if (entity != null && entity.getAppointmentId() != null) {
      deleteById(entity.getAppointmentId());
    }
  }

  /**
   * Map ResultSet to BookingAppointment object
   */
  private BookingAppointment getFromResultSet(ResultSet rs) throws SQLException {
    return BookingAppointment.builder()
        .appointmentId(rs.getInt("appointment_id"))
        .bookingGroupId(rs.getInt("booking_group_id"))
        .serviceId(rs.getInt("service_id"))
        .therapistUserId(rs.getInt("therapist_user_id"))
        .startTime(rs.getTimestamp("start_time").toLocalDateTime())
        .endTime(rs.getTimestamp("end_time").toLocalDateTime())
        .servicePrice(rs.getBigDecimal("service_price"))
        .status(rs.getString("status"))
        .serviceNotes(rs.getString("service_notes"))
        .createdAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null)
        .updatedAt(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null)
        .build();
  }

  /**
   * Main method for testing BookingAppointmentDAO functionality
   */
  public static void main(String[] args) {
    System.out.println("=== Testing BookingAppointmentDAO ===");

    BookingAppointmentDAO dao = new BookingAppointmentDAO();

    // Test 1: Find all appointments
    System.out.println("\n1. Finding all booking appointments:");
    List<BookingAppointment> allAppointments = dao.findAll();
    System.out.println("- Total appointments found: " + allAppointments.size());

    for (int i = 0; i < Math.min(3, allAppointments.size()); i++) {
      BookingAppointment apt = allAppointments.get(i);
      System.out.println("  * Appointment " + apt.getAppointmentId() +
          " - Therapist: " + apt.getTherapistUserId() +
          " - Status: " + apt.getStatus() +
          " - Time: " + apt.getStartTime());
    }

    // Test 2: Find by ID
    if (!allAppointments.isEmpty()) {
      System.out.println("\n2. Testing findById:");
      Integer firstId = allAppointments.get(0).getAppointmentId();
      Optional<BookingAppointment> found = dao.findById(firstId);
      System.out.println("- Found appointment by ID " + firstId + ": " + found.isPresent());
      if (found.isPresent()) {
        System.out.println("  * Service ID: " + found.get().getServiceId());
        System.out.println("  * Booking Group ID: " + found.get().getBookingGroupId());
      }
    }

    // Test 3: Test conflict checking methods
    System.out.println("\n3. Testing conflict checking methods:");
    if (!allAppointments.isEmpty()) {
      BookingAppointment testApt = allAppointments.get(0);
      LocalDateTime testStart = testApt.getStartTime();
      LocalDateTime testEnd = testApt.getEndTime();

      List<BookingAppointment> conflicts = dao.findByTherapistAndTimeRange(
          testApt.getTherapistUserId(), testStart, testEnd);
      System.out.println("- Therapist conflicts found: " + conflicts.size());

      List<BookingAppointment> bufferConflicts = dao.findByTherapistAndBufferTimeRange(
          testApt.getTherapistUserId(),
          testStart.minusMinutes(10),
          testStart,
          testEnd,
          testEnd.plusMinutes(10));
      System.out.println("- Buffer time conflicts found: " + bufferConflicts.size());
    }

    System.out.println("\n=== Testing completed ===");
  }
}