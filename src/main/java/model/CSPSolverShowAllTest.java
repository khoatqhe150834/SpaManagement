package model;

import dao.StaffDAO;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * Test class for CSPSolver with mock data
 * Tests the getAllValidSlots and getAllValidSlotsGroupedByTherapist methods
 */
public class CSPSolverShowAllTest {

  public static void main(String[] args) {
    System.out.println("=== CSPSolver Show All Slots Test ===");

    try {
      // 1. Create mock data
      System.out.println("1. Creating mock data...");
      MockDataResult mockData = createMockData();

      // 2. Create test domain
      System.out.println("2. Creating test domain...");
      CSPDomain domain = new CSPDomain();
      System.out.println("   Domain created with " + domain.getAvailableTimes().size() + " time slots");

      // 3. Create constraints
      System.out.println("3. Creating constraints...");
      List<CSPConstraint> constraints = createTestConstraints();
      System.out.println("   Created " + constraints.size() + " constraints");

      // 4. Create solver
      System.out.println("4. Creating CSP solver...");
      CSPSolver solver = new CSPSolver(domain, constraints);

      // 5. Test each service
      System.out.println("\n=== Testing Services ===");
      for (Service service : mockData.services) {
        testServiceSlots(solver, service);
        System.out.println(); // Add spacing between services
      }

      // 6. Performance test
      System.out.println("=== Performance Test ===");
      performanceTest(solver, mockData.services.get(0));

    } catch (Exception e) {
      System.err.println("Test failed with error: " + e.getMessage());
      e.printStackTrace();
    }

    System.out.println("\n=== Test Completed ===");
  }

  /**
   * Test slots for a specific service
   */
  private static void testServiceSlots(CSPSolver solver, Service service) {
    System.out.println("--- Testing Service: " + service.getName() + " ---");
    System.out.println("Duration: " + service.getDurationMinutes() + " minutes");
    System.out.println("Service Type ID: " +
        (service.getServiceTypeId() != null ? service.getServiceTypeId().getServiceTypeId() : "N/A"));

    long startTime = System.currentTimeMillis();

    // Test getAllValidSlots
    List<Assignment> allSlots = solver.getAllValidSlots(service);

    long endTime = System.currentTimeMillis();

    System.out.println("Found " + allSlots.size() + " valid slots in " + (endTime - startTime) + "ms");

    if (allSlots.isEmpty()) {
      System.out.println("⚠️  No valid slots found for this service");
      return;
    }

    // Show first 5 slots as sample
    System.out.println("Sample slots (first 5):");
    for (int i = 0; i < Math.min(5, allSlots.size()); i++) {
      Assignment assignment = allSlots.get(i);
      System.out.println("  " + (i + 1) + ". " +
          formatAssignment(assignment));
    }

    // Test grouped by therapist
    Map<Staff, List<LocalDateTime>> groupedSlots = solver.getAllValidSlotsGroupedByTherapist(service);
    System.out.println("Therapists available: " + groupedSlots.size());

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
    System.out.println("Running performance test (10 calls)...");

    long totalTime = 0;
    int totalSlots = 0;
    int calls = 10;

    for (int i = 0; i < calls; i++) {
      long start = System.currentTimeMillis();
      List<Assignment> slots = solver.getAllValidSlots(service);
      long end = System.currentTimeMillis();

      totalTime += (end - start);
      totalSlots += slots.size();
    }

    System.out.println("Average time per call: " + (totalTime / calls) + "ms");
    System.out.println("Average slots found: " + (totalSlots / calls));
    System.out.println("Total time for " + calls + " calls: " + totalTime + "ms");
  }

  /**
   * Create mock data for testing
   */
  private static MockDataResult createMockData() {
    System.out.println("   Creating mock services and service types...");

    // Create mock service types
    List<ServiceType> serviceTypes = Arrays.asList(
        createServiceType(1, "Massage Therapy"),
        createServiceType(2, "Facial Treatment"),
        createServiceType(3, "Manicure/Pedicure"),
        createServiceType(4, "Hair Styling"));

    // Create mock services
    List<Service> services = Arrays.asList(
        createService(1, "Swedish Massage", 60, serviceTypes.get(0)),
        createService(2, "Deep Tissue Massage", 90, serviceTypes.get(0)),
        createService(3, "Anti-Aging Facial", 75, serviceTypes.get(1)),
        createService(4, "Classic Manicure", 45, serviceTypes.get(2)),
        createService(5, "Hair Cut & Style", 60, serviceTypes.get(3)));

    System.out.println("   Created " + services.size() + " mock services");
    return new MockDataResult(services, serviceTypes);
  }

  /**
   * Create test constraints
   */
  private static List<CSPConstraint> createTestConstraints() {
    return Arrays.asList(
        new NoDoubleBookingConstraint(),
        new BufferTimeConstraint()
    // Add more constraints as they become available
    );
  }

  /**
   * Helper method to create mock ServiceType
   */
  private static ServiceType createServiceType(int id, String name) {
    ServiceType serviceType = new ServiceType();
    serviceType.setServiceTypeId(id);
    serviceType.setName(name);
    serviceType.setDescription("Mock " + name + " service type");
    return serviceType;
  }

  /**
   * Helper method to create mock Service
   */
  private static Service createService(int id, String name, int duration, ServiceType serviceType) {
    Service service = new Service();
    service.setServiceId(id);
    service.setName(name);
    service.setDurationMinutes(duration);
    service.setServiceTypeId(serviceType);
    service.setPrice(java.math.BigDecimal.valueOf(50.0 + (duration * 0.5))); // Mock pricing
    service.setDescription("Mock " + name + " service");
    return service;
  }

  /**
   * Format assignment for display
   */
  private static String formatAssignment(Assignment assignment) {
    return String.format("%s at %s (Therapist: %s)",
        assignment.getService().getName(),
        formatDateTime(assignment.getStartTime()),
        getTherapistName(assignment.getTherapist()));
  }

  /**
   * Format date time for display
   */
  private static String formatDateTime(LocalDateTime dateTime) {
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
    return "Therapist ID: " + (therapist.getUser() != null ? therapist.getUser().getUserId() : "Unknown");
  }

  /**
   * Helper class to hold mock data
   */
  private static class MockDataResult {
    final List<Service> services;
    final List<ServiceType> serviceTypes;

    MockDataResult(List<Service> services, List<ServiceType> serviceTypes) {
      this.services = services;
      this.serviceTypes = serviceTypes;
    }
  }
}