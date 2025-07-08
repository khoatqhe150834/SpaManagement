package dao;

import db.DBContext;
import model.ServiceType;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ServiceTypeDAO implements BaseDAO<ServiceType, Integer> {

    @Override
    public List<ServiceType> findAll() {
        List<ServiceType> serviceTypes = new ArrayList<>();
        String sql = "SELECT * FROM Service_Types";

        try (Connection connection = DBContext.getConnection();
                PreparedStatement stm = connection.prepareStatement(sql);
                ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                ServiceType serviceType = new ServiceType();
                serviceType.setServiceTypeId(rs.getInt("service_type_id"));
                serviceType.setName(rs.getString("name"));
                serviceType.setDescription(rs.getString("description"));
                serviceType.setImageUrl(rs.getString("image_url"));
                serviceType.setActive(rs.getBoolean("is_active"));
                serviceType.setCreatedAt(rs.getTimestamp("created_at"));
                serviceType.setUpdatedAt(rs.getTimestamp("updated_at"));
                serviceTypes.add(serviceType);
            }

        } catch (SQLException ex) {
            Logger.getLogger(ServiceTypeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return serviceTypes;
    }

    @Override
    public Optional<ServiceType> findById(Integer id) {
        String sql = "SELECT * FROM Service_Types WHERE service_type_id = ?";

        try (Connection connection = DBContext.getConnection();
                PreparedStatement stm = connection.prepareStatement(sql)) {

            stm.setInt(1, id);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    ServiceType st = new ServiceType();
                    st.setServiceTypeId(rs.getInt("service_type_id"));
                    st.setName(rs.getString("name"));
                    st.setDescription(rs.getString("description"));
                    st.setImageUrl(rs.getString("image_url"));
                    st.setActive(rs.getBoolean("is_active"));
                    st.setCreatedAt(rs.getTimestamp("created_at"));
                    st.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return Optional.of(st);
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(ServiceTypeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return Optional.empty();
    }

    @Override
    public <S extends ServiceType> S save(S entity) {
        String sql = "INSERT INTO Service_Types (name, description, image_url, is_active) VALUES (?, ?, ?, ?)";

        try (Connection connection = DBContext.getConnection();
                PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stm.setString(1, entity.getName());
            stm.setString(2, entity.getDescription());
            stm.setString(3, entity.getImageUrl());
            stm.setBoolean(4, entity.isActive());

            stm.executeUpdate();
            try (ResultSet rs = stm.getGeneratedKeys()) {
                if (rs.next()) {
                    entity.setServiceTypeId(rs.getInt(1));
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(ServiceTypeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return entity;
    }

    @Override
    public <S extends ServiceType> S update(S entity) {
        String sql = "UPDATE Service_Types SET name = ?, description = ?, image_url = ?, is_active = ? WHERE service_type_id = ?";

        try (Connection connection = DBContext.getConnection();
                PreparedStatement stm = connection.prepareStatement(sql)) {

            stm.setString(1, entity.getName());
            stm.setString(2, entity.getDescription());
            stm.setString(3, entity.getImageUrl());
            stm.setBoolean(4, entity.isActive());
            stm.setInt(5, entity.getServiceTypeId());

            stm.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(ServiceTypeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return entity;
    }

    @Override
    public void deleteById(Integer id) {
        String sql = "DELETE FROM Service_Types WHERE service_type_id = ?";

        try (Connection connection = DBContext.getConnection();
                PreparedStatement stm = connection.prepareStatement(sql)) {

            stm.setInt(1, id);
            stm.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(ServiceTypeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void delete(ServiceType entity) {
        deleteById(entity.getServiceTypeId());
    }

    @Override
    public boolean existsById(Integer id) {
        String sql = "SELECT 1 FROM Service_Types WHERE service_type_id = ?";
        try (Connection connection = DBContext.getConnection();
                PreparedStatement stm = connection.prepareStatement(sql)) {

            stm.setInt(1, id);
            try (ResultSet rs = stm.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException ex) {
            Logger.getLogger(ServiceTypeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return false;
    }

    public List<ServiceType> findByKeyword(String keyword) {
        List<ServiceType> serviceTypes = new ArrayList<>();
        String sql = "SELECT * FROM Service_Types WHERE LOWER(name) LIKE ? OR LOWER(description) LIKE ?";

        try (Connection connection = DBContext.getConnection();
                PreparedStatement stm = connection.prepareStatement(sql)) {

            String queryParam = "%" + keyword.toLowerCase() + "%";
            stm.setString(1, queryParam);
            stm.setString(2, queryParam);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    ServiceType serviceType = new ServiceType();
                    serviceType.setServiceTypeId(rs.getInt("service_type_id"));
                    serviceType.setName(rs.getString("name"));
                    serviceType.setDescription(rs.getString("description"));
                    serviceType.setImageUrl(rs.getString("image_url"));
                    serviceType.setActive(rs.getBoolean("is_active"));
                    serviceType.setCreatedAt(rs.getTimestamp("created_at"));
                    serviceType.setUpdatedAt(rs.getTimestamp("updated_at"));
                    serviceTypes.add(serviceType);
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(ServiceTypeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return serviceTypes;
    }

    public int deactiveById(int id) {
        String sql = "UPDATE service_types SET is_active = 0 WHERE service_type_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            int affectedRows = stmt.executeUpdate(); // ✅ Lấy số dòng bị ảnh hưởng
            return affectedRows; // ✅ Trả về giá trị đúng
        } catch (SQLException ex) {
            Logger.getLogger(ServiceTypeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0; // nếu lỗi
    }

    public List<ServiceType> findPaginated(int offset, int limit) {
        List<ServiceType> serviceTypes = new ArrayList<>();
        String sql = "SELECT * FROM Service_Types ORDER BY service_type_id LIMIT ? OFFSET ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {

            stm.setInt(1, limit);
            stm.setInt(2, offset);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    ServiceType st = new ServiceType();
                    st.setServiceTypeId(rs.getInt("service_type_id"));
                    st.setName(rs.getString("name"));
                    st.setDescription(rs.getString("description"));
                    st.setImageUrl(rs.getString("image_url"));
                    st.setActive(rs.getBoolean("is_active"));
                    st.setCreatedAt(rs.getTimestamp("created_at"));
                    st.setUpdatedAt(rs.getTimestamp("updated_at"));
                    serviceTypes.add(st);
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(ServiceTypeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return serviceTypes;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM Service_Types";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql);
                ResultSet rs = stm.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException ex) {
            Logger.getLogger(ServiceTypeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public List<ServiceType> searchByKeywordAndStatus(String keyword, String status, int offset, int limit) {
        List<ServiceType> serviceTypes = new ArrayList<>();
        String sql = "SELECT * FROM Service_Types WHERE 1=1";
        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND (name LIKE ? OR description LIKE ?)";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND is_active = ?";
        }
        sql += " LIMIT ? OFFSET ?";

        try (Connection connection = DBContext.getConnection();
                PreparedStatement stm = connection.prepareStatement(sql)) {
            int paramIndex = 1;
            if (keyword != null && !keyword.isEmpty()) {
                stm.setString(paramIndex++, "%" + keyword + "%");
                stm.setString(paramIndex++, "%" + keyword + "%");
            }
            if (status != null && !status.isEmpty()) {
                stm.setBoolean(paramIndex++, status.equalsIgnoreCase("active"));
            }
            stm.setInt(paramIndex++, limit);
            stm.setInt(paramIndex, offset);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    ServiceType st = new ServiceType();
                    st.setServiceTypeId(rs.getInt("service_type_id"));
                    st.setName(rs.getString("name"));
                    st.setDescription(rs.getString("description"));
                    st.setImageUrl(rs.getString("image_url"));
                    st.setActive(rs.getBoolean("is_active"));
                    st.setCreatedAt(rs.getTimestamp("created_at"));
                    st.setUpdatedAt(rs.getTimestamp("updated_at"));
                    serviceTypes.add(st);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return serviceTypes;
    }

    public int countSearchResult(String keyword, String status) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Service_Types WHERE 1=1";
        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND (name LIKE ? OR description LIKE ?)";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND is_active = ?";
        }
        try (Connection connection = DBContext.getConnection();
                PreparedStatement stm = connection.prepareStatement(sql)) {
            int paramIndex = 1;
            if (keyword != null && !keyword.isEmpty()) {
                stm.setString(paramIndex++, "%" + keyword + "%");
                stm.setString(paramIndex++, "%" + keyword + "%");
            }
            if (status != null && !status.isEmpty()) {
                stm.setBoolean(paramIndex++, status.equalsIgnoreCase("active"));
            }
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return count;
    }

    public boolean existsByName(String name) {
        String sql = "SELECT 1 FROM Service_Types WHERE LOWER(name) = LOWER(?)";
        try (Connection connection = DBContext.getConnection();
                PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, name.trim());
            try (ResultSet rs = stm.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException ex) {
            Logger.getLogger(ServiceTypeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean existsByNameExceptId(String name, int excludeId) {
        String sql = "SELECT 1 FROM Service_Types WHERE LOWER(name) = LOWER(?) AND service_type_id <> ?";
        try (Connection connection = DBContext.getConnection();
                PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, name.trim());
            stm.setInt(2, excludeId);
            try (ResultSet rs = stm.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException ex) {
            Logger.getLogger(ServiceTypeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public List<ServiceType> getActiveServiceTypes() throws SQLException {
        List<ServiceType> serviceTypes = new ArrayList<>();
        String sql = "SELECT * FROM Service_Types WHERE is_active = 1";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql);
                ResultSet rs = stm.executeQuery()) {
            while (rs.next()) {
                ServiceType serviceType = new ServiceType();
                serviceType.setServiceTypeId(rs.getInt("service_type_id"));
                serviceType.setName(rs.getString("name"));
                serviceType.setDescription(rs.getString("description"));
                serviceType.setImageUrl(rs.getString("image_url"));
                serviceType.setActive(rs.getBoolean("is_active"));
                serviceType.setCreatedAt(rs.getTimestamp("created_at"));
                serviceType.setUpdatedAt(rs.getTimestamp("updated_at"));
                serviceTypes.add(serviceType);
            }
        }
        return serviceTypes;
    }

    public List<ServiceType> getHotServiceTypes() throws SQLException {
        List<ServiceType> hotServiceTypes = new ArrayList<>();
        String sql = "SELECT st.service_type_id, st.name, st.description, st.image_url, COUNT(a.appointment_id) AS booking_count "
                + "FROM service_types st "
                + "JOIN services s ON st.service_type_id = s.service_type_id "
                + "JOIN appointments a ON s.service_id = a.service_id "
                + "WHERE a.status IN ('CONFIRMED', 'IN_PROGRESS', 'COMPLETED') "
                + "GROUP BY st.service_type_id, st.name, st.description, st.image_url "
                + "ORDER BY booking_count DESC "
                + "LIMIT 3";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql);
                ResultSet rs = stm.executeQuery()) {
            while (rs.next()) {
                ServiceType st = new ServiceType();
                st.setServiceTypeId(rs.getInt("service_type_id"));
                st.setName(rs.getString("name"));
                st.setDescription(rs.getString("description"));
                st.setImageUrl(rs.getString("image_url"));
                st.setActive(true); // is_active is assumed true for hot services
                hotServiceTypes.add(st);
            }
        }
        return hotServiceTypes;
    }

    public int activateById(int id) {
        String sql = "UPDATE service_types SET is_active = 1 WHERE service_type_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ServiceTypeDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    private void closeConnections() {
        try {
            // ... existing code ...
        } catch (Exception e) {
            // Handle exceptions appropriately
            e.printStackTrace();
        }
    }

    // public static void main(String[] args) {
    // ServiceTypeDAO dao = new ServiceTypeDAO();
    //
    // // Thay đổi ID tùy theo dữ liệu có trong database
    // int testId = 1;
    //
    // Optional<ServiceType> optional = dao.findById(testId);
    //
    // if (optional.isPresent()) {
    // ServiceType st = optional.get();
    // System.out.println(st);
    // } else {
    // System.out.println("ServiceType with ID " + testId + " not found.");
    // }
    // }
}
