/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author Admin
 */
public class Staff {

    private User user;
    private ServiceType serviceType;
    private String bio;
    private AvailabilityStatus availabilityStatus;
    private int yearsOfExperience;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Staff() {
    }

    public Staff(User user, ServiceType serviceType, String bio, AvailabilityStatus availabilityStatus,
                 int yearsOfExperience, Timestamp createdAt, Timestamp updatedAt) {
        this.user = user;
        this.serviceType = serviceType;
        this.bio = bio;
        this.availabilityStatus = availabilityStatus;
        this.yearsOfExperience = yearsOfExperience;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public ServiceType getServiceType() {
        return serviceType;
    }

    public void setServiceType(ServiceType serviceType) {
        this.serviceType = serviceType;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public AvailabilityStatus getAvailabilityStatus() {
        return availabilityStatus;
    }

    public void setAvailabilityStatus(AvailabilityStatus availabilityStatus) {
        this.availabilityStatus = availabilityStatus;
    }

    public int getYearsOfExperience() {
        return yearsOfExperience;
    }

    public void setYearsOfExperience(int yearsOfExperience) {
        this.yearsOfExperience = yearsOfExperience;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Staff{" +
                "user=" + (user != null ? user.getFullName() : "null") +
                ", serviceType=" + (serviceType != null ? serviceType.getName() : "null") +
                ", bio='" + bio + '\'' +
                ", availabilityStatus=" + availabilityStatus +
                ", yearsOfExperience=" + yearsOfExperience +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
    public enum AvailabilityStatus {
    AVAILABLE,
    BUSY,
    OFFLINE,
    ON_LEAVE
}
}