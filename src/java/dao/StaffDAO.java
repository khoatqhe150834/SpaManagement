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
        String sql = "INSERT INTO therapists(user_id, service_type_id, bio, availability_status, years_of_experience) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, entity.getUser().getUserId());
            if (entity.getServiceType() != null) {
                ps.setInt(2, entity.getServiceType().getServiceTypeId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, entity.getBio());
            ps.setString(4, entity.getAvailabilityStatus().name());
            ps.setInt(5, entity.getYearsOfExperience());
            ps.executeUpdate();
            return entity;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in saving staff", e);
            return null;
        }
    }

    @Override
    public Optional<Staff> findById(Integer id) {
        String sql = "SELECT t.*, u.full_name, st.name AS service_type_name "
                + "FROM therapists t "
                + "JOIN users u ON t.user_id = u.user_id "
                + "LEFT JOIN service_types st ON t.service_type_id = st.service_type_id "
                + "WHERE t.user_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Staff staff = mapResultSetToStaff(rs);
                    User user = new User();
                    user.setFullName(rs.getString("full_name"));
                    staff.setUser(user);

                    ServiceType serviceType = new ServiceType();
                    serviceType.setName(rs.getString("service_type_name"));
                    staff.setServiceType(serviceType);

                    return Optional.of(staff);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding staff by ID", e);
        }
        return Optional.empty();
    }

    @Override
    public List<Staff> findAll() {
        List<Staff> staffList = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name, st.name AS service_type_name "
                + "FROM therapists t "
                + "JOIN users u ON t.user_id = u.user_id "
                + "LEFT JOIN service_types st ON t.service_type_id = st.service_type_id";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Staff staff = new Staff();
                staff.setUser(new User());
                staff.getUser().setUserId(rs.getInt("user_id"));
                staff.getUser().setFullName(rs.getString("full_name"));

                ServiceType serviceType = new ServiceType();
                serviceType.setName(rs.getString("service_type_name"));
                staff.setServiceType(serviceType);

                staff.setBio(rs.getString("bio"));
                staff.setAvailabilityStatus(Staff.AvailabilityStatus.valueOf(rs.getString("availability_status")));
                staff.setYearsOfExperience(rs.getInt("years_of_experience"));
                staff.setCreatedAt(rs.getTimestamp("created_at"));
                staff.setUpdatedAt(rs.getTimestamp("updated_at"));

                staffList.add(staff);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all staff", e);
        }
        return staffList;
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
        // Câu lệnh SQL chỉ cần 5 tham số (service_type_id, bio, availability_status, years_of_experience, user_id)
        String sql = "UPDATE therapists SET service_type_id = ?, bio = ?, availability_status = ?, years_of_experience = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            // Kiểm tra xem entity.getServiceType() có khác null không, nếu không sẽ set null cho service_type_id
            ps.setObject(1, entity.getServiceType() != null ? entity.getServiceType().getServiceTypeId() : null, Types.INTEGER);
            ps.setString(2, entity.getBio());
            ps.setString(3, entity.getAvailabilityStatus().name());
            ps.setInt(4, entity.getYearsOfExperience());
            // Dùng userId để cập nhật dòng tương ứng với userId trong bảng therapists
            ps.setInt(5, entity.getUser().getUserId());

            // Thực thi câu lệnh UPDATE và trả về số dòng ảnh hưởng
            int rowsAffected = ps.executeUpdate();

            // Kiểm tra nếu không có dòng nào bị ảnh hưởng (tức là không cập nhật được)
            if (rowsAffected > 0) {
                System.out.println("Staff updated successfully.");
            } else {
                System.out.println("No rows updated, check user_id.");
            }

            return entity;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating staff", e);
            return null;
        }
    }

    private Staff mapResultSetToStaff(ResultSet rs) throws SQLException {
        Staff staff = new Staff();
        staff.setUser(new User());
        staff.getUser().setUserId(rs.getInt("user_id"));
        staff.setBio(rs.getString("bio"));
        staff.setAvailabilityStatus(Staff.AvailabilityStatus.valueOf(rs.getString("availability_status")));
        staff.setYearsOfExperience(rs.getInt("years_of_experience"));
        staff.setCreatedAt(rs.getTimestamp("created_at"));
        staff.setUpdatedAt(rs.getTimestamp("updated_at"));
        return staff;
    }

    @Override
    public void delete(Staff entity) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public List<Staff> searchByNameOrServiceType(String searchQuery) {
    List<Staff> staffList = new ArrayList<>();
    String sql = "SELECT t.*, u.full_name, st.name AS service_type_name "
               + "FROM therapists t "
               + "JOIN users u ON t.user_id = u.user_id "
               + "LEFT JOIN service_types st ON t.service_type_id = st.service_type_id "
               + "WHERE u.full_name LIKE ? OR st.name LIKE ?";

    try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        String searchPattern = "%" + searchQuery + "%"; // Tạo mẫu tìm kiếm
        ps.setString(1, searchPattern);
        ps.setString(2, searchPattern);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Staff staff = new Staff();
                staff.setUser(new User());
                staff.getUser().setUserId(rs.getInt("user_id"));
                staff.getUser().setFullName(rs.getString("full_name"));

                ServiceType serviceType = new ServiceType();
                serviceType.setName(rs.getString("service_type_name"));
                staff.setServiceType(serviceType);

                staff.setBio(rs.getString("bio"));
                staff.setAvailabilityStatus(Staff.AvailabilityStatus.valueOf(rs.getString("availability_status")));
                staff.setYearsOfExperience(rs.getInt("years_of_experience"));
                staff.setCreatedAt(rs.getTimestamp("created_at"));
                staff.setUpdatedAt(rs.getTimestamp("updated_at"));

                staffList.add(staff);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return staffList;
}


}