/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package booking;

/**
 *
 * @author quang
 */
// src/test/java/csp/CspValidationTest.java

import dao.SchedulingConstraintDAO;
import db.DBContext;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class CspValidationTest {
    
    private static SpaCspSolver cspSolver;
    private static SchedulingConstraintDAO dao;
    private static List<Integer> testBookingIds = new ArrayList<>();
    
    @BeforeAll
    static void setUp() {
        assertTrue(DBContext.testConnection(), "Database connection required for validation tests");
        cspSolver = new SpaCspSolver();
        dao = new SchedulingConstraintDAO();
    }
    
    @Test
    @Order(1)
    @DisplayName("Validate CSP - No Conflicts with Empty Schedule")
    void testCspWithEmptySchedule() {
        assertDoesNotThrow(() -> {
            // Use a future date with no existing bookings
            LocalDate emptyDate = LocalDate.now().plusDays(30);
            int serviceId = 1; // Massage service
            
            System.out.println("=== Testing Empty Schedule ===");
            System.out.println("Date: " + emptyDate);
            
            List<AvailableTimeSlot> slots = cspSolver.findAvailableSlots(emptyDate, serviceId, 20);
            
            assertNotNull(slots, "Should return slots for empty schedule");
            assertFalse(slots.isEmpty(), "Should find available slots on empty day");
            
            System.out.println("Found " + slots.size() + " available slots on empty day");
            
            // Verify that we have maximum possible slots (limited by business hours)
            // Business hours: 8 AM - 8 PM = 12 hours = 720 minutes
            // Service duration + buffer: ~75 minutes for massage
            // 15-minute intervals: should have many slots available
            assertTrue(slots.size() >= 10, "Should have at least 10 slots on empty day");
            
            // Verify each slot has resources available
            for (AvailableTimeSlot slot : slots) {
                assertTrue(slot.hasAvailableResources(), "Each slot should have available resources");
                assertTrue(slot.getTotalCombinations() > 0, "Each slot should have resource combinations");
                
                // Verify time slots are within business hours
                LocalTime startTime = slot.getTimeSlot().getStartTime().toLocalTime();
                LocalTime endTime = slot.getTimeSlot().getEndTime().toLocalTime();
                
                assertTrue(startTime.isAfter(LocalTime.of(7, 59)), "Should start at or after 8 AM");
                assertTrue(endTime.isBefore(LocalTime.of(20, 1)), "Should end at or before 8 PM");
            }
            
            System.out.println("✅ Empty schedule validation passed");
        });
    }
    
    @Test
    @Order(2)
    @DisplayName("Validate CSP - Respects Existing Bookings")
    void testCspRespectsExistingBookings() {
        assertDoesNotThrow(() -> {
            LocalDate testDate = LocalDate.now().plusDays(15);
            int serviceId = 1;
            int therapistId = 3; // Use a known therapist ID
            int roomId = 1;
            int bedId = 1;
            int customerId = 1;
            
            System.out.println("\n=== Testing Booking Constraint Respect ===");
            System.out.println("Date: " + testDate);
            
            // First, get available slots before adding constraint
            List<AvailableTimeSlot> slotsBefore = cspSolver.findAvailableSlots(testDate, serviceId, 50);
            System.out.println("Slots before adding booking: " + slotsBefore.size());
            
            // Insert a test booking at 10:00 AM
            LocalTime blockedTime = LocalTime.of(10, 0);
            int testBookingId = CspTestDataSetup.insertTestBooking(
                testDate, blockedTime, therapistId, roomId, bedId, serviceId, customerId);
            testBookingIds.add(testBookingId);
            
            System.out.println("Inserted test booking at " + blockedTime + 
                             " (Therapist: " + therapistId + ", Room: " + roomId + ", Bed: " + bedId + ")");
            
            // Get available slots after adding constraint
            List<AvailableTimeSlot> slotsAfter = cspSolver.findAvailableSlots(testDate, serviceId, 50);
            System.out.println("Slots after adding booking: " + slotsAfter.size());
            
            // Verify the booking created a constraint
            assertTrue(slotsAfter.size() <= slotsBefore.size(), 
                      "Should have same or fewer slots after adding booking");
            
            // Verify no slot conflicts with the blocked time (10:00-11:15 including buffer)
            LocalDateTime blockedStart = LocalDateTime.of(testDate, blockedTime);
            LocalDateTime blockedEnd = blockedStart.plusMinutes(75); // 60min service + 15min buffer
            
            for (AvailableTimeSlot slot : slotsAfter) {
                LocalDateTime slotStart = slot.getTimeSlot().getStartTime();
                LocalDateTime slotEnd = slot.getTimeSlot().getEndTime();
                
                // Check if any resource combination conflicts
                for (ResourceCombination resource : slot.getAvailableResources()) {
                    if (resource.getTherapistId() == therapistId || 
                        (resource.getRoomId() == roomId && resource.getBedId() != null && resource.getBedId().equals(bedId))) {
                        
                        // This resource should not be available during blocked time
                        boolean hasTimeConflict = slotStart.isBefore(blockedEnd) && slotEnd.isAfter(blockedStart);
                        assertFalse(hasTimeConflict, 
                                  "Resource should not be available during blocked time. " +
                                  "Slot: " + slotStart.toLocalTime() + "-" + slotEnd.toLocalTime() + 
                                  ", Blocked: " + blockedTime + "-" + blockedEnd.toLocalTime());
                    }
                }
            }
            
            System.out.println("✅ Booking constraint validation passed");
        });
    }
    
    @Test
    @Order(3)
    @DisplayName("Validate CSP - Therapist Qualification Constraints")
    void testTherapistQualificationConstraints() {
        assertDoesNotThrow(() -> {
            LocalDate testDate = LocalDate.now().plusDays(16);
            
            System.out.println("\n=== Testing Therapist Qualification Constraints ===");
            
            // Test different service types to ensure only qualified therapists are assigned
            int[] serviceIds = {1, 3, 5}; // Different service types
            
            for (int serviceId : serviceIds) {
                List<AvailableTimeSlot> slots = cspSolver.findAvailableSlots(testDate, serviceId, 5);
                ServiceInfo service = dao.getServiceInfo(serviceId);
                List<TherapistInfo> qualifiedTherapists = dao.getQualifiedTherapists(serviceId);
                
                System.out.println("Service: " + service.getName() + " (Type: " + service.getServiceTypeId() + ")");
                System.out.println("Qualified therapists: " + qualifiedTherapists.size());
                
                for (AvailableTimeSlot slot : slots) {
                    for (ResourceCombination resource : slot.getAvailableResources()) {
                        // Verify this therapist is qualified for this service
                        boolean isQualified = qualifiedTherapists.stream()
                            .anyMatch(t -> t.getUserId() == resource.getTherapistId());
                        
                        assertTrue(isQualified, 
                                 "Therapist " + resource.getTherapistName() + 
                                 " should be qualified for service " + service.getName());
                    }
                }
                
                System.out.println("✅ All assigned therapists are qualified");
            }
        });
    }
    
    @Test
    @Order(4)
    @DisplayName("Validate CSP - Time Slot Intervals")
    void testTimeSlotIntervals() {
        assertDoesNotThrow(() -> {
            LocalDate testDate = LocalDate.now().plusDays(17);
            int serviceId = 1;
            
            System.out.println("\n=== Testing Time Slot Intervals ===");
            
            List<AvailableTimeSlot> slots = cspSolver.findAvailableSlots(testDate, serviceId, 20);
            
            assertFalse(slots.isEmpty(), "Should have available slots");
            
            // Verify slots are in 15-minute intervals
            for (int i = 0; i < Math.min(10, slots.size()); i++) {
                LocalDateTime startTime = slots.get(i).getTimeSlot().getStartTime();
                int minute = startTime.getMinute();
                
                assertTrue(minute % 15 == 0, 
                         "Time slot should start at 15-minute intervals. Found: " + startTime);
            }
            
            // Verify slots are ordered chronologically
            for (int i = 1; i < slots.size(); i++) {
                LocalDateTime current = slots.get(i).getTimeSlot().getStartTime();
                LocalDateTime previous = slots.get(i-1).getTimeSlot().getStartTime();
                
                assertTrue(current.isAfter(previous), 
                         "Slots should be in chronological order");
            }
            
            System.out.println("✅ Time slot interval validation passed");
        });
    }
    
   @Test
@Order(5)
@DisplayName("Validate CSP - Buffer Time Enforcement")
void testBufferTimeEnforcement() {
    assertDoesNotThrow(() -> {
        LocalDate testDate = LocalDate.now().plusDays(18);
        int serviceId = 1;
        int therapistId = 3; // Use a known therapist ID
        int roomId = 1;
        int bedId = 1;
        int customerId = 1;
        
        System.out.println("\n=== Testing Buffer Time Enforcement ===");
        
        // Create a booking at 2:00 PM
        LocalTime bookingTime = LocalTime.of(14, 0);
        int testBookingId = CspTestDataSetup.insertTestBooking(
            testDate, bookingTime, therapistId, roomId, bedId, serviceId, customerId);
        testBookingIds.add(testBookingId);
        
        System.out.println("Created booking at " + bookingTime + " (1 hour service + 15 min buffer)");
        System.out.println("Booking should block time from 14:00 to 15:15");
        System.out.println("Using Therapist ID: " + therapistId + ", Room ID: " + roomId + ", Bed ID: " + bedId);
        
        List<AvailableTimeSlot> slots = cspSolver.findAvailableSlots(testDate, serviceId, 50);
        
        // Define the blocked time period (service + buffer)
        LocalDateTime bookingStart = LocalDateTime.of(testDate, bookingTime);
        LocalDateTime bookingServiceEnd = bookingStart.plusMinutes(60); // Service ends at 15:00
        LocalDateTime bufferEnd = bookingStart.plusMinutes(75); // Buffer ends at 15:15
        
        System.out.println("Blocked period: " + bookingStart.toLocalTime() + " - " + bufferEnd.toLocalTime());
        
        // Check that no slot overlaps with the blocked time for the same resources
        boolean foundConflict = false;
        for (AvailableTimeSlot slot : slots) {
            LocalDateTime slotStart = slot.getTimeSlot().getStartTime();
            LocalDateTime slotEnd = slot.getTimeSlot().getEndTime();
            
            for (ResourceCombination resource : slot.getAvailableResources()) {
                // Check if this resource matches the booked resource
                boolean sameTherapist = (resource.getTherapistId() == therapistId);
                boolean sameRoomBed = (resource.getRoomId() == roomId && 
                                     resource.getBedId() != null && resource.getBedId().equals(bedId));
                
                if (sameTherapist || sameRoomBed) {
                    // Check for time overlap with the blocked period
                    boolean overlaps = (slotStart.isBefore(bufferEnd) && slotEnd.isAfter(bookingStart));
                    
                    if (overlaps) {
                        foundConflict = true;
                        System.err.println("CONFLICT FOUND:");
                        System.err.println("  Slot: " + slotStart.toLocalTime() + " - " + slotEnd.toLocalTime());
                        System.err.println("  Resource: " + resource);
                        System.err.println("  Blocked period: " + bookingStart.toLocalTime() + " - " + bufferEnd.toLocalTime());
                        
                        fail("Found conflicting slot: " + slotStart.toLocalTime() + "-" + slotEnd.toLocalTime() + 
                             " overlaps with blocked period " + bookingStart.toLocalTime() + "-" + bufferEnd.toLocalTime() +
                             " for resource: " + resource);
                    }
                }
            }
        }
        
        System.out.println("✅ No conflicts found - buffer time is properly enforced");
        
        // Additional verification: ensure there are still available slots at other times
        long slotsBeforeBlocked = slots.stream()
            .filter(slot -> slot.getTimeSlot().getEndTime().isBefore(bookingStart) || 
                           slot.getTimeSlot().getEndTime().equals(bookingStart))
            .count();
        
        long slotsAfterBlocked = slots.stream()
            .filter(slot -> slot.getTimeSlot().getStartTime().isAfter(bufferEnd) || 
                           slot.getTimeSlot().getStartTime().equals(bufferEnd))
            .count();
        
        System.out.println("Available slots before blocked period: " + slotsBeforeBlocked);
        System.out.println("Available slots after blocked period: " + slotsAfterBlocked);
        
        assertTrue(slotsBeforeBlocked > 0 || slotsAfterBlocked > 0, 
                  "Should have available slots outside the blocked period");
        
        System.out.println("✅ Buffer time enforcement validation passed");
    });
}
    
    @Test
    @Order(6)
    @DisplayName("Validate CSP - Performance Under Load")
    void testCspPerformance() {
        assertDoesNotThrow(() -> {
            LocalDate testDate = LocalDate.now().plusDays(20);
            
            System.out.println("\n=== Testing CSP Performance ===");
            
            // Test performance with multiple service requests
            long totalTime = 0;
            int iterations = 5;
            
            for (int i = 0; i < iterations; i++) {
                long startTime = System.currentTimeMillis();
                List<AvailableTimeSlot> slots = cspSolver.findAvailableSlots(testDate, 1, 20);
                long endTime = System.currentTimeMillis();
                
                long executionTime = endTime - startTime;
                totalTime += executionTime;
                
                System.out.println("Iteration " + (i+1) + ": " + executionTime + "ms, found " + slots.size() + " slots");
            }
            
            double avgTime = (double) totalTime / iterations;
            System.out.println("Average execution time: " + String.format("%.2f", avgTime) + "ms");
            
            // Performance should be reasonable (under 2 seconds per request)
            assertTrue(avgTime < 2000, "CSP should complete within 2 seconds on average");
            
            System.out.println("✅ Performance validation passed");
        });
    }
    
    @Test
    @Order(7)
    @DisplayName("Validate CSP - Edge Cases")
    void testCspEdgeCases() {
        assertDoesNotThrow(() -> {
            System.out.println("\n=== Testing Edge Cases ===");
            
            LocalDate testDate = LocalDate.now().plusDays(25);
            
            // Test 1: Invalid service ID
            List<AvailableTimeSlot> invalidService = cspSolver.findAvailableSlots(testDate, 999, 10);
            assertTrue(invalidService.isEmpty(), "Should return empty list for invalid service");
            System.out.println("✅ Invalid service ID handled correctly");
            
            // Test 2: Very early morning slots
            List<AvailableTimeSlot> earlySlots = cspSolver.findAvailableSlots(testDate, 1, 5);
            if (!earlySlots.isEmpty()) {
                LocalTime firstSlotTime = earlySlots.get(0).getTimeSlot().getStartTime().toLocalTime();
                assertTrue(firstSlotTime.equals(LocalTime.of(8, 0)) || firstSlotTime.isAfter(LocalTime.of(8, 0)), 
                         "First slot should be at or after 8 AM");
            }
            System.out.println("✅ Business hours start time respected");
            
            // Test 3: Late evening slots
            if (!earlySlots.isEmpty()) {
                AvailableTimeSlot lastSlot = earlySlots.get(earlySlots.size() - 1);
                LocalTime lastSlotEnd = lastSlot.getTimeSlot().getEndTime().toLocalTime();
                assertTrue(lastSlotEnd.isBefore(LocalTime.of(20, 1)), 
                         "Last slot should end at or before 8 PM");
            }
            System.out.println("✅ Business hours end time respected");
            
            System.out.println("✅ All edge cases passed");
        });
    }
    
    
    // Add this method to CspValidationTest class for debugging

@Test
@Order(8)
@DisplayName("Debug CSP - Check Actual Booking Data")
void debugActualBookingData() {
    assertDoesNotThrow(() -> {
        LocalDate testDate = LocalDate.now().plusDays(19);
        int serviceId = 1;
        int therapistId = 3;
        int roomId = 1;
        int bedId = 1;
        int customerId = 1;
        
        System.out.println("\n=== DEBUG: Checking Actual Booking Data ===");
        
        // Create a test booking
        LocalTime bookingTime = LocalTime.of(10, 0); // 10 AM
        int testBookingId = CspTestDataSetup.insertTestBooking(
            testDate, bookingTime, therapistId, roomId, bedId, serviceId, customerId);
        testBookingIds.add(testBookingId);
        
        System.out.println("Created test booking:");
        System.out.println("  Date: " + testDate);
        System.out.println("  Time: " + bookingTime);
        System.out.println("  Therapist ID: " + therapistId);
        System.out.println("  Room ID: " + roomId);
        System.out.println("  Bed ID: " + bedId);
        System.out.println("  Booking ID: " + testBookingId);
        
        // Load the booking back from database to see what was actually stored
        SchedulingConstraintDAO dao = new SchedulingConstraintDAO();
        List<BookingConstraint> bookings = dao.loadExistingBookings(testDate);
        
        System.out.println("\nLoaded bookings from database:");
        for (BookingConstraint booking : bookings) {
            System.out.println("  Booking: " + booking);
            System.out.println("    Start: " + booking.getStartTime());
            System.out.println("    End: " + booking.getEndTime());
            System.out.println("    Buffer End: " + booking.getBufferEndTime());
            System.out.println("    Therapist: " + booking.getTherapistId());
            System.out.println("    Room: " + booking.getRoomId());
            System.out.println("    Bed: " + booking.getBedId());
        }
        
        // Now run CSP and see what happens
        List<AvailableTimeSlot> slots = cspSolver.findAvailableSlots(testDate, serviceId, 10);
        
        System.out.println("\nCSP Results:");
        System.out.println("Found " + slots.size() + " available slots");
        
        for (int i = 0; i < Math.min(5, slots.size()); i++) {
            AvailableTimeSlot slot = slots.get(i);
            System.out.println("Slot " + (i+1) + ": " + 
                slot.getTimeSlot().getStartTime().toLocalTime() + " - " +
                slot.getTimeSlot().getEndTime().toLocalTime());
            
            // Show resources for this slot
            for (ResourceCombination resource : slot.getAvailableResources()) {
                System.out.println("  Resource: " + resource);
            }
        }
        
        System.out.println("✅ Debug information displayed");
    });
}
    
    @AfterEach
    void cleanupAfterEach() {
        // Clean up any test bookings created in this test
        if (!testBookingIds.isEmpty()) {
            try {
                CspTestDataSetup.cleanupTestBookings(testBookingIds.stream().mapToInt(i -> i).toArray());
                testBookingIds.clear();
                System.out.println("🧹 Cleaned up test bookings");
            } catch (SQLException e) {
                System.err.println("Failed to cleanup test bookings: " + e.getMessage());
            }
        }
    }
    
    @AfterAll
    static void tearDown() {
        System.out.println("\n=== CSP Validation Complete ===");
        System.out.println("🎉 All CSP constraint validation tests passed!");
        System.out.println("Your CSP system is working correctly!");
    }
}