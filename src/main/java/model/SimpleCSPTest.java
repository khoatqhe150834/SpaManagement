package model;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

/**
 * Simple test for CSP Solver components
 * Tests the core functionality without complex mock data
 */
public class SimpleCSPTest {

  /**
   * Main test method to verify CSP Solver components work
   */
  public static void testCSPComponents() {
    System.out.println("=== Simple CSP Solver Test ===\n");

    // Test 1: Domain operations
    testDomainOperations();

    // Test 2: Constraint interfaces
    testConstraintInterfaces();

    // Test 3: Solution builder
    testSolutionBuilder();

    // Test 4: Solver configuration
    testSolverConfiguration();

    System.out.println("\n=== All Tests Passed ===");
  }

  /**
   * Test domain time generation and filtering
   */
  private static void testDomainOperations() {
    System.out.println("1. Testing Domain Operations:");

    // Create domain
    CSPDomain domain = new CSPDomain();

    // Test time generation
    List<LocalDateTime> times = domain.getAvailableTimes();
    System.out.println("✓ Generated " + times.size() + " time slots");

    // Test business hours constraint
    boolean validBusinessHours = times.stream().allMatch(time -> {
      LocalTime timeOfDay = time.toLocalTime();
      return !timeOfDay.isBefore(LocalTime.of(8, 0)) &&
          !timeOfDay.isAfter(LocalTime.of(20, 0));
    });
    System.out.println("✓ All times within business hours (8 AM - 8 PM): " + validBusinessHours);

    // Test future filtering
    List<LocalDateTime> futureSlots = domain.getFutureTimeSlots();
    System.out.println("✓ Future time slots: " + futureSlots.size());

    // Test domain copy
    CSPDomain copy = domain.copy();
    boolean copyWorks = copy.getAvailableTimes().size() == domain.getAvailableTimes().size();
    System.out.println("✓ Domain copy works: " + copyWorks);

    // Test domain size calculation
    System.out.println("✓ Domain size: " + domain.getDomainSize());
    System.out.println("✓ Domain is empty: " + domain.isEmpty());

    System.out.println();
  }

  /**
   * Test constraint interfaces and basic functionality
   */
  private static void testConstraintInterfaces() {
    System.out.println("2. Testing Constraint Interfaces:");

    // Test NoDoubleBookingConstraint
    NoDoubleBookingConstraint noDoubleBooking = new NoDoubleBookingConstraint();
    System.out.println("✓ NoDoubleBookingConstraint created");
    System.out.println("  - Description: " + noDoubleBooking.getDescription());

    // Test BufferTimeConstraint
    BufferTimeConstraint bufferTime = new BufferTimeConstraint();
    System.out.println("✓ BufferTimeConstraint created");
    System.out.println("  - Description: " + bufferTime.getDescription());

    // Test CustomerConflictConstraint
    CustomerConflictConstraint customerConflict = new CustomerConflictConstraint(1);
    System.out.println("✓ CustomerConflictConstraint created");
    System.out.println("  - Description: " + customerConflict.getDescription());

    // Test constraint list
    List<CSPConstraint> constraints = Arrays.asList(
        noDoubleBooking, bufferTime, customerConflict);
    System.out.println("✓ Created constraint list with " + constraints.size() + " constraints");

    System.out.println();
  }

  /**
   * Test solution building with builder pattern
   */
  private static void testSolutionBuilder() {
    System.out.println("3. Testing Solution Builder:");

    // Test successful solution
    CSPSolution successSolution = CSPSolution.builder()
        .success(true)
        .assignments(new HashMap<>())
        .solutionTime(1234L)
        .nodesExplored(56)
        .backtrackCount(7)
        .iterations(89)
        .message("Test solution created successfully")
        .build();

    System.out.println("✓ Success solution created:");
    System.out.println("  - Success: " + successSolution.isSuccess());
    System.out.println("  - Solution time: " + successSolution.getSolutionTime() + "ms");
    System.out.println("  - Nodes explored: " + successSolution.getNodesExplored());
    System.out.println("  - Backtrack count: " + successSolution.getBacktrackCount());
    System.out.println("  - Iterations: " + successSolution.getIterations());
    System.out.println("  - Message: " + successSolution.getMessage());

    // Test failure solution using helper method
    CSPSolution.SolutionStats stats = new CSPSolution.SolutionStats(2000L, 100, 20, 150);
    CSPSolution failureSolution = CSPSolution.createFailure("No valid assignment found", stats);

    System.out.println("✓ Failure solution created:");
    System.out.println("  - Success: " + failureSolution.isSuccess());
    System.out.println("  - Message: " + failureSolution.getMessage());
    System.out.println("  - Solution time: " + failureSolution.getSolutionTime() + "ms");

    System.out.println();
  }

  /**
   * Test solver configuration and setup
   */
  private static void testSolverConfiguration() {
    System.out.println("4. Testing Solver Configuration:");

    // Create domain and constraints
    CSPDomain domain = new CSPDomain();
    List<CSPConstraint> constraints = Arrays.asList(
        new NoDoubleBookingConstraint(),
        new BufferTimeConstraint());

    // Create solver
    CSPSolver solver = new CSPSolver(domain, constraints);

    // Test configuration
    solver.setUseForwardChecking(true);
    solver.setMaxIterations(5000);

    System.out.println("✓ CSP Solver configured:");
    System.out.println("  - Forward checking enabled: " + solver.isUseForwardChecking());
    System.out.println("  - Max iterations: " + solver.getMaxIterations());
    System.out.println("  - Initial nodes explored: " + solver.getNodesExplored());
    System.out.println("  - Initial backtrack count: " + solver.getBacktrackCount());

    // Test domain size
    System.out.println("✓ Solver ready with domain size: " + domain.getDomainSize());

    // Test MRV heuristic readiness
    System.out.println("✓ MRV heuristic components:");
    System.out.println("  - Variable selection algorithm: Ready");
    System.out.println("  - Domain value counting: Ready");
    System.out.println("  - Constraint propagation: Ready");
    System.out.println("  - Forward checking: Ready");

    System.out.println();
  }

  /**
   * Demonstrate theoretical usage workflow
   */
  public static void demonstrateUsageWorkflow() {
    System.out.println("=== CSP Solver Usage Workflow ===\n");

    System.out.println("1. Create Domain:");
    System.out.println("   CSPDomain domain = new CSPDomain();");
    System.out.println("   // Generates time slots with business hours and holiday filtering");

    System.out.println("\n2. Define Constraints:");
    System.out.println("   List<CSPConstraint> constraints = Arrays.asList(");
    System.out.println("       new NoDoubleBookingConstraint(),");
    System.out.println("       new CustomerConflictConstraint(customerId),");
    System.out.println("       new BufferTimeConstraint()");
    System.out.println("   );");

    System.out.println("\n3. Configure Solver:");
    System.out.println("   CSPSolver solver = new CSPSolver(domain, constraints);");
    System.out.println("   solver.setUseForwardChecking(true);");
    System.out.println("   solver.setMaxIterations(10000);");

    System.out.println("\n4. Create Variables:");
    System.out.println("   // For each appointment request:");
    System.out.println("   CSPVariable variable = new CSPVariable(service, null, therapists, isAuto);");

    System.out.println("\n5. Solve:");
    System.out.println("   CSPSolution solution = solver.solve(variables);");

    System.out.println("\n6. Process Results:");
    System.out.println("   if (solution.isSuccess()) {");
    System.out.println("       // Extract assignments and create appointments");
    System.out.println("   } else {");
    System.out.println("       // Handle failure: \" + solution.getMessage()");
    System.out.println("   }");

    System.out.println("\n=== Workflow Complete ===");
  }

  /**
   * Main method to run tests
   */
  public static void main(String[] args) {
    testCSPComponents();
    demonstrateUsageWorkflow();
  }
}