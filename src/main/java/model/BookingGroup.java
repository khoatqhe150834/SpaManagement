/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author ADMIN
 */
public class BookingGroup {
    private int bookingGroupId;
    private Customer representCustomer;
    private String groupName;
    private int expectedPax;
    private String groupNotes;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public BookingGroup() {
    }

    public BookingGroup(int bookingGroupId, Customer representCustomer, String groupName, int expectedPax, String groupNotes, String status, Timestamp createdAt, Timestamp updatedAt) {
        this.bookingGroupId = bookingGroupId;
        this.representCustomer = representCustomer;
        this.groupName = groupName;
        this.expectedPax = expectedPax;
        this.groupNotes = groupNotes;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getBookingGroupId() {
        return bookingGroupId;
    }

    public void setBookingGroupId(int bookingGroupId) {
        this.bookingGroupId = bookingGroupId;
    }

    public Customer getRepresentCustomer() {
        return representCustomer;
    }

    public void setRepresentCustomer(Customer representCustomer) {
        this.representCustomer = representCustomer;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public int getExpectedPax() {
        return expectedPax;
    }

    public void setExpectedPax(int expectedPax) {
        this.expectedPax = expectedPax;
    }

    public String getGroupNotes() {
        return groupNotes;
    }

    public void setGroupNotes(String groupNotes) {
        this.groupNotes = groupNotes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "BookingGroup{" + "bookingGroupId=" + bookingGroupId + ", representCustomer=" + representCustomer + ", groupName=" + groupName + ", expectedPax=" + expectedPax + ", groupNotes=" + groupNotes + ", status=" + status + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }
    
    
}
