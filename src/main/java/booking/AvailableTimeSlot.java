/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package booking;

/**
 *
 * @author quang
 */
// src/main/java/model/AvailableTimeSlot.java

import java.util.List;

public class AvailableTimeSlot {
    private TimeSlot timeSlot;
    private List<ResourceCombination> availableResources;
    private int totalCombinations;
    
    public AvailableTimeSlot(TimeSlot timeSlot, List<ResourceCombination> availableResources) {
        this.timeSlot = timeSlot;
        this.availableResources = availableResources;
        this.totalCombinations = availableResources.size();
    }
    
    // Getters and setters
    public TimeSlot getTimeSlot() { return timeSlot; }
    public void setTimeSlot(TimeSlot timeSlot) { this.timeSlot = timeSlot; }
    public List<ResourceCombination> getAvailableResources() { return availableResources; }
    public void setAvailableResources(List<ResourceCombination> availableResources) { 
        this.availableResources = availableResources; 
        this.totalCombinations = availableResources.size();
    }
    public int getTotalCombinations() { return totalCombinations; }
    
    public boolean hasAvailableResources() {
        return availableResources != null && !availableResources.isEmpty();
    }
    
    @Override
    public String toString() {
        return "AvailableTimeSlot{" +
               "timeSlot=" + timeSlot + 
               ", combinations=" + totalCombinations + "}";
    }
}