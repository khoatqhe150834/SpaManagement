package dao;

import db.DBContext;
import model.Service;
import model.ServiceType;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ServiceDAO implements BaseDAO<Service, Integer> {

    @Override
    public <S extends Service> S save(S entity) {
        String sql = "INSERT INTO Services (service_type_id, name, description, price, duration_minutes, buffer_time_after_minutes, image_url, is_active, average_rating, bookable_online, requires_consultation) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

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
        String sql = "SELECT * FROM Services WHERE service_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return Optional.of(mapResultSet(rs));
            }

        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return Optional.empty();
    }

    @Override
    public List<Service> findAll() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM Services";

        // Load ServiceType ra Map trước khi mở ResultSet
        ServiceTypeDAO typeDAO = new ServiceTypeDAO();
        List<ServiceType> serviceTypes = typeDAO.findAll();
        Map<Integer, ServiceType> typeMap = new HashMap<>();
        for (ServiceType type : serviceTypes) {
            typeMap.put(type.getServiceTypeId(), type);
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Service service = new Service();

                int typeId = rs.getInt("service_type_id");

                service.setServiceId(rs.getInt("service_id"));
                service.setServiceTypeId(typeMap.get(typeId));
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

                services.add(service);
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
        String sql = "DELETE FROM Services WHERE service_id = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();

        } catch (SQLException ex) {
            Logger.getLogger(ServiceDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public <S extends Service> S update(S entity) {
        String sql = "UPDATE Services SET service_type_id = ?, name = ?, description = ?, price = ?, duration_minutes = ?, buffer_time_after_minutes = ?, image_url = ?, is_active = ?, average_rating = ?, bookable_online = ?, requires_consultation = ? WHERE service_id = ?";

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

    private Service mapResultSet(ResultSet rs) throws SQLException {
        Service service = new Service();
        service.setServiceId(rs.getInt("service_id"));

        ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO();
        int typeId = rs.getInt("service_type_id");
        service.setServiceTypeId(serviceTypeDAO.findById(typeId).orElse(null));

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
        List<Service> services = serviceDAO.findAll();

        if (services.isEmpty()) {
            System.out.println("No services found.");
        } else {
            for (Service service : services) {
                System.out.println(service);
            }
        }
    }

}
