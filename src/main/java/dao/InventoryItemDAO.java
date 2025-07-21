package dao;

import model.InventoryItem;
import model.InventoryTransaction;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class InventoryItemDAO {
    // Dynamic search, filter, pagination for InventoryItem
    public List<InventoryItem> findItems(String search, Integer categoryId, Integer supplierId, Boolean onlyActive, int page, int pageSize) throws SQLException {
        List<InventoryItem> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT inventory_item_id, name, inventory_category_id, supplier_id, unit, quantity, min_quantity, description, created_at, updated_at, is_active FROM inventory_item WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND name LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        if (categoryId != null) {
            sql.append("AND inventory_category_id = ? ");
            params.add(categoryId);
        }
        if (supplierId != null) {
            sql.append("AND supplier_id = ? ");
            params.add(supplierId);
        }
        if (onlyActive != null) {
            sql.append("AND is_active = ? ");
            params.add(onlyActive ? 1 : 0);
        }
        sql.append("ORDER BY created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryItem item = new InventoryItem(
                        rs.getInt("inventory_item_id"),
                        rs.getString("name"),
                        (Integer)rs.getObject("inventory_category_id"),
                        (Integer)rs.getObject("supplier_id"),
                        rs.getString("unit"),
                        rs.getInt("quantity"),
                        rs.getInt("min_quantity"),
                        rs.getString("description"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at"),
                        rs.getBoolean("is_active")
                    );
                    list.add(item);
                }
            }
        }
        return list;
    }

    public int countItems(String search, Integer categoryId, Integer supplierId, Boolean onlyActive) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM inventory_item WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND name LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        if (categoryId != null) {
            sql.append("AND inventory_category_id = ? ");
            params.add(categoryId);
        }
        if (supplierId != null) {
            sql.append("AND supplier_id = ? ");
            params.add(supplierId);
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

    // Update findItemById to map isActive
    public Optional<InventoryItem> findItemById(int id) throws SQLException {
        String sql = "SELECT inventory_item_id, name, inventory_category_id, supplier_id, unit, quantity, min_quantity, description, created_at, updated_at, is_active FROM inventory_item WHERE inventory_item_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    InventoryItem item = new InventoryItem(
                        rs.getInt("inventory_item_id"),
                        rs.getString("name"),
                        (Integer)rs.getObject("inventory_category_id"),
                        (Integer)rs.getObject("supplier_id"),
                        rs.getString("unit"),
                        rs.getInt("quantity"),
                        rs.getInt("min_quantity"),
                        rs.getString("description"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at"),
                        rs.getBoolean("is_active")
                    );
                    return Optional.of(item);
                }
            }
        }
        return Optional.empty();
    }

    public InventoryItem addItem(InventoryItem item) throws SQLException {
        String sql = "INSERT INTO inventory_item (name, inventory_category_id, supplier_id, unit, quantity, min_quantity, description) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, item.getName());
            if (item.getInventoryCategoryId() != null) ps.setInt(2, item.getInventoryCategoryId()); else ps.setNull(2, Types.INTEGER);
            if (item.getSupplierId() != null) ps.setInt(3, item.getSupplierId()); else ps.setNull(3, Types.INTEGER);
            ps.setString(4, item.getUnit());
            ps.setInt(5, item.getQuantity());
            ps.setInt(6, item.getMinQuantity());
            ps.setString(7, item.getDescription());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        item.setInventoryItemId(rs.getInt(1));
                    }
                }
            }
        }
        return item;
    }

    public InventoryItem updateItem(InventoryItem item) throws SQLException {
        String sql = "UPDATE inventory_item SET name = ?, inventory_category_id = ?, supplier_id = ?, unit = ?, quantity = ?, min_quantity = ?, description = ?, is_active = ? WHERE inventory_item_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, item.getName());
            if (item.getInventoryCategoryId() != null) ps.setInt(2, item.getInventoryCategoryId()); else ps.setNull(2, Types.INTEGER);
            if (item.getSupplierId() != null) ps.setInt(3, item.getSupplierId()); else ps.setNull(3, Types.INTEGER);
            ps.setString(4, item.getUnit());
            ps.setInt(5, item.getQuantity());
            ps.setInt(6, item.getMinQuantity());
            ps.setString(7, item.getDescription());
            ps.setBoolean(8, item.isActive());
            ps.setInt(9, item.getInventoryItemId());
            ps.executeUpdate();
        }
        return item;
    }

    // Soft delete
    public boolean deleteItem(int id) throws SQLException {
        String sql = "UPDATE inventory_item SET is_active = 0 WHERE inventory_item_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // Tồn kho, cảnh báo
    public List<InventoryItem> findLowStockItems() throws SQLException {
        List<InventoryItem> list = new ArrayList<>();
        String sql = "SELECT inventory_item_id, name, inventory_category_id, supplier_id, unit, quantity, min_quantity, description, created_at, updated_at, is_active FROM inventory_item WHERE quantity <= min_quantity";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                InventoryItem item = new InventoryItem(
                        rs.getInt("inventory_item_id"),
                        rs.getString("name"),
                        (Integer)rs.getObject("inventory_category_id"),
                        (Integer)rs.getObject("supplier_id"),
                        rs.getString("unit"),
                        rs.getInt("quantity"),
                        rs.getInt("min_quantity"),
                        rs.getString("description"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at"),
                        rs.getBoolean("is_active")
                );
                list.add(item);
            }
        }
        return list;
    }

    // Lịch sử giao dịch
    public List<InventoryTransaction> getInventoryHistory(int inventoryItemId) throws SQLException {
        List<InventoryTransaction> list = new ArrayList<>();
        String sql = "SELECT inventory_transaction_id, inventory_item_id, type, quantity, transaction_date, user_id, note FROM inventory_transaction WHERE inventory_item_id = ? ORDER BY transaction_date DESC";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inventoryItemId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryTransaction t = new InventoryTransaction(
                            rs.getInt("inventory_transaction_id"),
                            rs.getInt("inventory_item_id"),
                            rs.getString("type"),
                            rs.getInt("quantity"),
                            rs.getTimestamp("transaction_date"),
                            rs.getInt("user_id"),
                            rs.getString("note")
                    );
                    list.add(t);
                }
            }
        }
        return list;
    }

    // Báo cáo tổng hợp
    public int getTotalQuantityByCategory(int categoryId) throws SQLException {
        String sql = "SELECT SUM(quantity) FROM inventory_item WHERE inventory_category_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
} 