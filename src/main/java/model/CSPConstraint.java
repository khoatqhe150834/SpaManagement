package model;

import java.util.List;

/**
 * Interface for Constraint Satisfaction Problem (CSP) constraints
 * Defines methods for checking constraint satisfaction in the spa booking
 * system
 */
public interface CSPConstraint {

  /**
   * Check if the constraint is satisfied given the current variable assignments
   * 
   * @param variables List of CSP variables with their current assignments
   * @return true if constraint is satisfied, false otherwise
   */
  boolean isSatisfied(List<CSPVariable> variables);

  /**
   * Get the variables that this constraint applies to
   * 
   * @return List of variable names/identifiers involved in this constraint
   */
  List<String> getInvolvedVariables();

  /**
   * Get a description of what this constraint enforces
   * 
   * @return String description of the constraint
   */
  String getDescription();

  /**
   * Check if this constraint can be applied to the given variables
   * 
   * @param variables List of variables to check
   * @return true if constraint is applicable, false otherwise
   */
  boolean isApplicable(List<CSPVariable> variables);
}