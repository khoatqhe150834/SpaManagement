/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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
                + "c.full_name AS customer_name, "
                + "bg.group_name AS booking_group_name, "
                + "u.full_name AS therapist_name, "
                + "a.start_time, a.end_time, "
                + "a.total_original_price, a.total_discount_amount, "
                + "a.points_redeemed_value, a.total_final_price, a.promotion_id,"
                + "a.status, a.payment_status, a.cancel_reason, "
                + "a.created_at, a.updated_at "
                + "FROM Appointments a "
                + "JOIN Customers c ON a.customer_id = c.customer_id "
                + "LEFT JOIN Booking_Groups bg ON a.booking_group_id = bg.booking_group_id "
                + "LEFT JOIN Users u ON a.therapist_user_id = u.user_id AND u.role_id = 3 "
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
                + "FROM Appointments a "
                + "JOIN Customers c ON a.customer_id = c.customer_id "
                + "LEFT JOIN Booking_Groups bg ON a.booking_group_id = bg.booking_group_id "
                + "LEFT JOIN Users u ON a.therapist_user_id = u.user_id AND u.role_id = 3 "
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
