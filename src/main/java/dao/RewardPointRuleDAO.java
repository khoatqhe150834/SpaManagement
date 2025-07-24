package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import db.DBContext;
import model.RewardPointRule;

public class RewardPointRuleDAO {
    // Lấy quy tắc đang áp dụng (is_active = 1 và ngày hiện tại nằm trong khoảng hiệu lực)
    public RewardPointRule getActiveRule() {
        String sql = "SELECT * FROM reward_point_rules WHERE is_active = 1 AND (start_date <= CURDATE()) AND (end_date IS NULL OR end_date >= CURDATE()) ORDER BY start_date DESC LIMIT 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm mới quy tắc
    public boolean insertRule(RewardPointRule rule) {
        String sql = "INSERT INTO reward_point_rules (money_per_point, start_date, end_date, is_active, note) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rule.getMoneyPerPoint());
            ps.setDate(2, rule.getStartDate());
            ps.setDate(3, rule.getEndDate());
            ps.setBoolean(4, rule.getIsActive() != null ? rule.getIsActive() : true);
            ps.setString(5, rule.getNote());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật trạng thái quy tắc (is_active)
    public boolean updateRuleStatus(int ruleId, boolean isActive) {
        String sql = "UPDATE reward_point_rules SET is_active = ?, updated_at = NOW() WHERE rule_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, ruleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy tất cả quy tắc (lịch sử)
    public List<RewardPointRule> getAllRules() {
        List<RewardPointRule> list = new ArrayList<>();
        String sql = "SELECT * FROM reward_point_rules ORDER BY start_date DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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

    // Cập nhật giá trị money_per_point cho quy tắc
    public boolean updateRuleMoneyPerPoint(int ruleId, int moneyPerPoint) {
        String sql = "UPDATE reward_point_rules SET money_per_point = ?, updated_at = NOW() WHERE rule_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, moneyPerPoint);
            ps.setInt(2, ruleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Map ResultSet sang model
    private RewardPointRule mapResultSet(ResultSet rs) throws SQLException {
        RewardPointRule rule = new RewardPointRule();
        rule.setRuleId(rs.getInt("rule_id"));
        rule.setMoneyPerPoint(rs.getInt("money_per_point"));
        rule.setStartDate(rs.getDate("start_date"));
        rule.setEndDate(rs.getDate("end_date"));
        rule.setIsActive(rs.getBoolean("is_active"));
        rule.setCreatedAt(rs.getTimestamp("created_at"));
        rule.setUpdatedAt(rs.getTimestamp("updated_at"));
        rule.setNote(rs.getString("note"));
        return rule;
    }
} 