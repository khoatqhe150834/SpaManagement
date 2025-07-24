package service;

import dao.CustomerDAO;
import dao.CustomerPointDAO;
import dao.PointRedemptionDAO;
import dao.RewardPointRuleDAO;
import model.CustomerTier;
import model.PointRedemption;
import model.RewardPointRule;

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

    // Tính điểm theo quy tắc đổi điểm động (dựa trên reward_point_rules)
    public int calculatePointsByOrderValueDynamic(int orderValue) {
        RewardPointRuleDAO ruleDAO = new RewardPointRuleDAO();
        RewardPointRule rule = ruleDAO.getActiveRule();
        if (rule == null || rule.getMoneyPerPoint() == null || rule.getMoneyPerPoint() <= 0) {
            // fallback mặc định nếu chưa có rule
            return orderValue / 100000;
        }
        return orderValue / rule.getMoneyPerPoint();
    }

    // Cộng điểm theo tổng hóa đơn (chỉ cộng nếu chưa cộng trong ngày, dùng quy tắc động)
    public int addOrderValuePointsIfNotYetDynamic(int customerId, int orderValue) {
        if (!customerPointDAO.hasReceivedOrderValuePointsToday(customerId)) {
            int points = calculatePointsByOrderValueDynamic(orderValue);
            customerPointDAO.addPoints(customerId, points, "Tổng hóa đơn");
            updateCustomerTierInDb(customerId);
            return points;
        }
        return 0;
    }

    // Đổi điểm lấy phần thưởng/mã giảm giá
    public boolean redeemPointsForReward(int customerId, int pointsToUse, String rewardType, String rewardValue, String note) {
        int currentPoints = getPoints(customerId);
        if (currentPoints < pointsToUse) return false; // Không đủ điểm
        // Trừ điểm
        customerPointDAO.addPoints(customerId, -pointsToUse, "Đổi điểm lấy " + rewardType + ": " + rewardValue);
        // Ghi lịch sử đổi điểm
        PointRedemption redemption = new PointRedemption();
        redemption.setCustomerId(customerId);
        redemption.setPointsUsed(pointsToUse);
        redemption.setRewardType(rewardType);
        redemption.setRewardValue(rewardValue);
        redemption.setStatus("SUCCESS");
        redemption.setNote(note);
        PointRedemptionDAO redemptionDAO = new PointRedemptionDAO();
        redemptionDAO.insertRedemption(redemption);
        updateCustomerTierInDb(customerId);
        return true;
    }

    // Hàm cập nhật tier vào DB
    public void updateCustomerTierInDb(int customerId) {
        int points = getPoints(customerId); // Đây là tổng điểm từ customer_points
        CustomerTier tier = CustomerTier.fromPoints(points);
        customerDAO.updateTier(customerId, tier.getLabel());
        
        // Lấy điểm hiện tại trong customers.loyalty_points
        int currentLoyaltyPoints = customerDAO.getLoyaltyPoints(customerId);
        // Cộng dồn với điểm mới từ customer_points
        int totalPoints = currentLoyaltyPoints + points;
        // Cập nhật loyalty_points = điểm cũ + điểm mới
        customerDAO.updateLoyaltyPoints(customerId, totalPoints);
    }
} 