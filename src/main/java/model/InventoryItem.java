package model;

import java.sql.Timestamp;

public class InventoryItem {
    private int inventoryItemId;
    private String name;
    private Integer inventoryCategoryId;
    private Integer supplierId;
    private String unit;
    private int quantity;
    private int minQuantity;
    private String description;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public InventoryItem() {}

    public InventoryItem(int inventoryItemId, String name, Integer inventoryCategoryId, Integer supplierId, String unit, int quantity, int minQuantity, String description, Timestamp createdAt, Timestamp updatedAt) {
        this.inventoryItemId = inventoryItemId;
        this.name = name;
        this.inventoryCategoryId = inventoryCategoryId;
        this.supplierId = supplierId;
        this.unit = unit;
        this.quantity = quantity;
        this.minQuantity = minQuantity;
        this.description = description;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getInventoryItemId() { return inventoryItemId; }
    public void setInventoryItemId(int inventoryItemId) { this.inventoryItemId = inventoryItemId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Integer getInventoryCategoryId() { return inventoryCategoryId; }
    public void setInventoryCategoryId(Integer inventoryCategoryId) { this.inventoryCategoryId = inventoryCategoryId; }
    public Integer getSupplierId() { return supplierId; }
    public void setSupplierId(Integer supplierId) { this.supplierId = supplierId; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public int getMinQuantity() { return minQuantity; }
    public void setMinQuantity(int minQuantity) { this.minQuantity = minQuantity; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "InventoryItem{" +
                "inventoryItemId=" + inventoryItemId +
                ", name='" + name + '\'' +
                ", inventoryCategoryId=" + inventoryCategoryId +
                ", supplierId=" + supplierId +
                ", unit='" + unit + '\'' +
                ", quantity=" + quantity +
                ", minQuantity=" + minQuantity +
                ", description='" + description + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
} 