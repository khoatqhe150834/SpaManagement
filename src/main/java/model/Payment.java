package model;

import lombok.ToString;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDateTime;

/**
 * Payment model class for cart-based payment transactions
 * Represents the payments table in the database
 * 
 * @author SpaManagement
 */
@ToString
public class Payment {
    private Integer paymentId;
    private Integer customerId;
    private BigDecimal totalAmount;
    private BigDecimal taxAmount;
    private BigDecimal subtotalAmount;
    private PaymentMethod paymentMethod;
    private PaymentStatus paymentStatus;
    private String referenceNumber;
    private Timestamp transactionDate;
    private Timestamp paymentDate;
    private String notes;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Related entities (for joins)
    private Customer customer;
    
    // Enums for payment method and status
    public enum PaymentMethod {
        BANK_TRANSFER, CREDIT_CARD, VNPAY, MOMO, ZALOPAY, CASH
    }
    
    public enum PaymentStatus {
        PENDING, PAID, REFUNDED, FAILED
    }
    
    // Constructors
    public Payment() {
        this.paymentStatus = PaymentStatus.PENDING;
        this.taxAmount = BigDecimal.ZERO;
        this.transactionDate = new Timestamp(System.currentTimeMillis());
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }
    
    public Payment(Integer customerId, BigDecimal totalAmount, BigDecimal subtotalAmount, 
                   PaymentMethod paymentMethod, String referenceNumber) {
        this();
        this.customerId = customerId;
        this.totalAmount = totalAmount;
        this.subtotalAmount = subtotalAmount;
        this.paymentMethod = paymentMethod;
        this.referenceNumber = referenceNumber;
    }
    
    // Getters and Setters
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
    
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public BigDecimal getTaxAmount() {
        return taxAmount;
    }
    
    public void setTaxAmount(BigDecimal taxAmount) {
        this.taxAmount = taxAmount;
    }
    
    public BigDecimal getSubtotalAmount() {
        return subtotalAmount;
    }
    
    public void setSubtotalAmount(BigDecimal subtotalAmount) {
        this.subtotalAmount = subtotalAmount;
    }
    
    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public String getReferenceNumber() {
        return referenceNumber;
    }
    
    public void setReferenceNumber(String referenceNumber) {
        this.referenceNumber = referenceNumber;
    }
    
    public Timestamp getTransactionDate() {
        return transactionDate;
    }
    
    public void setTransactionDate(Timestamp transactionDate) {
        this.transactionDate = transactionDate;
    }
    
    public Timestamp getPaymentDate() {
        return paymentDate;
    }
    
    public void setPaymentDate(Timestamp paymentDate) {
        this.paymentDate = paymentDate;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
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
    
    public Customer getCustomer() {
        return customer;
    }
    
    public void setCustomer(Customer customer) {
        this.customer = customer;
    }
    
    // Utility methods
    public boolean isPaid() {
        return PaymentStatus.PAID.equals(this.paymentStatus);
    }
    
    public boolean isPending() {
        return PaymentStatus.PENDING.equals(this.paymentStatus);
    }
    
    public boolean isFailed() {
        return PaymentStatus.FAILED.equals(this.paymentStatus);
    }
    
    public boolean isRefunded() {
        return PaymentStatus.REFUNDED.equals(this.paymentStatus);
    }
    
    /**
     * Calculate tax amount based on subtotal and tax percentage
     * @param taxPercentage Tax percentage (e.g., 8.0 for 8%)
     */
    public void calculateTaxAmount(BigDecimal taxPercentage) {
        if (subtotalAmount != null && taxPercentage != null) {
            this.taxAmount = subtotalAmount.multiply(taxPercentage.divide(BigDecimal.valueOf(100)));
            this.totalAmount = subtotalAmount.add(taxAmount);
        }
    }
    
    /**
     * Generate a unique reference number for the payment
     * Format: SPA + timestamp + random suffix
     */
    public static String generateReferenceNumber() {
        long timestamp = System.currentTimeMillis();
        String timestampStr = String.valueOf(timestamp).substring(8); // Last 5 digits
        String randomSuffix = String.valueOf((int)(Math.random() * 9000) + 1000); // 4 digit random
        return "SPA" + timestampStr + randomSuffix;
    }
}
