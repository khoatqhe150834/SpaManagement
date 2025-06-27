package dao;

import db.DBContext;
import model.Service_Reviews;
import model.Service;
import model.Customer;
import model.BookingAppointment;

import java.sql.*;
import java.util.*;

public class ServiceReviewDAO implements BaseDAO<Service_Reviews, Integer> {
    private ServiceDAO serviceDAO = new ServiceDAO();
    private CustomerDAO customerDAO = new CustomerDAO();
    private BookingAppointmentDAO appointmentDAO = new BookingAppointmentDAO();

    @Override
    public <S extends Service_Reviews> S save(S entity) {
        String sql = "INSERT INTO service_reviews (service_id, customer_id, appointment_id, rating, title, comment, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, entity.getServiceId().getServiceId());
            stmt.setInt(2, entity.getCustomerId().getCustomerId());
            stmt.setInt(3, entity.getAppointmentId().getAppointmentId());
            stmt.setInt(4, entity.getRating());
            stmt.setString(5, entity.getTitle());
            stmt.setString(6, entity.getComment());
            stmt.setTimestamp(7, entity.getCreatedAt());
            stmt.setTimestamp(8, entity.getUpdatedAt());
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                entity.setReviewId(rs.getInt(1));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return entity;
    }

    @Override
    public Optional<Service_Reviews> findById(Integer id) {
        String sql = "SELECT * FROM service_reviews WHERE review_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return Optional.of(mapResultSet(rs));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return Optional.empty();
    }

    @Override
    public List<Service_Reviews> findAll() {
        List<Service_Reviews> reviews = new ArrayList<>();
        String sql = "SELECT r.* FROM service_reviews r JOIN booking_appointments a ON r.appointment_id = a.appointment_id WHERE a.status = 'COMPLETED' ORDER BY r.created_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                reviews.add(mapResultSet(rs));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return reviews;
    }

    public List<Service_Reviews> findPaginated(int offset, int limit) {
        List<Service_Reviews> reviews = new ArrayList<>();
        String sql = "SELECT r.* FROM service_reviews r JOIN booking_appointments a ON r.appointment_id = a.appointment_id WHERE a.status = 'COMPLETED' ORDER BY r.created_at DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                reviews.add(mapResultSet(rs));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return reviews;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM service_reviews r JOIN booking_appointments a ON r.appointment_id = a.appointment_id WHERE a.status = 'COMPLETED'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    @Override
    public boolean existsById(Integer id) {
        return findById(id).isPresent();
    }

    @Override
    public void deleteById(Integer id) {
        String sql = "DELETE FROM service_reviews WHERE review_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    @Override
    public <S extends Service_Reviews> S update(S entity) {
        String sql = "UPDATE service_reviews SET service_id=?, customer_id=?, appointment_id=?, rating=?, title=?, comment=?, created_at=?, updated_at=? WHERE review_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, entity.getServiceId().getServiceId());
            stmt.setInt(2, entity.getCustomerId().getCustomerId());
            stmt.setInt(3, entity.getAppointmentId().getAppointmentId());
            stmt.setInt(4, entity.getRating());
            stmt.setString(5, entity.getTitle());
            stmt.setString(6, entity.getComment());
            stmt.setTimestamp(7, entity.getCreatedAt());
            stmt.setTimestamp(8, entity.getUpdatedAt());
            stmt.setInt(9, entity.getReviewId());
            stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return entity;
    }

    @Override
    public void delete(Service_Reviews entity) {
        deleteById(entity.getReviewId());
    }

    private Service_Reviews mapResultSet(ResultSet rs) throws SQLException {
        Service_Reviews review = new Service_Reviews();
        review.setReviewId(rs.getInt("review_id"));
        review.setServiceId(serviceDAO.findById(rs.getInt("service_id")).orElse(null));
        review.setCustomerId(customerDAO.findById(rs.getInt("customer_id")).orElse(null));
        review.setAppointmentId(appointmentDAO.findById(rs.getInt("appointment_id")).orElse(null));
        review.setRating(rs.getInt("rating"));
        review.setTitle(rs.getString("title"));
        review.setComment(rs.getString("comment"));
        review.setCreatedAt(rs.getTimestamp("created_at"));
        review.setUpdatedAt(rs.getTimestamp("updated_at"));
        return review;
    }
} 