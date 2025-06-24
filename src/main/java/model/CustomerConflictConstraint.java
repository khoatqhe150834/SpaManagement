package model;

import dao.BookingAppointmentDAO;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

/**
 * Constraint to prevent customer conflicts
 * Ensures a customer doesn't have overlapping appointments
 */
public class CustomerConflictConstraint implements CSPConstraint {

  private BookingAppointmentDAO bookingAppointmentDAO;
  private int customerId; // Customer ID for this booking session

  public CustomerConflictConstraint(int customerId) {
    this.bookingAppointmentDAO = new BookingAppointmentDAO();
    this.customerId = customerId;
  }

  @Override
  public boolean isSatisfied(List<CSPVariable> variables) {
    if (variables.isEmpty()) {
      return false;
    }

    CSPVariable variable = variables.get(0);

    Service service = variable.getChosenService();
    LocalDateTime appointmentTime = variable.getStartTime();

    if (service == null || appointmentTime == null) {
      return false;
    }

    // Calculate appointment duration
    int totalDurationMinutes = service.getDurationMinutes();

    // Check for conflicting customer appointments
    return !hasConflictingCustomerAppointment(customerId, appointmentTime, totalDurationMinutes);
  }

  /**
   * Check if customer has conflicting appointments
   * Uses BookingAppointmentDAO to check for conflicts
   */
  private boolean hasConflictingCustomerAppointment(int customerId, LocalDateTime startTime, int durationMinutes) {
    LocalDateTime endTime = startTime.plusMinutes(durationMinutes);

    try {
      List<BookingAppointment> conflicts = bookingAppointmentDAO.findByCustomerAndTimeRange(customerId, startTime,
          endTime);
      return !conflicts.isEmpty(); // Return true if conflicts found
    } catch (Exception e) {
      System.err.println("Error checking customer conflicts: " + e.getMessage());
      return true; // Assume conflict exists for safety
    }
  }

  @Override
  public List<String> getInvolvedVariables() {
    return Arrays.asList("customer", "appointmentTime", "service");
  }

  @Override
  public String getDescription() {
    return "Customer cannot have overlapping appointments";
  }

  @Override
  public boolean isApplicable(List<CSPVariable> variables) {
    return !variables.isEmpty() &&
        variables.get(0).getChosenService() != null &&
        variables.get(0).getStartTime() != null;
  }
}