package dao;

import model.InventoryReceipt;
import model.InventoryReceiptDetail;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class InventoryReceiptDAO {
    // Dynamic search, filter, pagination for InventoryReceipt
    public List<InventoryReceipt> findReceipts(String search, java.sql.Date fromDate, java.sql.Date toDate, Integer supplierId, Integer createdBy, int page, int pageSize) throws SQLException {
        List<InventoryReceipt> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT inventory_receipt_id, receipt_date, supplier_id, created_by, note, created_at FROM inventory_receipt WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND note LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        if (fromDate != null) {
            sql.append("AND receipt_date >= ? ");
            params.add(fromDate);
        }
        if (toDate != null) {
            sql.append("AND receipt_date <= ? ");
            params.add(toDate);
        }
        if (supplierId != null) {
            sql.append("AND supplier_id = ? ");
            params.add(supplierId);
        }
        if (createdBy != null) {
            sql.append("AND created_by = ? ");
            params.add(createdBy);
        }

        sql.append("ORDER BY receipt_date DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryReceipt r = new InventoryReceipt(
                            rs.getInt("inventory_receipt_id"),
                            rs.getDate("receipt_date"),
                            rs.getInt("supplier_id"),
                            rs.getInt("created_by"),
                            rs.getString("note"),
                            rs.getTimestamp("created_at")
                    );
                    list.add(r);
                }
            }
        }

        return list;
    }


    public int countReceipts(String search, java.sql.Date fromDate, java.sql.Date toDate,
                             Integer supplierId, Integer createdBy) throws SQLException {
        int total = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM inventory_receipt WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND note LIKE ? ");
            params.add("%" + search.trim() + "%");
        }
        if (fromDate != null) {
            sql.append("AND receipt_date >= ? ");
            params.add(fromDate);
        }
        if (toDate != null) {
            sql.append("AND receipt_date <= ? ");
            params.add(toDate);
        }
        if (supplierId != null) {
            sql.append("AND supplier_id = ? ");
            params.add(supplierId);
        }
        if (createdBy != null) {
            sql.append("AND created_by = ? ");
            params.add(createdBy);
        }

        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        }

        return total;
    }

    public Optional<InventoryReceipt> findReceiptById(int id) throws SQLException {
        String sql = "SELECT inventory_receipt_id, receipt_date, supplier_id, created_by, note, created_at FROM inventory_receipt WHERE inventory_receipt_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    InventoryReceipt r = new InventoryReceipt(
                        rs.getInt("inventory_receipt_id"),
                        rs.getDate("receipt_date"),
                        rs.getInt("supplier_id"),
                        rs.getInt("created_by"),
                        rs.getString("note"),
                        rs.getTimestamp("created_at"));
                    return Optional.of(r);
                }
            }
        }
        return Optional.empty();
    }

    public InventoryReceipt addReceipt(InventoryReceipt receipt) throws SQLException {
        String sql = "INSERT INTO inventory_receipt (receipt_date, supplier_id, created_by, note) VALUES (?, ?, ?, ?)";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setDate(1, receipt.getReceiptDate() == null ? null : new java.sql.Date(receipt.getReceiptDate().getTime()));
            ps.setInt(2, receipt.getSupplierId());
            ps.setInt(3, receipt.getCreatedBy());
            ps.setString(4, receipt.getNote());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        receipt.setInventoryReceiptId(rs.getInt(1));
                    }
                }
            }
        }
        return receipt;
    }

    public InventoryReceipt updateReceipt(InventoryReceipt receipt) throws SQLException {
        String sql = "UPDATE inventory_receipt SET receipt_date = ?, supplier_id = ?, created_by = ?, note = ? WHERE inventory_receipt_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, receipt.getReceiptDate() == null ? null : new java.sql.Date(receipt.getReceiptDate().getTime()));
            ps.setInt(2, receipt.getSupplierId());
            ps.setInt(3, receipt.getCreatedBy());
            ps.setString(4, receipt.getNote());
            ps.setInt(5, receipt.getInventoryReceiptId());
            ps.executeUpdate();
        }
        return receipt;
    }

    // Receipt detail CRUD (tuỳ chỉnh thêm nếu cần)
    public boolean addReceiptDetails(int receiptId, List<InventoryReceiptDetail> details) throws SQLException {
        if (details == null || details.isEmpty()) return true;
        String sql = "INSERT INTO inventory_receipt_detail (inventory_receipt_id, inventory_item_id, quantity, unit_price, note) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (InventoryReceiptDetail d : details) {
                ps.setInt(1, receiptId);
                ps.setInt(2, d.getInventoryItemId());
                ps.setInt(3, d.getQuantity());
                ps.setDouble(4, d.getUnitPrice());
                ps.setString(5, d.getNote());
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            for (int r : results) {
                if (r == Statement.EXECUTE_FAILED) return false;
            }
        }
        return true;
    }
    public List<InventoryReceiptDetail> getReceiptDetailsByReceiptId(int receiptId) throws SQLException {
        List<InventoryReceiptDetail> list = new ArrayList<>();
        String sql = "SELECT inventory_receipt_detail_id, inventory_receipt_id, inventory_item_id, quantity, unit_price, note FROM inventory_receipt_detail WHERE inventory_receipt_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, receiptId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryReceiptDetail detail = new InventoryReceiptDetail(
                        rs.getInt("inventory_receipt_detail_id"),
                        rs.getInt("inventory_receipt_id"),
                        rs.getInt("inventory_item_id"),
                        rs.getInt("quantity"),
                        rs.getDouble("unit_price"),
                        rs.getString("note")
                    );
                    list.add(detail);
                }
            }
        }
        return list;
    }
} 