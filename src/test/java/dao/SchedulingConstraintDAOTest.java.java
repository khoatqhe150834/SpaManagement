// src/test/java/dao/SchedulingConstraintDAOTest.java
package dao;

import booking.*;
import db.DBContext;
import java.sql.Connection;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class SchedulingConstraintDAOTest {
    
    private static SchedulingConstraintDAO dao;
    
    @BeforeAll
    static void setUp() {
        dao = new SchedulingConstraintDAO();
        
        // Test database connection first
        assertTrue(DBContext.testConnection(), "Database connection should be available for tests");
    }
    
    @Test
    @Order(1)
    @DisplayName("Test Database Connection")
    void testDatabaseConnection() {
        assertDoesNotThrow(() -> {
            try (Connection conn = DBContext.getConnection()) {
                assertNotNull(conn, "Connection should not be null");
                assertTrue(conn.isValid(5), "Connection should be valid");
            }
        });
    }
    
    @Test
    @Order(2)
    @DisplayName("Test Load Existing Bookings")
    void testLoadExistingBookings() {
        assertDoesNotThrow(() -> {
            LocalDate testDate = LocalDate.of(2025, 7, 25); // Use a date that might have bookings
            List<BookingConstraint> bookings = dao.loadExistingBookings(testDate);
            
            assertNotNull(bookings, "Bookings list should not be null");
            System.out.println("Found " + bookings.size() + " bookings for date: " + testDate);
            
            // If there are bookings, validate their structure
            for (BookingConstraint booking : bookings) {
                assertNotNull(booking.getStartTime(), "Start time should not be null");
                assertNotNull(booking.getEndTime(), "End time should not be null");
                assertTrue(booking.getTherapistId() > 0, "Therapist ID should be positive");
                assertTrue(booking.getRoomId() > 0, "Room ID should be positive");
                assertNotNull(booking.getBookingStatus(), "Booking status should not be null");
                
                System.out.println("Booking: " + booking);
            }
        });
    }
    
    @Test
    @Order(3)
    @DisplayName("Test Load Therapists By Service Type")
    void testLoadTherapistsByServiceType() {
        assertDoesNotThrow(() -> {
            Map<Integer, List<TherapistInfo>> therapistsByServiceType = dao.loadTherapistsByServiceType();
            
            assertNotNull(therapistsByServiceType, "Therapists map should not be null");
            assertFalse(therapistsByServiceType.isEmpty(), "Should have at least one service type with therapists");
            
            System.out.println("Found therapists for " + therapistsByServiceType.size() + " service types");
            
            // Validate each service type and its therapists
            for (Map.Entry<Integer, List<TherapistInfo>> entry : therapistsByServiceType.entrySet()) {
                Integer serviceTypeId = entry.getKey();
                List<TherapistInfo> therapists = entry.getValue();
                
                assertTrue(serviceTypeId > 0, "Service type ID should be positive");
                assertNotNull(therapists, "Therapists list should not be null");
                assertFalse(therapists.isEmpty(), "Should have at least one therapist per service type");
                
                System.out.println("Service Type " + serviceTypeId + " has " + therapists.size() + " therapists:");
                for (TherapistInfo therapist : therapists) {
                    assertNotNull(therapist.getFullName(), "Therapist name should not be null");
                    assertTrue(therapist.getUserId() > 0, "User ID should be positive");
                    assertEquals("AVAILABLE", therapist.getAvailabilityStatus(), "Should only load available therapists");
                    System.out.println("  - " + therapist);
                }
            }
        });
    }
    
    @Test
    @Order(4)
    @DisplayName("Test Load Rooms And Beds")
    void testLoadRoomsAndBeds() {
        assertDoesNotThrow(() -> {
            List<RoomBedInfo> roomBeds = dao.loadRoomsAndBeds();
            
            assertNotNull(roomBeds, "Room beds list should not be null");
            assertFalse(roomBeds.isEmpty(), "Should have at least one room");
            
            System.out.println("Found " + roomBeds.size() + " room-bed combinations");
            
            for (RoomBedInfo roomBed : roomBeds) {
                assertTrue(roomBed.getRoomId() > 0, "Room ID should be positive");
                assertNotNull(roomBed.getRoomName(), "Room name should not be null");
                assertTrue(roomBed.getCapacity() > 0, "Room capacity should be positive");
                
                System.out.println("Room: " + roomBed);
            }
        });
    }
    
    @Test
    @Order(5)
    @DisplayName("Test Get Service Info")
    void testGetServiceInfo() {
        assertDoesNotThrow(() -> {
            // Test with a known service ID (assuming service ID 1 exists)
            int testServiceId = 1;
            ServiceInfo service = dao.getServiceInfo(testServiceId);
            
            if (service != null) {
                assertEquals(testServiceId, service.getServiceId(), "Service ID should match");
                assertNotNull(service.getName(), "Service name should not be null");
                assertTrue(service.getDurationMinutes() > 0, "Duration should be positive");
                assertTrue(service.getServiceTypeId() > 0, "Service type ID should be positive");
                assertTrue(service.isActive(), "Should only return active services");
                
                System.out.println("Service Info: " + service);
            } else {
                System.out.println("No service found with ID: " + testServiceId);
            }
            
            // Test with invalid service ID
            ServiceInfo invalidService = dao.getServiceInfo(-1);
            assertNull(invalidService, "Should return null for invalid service ID");
        });
    }
    
   
    
    @Test
    @Order(7)
    @DisplayName("Test Get Qualified Therapists")
    void testGetQualifiedTherapists() {
        assertDoesNotThrow(() -> {
            // Test with a known service ID
            int testServiceId = 1; // Assuming service ID 1 exists
            List<TherapistInfo> qualifiedTherapists = dao.getQualifiedTherapists(testServiceId);
            
            assertNotNull(qualifiedTherapists, "Qualified therapists list should not be null");
            System.out.println("Found " + qualifiedTherapists.size() + " qualified therapists for service ID: " + testServiceId);
            
            for (TherapistInfo therapist : qualifiedTherapists) {
                assertTrue(therapist.getUserId() > 0, "User ID should be positive");
                assertNotNull(therapist.getFullName(), "Therapist name should not be null");
                assertTrue(therapist.getServiceTypeId() > 0, "Service type ID should be positive");
                assertEquals("AVAILABLE", therapist.getAvailabilityStatus(), "Should only return available therapists");
                
                System.out.println("Qualified therapist: " + therapist);
            }
            
            // Test with invalid service ID
            List<TherapistInfo> invalidTherapists = dao.getQualifiedTherapists(-1);
            assertNotNull(invalidTherapists, "Should return empty list for invalid service ID");
            assertTrue(invalidTherapists.isEmpty(), "Should be empty for invalid service ID");
        });
    }
    
    @Test
    @Order(8)
    @DisplayName("Test Load Existing Bookings with Future Date")
    void testLoadExistingBookingsWithFutureDate() {
        assertDoesNotThrow(() -> {
            // Test with a future date that likely has no bookings
            LocalDate futureDate = LocalDate.now().plusMonths(6);
            List<BookingConstraint> bookings = dao.loadExistingBookings(futureDate);
            
            assertNotNull(bookings, "Bookings list should not be null even for future dates");
            System.out.println("Found " + bookings.size() + " bookings for future date: " + futureDate);
        });
    }
    
    @AfterAll
    static void tearDown() {
        System.out.println("All DAO tests completed");
    }
}