package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.PaymentDAO;
import dao.PaymentItemDAO;
import dao.PaymentItemUsageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.Payment;
import model.PaymentItem;
import model.PaymentItemUsage;
import service.PaymentHistoryService;

/**
 * Controller for payment-related functionality
 * Handles payment history, payment details, and other payment operations
 * 
 * @author G1_SpaManagement Team
 */
@WebServlet(name = "PaymentController", urlPatterns = {"/customer/payment-history", "/customer/payments", "/customer/payment-details"})
public class PaymentController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(PaymentController.class.getName());
    private final PaymentDAO paymentDAO;
    private final PaymentItemDAO paymentItemDAO;
    private final PaymentItemUsageDAO paymentItemUsageDAO;
    private final PaymentHistoryService paymentHistoryService;
    
    public PaymentController() {
        this.paymentDAO = new PaymentDAO();
        this.paymentItemDAO = new PaymentItemDAO();
        this.paymentItemUsageDAO = new PaymentItemUsageDAO();
        this.paymentHistoryService = new PaymentHistoryService();
    }

    /**
     * Handles GET requests for payment operations
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getServletPath();
        
        switch (pathInfo) {
            case "/customer/payment-history":
            case "/customer/payments":  // Alternative URL for payment history
                handlePaymentHistory(request, response);
                break;
            case "/customer/payment-details":
                handlePaymentDetails(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }
    
    /**
     * Handles payment history display
     */
    private void handlePaymentHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        
        // Security check - ensure customer is logged in
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get pagination parameters
            int page = getIntParameter(request, "page", 1);
            int pageSize = getIntParameter(request, "pageSize", 10);
            
            // Get filter parameters
            String statusFilter = request.getParameter("status");
            String paymentMethodFilter = request.getParameter("paymentMethod");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String searchQuery = request.getParameter("search");
            
            // Parse date filters
            Date startDate = parseDate(startDateStr);
            Date endDate = parseDate(endDateStr);
            
            // Get payment history with filters using enhanced DAO methods
            List<Payment> payments = paymentDAO.findByCustomerIdWithFilters(
                customer.getCustomerId(), page, pageSize, statusFilter, paymentMethodFilter, 
                startDate, endDate, searchQuery);
            
            // Get total count for pagination
            int totalRecords = paymentDAO.countByCustomerIdWithFilters(
                customer.getCustomerId(), statusFilter, paymentMethodFilter, 
                startDate, endDate, searchQuery);
            
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            
            // Get payment items and usage for each payment
            for (Payment payment : payments) {
                List<PaymentItem> paymentItems = paymentItemDAO.findByPaymentId(payment.getPaymentId());
                payment.setPaymentItems(paymentItems);
                
                // Get usage information for each payment item - FIXED: Handle Optional properly
                for (PaymentItem item : paymentItems) {
                    try {
                        Optional<PaymentItemUsage> usageOptional = paymentItemUsageDAO.findByPaymentItemId(item.getPaymentItemId());
                        PaymentItemUsage usage = usageOptional.orElse(null);
                        item.setUsage(usage);
                    } catch (SQLException ex) {
                        LOGGER.log(Level.WARNING, "Could not load usage for payment item: " + item.getPaymentItemId(), ex);
                        // Set usage to null if there's an error
                        item.setUsage(null);
                    }
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("payments", payments);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("hasNextPage", page < totalPages);
            request.setAttribute("hasPreviousPage", page > 1);
            
            // Set filter attributes for form persistence
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("paymentMethodFilter", paymentMethodFilter);
            request.setAttribute("startDate", startDateStr);
            request.setAttribute("endDate", endDateStr);
            request.setAttribute("searchQuery", searchQuery);
            
            // Set customer info and page title
            request.setAttribute("customer", customer);
            request.setAttribute("pageTitle", "Lịch Sử Thanh Toán - BeautyZone Spa");
            
            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/view/customer/payment-history.jsp")
                    .forward(request, response);
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error in payment history", ex);
            request.setAttribute("errorMessage", "Lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/view/common/error.jsp")
                    .forward(request, response);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error in payment history", ex);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi không mong muốn.");
            request.getRequestDispatcher("/WEB-INF/view/common/error.jsp")
                    .forward(request, response);
        }
    }
    
    /**
     * Handles payment details display for a specific payment
     */
    private void handlePaymentDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        
        // Security check - ensure customer is logged in
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            String paymentIdStr = request.getParameter("id");
            if (paymentIdStr == null || paymentIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Payment ID is required");
                return;
            }
            
            int paymentId = Integer.parseInt(paymentIdStr);
            
            // Get payment details - FIXED: Handle Optional properly
            Optional<Payment> paymentOptional = paymentDAO.findById(paymentId);
            if (!paymentOptional.isPresent()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Payment not found");
                return;
            }

            Payment payment = paymentOptional.get();
            if (!payment.getCustomerId().equals(customer.getCustomerId())) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Payment not found");
                return;
            }
            
            // Get payment items and usage
            List<PaymentItem> paymentItems = paymentItemDAO.findByPaymentId(paymentId);
            payment.setPaymentItems(paymentItems);
            
            // Get usage information for each payment item - FIXED: Handle Optional properly
            for (PaymentItem item : paymentItems) {
                try {
                    Optional<PaymentItemUsage> usageOptional = paymentItemUsageDAO.findByPaymentItemId(item.getPaymentItemId());
                    PaymentItemUsage usage = usageOptional.orElse(null);
                    item.setUsage(usage);
                } catch (SQLException ex) {
                    LOGGER.log(Level.WARNING, "Could not load usage for payment item: " + item.getPaymentItemId(), ex);
                    item.setUsage(null);
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("payment", payment);
            request.setAttribute("customer", customer);
            request.setAttribute("pageTitle", "Chi Tiết Thanh Toán #" + paymentId + " - BeautyZone Spa");
            
            // Forward to payment details JSP (to be created if needed)
            request.getRequestDispatcher("/WEB-INF/view/customer/payment-details.jsp")
                    .forward(request, response);
            
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid payment ID format");
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error in payment details", ex);
            request.setAttribute("errorMessage", "Lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/view/common/error.jsp")
                    .forward(request, response);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error in payment details", ex);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi không mong muốn.");
            request.getRequestDispatcher("/WEB-INF/view/common/error.jsp")
                    .forward(request, response);
        }
    }
    
    /**
     * Handles POST requests (currently not used, redirects to GET)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST to GET for now
        response.sendRedirect(request.getContextPath() + "/customer/payment-history");
    }
    
    /**
     * Helper method to get integer parameter with default value
     */
    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try {
                return Integer.parseInt(paramValue);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid integer parameter: " + paramName + " = " + paramValue);
            }
        }
        return defaultValue;
    }
    
    /**
     * Helper method to parse date string
     */
    private Date parseDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }
        
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            return sdf.parse(dateStr);
        } catch (ParseException e) {
            LOGGER.log(Level.WARNING, "Invalid date format: " + dateStr);
            return null;
        }
    }
}
