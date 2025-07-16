package dao;

import db.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ServiceType;
import model.Staff;
import model.User;

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
        String sql = "SELECT t.*, u.full_name, u.email, u.phone_number, u.gender, u.birthday, u.avatar_url, u.address, st.name AS service_type_name, st.service_type_id "
                + "FROM therapists t "
                + "JOIN users u ON t.user_id = u.user_id "
                + "LEFT JOIN service_types st ON t.service_type_id = st.service_type_id "
                + "WHERE t.user_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Staff staff = mapResultSetToStaff(rs);
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
        String sql = "SELECT t.*, u.full_name, u.email, u.phone_number, u.gender, u.birthday, u.avatar_url, u.address, st.name AS service_type_name "
                + "FROM therapists t "
                + "JOIN users u ON t.user_id = u.user_id "
                + "LEFT JOIN service_types st ON t.service_type_id = st.service_type_id";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Staff staff = mapResultSetToStaff(rs);
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
        String sql = "UPDATE therapists SET service_type_id = ?, bio = ?, availability_status = ?, years_of_experience = ?, updated_at = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            // Set service_type_id
            if (entity.getServiceType() != null) {
                ps.setInt(1, entity.getServiceType().getServiceTypeId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }

            // Set other fields
            ps.setString(2, entity.getBio());
            ps.setString(3, entity.getAvailabilityStatus().name());
            ps.setInt(4, entity.getYearsOfExperience());
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            ps.setInt(6, entity.getUser().getUserId());

            LOGGER.info("Executing update query: " + sql);
            LOGGER.info("Parameters: userId=" + entity.getUser().getUserId() +
                    ", serviceTypeId="
                    + (entity.getServiceType() != null ? entity.getServiceType().getServiceTypeId() : "null") +
                    ", bio=" + entity.getBio() +
                    ", availabilityStatus=" + entity.getAvailabilityStatus() +
                    ", yearsOfExperience=" + entity.getYearsOfExperience());

            int rowsAffected = ps.executeUpdate();
            LOGGER.info(
                    "Update staff with userId: " + entity.getUser().getUserId() + ", rowsAffected: " + rowsAffected);
            if (rowsAffected >= 0)
                return entity;
            else
                return null;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating staff", e);
            return null;
        }
    }

    private Staff mapResultSetToStaff(ResultSet rs) throws SQLException {
        Staff staff = new Staff();

        // Set User information
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setGender(rs.getString("gender"));
        user.setBirthday(rs.getDate("birthday"));
        user.setAvatarUrl(rs.getString("avatar_url"));
        user.setAddress(rs.getString("address"));
        staff.setUser(user);

        // Set ServiceType information
        ServiceType serviceType = new ServiceType();
        serviceType.setServiceTypeId(rs.getInt("service_type_id"));
        serviceType.setName(rs.getString("service_type_name"));
        staff.setServiceType(serviceType);

        // Set other staff information
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

    // Lấy danh sách staff phân trang, có thể lọc theo keyword và status
    public List<Staff> searchByKeywordAndStatus(String keyword, String status, Integer serviceTypeId, int offset,
            int limit) {
        List<Staff> staffList = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT t.*, u.full_name, u.email, u.phone_number, u.gender, u.birthday, u.avatar_url, u.address, st.name AS service_type_name, st.service_type_id "
                        +
                        "FROM therapists t " +
                        "JOIN users u ON t.user_id = u.user_id " +
                        "LEFT JOIN service_types st ON t.service_type_id = st.service_type_id WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(u.full_name) LIKE ? OR LOWER(st.name) LIKE ?)");
            params.add("%" + keyword.toLowerCase() + "%");
            params.add("%" + keyword.toLowerCase() + "%");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND t.availability_status = ?");
            params.add(status.toUpperCase());
        }
        if (serviceTypeId != null && serviceTypeId > 0) {
            sql.append(" AND t.service_type_id = ?");
            params.add(serviceTypeId);
        }
        sql.append(" ORDER BY t.user_id LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Staff staff = mapResultSetToStaff(rs);
                    staffList.add(staff);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in searchByKeywordAndStatus", e);
        }
        return staffList;
    }

    // Đếm tổng số staff theo filter
    public int countByKeywordAndStatus(String keyword, String status, Integer serviceTypeId) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM therapists t " +
                        "JOIN users u ON t.user_id = u.user_id " +
                        "LEFT JOIN service_types st ON t.service_type_id = st.service_type_id WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(u.full_name) LIKE ? OR LOWER(st.name) LIKE ?)");
            params.add("%" + keyword.toLowerCase() + "%");
            params.add("%" + keyword.toLowerCase() + "%");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND t.availability_status = ?");
            params.add(status.toUpperCase());
        }
        if (serviceTypeId != null && serviceTypeId > 0) {
            sql.append(" AND t.service_type_id = ?");
            params.add(serviceTypeId);
        }
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in countByKeywordAndStatus", e);
        }
        return 0;
    }

    public List<Staff> findPaginated(int offset, int limit) {
        List<Staff> staffList = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name, u.email, u.phone_number, u.gender, u.birthday, u.avatar_url, u.address, st.name AS service_type_name "
                +
                "FROM therapists t " +
                "JOIN users u ON t.user_id = u.user_id " +
                "LEFT JOIN service_types st ON t.service_type_id = st.service_type_id " +
                "ORDER BY t.user_id LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Staff staff = mapResultSetToStaff(rs);
                    staffList.add(staff);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in findPaginated", e);
        }
        return staffList;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM therapists";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in countAll", e);
        }
        return 0;
    }

    public int deactiveById(int id) {
        String sql = "UPDATE therapists SET availability_status = 'OFFLINE' WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in deactiveById", e);
        }
        return 0;
    }

    /**
     * Find therapists qualified for a specific service type
     * 
     * @param serviceTypeId the ID of the service type
     * @return List of staff qualified for the service type
     */
    public List<Staff> findTherapistsByServiceType(int serviceTypeId) {
        List<Staff> staffList = new ArrayList<>();
        String sql = "SELECT t.*, u.full_name, u.email, u.phone_number, u.gender, u.birthday, u.avatar_url, u.address, st.name AS service_type_name, st.service_type_id "
                + "FROM therapists t "
                + "JOIN users u ON t.user_id = u.user_id "
                + "JOIN service_types st ON t.service_type_id = st.service_type_id "
                + "WHERE t.service_type_id = ? AND t.availability_status = 'AVAILABLE'";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceTypeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Staff staff = mapResultSetToStaff(rs);
                    staffList.add(staff);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding therapists by service type", e);
        }
        return staffList;
    }

    /**
     * Find therapists qualified for a specific service type (including OFFLINE
     * status)
     * 
     * @param serviceTypeId  the ID of the service type
     * @param includeOffline whether to include offline therapists
     * @return List of staff qualified for the service type
     */
    public List<Staff> findTherapistsByServiceType(int serviceTypeId, boolean includeOffline) {
        List<Staff> staffList = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT t.*, u.full_name, u.email, u.phone_number, u.gender, u.birthday, u.avatar_url, u.address, st.name AS service_type_name, st.service_type_id "
                        + "FROM therapists t "
                        + "JOIN users u ON t.user_id = u.user_id "
                        + "JOIN service_types st ON t.service_type_id = st.service_type_id "
                        + "WHERE t.service_type_id = ?");

        if (!includeOffline) {
            sql.append(" AND t.availability_status = 'AVAILABLE'");
        }

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, serviceTypeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Staff staff = mapResultSetToStaff(rs);
                    staffList.add(staff);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding therapists by service type", e);
        }
        return staffList;
    }

    /**
     * Main method for testing StaffDAO methods
     */
    public static void main(String[] args) {
        StaffDAO staffDAO = new StaffDAO();

        System.out.println("=== Testing StaffDAO Methods ===");

        // Test 1: Find all staff
        System.out.println("\n1. Testing findAll():");
        List<Staff> allStaff = staffDAO.findAll();
        System.out.println("Total staff found: " + allStaff.size());
        for (Staff staff : allStaff) {
            System.out.println("- " + staff.getUser().getFullName() +
                    " (Service Type: " + (staff.getServiceType() != null ? staff.getServiceType().getName() : "None") +
                    ", Status: " + staff.getAvailabilityStatus() + ")");
        }

        // Test 2: Find therapists by service type
        System.out.println("\n2. Testing findTherapistsByServiceType():");
        if (!allStaff.isEmpty()) {
            // Get the first staff's service type for testing
            Staff firstStaff = allStaff.get(0);
            if (firstStaff.getServiceType() != null) {
                int serviceTypeId = firstStaff.getServiceType().getServiceTypeId();
                System.out.println("Looking for therapists with service type ID: " + serviceTypeId);

                List<Staff> qualifiedTherapists = staffDAO.findTherapistsByServiceType(serviceTypeId);
                System.out.println("Qualified therapists found: " + qualifiedTherapists.size());
                for (Staff therapist : qualifiedTherapists) {
                    System.out.println("- " + therapist.getUser().getFullName() +
                            " (Experience: " + therapist.getYearsOfExperience() + " years)");
                }

                // Test with offline therapists included
                System.out.println("\n3. Testing findTherapistsByServiceType() with offline included:");
                List<Staff> allQualifiedTherapists = staffDAO.findTherapistsByServiceType(serviceTypeId, true);
                System.out.println("All qualified therapists (including offline): " + allQualifiedTherapists.size());
            } else {
                System.out.println("No service type found for testing");
            }
        } else {
            System.out.println("No staff found in database");
        }

        // Test 3: Count methods
        System.out.println("\n4. Testing count methods:");
        int totalCount = staffDAO.countAll();
        System.out.println("Total staff count: " + totalCount);

        // Test 4: Search functionality
        System.out.println("\n5. Testing search functionality:");
        List<Staff> searchResults = staffDAO.searchByKeywordAndStatus("", "AVAILABLE", null, 0, 10);
        System.out.println("Available staff found: " + searchResults.size());

        System.out.println("\n=== Testing completed ===");
    }

    // Kiểm tra userId đã tồn tại trong therapists
    public boolean existsByUserId(int userId) {
        String sql = "SELECT 1 FROM therapists WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if staff exists by userId", e);
        }
        return false;
    }

    // Kiểm tra fullName đã tồn tại trong therapists
    public boolean existsByFullName(String fullName) {
        String sql = "SELECT 1 FROM therapists t JOIN users u ON t.user_id = u.user_id WHERE u.full_name = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if staff exists by fullName", e);
        }
        return false;
    }

//    public Staff getStaffById(int staffUserId) {
//        Staff staff = null;
//        String sql = "SELECT * FROM therapists WHERE user_id = ?";
//        try (Connection conn = DBContext.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, staffUserId);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                staff = new Staff();
//                // ... set các trường khác ...
//                staff.setUserId(rs.getInt("user_id"));
//                staff.setFullName(rs.getString("full_name"));
//                // ... các trường khác ...
//
//                // Lấy danh sách chứng chỉ
//                CertificateDAO certificateDAO = new CertificateDAO();
//                List<Certificate> certificates = certificateDAO.getCertificatesByStaffId(staffUserId);
//                staff.setCertificates(certificates);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return staff;
//    }

    // Nếu có hàm lấy danh sách staff:
//    public List<Staff> getAllStaff() {
//        List<Staff> list = new ArrayList<>();
//        String sql = "SELECT * FROM therapists";
//        try (Connection conn = DBContext.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                Staff staff = new Staff();
//                // ... set các trường khác ...
//                int staffUserId = rs.getInt("user_id");
//                staff.setUserId(staffUserId);
//                staff.setFullName(rs.getString("full_name"));
//                // ... các trường khác ...
//
//                // Lấy danh sách chứng chỉ
//                CertificateDAO certificateDAO = new CertificateDAO();
//                List<Certificate> certificates = certificateDAO.getCertificatesByStaffId(staffUserId);
//                staff.setCertificates(certificates);
//
//                list.add(staff);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
}