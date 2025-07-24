// src/test/java/csp/CspTestDataSetup.java
package booking;

import db.DBContext;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;

public class CspTestDataSetup {
    
    /**
     * Insert a test booking to create known constraints
     */
    public static int insertTestBooking(LocalDate date, LocalTime startTime, 
                                       int therapistId, int roomId, Integer bedId, 
                                       int serviceId, int customerId) throws SQLException {
        
        // First, we need to create a payment record since bookings reference payment_items
        int paymentId = createTestPayment(customerId, serviceId);
        int paymentItemId = createTestPaymentItem(paymentId, serviceId);
        
        String insertQuery = """
            INSERT INTO bookings (customer_id, payment_item_id, service_id, therapist_user_id, 
                                 room_id, bed_id, appointment_date, appointment_time, 
                                 duration_minutes, booking_status, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'CONFIRMED', NOW(), NOW())
            """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(insertQuery, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, customerId);           // customer_id
            pstmt.setInt(2, paymentItemId);        // payment_item_id
            pstmt.setInt(3, serviceId);            // service_id
            pstmt.setInt(4, therapistId);          // therapist_user_id
            pstmt.setInt(5, roomId);               // room_id
            if (bedId != null) {
                pstmt.setInt(6, bedId);            // bed_id
            } else {
                pstmt.setNull(6, Types.INTEGER);   // bed_id
            }
            pstmt.setDate(7, Date.valueOf(date));  // appointment_date
            pstmt.setTime(8, Time.valueOf(startTime)); // appointment_time
            pstmt.setInt(9, 60);                   // duration_minutes
            
            pstmt.executeUpdate();
            
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        throw new SQLException("Failed to insert test booking");
    }
    
    /**
     * Create a test payment record
     */
    private static int createTestPayment(int customerId, int serviceId) throws SQLException {
        String query = """
            INSERT INTO payments (customer_id, total_amount, tax_amount, subtotal_amount, 
                                payment_method, payment_status, reference_number, created_at, updated_at)
            VALUES (?, 550000.00, 50000.00, 500000.00, 'CASH', 'PAID', ?, NOW(), NOW())
            """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, customerId);
            pstmt.setString(2, "TEST_" + System.currentTimeMillis());
            
            pstmt.executeUpdate();
            
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        throw new SQLException("Failed to create test payment");
    }
    
    /**
     * Create a test payment item record
     */
    private static int createTestPaymentItem(int paymentId, int serviceId) throws SQLException {
        String query = """
            INSERT INTO payment_items (payment_id, service_id, quantity, unit_price, 
                                     total_price, service_duration, created_at)
            VALUES (?, ?, 1, 500000.00, 500000.00, 60, NOW())
            """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, paymentId);
            pstmt.setInt(2, serviceId);
            
            pstmt.executeUpdate();
            
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        throw new SQLException("Failed to create test payment item");
    }
    
    /**
     * Clean up test bookings and related records
     */
    public static void cleanupTestBookings(int... bookingIds) throws SQLException {
        if (bookingIds.length == 0) return;
        
        try (Connection conn = DBContext.getConnection()) {
            // Disable foreign key checks temporarily for cleanup
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("SET FOREIGN_KEY_CHECKS = 0");
            }
            
            // Delete bookings
            StringBuilder bookingQuery = new StringBuilder("DELETE FROM bookings WHERE booking_id IN (");
            for (int i = 0; i < bookingIds.length; i++) {
                bookingQuery.append("?");
                if (i < bookingIds.length - 1) bookingQuery.append(",");
            }
            bookingQuery.append(")");
            
            try (PreparedStatement pstmt = conn.prepareStatement(bookingQuery.toString())) {
                for (int i = 0; i < bookingIds.length; i++) {
                    pstmt.setInt(i + 1, bookingIds[i]);
                }
                pstmt.executeUpdate();
            }
            
            // Clean up test payments and payment items (they might be referenced)
            String cleanupQuery = """
                DELETE p, pi FROM payments p 
                LEFT JOIN payment_items pi ON p.payment_id = pi.payment_id 
                WHERE p.reference_number LIKE 'TEST_%'
                """;
            
            try (PreparedStatement pstmt = conn.prepareStatement(cleanupQuery)) {
                pstmt.executeUpdate();
            }
            
            // Re-enable foreign key checks
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("SET FOREIGN_KEY_CHECKS = 1");
            }
        }
    }
    
    /**
     * Simple method to insert booking with minimal dependencies
     */
    public static int insertSimpleTestBooking(LocalDate date, LocalTime startTime, 
                                            int therapistId, int roomId, Integer bedId) throws SQLException {
        
        // Use existing customer and service IDs from your database
        int customerId = 1; // Assuming customer ID 1 exists
        int serviceId = 1;  // Assuming service ID 1 exists
        
        return insertTestBooking(date, startTime, therapistId, roomId, bedId, serviceId, customerId);
    }
}