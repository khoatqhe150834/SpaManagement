/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package model;
import java.math.BigDecimal;
import java.time.LocalDateTime;
public class Promotion {
    private Integer promotionId;
    private String title;
    private String description;
    private String promotionCode;
    private String discountType;
    private BigDecimal discountValue;
    private Integer appliesToServiceId;
    private BigDecimal minimumAppointmentValue;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private String status;
    private Integer usageLimitPerCustomer;
    private Integer totalUsageLimit;
    private Integer currentUsageCount;
    private String applicableScope;
    private String applicableServiceIdsJson;
    private String imageUrl;
    private String termsAndConditions;
    private Integer createdByUserId;
    private Boolean isAutoApply;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    
    public Promotion() {}
    
    
    public Integer getPromotionId() { return promotionId; }
    public void setPromotionId(Integer promotionId) { this.promotionId = promotionId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getPromotionCode() { return promotionCode; }
    public void setPromotionCode(String promotionCode) { this.promotionCode = promotionCode; }
    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }
    public BigDecimal getDiscountValue() { return discountValue; }
    public void setDiscountValue(BigDecimal discountValue) { this.discountValue = discountValue; }
    public Integer getAppliesToServiceId() { return appliesToServiceId; }
    public void setAppliesToServiceId(Integer appliesToServiceId) { this.appliesToServiceId = appliesToServiceId; }
    public BigDecimal getMinimumAppointmentValue() { return minimumAppointmentValue; }
    public void setMinimumAppointmentValue(BigDecimal minimumAppointmentValue) { this.minimumAppointmentValue = minimumAppointmentValue; }
    public LocalDateTime getStartDate() { return startDate; }
    public void setStartDate(LocalDateTime startDate) { this.startDate = startDate; }
    public LocalDateTime getEndDate() { return endDate; }
    public void setEndDate(LocalDateTime endDate) { this.endDate = endDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getUsageLimitPerCustomer() { return usageLimitPerCustomer; }
    public void setUsageLimitPerCustomer(Integer usageLimitPerCustomer) { this.usageLimitPerCustomer = usageLimitPerCustomer; }
    public Integer getTotalUsageLimit() { return totalUsageLimit; }
    public void setTotalUsageLimit(Integer totalUsageLimit) { this.totalUsageLimit = totalUsageLimit; }
    public Integer getCurrentUsageCount() { return currentUsageCount; }
    public void setCurrentUsageCount(Integer currentUsageCount) { this.currentUsageCount = currentUsageCount; }
    public String getApplicableScope() { return applicableScope; }
    public void setApplicableScope(String applicableScope) { this.applicableScope = applicableScope; }
    public String getApplicableServiceIdsJson() { return applicableServiceIdsJson; }
    public void setApplicableServiceIdsJson(String applicableServiceIdsJson) { this.applicableServiceIdsJson = applicableServiceIdsJson; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getTermsAndConditions() { return termsAndConditions; }
    public void setTermsAndConditions(String termsAndConditions) { this.termsAndConditions = termsAndConditions; }
    public Integer getCreatedByUserId() { return createdByUserId; }
    public void setCreatedByUserId(Integer createdByUserId) { this.createdByUserId = createdByUserId; }
    public Boolean getIsAutoApply() { return isAutoApply; }
    public void setIsAutoApply(Boolean isAutoApply) { this.isAutoApply = isAutoApply; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}

