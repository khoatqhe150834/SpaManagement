package model;

public class InventoryIssueDetail {
    private int inventoryIssueDetailId;
    private int inventoryIssueId;
    private int inventoryItemId;
    private int quantity;
    private String note;

    public InventoryIssueDetail() {}

    public InventoryIssueDetail(int inventoryIssueDetailId, int inventoryIssueId, int inventoryItemId, int quantity, String note) {
        this.inventoryIssueDetailId = inventoryIssueDetailId;
        this.inventoryIssueId = inventoryIssueId;
        this.inventoryItemId = inventoryItemId;
        this.quantity = quantity;
        this.note = note;
    }

    public int getInventoryIssueDetailId() { return inventoryIssueDetailId; }
    public void setInventoryIssueDetailId(int inventoryIssueDetailId) { this.inventoryIssueDetailId = inventoryIssueDetailId; }
    public int getInventoryIssueId() { return inventoryIssueId; }
    public void setInventoryIssueId(int inventoryIssueId) { this.inventoryIssueId = inventoryIssueId; }
    public int getInventoryItemId() { return inventoryItemId; }
    public void setInventoryItemId(int inventoryItemId) { this.inventoryItemId = inventoryItemId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    @Override
    public String toString() {
        return "InventoryIssueDetail{" +
                "inventoryIssueDetailId=" + inventoryIssueDetailId +
                ", inventoryIssueId=" + inventoryIssueId +
                ", inventoryItemId=" + inventoryItemId +
                ", quantity=" + quantity +
                ", note='" + note + '\'' +
                '}';
    }
} 