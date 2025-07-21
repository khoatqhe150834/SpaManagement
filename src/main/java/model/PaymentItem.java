package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

import lombok.ToString;

/**
 * PaymentItem model class for individual services in cart payments
 * Represents the payment_items table in the database
 * 
 * @author SpaManagement
 */
@ToString
public class PaymentItem {
    private Integer paymentItemId;
    private Integer paymentId;
    private Integer serviceId;
    private Integer quantity;
    private BigDecimal unitPrice;
    private BigDecimal totalPrice;
    private Integer serviceDuration; // Duration in minutes
    private Timestamp createdAt;
    
    // Related entities (for joins)
    private Payment payment;
    private Service service;
    private PaymentItemUsage usage;
    
    // Constructors
    public PaymentItem() {
        this.quantity = 1;
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }
    
    public PaymentItem(Integer paymentId, Integer serviceId, Integer quantity, 
                       BigDecimal unitPrice, Integer serviceDuration) {
        this();
        this.paymentId = paymentId;
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.serviceDuration = serviceDuration;
        calculateTotalPrice();
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
    
    public Integer getServiceId() {
        return serviceId;
    }
    
    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
        calculateTotalPrice(); // Recalculate when quantity changes
    }
    
    public BigDecimal getUnitPrice() {
        return unitPrice;
    }
    
    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
        calculateTotalPrice(); // Recalculate when unit price changes
    }
    
    public BigDecimal getTotalPrice() {
        return totalPrice;
    }
    
    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
    
    public Integer getServiceDuration() {
        return serviceDuration;
    }
    
    public void setServiceDuration(Integer serviceDuration) {
        this.serviceDuration = serviceDuration;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Payment getPayment() {
        return payment;
    }
    
    public void setPayment(Payment payment) {
        this.payment = payment;
    }
    
    public Service getService() {
        return service;
    }
    
    public void setService(Service service) {
        this.service = service;
    }
    
    // Utility methods
    
    /**
     * Calculate total price based on quantity and unit price
     */
    public void calculateTotalPrice() {
        if (quantity != null && unitPrice != null) {
            this.totalPrice = unitPrice.multiply(BigDecimal.valueOf(quantity));
        }
    }
    
    /**
     * Get total duration for all quantities of this service
     * @return Total duration in minutes
     */
    public Integer getTotalDuration() {
        if (quantity != null && serviceDuration != null) {
            return quantity * serviceDuration;
        }
        return serviceDuration;
    }
    
    /**
     * Validate the payment item data
     * @return true if valid, false otherwise
     */
    public boolean isValid() {
        return paymentId != null && paymentId > 0 &&
               serviceId != null && serviceId > 0 &&
               quantity != null && quantity > 0 &&
               unitPrice != null && unitPrice.compareTo(BigDecimal.ZERO) > 0 &&
               serviceDuration != null && serviceDuration > 0;
    }
    
    /**
     * Create a PaymentItem from a Service and quantity
     * @param service The service to create payment item for
     * @param quantity The quantity of the service
     * @return PaymentItem instance
     */
    public static PaymentItem fromService(Service service, Integer quantity) {
        PaymentItem item = new PaymentItem();
        item.setServiceId(service.getServiceId());
        item.setQuantity(quantity);
        item.setUnitPrice(service.getPrice());
        item.setServiceDuration(service.getDurationMinutes());
        item.setService(service);
        item.calculateTotalPrice();
        return item;
    }
    
    /**
     * Check if this payment item matches a service
     * @param serviceId The service ID to check
     * @return true if matches, false otherwise
     */
    public boolean isForService(Integer serviceId) {
        return this.serviceId != null && this.serviceId.equals(serviceId);
    }

    public PaymentItemUsage getUsage() {
        return usage;
    }

    public void setUsage(PaymentItemUsage usage) {
        this.usage = usage;
    }
}
