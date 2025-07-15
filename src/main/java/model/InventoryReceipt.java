package model;

import java.sql.Timestamp;
import java.util.Date;

public class InventoryReceipt {
    private int inventoryReceiptId;
    private Date receiptDate;
    private int supplierId;
    private int createdBy;
    private String note;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public InventoryReceipt() {}

    public InventoryReceipt(int inventoryReceiptId, Date receiptDate, int supplierId, int createdBy, String note, Timestamp createdAt, Timestamp updatedAt) {
        this.inventoryReceiptId = inventoryReceiptId;
        this.receiptDate = receiptDate;
        this.supplierId = supplierId;
        this.createdBy = createdBy;
        this.note = note;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getInventoryReceiptId() { return inventoryReceiptId; }
    public void setInventoryReceiptId(int inventoryReceiptId) { this.inventoryReceiptId = inventoryReceiptId; }
    public Date getReceiptDate() { return receiptDate; }
    public void setReceiptDate(Date receiptDate) { this.receiptDate = receiptDate; }
    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }
    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "InventoryReceipt{" +
                "inventoryReceiptId=" + inventoryReceiptId +
                ", receiptDate=" + receiptDate +
                ", supplierId=" + supplierId +
                ", createdBy=" + createdBy +
                ", note='" + note + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
} 