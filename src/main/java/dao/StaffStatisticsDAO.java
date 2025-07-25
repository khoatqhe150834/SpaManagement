package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import db.DBContext;

import java.util.ArrayList;
import java.util.List;

public class StaffStatisticsDAO {
    // Lấy tổng số booking đã thực hiện (COMPLETED) của một therapist
    public int getTotalBookings(int therapistId) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM bookings WHERE therapist_user_id = ? AND booking_status = 'COMPLETED'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, therapistId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public static class TherapistBookingStats {
        private int therapistId;
        private String fullName;
        private String avatarUrl;
        private String serviceTypeName;
        private int totalBookings;
        private int monthlyBookings;
        private int totalCustomers;
        private int totalServices;

        public int getTherapistId() { return therapistId; }
        public void setTherapistId(int therapistId) { this.therapistId = therapistId; }
        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }
        public String getAvatarUrl() { return avatarUrl; }
        public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
        public String getServiceTypeName() { return serviceTypeName; }
        public void setServiceTypeName(String serviceTypeName) { this.serviceTypeName = serviceTypeName; }
        public int getTotalBookings() { return totalBookings; }
        public void setTotalBookings(int totalBookings) { this.totalBookings = totalBookings; }
        public int getMonthlyBookings() { return monthlyBookings; }
        public void setMonthlyBookings(int monthlyBookings) { this.monthlyBookings = monthlyBookings; }
        public int getTotalCustomers() { return totalCustomers; }
        public void setTotalCustomers(int totalCustomers) { this.totalCustomers = totalCustomers; }
        public int getTotalServices() { return totalServices; }
        public void setTotalServices(int totalServices) { this.totalServices = totalServices; }
    }

    // Lấy danh sách tất cả therapist và các chỉ số booking
    public List<TherapistBookingStats> getAllTherapistBookingStats() {
        List<TherapistBookingStats> statsList = new ArrayList<>();
        String sql = "SELECT t.user_id, u.full_name, u.avatar_url, st.name AS service_type_name, " +
                "COUNT(DISTINCT CASE WHEN b.booking_id IS NOT NULL THEN b.booking_id END) AS total_bookings, " +
                "SUM(CASE WHEN b.booking_id IS NOT NULL AND MONTH(b.appointment_date) = MONTH(CURRENT_DATE()) AND YEAR(b.appointment_date) = YEAR(CURRENT_DATE()) THEN 1 ELSE 0 END) AS monthly_bookings, " +
                "COUNT(DISTINCT CASE WHEN b.booking_id IS NOT NULL THEN b.customer_id END) AS total_customers, " +
                "COUNT(DISTINCT CASE WHEN b.booking_id IS NOT NULL THEN b.service_id END) AS total_services " +
                "FROM therapists t " +
                "JOIN users u ON t.user_id = u.user_id " +
                "LEFT JOIN service_types st ON t.service_type_id = st.service_type_id " +
                "LEFT JOIN bookings b ON t.user_id = b.therapist_user_id AND b.booking_status = 'COMPLETED' " +
                "GROUP BY t.user_id, u.full_name, u.avatar_url, st.name " +
                "ORDER BY total_bookings DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                TherapistBookingStats stats = new TherapistBookingStats();
                stats.setTherapistId(rs.getInt("user_id"));
                stats.setFullName(rs.getString("full_name"));
                stats.setAvatarUrl(rs.getString("avatar_url"));
                stats.setServiceTypeName(rs.getString("service_type_name"));
                stats.setTotalBookings(rs.getInt("total_bookings"));
                stats.setMonthlyBookings(rs.getInt("monthly_bookings"));
                stats.setTotalCustomers(rs.getInt("total_customers"));
                stats.setTotalServices(rs.getInt("total_services"));
                statsList.add(stats);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return statsList;
    }

    // 1. Số booking đang chờ xử lý (SCHEDULED/CONFIRMED)
    public int getPendingBookings() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE booking_status IN ('SCHEDULED', 'CONFIRMED')";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 2. Số booking bị hủy (CANCELLED) trong tháng/năm
    public int getCancelledBookingsThisMonth() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE booking_status = 'CANCELLED' AND MONTH(appointment_date) = MONTH(CURRENT_DATE()) AND YEAR(appointment_date) = YEAR(CURRENT_DATE())";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 3. Số booking bị khách không đến (NO_SHOW)
    public int getNoShowBookings() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE booking_status = 'NO_SHOW'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 4. Tổng doanh thu từ booking đã hoàn thành
    public double getTotalRevenue() {
        String sql = "SELECT SUM(pi.total_price) FROM bookings b JOIN payment_items pi ON b.payment_item_id = pi.payment_item_id WHERE b.booking_status = 'COMPLETED'";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 5. Ngày/tháng có số booking nhiều nhất
    public String getPeakBookingDay() {
        String sql = "SELECT appointment_date, COUNT(*) as cnt FROM bookings GROUP BY appointment_date ORDER BY cnt DESC LIMIT 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getString("appointment_date");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 6. Nhân viên có số booking nhiều nhất/thấp nhất
    public int getTopStaffId() {
        String sql = "SELECT therapist_user_id FROM bookings WHERE booking_status = 'COMPLETED' GROUP BY therapist_user_id ORDER BY COUNT(*) DESC LIMIT 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    public int getBottomStaffId() {
        String sql = "SELECT therapist_user_id FROM bookings WHERE booking_status = 'COMPLETED' GROUP BY therapist_user_id ORDER BY COUNT(*) ASC LIMIT 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 7. Khách hàng quay lại nhiều nhất (top returning customers)
    public int getTopReturningCustomerId() {
        String sql = "SELECT customer_id FROM bookings WHERE booking_status = 'COMPLETED' GROUP BY customer_id ORDER BY COUNT(*) DESC LIMIT 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 8. Tỷ lệ booking online/offline (giả sử có cột source_type)
    public double getOnlineBookingRate() {
        String sql = "SELECT (SELECT COUNT(*) FROM bookings WHERE source_type = 'ONLINE') / COUNT(*) FROM bookings";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 9. Tỷ lệ booking theo loại dịch vụ
    public List<String[]> getServiceTypeBookingRate() {
        List<String[]> result = new ArrayList<>();
        String sql = "SELECT st.name, COUNT(*) FROM bookings b JOIN services s ON b.service_id = s.service_id JOIN service_types st ON s.service_type_id = st.service_type_id GROUP BY st.name";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.add(new String[]{rs.getString(1), String.valueOf(rs.getInt(2))});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    // 10. Số lượng booking theo ca (sáng/chiều/tối)
    public int getMorningBookings() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE HOUR(appointment_time) >= 6 AND HOUR(appointment_time) < 12";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    public int getAfternoonBookings() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE HOUR(appointment_time) >= 12 AND HOUR(appointment_time) < 18";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    public int getEveningBookings() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE HOUR(appointment_time) >= 18 OR HOUR(appointment_time) < 6";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
} 