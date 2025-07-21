package model;

import java.sql.Timestamp;
import java.util.List;
import model.Certificate;

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
    private List<Certificate> certificates;

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

    public List<Certificate> getCertificates() {
        return certificates;
    }

    public void setCertificates(List<Certificate> certificates) {
        this.certificates = certificates;
    }

    @Override
    public String toString() {
        return "Staff{" +
                "user=" + (user != null ? user.getFullName() : "No name assigned") +
                ", serviceType=" + (serviceType != null ? serviceType.getName() : "Not assigned") +
                ", bio='" + bio + '\'' +
                ", availabilityStatus=" + availabilityStatus +
                ", yearsOfExperience=" + yearsOfExperience +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }

    public void setPhone(String phone) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public void setDepartment(String department) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public void setDesignation(String designation) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public enum AvailabilityStatus {
        AVAILABLE,
        BUSY,
        OFFLINE,
        ON_LEAVE
    }
}
