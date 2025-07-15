package model;

import java.sql.Timestamp;

public class InventoryCategory {
    private int inventoryCategoryId;
    private String name;
    private String description;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public InventoryCategory() {}

    public InventoryCategory(int inventoryCategoryId, String name, String description, Timestamp createdAt, Timestamp updatedAt) {
        this.inventoryCategoryId = inventoryCategoryId;
        this.name = name;
        this.description = description;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getInventoryCategoryId() { return inventoryCategoryId; }
    public void setInventoryCategoryId(int inventoryCategoryId) { this.inventoryCategoryId = inventoryCategoryId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "InventoryCategory{" +
                "inventoryCategoryId=" + inventoryCategoryId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
} 