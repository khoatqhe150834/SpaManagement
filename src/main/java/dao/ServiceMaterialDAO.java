package dao;

import model.ServiceMaterial;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ServiceMaterialDAO {
    // Dynamic search, filter, pagination for ServiceMaterial
    public List<ServiceMaterial> findServiceMaterials(Integer serviceId, Integer inventoryItemId, int page, int pageSize) throws SQLException {
        List<ServiceMaterial> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT service_material_id, service_id, inventory_item_id, quantity_per_service FROM service_material WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (serviceId != null) {
            sql.append("AND service_id = ? ");
            params.add(serviceId);
        }
        if (inventoryItemId != null) {
            sql.append("AND inventory_item_id = ? ");
            params.add(inventoryItemId);
        }
        sql.append("ORDER BY service_material_id DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ServiceMaterial sm = new ServiceMaterial(
                        rs.getInt("service_material_id"),
                        rs.getInt("service_id"),
                        rs.getInt("inventory_item_id"),
                        rs.getInt("quantity_per_service")
                    );
                    list.add(sm);
                }
            }
        }
        return list;
    }

    public int countServiceMaterials(Integer serviceId, Integer inventoryItemId) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM service_material WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (serviceId != null) {
            sql.append("AND service_id = ? ");
            params.add(serviceId);
        }
        if (inventoryItemId != null) {
            sql.append("AND inventory_item_id = ? ");
            params.add(inventoryItemId);
        }
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public Optional<ServiceMaterial> findById(int id) throws SQLException {
        String sql = "SELECT service_material_id, service_id, inventory_item_id, quantity_per_service FROM service_material WHERE service_material_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ServiceMaterial sm = new ServiceMaterial(
                        rs.getInt("service_material_id"),
                        rs.getInt("service_id"),
                        rs.getInt("inventory_item_id"),
                        rs.getInt("quantity_per_service")
                    );
                    return Optional.of(sm);
                }
            }
        }
        return Optional.empty();
    }

    public ServiceMaterial addServiceMaterial(ServiceMaterial sm) throws SQLException {
        String sql = "INSERT INTO service_material (service_id, inventory_item_id, quantity_per_service) VALUES (?, ?, ?)";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, sm.getServiceId());
            ps.setInt(2, sm.getInventoryItemId());
            ps.setInt(3, sm.getQuantityPerService());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        sm.setServiceMaterialId(rs.getInt(1));
                    }
                }
            }
        }
        return sm;
    }

    public ServiceMaterial updateServiceMaterial(ServiceMaterial sm) throws SQLException {
        String sql = "UPDATE service_material SET service_id = ?, inventory_item_id = ?, quantity_per_service = ? WHERE service_material_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sm.getServiceId());
            ps.setInt(2, sm.getInventoryItemId());
            ps.setInt(3, sm.getQuantityPerService());
            ps.setInt(4, sm.getServiceMaterialId());
            ps.executeUpdate();
        }
        return sm;
    }

    public boolean deleteServiceMaterial(int id) throws SQLException {
        String sql = "DELETE FROM service_material WHERE service_material_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }
} 