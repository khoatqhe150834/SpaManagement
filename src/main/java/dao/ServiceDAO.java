package dao;

import db.DBContext;
import model.Service;
import model.ServiceType;

import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ServiceDAO implements BaseDAO<Service, Integer> {

    @Override
    public <S extends Service> S save(S entity) {
        String sql = "INSERT INTO services (service_type_id, name, description, price, duration_minutes, buffer_time_after_minutes, image_url, is_active, average_rating, bookable_online, requires_consultation) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, entity.getServiceTypeId().getServiceTypeId());
            stmt.setString(2, entity.getName());
            stmt.setString(3, entity.getDescription());
            stmt.setBigDecimal(4, entity.getPrice());
            stmt.setInt(5, entity.getDurationMinutes());
            stmt.setInt(6, entity.getBufferTimeAfterMinutes());
            stmt.setString(7, entity.getImageUrl());
            stmt.setBoolean(8, entity.isIsActive());
            stmt.setBigDecimal(9, entity.getAverageRating());
            stmt.setBoolean(10, entity.isBookableOnline());
            stmt.setBoolean(11, entity.isRequiresConsultation());

            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                entity.setServiceId(rs.getInt(1));
            }

        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return entity;
    }

    @Override
    public Optional<Service> findById(Integer id) {
        String sql = "SELECT * FROM services WHERE service_id = ?";
        ServiceTypeDAO typeDAO = new ServiceTypeDAO();
        Map<Integer, ServiceType> typeMap = new HashMap<>();
        for (ServiceType type : typeDAO.findAll()) {
            typeMap.put(type.getServiceTypeId(), type);
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return Optional.of(mapResultSet(rs, typeMap));
            }

        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return Optional.empty();
    }

    @Override
    public List<Service> findAll() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM services";

        ServiceTypeDAO typeDAO = new ServiceTypeDAO();
        Map<Integer, ServiceType> typeMap = new HashMap<>();
        for (ServiceType type : typeDAO.findAll()) {
            typeMap.put(type.getServiceTypeId(), type);
        }

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                services.add(mapResultSet(rs, typeMap));
            }

        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return services;
    }

    public List<Service> findByKeyword(String keyword) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM services WHERE LOWER(name) LIKE ? OR LOWER(description) LIKE ?";

        ServiceTypeDAO typeDAO = new ServiceTypeDAO();
        Map<Integer, ServiceType> typeMap = new HashMap<>();
        for (ServiceType type : typeDAO.findAll()) {
            typeMap.put(type.getServiceTypeId(), type);
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Normalize search keyword: trim and handle multiple spaces
            String normalizedKeyword = keyword.trim().replaceAll("\\s+", " ").toLowerCase();
            String query = "%" + normalizedKeyword + "%";
            stmt.setString(1, query);
            stmt.setString(2, query);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    services.add(mapResultSet(rs, typeMap));
                }
            }

        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return services;
    }

    @Override
    public boolean existsById(Integer id) {
        return findById(id).isPresent();
    }

    @Override
    public void deleteById(Integer id) {
        String sql = "DELETE FROM services WHERE service_id = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public <S extends Service> S update(S entity) {
        String sql = "UPDATE services SET service_type_id = ?, name = ?, description = ?, price = ?, duration_minutes = ?, buffer_time_after_minutes = ?, image_url = ?, is_active = ?, average_rating = ?, bookable_online = ?, requires_consultation = ? WHERE service_id = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, entity.getServiceTypeId().getServiceTypeId());
            stmt.setString(2, entity.getName());
            stmt.setString(3, entity.getDescription());
            stmt.setBigDecimal(4, entity.getPrice());
            stmt.setInt(5, entity.getDurationMinutes());
            stmt.setInt(6, entity.getBufferTimeAfterMinutes());
            stmt.setString(7, entity.getImageUrl());
            stmt.setBoolean(8, entity.isIsActive());
            stmt.setBigDecimal(9, entity.getAverageRating());
            stmt.setBoolean(10, entity.isBookableOnline());
            stmt.setBoolean(11, entity.isRequiresConsultation());
            stmt.setInt(12, entity.getServiceId());

            stmt.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return entity;
    }

    @Override
    public void delete(Service entity) {
        deleteById(entity.getServiceId());
    }

    public List<Service> findByServiceTypeId(int serviceTypeId) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM services WHERE service_type_id = ?";

        ServiceTypeDAO typeDAO = new ServiceTypeDAO();
        ServiceType serviceType = typeDAO.findById(serviceTypeId).orElse(null);

        System.out.println("Service Type: " + serviceType);

        try (Connection conn = DBContext.getConnection(); PreparedStatement stm = conn.prepareStatement(sql)) {
            stm.setInt(1, serviceTypeId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Service s = new Service();
                    s.setServiceId(rs.getInt("service_id"));
                    s.setServiceTypeId(serviceType);
                    s.setName(rs.getString("name"));
                    s.setDescription(rs.getString("description"));
                    s.setPrice(rs.getBigDecimal("price"));
                    s.setDurationMinutes(rs.getInt("duration_minutes"));
                    s.setBufferTimeAfterMinutes(rs.getInt("buffer_time_after_minutes"));
                    s.setImageUrl(rs.getString("image_url"));
                    s.setIsActive(rs.getBoolean("is_active"));
                    s.setAverageRating(rs.getBigDecimal("average_rating"));
                    s.setBookableOnline(rs.getBoolean("bookable_online"));
                    s.setRequiresConsultation(rs.getBoolean("requires_consultation"));
                    s.setCreatedAt(rs.getTimestamp("created_at"));
                    s.setUpdatedAt(rs.getTimestamp("updated_at"));

                    services.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return services;
    }

    public void deactivateById(int id) {
        String sql = "UPDATE services SET is_active = 0 WHERE service_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public List<Service> searchServices(String keyword, String status, Integer serviceTypeId, int offset, int limit) {
        List<Service> services = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM services WHERE 1=1");
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            sql.append(" AND (LOWER(name) LIKE ? OR LOWER(description) LIKE ?)");
        }
        if (serviceTypeId != null) {
            sql.append(" AND service_type_id = ?");
        }
        if ("active".equalsIgnoreCase(status)) {
            sql.append(" AND is_active = 1");
        } else if ("inactive".equalsIgnoreCase(status)) {
            sql.append(" AND is_active = 0");
        }
        sql.append(" ORDER BY service_id LIMIT ? OFFSET ?");

        ServiceTypeDAO typeDAO = new ServiceTypeDAO();
        Map<Integer, ServiceType> typeMap = new HashMap<>();
        for (ServiceType type : typeDAO.findAll()) {
            typeMap.put(type.getServiceTypeId(), type);
        }

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (hasKeyword) {
                String query = "%" + keyword.toLowerCase() + "%";
                stm.setString(paramIndex++, query);
                stm.setString(paramIndex++, query);
            }
            if (serviceTypeId != null) {
                stm.setInt(paramIndex++, serviceTypeId);
            }
            stm.setInt(paramIndex++, limit);
            stm.setInt(paramIndex, offset);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    services.add(mapResultSet(rs, typeMap));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return services;
    }

    public int countSearchResult(String keyword, String status, Integer serviceTypeId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM services WHERE 1=1");
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            sql.append(" AND (LOWER(name) LIKE ? OR LOWER(description) LIKE ?)");
        }
        if (serviceTypeId != null) {
            sql.append(" AND service_type_id = ?");
        }
        if ("active".equalsIgnoreCase(status)) {
            sql.append(" AND is_active = 1");
        } else if ("inactive".equalsIgnoreCase(status)) {
            sql.append(" AND is_active = 0");
        }
        try (Connection conn = DBContext.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (hasKeyword) {
                String query = "%" + keyword.toLowerCase() + "%";
                stm.setString(paramIndex++, query);
                stm.setString(paramIndex++, query);
            }
            if (serviceTypeId != null) {
                stm.setInt(paramIndex++, serviceTypeId);
            }
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public List<Service> findPaginated(int offset, int limit) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM services ORDER BY service_id LIMIT ? OFFSET ?";

        ServiceTypeDAO typeDAO = new ServiceTypeDAO();
        Map<Integer, ServiceType> typeMap = new HashMap<>();
        for (ServiceType type : typeDAO.findAll()) {
            typeMap.put(type.getServiceTypeId(), type);
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    services.add(mapResultSet(rs, typeMap));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return services;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM services";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    // Reusable mapper with type cache
    private Service mapResultSet(ResultSet rs, Map<Integer, ServiceType> typeMap) throws SQLException {
        Service service = new Service();

        service.setServiceId(rs.getInt("service_id"));
        service.setServiceTypeId(typeMap.get(rs.getInt("service_type_id")));
        service.setName(rs.getString("name"));
        service.setDescription(rs.getString("description"));
        service.setPrice(rs.getBigDecimal("price"));
        service.setDurationMinutes(rs.getInt("duration_minutes"));
        service.setBufferTimeAfterMinutes(rs.getInt("buffer_time_after_minutes"));
        service.setImageUrl(rs.getString("image_url"));
        service.setIsActive(rs.getBoolean("is_active"));
        service.setAverageRating(rs.getBigDecimal("average_rating"));
        service.setBookableOnline(rs.getBoolean("bookable_online"));
        service.setRequiresConsultation(rs.getBoolean("requires_consultation"));
        service.setCreatedAt(rs.getTimestamp("created_at"));
        service.setUpdatedAt(rs.getTimestamp("updated_at"));

        return service;
    }

    public static void main(String[] args) {
        ServiceDAO serviceDAO = new ServiceDAO();

        // Test findAll
        List<Service> services = serviceDAO.findAll();
        if (services.isEmpty()) {
            System.out.println("No services found.");
        } else {
            System.out.println("Services list:");
            for (Service service : services) {
                System.out.println(service);
            }
        }

        // Test findById
        int testId = 1; // <-- bạn có thể thay đổi ID này
        System.out.println("\nTesting findById(" + testId + "):");
        Optional<Service> optionalService = serviceDAO.findById(testId);
        if (optionalService.isPresent()) {
            System.out.println("Service found:\n" + optionalService.get());
        } else {
            System.out.println("Service with ID " + testId + " not found.");
        }
    }

    // method to find min price of services
    public double findMinPrice() {

        return 0;
    }

    // method to find max price of services
    public double findMaxPrice() {
        double maxPrice = 0;
        String sql = "SELECT MAX(price) FROM services";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql);
                ResultSet rs = stm.executeQuery()) {
            if (rs.next()) {
                maxPrice = rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return maxPrice;
    }

    /**
     * Fetches a list of services based on a combination of optional filters.
     *
     * @param typeId      Optional service type ID to filter by.
     * @param searchQuery Optional search term to filter by name.
     * @param minPrice    Optional minimum price.
     * @param maxPrice    Optional maximum price.
     * @return A list of services matching the filter criteria.
     */

    // Kiểm tra tên dịch vụ đã tồn tại (không phân biệt loại)
    public boolean existsByName(String name) {
        String sql = "SELECT COUNT(*) FROM services WHERE LOWER(name) = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name.toLowerCase());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // Kiểm tra tên dịch vụ đã tồn tại, loại trừ 1 id (dùng cho update)
    public boolean existsByNameExceptId(String name, int excludeId) {
        String sql = "SELECT COUNT(*) FROM services WHERE LOWER(name) = ? AND service_id <> ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name.toLowerCase());
            stmt.setInt(2, excludeId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public List<Service> getServicesByCriteria(String category, String searchQuery, Integer minPrice, Integer maxPrice,
            int page, int pageSize, String order) {
        List<Service> services = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM services WHERE is_active = 1");
        List<Object> params = new ArrayList<>();

        if (category != null) {
            if (category.equals("all")) {
                // do nothing
            } else if (category.equals("featured")) {
                sql.append(" AND average_rating >= 4.5");
            } else if (category.equals("new")) {
                sql.append(" AND created_at >= NOW() - INTERVAL 1 MONTH");
            } else if (category.startsWith("type-")) {
                sql.append(" AND service_type_id = ?");
                params.add(Integer.parseInt(category.substring(5)));
            }
        }

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            // Normalize search query: trim and handle multiple spaces
            String normalizedQuery = searchQuery.trim().replaceAll("\\s+", " ").toLowerCase();
            sql.append(" AND (LOWER(name) LIKE ? OR LOWER(description) LIKE ?)");
            params.add("%" + normalizedQuery + "%");
            params.add("%" + normalizedQuery + "%");
        }

        if (minPrice != null) {
            sql.append(" AND price >= ?");
            params.add(minPrice);
        }

        if (maxPrice != null) {
            sql.append(" AND price <= ?");
            params.add(maxPrice);
        }

        // Add sorting
        // Whitelist valid sort columns to prevent SQL injection
        Map<String, String> validSortColumns = new HashMap<>();
        validSortColumns.put("name-asc", "name ASC");
        validSortColumns.put("name-desc", "name DESC");
        validSortColumns.put("price-asc", "price ASC");
        validSortColumns.put("price-desc", "price DESC");
        validSortColumns.put("rating-desc", "average_rating DESC");
        validSortColumns.put("default", "created_at DESC");

        String orderByClause = " ORDER BY " + validSortColumns.getOrDefault(order, "created_at DESC");
        sql.append(orderByClause);

        // Add pagination
        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        ServiceTypeDAO typeDAO = new ServiceTypeDAO();
        Map<Integer, ServiceType> typeMap = new HashMap<>();
        for (ServiceType type : typeDAO.findAll()) {
            typeMap.put(type.getServiceTypeId(), type);
        }

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stm = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stm.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    services.add(mapResultSet(rs, typeMap));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    // method to find all services types
    public void activateById(int id) {
        String sql = "UPDATE services SET is_active = 1 WHERE service_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Kiểm tra tên dịch vụ đã tồn tại (không phân biệt loại)

    /**
     * Get services with active promotions for homepage promotional section
     * 
     * @param limit Maximum number of services to return
     * @return List of services with promotions
     */
    public List<Service> getPromotionalServices(int limit) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT DISTINCT s.*, p.discount_type, p.discount_value " +
                "FROM services s " +
                "INNER JOIN promotions p ON (p.applicable_service_ids_json LIKE CONCAT('%', s.service_id, '%') " +
                "    OR p.applicable_scope = 'ALL_SERVICES' " +
                "    OR p.applies_to_service_id = s.service_id) " +
                "WHERE s.is_active = 1 " +
                "    AND p.status = 'ACTIVE' " +
                "    AND p.start_date <= NOW() " +
                "    AND p.end_date >= NOW() " +
                "ORDER BY p.discount_value DESC, s.average_rating DESC " +
                "LIMIT ?";

        ServiceTypeDAO typeDAO = new ServiceTypeDAO();
        Map<Integer, ServiceType> typeMap = new HashMap<>();
        for (ServiceType type : typeDAO.findAll()) {
            typeMap.put(type.getServiceTypeId(), type);
        }

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    services.add(mapResultSet(rs, typeMap));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return services;
    }

    /**
     * Get most purchased services based on booking count for homepage most
     * purchased section
     * 
     * @param limit Maximum number of services to return
     * @return List of most purchased services
     */
    public List<Service> getMostPurchasedServices(int limit) {
        if (limit <= 0) {
            throw new IllegalArgumentException("Limit must be positive");
        }

        List<Service> services = new ArrayList<>();
        String sql = "SELECT s.*, COUNT(ba.appointment_id) as purchase_count " +
                "FROM services s " +
                "LEFT JOIN booking_appointments ba ON s.service_id = ba.service_id AND ba.status IN ('COMPLETED', 'IN_PROGRESS') "
                +
                "WHERE s.is_active = 1 " +
                "GROUP BY s.service_id " +
                "ORDER BY purchase_count DESC, s.average_rating DESC " +
                "LIMIT ?";

        // Fetch service types
        ServiceTypeDAO typeDAO = new ServiceTypeDAO();
        Map<Integer, ServiceType> typeMap = new HashMap<>();
        try {
            for (ServiceType type : typeDAO.findAll()) {
                typeMap.put(type.getServiceTypeId(), type);
            }
        } catch (Exception e) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.WARNING,
                    "Failed to load service types, proceeding with empty type map", e);
        }

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Service service = mapResultSet(rs, typeMap);
                    // Check if the purchase_count column exists before reading it
                    if (hasColumn(rs, "purchase_count")) {
                        service.setPurchaseCount(rs.getInt("purchase_count"));
                    }
                    services.add(service);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE,
                    "Failed to retrieve most purchased services", ex);
            throw new RuntimeException("Database error while retrieving services", ex);
        }

        return services;
    }

    /**
     * Utility method to check if a ResultSet contains a specific column.
     * 
     * @param rs         The ResultSet to check.
     * @param columnName The name of the column.
     * @return true if the column exists, false otherwise.
     * @throws SQLException
     */
    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData rsmd = rs.getMetaData();
        int columns = rsmd.getColumnCount();
        for (int x = 1; x <= columns; x++) {
            if (columnName.equals(rsmd.getColumnName(x))) {
                return true;
            }
        }
        return false;
    }

    /**
     * Get services by their IDs for recently viewed section
     * 
     * @param serviceIds List of service IDs to retrieve
     * @return List of services matching the IDs
     */
    public List<Service> getServicesByIds(List<Integer> serviceIds) {
        if (serviceIds == null || serviceIds.isEmpty()) {
            return new ArrayList<>();
        }

        List<Service> services = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM services WHERE service_id IN (");

        // Build placeholders for IN clause
        for (int i = 0; i < serviceIds.size(); i++) {
            sql.append("?");
            if (i < serviceIds.size() - 1) {
                sql.append(",");
            }
        }
        sql.append(") AND is_active = 1");

        ServiceTypeDAO typeDAO = new ServiceTypeDAO();
        Map<Integer, ServiceType> typeMap = new HashMap<>();
        for (ServiceType type : typeDAO.findAll()) {
            typeMap.put(type.getServiceTypeId(), type);
        }

        try (Connection conn = DBContext.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Set the service ID parameters
            for (int i = 0; i < serviceIds.size(); i++) {
                stmt.setInt(i + 1, serviceIds.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                Map<Integer, Service> serviceMap = new HashMap<>();
                while (rs.next()) {
                    Service service = mapResultSet(rs, typeMap);
                    serviceMap.put(service.getServiceId(), service);
                }

                // Maintain the order from the input list
                for (Integer id : serviceIds) {
                    if (serviceMap.containsKey(id)) {
                        services.add(serviceMap.get(id));
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return services;
    }
}
