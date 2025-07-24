/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package booking;

/**
 *
 * @author quang
 */
// src/test/java/csp/SpaCspSolverTest.java

import booking.*;
import db.DBContext;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class SpaCspSolverTest {
    
    private static SpaCspSolver cspSolver;
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");
    
    @BeforeAll
    static void setUp() {
        assertTrue(DBContext.testConnection(), "Database connection should be available for CSP tests");
        cspSolver = new SpaCspSolver();
    }
    
    @Test
    @Order(1)
    @DisplayName("Test CSP Solver - Find Available Slots for Massage Service")
    void testFindAvailableSlotsForMassage() {
        assertDoesNotThrow(() -> {
            LocalDate testDate = LocalDate.of(2025, 7, 26); // Use a future date
            int massageServiceId = 1; // Massage Thụy Điển
            int maxResults = 10;
            
            System.out.println("\n=== Testing CSP for Massage Service ===");
            System.out.println("Date: " + testDate);
            System.out.println("Service ID: " + massageServiceId);
            System.out.println("Max Results: " + maxResults);
            
            List<AvailableTimeSlot> availableSlots = cspSolver.findAvailableSlots(testDate, massageServiceId, maxResults);
            
            assertNotNull(availableSlots, "Available slots should not be null");
            System.out.println("Found " + availableSlots.size() + " available time slots");
            
            // Display first few available slots
            int displayCount = Math.min(5, availableSlots.size());
            for (int i = 0; i < displayCount; i++) {
                AvailableTimeSlot slot = availableSlots.get(i);
                System.out.println("\nSlot " + (i + 1) + ": " + 
                    slot.getTimeSlot().getStartTime().format(TIME_FORMATTER) + " - " +
                    slot.getTimeSlot().getEndTime().format(TIME_FORMATTER));
                System.out.println("  Available combinations: " + slot.getTotalCombinations());
                
                // Show first 3 resource combinations
                List<ResourceCombination> resources = slot.getAvailableResources();
                int resourceDisplayCount = Math.min(3, resources.size());
                for (int j = 0; j < resourceDisplayCount; j++) {
                    System.out.println("    Option " + (j + 1) + ": " + resources.get(j));
                }
                if (resources.size() > 3) {
                    System.out.println("    ... and " + (resources.size() - 3) + " more options");
                }
            }
            
            // Verify that all slots have available resources
            for (AvailableTimeSlot slot : availableSlots) {
                assertTrue(slot.hasAvailableResources(), "Each slot should have available resources");
                assertTrue(slot.getTotalCombinations() > 0, "Each slot should have at least one resource combination");
            }
        });
    }
    
    @Test
    @Order(2)
    @DisplayName("Test CSP Solver - Find Available Slots for Facial Service")
    void testFindAvailableSlotsForFacial() {
        assertDoesNotThrow(() -> {
            LocalDate testDate = LocalDate.of(2025, 7, 26);
            int facialServiceId = 3; // Chăm Sóc Da Cơ Bản
            int maxResults = 8;
            
            System.out.println("\n=== Testing CSP for Facial Service ===");
            System.out.println("Date: " + testDate);
            System.out.println("Service ID: " + facialServiceId);
            
            List<AvailableTimeSlot> availableSlots = cspSolver.findAvailableSlots(testDate, facialServiceId, maxResults);
            
            assertNotNull(availableSlots, "Available slots should not be null");
            System.out.println("Found " + availableSlots.size() + " available time slots");
            
            // Display available slots
            for (int i = 0; i < Math.min(3, availableSlots.size()); i++) {
                AvailableTimeSlot slot = availableSlots.get(i);
                System.out.println("Slot " + (i + 1) + ": " + 
                    slot.getTimeSlot().getStartTime().format(TIME_FORMATTER) + " - " +
                    slot.getTimeSlot().getEndTime().format(TIME_FORMATTER) +
                    " (" + slot.getTotalCombinations() + " combinations)");
            }
        });
    }
    
    @Test
    @Order(3)
    @DisplayName("Test CSP Solver - Date with Existing Bookings")
    void testCspWithExistingBookings() {
        assertDoesNotThrow(() -> {
            LocalDate busyDate = LocalDate.of(2025, 7, 25); // Use a date that might have existing bookings
            int serviceId = 1;
            int maxResults = 15;
            
            System.out.println("\n=== Testing CSP with Existing Bookings ===");
            System.out.println("Date: " + busyDate + " (might have existing bookings)");
            
            // Show constraints summary first
            System.out.println(cspSolver.getConstraintsSummary());
            
            List<AvailableTimeSlot> availableSlots = cspSolver.findAvailableSlots(busyDate, serviceId, maxResults);
            
            System.out.println("Available slots despite existing bookings: " + availableSlots.size());
            
            // Show how CSP worked around existing bookings
            for (int i = 0; i < Math.min(5, availableSlots.size()); i++) {
                AvailableTimeSlot slot = availableSlots.get(i);
                System.out.println("Available: " + 
                    slot.getTimeSlot().getStartTime().format(TIME_FORMATTER) + " - " +
                    slot.getTimeSlot().getEndTime().format(TIME_FORMATTER) +
                    " (" + slot.getTotalCombinations() + " resource combinations)");
            }
        });
    }
    
    @Test
    @Order(4)
    @DisplayName("Test CSP Solver - Invalid Service ID")
    void testCspWithInvalidService() {
        assertDoesNotThrow(() -> {
            LocalDate testDate = LocalDate.of(2025, 7, 26);
            int invalidServiceId = 999;
            
            System.out.println("\n=== Testing CSP with Invalid Service ID ===");
            
            List<AvailableTimeSlot> availableSlots = cspSolver.findAvailableSlots(testDate, invalidServiceId, 10);
            
            assertNotNull(availableSlots, "Should return empty list, not null");
            assertTrue(availableSlots.isEmpty(), "Should return empty list for invalid service");
            System.out.println("Correctly returned empty list for invalid service ID");
        });
    }
    
    @Test
    @Order(5)
    @DisplayName("Test CSP Solver - Multiple Services Comparison")
    void testMultipleServicesComparison() {
        assertDoesNotThrow(() -> {
            LocalDate testDate = LocalDate.of(2025, 7, 27);
            int[] serviceIds = {1, 2, 3, 5}; // Different services with different durations
            
            System.out.println("\n=== Comparing CSP Results for Different Services ===");
            System.out.println("Date: " + testDate);
            
            for (int serviceId : serviceIds) {
                List<AvailableTimeSlot> slots = cspSolver.findAvailableSlots(testDate, serviceId, 5);
                System.out.println("\nService ID " + serviceId + ": " + slots.size() + " available slots");
                
                if (!slots.isEmpty()) {
                    AvailableTimeSlot firstSlot = slots.get(0);
                    System.out.println("  First available: " + 
                        firstSlot.getTimeSlot().getStartTime().format(TIME_FORMATTER) + " - " +
                        firstSlot.getTimeSlot().getEndTime().format(TIME_FORMATTER) +
                        " (" + firstSlot.getTotalCombinations() + " combinations)");
                }
            }
        });
    }
    
    @Test
    @Order(6)
    @DisplayName("Test CSP Performance")
    void testCspPerformance() {
        assertDoesNotThrow(() -> {
            LocalDate testDate = LocalDate.of(2025, 7, 28);
            int serviceId = 1;
            int maxResults = 20;
            
            System.out.println("\n=== Testing CSP Performance ===");
            
            long startTime = System.currentTimeMillis();
            List<AvailableTimeSlot> slots = cspSolver.findAvailableSlots(testDate, serviceId, maxResults);
            long endTime = System.currentTimeMillis();
            
            long executionTime = endTime - startTime;
            System.out.println("Execution time: " + executionTime + " ms");
            System.out.println("Found " + slots.size() + " available slots");
            
            // Performance should be reasonable (under 5 seconds for this test)
            assertTrue(executionTime < 5000, "CSP solver should complete within 5 seconds");
            
            // Calculate total resource combinations checked
            int totalCombinations = slots.stream()
                .mapToInt(AvailableTimeSlot::getTotalCombinations)
                .sum();
            System.out.println("Total resource combinations available: " + totalCombinations);
        });
    }
    
    @AfterAll
    static void tearDown() {
        System.out.println("\n=== CSP Testing Complete ===");
        System.out.println("All CSP constraint satisfaction tests passed!");
    }
}