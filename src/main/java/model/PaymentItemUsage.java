package model;

import lombok.ToString;
import java.sql.Timestamp;

/**
 * PaymentItemUsage model class for tracking remaining bookable quantities
 * Represents the payment_item_usage table in the database
 * 
 * @author SpaManagement
 */
@ToString
public class PaymentItemUsage {
    private Integer usageId;
    private Integer paymentItemId;
    private Integer totalQuantity;
    private Integer bookedQuantity;
    private Integer remainingQuantity; // Generated column in database
    private Timestamp lastUpdated;
    
    // Related entities (for joins)
    private PaymentItem paymentItem;
    
    // Constructors
    public PaymentItemUsage() {
        this.bookedQuantity = 0;
        this.lastUpdated = new Timestamp(System.currentTimeMillis());
    }
    
    public PaymentItemUsage(Integer paymentItemId, Integer totalQuantity) {
        this();
        this.paymentItemId = paymentItemId;
        this.totalQuantity = totalQuantity;
        this.remainingQuantity = totalQuantity; // Initially all quantity is remaining
    }
    
    // Getters and Setters
    public Integer getUsageId() {
        return usageId;
    }
    
    public void setUsageId(Integer usageId) {
        this.usageId = usageId;
    }
    
    public Integer getPaymentItemId() {
        return paymentItemId;
    }
    
    public void setPaymentItemId(Integer paymentItemId) {
        this.paymentItemId = paymentItemId;
    }
    
    public Integer getTotalQuantity() {
        return totalQuantity;
    }
    
    public void setTotalQuantity(Integer totalQuantity) {
        this.totalQuantity = totalQuantity;
        updateRemainingQuantity();
    }
    
    public Integer getBookedQuantity() {
        return bookedQuantity;
    }
    
    public void setBookedQuantity(Integer bookedQuantity) {
        this.bookedQuantity = bookedQuantity;
        updateRemainingQuantity();
    }
    
    public Integer getRemainingQuantity() {
        return remainingQuantity;
    }
    
    public void setRemainingQuantity(Integer remainingQuantity) {
        this.remainingQuantity = remainingQuantity;
    }
    
    public Timestamp getLastUpdated() {
        return lastUpdated;
    }
    
    public void setLastUpdated(Timestamp lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
    
    public PaymentItem getPaymentItem() {
        return paymentItem;
    }
    
    public void setPaymentItem(PaymentItem paymentItem) {
        this.paymentItem = paymentItem;
    }
    
    // Utility methods
    
    /**
     * Update remaining quantity based on total and booked quantities
     */
    private void updateRemainingQuantity() {
        if (totalQuantity != null && bookedQuantity != null) {
            this.remainingQuantity = totalQuantity - bookedQuantity;
        }
    }
    
    /**
     * Check if there are any remaining quantities available for booking
     * @return true if remaining quantity > 0, false otherwise
     */
    public boolean hasRemainingQuantity() {
        return remainingQuantity != null && remainingQuantity > 0;
    }
    
    /**
     * Check if all quantities have been booked
     * @return true if fully booked, false otherwise
     */
    public boolean isFullyBooked() {
        return remainingQuantity != null && remainingQuantity == 0;
    }
    
    /**
     * Get the percentage of quantities that have been booked
     * @return Percentage as double (0.0 to 100.0)
     */
    public double getBookedPercentage() {
        if (totalQuantity == null || totalQuantity == 0) {
            return 0.0;
        }
        return (bookedQuantity.doubleValue() / totalQuantity.doubleValue()) * 100.0;
    }
    
    /**
     * Increment booked quantity by 1 (for new booking)
     * @return true if successful, false if no remaining quantity
     */
    public boolean incrementBookedQuantity() {
        if (hasRemainingQuantity()) {
            this.bookedQuantity++;
            updateRemainingQuantity();
            this.lastUpdated = new Timestamp(System.currentTimeMillis());
            return true;
        }
        return false;
    }
    
    /**
     * Decrement booked quantity by 1 (for cancelled booking)
     * @return true if successful, false if booked quantity is already 0
     */
    public boolean decrementBookedQuantity() {
        if (bookedQuantity != null && bookedQuantity > 0) {
            this.bookedQuantity--;
            updateRemainingQuantity();
            this.lastUpdated = new Timestamp(System.currentTimeMillis());
            return true;
        }
        return false;
    }
    
    /**
     * Validate the usage data
     * @return true if valid, false otherwise
     */
    public boolean isValid() {
        return paymentItemId != null && paymentItemId > 0 &&
               totalQuantity != null && totalQuantity > 0 &&
               bookedQuantity != null && bookedQuantity >= 0 &&
               bookedQuantity <= totalQuantity;
    }
    
    /**
     * Create PaymentItemUsage from PaymentItem
     * @param paymentItem The payment item to create usage tracking for
     * @return PaymentItemUsage instance
     */
    public static PaymentItemUsage fromPaymentItem(PaymentItem paymentItem) {
        PaymentItemUsage usage = new PaymentItemUsage();
        usage.setPaymentItemId(paymentItem.getPaymentItemId());
        usage.setTotalQuantity(paymentItem.getQuantity());
        usage.setPaymentItem(paymentItem);
        return usage;
    }
}
