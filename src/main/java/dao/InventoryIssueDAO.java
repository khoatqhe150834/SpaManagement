package dao;

import model.InventoryIssue;
import model.InventoryIssueDetail;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class InventoryIssueDAO {
    // Dynamic search, filter, pagination for InventoryIssue
    public List<InventoryIssue> findIssues(String search, int page, int pageSize) throws SQLException {
        List<InventoryIssue> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT inventory_issue_id, issue_date, booking_appointment_id, requested_by, approved_by, status, note, created_at FROM inventory_issue WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND note LIKE ? ");
            params.add("%" + search.trim() + "%");
        }

        sql.append("ORDER BY issue_date ASC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryIssue issue = new InventoryIssue(
                            rs.getInt("inventory_issue_id"),
                            rs.getDate("issue_date"),
                            (Integer) rs.getObject("booking_appointment_id"),
                            rs.getInt("requested_by"),
                            rs.getInt("approved_by"),
                            rs.getString("status"),
                            rs.getString("note"),
                            rs.getTimestamp("created_at"));
                    list.add(issue);
                }
            }
        }

        return list;
    }

    public int countIssues(String search) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM inventory_issue WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND note LIKE ? ");
            params.add("%" + search.trim() + "%");
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

    public Optional<InventoryIssue> findIssueById(int id) throws SQLException {
        String sql = "SELECT inventory_issue_id, issue_date, booking_appointment_id, requested_by, approved_by, status, note, created_at FROM inventory_issue WHERE inventory_issue_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    InventoryIssue issue = new InventoryIssue(
                        rs.getInt("inventory_issue_id"),
                        rs.getDate("issue_date"),
                        (Integer)rs.getObject("booking_appointment_id"),
                        rs.getInt("requested_by"),
                        rs.getInt("approved_by"),
                        rs.getString("status"),
                        rs.getString("note"),
                        rs.getTimestamp("created_at"));
                    return Optional.of(issue);
                }
            }
        }
        return Optional.empty();
    }

    public InventoryIssue addIssue(InventoryIssue issue) throws SQLException {
        String sql = "INSERT INTO inventory_issue (issue_date, booking_appointment_id, requested_by, approved_by, status, note) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setDate(1, issue.getIssueDate() == null ? null : new java.sql.Date(issue.getIssueDate().getTime()));
            if (issue.getBookingAppointmentId() != null) ps.setInt(2, issue.getBookingAppointmentId()); else ps.setNull(2, Types.INTEGER);
            ps.setInt(3, issue.getRequestedBy());
            ps.setInt(4, issue.getApprovedBy());
            ps.setString(5, issue.getStatus());
            ps.setString(6, issue.getNote());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        issue.setInventoryIssueId(rs.getInt(1));
                    }
                }
            }
        }
        return issue;
    }

    public InventoryIssue updateIssue(InventoryIssue issue) throws SQLException {
        String sql = "UPDATE inventory_issue SET issue_date = ?, booking_appointment_id = ?, requested_by = ?, approved_by = ?, status = ?, note = ? WHERE inventory_issue_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, issue.getIssueDate() == null ? null : new java.sql.Date(issue.getIssueDate().getTime()));
            if (issue.getBookingAppointmentId() != null) ps.setInt(2, issue.getBookingAppointmentId()); else ps.setNull(2, Types.INTEGER);
            ps.setInt(3, issue.getRequestedBy());
            ps.setInt(4, issue.getApprovedBy());
            ps.setString(5, issue.getStatus());
            ps.setString(6, issue.getNote());
            ps.setInt(7, issue.getInventoryIssueId());
            ps.executeUpdate();
        }
        return issue;
    }

    // Issue detail CRUD (tuỳ chỉnh thêm nếu cần)
    public List<InventoryIssueDetail> getIssueDetailsByIssueId(int issueId) throws SQLException {
        List<InventoryIssueDetail> list = new ArrayList<>();
        String sql = "SELECT inventory_issue_detail_id, inventory_issue_id, inventory_item_id, quantity, note FROM inventory_issue_detail WHERE inventory_issue_id = ?";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, issueId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryIssueDetail detail = new InventoryIssueDetail(
                        rs.getInt("inventory_issue_detail_id"),
                        rs.getInt("inventory_issue_id"),
                        rs.getInt("inventory_item_id"),
                        rs.getInt("quantity"),
                        rs.getString("note")
                    );
                    list.add(detail);
                }
            }
        }
        return list;
    }

    public boolean addIssueDetails(int issueId, List<InventoryIssueDetail> details) throws SQLException {
        if (details == null || details.isEmpty()) return true;
        String sql = "INSERT INTO inventory_issue_detail (inventory_issue_id, inventory_item_id, quantity, note) VALUES (?, ?, ?, ?)";
        try (Connection conn = db.DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (InventoryIssueDetail d : details) {
                ps.setInt(1, issueId);
                ps.setInt(2, d.getInventoryItemId());
                ps.setInt(3, d.getQuantity());
                ps.setString(4, d.getNote());
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            for (int r : results) {
                if (r == Statement.EXECUTE_FAILED) return false;
            }
        }
        return true;
    }

    public void deleteIssue(int issueId) throws SQLException {
        String deleteDetailsSQL = "DELETE FROM inventory_issue_detail WHERE inventory_issue_id = ?";
        String deleteIssueSQL = "DELETE FROM inventory_issue WHERE inventory_issue_id = ?";

        try (Connection conn = db.DBContext.getConnection()) {
            conn.setAutoCommit(false); // Bắt đầu transaction

            try (
                    PreparedStatement psDetails = conn.prepareStatement(deleteDetailsSQL);
                    PreparedStatement psIssue = conn.prepareStatement(deleteIssueSQL)
            ) {
                // Xóa chi tiết trước
                psDetails.setInt(1, issueId);
                psDetails.executeUpdate();

                // Sau đó xóa phiếu xuất
                psIssue.setInt(1, issueId);
                psIssue.executeUpdate();

                conn.commit(); // Commit nếu không lỗi
            } catch (SQLException e) {
                conn.rollback(); // Rollback nếu có lỗi
                throw e;
            }
        }
    }

} 