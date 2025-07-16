package dao;

import model.InventoryCategory;
import model.Supplier;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class InventoryMasterDataDAO {
    // InventoryCategory CRUD

    // Dynamic search, filter, pagination for InventoryCategory
    public List<InventoryCategory> findCategories(String search, Boolean onlyActive, int page, int pageSize) throws SQLException {
        List<InventoryCategory> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT inventory_category_id, name, description, is_active FROM inventory_category WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND name LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        if (onlyActive != null) {
            sql.append("AND is_active = ? ");
            params.add(onlyActive ? 1 : 0);
        }
        sql.append("ORDER BY inventory_category_id ASC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryCategory cat = new InventoryCategory(
                        rs.getInt("inventory_category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBoolean("is_active")
                    );
                    list.add(cat);
                }
            }
        }
        return list;
    }

    public int countCategories(String search, Boolean onlyActive) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM inventory_category WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND name LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        if (onlyActive != null) {
            sql.append("AND is_active = ? ");
            params.add(onlyActive ? 1 : 0);
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

    public Optional<InventoryCategory> findCategoryById(int id) throws SQLException {
        String sql = "SELECT inventory_category_id, name, description, is_active FROM inventory_category WHERE inventory_category_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    InventoryCategory cat = new InventoryCategory(
                            rs.getInt("inventory_category_id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getBoolean("is_active")
                    );
                    return Optional.of(cat);
                }
            }
        }
        return Optional.empty();
    }

    public InventoryCategory addCategory(InventoryCategory category) throws SQLException {
        String sql = "INSERT INTO inventory_category (name, description) VALUES (?, ?)";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        category.setInventoryCategoryId(rs.getInt(1));
                    }
                }
            }
        }
        return category;
    }

    public InventoryCategory updateCategory(InventoryCategory category) throws SQLException {
        String sql = "UPDATE inventory_category SET name = ?, description = ?, is_active = ? WHERE inventory_category_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            ps.setBoolean(3, category.isActive());
            ps.setInt(4, category.getInventoryCategoryId());
            ps.executeUpdate();
        }
        return category;
    }

    public boolean deleteCategory(int id) throws SQLException {
        String sql = "UPDATE inventory_category SET is_active = 0 WHERE inventory_category_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // Supplier CRUD

// Dynamic search, filter, pagination for Supplier
    public List<Supplier> findSuppliers(String search, Boolean onlyActive, int page, int pageSize) throws SQLException {
        List<Supplier> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT supplier_id, name, contact_info, is_active FROM supplier WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND name LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        if (onlyActive != null) {
            sql.append("AND is_active = ? ");
            params.add(onlyActive ? 1 : 0);
        }
        sql.append("ORDER BY supplier_id ASC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Supplier s = new Supplier(
                        rs.getInt("supplier_id"),
                        rs.getString("name"),
                        rs.getString("contact_info"),
                        rs.getBoolean("is_active")
                    );
                    list.add(s);
                }
            }
        }
        return list;
    }

    public int countSuppliers(String search, Boolean onlyActive) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM supplier WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND name LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        if (onlyActive != null) {
            sql.append("AND is_active = ? ");
            params.add(onlyActive ? 1 : 0);
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

    public Optional<Supplier> findSupplierById(int id) throws SQLException {
        String sql = "SELECT supplier_id, name, contact_info, is_active FROM supplier WHERE supplier_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Supplier s = new Supplier(
                            rs.getInt("supplier_id"),
                            rs.getString("name"),
                            rs.getString("contact_info"),
                            rs.getBoolean("is_active")
                    );
                    return Optional.of(s);
                }
            }
        }
        return Optional.empty();
    }

    public Supplier addSupplier(Supplier supplier) throws SQLException {
        String sql = "INSERT INTO supplier (name, contact_info) VALUES (?, ?)";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, supplier.getName());
            ps.setString(2, supplier.getContactInfo());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        supplier.setSupplierId(rs.getInt(1));
                    }
                }
            }
        }
        return supplier;
    }

    public Supplier updateSupplier(Supplier supplier) throws SQLException {
        String sql = "UPDATE supplier SET name = ?, contact_info = ?, is_active = ? WHERE supplier_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, supplier.getName());
            ps.setString(2, supplier.getContactInfo());
            ps.setBoolean(3, supplier.isActive());
            ps.setInt(4, supplier.getSupplierId());
            ps.executeUpdate();
        }
        return supplier;
    }

    public boolean deleteSupplier(int id) throws SQLException {
        String sql = "UPDATE supplier SET is_active = 0 WHERE supplier_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    
} 