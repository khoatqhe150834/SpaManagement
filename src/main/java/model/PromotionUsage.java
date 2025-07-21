package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * PromotionUsage model class for tracking promotion usage by customers
 * Represents the promotion_usage table in the database
 * 
 * @author SpaManagement
 */
public class PromotionUsage {
    private Integer usageId;
    private Integer promotionId;
    private Integer customerId;
    private Integer paymentId;
    private Integer bookingId;
    private BigDecimal discountAmount;
    private BigDecimal originalAmount;
    private BigDecimal finalAmount;
    private Timestamp usedAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Related entities (for joins)
    private Promotion promotion;
    private Customer customer;
    private Payment payment;
    private Booking booking;
    
    // Constructors
    public PromotionUsage() {
        this.usedAt = new Timestamp(System.currentTimeMillis());
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.updatedAt = new Timestamp(System.currentTimeMillis());
    }
    
    public PromotionUsage(Integer promotionId, Integer customerId, BigDecimal discountAmount, 
                         BigDecimal originalAmount, BigDecimal finalAmount) {
        this();
        this.promotionId = promotionId;
        this.customerId = customerId;
        this.discountAmount = discountAmount;
        this.originalAmount = originalAmount;
        this.finalAmount = finalAmount;
    }
    
    // Getters and Setters
    public Integer getUsageId() {
        return usageId;
    }
    
    public void setUsageId(Integer usageId) {
        this.usageId = usageId;
    }
    
    public Integer getPromotionId() {
        return promotionId;
    }
    
    public void setPromotionId(Integer promotionId) {
        this.promotionId = promotionId;
    }
    
    public Integer getCustomerId() {
        return customerId;
    }
    
    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }
    
    public Integer getPaymentId() {
        return paymentId;
    }
    
    public void setPaymentId(Integer paymentId) {
        this.paymentId = paymentId;
    }
    
    public Integer getBookingId() {
        return bookingId;
    }
    
    public void setBookingId(Integer bookingId) {
        this.bookingId = bookingId;
    }
    
    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }
    
    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }
    
    public BigDecimal getOriginalAmount() {
        return originalAmount;
    }
    
    public void setOriginalAmount(BigDecimal originalAmount) {
        this.originalAmount = originalAmount;
    }
    
    public BigDecimal getFinalAmount() {
        return finalAmount;
    }
    
    public void setFinalAmount(BigDecimal finalAmount) {
        this.finalAmount = finalAmount;
    }
    
    public Timestamp getUsedAt() {
        return usedAt;
    }
    
    public void setUsedAt(Timestamp usedAt) {
        this.usedAt = usedAt;
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
    
    // Related entities getters/setters
    public Promotion getPromotion() {
        return promotion;
    }
    
    public void setPromotion(Promotion promotion) {
        this.promotion = promotion;
    }
    
    public Customer getCustomer() {
        return customer;
    }
    
    public void setCustomer(Customer customer) {
        this.customer = customer;
    }
    
    public Payment getPayment() {
        return payment;
    }
    
    public void setPayment(Payment payment) {
        this.payment = payment;
    }
    
    public Booking getBooking() {
        return booking;
    }
    
    public void setBooking(Booking booking) {
        this.booking = booking;
    }
    
    @Override
    public String toString() {
        return "PromotionUsage{" +
                "usageId=" + usageId +
                ", promotionId=" + promotionId +
                ", customerId=" + customerId +
                ", paymentId=" + paymentId +
                ", bookingId=" + bookingId +
                ", discountAmount=" + discountAmount +
                ", originalAmount=" + originalAmount +
                ", finalAmount=" + finalAmount +
                ", usedAt=" + usedAt +
                '}';
    }
} 
 
 