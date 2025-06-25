package model;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

/**
 * Constraint to prevent conflicts within the same booking session
 * Ensures multiple services in the same session don't overlap
 */
public class BookingSessionConflictConstraint implements CSPConstraint {

  @Override
  public boolean isSatisfied(List<CSPVariable> variables) {
    if (variables.size() <= 1) {
      return true; // No conflicts possible with 0 or 1 variables
    }

    // Check each pair of variables for time conflicts
    for (int i = 0; i < variables.size(); i++) {
      for (int j = i + 1; j < variables.size(); j++) {
        CSPVariable var1 = variables.get(i);
        CSPVariable var2 = variables.get(j);

        if (hasTimeConflict(var1, var2)) {
          System.out.println("BookingSessionConflictConstraint: Conflict detected between services " +
              var1.getChosenService().getName() + " and " + var2.getChosenService().getName());
          return false;
        }
      }
    }

    return true; // No conflicts found
  }

  /**
   * Check if two CSP variables have conflicting time assignments
   */
  private boolean hasTimeConflict(CSPVariable var1, CSPVariable var2) {
    if (var1.getStartTime() == null || var2.getStartTime() == null ||
        var1.getChosenService() == null || var2.getChosenService() == null) {
      return false; // Can't conflict if not fully assigned
    }

    LocalDateTime start1 = var1.getStartTime();
    LocalDateTime end1 = start1.plusMinutes(var1.getChosenService().getDurationMinutes());

    LocalDateTime start2 = var2.getStartTime();
    LocalDateTime end2 = start2.plusMinutes(var2.getChosenService().getDurationMinutes());

    // Check for overlap: start1 < end2 && start2 < end1
    boolean hasOverlap = start1.isBefore(end2) && start2.isBefore(end1);

    if (hasOverlap) {
      System.out.println("Time conflict detected:");
      System.out.println("  Service 1: " + var1.getChosenService().getName() +
          " (" + start1 + " - " + end1 + ")");
      System.out.println("  Service 2: " + var2.getChosenService().getName() +
          " (" + start2 + " - " + end2 + ")");
    }

    return hasOverlap;
  }

  @Override
  public List<String> getInvolvedVariables() {
    return Arrays.asList("appointmentTime", "service", "serviceDuration");
  }

  @Override
  public String getDescription() {
    return "Services within the same booking session cannot have overlapping times";
  }

  @Override
  public boolean isApplicable(List<CSPVariable> variables) {
    return variables.size() > 1 &&
        variables.stream().allMatch(var -> var.getChosenService() != null && var.getStartTime() != null);
  }
}