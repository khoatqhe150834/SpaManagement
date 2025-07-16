package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import db.DBContext;
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
                    "appointment_date, appointment_time, duration_minutes, booking_status, booking_notes) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
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
                    "updated_at = CURRENT_TIMESTAMP WHERE booking_id = ?";
        
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
            stmt.setInt(13, booking.getBookingId());
            
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
}
