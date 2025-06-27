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
import java.time.LocalDate;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

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
        "  start_time < ? AND end_time > ?" + // Overlap detection: existing_start < new_end AND existing_end >
                                              // new_start
        ")";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, therapistUserId);
      stmt.setObject(2, endTime); // start_time < new_end (existing appointment starts before new appointment
                                  // ends)
      stmt.setObject(3, startTime); // end_time > new_start (existing appointment ends after new appointment starts)

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
        "  ba.start_time < ? AND ba.end_time > ?" + // Overlap detection: existing_start < new_end AND existing_end >
                                                    // new_start
        ")";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, customerId);
      stmt.setObject(2, endTime); // ba.start_time < new_end (existing appointment starts before new appointment
                                  // ends)
      stmt.setObject(3, startTime); // ba.end_time > new_start (existing appointment ends after new appointment
                                    // starts)

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

  /**
   * Find appointments by customer ID for booking list
   */
  public List<BookingAppointment> findByCustomerId(int customerId) {
    List<BookingAppointment> appointments = new ArrayList<>();
    String sql = "SELECT ba.appointment_id, ba.booking_group_id, ba.service_id, ba.therapist_user_id, ba.start_time, ba.end_time, ba.service_price, ba.status, ba.service_notes, ba.created_at, ba.updated_at "
        + "FROM booking_appointments ba "
        + "JOIN booking_groups bg ON ba.booking_group_id = bg.booking_group_id "
        + "WHERE bg.customer_id = ? "
        + "ORDER BY ba.start_time DESC";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, customerId);
      try (ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
          appointments.add(getFromResultSet(rs));
        }
      }
    } catch (SQLException e) {
      System.err.println("Error finding appointments by customer ID: " + e.getMessage());
    }

    return appointments;
  }

  /**
   * Find appointment with service and therapist details for booking details page
   */
  public Map<String, Object> findAppointmentWithDetails(int appointmentId) {
    Map<String, Object> result = new HashMap<>();
    String sql = "SELECT ba.*, s.name as service_name, s.description as service_description, s.price as original_price, "
        + "u.full_name as therapist_name, u.phone_number as therapist_phone, "
        + "bg.customer_id, bg.booking_date, bg.total_amount, bg.payment_status, bg.booking_status, bg.special_notes "
        + "FROM booking_appointments ba "
        + "JOIN services s ON ba.service_id = s.service_id "
        + "JOIN users u ON ba.therapist_user_id = u.user_id "
        + "JOIN booking_groups bg ON ba.booking_group_id = bg.booking_group_id "
        + "WHERE ba.appointment_id = ?";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, appointmentId);
      try (ResultSet rs = stmt.executeQuery()) {
        if (rs.next()) {
          // Appointment details
          BookingAppointment appointment = getFromResultSet(rs);
          result.put("appointment", appointment);

          // Service details
          Map<String, Object> service = new HashMap<>();
          service.put("serviceId", rs.getInt("service_id"));
          service.put("serviceName", rs.getString("service_name"));
          service.put("serviceDescription", rs.getString("service_description"));
          service.put("originalPrice", rs.getBigDecimal("original_price"));
          result.put("service", service);

          // Therapist details
          Map<String, Object> therapist = new HashMap<>();
          therapist.put("therapistUserId", rs.getInt("therapist_user_id"));
          therapist.put("therapistName", rs.getString("therapist_name"));
          therapist.put("therapistPhone", rs.getString("therapist_phone"));
          result.put("therapist", therapist);

          // Booking group details
          Map<String, Object> bookingGroup = new HashMap<>();
          bookingGroup.put("bookingGroupId", rs.getInt("booking_group_id"));
          bookingGroup.put("customerId", rs.getInt("customer_id"));
          bookingGroup.put("bookingDate", rs.getDate("booking_date"));
          bookingGroup.put("totalAmount", rs.getBigDecimal("total_amount"));
          bookingGroup.put("paymentStatus", rs.getString("payment_status"));
          bookingGroup.put("bookingStatus", rs.getString("booking_status"));
          bookingGroup.put("specialNotes", rs.getString("special_notes"));
          result.put("bookingGroup", bookingGroup);
        }
      }
    } catch (SQLException e) {
      System.err.println("Error finding appointment with details: " + e.getMessage());
    }

    return result;
  }

  /**
   * Find booking group with all appointments for a customer
   */
  public List<Map<String, Object>> findBookingGroupsWithAppointments(int customerId) {
    List<Map<String, Object>> results = new ArrayList<>();
    String sql = "SELECT bg.*, ba.appointment_id, ba.service_id, ba.therapist_user_id, ba.start_time, ba.end_time, "
        + "ba.service_price, ba.status as appointment_status, ba.service_notes, "
        + "s.name as service_name, u.full_name as therapist_name "
        + "FROM booking_groups bg "
        + "LEFT JOIN booking_appointments ba ON bg.booking_group_id = ba.booking_group_id "
        + "LEFT JOIN services s ON ba.service_id = s.service_id "
        + "LEFT JOIN users u ON ba.therapist_user_id = u.user_id "
        + "WHERE bg.customer_id = ? "
        + "ORDER BY bg.booking_date DESC, bg.booking_group_id DESC, ba.start_time ASC";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, customerId);
      try (ResultSet rs = stmt.executeQuery()) {
        Map<Integer, Map<String, Object>> bookingGroups = new HashMap<>();

        while (rs.next()) {
          int bookingGroupId = rs.getInt("booking_group_id");

          // Create or get booking group
          Map<String, Object> bookingGroup = bookingGroups.get(bookingGroupId);
          if (bookingGroup == null) {
            bookingGroup = new HashMap<>();
            bookingGroup.put("bookingGroupId", bookingGroupId);
            bookingGroup.put("customerId", rs.getInt("customer_id"));
            bookingGroup.put("bookingDate", rs.getDate("booking_date"));
            bookingGroup.put("totalAmount", rs.getBigDecimal("total_amount"));
            bookingGroup.put("paymentStatus", rs.getString("payment_status"));
            bookingGroup.put("bookingStatus", rs.getString("booking_status"));
            bookingGroup.put("paymentMethod", rs.getString("payment_method"));
            bookingGroup.put("specialNotes", rs.getString("special_notes"));
            bookingGroup.put("createdAt", rs.getTimestamp("created_at"));
            bookingGroup.put("updatedAt", rs.getTimestamp("updated_at"));
            bookingGroup.put("appointments", new ArrayList<>());
            bookingGroups.put(bookingGroupId, bookingGroup);
          }

          // Add appointment if exists
          if (rs.getInt("appointment_id") > 0) {
            Map<String, Object> appointment = new HashMap<>();
            appointment.put("appointmentId", rs.getInt("appointment_id"));
            appointment.put("serviceId", rs.getInt("service_id"));
            appointment.put("therapistUserId", rs.getInt("therapist_user_id"));
            appointment.put("startTime", rs.getTimestamp("start_time"));
            appointment.put("endTime", rs.getTimestamp("end_time"));
            appointment.put("servicePrice", rs.getBigDecimal("service_price"));
            appointment.put("status", rs.getString("appointment_status"));
            appointment.put("serviceNotes", rs.getString("service_notes"));
            appointment.put("serviceName", rs.getString("service_name"));
            appointment.put("therapistName", rs.getString("therapist_name"));

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> appointments = (List<Map<String, Object>>) bookingGroup.get("appointments");
            appointments.add(appointment);
          }
        }

        results.addAll(bookingGroups.values());
      }
    } catch (SQLException e) {
      System.err.println("Error finding booking groups with appointments: " + e.getMessage());
    }

    return results;
  }

  /**
   * PERFORMANCE OPTIMIZATION: Bulk load all appointments for multiple therapists
   * within a date range
   * This replaces hundreds of individual database queries with a single bulk
   * query
   * 
   * @param therapistIds List of therapist user IDs to load appointments for
   * @param startDate    Start date for the range (inclusive)
   * @param endDate      End date for the range (exclusive)
   * @return Map of therapist ID to their appointments in the date range
   */
  public Map<Integer, List<BookingAppointment>> findByTherapistIdsAndDateRange(
      List<Integer> therapistIds, LocalDate startDate, LocalDate endDate) {

    Map<Integer, List<BookingAppointment>> result = new HashMap<>();

    if (therapistIds == null || therapistIds.isEmpty()) {
      return result;
    }

    // Create placeholders for IN clause
    String placeholders = therapistIds.stream()
        .map(id -> "?")
        .collect(Collectors.joining(","));

    String sql = "SELECT appointment_id, booking_group_id, service_id, therapist_user_id, " +
        "start_time, end_time, service_price, status, service_notes, created_at, updated_at " +
        "FROM booking_appointments " +
        "WHERE therapist_user_id IN (" + placeholders + ") " +
        "AND status IN ('SCHEDULED', 'IN_PROGRESS') " +
        "AND start_time >= ? " +
        "AND start_time < ? " +
        "ORDER BY therapist_user_id, start_time";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      // Set therapist IDs
      int paramIndex = 1;
      for (Integer therapistId : therapistIds) {
        stmt.setInt(paramIndex++, therapistId);
      }

      // Set date range
      stmt.setObject(paramIndex++, startDate.atStartOfDay());
      stmt.setObject(paramIndex, endDate.plusDays(1).atStartOfDay());

      System.out.println("🔍 BULK LOAD: Loading appointments for " + therapistIds.size() +
          " therapists from " + startDate + " to " + endDate);

      try (ResultSet rs = stmt.executeQuery()) {
        int appointmentCount = 0;
        while (rs.next()) {
          BookingAppointment appointment = getFromResultSet(rs);
          int therapistId = appointment.getTherapistUserId();

          result.computeIfAbsent(therapistId, k -> new ArrayList<>()).add(appointment);
          appointmentCount++;
        }

        System.out.println("✅ BULK LOAD: Loaded " + appointmentCount +
            " appointments for " + result.size() + " therapists");
      }

    } catch (SQLException e) {
      System.err.println("❌ Error bulk loading therapist appointments: " + e.getMessage());
      e.printStackTrace();
    }

    return result;
  }

  /**
   * PERFORMANCE OPTIMIZATION: Bulk load appointments for a single therapist over
   * extended period
   * Used when we need all appointments for one therapist across many months
   * 
   * @param therapistId Therapist user ID
   * @param startDate   Start date for the range (inclusive)
   * @param endDate     End date for the range (exclusive)
   * @return List of appointments for the therapist in the date range
   */
  public List<BookingAppointment> findByTherapistAndDateRange(int therapistId, LocalDate startDate, LocalDate endDate) {
    List<BookingAppointment> appointments = new ArrayList<>();

    String sql = "SELECT appointment_id, booking_group_id, service_id, therapist_user_id, " +
        "start_time, end_time, service_price, status, service_notes, created_at, updated_at " +
        "FROM booking_appointments " +
        "WHERE therapist_user_id = ? " +
        "AND status IN ('SCHEDULED', 'IN_PROGRESS') " +
        "AND start_time >= ? " +
        "AND start_time < ? " +
        "ORDER BY start_time";

    try (Connection conn = DBContext.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setInt(1, therapistId);
      stmt.setObject(2, startDate.atStartOfDay());
      stmt.setObject(3, endDate.plusDays(1).atStartOfDay());

      try (ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
          appointments.add(getFromResultSet(rs));
        }
      }

    } catch (SQLException e) {
      System.err.println("Error loading therapist appointments by date range: " + e.getMessage());
    }

    return appointments;
  }
}