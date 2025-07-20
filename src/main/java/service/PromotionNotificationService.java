package service;

import java.util.logging.Level;
import java.util.logging.Logger;

import dao.CustomerDAO;
import dao.PromotionDAO;
import model.Customer;
import model.Promotion;

/**
 * Service để gửi thông báo khuyến mãi cho khách hàng
 */
public class PromotionNotificationService {
    private static final Logger logger = Logger.getLogger(PromotionNotificationService.class.getName());
    
    private final CustomerDAO customerDAO;
    private final PromotionDAO promotionDAO;
    
    public PromotionNotificationService() {
        this.customerDAO = new CustomerDAO();
        this.promotionDAO = new PromotionDAO();
    }
    
    /**
     * Gửi thông báo promotion mới cho tất cả khách hàng
     */
    public void notifyNewPromotion(Promotion promotion) {
        try {
            logger.info("Sending notification for new promotion: " + promotion.getTitle());
            
            // TODO: Implement actual customer notification
            // Hiện tại chỉ log thông tin, có thể mở rộng sau để:
            // 1. Gửi email cho khách hàng
            // 2. Lưu thông báo vào database
            // 3. Gửi push notification
            
            logger.info("Promotion notification prepared for: " + promotion.getPromotionCode());
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error sending promotion notifications", e);
        }
    }
    
    /**
     * Gửi thông báo promotion cho khách hàng cụ thể
     */
    public void sendPromotionNotificationToCustomer(Customer customer, Promotion promotion) {
        try {
            // TODO: Implement actual notification sending
            // Có thể gửi email, push notification, hoặc lưu vào database
            
            logger.info("Notification sent to customer " + customer.getEmail() + 
                       " for promotion: " + promotion.getPromotionCode());
            
            // Placeholder: Lưu thông báo vào database hoặc gửi email
            // saveNotificationToDatabase(customer.getCustomerId(), promotion.getPromotionId());
            // sendEmailNotification(customer.getEmail(), promotion);
            
        } catch (Exception e) {
            logger.log(Level.WARNING, "Failed to send notification to customer: " + customer.getEmail(), e);
        }
    }
    
    /**
     * Gửi thông báo promotion sắp hết hạn
     */
    public void notifyExpiringPromotions() {
        try {
            logger.info("Checking for expiring promotions...");
            
            // TODO: Implement expiring promotion notification
            // Hiện tại chỉ log thông tin, có thể mở rộng sau
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error sending expiring promotion notifications", e);
        }
    }
} 