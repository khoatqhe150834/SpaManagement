package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import db.DBContext;

public class CustomerPointDAO {
    public int getPointsByCustomerId(int customerId) {
        String sql = "SELECT points FROM customer_points WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("points");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Cộng điểm cho khách hàng và ghi lịch sử (chỉ nhận points > 0)
    public boolean addPoints(int customerId, int points, String reason) {
        if (points <= 0) throw new IllegalArgumentException("Chỉ dùng cho cộng điểm, points phải > 0");
        String updateSql = "INSERT INTO customer_points (customer_id, points, updated_at) VALUES (?, ?, NOW()) ON DUPLICATE KEY UPDATE points = points + VALUES(points), updated_at = NOW()";
        String historySql = "INSERT INTO point_transactions (customer_id, points_change, reason) VALUES (?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(updateSql);
                 PreparedStatement ps2 = conn.prepareStatement(historySql)) {
                ps1.setInt(1, customerId);
                ps1.setInt(2, points);
                ps1.executeUpdate();
                ps2.setInt(1, customerId);
                ps2.setInt(2, points);
                ps2.setString(3, reason);
                ps2.executeUpdate();
                conn.commit();
                return true;
            } catch (SQLException e) {
                if (conn != null) conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignore) {}
        }
    }

    // Trừ điểm cho khách hàng và ghi lịch sử (chỉ nhận points > 0, kiểm tra đủ điểm)
    public boolean subtractPoints(int customerId, int points, String reason) {
        if (points <= 0) throw new IllegalArgumentException("Chỉ dùng cho trừ điểm, points phải > 0");
        int currentPoints = getPointsByCustomerId(customerId);
        if (currentPoints < points) {
            // Không đủ điểm để trừ
            return false;
        }
        String updateSql = "INSERT INTO customer_points (customer_id, points, updated_at) VALUES (?, ?, NOW()) ON DUPLICATE KEY UPDATE points = points - VALUES(points), updated_at = NOW()";
        String historySql = "INSERT INTO point_transactions (customer_id, points_change, reason) VALUES (?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(updateSql);
                 PreparedStatement ps2 = conn.prepareStatement(historySql)) {
                ps1.setInt(1, customerId);
                ps1.setInt(2, points);
                ps1.executeUpdate();
                ps2.setInt(1, customerId);
                ps2.setInt(2, -points); // Lưu lịch sử là số âm
                ps2.setString(3, reason);
                ps2.executeUpdate();
                conn.commit();
                return true;
            } catch (SQLException e) {
                if (conn != null) conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignore) {}
        }
    }

    // Kiểm tra đã cộng điểm đăng nhập hôm nay chưa
    public boolean hasReceivedDailyLoginPoints(int customerId) {
        String sql = "SELECT COUNT(*) FROM point_transactions WHERE customer_id = ? AND reason = ? AND DATE(created_at) = CURDATE()";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setString(2, "Điểm đăng nhập mỗi ngày");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra đã cộng điểm cho dịch vụ này trong ngày chưa
    public boolean hasReceivedServiceUsagePointsToday(int customerId, String serviceName) {
        String sql = "SELECT COUNT(*) FROM point_transactions WHERE customer_id = ? AND reason = ? AND DATE(created_at) = CURDATE()";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setString(2, "Dùng dịch vụ: " + serviceName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra đã cộng điểm cho tổng hóa đơn trong ngày chưa
    public boolean hasReceivedOrderValuePointsToday(int customerId) {
        String sql = "SELECT COUNT(*) FROM point_transactions WHERE customer_id = ? AND reason = ? AND DATE(created_at) = CURDATE()";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setString(2, "Tổng hóa đơn");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public java.util.List<model.PointTransaction> getHistoryByCustomerId(int customerId) {
        java.util.List<model.PointTransaction> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM point_transactions WHERE customer_id = ? ORDER BY created_at DESC";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.PointTransaction pt = new model.PointTransaction();
                    pt.setTransactionId(rs.getInt("transaction_id"));
                    pt.setCustomerId(rs.getInt("customer_id"));
                    pt.setPoints(rs.getInt("points_change"));
                    pt.setReason(rs.getString("reason"));
                    pt.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(pt);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
} 