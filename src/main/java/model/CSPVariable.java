package model;

import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;
import model.Staff;
import model.Service;

/**
 * This class represents a variable in the CSP.
 * It is used to store the information that is already known and the information
 * that needs to be assigned.
 * 
 * @author
 */
public class CSPVariable {
  // what is already known

  private Service chosenService;
  private LocalDateTime startTime;
  private List<Staff> preferedTherapists;
  private boolean isAutoMode;

  // what needs to assign to the variable
  private Staff assignedTherapist;
  private LocalDateTime assignedStartTime;
  private LocalDateTime assignedEndTime;

  public CSPVariable(Service chosenService, LocalDateTime startTime, List<Staff> preferedTherapists,
      boolean isAutoMode) {
    this.chosenService = chosenService;
    this.startTime = startTime;
    this.preferedTherapists = preferedTherapists;
    this.isAutoMode = isAutoMode;
  }

  // getters and setters
  public Service getChosenService() {
    return chosenService;
  }

  public void setChosenService(Service chosenService) {
    this.chosenService = chosenService;
  }

  public LocalDateTime getStartTime() {
    return startTime;
  }

  public void setStartTime(LocalDateTime startTime) {
    this.startTime = startTime;
  }

  public List<Staff> getPreferedTherapists() {
    return preferedTherapists;
  }

  public void setPreferedTherapists(List<Staff> preferedTherapists) {
    this.preferedTherapists = preferedTherapists;
  }

  public boolean isAutoMode() {
    return isAutoMode;
  }

  public void setAutoMode(boolean isAutoMode) {
    this.isAutoMode = isAutoMode;
  }

  // Getters and setters for assignment fields
  public Staff getAssignedTherapist() {
    return assignedTherapist;
  }

  public void setAssignedTherapist(Staff assignedTherapist) {
    this.assignedTherapist = assignedTherapist;
  }

  public Staff getChosenTherapist() {
    return assignedTherapist;
  }

  public void setChosenTherapist(Staff chosenTherapist) {
    this.assignedTherapist = chosenTherapist;
  }

  public LocalDateTime getAssignedStartTime() {
    return assignedStartTime;
  }

  public void setAssignedStartTime(LocalDateTime assignedStartTime) {
    this.assignedStartTime = assignedStartTime;
  }

  public LocalDateTime getAssignedEndTime() {
    return assignedEndTime;
  }

  public void setAssignedEndTime(LocalDateTime assignedEndTime) {
    this.assignedEndTime = assignedEndTime;
  }

  /**
   * Check if the variable has been assigned (has both therapist and start time)
   */
  public boolean isAssigned() {
    return assignedTherapist != null && assignedStartTime != null;
  }

  /**
   * Clear all assignments from this variable
   */
  public void clearAssignments() {
    this.assignedTherapist = null;
    this.assignedStartTime = null;
    this.assignedEndTime = null;
  }

  /**
   * Get the list of preferred therapists, or return an empty list if null
   */
  public List<Staff> getPreferedTherapistsOrEmpty() {
    return preferedTherapists != null ? preferedTherapists : new ArrayList<>();
  }

  @Override
  public String toString() {
    return String.format(
        "CSPVariable{service=%s, startTime=%s, assignedTherapist=%s, assignedStartTime=%s, isAutoMode=%s}",
        chosenService != null ? chosenService.getName() : "null",
        startTime,
        assignedTherapist != null ? assignedTherapist.getUser().getUserId() : "null",
        assignedStartTime,
        isAutoMode);
  }
}
