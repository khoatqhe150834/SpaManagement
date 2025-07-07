/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 *
 * @author ADMIN
 */
public class Service {
    private int serviceId;
    private ServiceType serviceTypeId;
    private String name;
    private String description;
    private BigDecimal price;
    private int durationMinutes;
    private int bufferTimeAfterMinutes;
    private String imageUrl;
    private boolean isActive;
    private BigDecimal averageRating;
    private boolean bookableOnline;
    private boolean requiresConsultation;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private int purchaseCount; // Transient field for popular services

    public Service() {
    }

    public Service(int serviceId, ServiceType serviceTypeId, String name, String description, BigDecimal price,
            int durationMinutes, int bufferTimeAfterMinutes, String imageUrl, boolean isActive,
            BigDecimal averageRating, boolean bookableOnline, boolean requiresConsultation, Timestamp createdAt,
            Timestamp updatedAt) {
        this.serviceId = serviceId;
        this.serviceTypeId = serviceTypeId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.durationMinutes = durationMinutes;
        this.bufferTimeAfterMinutes = bufferTimeAfterMinutes;
        this.imageUrl = imageUrl;
        this.isActive = isActive;
        this.averageRating = averageRating;
        this.bookableOnline = bookableOnline;
        this.requiresConsultation = requiresConsultation;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getPurchaseCount() {
        return purchaseCount;
    }

    public void setPurchaseCount(int purchaseCount) {
        this.purchaseCount = purchaseCount;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public ServiceType getServiceTypeId() {
        return serviceTypeId;
    }

    public void setServiceTypeId(ServiceType serviceTypeId) {
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

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public int getBufferTimeAfterMinutes() {
        return bufferTimeAfterMinutes;
    }

    public void setBufferTimeAfterMinutes(int bufferTimeAfterMinutes) {
        this.bufferTimeAfterMinutes = bufferTimeAfterMinutes;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public BigDecimal getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(BigDecimal averageRating) {
        this.averageRating = averageRating;
    }

    public boolean isBookableOnline() {
        return bookableOnline;
    }

    public void setBookableOnline(boolean bookableOnline) {
        this.bookableOnline = bookableOnline;
    }

    public boolean isRequiresConsultation() {
        return requiresConsultation;
    }

    public void setRequiresConsultation(boolean requiresConsultation) {
        this.requiresConsultation = requiresConsultation;
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
        return "Service{" + "serviceId=" + serviceId + ", serviceTypeId=" + serviceTypeId + ", name=" + name
                + ", description=" + description + ", price=" + price + ", durationMinutes=" + durationMinutes
                + ", bufferTimeAfterMinutes=" + bufferTimeAfterMinutes + ", imageUrl=" + imageUrl + ", isActive="
                + isActive + ", averageRating=" + averageRating + ", bookableOnline=" + bookableOnline
                + ", requiresConsultation=" + requiresConsultation + ", createdAt=" + createdAt + ", updatedAt="
                + updatedAt + '}';
    }

}
