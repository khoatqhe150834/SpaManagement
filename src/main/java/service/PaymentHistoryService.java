package service;

import dao.PaymentDAO;
import dao.PaymentItemDAO;
import dao.PaymentItemUsageDAO;
import model.Payment;
import model.PaymentItem;
import model.PaymentItemUsage;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service class for handling payment history operations
 * Provides business logic for payment history with pagination and filtering
 * 
 * @author G1_SpaManagement Team
 */
public class PaymentHistoryService {
    
    private static final Logger LOGGER = Logger.getLogger(PaymentHistoryService.class.getName());
    private final PaymentDAO paymentDAO;
    private final PaymentItemDAO paymentItemDAO;
    private final PaymentItemUsageDAO paymentItemUsageDAO;
    
    public PaymentHistoryService() {
        this.paymentDAO = new PaymentDAO();
        this.paymentItemDAO = new PaymentItemDAO();
        this.paymentItemUsageDAO = new PaymentItemUsageDAO();
    }
    
    /**
     * Get customer payment history with pagination and filtering
     */
    public PaymentHistoryResult getCustomerPaymentHistory(Integer customerId, int page, int pageSize,
            String statusFilter, String paymentMethodFilter, Date startDate, Date endDate, String searchQuery) 
            throws SQLException {
        
        // Get payments with filters using enhanced DAO methods
        List<Payment> payments = paymentDAO.findByCustomerIdWithFilters(
            customerId, page, pageSize, statusFilter, paymentMethodFilter, 
            startDate, endDate, searchQuery);
        
        // Get total count for pagination
        int totalRecords = paymentDAO.countByCustomerIdWithFilters(
            customerId, statusFilter, paymentMethodFilter, 
            startDate, endDate, searchQuery);
        
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        
        // Load payment items and usage for each payment
        for (Payment payment : payments) {
            try {
                List<PaymentItem> paymentItems = paymentItemDAO.findByPaymentId(payment.getPaymentId());
                
                // Load usage information for each payment item - FIXED: Handle Optional properly
                for (PaymentItem item : paymentItems) {
                    try {
                        Optional<PaymentItemUsage> usageOptional = paymentItemUsageDAO.findByPaymentItemId(item.getPaymentItemId());
                        PaymentItemUsage usage = usageOptional.orElse(null);
                        item.setUsage(usage);
                    } catch (SQLException ex) {
                        LOGGER.log(Level.WARNING, "Could not load usage for payment item: " + item.getPaymentItemId(), ex);
                        // Continue processing other items even if one fails
                        item.setUsage(null);
                    }
                }
                
                payment.setPaymentItems(paymentItems);
                
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Could not load payment items for payment: " + payment.getPaymentId(), ex);
                // Continue processing other payments even if one fails
            }
        }
        
        return new PaymentHistoryResult(payments, page, pageSize, totalPages, totalRecords);
    }
    
    /**
     * Get recent payments for dashboard preview
     */
    public List<Payment> getRecentPayments(Integer customerId, int limit) throws SQLException {
        List<Payment> payments = paymentDAO.findRecentByCustomerId(customerId, limit);
        
        // Load basic payment items for each payment (without full usage details for performance)
        for (Payment payment : payments) {
            try {
                List<PaymentItem> paymentItems = paymentItemDAO.findByPaymentId(payment.getPaymentId());
                payment.setPaymentItems(paymentItems);
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Could not load payment items for recent payment: " + payment.getPaymentId(), ex);
            }
        }
        
        return payments;
    }
    
    /**
     * Get customer payment statistics
     */
    public Map<String, Object> getCustomerPaymentStatistics(Integer customerId) throws SQLException {
        return paymentDAO.getCustomerPaymentStatistics(customerId);
    }
    
    /**
     * Get payments by date range for a customer
     */
    public List<Payment> getPaymentsByDateRange(Integer customerId, Date startDate, Date endDate) throws SQLException {
        return paymentDAO.findByCustomerIdAndDateRange(customerId, startDate, endDate);
    }
    
    /**
     * Result wrapper class for payment history with pagination info
     */
    public static class PaymentHistoryResult {
        private final List<Payment> payments;
        private final int currentPage;
        private final int pageSize;
        private final int totalPages;
        private final int totalRecords;
        
        public PaymentHistoryResult(List<Payment> payments, int currentPage, int pageSize, 
                int totalPages, int totalRecords) {
            this.payments = payments;
            this.currentPage = currentPage;
            this.pageSize = pageSize;
            this.totalPages = totalPages;
            this.totalRecords = totalRecords;
        }
        
        // Getters
        public List<Payment> getPayments() { return payments; }
        public int getCurrentPage() { return currentPage; }
        public int getPageSize() { return pageSize; }
        public int getTotalPages() { return totalPages; }
        public int getTotalRecords() { return totalRecords; }
        public boolean hasNextPage() { return currentPage < totalPages; }
        public boolean hasPreviousPage() { return currentPage > 1; }
        
        /**
         * Get the starting record number for current page
         */
        public int getStartRecord() {
            return (currentPage - 1) * pageSize + 1;
        }
        
        /**
         * Get the ending record number for current page
         */
        public int getEndRecord() {
            int endRecord = currentPage * pageSize;
            return Math.min(endRecord, totalRecords);
        }
        
        /**
         * Check if there are any payments
         */
        public boolean hasPayments() {
            return payments != null && !payments.isEmpty();
        }
        
        /**
         * Get pagination info string
         */
        public String getPaginationInfo() {
            if (totalRecords == 0) {
                return "Không có kết quả";
            }
            return String.format("Hiển thị %d - %d trong tổng số %d kết quả", 
                getStartRecord(), getEndRecord(), totalRecords);
        }
    }
}
