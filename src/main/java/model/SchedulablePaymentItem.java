package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Objects;

/**
 * Model class representing a payment item that can be scheduled
 * Contains combined information from payment, payment_item, customer, service, and usage
 * 
 * @author SpaManagement
 */
public class SchedulablePaymentItem {
    
    private Integer paymentItemId;
    private Integer paymentId;
    private Integer customerId;
    private String customerName;
    private String customerPhone;
    private Integer serviceId;
    private String serviceName;
    private Integer serviceDuration;
    private BigDecimal unitPrice;
    private Integer totalQuantity;
    private Integer bookedQuantity;
    private Integer remainingQuantity;
    private Timestamp paymentDate;
    private String referenceNumber;
    
    // Constructors
    public SchedulablePaymentItem() {}
    
    public SchedulablePaymentItem(Integer paymentItemId, Integer paymentId, Integer customerId, 
                                String customerName, String customerPhone, Integer serviceId, 
                                String serviceName, Integer serviceDuration, BigDecimal unitPrice,
                                Integer totalQuantity, Integer bookedQuantity, Integer remainingQuantity,
                                Timestamp paymentDate, String referenceNumber) {
        this.paymentItemId = paymentItemId;
        this.paymentId = paymentId;
        this.customerId = customerId;
        this.customerName = customerName;
        this.customerPhone = customerPhone;
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.serviceDuration = serviceDuration;
        this.unitPrice = unitPrice;
        this.totalQuantity = totalQuantity;
        this.bookedQuantity = bookedQuantity;
        this.remainingQuantity = remainingQuantity;
        this.paymentDate = paymentDate;
        this.referenceNumber = referenceNumber;
    }
    
    // Getters and Setters
    public Integer getPaymentItemId() {
        return paymentItemId;
    }
    
    public void setPaymentItemId(Integer paymentItemId) {
        this.paymentItemId = paymentItemId;
    }
    
    public Integer getPaymentId() {
        return paymentId;
    }
    
    public void setPaymentId(Integer paymentId) {
        this.paymentId = paymentId;
    }
    
    public Integer getCustomerId() {
        return customerId;
    }
    
    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getCustomerPhone() {
        return customerPhone;
    }
    
    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }
    
    public Integer getServiceId() {
        return serviceId;
    }
    
    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }
    
    public String getServiceName() {
        return serviceName;
    }
    
    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }
    
    public Integer getServiceDuration() {
        return serviceDuration;
    }
    
    public void setServiceDuration(Integer serviceDuration) {
        this.serviceDuration = serviceDuration;
    }
    
    public BigDecimal getUnitPrice() {
        return unitPrice;
    }
    
    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }
    
    public Integer getTotalQuantity() {
        return totalQuantity;
    }
    
    public void setTotalQuantity(Integer totalQuantity) {
        this.totalQuantity = totalQuantity;
    }
    
    public Integer getBookedQuantity() {
        return bookedQuantity;
    }
    
    public void setBookedQuantity(Integer bookedQuantity) {
        this.bookedQuantity = bookedQuantity;
    }
    
    public Integer getRemainingQuantity() {
        return remainingQuantity;
    }
    
    public void setRemainingQuantity(Integer remainingQuantity) {
        this.remainingQuantity = remainingQuantity;
    }
    
    public Timestamp getPaymentDate() {
        return paymentDate;
    }
    
    public void setPaymentDate(Timestamp paymentDate) {
        this.paymentDate = paymentDate;
    }
    
    public String getReferenceNumber() {
        return referenceNumber;
    }
    
    public void setReferenceNumber(String referenceNumber) {
        this.referenceNumber = referenceNumber;
    }
    
    // Utility methods
    
    /**
     * Check if this item has remaining quantity available for scheduling
     */
    public boolean hasRemainingQuantity() {
        return remainingQuantity != null && remainingQuantity > 0;
    }
    
    /**
     * Check if this item is fully scheduled
     */
    public boolean isFullyScheduled() {
        return remainingQuantity != null && remainingQuantity == 0;
    }
    
    /**
     * Get the percentage of items that have been scheduled
     */
    public double getScheduledPercentage() {
        if (totalQuantity == null || totalQuantity == 0) {
            return 0.0;
        }
        return (bookedQuantity.doubleValue() / totalQuantity.doubleValue()) * 100.0;
    }
    
    /**
     * Get the total value of remaining unscheduled items
     */
    public BigDecimal getRemainingValue() {
        if (remainingQuantity == null || unitPrice == null) {
            return BigDecimal.ZERO;
        }
        return unitPrice.multiply(BigDecimal.valueOf(remainingQuantity));
    }
    
    /**
     * Get the total value of all items (scheduled + unscheduled)
     */
    public BigDecimal getTotalValue() {
        if (totalQuantity == null || unitPrice == null) {
            return BigDecimal.ZERO;
        }
        return unitPrice.multiply(BigDecimal.valueOf(totalQuantity));
    }
    
    /**
     * Get formatted service duration as hours and minutes
     */
    public String getFormattedDuration() {
        if (serviceDuration == null) {
            return "N/A";
        }
        
        int hours = serviceDuration / 60;
        int minutes = serviceDuration % 60;
        
        if (hours > 0 && minutes > 0) {
            return hours + "h " + minutes + "m";
        } else if (hours > 0) {
            return hours + "h";
        } else {
            return minutes + "m";
        }
    }
    
    /**
     * Get priority level based on payment date (older payments have higher priority)
     */
    public String getPriorityLevel() {
        if (paymentDate == null) {
            return "NORMAL";
        }
        
        long daysSincePayment = (System.currentTimeMillis() - paymentDate.getTime()) / (1000 * 60 * 60 * 24);
        
        if (daysSincePayment > 7) {
            return "HIGH";
        } else if (daysSincePayment > 3) {
            return "MEDIUM";
        } else {
            return "NORMAL";
        }
    }
    
    @Override
    public String toString() {
        return "SchedulablePaymentItem{" +
                "paymentItemId=" + paymentItemId +
                ", customerName='" + customerName + '\'' +
                ", serviceName='" + serviceName + '\'' +
                ", remainingQuantity=" + remainingQuantity +
                ", totalQuantity=" + totalQuantity +
                ", referenceNumber='" + referenceNumber + '\'' +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        SchedulablePaymentItem that = (SchedulablePaymentItem) o;
        return Objects.equals(paymentItemId, that.paymentItemId);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(paymentItemId);
    }
}
