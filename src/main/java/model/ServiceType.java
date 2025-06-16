/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author ADMIN
 */
public class ServiceType {
    private int serviceTypeId;
    private String name;
    private String description;
    private String imageUrl;
    private boolean active;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public ServiceType() {
    }

    public ServiceType(int serviceTypeId, String name, String description, String imageUrl, boolean active, Timestamp createdAt, Timestamp updatedAt) {
        this.serviceTypeId = serviceTypeId;
        this.name = name;
        this.description = description;
        this.imageUrl = imageUrl;
        this.active = active;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getServiceTypeId() {
        return serviceTypeId;
    }

    public void setServiceTypeId(int serviceTypeId) {
        this.serviceTypeId = serviceTypeId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
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
        return "ServiceType{" + "serviceTypeId=" + serviceTypeId + ", name=" + name + ", description=" + description + ", imageUrl=" + imageUrl + ", active=" + active + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }

    
}
