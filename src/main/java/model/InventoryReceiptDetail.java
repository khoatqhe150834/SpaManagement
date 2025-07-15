package model;

public class InventoryReceiptDetail {
    private int inventoryReceiptDetailId;
    private int inventoryReceiptId;
    private int inventoryItemId;
    private int quantity;
    private double unitPrice;
    private String note;

    public InventoryReceiptDetail() {}

    public InventoryReceiptDetail(int inventoryReceiptDetailId, int inventoryReceiptId, int inventoryItemId, int quantity, double unitPrice, String note) {
        this.inventoryReceiptDetailId = inventoryReceiptDetailId;
        this.inventoryReceiptId = inventoryReceiptId;
        this.inventoryItemId = inventoryItemId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.note = note;
    }

    public int getInventoryReceiptDetailId() { return inventoryReceiptDetailId; }
    public void setInventoryReceiptDetailId(int inventoryReceiptDetailId) { this.inventoryReceiptDetailId = inventoryReceiptDetailId; }
    public int getInventoryReceiptId() { return inventoryReceiptId; }
    public void setInventoryReceiptId(int inventoryReceiptId) { this.inventoryReceiptId = inventoryReceiptId; }
    public int getInventoryItemId() { return inventoryItemId; }
    public void setInventoryItemId(int inventoryItemId) { this.inventoryItemId = inventoryItemId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    @Override
    public String toString() {
        return "InventoryReceiptDetail{" +
                "inventoryReceiptDetailId=" + inventoryReceiptDetailId +
                ", inventoryReceiptId=" + inventoryReceiptId +
                ", inventoryItemId=" + inventoryItemId +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                ", note='" + note + '\'' +
                '}';
    }
} 