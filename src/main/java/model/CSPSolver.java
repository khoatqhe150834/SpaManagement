package model;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Constraint Satisfaction Problem Solver for Spa Appointment Scheduling
 * Uses Minimum Remaining Values (MRV) heuristic for variable ordering
 * 
 * The MRV heuristic selects the variable with the fewest legal values
 * remaining,
 * which helps to fail fast and prune the search space early.
 */
public class CSPSolver {

  private CSPDomain globalDomain;
  private List<CSPConstraint> constraints;
  private boolean useForwardChecking;
  private int maxIterations;
  private int currentIterations;

  // Statistics tracking
  private int nodesExplored;
  private int backtrackCount;
  private long startTime;
  private long endTime;

  public CSPSolver(CSPDomain globalDomain, List<CSPConstraint> constraints) {
    this.globalDomain = globalDomain;
    this.constraints = constraints != null ? constraints : new ArrayList<>();
    this.useForwardChecking = true;
    this.maxIterations = 10000;
    this.currentIterations = 0;
    this.nodesExplored = 0;
    this.backtrackCount = 0;
  }

  /**
   * Solve the CSP using backtracking with MRV heuristic
   * 
   * @param variables List of CSP variables to assign values to
   * @return Solution assignment or null if no solution exists
   */
  public CSPSolution solve(List<CSPVariable> variables) {
    startTime = System.currentTimeMillis();
    currentIterations = 0;
    nodesExplored = 0;
    backtrackCount = 0;

    if (variables == null || variables.isEmpty()) {
      return null;
    }

    // Initialize domains for each variable
    Map<CSPVariable, CSPDomain> variableDomains = initializeVariableDomains(variables);

    // Apply initial constraint propagation
    if (useForwardChecking && !propagateConstraints(variables, variableDomains)) {
      return createFailureSolution("Initial constraint propagation failed");
    }

    // Start backtracking search
    Map<CSPVariable, Assignment> solution = new HashMap<>();
    boolean solved = backtrackSearch(variables, variableDomains, solution, 0);

    endTime = System.currentTimeMillis();

    if (solved) {
      return createSuccessSolution(solution);
    } else {
      return createFailureSolution("No solution found within " + maxIterations + " iterations");
    }
  }

  /**
   * Backtracking search with MRV heuristic
   */
  private boolean backtrackSearch(List<CSPVariable> variables,
      Map<CSPVariable, CSPDomain> domains,
      Map<CSPVariable, Assignment> assignment,
      int depth) {

    currentIterations++;
    nodesExplored++;

    if (currentIterations > maxIterations) {
      return false;
    }

    // Check if assignment is complete
    if (assignment.size() == variables.size()) {
      return isConsistent(variables, assignment);
    }

    // Select next variable using MRV heuristic
    CSPVariable nextVariable = selectVariableWithMRV(variables, domains, assignment);

    if (nextVariable == null) {
      return false;
    }

    // Get domain for the selected variable
    CSPDomain currentDomain = domains.get(nextVariable);
    if (currentDomain == null || currentDomain.isEmpty()) {
      backtrackCount++;
      return false;
    }

    // Try each value in the domain
    List<Assignment> possibleAssignments = generateAssignments(nextVariable, currentDomain);

    for (Assignment candidateAssignment : possibleAssignments) {
      // Make assignment
      assignment.put(nextVariable, candidateAssignment);
      nextVariable.setStartTime(candidateAssignment.getStartTime());
      nextVariable.setChosenTherapist(candidateAssignment.getTherapist());

      // Check if assignment is consistent with constraints
      if (isPartialAssignmentConsistent(variables, assignment)) {

        // Forward checking: update domains
        Map<CSPVariable, CSPDomain> newDomains = new HashMap<>(domains);
        if (!useForwardChecking || updateDomainsAfterAssignment(variables, newDomains, assignment)) {

          // Recursive call
          if (backtrackSearch(variables, newDomains, assignment, depth + 1)) {
            return true;
          }
        }
      }

      // Backtrack: remove assignment
      assignment.remove(nextVariable);
      nextVariable.setStartTime(null);
      nextVariable.setChosenTherapist(null);
    }

    backtrackCount++;
    return false;
  }

  /**
   * MRV Heuristic: Select variable with minimum remaining values
   */
  private CSPVariable selectVariableWithMRV(List<CSPVariable> variables,
      Map<CSPVariable, CSPDomain> domains,
      Map<CSPVariable, Assignment> assignment) {

    CSPVariable bestVariable = null;
    int minRemainingValues = Integer.MAX_VALUE;

    for (CSPVariable variable : variables) {
      // Skip already assigned variables
      if (assignment.containsKey(variable)) {
        continue;
      }

      CSPDomain domain = domains.get(variable);
      if (domain == null) {
        continue;
      }

      // Calculate remaining values for this variable
      int remainingValues = calculateRemainingValues(variable, domain, assignment);

      // MRV: choose variable with fewest remaining values
      if (remainingValues < minRemainingValues) {
        minRemainingValues = remainingValues;
        bestVariable = variable;
      }

      // If domain is empty, this variable has no valid assignments
      if (remainingValues == 0) {
        return variable; // Return immediately to fail fast
      }
    }

    return bestVariable;
  }

  /**
   * Calculate remaining valid values for a variable
   */
  private int calculateRemainingValues(CSPVariable variable, CSPDomain domain,
      Map<CSPVariable, Assignment> currentAssignment) {

    List<Assignment> possibleAssignments = generateAssignments(variable, domain);
    int validCount = 0;

    for (Assignment assignment : possibleAssignments) {
      // Temporarily assign and check consistency
      Map<CSPVariable, Assignment> tempAssignment = new HashMap<>(currentAssignment);
      tempAssignment.put(variable, assignment);

      if (isPartialAssignmentConsistent(Arrays.asList(variable), tempAssignment)) {
        validCount++;
      }
    }

    return validCount;
  }

  /**
   * Generate possible assignments for a variable given its domain
   */
  private List<Assignment> generateAssignments(CSPVariable variable, CSPDomain domain) {
    List<Assignment> assignments = new ArrayList<>();

    Service service = variable.getChosenService();
    if (service == null) {
      return assignments;
    }

    List<Staff> availableTherapists = domain.getCompatibleTherapistsForService(variable);
    List<LocalDateTime> availableTimes = domain.getCompatibleTimesForService(variable);

    // Generate all combinations of therapist and time
    for (Staff therapist : availableTherapists) {
      for (LocalDateTime time : availableTimes) {
        assignments.add(new Assignment(variable, therapist, time, service));
      }
    }

    return assignments;
  }

  /**
   * Initialize domains for each variable
   */
  private Map<CSPVariable, CSPDomain> initializeVariableDomains(List<CSPVariable> variables) {
    Map<CSPVariable, CSPDomain> domains = new HashMap<>();

    for (CSPVariable variable : variables) {
      // Each variable gets a copy of the global domain
      domains.put(variable, globalDomain.copy());
    }

    return domains;
  }

  /**
   * Check if partial assignment is consistent with all applicable constraints
   */
  private boolean isPartialAssignmentConsistent(List<CSPVariable> variables,
      Map<CSPVariable, Assignment> assignment) {

    for (CSPConstraint constraint : constraints) {
      List<CSPVariable> assignedVariables = variables.stream()
          .filter(assignment::containsKey)
          .collect(Collectors.toList());

      if (constraint.isApplicable(assignedVariables)) {
        if (!constraint.isSatisfied(assignedVariables)) {
          return false;
        }
      }
    }

    return true;
  }

  /**
   * Check if complete assignment satisfies all constraints
   */
  private boolean isConsistent(List<CSPVariable> variables, Map<CSPVariable, Assignment> assignment) {

    for (CSPConstraint constraint : constraints) {
      if (constraint.isApplicable(variables)) {
        if (!constraint.isSatisfied(variables)) {
          return false;
        }
      }
    }

    return true;
  }

  /**
   * Apply constraint propagation to reduce domains
   */
  private boolean propagateConstraints(List<CSPVariable> variables,
      Map<CSPVariable, CSPDomain> domains) {

    boolean changed = true;
    while (changed) {
      changed = false;

      for (CSPVariable variable : variables) {
        CSPDomain domain = domains.get(variable);
        if (domain == null || domain.isEmpty()) {
          return false;
        }

        // Apply domain reduction based on constraints
        // This is a simplified version - could be enhanced with arc consistency
        List<Assignment> validAssignments = generateAssignments(variable, domain)
            .stream()
            .filter(assignment -> {
              Map<CSPVariable, Assignment> tempAssignment = new HashMap<>();
              tempAssignment.put(variable, assignment);
              return isPartialAssignmentConsistent(Arrays.asList(variable), tempAssignment);
            })
            .collect(Collectors.toList());

        if (validAssignments.isEmpty()) {
          return false;
        }

        // Update domain if it was reduced
        CSPDomain newDomain = createDomainFromAssignments(validAssignments);
        if (newDomain.getDomainSize() < domain.getDomainSize()) {
          domains.put(variable, newDomain);
          changed = true;
        }
      }
    }

    return true;
  }

  /**
   * Update domains after making an assignment (forward checking)
   */
  private boolean updateDomainsAfterAssignment(List<CSPVariable> variables,
      Map<CSPVariable, CSPDomain> domains,
      Map<CSPVariable, Assignment> assignment) {

    // For each unassigned variable, check which domain values are still valid
    for (CSPVariable variable : variables) {
      if (assignment.containsKey(variable)) {
        continue; // Skip assigned variables
      }

      CSPDomain currentDomain = domains.get(variable);
      if (currentDomain == null) {
        continue;
      }

      List<Assignment> validAssignments = generateAssignments(variable, currentDomain)
          .stream()
          .filter(candidateAssignment -> {
            Map<CSPVariable, Assignment> tempAssignment = new HashMap<>(assignment);
            tempAssignment.put(variable, candidateAssignment);
            return isPartialAssignmentConsistent(variables, tempAssignment);
          })
          .collect(Collectors.toList());

      if (validAssignments.isEmpty()) {
        return false; // Domain wipeout
      }

      domains.put(variable, createDomainFromAssignments(validAssignments));
    }

    return true;
  }

  /**
   * Create a domain from a list of valid assignments
   */
  private CSPDomain createDomainFromAssignments(List<Assignment> assignments) {
    Set<Staff> therapists = new HashSet<>();
    Set<LocalDateTime> times = new HashSet<>();

    for (Assignment assignment : assignments) {
      therapists.add(assignment.getTherapist());
      times.add(assignment.getStartTime());
    }

    return new CSPDomain(new ArrayList<>(therapists), new ArrayList<>(times));
  }

  /**
   * Create success solution
   */
  private CSPSolution createSuccessSolution(Map<CSPVariable, Assignment> assignment) {
    return CSPSolution.builder()
        .success(true)
        .assignments(new HashMap<>(assignment))
        .solutionTime(endTime - startTime)
        .nodesExplored(nodesExplored)
        .backtrackCount(backtrackCount)
        .iterations(currentIterations)
        .message("Solution found using MRV heuristic")
        .build();
  }

  /**
   * Create failure solution
   */
  private CSPSolution createFailureSolution(String reason) {
    return CSPSolution.builder()
        .success(false)
        .assignments(new HashMap<>())
        .solutionTime(endTime - startTime)
        .nodesExplored(nodesExplored)
        .backtrackCount(backtrackCount)
        .iterations(currentIterations)
        .message(reason)
        .build();
  }

  // Getters and setters
  public boolean isUseForwardChecking() {
    return useForwardChecking;
  }

  public void setUseForwardChecking(boolean useForwardChecking) {
    this.useForwardChecking = useForwardChecking;
  }

  public int getMaxIterations() {
    return maxIterations;
  }

  public void setMaxIterations(int maxIterations) {
    this.maxIterations = maxIterations;
  }

  public int getNodesExplored() {
    return nodesExplored;
  }

  public int getBacktrackCount() {
    return backtrackCount;
  }

  /**
   * Main method for testing CSPSolver functionality
   */
  public static void main(String[] args) {
    System.out.println("=== Testing CSPSolver with MRV Heuristic ===");

    // Create test domain
    CSPDomain domain = new CSPDomain();
    System.out.println("Created global domain with " + domain.getDomainSize() + " possible combinations");

    // Create constraints
    List<CSPConstraint> constraints = Arrays.asList(
        new NoDoubleBookingConstraint(),
        new BufferTimeConstraint());
    System.out.println("Created " + constraints.size() + " constraints");

    // Create solver
    CSPSolver solver = new CSPSolver(domain, constraints);
    solver.setMaxIterations(5000);
    solver.setUseForwardChecking(true);

    System.out.println("Created CSP solver with:");
    System.out.println("- MRV heuristic for variable ordering");
    System.out.println("- Forward checking: " + solver.isUseForwardChecking());
    System.out.println("- Max iterations: " + solver.getMaxIterations());

    // Note: To fully test, you would need actual CSPVariable instances with
    // services
    // This is a basic structure test

    System.out.println("\n=== CSPSolver Structure Test Completed ===");
    System.out.println("Ready for integration with spa booking system!");
  }

  /**
   * PERFORMANCE OPTIMIZED: Get all valid slots for a service within the next 360
   * days
   * This method uses bulk loading and in-memory conflict checking for massive
   * performance gains
   * 
   * @param service The service to find slots for
   * @return List of valid assignments (therapist-time combinations)
   */
  public List<Assignment> getAllValidSlots(Service service) {
    if (service == null) {
      return new ArrayList<>();
    }

    long startTime = System.currentTimeMillis();

    // Create a CSP variable for this service
    CSPVariable variable = new CSPVariable(service, null, null, true);

    // OPTIMIZATION 1: Bulk load all appointments for qualified therapists
    Map<Integer, List<BookingAppointment>> therapistAppointments = globalDomain.bulkLoadTherapistAppointments(service);

    // Get compatible therapists and times from domain
    List<Staff> availableTherapists = globalDomain.getCompatibleTherapistsForService(variable);
    List<LocalDateTime> availableTimes = globalDomain.getCompatibleTimesForService(variable);

    List<Assignment> validAssignments = new ArrayList<>();
    int totalCombinations = availableTherapists.size() * availableTimes.size();
    int validCombinations = 0;

    System.out.println("🚀 OPTIMIZED getAllValidSlots: Processing " + totalCombinations +
        " combinations for service " + service.getServiceId());

    // OPTIMIZATION 2: Use fast in-memory checking instead of database queries
    for (Staff therapist : availableTherapists) {
      int therapistId = therapist.getUser().getUserId();

      for (LocalDateTime time : availableTimes) {
        LocalDateTime endTime = time.plusMinutes(service.getDurationMinutes());

        // OPTIMIZATION 3: Fast in-memory conflict checking
        if (!globalDomain.hasAppointmentConflict(therapistId, time, endTime, therapistAppointments)) {

          // OPTIMIZATION 4: Fast in-memory buffer time checking
          LocalDateTime bufferStart = time.minusMinutes(15); // 15 min buffer before
          LocalDateTime bufferEnd = endTime.plusMinutes(15); // 15 min buffer after

          if (!globalDomain.hasBufferTimeConflict(therapistId, bufferStart, time, endTime,
              bufferEnd, therapistAppointments)) {

            Assignment candidateAssignment = new Assignment(variable, therapist, time, service);
            validAssignments.add(candidateAssignment);
            validCombinations++;
          }
        }
      }
    }

    long endTime = System.currentTimeMillis();
    long duration = endTime - startTime;

    System.out.println("✅ OPTIMIZED getAllValidSlots COMPLETE:");
    System.out.println("   - Service: " + service.getServiceId());
    System.out.println("   - Therapists: " + availableTherapists.size());
    System.out.println("   - Time slots: " + availableTimes.size());
    System.out.println("   - Total combinations: " + totalCombinations);
    System.out.println("   - Valid combinations: " + validCombinations);
    System.out.println("   - Processing time: " + duration + "ms");
    System.out.println("   - Performance: " + (totalCombinations * 1000 / Math.max(duration, 1)) + " combinations/sec");

    return validAssignments;
  }

  /**
   * Get all valid slots grouped by therapist
   * This method organizes the valid slots by therapist for easier display
   * 
   * @param service The service to find slots for
   * @return Map of therapist to their available time slots
   */
  public Map<Staff, List<LocalDateTime>> getAllValidSlotsGroupedByTherapist(Service service) {
    List<Assignment> validAssignments = getAllValidSlots(service);
    Map<Staff, List<LocalDateTime>> groupedSlots = new HashMap<>();

    for (Assignment assignment : validAssignments) {
      Staff therapist = assignment.getTherapist();
      LocalDateTime time = assignment.getStartTime();

      groupedSlots.computeIfAbsent(therapist, k -> new ArrayList<>())
          .add(time);
    }

    return groupedSlots;
  }
}