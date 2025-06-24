package model;

import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Represents an assignment of values to a CSP variable in the spa booking
 * system
 * Contains the variable, assigned therapist, start time, and service
 */
public class Assignment {

  private CSPVariable variable;
  private Staff therapist;
  private LocalDateTime startTime;
  private Service service;

  public Assignment(CSPVariable variable, Staff therapist, LocalDateTime startTime, Service service) {
    this.variable = variable;
    this.therapist = therapist;
    this.startTime = startTime;
    this.service = service;
  }

  // Getters and setters
  public CSPVariable getVariable() {
    return variable;
  }

  public void setVariable(CSPVariable variable) {
    this.variable = variable;
  }

  public Staff getTherapist() {
    return therapist;
  }

  public void setTherapist(Staff therapist) {
    this.therapist = therapist;
  }

  public LocalDateTime getStartTime() {
    return startTime;
  }

  public void setStartTime(LocalDateTime startTime) {
    this.startTime = startTime;
  }

  public Service getService() {
    return service;
  }

  public void setService(Service service) {
    this.service = service;
  }

  /**
   * Calculate the end time of this assignment based on service duration
   * 
   * @return End time of the appointment
   */
  public LocalDateTime getEndTime() {
    if (startTime == null || service == null) {
      return null;
    }
    return startTime.plusMinutes(service.getDurationMinutes());
  }

  /**
   * Check if this assignment conflicts with another assignment
   * 
   * @param other Another assignment to compare with
   * @return true if there's a time conflict with the same therapist
   */
  public boolean conflictsWith(Assignment other) {
    if (other == null || !this.therapist.equals(other.therapist)) {
      return false;
    }

    LocalDateTime thisEnd = this.getEndTime();
    LocalDateTime otherEnd = other.getEndTime();

    if (thisEnd == null || otherEnd == null) {
      return false;
    }

    // Check for time overlap
    return !(thisEnd.isBefore(other.startTime) || this.startTime.isAfter(otherEnd));
  }

  @Override
  public boolean equals(Object obj) {
    if (this == obj)
      return true;
    if (obj == null || getClass() != obj.getClass())
      return false;

    Assignment that = (Assignment) obj;
    return Objects.equals(variable, that.variable) &&
        Objects.equals(therapist, that.therapist) &&
        Objects.equals(startTime, that.startTime) &&
        Objects.equals(service, that.service);
  }

  @Override
  public int hashCode() {
    return Objects.hash(variable, therapist, startTime, service);
  }

  @Override
  public String toString() {
    return String.format("Assignment{therapist=%s, startTime=%s, service=%s}",
        therapist != null ? therapist.getUser().getUserId() : "null",
        startTime,
        service != null ? service.getName() : "null");
  }
}