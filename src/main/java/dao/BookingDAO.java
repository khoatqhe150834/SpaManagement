package dao;

import booking.*;
import db.DBContext;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Types;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Booking;
import model.Customer;
import model.Service;
import model.User;

/**
 * Data Access Object for Booking entity
 * Handles CRUD operations for service bookings linked to paid services
 * 
 * @author SpaManagement
 */
public class BookingDAO implements BaseDAO<Booking, Integer> {
    
    private static final Logger LOGGER = Logger.getLogger(BookingDAO.class.getName());
    
    @Override
    public <S extends Booking> S save(S booking) throws SQLException {
        String sql = "INSERT INTO bookings (customer_id, payment_item_id, service_id, therapist_user_id, " +
                    "appointment_date, appointment_time, duration_minutes, booking_status, booking_notes, " +
                    "room_id, bed_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, booking.getCustomerId());
            stmt.setInt(2, booking.getPaymentItemId());
            stmt.setInt(3, booking.getServiceId());
            stmt.setInt(4, booking.getTherapistUserId());
            stmt.setDate(5, booking.getAppointmentDate());
            stmt.setTime(6, booking.getAppointmentTime());
            stmt.setInt(7, booking.getDurationMinutes());
            stmt.setString(8, booking.getBookingStatus().name());
            stmt.setString(9, booking.getBookingNotes());
            stmt.setInt(10, booking.getRoomId());
            if (booking.getBedId() != null) {
                stmt.setInt(11, booking.getBedId());
            } else {
                stmt.setNull(11, Types.INTEGER);
            }
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating booking failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    booking.setBookingId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating booking failed, no ID obtained.");
                }
            }
            
            LOGGER.log(Level.INFO, "Booking saved successfully with ID: {0}", booking.getBookingId());
            return booking;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error saving booking", ex);
            throw ex;
        }
    }
    
    @Override
    public Optional<Booking> findById(Integer id) throws SQLException {
        String sql = "SELECT b.*, c.full_name as customer_name, c.email as customer_email, " +
                    "s.name as service_name, u.full_name as therapist_name " +
                    "FROM bookings b " +
                    "LEFT JOIN customers c ON b.customer_id = c.customer_id " +
                    "LEFT JOIN services s ON b.service_id = s.service_id " +
                    "LEFT JOIN users u ON b.therapist_user_id = u.user_id " +
                    "WHERE b.booking_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToBooking(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding booking by ID: " + id, ex);
            throw ex;
        }
        
        return Optional.empty();
    }
    
    @Override
    public List<Booking> findAll() throws SQLException {
        return findAll(1, 50); // Default pagination
    }
    
    @Override
    public List<Booking> findAll(int page, int pageSize) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name as customer_name, c.email as customer_email, " +
                    "s.name as service_name, u.full_name as therapist_name " +
                    "FROM bookings b " +
                    "LEFT JOIN customers c ON b.customer_id = c.customer_id " +
                    "LEFT JOIN services s ON b.service_id = s.service_id " +
                    "LEFT JOIN users u ON b.therapist_user_id = u.user_id " +
                    "ORDER BY b.appointment_date DESC, b.appointment_time DESC " +
                    "LIMIT ? OFFSET ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, pageSize);
            stmt.setInt(2, (page - 1) * pageSize);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding all bookings", ex);
            throw ex;
        }
        
        return bookings;
    }
    
    @Override
    public <S extends Booking> S update(S booking) throws SQLException {
        String sql = "UPDATE bookings SET customer_id = ?, payment_item_id = ?, service_id = ?, " +
                    "therapist_user_id = ?, appointment_date = ?, appointment_time = ?, " +
                    "duration_minutes = ?, booking_status = ?, booking_notes = ?, " +
                    "cancellation_reason = ?, cancelled_at = ?, cancelled_by = ?, " +
                    "room_id = ?, bed_id = ?, updated_at = CURRENT_TIMESTAMP WHERE booking_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, booking.getCustomerId());
            stmt.setInt(2, booking.getPaymentItemId());
            stmt.setInt(3, booking.getServiceId());
            stmt.setInt(4, booking.getTherapistUserId());
            stmt.setDate(5, booking.getAppointmentDate());
            stmt.setTime(6, booking.getAppointmentTime());
            stmt.setInt(7, booking.getDurationMinutes());
            stmt.setString(8, booking.getBookingStatus().name());
            stmt.setString(9, booking.getBookingNotes());
            stmt.setString(10, booking.getCancellationReason());
            stmt.setTimestamp(11, booking.getCancelledAt());
            if (booking.getCancelledBy() != null) {
                stmt.setInt(12, booking.getCancelledBy());
            } else {
                stmt.setNull(12, Types.INTEGER);
            }
            stmt.setInt(13, booking.getRoomId());
            if (booking.getBedId() != null) {
                stmt.setInt(14, booking.getBedId());
            } else {
                stmt.setNull(14, Types.INTEGER);
            }
            stmt.setInt(15, booking.getBookingId());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating booking failed, no rows affected.");
            }
            
            LOGGER.log(Level.INFO, "Booking updated successfully with ID: {0}", booking.getBookingId());
            return booking;
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating booking", ex);
            throw ex;
        }
    }
    
    @Override
    public void deleteById(Integer id) throws SQLException {
        String sql = "DELETE FROM bookings WHERE booking_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Deleting booking failed, no rows affected.");
            }
            
            LOGGER.log(Level.INFO, "Booking deleted successfully with ID: {0}", id);
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting booking by ID: " + id, ex);
            throw ex;
        }
    }
    
    @Override
    public void delete(Booking booking) throws SQLException {
        deleteById(booking.getBookingId());
    }
    
    @Override
    public boolean existsById(Integer id) throws SQLException {
        String sql = "SELECT 1 FROM bookings WHERE booking_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking booking existence by ID: " + id, ex);
            throw ex;
        }
    }
    
    @Override
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error counting bookings", ex);
            throw ex;
        }
        
        return 0;
    }

    // Business logic methods

    /**
     * Find bookings by customer ID
     */
    public List<Booking> findByCustomerId(Integer customerId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name as customer_name, c.email as customer_email, " +
                    "s.name as service_name, u.full_name as therapist_name " +
                    "FROM bookings b " +
                    "LEFT JOIN customers c ON b.customer_id = c.customer_id " +
                    "LEFT JOIN services s ON b.service_id = s.service_id " +
                    "LEFT JOIN users u ON b.therapist_user_id = u.user_id " +
                    "WHERE b.customer_id = ? " +
                    "ORDER BY b.appointment_date DESC, b.appointment_time DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding bookings by customer ID: " + customerId, ex);
            throw ex;
        }

        return bookings;
    }

    /**
     * Find bookings by therapist ID
     */
    public List<Booking> findByTherapistId(Integer therapistId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name as customer_name, c.email as customer_email, " +
                    "s.name as service_name, u.full_name as therapist_name " +
                    "FROM bookings b " +
                    "LEFT JOIN customers c ON b.customer_id = c.customer_id " +
                    "LEFT JOIN services s ON b.service_id = s.service_id " +
                    "LEFT JOIN users u ON b.therapist_user_id = u.user_id " +
                    "WHERE b.therapist_user_id = ? " +
                    "ORDER BY b.appointment_date ASC, b.appointment_time ASC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, therapistId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding bookings by therapist ID: " + therapistId, ex);
            throw ex;
        }

        return bookings;
    }

    /**
     * Find bookings by date
     */
    public List<Booking> findByDate(LocalDate date) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name as customer_name, c.email as customer_email, " +
                    "s.name as service_name, u.full_name as therapist_name " +
                    "FROM bookings b " +
                    "LEFT JOIN customers c ON b.customer_id = c.customer_id " +
                    "LEFT JOIN services s ON b.service_id = s.service_id " +
                    "LEFT JOIN users u ON b.therapist_user_id = u.user_id " +
                    "WHERE b.appointment_date = ? " +
                    "ORDER BY b.appointment_time ASC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, java.sql.Date.valueOf(date));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding bookings by date: " + date, ex);
            throw ex;
        }

        return bookings;
    }

    /**
     * Find bookings by customer ID and date
     */
    public List<Booking> findByCustomerAndDate(Integer customerId, LocalDate date) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name as customer_name, c.email as customer_email, " +
                    "s.name as service_name, u.full_name as therapist_name " +
                    "FROM bookings b " +
                    "LEFT JOIN customers c ON b.customer_id = c.customer_id " +
                    "LEFT JOIN services s ON b.service_id = s.service_id " +
                    "LEFT JOIN users u ON b.therapist_user_id = u.user_id " +
                    "WHERE b.customer_id = ? AND b.appointment_date = ? " +
                    "ORDER BY b.appointment_time ASC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            stmt.setDate(2, java.sql.Date.valueOf(date));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding bookings by customer and date: " + customerId + ", " + date, ex);
            throw ex;
        }

        return bookings;
    }

    /**
     * Find bookings by status
     */
    public List<Booking> findByStatus(Booking.BookingStatus status) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name as customer_name, c.email as customer_email, " +
                    "s.name as service_name, u.full_name as therapist_name " +
                    "FROM bookings b " +
                    "LEFT JOIN customers c ON b.customer_id = c.customer_id " +
                    "LEFT JOIN services s ON b.service_id = s.service_id " +
                    "LEFT JOIN users u ON b.therapist_user_id = u.user_id " +
                    "WHERE b.booking_status = ? " +
                    "ORDER BY b.appointment_date ASC, b.appointment_time ASC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status.name());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding bookings by status: " + status, ex);
            throw ex;
        }

        return bookings;
    }

    /**
     * Find bookings by payment item ID
     */
    public List<Booking> findByPaymentItemId(Integer paymentItemId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, c.full_name as customer_name, c.email as customer_email, " +
                    "s.name as service_name, u.full_name as therapist_name " +
                    "FROM bookings b " +
                    "LEFT JOIN customers c ON b.customer_id = c.customer_id " +
                    "LEFT JOIN services s ON b.service_id = s.service_id " +
                    "LEFT JOIN users u ON b.therapist_user_id = u.user_id " +
                    "WHERE b.payment_item_id = ? " +
                    "ORDER BY b.appointment_date ASC, b.appointment_time ASC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, paymentItemId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding bookings by payment item ID: " + paymentItemId, ex);
            throw ex;
        }

        return bookings;
    }

    /**
     * Cancel a booking
     */
    public boolean cancelBooking(Integer bookingId, String reason, Integer cancelledByUserId) throws SQLException {
        String sql = "UPDATE bookings SET booking_status = 'CANCELLED', cancellation_reason = ?, " +
                    "cancelled_at = CURRENT_TIMESTAMP, cancelled_by = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE booking_id = ? AND booking_status IN ('SCHEDULED', 'CONFIRMED')";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, reason);
            stmt.setInt(2, cancelledByUserId);
            stmt.setInt(3, bookingId);

            int affectedRows = stmt.executeUpdate();
            boolean success = affectedRows > 0;

            if (success) {
                LOGGER.log(Level.INFO, "Booking cancelled successfully with ID: {0}", bookingId);
            } else {
                LOGGER.log(Level.WARNING, "Could not cancel booking - may already be cancelled or completed: {0}", bookingId);
            }

            return success;

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error cancelling booking ID: " + bookingId, ex);
            throw ex;
        }
    }

    /**
     * Update booking status
     */
    public boolean updateBookingStatus(Integer bookingId, Booking.BookingStatus status) throws SQLException {
        String sql = "UPDATE bookings SET booking_status = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE booking_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status.name());
            stmt.setInt(2, bookingId);

            int affectedRows = stmt.executeUpdate();
            boolean success = affectedRows > 0;

            if (success) {
                LOGGER.log(Level.INFO, "Booking status updated to {0} for ID: {1}",
                          new Object[]{status, bookingId});
            }

            return success;

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating booking status", ex);
            throw ex;
        }
    }

    /**
     * Check if therapist is available at specific time
     */
    public boolean isTherapistAvailable(Integer therapistId, java.sql.Date appointmentDate,
                                       Time appointmentTime, Integer durationMinutes) throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings " +
                    "WHERE therapist_user_id = ? AND appointment_date = ? " +
                    "AND booking_status NOT IN ('CANCELLED', 'NO_SHOW') " +
                    "AND ((appointment_time <= ? AND ADDTIME(appointment_time, SEC_TO_TIME(duration_minutes * 60)) > ?) " +
                    "OR (appointment_time < ADDTIME(?, SEC_TO_TIME(? * 60)) AND appointment_time >= ?))";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, therapistId);
            stmt.setDate(2, appointmentDate);
            stmt.setTime(3, appointmentTime);
            stmt.setTime(4, appointmentTime);
            stmt.setTime(5, appointmentTime);
            stmt.setInt(6, durationMinutes);
            stmt.setTime(7, appointmentTime);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0; // Available if no conflicts
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking therapist availability", ex);
            throw ex;
        }

        return false;
    }

    /**
     * Get booking statistics
     */
    public Map<String, Object> getBookingStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        String sql = "SELECT " +
                    "COUNT(*) as total_bookings, " +
                    "COUNT(CASE WHEN booking_status = 'SCHEDULED' THEN 1 END) as scheduled_bookings, " +
                    "COUNT(CASE WHEN booking_status = 'CONFIRMED' THEN 1 END) as confirmed_bookings, " +
                    "COUNT(CASE WHEN booking_status = 'IN_PROGRESS' THEN 1 END) as in_progress_bookings, " +
                    "COUNT(CASE WHEN booking_status = 'COMPLETED' THEN 1 END) as completed_bookings, " +
                    "COUNT(CASE WHEN booking_status = 'CANCELLED' THEN 1 END) as cancelled_bookings, " +
                    "COUNT(CASE WHEN booking_status = 'NO_SHOW' THEN 1 END) as no_show_bookings " +
                    "FROM bookings";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                stats.put("totalBookings", rs.getInt("total_bookings"));
                stats.put("scheduledBookings", rs.getInt("scheduled_bookings"));
                stats.put("confirmedBookings", rs.getInt("confirmed_bookings"));
                stats.put("inProgressBookings", rs.getInt("in_progress_bookings"));
                stats.put("completedBookings", rs.getInt("completed_bookings"));
                stats.put("cancelledBookings", rs.getInt("cancelled_bookings"));
                stats.put("noShowBookings", rs.getInt("no_show_bookings"));
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting booking statistics", ex);
            throw ex;
        }

        return stats;
    }

    /**
     * Map ResultSet to Booking object
     */
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();

        booking.setBookingId(rs.getInt("booking_id"));
        booking.setCustomerId(rs.getInt("customer_id"));
        booking.setPaymentItemId(rs.getInt("payment_item_id"));
        booking.setServiceId(rs.getInt("service_id"));
        booking.setTherapistUserId(rs.getInt("therapist_user_id"));
        booking.setAppointmentDate(rs.getDate("appointment_date"));
        booking.setAppointmentTime(rs.getTime("appointment_time"));
        booking.setDurationMinutes(rs.getInt("duration_minutes"));
        booking.setBookingStatus(Booking.BookingStatus.valueOf(rs.getString("booking_status")));
        booking.setBookingNotes(rs.getString("booking_notes"));
        booking.setCancellationReason(rs.getString("cancellation_reason"));
        booking.setCancelledAt(rs.getTimestamp("cancelled_at"));

        Integer cancelledBy = rs.getInt("cancelled_by");
        if (!rs.wasNull()) {
            booking.setCancelledBy(cancelledBy);
        }

        booking.setCreatedAt(rs.getTimestamp("created_at"));
        booking.setUpdatedAt(rs.getTimestamp("updated_at"));

        // Map room and bed IDs
        booking.setRoomId(rs.getInt("room_id"));
        Integer bedId = rs.getInt("bed_id");
        if (!rs.wasNull()) {
            booking.setBedId(bedId);
        }

        // Map related entities if available
        String customerName = rs.getString("customer_name");
        if (customerName != null) {
            Customer customer = new Customer();
            customer.setCustomerId(booking.getCustomerId());
            customer.setFullName(customerName);
            customer.setEmail(rs.getString("customer_email"));
            booking.setCustomer(customer);
        }

        String serviceName = rs.getString("service_name");
        if (serviceName != null) {
            Service service = new Service();
            service.setServiceId(booking.getServiceId());
            service.setName(serviceName);
            booking.setService(service);
        }

        String therapistName = rs.getString("therapist_name");
        if (therapistName != null) {
            User therapist = new User();
            therapist.setUserId(booking.getTherapistUserId());
            therapist.setFullName(therapistName);
            booking.setTherapist(therapist);
        }

        return booking;
    }

    /**
     * Find bookings by customer ID with filters and pagination
     */
    public List<Booking> findByCustomerIdWithFilters(Integer customerId, String statusFilter,
            Date dateFrom, Date dateTo, int page, int pageSize) throws SQLException {
        List<Booking> bookings = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT b.*, c.full_name as customer_name, c.email as customer_email, ");
        sql.append("s.name as service_name, u.full_name as therapist_name ");
        sql.append("FROM bookings b ");
        sql.append("LEFT JOIN customers c ON b.customer_id = c.customer_id ");
        sql.append("LEFT JOIN services s ON b.service_id = s.service_id ");
        sql.append("LEFT JOIN users u ON b.therapist_user_id = u.user_id ");
        sql.append("WHERE b.customer_id = ? ");

        List<Object> params = new ArrayList<>();
        params.add(customerId);

        // Add status filter
        if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("ALL")) {
            sql.append("AND b.booking_status = ? ");
            params.add(statusFilter);
        }

        // Add date range filter
        if (dateFrom != null) {
            sql.append("AND b.appointment_date >= ? ");
            params.add(dateFrom);
        }

        if (dateTo != null) {
            sql.append("AND b.appointment_date <= ? ");
            params.add(dateTo);
        }

        sql.append("ORDER BY b.appointment_date DESC, b.appointment_time DESC ");
        sql.append("LIMIT ? OFFSET ?");

        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Booking booking = mapResultSetToBooking(rs);
                    bookings.add(booking);
                }
            }
        }

        return bookings;
    }

    /**
     * Count bookings by customer ID with filters
     */
    public int countByCustomerIdWithFilters(Integer customerId, String statusFilter,
            Date dateFrom, Date dateTo) throws SQLException {

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM bookings b WHERE b.customer_id = ? ");

        List<Object> params = new ArrayList<>();
        params.add(customerId);

        // Add status filter
        if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("ALL")) {
            sql.append("AND b.booking_status = ? ");
            params.add(statusFilter);
        }

        // Add date range filter
        if (dateFrom != null) {
            sql.append("AND b.appointment_date >= ? ");
            params.add(dateFrom);
        }

        if (dateTo != null) {
            sql.append("AND b.appointment_date <= ? ");
            params.add(dateTo);
        }

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    /**
     * Get booking statistics by customer ID
     */
    public Map<String, Integer> getBookingStatsByCustomerId(Integer customerId) throws SQLException {
        Map<String, Integer> stats = new HashMap<>();

        String sql = "SELECT " +
                    "COUNT(*) as total_bookings, " +
                    "COUNT(CASE WHEN booking_status = 'SCHEDULED' THEN 1 END) as scheduled_count, " +
                    "COUNT(CASE WHEN booking_status = 'COMPLETED' THEN 1 END) as completed_count, " +
                    "COUNT(CASE WHEN booking_status = 'CANCELLED' THEN 1 END) as cancelled_count, " +
                    "COUNT(CASE WHEN booking_status = 'NO_SHOW' THEN 1 END) as no_show_count " +
                    "FROM bookings WHERE customer_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("total_bookings", rs.getInt("total_bookings"));
                    stats.put("scheduled_count", rs.getInt("scheduled_count"));
                    stats.put("completed_count", rs.getInt("completed_count"));
                    stats.put("cancelled_count", rs.getInt("cancelled_count"));
                    stats.put("no_show_count", rs.getInt("no_show_count"));
                }
            }
        }

        return stats;
    }

    /**
     * Find bookings by therapist and date
     */
    public List<Booking> findByTherapistAndDate(int therapistId, Date appointmentDate) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE therapist_user_id = ? AND appointment_date = ? " +
                    "ORDER BY appointment_time";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, therapistId);
            stmt.setDate(2, appointmentDate);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding bookings by therapist and date", ex);
            throw ex;
        }

        return bookings;
    }




    public PaymentItemDetails getPaymentItemForBooking(int paymentItemId) throws SQLException {
        String query = """
            SELECT pi.payment_item_id, pi.payment_id, pi.service_id, s.name as service_name,
                   pi.quantity, pi.unit_price, pi.total_price, pi.service_duration,
                   COALESCE(s.buffer_time_after_minutes, 15) as buffer_time,
                   COALESCE(piu.booked_quantity, 0) as booked_quantity
            FROM payment_items pi
            JOIN services s ON pi.service_id = s.service_id
            LEFT JOIN payment_item_usage piu ON pi.payment_item_id = piu.payment_item_id
            WHERE pi.payment_item_id = ? AND s.is_active = 1
            """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, paymentItemId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new PaymentItemDetails(
                        rs.getInt("payment_item_id"),
                        rs.getInt("payment_id"),
                        rs.getInt("service_id"),
                        rs.getString("service_name"),
                        rs.getInt("quantity"),
                        rs.getInt("booked_quantity"),
                        rs.getDouble("unit_price"),
                        rs.getDouble("total_price"),
                        rs.getInt("service_duration"),
                        rs.getInt("buffer_time")
                    );
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading payment item details: " + paymentItemId, e);
            throw e;
        }
        
        return null;
    }
    
    /**
     * Get customer ID from payment item
     */
    public int getCustomerIdFromPaymentItem(int paymentItemId) throws SQLException {
        String query = """
            SELECT p.customer_id 
            FROM payment_items pi 
            JOIN payments p ON pi.payment_id = p.payment_id 
            WHERE pi.payment_item_id = ?
            """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, paymentItemId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("customer_id");
                }
            }
        }
        
        throw new SQLException("Customer not found for payment item: " + paymentItemId);
    }
    
    /**
     * Check if a customer has conflicting bookings at the specified time
     */
    public boolean hasCustomerTimeConflict(int customerId, LocalDate appointmentDate,
                                         LocalTime appointmentTime, int durationMinutes) throws SQLException {
        String query = """
            SELECT booking_id, appointment_time, duration_minutes
            FROM bookings
            WHERE customer_id = ?
            AND appointment_date = ?
            AND booking_status IN ('SCHEDULED', 'CONFIRMED', 'IN_PROGRESS')
            """;

        LocalTime newEndTime = appointmentTime.plusMinutes(durationMinutes);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, customerId);
            pstmt.setDate(2, Date.valueOf(appointmentDate));

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    LocalTime existingStartTime = rs.getTime("appointment_time").toLocalTime();
                    int existingDuration = rs.getInt("duration_minutes");
                    LocalTime existingEndTime = existingStartTime.plusMinutes(existingDuration);

                    // Check for time overlap: new appointment overlaps with existing appointment
                    boolean overlaps = (appointmentTime.isBefore(existingEndTime) && newEndTime.isAfter(existingStartTime));

                    if (overlaps) {
                        LOGGER.info("Customer " + customerId + " has conflicting booking at " +
                                   appointmentDate + " " + existingStartTime + "-" + existingEndTime +
                                   " (conflicts with requested " + appointmentTime + "-" + newEndTime + ")");
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking customer time conflict", e);
            throw e;
        }

        return false;
    }

    /**
     * Create a booking
     */
    public int createBooking(int customerId, int paymentItemId, int serviceId, int therapistId,
                           int roomId, Integer bedId, LocalDate appointmentDate,
                           LocalTime appointmentTime, int durationMinutes) throws SQLException {

        // Check for customer time conflicts before creating the booking
        if (hasCustomerTimeConflict(customerId, appointmentDate, appointmentTime, durationMinutes)) {
            throw new SQLException("Customer already has a booking at the same time. " +
                                 "A customer cannot book multiple services simultaneously.");
        }

        String query = """
            INSERT INTO bookings (customer_id, payment_item_id, service_id, therapist_user_id,
                                room_id, bed_id, appointment_date, appointment_time,
                                duration_minutes, booking_status, booking_notes, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'SCHEDULED', 'Booked via online system', NOW(), NOW())
            """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, customerId);
            pstmt.setInt(2, paymentItemId);
            pstmt.setInt(3, serviceId);
            pstmt.setInt(4, therapistId);
            pstmt.setInt(5, roomId);
            if (bedId != null) {
                pstmt.setInt(6, bedId);
            } else {
                pstmt.setNull(6, Types.INTEGER);
            }
            pstmt.setDate(7, Date.valueOf(appointmentDate));
            pstmt.setTime(8, Time.valueOf(appointmentTime));
            pstmt.setInt(9, durationMinutes);
            
            pstmt.executeUpdate();
            
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    int bookingId = rs.getInt(1);
                    
                    // Update payment item usage
                    updatePaymentItemUsage(paymentItemId);
                    
                    LOGGER.info("Created booking ID: " + bookingId + " for payment item: " + paymentItemId);
                    return bookingId;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating booking", e);
            throw e;
        }
        
        throw new SQLException("Failed to create booking");
    }
    
    /**
     * Update payment item usage after booking
     */
    private void updatePaymentItemUsage(int paymentItemId) throws SQLException {
        String query = """
            INSERT INTO payment_item_usage (payment_item_id, total_quantity, booked_quantity)
            SELECT pi.payment_item_id, pi.quantity, 1
            FROM payment_items pi
            WHERE pi.payment_item_id = ?
            ON DUPLICATE KEY UPDATE booked_quantity = booked_quantity + 1
            """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, paymentItemId);
            pstmt.executeUpdate();
            
            LOGGER.info("Updated usage for payment item: " + paymentItemId);
        }
    }
    
    /**
     * Get available payment items for a customer
     */
    public List<PaymentItemDetails> getAvailablePaymentItems(int customerId) throws SQLException {
        String query = """
            SELECT pi.payment_item_id, pi.payment_id, pi.service_id, s.name as service_name,
                   pi.quantity, pi.unit_price, pi.total_price, pi.service_duration,
                   COALESCE(s.buffer_time_after_minutes, 15) as buffer_time,
                   COALESCE(piu.booked_quantity, 0) as booked_quantity
            FROM payment_items pi
            JOIN payments p ON pi.payment_id = p.payment_id
            JOIN services s ON pi.service_id = s.service_id
            LEFT JOIN payment_item_usage piu ON pi.payment_item_id = piu.payment_item_id
            WHERE p.customer_id = ? AND p.payment_status = 'PAID' AND s.is_active = 1
            AND (piu.booked_quantity IS NULL OR piu.booked_quantity < pi.quantity)
            ORDER BY pi.created_at DESC, s.name
            """;
        
        List<PaymentItemDetails> items = new ArrayList<>();
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, customerId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    PaymentItemDetails item = new PaymentItemDetails(
                        rs.getInt("payment_item_id"),
                        rs.getInt("payment_id"),
                        rs.getInt("service_id"),
                        rs.getString("service_name"),
                        rs.getInt("quantity"),
                        rs.getInt("booked_quantity"),
                        rs.getDouble("unit_price"),
                        rs.getDouble("total_price"),
                        rs.getInt("service_duration"),
                        rs.getInt("buffer_time")
                    );
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading available payment items for customer: " + customerId, e);
            throw e;
        }
        
        return items;
    }



    // BookingDAO.java - Add these methods to your existing BookingDAO class

/**
 * Get bookings for customer dashboard view
 */

public List<BookingCustomerView> findBookingsForCustomer(Integer customerId) throws SQLException {
    String sql = "SELECT b.booking_id, b.appointment_date, b.appointment_time, b.duration_minutes, " +
                "b.booking_status, b.booking_notes, b.created_at, " +
                "s.name as service_name, s.price as service_price, " +
                "u.full_name as therapist_name, " +
                "r.name as room_name, " +
                "p.payment_status, p.total_amount, p.reference_number " +
                "FROM bookings b " +
                "JOIN services s ON b.service_id = s.service_id " +
                "JOIN users u ON b.therapist_user_id = u.user_id " +
                "JOIN rooms r ON b.room_id = r.room_id " +
                "JOIN payment_items pi ON b.payment_item_id = pi.payment_item_id " +
                "JOIN payments p ON pi.payment_id = p.payment_id " +
                "WHERE b.customer_id = ? " +
                "ORDER BY b.appointment_date DESC, b.appointment_time DESC";
    
    List<BookingCustomerView> bookings = new ArrayList<>();
    
    try (Connection conn = DBContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, customerId);
        
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                BookingCustomerView booking = mapResultSetToCustomerView(rs);
                bookings.add(booking);
            }
        }
        
    } catch (SQLException ex) {
        LOGGER.log(Level.SEVERE, "Error finding bookings for customer: " + customerId, ex);
        throw ex;
    }
    
    return bookings;
}

/**
 * Get bookings for therapist dashboard view
 */

public List<BookingTherapistView> findBookingsForTherapist(Integer therapistId, LocalDate date) throws SQLException {
    String sql = "SELECT b.booking_id, b.appointment_date, b.appointment_time, b.duration_minutes, " +
                "b.booking_status, b.booking_notes, " +
                "s.name as service_name, s.duration_minutes as service_duration, " +
                "c.full_name as customer_name, c.phone_number as customer_phone, " +
                "c.email as customer_email, " +
                "r.name as room_name, " +
                "bed.name as bed_name " +
                "FROM bookings b " +
                "JOIN services s ON b.service_id = s.service_id " +
                "JOIN customers c ON b.customer_id = c.customer_id " +
                "JOIN rooms r ON b.room_id = r.room_id " +
                "LEFT JOIN beds bed ON b.bed_id = bed.bed_id " +
                "WHERE b.therapist_user_id = ? ";
    
    if (date != null) {
        sql += "AND DATE(b.appointment_date) = ? ";
    }
    
    sql += "ORDER BY b.appointment_date ASC, b.appointment_time ASC";
    
    List<BookingTherapistView> bookings = new ArrayList<>();
    
    try (Connection conn = DBContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, therapistId);
        if (date != null) {
            stmt.setDate(2, Date.valueOf(date));
        }
        
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                BookingTherapistView booking = mapResultSetToTherapistView(rs);
                bookings.add(booking);
            }
        }
        
    } catch (SQLException ex) {
        LOGGER.log(Level.SEVERE, "Error finding bookings for therapist: " + therapistId, ex);
        throw ex;
    }
    
    return bookings;
}

/**
 * Get bookings for manager dashboard view with filters
 */

public List<BookingManagerView> findBookingsForManager(BookingManagerFilter filter) throws SQLException {
    StringBuilder sql = new StringBuilder();
    sql.append("SELECT b.booking_id, b.appointment_date, b.appointment_time, b.duration_minutes, ")
       .append("b.booking_status, b.booking_notes, b.created_at, ")
       .append("s.name as service_name, s.price as service_price, ")
       .append("c.full_name as customer_name, c.phone_number as customer_phone, ")
       .append("c.email as customer_email, ")
       .append("u.full_name as therapist_name, ")
       .append("r.name as room_name, ")
       .append("p.total_amount, p.payment_status, p.reference_number ")
       .append("FROM bookings b ")
       .append("JOIN services s ON b.service_id = s.service_id ")
       .append("JOIN customers c ON b.customer_id = c.customer_id ")
       .append("JOIN users u ON b.therapist_user_id = u.user_id ")
       .append("JOIN rooms r ON b.room_id = r.room_id ")
       .append("JOIN payment_items pi ON b.payment_item_id = pi.payment_item_id ")
       .append("JOIN payments p ON pi.payment_id = p.payment_id ")
       .append("WHERE 1=1 ");
    
    List<Object> parameters = new ArrayList<>();
    
    // Add filters
    if (filter.getStartDate() != null) {
        sql.append("AND b.appointment_date >= ? ");
        parameters.add(Date.valueOf(filter.getStartDate()));
    }
    
    if (filter.getEndDate() != null) {
        sql.append("AND b.appointment_date <= ? ");
        parameters.add(Date.valueOf(filter.getEndDate()));
    }
    
    if (filter.getTherapistId() != null) {
        sql.append("AND b.therapist_user_id = ? ");
        parameters.add(filter.getTherapistId());
    }
    
    if (filter.getBookingStatus() != null && !filter.getBookingStatus().isEmpty()) {
        sql.append("AND b.booking_status = ? ");
        parameters.add(filter.getBookingStatus());
    }
    
    if (filter.getServiceTypeId() != null) {
        sql.append("AND s.service_type_id = ? ");
        parameters.add(filter.getServiceTypeId());
    }
    
    sql.append("ORDER BY b.appointment_date DESC, b.appointment_time DESC ");
    
    // Add pagination
    if (filter.getLimit() != null && filter.getOffset() != null) {
        sql.append("LIMIT ? OFFSET ? ");
        parameters.add(filter.getLimit());
        parameters.add(filter.getOffset());
    }
    
    List<BookingManagerView> bookings = new ArrayList<>();
    
    try (Connection conn = DBContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
        
        // Set parameters
        for (int i = 0; i < parameters.size(); i++) {
            stmt.setObject(i + 1, parameters.get(i));
        }
        
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                BookingManagerView booking = mapResultSetToManagerView(rs);
                bookings.add(booking);
            }
        }
        
    } catch (SQLException ex) {
        LOGGER.log(Level.SEVERE, "Error finding bookings for manager with filter", ex);
        throw ex;
    }
    
    return bookings;
}

/**
 * Get total count for manager bookings (for pagination)
 */

public int countBookingsForManager(BookingManagerFilter filter) throws SQLException {
    StringBuilder sql = new StringBuilder();
    sql.append("SELECT COUNT(*) FROM bookings b ")
       .append("JOIN services s ON b.service_id = s.service_id ")
       .append("WHERE 1=1 ");
    
    List<Object> parameters = new ArrayList<>();
    
    // Add same filters as above (without ORDER BY and LIMIT)
    if (filter.getStartDate() != null) {
        sql.append("AND b.appointment_date >= ? ");
        parameters.add(Date.valueOf(filter.getStartDate()));
    }
    
    if (filter.getEndDate() != null) {
        sql.append("AND b.appointment_date <= ? ");
        parameters.add(Date.valueOf(filter.getEndDate()));
    }
    
    if (filter.getTherapistId() != null) {
        sql.append("AND b.therapist_user_id = ? ");
        parameters.add(filter.getTherapistId());
    }
    
    if (filter.getBookingStatus() != null && !filter.getBookingStatus().isEmpty()) {
        sql.append("AND b.booking_status = ? ");
        parameters.add(filter.getBookingStatus());
    }
    
    if (filter.getServiceTypeId() != null) {
        sql.append("AND s.service_type_id = ? ");
        parameters.add(filter.getServiceTypeId());
    }
    
    try (Connection conn = DBContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
        
        // Set parameters
        for (int i = 0; i < parameters.size(); i++) {
            stmt.setObject(i + 1, parameters.get(i));
        }
        
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        
    } catch (SQLException ex) {
        LOGGER.log(Level.SEVERE, "Error counting bookings for manager", ex);
        throw ex;
    }
    
    return 0;
}

// Helper methods to map ResultSet to view objects
private BookingCustomerView mapResultSetToCustomerView(ResultSet rs) throws SQLException {
    BookingCustomerView booking = new BookingCustomerView();
    booking.setBookingId(rs.getInt("booking_id"));
    booking.setAppointmentDate(rs.getDate("appointment_date").toLocalDate());
    booking.setAppointmentTime(rs.getTime("appointment_time").toLocalTime());
    booking.setDurationMinutes(rs.getInt("duration_minutes"));
    booking.setBookingStatus(rs.getString("booking_status"));
    booking.setBookingNotes(rs.getString("booking_notes"));
    booking.setServiceName(rs.getString("service_name"));
    booking.setServicePrice(rs.getBigDecimal("service_price"));
    booking.setTherapistName(rs.getString("therapist_name"));
    booking.setRoomName(rs.getString("room_name"));
    booking.setPaymentStatus(rs.getString("payment_status"));
    booking.setTotalAmount(rs.getBigDecimal("total_amount"));
    booking.setReferenceNumber(rs.getString("reference_number"));
    booking.setCreatedAt(rs.getTimestamp("created_at"));
    return booking;
}

private BookingTherapistView mapResultSetToTherapistView(ResultSet rs) throws SQLException {
    BookingTherapistView booking = new BookingTherapistView();
    booking.setBookingId(rs.getInt("booking_id"));
    booking.setAppointmentDate(rs.getDate("appointment_date").toLocalDate());
    booking.setAppointmentTime(rs.getTime("appointment_time").toLocalTime());
    booking.setDurationMinutes(rs.getInt("duration_minutes"));
    booking.setBookingStatus(rs.getString("booking_status"));
    booking.setBookingNotes(rs.getString("booking_notes"));
    booking.setServiceName(rs.getString("service_name"));
    booking.setCustomerName(rs.getString("customer_name"));
    booking.setCustomerPhone(rs.getString("customer_phone"));
    booking.setCustomerEmail(rs.getString("customer_email"));
    booking.setRoomName(rs.getString("room_name"));
    booking.setBedName(rs.getString("bed_name"));
    return booking;
}

private BookingManagerView mapResultSetToManagerView(ResultSet rs) throws SQLException {
    BookingManagerView booking = new BookingManagerView();
    booking.setBookingId(rs.getInt("booking_id"));
    booking.setAppointmentDate(rs.getDate("appointment_date").toLocalDate());
    booking.setAppointmentTime(rs.getTime("appointment_time").toLocalTime());
    booking.setDurationMinutes(rs.getInt("duration_minutes"));
    booking.setBookingStatus(rs.getString("booking_status"));
    booking.setBookingNotes(rs.getString("booking_notes"));
    booking.setServiceName(rs.getString("service_name"));
    booking.setServicePrice(rs.getBigDecimal("service_price"));
    booking.setCustomerName(rs.getString("customer_name"));
    booking.setCustomerPhone(rs.getString("customer_phone"));
    booking.setCustomerEmail(rs.getString("customer_email"));
    booking.setTherapistName(rs.getString("therapist_name"));
    booking.setRoomName(rs.getString("room_name"));
    booking.setTotalAmount(rs.getBigDecimal("total_amount"));
    booking.setPaymentStatus(rs.getString("payment_status"));
    booking.setReferenceNumber(rs.getString("reference_number"));
    booking.setCreatedAt(rs.getTimestamp("created_at"));
    return booking;
}
}
