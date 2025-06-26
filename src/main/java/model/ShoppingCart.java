package model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ShoppingCart {
  private Integer cartId;
  private Integer customerId;
  private String sessionId;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;
  private String status; // ACTIVE, ABANDONED, CONVERTED

  // Transient field for cart items
  private List<CartItem> cartItems = new ArrayList<>();

  // Constructors
  public ShoppingCart() {
    this.status = "ACTIVE";
    this.createdAt = LocalDateTime.now();
    this.updatedAt = LocalDateTime.now();
  }

  public ShoppingCart(Integer customerId, String sessionId) {
    this();
    this.customerId = customerId;
    this.sessionId = sessionId;
  }

  // Business logic methods
  public int getTotalItemCount() {
    return cartItems.stream().mapToInt(CartItem::getQuantity).sum();
  }

  public boolean isEmpty() {
    return cartItems.isEmpty();
  }

  public void addCartItem(CartItem item) {
    this.cartItems.add(item);
  }

  public void removeCartItem(CartItem item) {
    this.cartItems.remove(item);
  }

  // Getters and Setters
  public Integer getCartId() {
    return cartId;
  }

  public void setCartId(Integer cartId) {
    this.cartId = cartId;
  }

  public Integer getCustomerId() {
    return customerId;
  }

  public void setCustomerId(Integer customerId) {
    this.customerId = customerId;
  }

  public String getSessionId() {
    return sessionId;
  }

  public void setSessionId(String sessionId) {
    this.sessionId = sessionId;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }

  public LocalDateTime getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(LocalDateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public List<CartItem> getCartItems() {
    return cartItems;
  }

  public void setCartItems(List<CartItem> cartItems) {
    this.cartItems = cartItems;
  }
}