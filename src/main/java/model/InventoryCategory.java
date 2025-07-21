package model;

public class InventoryCategory {
    private int inventoryCategoryId;
    private String name;
    private String description;
    private boolean isActive;

    public InventoryCategory() {}

    public InventoryCategory(int inventoryCategoryId, String name, String description, boolean isActive) {
        this.inventoryCategoryId = inventoryCategoryId;
        this.name = name;
        this.description = description;
        this.isActive = isActive;
    }

    public int getInventoryCategoryId() { return inventoryCategoryId; }
    public void setInventoryCategoryId(int inventoryCategoryId) { this.inventoryCategoryId = inventoryCategoryId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    @Override
    public String toString() {
        return "InventoryCategory{" +
                "inventoryCategoryId=" + inventoryCategoryId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", isActive=" + isActive +
                '}';
    }
} 