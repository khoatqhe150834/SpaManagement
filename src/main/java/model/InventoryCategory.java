package model;

public class InventoryCategory {
    private int inventoryCategoryId;
    private String name;
    private String description;

    public InventoryCategory() {}

    public InventoryCategory(int inventoryCategoryId, String name, String description) {
        this.inventoryCategoryId = inventoryCategoryId;
        this.name = name;
        this.description = description;
    }

    public int getInventoryCategoryId() { return inventoryCategoryId; }
    public void setInventoryCategoryId(int inventoryCategoryId) { this.inventoryCategoryId = inventoryCategoryId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    @Override
    public String toString() {
        return "InventoryCategory{" +
                "inventoryCategoryId=" + inventoryCategoryId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
} 