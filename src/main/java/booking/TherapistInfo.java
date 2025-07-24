/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package booking;

/**
 *
 * @author quang
 */
// src/main/java/model/TherapistInfo.java

public class TherapistInfo {
    private int userId;
    private String fullName;
    private int serviceTypeId;
    private String availabilityStatus;
    
    public TherapistInfo(int userId, String fullName, int serviceTypeId, String availabilityStatus) {
        this.userId = userId;
        this.fullName = fullName;
        this.serviceTypeId = serviceTypeId;
        this.availabilityStatus = availabilityStatus;
    }
    
    // Getters and setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public int getServiceTypeId() { return serviceTypeId; }
    public void setServiceTypeId(int serviceTypeId) { this.serviceTypeId = serviceTypeId; }
    public String getAvailabilityStatus() { return availabilityStatus; }
    public void setAvailabilityStatus(String availabilityStatus) { this.availabilityStatus = availabilityStatus; }
    
    @Override
    public String toString() {
        return "TherapistInfo{userId=" + userId + ", fullName='" + fullName + 
               "', serviceTypeId=" + serviceTypeId + ", availabilityStatus='" + availabilityStatus + "'}";
    }
}