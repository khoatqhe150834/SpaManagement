/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package booking;

/**
 *
 * @author quang
 */
// src/main/java/model/PaymentItemDetails.java

public class PaymentItemDetails {
    private int paymentItemId;
    private int paymentId;
    private int serviceId;
    private String serviceName;
    private int quantity;
    private int bookedQuantity;
    private int remainingQuantity;
    private double unitPrice;
    private double totalPrice;
    private int serviceDuration;
    private int bufferTime;
    
    public PaymentItemDetails(int paymentItemId, int paymentId, int serviceId, String serviceName,
                            int quantity, int bookedQuantity, double unitPrice, double totalPrice,
                            int serviceDuration, int bufferTime) {
        this.paymentItemId = paymentItemId;
        this.paymentId = paymentId;
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.quantity = quantity;
        this.bookedQuantity = bookedQuantity;
        this.remainingQuantity = quantity - bookedQuantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
        this.serviceDuration = serviceDuration;
        this.bufferTime = bufferTime;
    }
    
    // Getters and setters
    public int getPaymentItemId() { return paymentItemId; }
    public void setPaymentItemId(int paymentItemId) { this.paymentItemId = paymentItemId; }
    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public int getBookedQuantity() { return bookedQuantity; }
    public void setBookedQuantity(int bookedQuantity) { 
        this.bookedQuantity = bookedQuantity; 
        this.remainingQuantity = this.quantity - bookedQuantity;
    }
    public int getRemainingQuantity() { return remainingQuantity; }
    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }
    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
    public int getServiceDuration() { return serviceDuration; }
    public void setServiceDuration(int serviceDuration) { this.serviceDuration = serviceDuration; }
    public int getBufferTime() { return bufferTime; }
    public void setBufferTime(int bufferTime) { this.bufferTime = bufferTime; }
    
    public boolean hasRemainingQuantity() {
        return remainingQuantity > 0;
    }
    
    @Override
    public String toString() {
        return "PaymentItemDetails{" +
               "paymentItemId=" + paymentItemId +
               ", serviceName='" + serviceName + '\'' +
               ", quantity=" + quantity +
               ", bookedQuantity=" + bookedQuantity +
               ", remainingQuantity=" + remainingQuantity +
               '}';
    }
}