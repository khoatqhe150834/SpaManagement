package model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CartSession {
  private String sessionId;
  private Integer customerId;
  private Integer cartId; // Add cartId field for shopping_carts table
  private String sessionData; // JSON string
  private LocalDateTime expiresAt;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  // Transient fields for working with session data
  private CartSessionData data;
  private static final ObjectMapper objectMapper = new ObjectMapper()
      .registerModule(new JavaTimeModule());

  public enum ItemType {
    SERVICE, PRODUCT
  }

  // Constructors
  public CartSession() {
    this.data = new CartSessionData();
    this.expiresAt = LocalDateTime.now().plusDays(30); // Cart expires in 30 days
  }

  public CartSession(String sessionId) {
    this();
    this.sessionId = sessionId;
  }

  // Business Logic Methods
  public void addCartItem(CartItem item) {
    if (data.getCartItems() == null) {
      data.setCartItems(new ArrayList<>());
    }

    // Check if item already exists
    CartItem existingItem = findCartItem(item.getItemId(), item.getItemType());
    if (existingItem != null) {
      existingItem.setQuantity(existingItem.getQuantity() + item.getQuantity());
    } else {
      data.getCartItems().add(item);
    }
    updateTotals();
  }

  public void removeCartItem(int itemId, ItemType itemType) {
    if (data.getCartItems() != null) {
      data.getCartItems().removeIf(item -> item.getItemId() == itemId && item.getItemType() == itemType);
      updateTotals();
    }
  }

  public void updateItemQuantity(int itemId, ItemType itemType, int quantity) {
    CartItem item = findCartItem(itemId, itemType);
    if (item != null) {
      if (quantity <= 0) {
        removeCartItem(itemId, itemType);
      } else {
        item.setQuantity(quantity);
        updateTotals();
      }
    }
  }

  public CartItem findCartItem(int itemId, ItemType itemType) {
    if (data.getCartItems() == null)
      return null;
    return data.getCartItems().stream()
        .filter(item -> item.getItemId() == itemId && item.getItemType() == itemType)
        .findFirst()
        .orElse(null);
  }

  public void clearCart() {
    if (data.getCartItems() != null) {
      data.getCartItems().clear();
      updateTotals();
    }
  }

  public boolean isEmpty() {
    return data.getCartItems() == null || data.getCartItems().isEmpty();
  }

  public int getTotalItemCount() {
    if (data.getCartItems() == null)
      return 0;
    return data.getCartItems().stream()
        .mapToInt(CartItem::getQuantity)
        .sum();
  }

  public boolean isExpired() {
    return LocalDateTime.now().isAfter(expiresAt);
  }

  public boolean hasServices() {
    if (data.getCartItems() == null)
      return false;
    return data.getCartItems().stream()
        .anyMatch(item -> item.getItemType() == ItemType.SERVICE);
  }

  public boolean hasProducts() {
    if (data.getCartItems() == null)
      return false;
    return data.getCartItems().stream()
        .anyMatch(item -> item.getItemType() == ItemType.PRODUCT);
  }

  public List<CartItem> getServiceItems() {
    if (data.getCartItems() == null)
      return new ArrayList<>();
    return data.getCartItems().stream()
        .filter(item -> item.getItemType() == ItemType.SERVICE)
        .toList();
  }

  public List<CartItem> getProductItems() {
    if (data.getCartItems() == null)
      return new ArrayList<>();
    return data.getCartItems().stream()
        .filter(item -> item.getItemType() == ItemType.PRODUCT)
        .toList();
  }

  private void updateTotals() {
    if (data.getCartItems() == null || data.getCartItems().isEmpty()) {
      data.setTotalAmount(BigDecimal.ZERO);
      data.setTotalItems(0);
      return;
    }

    BigDecimal total = data.getCartItems().stream()
        .map(item -> item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
        .reduce(BigDecimal.ZERO, BigDecimal::add);
    data.setTotalAmount(total);

    int totalItems = data.getCartItems().stream()
        .mapToInt(CartItem::getQuantity)
        .sum();
    data.setTotalItems(totalItems);
  }

  // JSON Serialization Methods
  public void serializeData() {
    try {
      this.sessionData = objectMapper.writeValueAsString(this.data);
    } catch (JsonProcessingException e) {
      throw new RuntimeException("Failed to serialize cart session data", e);
    }
  }

  public void deserializeData() {
    if (this.sessionData != null && !this.sessionData.trim().isEmpty()) {
      try {
        this.data = objectMapper.readValue(this.sessionData, CartSessionData.class);
      } catch (JsonProcessingException e) {
        this.data = new CartSessionData(); // Fallback to empty data
      }
    } else {
      this.data = new CartSessionData();
    }
  }

  // Getters and Setters
  public String getSessionId() {
    return sessionId;
  }

  public void setSessionId(String sessionId) {
    this.sessionId = sessionId;
  }

  public Integer getCustomerId() {
    return customerId;
  }

  public void setCustomerId(Integer customerId) {
    this.customerId = customerId;
  }

  public Integer getCartId() {
    return cartId;
  }

  public void setCartId(Integer cartId) {
    this.cartId = cartId;
  }

  public String getSessionData() {
    return sessionData;
  }

  public void setSessionData(String sessionData) {
    this.sessionData = sessionData;
    deserializeData();
  }

  public LocalDateTime getExpiresAt() {
    return expiresAt;
  }

  public void setExpiresAt(LocalDateTime expiresAt) {
    this.expiresAt = expiresAt;
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

  public CartSessionData getData() {
    if (data == null) {
      deserializeData();
    }
    return data;
  }

  public void setData(CartSessionData data) {
    this.data = data;
    serializeData();
  }

  // Inner Classes for JSON Data Structure
  @JsonIgnoreProperties(ignoreUnknown = true)
  public static class CartSessionData {
    @JsonProperty("cartItems")
    private List<CartItem> cartItems = new ArrayList<>();

    @JsonProperty("totalAmount")
    private BigDecimal totalAmount = BigDecimal.ZERO;

    @JsonProperty("totalItems")
    private Integer totalItems = 0;

    @JsonProperty("discountCode")
    private String discountCode;

    @JsonProperty("discountAmount")
    private BigDecimal discountAmount = BigDecimal.ZERO;

    @JsonProperty("notes")
    private String notes;

    // Getters and Setters
    public List<CartItem> getCartItems() {
      return cartItems;
    }

    public void setCartItems(List<CartItem> cartItems) {
      this.cartItems = cartItems;
    }

    public BigDecimal getTotalAmount() {
      return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
      this.totalAmount = totalAmount;
    }

    public Integer getTotalItems() {
      return totalItems;
    }

    public void setTotalItems(Integer totalItems) {
      this.totalItems = totalItems;
    }

    public String getDiscountCode() {
      return discountCode;
    }

    public void setDiscountCode(String discountCode) {
      this.discountCode = discountCode;
    }

    public BigDecimal getDiscountAmount() {
      return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
      this.discountAmount = discountAmount;
    }

    public String getNotes() {
      return notes;
    }

    public void setNotes(String notes) {
      this.notes = notes;
    }
  }

  @JsonIgnoreProperties(ignoreUnknown = true)
  public static class CartItem {
    @JsonProperty("itemId")
    private Integer itemId;

    @JsonProperty("itemType")
    private ItemType itemType;

    @JsonProperty("itemName")
    private String itemName;

    @JsonProperty("price")
    private BigDecimal price;

    @JsonProperty("quantity")
    private Integer quantity = 1;

    @JsonProperty("description")
    private String description;

    @JsonProperty("imageUrl")
    private String imageUrl;

    @JsonProperty("categoryId")
    private Integer categoryId;

    @JsonProperty("categoryName")
    private String categoryName;

    @JsonProperty("duration")
    private Integer duration; // For services

    @JsonProperty("addedAt")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime addedAt = LocalDateTime.now();

    // Constructors
    public CartItem() {
    }

    public CartItem(Integer itemId, ItemType itemType, String itemName, BigDecimal price) {
      this.itemId = itemId;
      this.itemType = itemType;
      this.itemName = itemName;
      this.price = price;
      this.addedAt = LocalDateTime.now();
    }

    public CartItem(Integer itemId, ItemType itemType, String itemName, BigDecimal price, Integer quantity) {
      this(itemId, itemType, itemName, price);
      this.quantity = quantity;
    }

    // Getters and Setters
    public Integer getItemId() {
      return itemId;
    }

    public void setItemId(Integer itemId) {
      this.itemId = itemId;
    }

    public ItemType getItemType() {
      return itemType;
    }

    public void setItemType(ItemType itemType) {
      this.itemType = itemType;
    }

    public String getItemName() {
      return itemName;
    }

    public void setItemName(String itemName) {
      this.itemName = itemName;
    }

    public BigDecimal getPrice() {
      return price;
    }

    public void setPrice(BigDecimal price) {
      this.price = price;
    }

    public Integer getQuantity() {
      return quantity;
    }

    public void setQuantity(Integer quantity) {
      this.quantity = quantity;
    }

    public String getDescription() {
      return description;
    }

    public void setDescription(String description) {
      this.description = description;
    }

    public String getImageUrl() {
      return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
      this.imageUrl = imageUrl;
    }

    public Integer getCategoryId() {
      return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
      this.categoryId = categoryId;
    }

    public String getCategoryName() {
      return categoryName;
    }

    public void setCategoryName(String categoryName) {
      this.categoryName = categoryName;
    }

    public Integer getDuration() {
      return duration;
    }

    public void setDuration(Integer duration) {
      this.duration = duration;
    }

    public LocalDateTime getAddedAt() {
      return addedAt;
    }

    public void setAddedAt(LocalDateTime addedAt) {
      this.addedAt = addedAt;
    }

    public BigDecimal getTotalPrice() {
      return price.multiply(BigDecimal.valueOf(quantity));
    }
  }
}