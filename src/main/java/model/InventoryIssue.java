package model;

import java.sql.Timestamp;
import java.util.Date;

public class InventoryIssue {
    private int inventoryIssueId;
    private Date issueDate;
    private Integer bookingAppointmentId;
    private int requestedBy;
    private int approvedBy;
    private String status;
    private String note;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public InventoryIssue() {}

    public InventoryIssue(int inventoryIssueId, Date issueDate, Integer bookingAppointmentId, int requestedBy, int approvedBy, String status, String note, Timestamp createdAt, Timestamp updatedAt) {
        this.inventoryIssueId = inventoryIssueId;
        this.issueDate = issueDate;
        this.bookingAppointmentId = bookingAppointmentId;
        this.requestedBy = requestedBy;
        this.approvedBy = approvedBy;
        this.status = status;
        this.note = note;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getInventoryIssueId() { return inventoryIssueId; }
    public void setInventoryIssueId(int inventoryIssueId) { this.inventoryIssueId = inventoryIssueId; }
    public Date getIssueDate() { return issueDate; }
    public void setIssueDate(Date issueDate) { this.issueDate = issueDate; }
    public Integer getBookingAppointmentId() { return bookingAppointmentId; }
    public void setBookingAppointmentId(Integer bookingAppointmentId) { this.bookingAppointmentId = bookingAppointmentId; }
    public int getRequestedBy() { return requestedBy; }
    public void setRequestedBy(int requestedBy) { this.requestedBy = requestedBy; }
    public int getApprovedBy() { return approvedBy; }
    public void setApprovedBy(int approvedBy) { this.approvedBy = approvedBy; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "InventoryIssue{" +
                "inventoryIssueId=" + inventoryIssueId +
                ", issueDate=" + issueDate +
                ", bookingAppointmentId=" + bookingAppointmentId +
                ", requestedBy=" + requestedBy +
                ", approvedBy=" + approvedBy +
                ", status='" + status + '\'' +
                ", note='" + note + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
} 