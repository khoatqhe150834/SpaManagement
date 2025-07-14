package model;

import java.sql.Timestamp;

public class InventoryTransaction {
    private int inventoryTransactionId;
    private int inventoryItemId;
    private String type; // IN, OUT, ADJUST
    private int quantity;
    private Timestamp transactionDate;
    private int userId;
    private String note;

    public InventoryTransaction() {}

    public InventoryTransaction(int inventoryTransactionId, int inventoryItemId, String type, int quantity, Timestamp transactionDate, int userId, String note) {
        this.inventoryTransactionId = inventoryTransactionId;
        this.inventoryItemId = inventoryItemId;
        this.type = type;
        this.quantity = quantity;
        this.transactionDate = transactionDate;
        this.userId = userId;
        this.note = note;
    }

    public int getInventoryTransactionId() { return inventoryTransactionId; }
    public void setInventoryTransactionId(int inventoryTransactionId) { this.inventoryTransactionId = inventoryTransactionId; }
    public int getInventoryItemId() { return inventoryItemId; }
    public void setInventoryItemId(int inventoryItemId) { this.inventoryItemId = inventoryItemId; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public Timestamp getTransactionDate() { return transactionDate; }
    public void setTransactionDate(Timestamp transactionDate) { this.transactionDate = transactionDate; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    @Override
    public String toString() {
        return "InventoryTransaction{" +
                "inventoryTransactionId=" + inventoryTransactionId +
                ", inventoryItemId=" + inventoryItemId +
                ", type='" + type + '\'' +
                ", quantity=" + quantity +
                ", transactionDate=" + transactionDate +
                ", userId=" + userId +
                ", note='" + note + '\'' +
                '}';
    }
} 