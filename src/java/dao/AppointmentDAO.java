package dao;

import db.DBContext;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import model.Appointment;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import model.AppointmentDetails;

/**
 *
 * @author ADMIN
 */
public class AppointmentDAO extends DBContext implements BaseDAO<Appointment, Integer> {

    @Override
    public <S extends Appointment> S save(S entity) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Optional<Appointment> findById(Integer id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public List<Appointment> findAppointmentsWithFilters(
            String statusFilter,
            String paymentStatusFilter,
            String searchFilter,
            int page,
            int pageSize) {

        List<Appointment> appointments = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT "
                + "  a.appointment_id, "
                + "  c.full_name   AS customer_name, "
                + "  bg.group_name AS booking_group_name, "
                + "  u.full_name   AS therapist_name, "
                + "  a.start_time, a.end_time, "
                + "  a.total_original_price, a.total_discount_amount, "
                + "  a.points_redeemed_value, a.total_final_price, a.promotion_id, "
                + "  a.status, a.payment_status, a.cancel_reason, "
                + "  a.created_at, a.updated_at "
                + "FROM appointments a "
                + "  JOIN customers c ON a.customer_id = c.customer_id "
                + "  LEFT JOIN booking_groups bg ON a.booking_group_id = bg.booking_group_id "
                + "  LEFT JOIN users u ON a.therapist_user_id = u.user_id AND u.role_id = 3 "
                + "WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND a.status = ? ");
            params.add(statusFilter);
        }

        if (paymentStatusFilter != null && !paymentStatusFilter.isEmpty()) {
            sql.append(" AND a.payment_status = ? ");
            params.add(paymentStatusFilter);
        }

        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append(" AND (c.full_name LIKE ? OR bg.group_name LIKE ? OR u.full_name LIKE ?) ");
            String keyword = "%" + searchFilter.trim() + "%";
            params.add(keyword);
            params.add(keyword);
            params.add(keyword);
        }

        sql.append(" ORDER BY a.appointment_id ASC LIMIT ? OFFSET ? ");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try {
            Connection conn = DBContext.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                appointments.add(getFromResultSet(rs));
            }

        } catch (SQLException ex) {
            System.out.println("Error finding filtered appointments: " + ex.getMessage());
        } finally {
            closeConnection();
        }

        return appointments;
    }

    public int getTotalFilteredAppointments(String statusFilter, String paymentStatusFilter, String searchFilter) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM appointments a "
                + "JOIN customers c ON a.customer_id = c.customer_id "
                + "LEFT JOIN booking_groups bg ON a.booking_group_id = bg.booking_group_id "
                + "LEFT JOIN users u ON a.therapist_user_id = u.user_id AND u.role_id = 3 "
                + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND a.status = ? ");
            params.add(statusFilter);
        }

        if (paymentStatusFilter != null && !paymentStatusFilter.isEmpty()) {
            sql.append(" AND a.payment_status = ? ");
            params.add(paymentStatusFilter);
        }

        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append(" AND (c.full_name LIKE ? OR bg.group_name LIKE ? OR u.full_name LIKE ?) ");
            String keyword = "%" + searchFilter.trim() + "%";
            params.add(keyword);
            params.add(keyword);
            params.add(keyword);
        }

        try {
            Connection conn = DBContext.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException ex) {
            System.out.println("Error counting filtered appointments: " + ex.getMessage());
        } finally {
            DBContext.closeConnection();
        }

        return 0;
    }

    public List<AppointmentDetails> findDetailsByAppointmentId(int appointmentId, String serviceSearch) {
        List<AppointmentDetails> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT "
                + "  ad.detail_id, "
                + "  ad.appointment_id, "
                + "  ad.service_id, "
                + "  s.name AS service_name, "
                + "  ad.original_service_price, "
                + "  ad.discount_amount_applied, "
                + "  ad.final_price_after_discount, "
                + "  ad.notes_by_customer, "
                + "  ad.notes_by_staff, "
                + "  a.status, "
                + "  a.payment_status "
                + "FROM appointment_details ad "
                + "JOIN services s ON ad.service_id = s.service_id "
                + "JOIN appointments a ON ad.appointment_id = a.appointment_id "
                + "WHERE ad.appointment_id = ? "
        );

        List<Object> params = new ArrayList<>();
        params.add(appointmentId);

        if (serviceSearch != null && !serviceSearch.trim().isEmpty()) {
            sql.append(" AND s.name LIKE ? ");
            params.add("%" + serviceSearch.trim().toLowerCase() + "%");
        }

        sql.append(" ORDER BY ad.detail_id ASC ");

        try {
            Connection conn = DBContext.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                AppointmentDetails det = AppointmentDetails.builder()
                        .detailId(rs.getInt("detail_id"))
                        .appointmentId(rs.getInt("appointment_id"))
                        .serviceId(rs.getInt("service_id"))
                        .serviceName(rs.getString("service_name"))
                        .originalServicePrice(rs.getBigDecimal("original_service_price"))
                        .discountAmountApplied(rs.getBigDecimal("discount_amount_applied"))
                        .finalPriceAfterDiscount(rs.getBigDecimal("final_price_after_discount"))
                        .notesByCustomer(rs.getString("notes_by_customer"))
                        .notesByStaff(rs.getString("notes_by_staff"))
                        .status(rs.getString("status"))
                        .paymentStatus(rs.getString("payment_status"))
                        .build();
                list.add(det);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding appointment details: " + ex.getMessage());
        } finally {
            DBContext.closeConnection();
        }

        return list;
    }

    public boolean updateStatusAndPayment(int appointmentId, String newStatus, String newPaymentStatus) {
        String sql
                = "UPDATE appointments "
                + "SET status = ?, payment_status = ? "
                + "WHERE appointment_id = ?";

        try {
            Connection conn = DBContext.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, newStatus);
            stmt.setString(2, newPaymentStatus);
            stmt.setInt(3, appointmentId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;  // nếu >=1 dòng thay đổi thì trả về true

        } catch (SQLException ex) {
            System.out.println("Error updating status/payment: " + ex.getMessage());
            return false;
        } finally {
            DBContext.closeConnection();
        }
    }


    public List<Appointment> findUserAppointmentsBySearch(int userId, String searchFilter) {
        List<Appointment> appointments = new ArrayList<>();

        // Chỉ cần tìm theo customer_id, và (nếu có) searchFilter
        StringBuilder sql = new StringBuilder(
                "SELECT "
                + "  a.appointment_id, "
                + "  c.full_name   AS customer_name, "
                + "  bg.group_name AS booking_group_name, "
                + "  u.full_name   AS therapist_name, "
                + "  a.start_time, a.end_time, "
                + "  a.total_original_price, a.total_discount_amount, "
                + "  a.points_redeemed_value, a.total_final_price, a.promotion_id, "
                + "  a.status, a.payment_status, a.cancel_reason, "
                + "  a.created_at, a.updated_at "
                + "FROM appointments a "
                + "  JOIN customers c ON a.customer_id = c.customer_id "
                + "  LEFT JOIN booking_groups bg ON a.booking_group_id = bg.booking_group_id "
                + "  LEFT JOIN users u ON a.therapist_user_id = u.user_id AND u.role_id = 3 "
                + "WHERE a.customer_id = ? "
        );
        List<Object> params = new ArrayList<>();
        params.add(userId);

        // Nếu có giá trị tìm kiếm (searchFilter) thì thêm điều kiện LIKE
        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append(" AND (bg.group_name LIKE ? OR u.full_name LIKE ?) ");
            String keyword = "%" + searchFilter.trim() + "%";
            params.add(keyword);
            params.add(keyword);
        }

        // Thứ tự hiển thị: gần nhất trước (có thể tuỳ chỉnh lại nếu muốn)
        sql.append(" ORDER BY a.appointment_id DESC ");

        try {
            Connection conn = DBContext.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql.toString());

            // Gán tham số
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                appointments.add(getFromResultSet(rs));
            }

        } catch (SQLException ex) {
            System.out.println("Error finding user appointments by search: " + ex.getMessage());
        } finally {
            closeConnection();
        }

        return appointments;
    }

    @Override
    public List<Appointment> findAll() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean existsById(Integer id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void deleteById(Integer id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public <S extends Appointment> S update(S entity) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(Appointment entity) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public Appointment getFromResultSet(ResultSet rs) throws SQLException {
        Appointment ap = new Appointment();
        ap.setAppointmentId(rs.getInt("appointment_id"));
        ap.setCustomerName(rs.getString("customer_name"));
        ap.setBookingGroupName(rs.getString("booking_group_name"));
        ap.setTherapistName(rs.getString("therapist_name"));
        ap.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
        ap.setEndTime(rs.getTimestamp("end_time").toLocalDateTime());
        ap.setTotalOriginalPrice(rs.getBigDecimal("total_original_price"));
        ap.setTotalDiscountAmount(rs.getBigDecimal("total_discount_amount"));
        ap.setPointsRedeemedValue(rs.getBigDecimal("points_redeemed_value"));
        ap.setTotalFinalPrice(rs.getBigDecimal("total_final_price"));
        ap.setPromotionId(rs.getInt("promotion_id"));
        ap.setStatus(rs.getString("status"));
        ap.setPaymentStatus(rs.getString("payment_status"));
        ap.setCancelReason(rs.getString("cancel_reason"));
        ap.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        ap.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

        return ap;
    }
}
