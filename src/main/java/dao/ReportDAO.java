/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.Report;
import db.DBContext; // Sử dụng class DBContext của bạn để lấy connection

public class ReportDAO {
    public List<Report> getRevenueByDate() {
        List<Report> list = new ArrayList<>();
        String sql = "SELECT DATE(payment_date) AS ngay, SUM(total_amount) AS tong_doanh_thu FROM payments GROUP BY DATE(payment_date) ORDER BY ngay DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Report r = new Report();
                r.setDate(rs.getDate("ngay"));
                r.setTotalRevenue(rs.getDouble("tong_doanh_thu"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
