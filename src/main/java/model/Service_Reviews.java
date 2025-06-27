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
public class Service_Reviews {
    
    private int reviewId;
    private Service serviceId;
    private Customer customerId;
    private BookingAppointment appointmentId;
    private int rating;
    private String title;
    private String comment;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Service_Reviews() {
    }

    public Service_Reviews(int reviewId, Service serviceId, Customer customerId, BookingAppointment appointmentId, int rating, String title, String comment, Timestamp createdAt, Timestamp updatedAt) {
        this.reviewId = reviewId;
        this.serviceId = serviceId;
        this.customerId = customerId;
        this.appointmentId = appointmentId;
        this.rating = rating;
        this.title = title;
        this.comment = comment;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public Service getServiceId() {
        return serviceId;
    }

    public void setServiceId(Service serviceId) {
        this.serviceId = serviceId;
    }

    public Customer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Customer customerId) {
        this.customerId = customerId;
    }

    public BookingAppointment getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(BookingAppointment appointmentId) {
        this.appointmentId = appointmentId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
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
        return "ServiceReview{" + "reviewId=" + reviewId + ", serviceId=" + serviceId + ", customerId=" + customerId + ", appointmentId=" + appointmentId + ", rating=" + rating + ", title=" + title + ", comment=" + comment + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }

}
