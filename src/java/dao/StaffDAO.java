package dao;

import db.DBContext;
import model.ServiceType;
import model.Staff;
import model.User;
import model.Staff.AvailabilityStatus;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class StaffDAO implements BaseDAO<Staff, Integer> {

    private static final Logger LOGGER = Logger.getLogger(StaffDAO.class.getName());

    @Override
    public <S extends Staff> S save(S entity) {
        String sql = "INSERT INTO therapists(user_id, service_type_id, bio, availability_status, years_of_experience, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, entity.getUser().getUserId());
            if (entity.getServiceType() != null) {
                ps.setInt(2, entity.getServiceType().getServiceTypeId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, entity.getBio());
            ps.setString(4, entity.getAvailabilityStatus() != null ? entity.getAvailabilityStatus().name() : null);
            ps.setInt(5, entity.getYearsOfExperience());
            ps.setTimestamp(6, entity.getCreatedAt());
            ps.setTimestamp(7, entity.getUpdatedAt());
            ps.executeUpdate();
            return entity;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in saving staff", e);
            return null;
        }
    }

    @Override
    public Optional<Staff> findById(Integer id) {
        String sql = "SELECT * FROM therapists WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToStaff(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding staff by ID", e);
        }
        return Optional.empty();
    }

    @Override
    public List<Staff> findAll() {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT * FROM therapists";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToStaff(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all staff", e);
        }
        return list;
    }

    @Override
    public boolean existsById(Integer id) {
        String sql = "SELECT 1 FROM therapists WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if staff exists by ID", e);
        }
        return false;
    }

    @Override
    public void deleteById(Integer id) {
        String sql = "DELETE FROM therapists WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting staff by ID", e);
        }
    }

    @Override
    public <S extends Staff> S update(S entity) {
        String sql = "UPDATE therapists SET service_type_id = ?, bio = ?, availability_status = ?, years_of_experience = ?, updated_at = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (entity.getServiceType() != null) {
                ps.setInt(1, entity.getServiceType().getServiceTypeId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, entity.getBio());
            ps.setString(3, entity.getAvailabilityStatus() != null ? entity.getAvailabilityStatus().name() : null);
            ps.setInt(4, entity.getYearsOfExperience());
            ps.setTimestamp(5, entity.getUpdatedAt());
            ps.setInt(6, entity.getUser().getUserId());
            ps.executeUpdate();
            return entity;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating staff", e);
            return null;
        }
    }

    @Override
    public void delete(Staff entity) {
        if (entity != null && entity.getUser() != null) {
            deleteById(entity.getUser().getUserId());
        }
    }

    // Helper method to map ResultSet to Staff object
    private Staff mapResultSetToStaff(ResultSet rs) throws SQLException {
        Staff staff = new Staff();

        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        staff.setUser(user);

        int serviceTypeId = rs.getInt("service_type_id");
        if (rs.wasNull()) {
            staff.setServiceType(null);
        } else {
            ServiceType serviceType = new ServiceType();
            serviceType.setServiceTypeId(serviceTypeId);
            staff.setServiceType(serviceType);
        }

        staff.setBio(rs.getString("bio"));

        String availabilityStr = rs.getString("availability_status");
        AvailabilityStatus availabilityStatus = availabilityStr != null ? AvailabilityStatus.valueOf(availabilityStr) : null;
        staff.setAvailabilityStatus(availabilityStatus);

        staff.setYearsOfExperience(rs.getInt("years_of_experience"));
        staff.setCreatedAt(rs.getTimestamp("created_at"));
        staff.setUpdatedAt(rs.getTimestamp("updated_at"));

        return staff;
    }

    public static void main(String[] args) {
        StaffDAO staffDAO = new StaffDAO();
        List<Staff> staffList = staffDAO.findAll();
        for (Staff staff : staffList) {
            System.out.println(staff);
        }
    }
}
