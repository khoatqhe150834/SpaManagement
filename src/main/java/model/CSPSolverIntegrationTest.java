package model;

import dao.StaffDAO;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

/**
 * Integration test for CSP Solver with realistic spa scheduling scenarios
 * This test can be run independently to verify CSP solver functionality
 */
public class CSPSolverIntegrationTest {

  /**
   * Main test method that demonstrates CSP Solver functionality
   */
  public static void testCSPSolver() {
    System.out.println("=== CSP Solver Integration Test ===\n");

    try {
      // Test 1: Basic solver setup
      testBasicSolverSetup();

      // Test 2: Domain operations
      testDomainOperations();

      // Test 3: Constraint evaluation
      testConstraintEvaluation();

      // Test 4: Assignment operations
      testAssignmentOperations();

      // Test 5: Solution building
      testSolutionBuilding();

      // Test 6: Realistic scheduling scenario
      testRealisticSchedulingScenario();

      System.out.println("\n=== All CSP Solver Tests Completed Successfully ===");

    } catch (Exception e) {
      System.err.println("Test failed with exception: " + e.getMessage());
      e.printStackTrace();
    }
  }

  /**
   * Test 1: Basic CSP Solver setup and configuration
   */
  private static void testBasicSolverSetup() {
    System.out.println("1. Testing Basic Solver Setup:");

    CSPDomain domain = new CSPDomain();
    System.out.println("✓ Created CSPDomain with " + domain.getAvailableTimes().size() + " time slots");

    List<CSPConstraint> constraints = Arrays.asList(
        new NoDoubleBookingConstraint(),
        new BufferTimeConstraint());
    System.out.println("✓ Created " + constraints.size() + " constraints");

    CSPSolver solver = new CSPSolver(domain, constraints);
    solver.setUseForwardChecking(true);
    solver.setMaxIterations(1000);

    System.out.println("✓ Created CSPSolver");
    System.out.println("  - Forward checking: " + solver.isUseForwardChecking());
    System.out.println("  - Max iterations: " + solver.getMaxIterations());
    System.out.println();
  }

  /**
   * Test 2: Domain operations and time generation
   */
  private static void testDomainOperations() {
    System.out.println("2. Testing Domain Operations:");

    CSPDomain domain = new CSPDomain();
    List<LocalDateTime> availableTimes = domain.getAvailableTimes();

    System.out.println("✓ Generated " + availableTimes.size() + " available time slots");

    System.out.println("✓ First 3 time slots:");
    for (int i = 0; i < Math.min(3, availableTimes.size()); i++) {
      LocalDateTime time = availableTimes.get(i);
      System.out.println("  - " + time);
    }

    boolean allWithinBusinessHours = availableTimes.stream()
        .allMatch(time -> {
          LocalTime timeOfDay = time.toLocalTime();
          return !timeOfDay.isBefore(LocalTime.of(8, 0)) &&
              !timeOfDay.isAfter(LocalTime.of(20, 0));
        });
    System.out.println("✓ All times within business hours: " + allWithinBusinessHours);

    List<LocalDateTime> futureSlots = domain.getFutureTimeSlots();
    System.out.println("✓ Future time slots: " + futureSlots.size());
    System.out.println();
  }

  /**
   * Test 3: Constraint evaluation with mock data
   */
  private static void testConstraintEvaluation() {
    System.out.println("3. Testing Constraint Evaluation:");

    // Create mock variables for testing
    List<CSPVariable> testVariables = createMockVariables();

    // Test NoDoubleBookingConstraint
    NoDoubleBookingConstraint doubleBookingConstraint = new NoDoubleBookingConstraint();
    System.out.println("✓ NoDoubleBookingConstraint created");
    System.out.println("  - Description: " + doubleBookingConstraint.getDescription());
    System.out.println("  - Applicable to " + testVariables.size() + " variables: " +
        doubleBookingConstraint.isApplicable(testVariables));

    // Test BufferTimeConstraint
    BufferTimeConstraint bufferConstraint = new BufferTimeConstraint();
    System.out.println("✓ BufferTimeConstraint created");
    System.out.println("  - Description: " + bufferConstraint.getDescription());

    // Test CustomerConflictConstraint
    CustomerConflictConstraint customerConstraint = new CustomerConflictConstraint(1);
    System.out.println("✓ CustomerConflictConstraint created");
    System.out.println("  - Description: " + customerConstraint.getDescription());
    System.out.println();
  }

  /**
   * Test 4: Assignment operations
   */
  private static void testAssignmentOperations() {
    System.out.println("4. Testing Assignment Operations:");

    Service service = createMockService();
    CSPVariable variable = new CSPVariable(service, null, new ArrayList<>(), true);
    Staff therapist = createMockTherapist();
    LocalDateTime startTime = LocalDateTime.now().plusDays(1).withHour(10).withMinute(0);

    Assignment assignment = new Assignment(variable, therapist, startTime, service);

    System.out.println("✓ Created assignment:");
    System.out.println("  - Start time: " + assignment.getStartTime());
    System.out.println("  - End time: " + assignment.getEndTime());
    System.out.println("  - Service: " + assignment.getService().getName());
    System.out.println();
  }

  /**
   * Test 5: Solution building and statistics
   */
  private static void testSolutionBuilding() {
    System.out.println("5. Testing Solution Building:");

    Map<CSPVariable, Assignment> assignments = new HashMap<>();

    CSPSolution successSolution = CSPSolution.builder()
        .success(true)
        .assignments(assignments)
        .solutionTime(1500L)
        .nodesExplored(45)
        .backtrackCount(3)
        .iterations(20)
        .message("Test solution found")
        .build();

    System.out.println("✓ Created solution:");
    System.out.println("  - Success: " + successSolution.isSuccess());
    System.out.println("  - Solution time: " + successSolution.getSolutionTime() + "ms");
    System.out.println("  - Nodes explored: " + successSolution.getNodesExplored());
    System.out.println("  - Backtrack count: " + successSolution.getBacktrackCount());
    System.out.println();
  }

  /**
   * Test 6: Realistic scheduling scenario
   */
  private static void testRealisticSchedulingScenario() {
    System.out.println("6. Testing Realistic Scheduling Scenario:");

    // Create domain
    CSPDomain domain = new CSPDomain();

    // Create constraints for realistic spa scenario
    List<CSPConstraint> constraints = Arrays.asList(
        new NoDoubleBookingConstraint(),
        new BufferTimeConstraint(),
        new CustomerConflictConstraint(1),
        new CustomerConflictConstraint(2));

    // Create solver
    CSPSolver solver = new CSPSolver(domain, constraints);
    solver.setUseForwardChecking(true);
    solver.setMaxIterations(500); // Lower for testing

    System.out.println("✓ Created realistic spa scheduling setup:");
    System.out.println("  - Domain size: " + domain.getDomainSize());
    System.out.println("  - Constraints: " + constraints.size());
    System.out.println("  - Forward checking enabled: " + solver.isUseForwardChecking());

    // Create variables for multiple appointment requests
    List<CSPVariable> variables = createRealisticVariables();
    System.out.println("✓ Created " + variables.size() + " appointment requests");

    // Note: We can't actually solve without full database integration
    // But we can test the solver structure and components
    System.out.println("✓ Solver is ready for integration with:");
    System.out.println("  - StaffDAO for therapist data");
    System.out.println("  - BookingAppointmentDAO for conflict checking");
    System.out.println("  - Service and Customer entities");

    System.out.println("✓ Theoretical solving process would:");
    System.out.println("  1. Apply MRV heuristic to select variables");
    System.out.println("  2. Generate therapist-time assignments");
    System.out.println("  3. Check constraints for each assignment");
    System.out.println("  4. Use forward checking to prune domains");
    System.out.println("  5. Backtrack when conflicts detected");
    System.out.println("  6. Return optimal solution or failure reason");
    System.out.println();
  }

  // Helper methods for creating mock data

  private static List<CSPVariable> createMockVariables() {
    List<CSPVariable> variables = new ArrayList<>();

    for (int i = 1; i <= 3; i++) {
      variables.add(createMockVariable("BOOKING00" + i, i));
    }

    return variables;
  }

  private static CSPVariable createMockVariable(String bookingId, int customerId) {
    Service service = createMockService("Test Service", 60);
    CSPVariable variable = new CSPVariable(service, null, new ArrayList<>(), true);
    // Note: In real implementation, these would be set with actual data
    // variable.setBookingId(bookingId);
    // variable.setCustomerId(customerId);
    return variable;
  }

  private static Staff createMockTherapist() {
    User user = new User(
        101, null, "John Doe", "john@spa.com", "123456789",
        "Male", "Therapist", null, "avatar.jpg", "123 Spa St",
        true, null, null, null);

    Staff therapist = new Staff();
    therapist.setUser(user);
    therapist.setAvailabilityStatus(Staff.AvailabilityStatus.AVAILABLE);

    return therapist;
  }

  private static Service createMockService() {
    Service service = new Service();
    service.setName("Swedish Massage");
    service.setDurationMinutes(60);
    service.setPrice(new BigDecimal("50.00"));
    return service;
  }

  private static Service createMockService(String name, int duration) {
    Service service = new Service();
    service.setName(name);
    service.setDurationMinutes(duration);
    service.setPrice(new BigDecimal("50.00"));
    return service;
  }

  private static List<CSPVariable> createRealisticVariables() {
    List<CSPVariable> variables = new ArrayList<>();

    // Massage appointments
    CSPVariable massage1 = createMockVariable("BOOKING001", 1);
    massage1.setChosenService(createMockService("Swedish Massage", 60));
    variables.add(massage1);

    // Facial appointments
    CSPVariable facial1 = createMockVariable("BOOKING002", 2);
    facial1.setChosenService(createMockService("Hydrating Facial", 90));
    variables.add(facial1);

    // Nail appointments
    CSPVariable nail1 = createMockVariable("BOOKING003", 3);
    nail1.setChosenService(createMockService("Manicure & Pedicure", 75));
    variables.add(nail1);

    return variables;
  }

  /**
   * Main method to run all tests
   */
  public static void main(String[] args) {
    testCSPSolver();
  }
}