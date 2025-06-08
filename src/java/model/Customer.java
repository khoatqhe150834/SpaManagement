package model;

import java.time.LocalDateTime;
import java.util.Date;
import lombok.ToString;

@ToString
public class Customer {
    private Integer customerId;
    private String fullName;
    private String email;
    private String hashPassword;
    private String phoneNumber;
    private String gender;
    private Date birthday;
    private String address;
    private Boolean isActive;
    private Integer loyaltyPoints;
    private Integer roleId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Boolean isVerified; // TRUE = Email verified, FALSE = Not verified

    public Customer() {
    }

    public Customer(String fullName, String email, String hashPassword, String phoneNumber) {
        this.fullName = fullName;
        this.email = email;
        this.hashPassword = hashPassword;
        this.phoneNumber = phoneNumber;
        this.roleId = RoleConstants.CUSTOMER_ID;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getHashPassword() {
        return hashPassword;
    }

    public void setHashPassword(String hashPassword) {
        this.hashPassword = hashPassword;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Integer getLoyaltyPoints() {
        return loyaltyPoints;
    }

    public void setLoyaltyPoints(Integer loyaltyPoints) {
        this.loyaltyPoints = loyaltyPoints;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Boolean getIsVerified() {
        return isVerified;
    }

    public void setIsVerified(Boolean isVerified) {
        this.isVerified = isVerified;
    }
    
    // Convenience methods for better readability
    public boolean isActive() {
        return Boolean.TRUE.equals(this.isActive);
    }
    
    public boolean isVerified() {
        return Boolean.TRUE.equals(this.isVerified);
    }
}