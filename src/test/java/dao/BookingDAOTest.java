package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;

import booking.BookingCustomerView;
import db.DBContext;
import model.Booking;

/**
 * JUnit tests for BookingDAO to debug booking data loading issues
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class BookingDAOTest {
    
    private static final Logger LOGGER = Logger.getLogger(BookingDAOTest.class.getName());
    private BookingDAO bookingDAO;
    
    @BeforeEach
    void setUp() {
        bookingDAO = new BookingDAO();
    }
    
    /**
     * Test 1: Check database connection
     */
    @Test
    @Order(1)
    @DisplayName("Test Database Connection")
    void testDatabaseConnection() {
        assertDoesNotThrow(() -> {
            try (Connection conn = DBContext.getConnection()) {
                assertNotNull(conn, "Database connection should not be null");
                assertTrue(conn.isValid(5), "Database connection should be valid");
                LOGGER.info("✅ Database connection test passed");
            }
        }, "Database connection should work without throwing exceptions");
    }
    
    /**
     * Test 2: Check if customers table has data
     */
    @Test
    @Order(2)
    @DisplayName("Test Customer Data Exists")
    void testCustomerDataExists() throws SQLException {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM customers");
             ResultSet rs = stmt.executeQuery()) {
            
            assertTrue(rs.next(), "Should have result from COUNT query");
            int customerCount = rs.getInt(1);
            LOGGER.info("Total customers in database: " + customerCount);
            assertTrue(customerCount > 0, "Should have at least one customer in database");
        }
    }
    
    /**
     * Test 3: Check if bookings table has data
     */
    @Test
    @Order(3)
    @DisplayName("Test Booking Data Exists")
    void testBookingDataExists() throws SQLException {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM bookings");
             ResultSet rs = stmt.executeQuery()) {
            
            assertTrue(rs.next(), "Should have result from COUNT query");
            int bookingCount = rs.getInt(1);
            LOGGER.info("Total bookings in database: " + bookingCount);
            
            if (bookingCount == 0) {
                LOGGER.warning("⚠️ No bookings found in database - this explains why no data is showing");
            } else {
                LOGGER.info("✅ Found " + bookingCount + " bookings in database");
            }
        }
    }
    
    /**
     * Test 4: Check specific customer exists
     */
    @Test
    @Order(4)
    @DisplayName("Test Specific Customer Exists")
    void testSpecificCustomerExists() throws SQLException {
        String[] testEmails = {"khoatqhe150834", "vucongdat28032003@gmail.com"};
        
        for (String email : testEmails) {
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                     "SELECT customer_id, full_name, email FROM customers WHERE email = ? OR full_name LIKE ?")) {
                
                stmt.setString(1, email);
                stmt.setString(2, "%" + email + "%");
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int customerId = rs.getInt("customer_id");
                        String fullName = rs.getString("full_name");
                        String customerEmail = rs.getString("email");
                        LOGGER.info("✅ Found customer: ID=" + customerId + ", Name=" + fullName + ", Email=" + customerEmail);
                        
                        // Check if this customer has bookings
                        checkCustomerBookings(customerId, email);
                    } else {
                        LOGGER.warning("❌ Customer not found: " + email);
                    }
                }
            }
        }
    }
    
    /**
     * Helper method to check customer bookings
     */
    private void checkCustomerBookings(int customerId, String identifier) throws SQLException {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM bookings WHERE customer_id = ?")) {
            
            stmt.setInt(1, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int bookingCount = rs.getInt(1);
                    LOGGER.info("Customer " + identifier + " (ID: " + customerId + ") has " + bookingCount + " bookings");
                }
            }
        }
    }
    
    /**
     * Test 5: Test BookingDAO.findByCustomerId method
     */
    @Test
    @Order(5)
    @DisplayName("Test BookingDAO findByCustomerId Method")
    void testFindByCustomerId() {
        // Test with known customer IDs
        Integer[] testCustomerIds = {1, 2, 3, 4, 5}; // Adjust based on your data
        
        for (Integer customerId : testCustomerIds) {
            assertDoesNotThrow(() -> {
                List<Booking> bookings = bookingDAO.findByCustomerId(customerId);
                LOGGER.info("Customer ID " + customerId + " has " + bookings.size() + " bookings via findByCustomerId()");
                
                if (!bookings.isEmpty()) {
                    Booking firstBooking = bookings.get(0);
                    LOGGER.info("First booking: ID=" + firstBooking.getBookingId() + 
                               ", Date=" + firstBooking.getAppointmentDate() + 
                               ", Status=" + firstBooking.getBookingStatus());
                }
            }, "findByCustomerId should not throw exceptions");
        }
    }
    
    /**
     * Test 6: Test BookingDAO.findBookingsForCustomer method (the problematic one)
     */
    @Test
    @Order(6)
    @DisplayName("Test BookingDAO findBookingsForCustomer Method")
    void testFindBookingsForCustomer() {
        Integer[] testCustomerIds = {1, 2, 3, 4, 5}; // Adjust based on your data
        
        for (Integer customerId : testCustomerIds) {
            assertDoesNotThrow(() -> {
                List<BookingCustomerView> bookings = bookingDAO.findBookingsForCustomer(customerId);
                LOGGER.info("Customer ID " + customerId + " has " + bookings.size() + " bookings via findBookingsForCustomer()");
                
                if (!bookings.isEmpty()) {
                    BookingCustomerView firstBooking = bookings.get(0);
                    LOGGER.info("First booking view: ID=" + firstBooking.getBookingId() + 
                               ", Service=" + firstBooking.getServiceName() + 
                               ", Therapist=" + firstBooking.getTherapistName());
                } else {
                    LOGGER.warning("⚠️ No BookingCustomerView records found for customer " + customerId);
                    // Check if raw bookings exist but joins are failing
                    checkRawBookingsVsJoinedBookings(customerId);
                }
            }, "findBookingsForCustomer should not throw exceptions");
        }
    }
    
    /**
     * Helper method to compare raw bookings vs joined bookings
     */
    private void checkRawBookingsVsJoinedBookings(Integer customerId) throws SQLException {
        // Check raw bookings
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM bookings WHERE customer_id = ?")) {
            
            stmt.setInt(1, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int rawCount = rs.getInt(1);
                    LOGGER.info("Customer " + customerId + " has " + rawCount + " raw bookings");
                    
                    if (rawCount > 0) {
                        // Check what's missing in the joins
                        checkMissingJoinData(customerId);
                    }
                }
            }
        }
    }
    
    /**
     * Check what data is missing that causes joins to fail
     */
    private void checkMissingJoinData(Integer customerId) throws SQLException {
        String sql = """
            SELECT b.booking_id, b.service_id, b.therapist_user_id, b.room_id, b.payment_item_id,
                   s.service_id as service_exists,
                   u.user_id as therapist_exists,
                   r.room_id as room_exists,
                   pi.payment_item_id as payment_item_exists
            FROM bookings b
            LEFT JOIN services s ON b.service_id = s.service_id
            LEFT JOIN users u ON b.therapist_user_id = u.user_id
            LEFT JOIN rooms r ON b.room_id = r.room_id
            LEFT JOIN payment_items pi ON b.payment_item_id = pi.payment_item_id
            WHERE b.customer_id = ?
            """;
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int bookingId = rs.getInt("booking_id");
                    boolean serviceExists = rs.getObject("service_exists") != null;
                    boolean therapistExists = rs.getObject("therapist_exists") != null;
                    boolean roomExists = rs.getObject("room_exists") != null;
                    boolean paymentItemExists = rs.getObject("payment_item_exists") != null;
                    
                    LOGGER.info("Booking " + bookingId + " - Service: " + serviceExists + 
                               ", Therapist: " + therapistExists + 
                               ", Room: " + roomExists + 
                               ", PaymentItem: " + paymentItemExists);
                    
                    if (!serviceExists || !therapistExists || !roomExists || !paymentItemExists) {
                        LOGGER.warning("⚠️ Booking " + bookingId + " has missing related data!");
                    }
                }
            }
        }
    }
    
    /**
     * Test 7: Test the exact SQL query used in findBookingsForCustomer
     */
    @Test
    @Order(7)
    @DisplayName("Test Exact SQL Query from findBookingsForCustomer")
    void testExactSQLQuery() throws SQLException {
        String sql = """
            SELECT b.booking_id, b.appointment_date, b.appointment_time, b.duration_minutes,
                   b.booking_status, b.booking_notes, b.created_at,
                   s.name as service_name, s.price as service_price,
                   u.full_name as therapist_name,
                   r.name as room_name,
                   p.payment_status, p.total_amount, p.reference_number
            FROM bookings b
            LEFT JOIN services s ON b.service_id = s.service_id
            LEFT JOIN users u ON b.therapist_user_id = u.user_id
            LEFT JOIN rooms r ON b.room_id = r.room_id
            LEFT JOIN payment_items pi ON b.payment_item_id = pi.payment_item_id
            LEFT JOIN payments p ON pi.payment_id = p.payment_id
            WHERE b.customer_id = ?
            ORDER BY b.appointment_date DESC, b.appointment_time DESC
            """;
        
        Integer[] testCustomerIds = {1, 2, 3, 4, 5};
        
        for (Integer customerId : testCustomerIds) {
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                
                stmt.setInt(1, customerId);
                try (ResultSet rs = stmt.executeQuery()) {
                    int count = 0;
                    while (rs.next()) {
                        count++;
                        if (count == 1) { // Log first result
                            LOGGER.info("Customer " + customerId + " first result: " +
                                       "BookingID=" + rs.getInt("booking_id") +
                                       ", Service=" + rs.getString("service_name") +
                                       ", Therapist=" + rs.getString("therapist_name"));
                        }
                    }
                    LOGGER.info("Customer " + customerId + " has " + count + " results from exact SQL");
                }
            }
        }
    }
}
