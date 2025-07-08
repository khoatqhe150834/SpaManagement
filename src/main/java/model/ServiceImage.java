/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 * ServiceImage model class that maps to the service_images table
 * Stores multiple images for each service with metadata
 *
 * @author ADMIN
 */
public class ServiceImage {
    private Integer imageId;
    private Integer serviceId;
    private String url;
    private String altText;
    private Boolean isPrimary;
    private Integer sortOrder;
    private String caption;
    private Boolean isActive;
    private Integer fileSize;
    private Timestamp uploadedAt;
    private Timestamp updatedAt;

    // Default constructor
    public ServiceImage() {
        this.isPrimary = false;
        this.sortOrder = 0;
        this.isActive = true;
    }

    // Constructor for basic image creation
    public ServiceImage(Integer serviceId, String url) {
        this();
        this.serviceId = serviceId;
        this.url = url;
    }

    // Constructor with primary fields
    public ServiceImage(Integer serviceId, String url, String altText, Boolean isPrimary) {
        this(serviceId, url);
        this.altText = altText;
        this.isPrimary = isPrimary;
    }

    // Full constructor
    public ServiceImage(Integer imageId, Integer serviceId, String url, String altText,
            Boolean isPrimary, Integer sortOrder, String caption,
            Boolean isActive, Integer fileSize, Timestamp uploadedAt, Timestamp updatedAt) {
        this.imageId = imageId;
        this.serviceId = serviceId;
        this.url = url;
        this.altText = altText;
        this.isPrimary = isPrimary;
        this.sortOrder = sortOrder;
        this.caption = caption;
        this.isActive = isActive;
        this.fileSize = fileSize;
        this.uploadedAt = uploadedAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public Integer getImageId() {
        return imageId;
    }

    public void setImageId(Integer imageId) {
        this.imageId = imageId;
    }

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getAltText() {
        return altText;
    }

    public void setAltText(String altText) {
        this.altText = altText;
    }

    public Boolean getIsPrimary() {
        return isPrimary;
    }

    public void setIsPrimary(Boolean isPrimary) {
        this.isPrimary = isPrimary;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Integer getFileSize() {
        return fileSize;
    }

    public void setFileSize(Integer fileSize) {
        this.fileSize = fileSize;
    }

    public Timestamp getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(Timestamp uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Utility methods
    public boolean isPrimary() {
        return isPrimary != null && isPrimary;
    }

    public boolean isActive() {
        return isActive != null && isActive;
    }

    @Override
    public String toString() {
        return "ServiceImage{" +
                "imageId=" + imageId +
                ", serviceId=" + serviceId +
                ", url='" + url + '\'' +
                ", altText='" + altText + '\'' +
                ", isPrimary=" + isPrimary +
                ", sortOrder=" + sortOrder +
                ", caption='" + caption + '\'' +
                ", isActive=" + isActive +
                ", fileSize=" + fileSize +
                ", uploadedAt=" + uploadedAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
