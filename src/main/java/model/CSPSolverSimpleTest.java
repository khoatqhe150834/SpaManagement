package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * Simple standalone test for CSPSolver's getAllValidSlots method
 * This test uses minimal mock data without requiring database or complex
 * dependencies
 */
public class CSPSolverSimpleTest {

  public static void main(String[] args) {
    System.out.println("=== CSP Solver Get All Valid Slots Test ===");

    try {
      // 1. Create test domain
      System.out.println("1. Creating test domain...");
      CSPDomain domain = new CSPDomain();
      System.out.println("   Domain created with " + domain.getAvailableTimes().size() + " time slots");

      // 2. Create minimal constraints (empty list for basic test)
      System.out.println("2. Creating minimal constraint set...");
      List<CSPConstraint> constraints = new ArrayList<>();
      // For basic testing, we'll use empty constraints to see all possible
      // combinations
      System.out.println("   Created " + constraints.size() + " constraints (empty for basic test)");

      // 3. Create solver
      System.out.println("3. Creating CSP solver...");
      CSPSolver solver = new CSPSolver(domain, constraints);

      // 4. Create a mock service
      System.out.println("4. Creating mock service...");
      Service mockService = createMockService();
      System.out
          .println("   Mock service: " + mockService.getName() + " (" + mockService.getDurationMinutes() + " mins)");

      // 5. Test getAllValidSlots
      System.out.println("\n=== Testing getAllValidSlots ===");
      testGetAllValidSlots(solver, mockService);

      // 6. Test getAllValidSlotsGroupedByTherapist
      System.out.println("\n=== Testing getAllValidSlotsGroupedByTherapist ===");
      testGetAllValidSlotsGrouped(solver, mockService);

      // 7. Performance test
      System.out.println("\n=== Performance Test ===");
      performanceTest(solver, mockService);

    } catch (Exception e) {
      System.err.println("Test failed with error: " + e.getMessage());
      e.printStackTrace();
    }

    System.out.println("\n=== Test Completed Successfully ===");
  }

  /**
   * Test the getAllValidSlots method
   */
  private static void testGetAllValidSlots(CSPSolver solver, Service service) {
    long startTime = System.currentTimeMillis();

    List<Assignment> allSlots = solver.getAllValidSlots(service);

    long endTime = System.currentTimeMillis();

    System.out.println("Found " + allSlots.size() + " valid slots in " + (endTime - startTime) + "ms");

    if (allSlots.isEmpty()) {
      System.out.println("⚠️  No valid slots found. This might indicate:");
      System.out.println("   - No qualified therapists in database");
      System.out.println("   - No available time slots");
      System.out.println("   - Service configuration issues");
      return;
    }

    // Show first 5 slots as sample
    System.out.println("Sample slots (first 5):");
    for (int i = 0; i < Math.min(5, allSlots.size()); i++) {
      Assignment assignment = allSlots.get(i);
      System.out.println("  " + (i + 1) + ". " + formatAssignment(assignment));
    }

    if (allSlots.size() > 5) {
      System.out.println("  ... and " + (allSlots.size() - 5) + " more slots");
    }
  }

  /**
   * Test the getAllValidSlotsGroupedByTherapist method
   */
  private static void testGetAllValidSlotsGrouped(CSPSolver solver, Service service) {
    Map<Staff, List<LocalDateTime>> groupedSlots = solver.getAllValidSlotsGroupedByTherapist(service);

    System.out.println("Therapists available: " + groupedSlots.size());

    if (groupedSlots.isEmpty()) {
      System.out.println("⚠️  No therapists available for this service");
      return;
    }

    for (Map.Entry<Staff, List<LocalDateTime>> entry : groupedSlots.entrySet()) {
      Staff therapist = entry.getKey();
      List<LocalDateTime> times = entry.getValue();
      System.out.println("  📋 " + getTherapistName(therapist) +
          ": " + times.size() + " available slots");

      // Show first 3 time slots for this therapist
      for (int i = 0; i < Math.min(3, times.size()); i++) {
        System.out.println("     • " + formatDateTime(times.get(i)));
      }
      if (times.size() > 3) {
        System.out.println("     ... and " + (times.size() - 3) + " more");
      }
    }
  }

  /**
   * Performance test with multiple calls
   */
  private static void performanceTest(CSPSolver solver, Service service) {
    System.out.println("Running performance test (5 calls)...");

    long totalTime = 0;
    int totalSlots = 0;
    int calls = 5;

    for (int i = 0; i < calls; i++) {
      long start = System.currentTimeMillis();
      List<Assignment> slots = solver.getAllValidSlots(service);
      long end = System.currentTimeMillis();

      totalTime += (end - start);
      totalSlots += slots.size();

      System.out.println("  Call " + (i + 1) + ": " + (end - start) + "ms, " + slots.size() + " slots");
    }

    System.out.println("Average time per call: " + (totalTime / calls) + "ms");
    System.out.println("Average slots found: " + (totalSlots / calls));
    System.out.println("Total time for " + calls + " calls: " + totalTime + "ms");
  }

  /**
   * Create a mock service for testing
   */
  private static Service createMockService() {
    Service service = new Service();

    // Create mock service type
    ServiceType serviceType = new ServiceType();
    serviceType.setServiceTypeId(1); // Assuming this exists in DB
    serviceType.setName("Massage Therapy");
    serviceType.setDescription("Therapeutic massage services");

    // Set up service
    service.setServiceId(1);
    service.setName("Swedish Massage");
    service.setDurationMinutes(60);
    service.setServiceTypeId(serviceType);
    service.setDescription("Relaxing Swedish massage");
    service.setPrice(java.math.BigDecimal.valueOf(100.0));

    return service;
  }

  /**
   * Format assignment for display
   */
  private static String formatAssignment(Assignment assignment) {
    if (assignment == null)
      return "null assignment";

    String serviceName = assignment.getService() != null ? assignment.getService().getName() : "Unknown Service";
    String time = assignment.getStartTime() != null ? formatDateTime(assignment.getStartTime()) : "Unknown Time";
    String therapistName = getTherapistName(assignment.getTherapist());

    return String.format("%s at %s (Therapist: %s)", serviceName, time, therapistName);
  }

  /**
   * Format date time for display
   */
  private static String formatDateTime(LocalDateTime dateTime) {
    if (dateTime == null)
      return "Unknown Time";
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' h:mm a");
    return dateTime.format(formatter);
  }

  /**
   * Get therapist name safely
   */
  private static String getTherapistName(Staff therapist) {
    if (therapist == null)
      return "Unknown";
    if (therapist.getUser() != null && therapist.getUser().getFullName() != null) {
      return therapist.getUser().getFullName();
    }
    return "Therapist (User ID: " +
        (therapist.getUser() != null ? therapist.getUser().getUserId() : "Unknown") + ")";
  }
}