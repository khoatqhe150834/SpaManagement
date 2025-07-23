package service;

import dao.CustomerDAO;
import dao.CustomerPointDAO;
import model.CustomerTier;

public class RewardPointService {
    private final CustomerPointDAO customerPointDAO = new CustomerPointDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();

    public int getPoints(int customerId) {
        return customerPointDAO.getPointsByCustomerId(customerId);
    }

    public CustomerTier getTier(int customerId) {
        int points = getPoints(customerId);
        return CustomerTier.fromPoints(points);
    }

    // Cộng điểm khi đăng nhập mỗi ngày
    public void addDailyLoginPoints(int customerId, int points) {
        // Ghi nhận điểm đăng nhập mỗi ngày
        customerPointDAO.addPoints(customerId, points, "Điểm đăng nhập mỗi ngày");
    }

    // Cộng điểm khi đăng nhập mỗi ngày (chỉ cộng nếu chưa cộng hôm nay)
    public void addDailyLoginPointsIfNotYet(int customerId, int points) {
        if (!customerPointDAO.hasReceivedDailyLoginPoints(customerId)) {
            customerPointDAO.addPoints(customerId, points, "Điểm đăng nhập mỗi ngày");
            updateCustomerTierInDb(customerId);
        }
    }

    // Cộng điểm khi dùng dịch vụ
    public void addServiceUsagePoints(int customerId, int points, String serviceName) {
        // Ghi nhận điểm khi sử dụng dịch vụ
        customerPointDAO.addPoints(customerId, points, "Dùng dịch vụ: " + serviceName);
    }

    // Cộng điểm khi dùng dịch vụ (chỉ cộng nếu chưa cộng cho dịch vụ này trong ngày)
    public void addServiceUsagePointsIfNotYet(int customerId, int points, String serviceName) {
        if (!customerPointDAO.hasReceivedServiceUsagePointsToday(customerId, serviceName)) {
            customerPointDAO.addPoints(customerId, points, "Dùng dịch vụ: " + serviceName);
            updateCustomerTierInDb(customerId);
        }
    }

    // Tính điểm theo giá trị tổng hóa đơn
    public int calculatePointsByOrderValue(int orderValue) {
        if (orderValue >= 2_000_000) return 60;
        if (orderValue >= 1_000_000) return 25;
        if (orderValue >= 500_000) return 10;
        return 5;
    }

    // Cộng điểm theo tổng hóa đơn (chỉ cộng nếu chưa cộng trong ngày)
    public int addOrderValuePointsIfNotYet(int customerId, int orderValue) {
        if (!customerPointDAO.hasReceivedOrderValuePointsToday(customerId)) {
            int points = calculatePointsByOrderValue(orderValue);
            customerPointDAO.addPoints(customerId, points, "Tổng hóa đơn");
            updateCustomerTierInDb(customerId);
            return points;
        }
        return 0;
    }

    // Hàm cập nhật tier vào DB
    private void updateCustomerTierInDb(int customerId) {
        int points = getPoints(customerId);
        CustomerTier tier = CustomerTier.fromPoints(points);
        customerDAO.updateTier(customerId, tier.getLabel());
    }
} 