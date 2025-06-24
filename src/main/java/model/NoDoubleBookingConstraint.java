package model;

import dao.BookingAppointmentDAO;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

/**
 * Constraint to prevent therapist double booking
 * Ensures a therapist doesn't have overlapping appointments
 */
public class NoDoubleBookingConstraint implements CSPConstraint {

  private BookingAppointmentDAO bookingAppointmentDAO;

  public NoDoubleBookingConstraint() {
    this.bookingAppointmentDAO = new BookingAppointmentDAO();
  }

  @Override
  public boolean isSatisfied(List<CSPVariable> variables) {
    // For now, assuming we have one CSPVariable that contains all information
    if (variables.isEmpty()) {
      return false;
    }

    CSPVariable variable = variables.get(0);

    // CSPVariable structure: chosenService, startTime, preferedTherapists,
    // isAutoMode
    // For this constraint, we need to check if there are conflicts
    // This is a simplified implementation

    Service service = variable.getChosenService();
    LocalDateTime appointmentTime = variable.getStartTime();
    List<Staff> preferredTherapists = variable.getPreferedTherapists();

    if (service == null || appointmentTime == null || preferredTherapists == null || preferredTherapists.isEmpty()) {
      return false;
    }

    // Check each preferred therapist for conflicts
    for (Staff therapist : preferredTherapists) {
      if (therapist == null || therapist.getUser() == null) {
        continue;
      }

      int therapistId = therapist.getUser().getUserId();
      int totalDurationMinutes = service.getDurationMinutes() + service.getBufferTimeAfterMinutes();

      // If any preferred therapist has a conflict, this assignment fails
      if (hasConflictingAppointment(therapistId, appointmentTime, totalDurationMinutes)) {
        return false;
      }
    }

    return true; // No conflicts found
  }

  /**
   * Check if therapist has conflicting appointments
   * Uses BookingAppointmentDAO to check for conflicts
   */
  private boolean hasConflictingAppointment(int therapistId, LocalDateTime startTime, int durationMinutes) {
    LocalDateTime endTime = startTime.plusMinutes(durationMinutes);

    try {
      List<BookingAppointment> conflicts = bookingAppointmentDAO.findByTherapistAndTimeRange(therapistId, startTime,
          endTime);
      return !conflicts.isEmpty(); // Return true if conflicts found
    } catch (Exception e) {
      System.err.println("Error checking therapist conflicts: " + e.getMessage());
      return true; // Assume conflict exists for safety
    }
  }

  @Override
  public List<String> getInvolvedVariables() {
    return Arrays.asList("preferredTherapists", "appointmentTime", "service");
  }

  @Override
  public String getDescription() {
    return "Therapist cannot have overlapping appointments";
  }

  @Override
  public boolean isApplicable(List<CSPVariable> variables) {
    return !variables.isEmpty() &&
        variables.get(0).getChosenService() != null &&
        variables.get(0).getStartTime() != null &&
        variables.get(0).getPreferedTherapists() != null;
  }
}