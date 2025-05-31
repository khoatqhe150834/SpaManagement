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

    private User userId;
    private ServiceType serviceTypeId;
    private String bio;
    private String availabilityStatus;
    private int yearsOfExperience;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Staff() {
    }

    public Staff(User userId, ServiceType serviceTypeId, String bio, String availabilityStatus, int yearsOfExperience, Timestamp createdAt, Timestamp updatedAt) {
        this.userId = userId;
        this.serviceTypeId = serviceTypeId;
        this.bio = bio;
        this.availabilityStatus = availabilityStatus;
        this.yearsOfExperience = yearsOfExperience;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public User getUserId() {
        return userId;
    }

    public void setUserId(User userId) {
        this.userId = userId;
    }

    public ServiceType getServiceTypeId() {
        return serviceTypeId;
    }

    public void setServiceTypeId(ServiceType serviceTypeId) {
        this.serviceTypeId = serviceTypeId;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getAvailabilityStatus() {
        return availabilityStatus;
    }

    public void setAvailabilityStatus(String availabilityStatus) {
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
        return "Staff{" + "userId=" + userId + ", serviceTypeId=" + serviceTypeId + ", bio=" + bio + ", availabilityStatus=" + availabilityStatus + ", yearsOfExperience=" + yearsOfExperience + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }

}
