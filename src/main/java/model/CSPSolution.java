package model;

import java.util.HashMap;
import java.util.Map;

/**
 * Represents the solution result from CSP solving process
 * Contains the solution assignments, statistics, and metadata
 */
public class CSPSolution {

  private boolean success;
  private Map<CSPVariable, Assignment> assignments;
  private long solutionTime; // in milliseconds
  private int nodesExplored;
  private int backtrackCount;
  private int iterations;
  private String message;

  // Private constructor for builder pattern
  private CSPSolution() {
    this.assignments = new HashMap<>();
  }

  // Getters
  public boolean isSuccess() {
    return success;
  }

  public Map<CSPVariable, Assignment> getAssignments() {
    return new HashMap<>(assignments);
  }

  public long getSolutionTime() {
    return solutionTime;
  }

  public int getNodesExplored() {
    return nodesExplored;
  }

  public int getBacktrackCount() {
    return backtrackCount;
  }

  public int getIterations() {
    return iterations;
  }

  public String getMessage() {
    return message;
  }

  /**
   * Get assignment for a specific variable
   * 
   * @param variable The CSP variable
   * @return Assignment for the variable, or null if not found
   */
  public Assignment getAssignment(CSPVariable variable) {
    return assignments.get(variable);
  }

  /**
   * Check if solution has assignment for a variable
   * 
   * @param variable The CSP variable
   * @return true if assignment exists
   */
  public boolean hasAssignment(CSPVariable variable) {
    return assignments.containsKey(variable);
  }

  /**
   * Get the number of assignments in the solution
   * 
   * @return Number of variable assignments
   */
  public int getAssignmentCount() {
    return assignments.size();
  }

  /**
   * Calculate solution efficiency metrics
   * 
   * @return Efficiency ratio (assignments / nodes explored)
   */
  public double getEfficiencyRatio() {
    if (nodesExplored == 0) {
      return 0.0;
    }
    return (double) assignments.size() / nodesExplored;
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("CSPSolution{\n");
    sb.append("  success=").append(success).append("\n");
    sb.append("  assignments=").append(assignments.size()).append("\n");
    sb.append("  solutionTime=").append(solutionTime).append("ms\n");
    sb.append("  nodesExplored=").append(nodesExplored).append("\n");
    sb.append("  backtrackCount=").append(backtrackCount).append("\n");
    sb.append("  iterations=").append(iterations).append("\n");
    sb.append("  message='").append(message).append("'\n");

    if (success && !assignments.isEmpty()) {
      sb.append("  assignments:{\n");
      for (Map.Entry<CSPVariable, Assignment> entry : assignments.entrySet()) {
        sb.append("    ").append(entry.getValue()).append("\n");
      }
      sb.append("  }\n");
    }

    sb.append("}");
    return sb.toString();
  }

  // Builder pattern for creating CSPSolution instances
  public static Builder builder() {
    return new Builder();
  }

  public static class Builder {
    private CSPSolution solution;

    public Builder() {
      this.solution = new CSPSolution();
    }

    public Builder success(boolean success) {
      solution.success = success;
      return this;
    }

    public Builder assignments(Map<CSPVariable, Assignment> assignments) {
      solution.assignments = assignments != null ? new HashMap<>(assignments) : new HashMap<>();
      return this;
    }

    public Builder addAssignment(CSPVariable variable, Assignment assignment) {
      solution.assignments.put(variable, assignment);
      return this;
    }

    public Builder solutionTime(long solutionTime) {
      solution.solutionTime = solutionTime;
      return this;
    }

    public Builder nodesExplored(int nodesExplored) {
      solution.nodesExplored = nodesExplored;
      return this;
    }

    public Builder backtrackCount(int backtrackCount) {
      solution.backtrackCount = backtrackCount;
      return this;
    }

    public Builder iterations(int iterations) {
      solution.iterations = iterations;
      return this;
    }

    public Builder message(String message) {
      solution.message = message;
      return this;
    }

    public CSPSolution build() {
      return solution;
    }
  }

  /**
   * Create a successful solution
   * 
   * @param assignments Variable assignments
   * @param stats       Solution statistics
   * @return CSPSolution instance
   */
  public static CSPSolution createSuccess(Map<CSPVariable, Assignment> assignments, SolutionStats stats) {
    return builder()
        .success(true)
        .assignments(assignments)
        .solutionTime(stats.solutionTime)
        .nodesExplored(stats.nodesExplored)
        .backtrackCount(stats.backtrackCount)
        .iterations(stats.iterations)
        .message("Solution found successfully")
        .build();
  }

  /**
   * Create a failure solution
   * 
   * @param reason Reason for failure
   * @param stats  Solution statistics
   * @return CSPSolution instance
   */
  public static CSPSolution createFailure(String reason, SolutionStats stats) {
    return builder()
        .success(false)
        .assignments(new HashMap<>())
        .solutionTime(stats.solutionTime)
        .nodesExplored(stats.nodesExplored)
        .backtrackCount(stats.backtrackCount)
        .iterations(stats.iterations)
        .message(reason)
        .build();
  }

  /**
   * Helper class for solution statistics
   */
  public static class SolutionStats {
    public long solutionTime;
    public int nodesExplored;
    public int backtrackCount;
    public int iterations;

    public SolutionStats(long solutionTime, int nodesExplored, int backtrackCount, int iterations) {
      this.solutionTime = solutionTime;
      this.nodesExplored = nodesExplored;
      this.backtrackCount = backtrackCount;
      this.iterations = iterations;
    }
  }
}