package model;

import dao.BookingAppointmentDAO;
import dao.ServiceDAO;
import dao.StaffDAO;
import model.constraint.BufferTimeConstraint;
import model.constraint.CustomerConflictConstraint;
import model.constraint.NoDoubleBookingConstraint;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Comprehensive test class for CSP Solver with realistic booking scenarios.
 * This class tests the MRV (Minimum Remaining Values) heuristic with actual
 * database data.
 */
public class CSPAvailabilityTest {

  // Test scenarios
  public static void main(String[] args) {
    System.out.println("=== CSP Solver Availability Test ===");
    System.out.println("Testing with realistic booking data for next 10 days\n");

    try {
      // Test different scenarios
      testFindAvailableSlotForSingleService();
      testFindAvailableSlotForMultipleServices();
      testOptimizeExistingBooking();
      testBusyDayOptimization();
      testCustomerPreferredTherapist();
      testLastMinuteBooking();
      testVIPCustomerPriority();

    } catch (Exception e) {
      System.err.println("Error during testing: " + e.getMessage());
      e.printStackTrace();
    }
  }

  /**
   * Test 1: Find available slot for a single service
   */
  public static void testFindAvailableSlotForSingleService() {
    System.out.println("--- Test 1: Single Service Booking ---");

    try {
      CSPDomain domain = new CSPDomain();

      // Scenario: Customer wants a Massage Thụy Điển (Service ID: 1) tomorrow
      LocalDate targetDate = LocalDate.now().plusDays(1);
      Service massageService = createMockService(1, "Massage Thụy Điển", 60);

      // Create CSP variable for this booking request
      CSPVariable bookingRequest = new CSPVariable(
          101, // New customer ID
          massageService,
          targetDate,
          null, // No preferred therapist
          null // No preferred time
      );

      List<CSPVariable> variables = Arrays.asList(bookingRequest);

      // Create constraints
      List<CSPConstraint> constraints = Arrays.asList(
          new NoDoubleBookingConstraint(),
          new CustomerConflictConstraint(101),
          new BufferTimeConstraint());

      // Create and configure solver
      CSPSolver solver = new CSPSolver(domain, constraints);
      solver.setMaxIterations(1000);
      solver.setVerbose(true);

      // Solve
      System.out.println("Finding available slot for Massage Thụy Điển on " + targetDate);
      long startTime = System.currentTimeMillis();
      CSPSolution solution = solver.solve(variables);
      long endTime = System.currentTimeMillis();

      // Display results
      displaySolutionResults("Single Service Booking", solution, endTime - startTime);

    } catch (Exception e) {
      System.err.println("Error in testFindAvailableSlotForSingleService: " + e.getMessage());
      e.printStackTrace();
    }

    System.out.println();
  }

  /**
   * Test 2: Find available slots for multiple services (combo booking)
   */
  public static void testFindAvailableSlotForMultipleServices() {
    System.out.println("--- Test 2: Multiple Services Combo Booking ---");

    try {
      CSPDomain domain = new CSPDomain();

      // Scenario: Customer wants a spa combo - Massage + Facial + Manicure
      LocalDate targetDate = LocalDate.now().plusDays(2);

      List<CSPVariable> variables = Arrays.asList(
          new CSPVariable(102, createMockService(2, "Massage Đá Nóng", 90), targetDate, null, null),
          new CSPVariable(102, createMockService(3, "Chăm Sóc Da Cơ Bản", 60), targetDate, null, null),
          new CSPVariable(102, createMockService(27, "Manicure", 45), targetDate, null, null));

      // Create constraints
      List<CSPConstraint> constraints = Arrays.asList(
          new NoDoubleBookingConstraint(),
          new CustomerConflictConstraint(102),
          new BufferTimeConstraint());

      // Create and configure solver
      CSPSolver solver = new CSPSolver(domain, constraints);
      solver.setMaxIterations(2000);
      solver.setVerbose(true);

      // Solve
      System.out.println("Finding available slots for combo booking on " + targetDate);
      long startTime = System.currentTimeMillis();
      CSPSolution solution = solver.solve(variables);
      long endTime = System.currentTimeMillis();

      // Display results
      displaySolutionResults("Multiple Services Combo", solution, endTime - startTime);

    } catch (Exception e) {
      System.err.println("Error in testFindAvailableSlotForMultipleServices: " + e.getMessage());
      e.printStackTrace();
    }

    System.out.println();
  }

  /**
   * Test 3: Optimize existing booking with constraints
   */
  public static void testOptimizeExistingBooking() {
    System.out.println("--- Test 3: Existing Booking Optimization ---");

    try {
      CSPDomain domain = new CSPDomain();

      // Scenario: Customer wants to reschedule multiple services to minimize gaps
      LocalDate targetDate = LocalDate.now().plusDays(3);

      List<CSPVariable> variables = Arrays.asList(
          new CSPVariable(103, createMockService(1, "Massage Thụy Điển", 60), targetDate,
              Arrays.asList(3, 16), // Preferred therapists
              LocalTime.of(14, 0)), // Preferred time
          new CSPVariable(103, createMockService(6, "Gội Đầu Thảo Dược", 60), targetDate,
              Arrays.asList(15, 19),
              LocalTime.of(15, 30)),
          new CSPVariable(103, createMockService(28, "Pedicure Deluxe", 75), targetDate,
              Arrays.asList(15),
              LocalTime.of(17, 0)));

      // Create constraints
      List<CSPConstraint> constraints = Arrays.asList(
          new NoDoubleBookingConstraint(),
          new CustomerConflictConstraint(103),
          new BufferTimeConstraint());

      // Create and configure solver with optimization
      CSPSolver solver = new CSPSolver(domain, constraints);
      solver.setMaxIterations(1500);
      solver.setOptimizeForMinimalGaps(true);
      solver.setVerbose(true);

      // Solve
      System.out.println("Optimizing booking schedule for customer 103 on " + targetDate);
      long startTime = System.currentTimeMillis();
      CSPSolution solution = solver.solve(variables);
      long endTime = System.currentTimeMillis();

      // Display results
      displaySolutionResults("Booking Optimization", solution, endTime - startTime);

    } catch (Exception e) {
      System.err.println("Error in testOptimizeExistingBooking: " + e.getMessage());
      e.printStackTrace();
    }

    System.out.println();
  }

  /**
   * Test 4: Handle busy day with limited availability
   */
  public static void testBusyDayOptimization() {
    System.out.println("--- Test 4: Busy Day Optimization ---");

    try {
      CSPDomain domain = new CSPDomain();

      // Scenario: Multiple customers want services on a busy day (Day 6)
      LocalDate busyDate = LocalDate.now().plusDays(6);

      List<CSPVariable> variables = Arrays.asList(
          new CSPVariable(201, createMockService(1, "Massage Thụy Điển", 60), busyDate, null, null),
          new CSPVariable(202, createMockService(2, "Massage Đá Nóng", 90), busyDate, null, null),
          new CSPVariable(203, createMockService(7, "Massage Thái", 90), busyDate, null, null),
          new CSPVariable(204, createMockService(3, "Chăm Sóc Da", 60), busyDate, null, null),
          new CSPVariable(205, createMockService(8, "Massage Shiatsu", 75), busyDate, null, null));

      // Create constraints
      List<CSPConstraint> constraints = Arrays.asList(
          new NoDoubleBookingConstraint(),
          new BufferTimeConstraint());

      // Create and configure solver
      CSPSolver solver = new CSPSolver(domain, constraints);
      solver.setMaxIterations(3000);
      solver.setVerbose(true);

      // Solve
      System.out.println("Finding slots for 5 customers on busy day: " + busyDate);
      long startTime = System.currentTimeMillis();
      CSPSolution solution = solver.solve(variables);
      long endTime = System.currentTimeMillis();

      // Display results
      displaySolutionResults("Busy Day Optimization", solution, endTime - startTime);

    } catch (Exception e) {
      System.err.println("Error in testBusyDayOptimization: " + e.getMessage());
      e.printStackTrace();
    }

    System.out.println();
  }

  /**
   * Test 5: Customer with preferred therapist
   */
  public static void testCustomerPreferredTherapist() {
    System.out.println("--- Test 5: Customer Preferred Therapist ---");

    try {
      CSPDomain domain = new CSPDomain();

      // Scenario: VIP customer wants specific therapist
      LocalDate targetDate = LocalDate.now().plusDays(4);

      CSPVariable vipBooking = new CSPVariable(
          1, // VIP Customer ID from database
          createMockService(2, "Massage Đá Nóng VIP", 90),
          targetDate,
          Arrays.asList(3), // Only wants therapist ID 3 (Lê Minh Cường)
          LocalTime.of(10, 0) // Preferred morning time
      );

      List<CSPVariable> variables = Arrays.asList(vipBooking);

      // Create constraints
      List<CSPConstraint> constraints = Arrays.asList(
          new NoDoubleBookingConstraint(),
          new CustomerConflictConstraint(1),
          new BufferTimeConstraint());

      // Create and configure solver
      CSPSolver solver = new CSPSolver(domain, constraints);
      solver.setMaxIterations(1000);
      solver.setVerbose(true);

      // Solve
      System.out.println("Finding slot for VIP customer with preferred therapist on " + targetDate);
      long startTime = System.currentTimeMillis();
      CSPSolution solution = solver.solve(variables);
      long endTime = System.currentTimeMillis();

      // Display results
      displaySolutionResults("VIP Customer Preferred Therapist", solution, endTime - startTime);

    } catch (Exception e) {
      System.err.println("Error in testCustomerPreferredTherapist: " + e.getMessage());
      e.printStackTrace();
    }

    System.out.println();
  }

  /**
   * Test 6: Last minute booking
   */
  public static void testLastMinuteBooking() {
    System.out.println("--- Test 6: Last Minute Booking ---");

    try {
      CSPDomain domain = new CSPDomain();

      // Scenario: Customer needs urgent appointment today/tomorrow
      LocalDate urgentDate = LocalDate.now().plusDays(1);

      List<CSPVariable> variables = Arrays.asList(
          new CSPVariable(301, createMockService(1, "Massage Thụy Điển Urgent", 60), urgentDate, null,
              LocalTime.of(18, 0)), // Late evening slot
          new CSPVariable(301, createMockService(3, "Chăm Sóc Da Express", 45), urgentDate, null,
              LocalTime.of(19, 0)) // Even later
      );

      // Create constraints
      List<CSPConstraint> constraints = Arrays.asList(
          new NoDoubleBookingConstraint(),
          new CustomerConflictConstraint(301),
          new BufferTimeConstraint());

      // Create and configure solver
      CSPSolver solver = new CSPSolver(domain, constraints);
      solver.setMaxIterations(1000);
      solver.setVerbose(true);

      // Solve
      System.out.println("Finding last-minute slots for urgent booking on " + urgentDate);
      long startTime = System.currentTimeMillis();
      CSPSolution solution = solver.solve(variables);
      long endTime = System.currentTimeMillis();

      // Display results
      displaySolutionResults("Last Minute Booking", solution, endTime - startTime);

    } catch (Exception e) {
      System.err.println("Error in testLastMinuteBooking: " + e.getMessage());
      e.printStackTrace();
    }

    System.out.println();
  }

  /**
   * Test 7: VIP customer priority booking
   */
  public static void testVIPCustomerPriority() {
    System.out.println("--- Test 7: VIP Customer Priority Booking ---");

    try {
      CSPDomain domain = new CSPDomain();

      // Scenario: VIP customer wants premium services with best therapists
      LocalDate vipDate = LocalDate.now().plusDays(5);

      List<CSPVariable> variables = Arrays.asList(
          new CSPVariable(1, createMockService(2, "Massage Đá Nóng VIP", 90), vipDate,
              Arrays.asList(3, 12), // Top therapists only
              LocalTime.of(9, 0)),
          new CSPVariable(1, createMockService(11, "Điều Trị Nám Premium", 90), vipDate,
              Arrays.asList(4, 13), // Facial specialists
              LocalTime.of(11, 0)),
          new CSPVariable(1, createMockService(8, "Massage Shiatsu VIP", 75), vipDate,
              Arrays.asList(3, 18), // Premium massage therapists
              LocalTime.of(14, 0)));

      // Create constraints
      List<CSPConstraint> constraints = Arrays.asList(
          new NoDoubleBookingConstraint(),
          new CustomerConflictConstraint(1),
          new BufferTimeConstraint());

      // Create and configure solver
      CSPSolver solver = new CSPSolver(domain, constraints);
      solver.setMaxIterations(2000);
      solver.setOptimizeForMinimalGaps(true);
      solver.setVerbose(true);

      // Solve
      System.out.println("Finding premium slots for VIP customer on " + vipDate);
      long startTime = System.currentTimeMillis();
      CSPSolution solution = solver.solve(variables);
      long endTime = System.currentTimeMillis();

      // Display results
      displaySolutionResults("VIP Customer Priority", solution, endTime - startTime);

    } catch (Exception e) {
      System.err.println("Error in testVIPCustomerPriority: " + e.getMessage());
      e.printStackTrace();
    }

    System.out.println();
  }

  /**
   * Display comprehensive solution results
   */
  private static void displaySolutionResults(String testName, CSPSolution solution, long executionTime) {
    System.out.println(">>> " + testName + " Results:");
    System.out.println("Success: " + solution.isSuccess());

    if (solution.isSuccess()) {
      System.out.println("Found " + solution.getAssignmentCount() + " assignments:");

      for (Assignment assignment : solution.getAssignments()) {
        System.out.printf("  - Customer %d: %s with Therapist %d at %s-%s%n",
            assignment.getVariable().getCustomerId(),
            assignment.getVariable().getService().getName(),
            assignment.getTherapist(),
            assignment.getStartTime().format(DateTimeFormatter.ofPattern("HH:mm")),
            assignment.getEndTime().format(DateTimeFormatter.ofPattern("HH:mm")));
      }

      // Performance metrics
      System.out.println("\nPerformance Metrics:");
      System.out.println("  - Execution Time: " + executionTime + " ms");
      System.out.println("  - Solution Time: " + solution.getSolutionTime() + " ms");
      System.out.println("  - Nodes Explored: " + solution.getNodesExplored());
      System.out.println("  - Backtrack Count: " + solution.getBacktrackCount());
      System.out.println("  - Iterations: " + solution.getIterations());

      if (solution.getNodesExplored() > 0) {
        double efficiency = (double) solution.getAssignmentCount() / solution.getNodesExplored() * 100;
        System.out.printf("  - Efficiency Ratio: %.2f%% (assignments/nodes)%n", efficiency);
      }

      // MRV Effectiveness
      if (solution.getBacktrackCount() > 0) {
        double backtrackRatio = (double) solution.getBacktrackCount() / solution.getNodesExplored() * 100;
        System.out.printf("  - Backtrack Ratio: %.2f%% (MRV effectiveness)%n", backtrackRatio);
      }

    } else {
      System.out.println("Failed to find solution: " + solution.getMessage());
      System.out.println("Nodes explored: " + solution.getNodesExplored());
      System.out.println("Backtrack count: " + solution.getBacktrackCount());
    }

    System.out.println();
  }

  /**
   * Create mock service for testing
   */
  private static Service createMockService(int id, String name, int durationMinutes) {
    Service service = new Service();
    service.setServiceId(id);
    service.setName(name);
    service.setDurationMinutes(durationMinutes);
    service.setPrice(500000.0); // Default price
    service.setServiceTypeId(1); // Default service type
    return service;
  }

  /**
   * Run comprehensive performance analysis
   */
  public static void runPerformanceAnalysis() {
    System.out.println("=== CSP Solver Performance Analysis ===");

    try {
      // Test with increasing complexity
      int[] problemSizes = { 1, 3, 5, 7, 10 };

      for (int size : problemSizes) {
        System.out.println("\n--- Testing with " + size + " variables ---");

        CSPDomain domain = new CSPDomain();
        List<CSPVariable> variables = new ArrayList<>();
        LocalDate testDate = LocalDate.now().plusDays(8); // Less busy day

        // Create variables
        for (int i = 0; i < size; i++) {
          variables.add(new CSPVariable(
              400 + i, // Unique customer IDs
              createMockService(1 + (i % 5), "Service " + i, 60),
              testDate,
              null,
              null));
        }

        // Create constraints
        List<CSPConstraint> constraints = Arrays.asList(
            new NoDoubleBookingConstraint(),
            new BufferTimeConstraint());

        // Solve
        CSPSolver solver = new CSPSolver(domain, constraints);
        solver.setMaxIterations(size * 500);

        long startTime = System.currentTimeMillis();
        CSPSolution solution = solver.solve(variables);
        long endTime = System.currentTimeMillis();

        // Results
        System.out.printf("Size %d: %s in %d ms (%d nodes, %d backtracks)%n",
            size,
            solution.isSuccess() ? "SUCCESS" : "FAILED",
            endTime - startTime,
            solution.getNodesExplored(),
            solution.getBacktrackCount());
      }

    } catch (Exception e) {
      System.err.println("Error in performance analysis: " + e.getMessage());
      e.printStackTrace();
    }
  }
}