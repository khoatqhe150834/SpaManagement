package model;

import dao.BookingAppointmentDAO;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

/**
 * Constraint to ensure buffer time between appointments
 * Ensures there's adequate time between consecutive appointments for
 * setup/cleanup
 */
public class BufferTimeConstraint implements CSPConstraint {

  private static final int REQUIRED_BUFFER_MINUTES = 10; // 10 minutes buffer time
  private BookingAppointmentDAO bookingAppointmentDAO;

  public BufferTimeConstraint() {
    this.bookingAppointmentDAO = new BookingAppointmentDAO();
  }

  @Override
  public boolean isSatisfied(List<CSPVariable> variables) {
    if (variables.isEmpty()) {
      return false;
    }

    CSPVariable variable = variables.get(0);

    Service service = variable.getChosenService();
    LocalDateTime appointmentTime = variable.getStartTime();
    List<Staff> preferredTherapists = variable.getPreferedTherapists();

    if (service == null || appointmentTime == null || preferredTherapists == null || preferredTherapists.isEmpty()) {
      return false;
    }

    // Check buffer time for each preferred therapist
    for (Staff therapist : preferredTherapists) {
      if (therapist == null || therapist.getUser() == null) {
        continue;
      }

      int therapistId = therapist.getUser().getUserId();

      // Check if there's adequate buffer time before and after this appointment
      if (!hasAdequateBufferTime(therapistId, appointmentTime, service.getDurationMinutes())) {
        return false;
      }
    }

    return true; // All therapists have adequate buffer time
  }

  /**
   * Check if therapist has adequate buffer time around the proposed appointment
   * Uses BookingAppointmentDAO to check for buffer time conflicts
   */
  private boolean hasAdequateBufferTime(int therapistId, LocalDateTime appointmentStart, int serviceDurationMinutes) {
    LocalDateTime appointmentEnd = appointmentStart.plusMinutes(serviceDurationMinutes);

    // Check for appointments that might violate buffer time
    // Buffer time should be maintained both before and after the appointment
    LocalDateTime bufferCheckStart = appointmentStart.minusMinutes(REQUIRED_BUFFER_MINUTES);
    LocalDateTime bufferCheckEnd = appointmentEnd.plusMinutes(REQUIRED_BUFFER_MINUTES);

    try {
      List<BookingAppointment> conflicts = bookingAppointmentDAO.findByTherapistAndBufferTimeRange(
          therapistId, bufferCheckStart, appointmentStart, appointmentEnd, bufferCheckEnd);
      return conflicts.isEmpty(); // Return true if NO conflicts found (adequate buffer)
    } catch (Exception e) {
      System.err.println("Error checking buffer time: " + e.getMessage());
      return false; // Assume inadequate buffer for safety
    }
  }

  /**
   * Get the required buffer time in minutes
   */
  public static int getRequiredBufferMinutes() {
    return REQUIRED_BUFFER_MINUTES;
  }

  @Override
  public List<String> getInvolvedVariables() {
    return Arrays.asList("preferredTherapists", "appointmentTime", "service");
  }

  @Override
  public String getDescription() {
    return "Appointments must have " + REQUIRED_BUFFER_MINUTES + " minutes buffer time between consecutive bookings";
  }

  @Override
  public boolean isApplicable(List<CSPVariable> variables) {
    return !variables.isEmpty() &&
        variables.get(0).getChosenService() != null &&
        variables.get(0).getStartTime() != null &&
        variables.get(0).getPreferedTherapists() != null;
  }
}