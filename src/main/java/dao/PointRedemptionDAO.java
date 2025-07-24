package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import db.DBContext;
import model.PointRedemption;

public class PointRedemptionDAO {
    // Thêm mới lịch sử đổi điểm
    public boolean insertRedemption(PointRedemption redemption) {
        String sql = "INSERT INTO point_redemptions (customer_id, points_used, reward_type, reward_value, redeemed_at, status, note) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, redemption.getCustomerId());
            ps.setInt(2, redemption.getPointsUsed());
            ps.setString(3, redemption.getRewardType());
            ps.setString(4, redemption.getRewardValue());
            ps.setTimestamp(5, redemption.getRedeemedAt());
            ps.setString(6, redemption.getStatus());
            ps.setString(7, redemption.getNote());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        redemption.setRedemptionId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy lịch sử đổi điểm theo khách hàng
    public List<PointRedemption> getRedemptionsByCustomer(int customerId) {
        List<PointRedemption> list = new ArrayList<>();
        String sql = "SELECT * FROM point_redemptions WHERE customer_id = ? ORDER BY redeemed_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Map ResultSet sang model
    private PointRedemption mapResultSet(ResultSet rs) throws SQLException {
        PointRedemption r = new PointRedemption();
        r.setRedemptionId(rs.getInt("redemption_id"));
        r.setCustomerId(rs.getInt("customer_id"));
        r.setPointsUsed(rs.getInt("points_used"));
        r.setRewardType(rs.getString("reward_type"));
        r.setRewardValue(rs.getString("reward_value"));
        r.setRedeemedAt(rs.getTimestamp("redeemed_at"));
        r.setStatus(rs.getString("status"));
        r.setNote(rs.getString("note"));
        return r;
    }
} 