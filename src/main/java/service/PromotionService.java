package service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.PromotionDAO;
import dao.PromotionUsageDAO;
import model.Promotion;
import model.PromotionUsage;

/**
 * Service class for handling promotion code applications and validations
 */
public class PromotionService {
    private static final Logger logger = Logger.getLogger(PromotionService.class.getName());
    
    private final PromotionDAO promotionDAO;
    private final PromotionUsageDAO promotionUsageDAO;
    
    public PromotionService() {
        this.promotionDAO = new PromotionDAO();
        this.promotionUsageDAO = new PromotionUsageDAO();
    }
    
    public PromotionService(PromotionDAO promotionDAO, PromotionUsageDAO promotionUsageDAO) {
        this.promotionDAO = promotionDAO;
        this.promotionUsageDAO = promotionUsageDAO;
    }

    /**
     * Result class for promotion application
     */
    public static class PromotionApplicationResult {
        private boolean success;
        private String message;
        private BigDecimal discountAmount;
        private BigDecimal finalAmount;
        private Promotion promotion;
        
        public PromotionApplicationResult(boolean success, String message) {
            this.success = success;
            this.message = message;
            this.discountAmount = BigDecimal.ZERO;
            this.finalAmount = BigDecimal.ZERO;
        }
        
        public PromotionApplicationResult(boolean success, String message, BigDecimal discountAmount, 
                                        BigDecimal finalAmount, Promotion promotion) {
            this.success = success;
            this.message = message;
            this.discountAmount = discountAmount;
            this.finalAmount = finalAmount;
            this.promotion = promotion;
        }
        
        // Getters and setters
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        public BigDecimal getDiscountAmount() { return discountAmount; }
        public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }
        public BigDecimal getFinalAmount() { return finalAmount; }
        public void setFinalAmount(BigDecimal finalAmount) { this.finalAmount = finalAmount; }
        public Promotion getPromotion() { return promotion; }
        public void setPromotion(Promotion promotion) { this.promotion = promotion; }
    }

    /**
     * Apply promotion code to an order amount
     * @param promotionCode The promotion code to apply
     * @param customerId The customer ID
     * @param originalAmount The original order amount
     * @param paymentId Optional payment ID (for tracking)
     * @param bookingId Optional booking ID (for tracking)
     * @return PromotionApplicationResult with success status and details
     */
    public PromotionApplicationResult applyPromotionCode(String promotionCode, Integer customerId, 
                                                       BigDecimal originalAmount, Integer paymentId, Integer bookingId) {
        try {
            // 1. Find promotion by code
            Optional<Promotion> promotionOpt = promotionDAO.findByCode(promotionCode);
            if (!promotionOpt.isPresent()) {
                return new PromotionApplicationResult(false, "Mã khuyến mãi không hợp lệ hoặc không tồn tại");
            }
            
            Promotion promotion = promotionOpt.get();
            
            // 2. Validate promotion
            String validationError = validatePromotion(promotion, customerId, originalAmount);
            if (validationError != null) {
                return new PromotionApplicationResult(false, validationError);
            }
            
            // 3. Calculate discount
            BigDecimal discountAmount = calculateDiscount(promotion, originalAmount);
            BigDecimal finalAmount = originalAmount.subtract(discountAmount);
            
            // 4. Record usage
            PromotionUsage usage = new PromotionUsage(promotion.getPromotionId(), customerId, 
                                                    discountAmount, originalAmount, finalAmount);
            usage.setPaymentId(paymentId);
            usage.setBookingId(bookingId);
            
            boolean saved = promotionUsageDAO.save(usage);
            if (!saved) {
                return new PromotionApplicationResult(false, "Không thể ghi nhận việc sử dụng mã khuyến mãi");
            }
            
            // 5. Update promotion usage count
            updatePromotionUsageCount(promotion.getPromotionId());
            
            logger.info(String.format("Applied promotion %s for customer %d: %.2f discount", 
                                     promotionCode, customerId, discountAmount));
            
            return new PromotionApplicationResult(true, "Áp dụng mã khuyến mãi thành công", 
                                                discountAmount, finalAmount, promotion);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error applying promotion code: " + promotionCode, e);
            return new PromotionApplicationResult(false, "Lỗi hệ thống khi áp dụng mã khuyến mãi");
        }
    }

    /**
     * Validate if promotion can be applied
     */
    private String validatePromotion(Promotion promotion, Integer customerId, BigDecimal orderAmount) {
        LocalDateTime now = LocalDateTime.now();
        
        // Check if promotion is active
        if (!"ACTIVE".equals(promotion.getStatus())) {
            return "Mã khuyến mãi hiện không khả dụng";
        }
        
        // Check if promotion is within valid date range
        if (promotion.getStartDate() != null && now.isBefore(promotion.getStartDate())) {
            return "Mã khuyến mãi chưa có hiệu lực";
        }
        
        if (promotion.getEndDate() != null && now.isAfter(promotion.getEndDate())) {
            return "Mã khuyến mãi đã hết hạn";
        }
        
        // Check minimum order amount
        if (promotion.getMinimumAppointmentValue() != null && 
            orderAmount.compareTo(promotion.getMinimumAppointmentValue()) < 0) {
            return String.format("Đơn hàng tối thiểu phải từ %.0f VND để sử dụng mã này", 
                               promotion.getMinimumAppointmentValue().doubleValue());
        }
        
        // Check usage limits per customer
        if (promotion.getUsageLimitPerCustomer() != null) {
            int customerUsageCount = promotionUsageDAO.getCustomerUsageCount(promotion.getPromotionId(), customerId);
            if (customerUsageCount >= promotion.getUsageLimitPerCustomer()) {
                return "Bạn đã sử dụng hết số lần cho phép với mã này";
            }
        }
        
        // Check total usage limit
        if (promotion.getTotalUsageLimit() != null) {
            int totalUsageCount = promotionUsageDAO.getTotalUsageCount(promotion.getPromotionId());
            if (totalUsageCount >= promotion.getTotalUsageLimit()) {
                return "Mã khuyến mãi đã hết lượt sử dụng";
            }
        }
        
        return null; // Valid
    }

    /**
     * Calculate discount amount based on promotion type
     */
    private BigDecimal calculateDiscount(Promotion promotion, BigDecimal originalAmount) {
        BigDecimal discountAmount = BigDecimal.ZERO;
        
        switch (promotion.getDiscountType()) {
            case "PERCENTAGE":
                // Percentage discount: amount * (percentage / 100)
                discountAmount = originalAmount.multiply(promotion.getDiscountValue())
                                             .divide(new BigDecimal("100"));
                break;
                
            case "FIXED":
            case "FIXED_AMOUNT":
                // Fixed amount discount
                discountAmount = promotion.getDiscountValue();
                // Don't let discount exceed original amount
                if (discountAmount.compareTo(originalAmount) > 0) {
                    discountAmount = originalAmount;
                }
                break;
                
            case "FREE_SERVICE":
                // For free service, the discount value might represent the service price
                discountAmount = promotion.getDiscountValue();
                break;
                
            default:
                logger.warning("Unknown discount type: " + promotion.getDiscountType());
                break;
        }
        
        return discountAmount;
    }

    /**
     * Update promotion current usage count
     */
    private void updatePromotionUsageCount(Integer promotionId) {
        try {
            Optional<Promotion> promotionOpt = promotionDAO.findById(promotionId);
            if (promotionOpt.isPresent()) {
                Promotion promotion = promotionOpt.get();
                int currentCount = promotion.getCurrentUsageCount() != null ? promotion.getCurrentUsageCount() : 0;
                promotion.setCurrentUsageCount(currentCount + 1);
                promotionDAO.update(promotion);
            }
        } catch (Exception e) {
            logger.log(Level.WARNING, "Failed to update promotion usage count", e);
        }
    }

    /**
     * Check if customer can use a specific promotion
     */
    public boolean canCustomerUsePromotion(String promotionCode, Integer customerId, BigDecimal orderAmount) {
        try {
            Optional<Promotion> promotionOpt = promotionDAO.findByCode(promotionCode);
            if (!promotionOpt.isPresent()) {
                return false;
            }
            
            String validationError = validatePromotion(promotionOpt.get(), customerId, orderAmount);
            return validationError == null;
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error checking promotion eligibility", e);
            return false;
        }
    }

    /**
     * Get promotion by code for preview (without applying)
     */
    public Optional<Promotion> getPromotionByCode(String promotionCode) {
        return promotionDAO.findByCode(promotionCode);
    }

    /**
     * Calculate potential discount without applying
     */
    public PromotionApplicationResult previewPromotion(String promotionCode, Integer customerId, BigDecimal originalAmount) {
        try {
            Optional<Promotion> promotionOpt = promotionDAO.findByCode(promotionCode);
            if (!promotionOpt.isPresent()) {
                return new PromotionApplicationResult(false, "Mã khuyến mãi không hợp lệ");
            }
            
            Promotion promotion = promotionOpt.get();
            String validationError = validatePromotion(promotion, customerId, originalAmount);
            if (validationError != null) {
                return new PromotionApplicationResult(false, validationError);
            }
            
            BigDecimal discountAmount = calculateDiscount(promotion, originalAmount);
            BigDecimal finalAmount = originalAmount.subtract(discountAmount);
            
            return new PromotionApplicationResult(true, "Mã khuyến mãi hợp lệ", 
                                                discountAmount, finalAmount, promotion);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error previewing promotion", e);
            return new PromotionApplicationResult(false, "Lỗi hệ thống");
        }
    }
} 
 
 