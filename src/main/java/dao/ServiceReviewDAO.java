package dao;

import db.DBContext;
import model.ServiceReview;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceReviewDAO {
    // Thêm review mới
    public boolean addReview(ServiceReview review) throws SQLException {
        String sql = "INSERT INTO service_reviews (service_id, customer_id, booking_id, therapist_user_id, rating, title, comment, is_visible, manager_reply) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, review.getServiceId());
            stmt.setInt(2, review.getCustomerId());
            stmt.setInt(3, review.getBookingId());
            stmt.setInt(4, review.getTherapistUserId());
            stmt.setInt(5, review.getRating());
            stmt.setString(6, review.getTitle());
            stmt.setString(7, review.getComment());
            stmt.setBoolean(8, review.isVisible());
            stmt.setString(9, review.getManagerReply());
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                updateServiceAverageRating(review.getServiceId(), conn);
                return true;
            }
        }
        return false;
    }

    // Lấy danh sách review theo service_id
    public List<ServiceReview> getReviewsByService(int serviceId) throws SQLException {
        List<ServiceReview> list = new ArrayList<>();
        String sql = "SELECT * FROM service_reviews WHERE service_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        }
        return list;
    }

    // Lấy review theo id
    public ServiceReview getReviewById(int reviewId) throws SQLException {
        String sql = "SELECT r.*, s.name AS service_name, c.full_name AS customer_name FROM service_reviews r " +
                "JOIN services s ON r.service_id = s.service_id " +
                "JOIN customers c ON r.customer_id = c.customer_id " +
                "WHERE r.review_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reviewId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        }
        return null;
    }

    // Lấy tất cả review (cho manager)
    public List<ServiceReview> getAllReviews() throws SQLException {
        List<ServiceReview> list = new ArrayList<>();
        String sql = "SELECT r.*, s.name AS service_name, c.full_name AS customer_name FROM service_reviews r " +
                "JOIN services s ON r.service_id = s.service_id " +
                "JOIN customers c ON r.customer_id = c.customer_id " +
                "ORDER BY r.created_at DESC";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        }
        return list;
    }

    // Cập nhật phản hồi của manager
    public boolean updateManagerReply(int reviewId, String reply) throws SQLException {
        String sql = "UPDATE service_reviews SET manager_reply = ? WHERE review_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, reply);
            stmt.setInt(2, reviewId);
            int affected = stmt.executeUpdate();
            return affected > 0;
        }
    }

    // Cập nhật average_rating cho bảng services
    public void updateServiceAverageRating(int serviceId, Connection conn) throws SQLException {
        String sql = "UPDATE services SET average_rating = (SELECT COALESCE(AVG(rating), 0) FROM service_reviews WHERE service_id = ?) WHERE service_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            stmt.setInt(2, serviceId);
            stmt.executeUpdate();
        }
    }

    // Map ResultSet sang ServiceReview
    private ServiceReview mapResultSet(ResultSet rs) throws SQLException {
        ServiceReview review = new ServiceReview();
        review.setReviewId(rs.getInt("review_id"));
        review.setServiceId(rs.getInt("service_id"));
        review.setCustomerId(rs.getInt("customer_id"));
        review.setBookingId(rs.getInt("booking_id"));
        review.setTherapistUserId(rs.getInt("therapist_user_id"));
        review.setRating(rs.getInt("rating"));
        review.setTitle(rs.getString("title"));
        review.setComment(rs.getString("comment"));
        review.setCreatedAt(rs.getTimestamp("created_at"));
        review.setUpdatedAt(rs.getTimestamp("updated_at"));
        review.setVisible(rs.getBoolean("is_visible"));
        review.setManagerReply(rs.getString("manager_reply"));
        // Map thêm tên dịch vụ và tên khách hàng nếu có
        try { review.setServiceName(rs.getString("service_name")); } catch (SQLException ignore) {}
        try { review.setCustomerName(rs.getString("customer_name")); } catch (SQLException ignore) {}
        return review;
    }
} 