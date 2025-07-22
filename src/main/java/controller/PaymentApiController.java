package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import dao.CustomerDAO;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.Payment;
import model.Payment.PaymentMethod;
import model.Payment.PaymentStatus;
import model.User;

/**
 * REST API Controller for Payment Management
 * Handles CRUD operations for payments via JSON API
 */
@WebServlet({
    "/api/payments",
    "/api/payments/*"
})
public class PaymentApiController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(PaymentApiController.class.getName());
    private final PaymentDAO paymentDAO;
    private final CustomerDAO customerDAO;
    private final Gson gson;
    
    public PaymentApiController() {
        this.paymentDAO = new PaymentDAO();
        this.customerDAO = new CustomerDAO();
        this.gson = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd HH:mm:ss")
            .create();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Get all payments (with pagination)
                handleGetAllPayments(request, response);
            } else {
                // Get specific payment by ID
                String paymentIdStr = pathInfo.substring(1); // Remove leading slash
                try {
                    int paymentId = Integer.parseInt(paymentIdStr);
                    handleGetPayment(request, response, paymentId);
                } catch (NumberFormatException e) {
                    sendErrorResponse(response, "Invalid payment ID", 400);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in PaymentApiController GET", e);
            sendErrorResponse(response, "Internal server error", 500);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Create new payment
            handleCreatePayment(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in PaymentApiController POST", e);
            sendErrorResponse(response, "Internal server error", 500);
        }
    }
    
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo != null && pathInfo.contains("/status")) {
                // Update payment status
                String[] parts = pathInfo.split("/");
                if (parts.length >= 2) {
                    try {
                        int paymentId = Integer.parseInt(parts[1]);
                        handleUpdatePaymentStatus(request, response, paymentId);
                    } catch (NumberFormatException e) {
                        sendErrorResponse(response, "Invalid payment ID", 400);
                    }
                }
            } else if (pathInfo != null && !pathInfo.equals("/")) {
                // Update entire payment
                String paymentIdStr = pathInfo.substring(1);
                try {
                    int paymentId = Integer.parseInt(paymentIdStr);
                    handleUpdatePayment(request, response, paymentId);
                } catch (NumberFormatException e) {
                    sendErrorResponse(response, "Invalid payment ID", 400);
                }
            } else {
                sendErrorResponse(response, "Invalid request", 400);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in PaymentApiController PUT", e);
            sendErrorResponse(response, "Internal server error", 500);
        }
    }
    
    private void handleGetPayment(HttpServletRequest request, HttpServletResponse response, int paymentId)
            throws IOException, SQLException {
        
        Optional<Payment> paymentOpt = paymentDAO.findById(paymentId);
        
        if (!paymentOpt.isPresent()) {
            sendErrorResponse(response, "Payment not found", 404);
            return;
        }
        
        Payment payment = paymentOpt.get();
        
        // Check authorization - managers can see all payments, customers only their own
        if (!canAccessPayment(request, payment)) {
            sendErrorResponse(response, "Access denied", 403);
            return;
        }
        
        sendSuccessResponse(response, payment);
    }
    
    private void handleGetAllPayments(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        
        // This endpoint is for managers only
        if (!isManagerOrAdmin(request)) {
            sendErrorResponse(response, "Access denied", 403);
            return;
        }
        
        // Get pagination parameters
        int page = getIntParameter(request, "page", 1);
        int pageSize = getIntParameter(request, "pageSize", 10);
        
        // Get filters
        String statusFilter = request.getParameter("status");
        String methodFilter = request.getParameter("method");
        String searchQuery = request.getParameter("search");
        
        // Get payments with filters
        var payments = paymentDAO.findAllWithFilters(page, pageSize, statusFilter, methodFilter, 
                                                    null, null, searchQuery, null);
        
        sendSuccessResponse(response, payments);
    }
    
    private void handleCreatePayment(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {
        
        // Only managers can create payments
        if (!isManagerOrAdmin(request)) {
            sendErrorResponse(response, "Access denied", 403);
            return;
        }
        
        // Parse request body
        PaymentRequest paymentRequest = parseRequestBody(request, PaymentRequest.class);
        if (paymentRequest == null) {
            sendErrorResponse(response, "Invalid request body", 400);
            return;
        }
        
        // Validate required fields
        if (paymentRequest.customerId == null || paymentRequest.totalAmount == null ||
            paymentRequest.paymentMethod == null || paymentRequest.paymentStatus == null) {
            sendErrorResponse(response, "Missing required fields", 400);
            return;
        }

        // Get and validate amount
        BigDecimal amount = paymentRequest.getTotalAmountAsBigDecimal();
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            sendErrorResponse(response, "Amount must be greater than 0", 400);
            return;
        }

        if (amount.compareTo(new BigDecimal("100000000")) > 0) {
            sendErrorResponse(response, "Amount cannot exceed 100,000,000 VNĐ", 400);
            return;
        }
        
        // Verify customer exists
        Optional<Customer> customerOpt = customerDAO.findById(paymentRequest.customerId);
        if (!customerOpt.isPresent()) {
            sendErrorResponse(response, "Customer not found", 400);
            return;
        }
        
        // Create payment
        Payment payment = new Payment();
        payment.setCustomerId(paymentRequest.customerId);
        payment.setTotalAmount(amount);
        payment.setSubtotalAmount(amount); // Assuming no tax for manual entries
        payment.setTaxAmount(BigDecimal.ZERO);
        payment.setPaymentMethod(PaymentMethod.valueOf(paymentRequest.paymentMethod));
        payment.setPaymentStatus(PaymentStatus.valueOf(paymentRequest.paymentStatus));
        payment.setNotes(paymentRequest.notes);
        
        // Set payment date
        if (paymentRequest.paymentDate != null) {
            payment.setPaymentDate(Timestamp.valueOf(paymentRequest.paymentDate));
        } else {
            payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));
        }
        
        // Generate reference number if not provided
        if (paymentRequest.referenceNumber != null && !paymentRequest.referenceNumber.trim().isEmpty()) {
            payment.setReferenceNumber(paymentRequest.referenceNumber.trim());
        } else {
            payment.setReferenceNumber(Payment.generateReferenceNumber());
        }
        
        // Save payment
        Payment savedPayment = paymentDAO.save(payment);
        
        sendSuccessResponse(response, savedPayment);
    }
    
    private void handleUpdatePayment(HttpServletRequest request, HttpServletResponse response, int paymentId)
            throws IOException, SQLException {
        
        // Only managers can update payments
        if (!isManagerOrAdmin(request)) {
            sendErrorResponse(response, "Access denied", 403);
            return;
        }
        
        // Get existing payment
        Optional<Payment> existingOpt = paymentDAO.findById(paymentId);
        if (!existingOpt.isPresent()) {
            sendErrorResponse(response, "Payment not found", 404);
            return;
        }
        
        // Parse request body
        PaymentRequest paymentRequest = parseRequestBody(request, PaymentRequest.class);
        if (paymentRequest == null) {
            sendErrorResponse(response, "Invalid request body", 400);
            return;
        }
        
        Payment payment = existingOpt.get();
        
        // Update fields
        if (paymentRequest.paymentStatus != null) {
            payment.setPaymentStatus(PaymentStatus.valueOf(paymentRequest.paymentStatus));
        }
        if (paymentRequest.notes != null) {
            payment.setNotes(paymentRequest.notes);
        }
        if (paymentRequest.paymentDate != null) {
            payment.setPaymentDate(Timestamp.valueOf(paymentRequest.paymentDate));
        }
        
        // Update payment
        paymentDAO.update(payment);
        
        sendSuccessResponse(response, payment);
    }
    
    private void handleUpdatePaymentStatus(HttpServletRequest request, HttpServletResponse response, int paymentId)
            throws IOException, SQLException {
        
        // Only managers can update payment status
        if (!isManagerOrAdmin(request)) {
            sendErrorResponse(response, "Access denied", 403);
            return;
        }
        
        // Parse request body
        StatusUpdateRequest statusRequest = parseRequestBody(request, StatusUpdateRequest.class);
        if (statusRequest == null || statusRequest.status == null) {
            sendErrorResponse(response, "Invalid request body", 400);
            return;
        }
        
        // Get existing payment
        Optional<Payment> existingOpt = paymentDAO.findById(paymentId);
        if (!existingOpt.isPresent()) {
            sendErrorResponse(response, "Payment not found", 404);
            return;
        }
        
        Payment payment = existingOpt.get();
        payment.setPaymentStatus(PaymentStatus.valueOf(statusRequest.status));
        
        // Update payment
        paymentDAO.update(payment);
        
        sendSuccessResponse(response, payment);
    }
    
    // Helper methods and classes will be added in the next part...
    
    private boolean canAccessPayment(HttpServletRequest request, Payment payment) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        if (user != null) {
            // Staff can access all payments
            return true;
        }
        
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer != null) {
            // Customers can only access their own payments
            return payment.getCustomerId().equals(customer.getCustomerId());
        }
        
        return false;
    }
    
    private boolean isManagerOrAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        User user = (User) session.getAttribute("user");
        if (user != null) {
            Integer roleId = user.getRoleId();
            return roleId != null && (roleId == 1 || roleId == 2); // Admin or Manager
        }
        
        return false;
    }
    
    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null) {
            try {
                return Integer.parseInt(paramValue);
            } catch (NumberFormatException e) {
                // Return default value if parsing fails
            }
        }
        return defaultValue;
    }
    
    private <T> T parseRequestBody(HttpServletRequest request, Class<T> clazz) {
        try {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            return gson.fromJson(sb.toString(), clazz);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to parse request body", e);
            return null;
        }
    }
    
    private void sendSuccessResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        ApiResponse apiResponse = new ApiResponse(true, "Success", data);
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(apiResponse));
        out.flush();
    }
    
    private void sendErrorResponse(HttpServletResponse response, String message, int statusCode) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(statusCode);
        
        ApiResponse apiResponse = new ApiResponse(false, message, null);
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(apiResponse));
        out.flush();
    }
    
    // Request/Response classes
    private static class PaymentRequest {
        Integer customerId;
        String totalAmount; // Accept as string to handle formatting
        String paymentMethod;
        String paymentStatus;
        String paymentDate;
        String notes;
        String referenceNumber;

        // Helper method to get BigDecimal amount
        public BigDecimal getTotalAmountAsBigDecimal() {
            if (totalAmount == null || totalAmount.trim().isEmpty()) {
                return BigDecimal.ZERO;
            }
            try {
                // Remove any formatting and convert to BigDecimal
                String cleanAmount = totalAmount.replaceAll("[^\\d]", "");
                return new BigDecimal(cleanAmount);
            } catch (NumberFormatException e) {
                return BigDecimal.ZERO;
            }
        }
    }
    
    private static class StatusUpdateRequest {
        String status;
    }
    
    private static class ApiResponse {
        boolean success;
        String message;
        Object data;
        
        ApiResponse(boolean success, String message, Object data) {
            this.success = success;
            this.message = message;
            this.data = data;
        }
    }
}
