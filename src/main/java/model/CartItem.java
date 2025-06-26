package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class CartItem {
  private Integer cartItemId;
  private Integer cartId;
  private Integer serviceId;
  private Integer quantity;
  private BigDecimal priceAtAddition;
  private Integer therapistUserIdPreference;
  private LocalDateTime preferredStartTimeSlot;
  private String notes;
  private LocalDateTime addedAt;
  private Boolean isConvertedToAppointment;

  // Transient fields for service information
  private String serviceName;
  private String serviceDescription;
  private String serviceImageUrl;

  // Constructors
  public CartItem() {
    this.quantity = 1;
    this.addedAt = LocalDateTime.now();
    this.isConvertedToAppointment = false;
  }

  public CartItem(Integer cartId, Integer serviceId, BigDecimal priceAtAddition) {
    this();
    this.cartId = cartId;
    this.serviceId = serviceId;
    this.priceAtAddition = priceAtAddition;
  }

  // Business logic methods
  public BigDecimal getTotalPrice() {
    return priceAtAddition.multiply(BigDecimal.valueOf(quantity));
  }

  // Getters and Setters
  public Integer getCartItemId() {
    return cartItemId;
  }

  public void setCartItemId(Integer cartItemId) {
    this.cartItemId = cartItemId;
  }

  public Integer getCartId() {
    return cartId;
  }

  public void setCartId(Integer cartId) {
    this.cartId = cartId;
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
  }

  public BigDecimal getPriceAtAddition() {
    return priceAtAddition;
  }

  public void setPriceAtAddition(BigDecimal priceAtAddition) {
    this.priceAtAddition = priceAtAddition;
  }

  public Integer getTherapistUserIdPreference() {
    return therapistUserIdPreference;
  }

  public void setTherapistUserIdPreference(Integer therapistUserIdPreference) {
    this.therapistUserIdPreference = therapistUserIdPreference;
  }

  public LocalDateTime getPreferredStartTimeSlot() {
    return preferredStartTimeSlot;
  }

  public void setPreferredStartTimeSlot(LocalDateTime preferredStartTimeSlot) {
    this.preferredStartTimeSlot = preferredStartTimeSlot;
  }

  public String getNotes() {
    return notes;
  }

  public void setNotes(String notes) {
    this.notes = notes;
  }

  public LocalDateTime getAddedAt() {
    return addedAt;
  }

  public void setAddedAt(LocalDateTime addedAt) {
    this.addedAt = addedAt;
  }

  public Boolean getIsConvertedToAppointment() {
    return isConvertedToAppointment;
  }

  public void setIsConvertedToAppointment(Boolean isConvertedToAppointment) {
    this.isConvertedToAppointment = isConvertedToAppointment;
  }

  public String getServiceName() {
    return serviceName;
  }

  public void setServiceName(String serviceName) {
    this.serviceName = serviceName;
  }

  public String getServiceDescription() {
    return serviceDescription;
  }

  public void setServiceDescription(String serviceDescription) {
    this.serviceDescription = serviceDescription;
  }

  public String getServiceImageUrl() {
    return serviceImageUrl;
  }

  public void setServiceImageUrl(String serviceImageUrl) {
    this.serviceImageUrl = serviceImageUrl;
  }
}