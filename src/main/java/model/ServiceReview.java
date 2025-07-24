package model;

import java.sql.Timestamp;

public class ServiceReview {
    private int reviewId;
    private int serviceId;
    private int customerId;
    private int bookingId;
    private int therapistUserId;
    private int rating;
    private String title;
    private String comment;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private boolean isVisible;
    private String managerReply;

    // Getters and setters
    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getTherapistUserId() { return therapistUserId; }
    public void setTherapistUserId(int therapistUserId) { this.therapistUserId = therapistUserId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public boolean isVisible() { return isVisible; }
    public void setVisible(boolean visible) { isVisible = visible; }

    public String getManagerReply() { return managerReply; }
    public void setManagerReply(String managerReply) { this.managerReply = managerReply; }
} 