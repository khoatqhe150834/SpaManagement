package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import com.google.gson.JsonDeserializer;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import dao.CustomerDAO;
import dao.PaymentDAO;
import dao.PaymentItemDAO;
import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;
import model.Payment;
import model.Payment.PaymentMethod;
import model.Payment.PaymentStatus;
import model.PaymentItem;
import model.Service;
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
    private final PaymentItemDAO paymentItemDAO;
    private final CustomerDAO customerDAO;
    private final ServiceDAO serviceDAO;
    private final Gson gson;

    public PaymentApiController() {
        this.paymentDAO = new PaymentDAO();
        this.paymentItemDAO = new PaymentItemDAO();
        this.customerDAO = new CustomerDAO();
        this.serviceDAO = new ServiceDAO();
        this.gson = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd HH:mm:ss")
            .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) -> 
                context.serialize(src.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))))
            .registerTypeAdapter(LocalDateTime.class, (JsonDeserializer<LocalDateTime>) (json, typeOfT, context) -> 
                LocalDateTime.parse(json.getAsString(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")))
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
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in PaymentApiController POST", e);
            sendErrorResponse(response, "Database error: " + e.getMessage(), 500);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in PaymentApiController POST", e);
            sendErrorResponse(response, "Internal server error: " + e.getMessage(), 500);
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
        
        LOGGER.info("=== CREATE PAYMENT REQUEST ===");
        LOGGER.info("Request method: " + request.getMethod());
        LOGGER.info("Request URI: " + request.getRequestURI());
        LOGGER.info("Content type: " + request.getContentType());
        
        // Only managers can create payments
        if (!isManagerOrAdmin(request)) {
            LOGGER.warning("Access denied - user is not manager or admin");
            sendErrorResponse(response, "Access denied", 403);
            return;
        }
        
        // Parse request body
        PaymentRequest paymentRequest;
        try {
            paymentRequest = parseRequestBody(request, PaymentRequest.class);
            if (paymentRequest == null) {
                LOGGER.severe("Failed to parse request body - returned null");
                sendErrorResponse(response, "Invalid request body - could not parse JSON", 400);
                return;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Exception while parsing request body", e);
            sendErrorResponse(response, "Error parsing request body: " + e.getMessage(), 400);
            return;
        }
        
        LOGGER.info("Parsed payment request: customerId=" + paymentRequest.customerId + 
                   ", totalAmount=" + paymentRequest.totalAmount + 
                   ", paymentMethod=" + paymentRequest.paymentMethod + 
                   ", paymentStatus=" + paymentRequest.paymentStatus);
        
        // Validate required fields
        if (paymentRequest.customerId == null) {
            sendErrorResponse(response, "Missing required field: customerId", 400);
            return;
        }
        if (paymentRequest.totalAmount == null || paymentRequest.totalAmount.trim().isEmpty()) {
            sendErrorResponse(response, "Missing required field: totalAmount", 400);
            return;
        }
        if (paymentRequest.paymentMethod == null || paymentRequest.paymentMethod.trim().isEmpty()) {
            sendErrorResponse(response, "Missing required field: paymentMethod", 400);
            return;
        }
        // Payment status is automatically set to PAID for new payments
        // No validation needed

        // Get and validate amount
        BigDecimal amount;
        try {
            amount = paymentRequest.getTotalAmountAsBigDecimal();
            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                sendErrorResponse(response, "Amount must be greater than 0", 400);
                return;
            }

            if (amount.compareTo(new BigDecimal("100000000")) > 0) {
                sendErrorResponse(response, "Amount cannot exceed 100,000,000 VNĐ", 400);
                return;
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Invalid amount format: " + paymentRequest.totalAmount, e);
            sendErrorResponse(response, "Invalid amount format", 400);
            return;
        }
        
        // Verify customer exists
        Optional<Customer> customerOpt;
        customerOpt = customerDAO.findById(paymentRequest.customerId);
        if (!customerOpt.isPresent()) {
            sendErrorResponse(response, "Customer not found with ID: " + paymentRequest.customerId, 400);
            return;
        }
        
        // Get subtotal and tax amounts
        BigDecimal subtotalAmount = paymentRequest.getSubtotalAmountAsBigDecimal();
        BigDecimal taxAmount = paymentRequest.getTaxAmountAsBigDecimal();

        // If subtotal is not provided, use total amount
        if (subtotalAmount.compareTo(BigDecimal.ZERO) == 0) {
            subtotalAmount = amount;
        }

        // Create payment
        Payment payment = new Payment();
        payment.setCustomerId(paymentRequest.customerId);
        payment.setTotalAmount(amount);
        payment.setSubtotalAmount(subtotalAmount);
        payment.setTaxAmount(taxAmount);
        
        // Validate and set payment method
        try {
            payment.setPaymentMethod(PaymentMethod.valueOf(paymentRequest.paymentMethod.toUpperCase()));
        } catch (IllegalArgumentException e) {
            sendErrorResponse(response, "Invalid payment method: " + paymentRequest.paymentMethod, 400);
            return;
        }
        
        // Always set payment status to PAID for new payments
        payment.setPaymentStatus(PaymentStatus.PAID);
        
        payment.setNotes(paymentRequest.notes);

        // Always set payment date to current time
        payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));

        // Set transaction date to current time
        payment.setTransactionDate(new Timestamp(System.currentTimeMillis()));

        // Always generate a new reference number automatically
        String timestamp = String.valueOf(System.currentTimeMillis()).substring(8);
        String random = String.valueOf((int)(Math.random() * 9000) + 1000);
        payment.setReferenceNumber("SPA" + timestamp + random);

        // Save payment
        Payment savedPayment;
        try {
            LOGGER.info("Attempting to save payment...");
            savedPayment = paymentDAO.save(payment);
            LOGGER.info("Payment saved successfully with ID: " + savedPayment.getPaymentId());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error while saving payment: " + e.getSQLState() + " - " + e.getErrorCode(), e);
            sendErrorResponse(response, "Database error: " + e.getMessage(), 500);
            return;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error while saving payment", e);
            sendErrorResponse(response, "Error saving payment: " + e.getMessage(), 500);
            return;
        }

        // Create payment items if provided
        if (paymentRequest.paymentItems != null && !paymentRequest.paymentItems.isEmpty()) {
            List<PaymentItem> paymentItems = new ArrayList<>();

            for (PaymentItemRequest itemRequest : paymentRequest.paymentItems) {
                try {
                    // Validate service exists
                    Optional<Service> serviceOpt = serviceDAO.findById(itemRequest.serviceId);
                    if (!serviceOpt.isPresent()) {
                        LOGGER.warning("Service not found: " + itemRequest.serviceId);
                        continue;
                    }

                    PaymentItem paymentItem = new PaymentItem();
                    paymentItem.setPaymentId(savedPayment.getPaymentId());
                    paymentItem.setServiceId(itemRequest.serviceId);
                    paymentItem.setQuantity(itemRequest.quantity != null ? itemRequest.quantity : 1);
                    paymentItem.setUnitPrice(itemRequest.getUnitPriceAsBigDecimal());
                    paymentItem.setTotalPrice(itemRequest.getTotalPriceAsBigDecimal());
                    paymentItem.setServiceDuration(itemRequest.serviceDuration != null ? itemRequest.serviceDuration : 0);

                    paymentItems.add(paymentItem);
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Error processing payment item: " + itemRequest.serviceId, e);
                    continue;
                }
            }

            // Save payment items
            if (!paymentItems.isEmpty()) {
                try {
                    paymentItemDAO.saveAll(paymentItems);
                    LOGGER.info("Saved " + paymentItems.size() + " payment items");
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Database error while saving payment items", e);
                    // Don't fail the entire payment creation, just log the error
                    LOGGER.warning("Payment created but payment items failed to save");
                }
            }
        }

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

        // Update payment fields
        if (paymentRequest.paymentStatus != null) {
            payment.setPaymentStatus(PaymentStatus.valueOf(paymentRequest.paymentStatus));
        }
        if (paymentRequest.paymentMethod != null) {
            payment.setPaymentMethod(PaymentMethod.valueOf(paymentRequest.paymentMethod));
        }
        if (paymentRequest.notes != null) {
            payment.setNotes(paymentRequest.notes);
        }
        if (paymentRequest.paymentDate != null && !paymentRequest.paymentDate.trim().isEmpty()) {
            try {
                payment.setPaymentDate(Timestamp.valueOf(paymentRequest.paymentDate));
            } catch (IllegalArgumentException e) {
                // Keep existing date if invalid format
                LOGGER.warning("Invalid date format: " + paymentRequest.paymentDate);
            }
        }

        // Update amounts if provided
        BigDecimal totalAmount = paymentRequest.getTotalAmountAsBigDecimal();
        BigDecimal subtotalAmount = paymentRequest.getSubtotalAmountAsBigDecimal();
        BigDecimal taxAmount = paymentRequest.getTaxAmountAsBigDecimal();

        if (totalAmount.compareTo(BigDecimal.ZERO) > 0) {
            payment.setTotalAmount(totalAmount);
        }
        if (subtotalAmount.compareTo(BigDecimal.ZERO) > 0) {
            payment.setSubtotalAmount(subtotalAmount);
        }
        payment.setTaxAmount(taxAmount); // Tax can be zero

        // Update payment
        paymentDAO.update(payment);

        // Handle payment items if provided
        if (paymentRequest.paymentItems != null) {
            // Delete existing payment items
            paymentItemDAO.deleteByPaymentId(paymentId);

            // Create new payment items
            List<PaymentItem> paymentItems = new ArrayList<>();
            for (PaymentItemRequest itemRequest : paymentRequest.paymentItems) {
                // Validate service exists
                Optional<Service> serviceOpt = serviceDAO.findById(itemRequest.serviceId);
                if (!serviceOpt.isPresent()) {
                    LOGGER.warning("Service not found during update: " + itemRequest.serviceId);
                    continue;
                }

                PaymentItem paymentItem = new PaymentItem();
                paymentItem.setPaymentId(paymentId);
                paymentItem.setServiceId(itemRequest.serviceId);
                paymentItem.setQuantity(itemRequest.quantity != null ? itemRequest.quantity : 1);
                paymentItem.setUnitPrice(itemRequest.getUnitPriceAsBigDecimal());
                paymentItem.setTotalPrice(itemRequest.getTotalPriceAsBigDecimal());
                paymentItem.setServiceDuration(itemRequest.serviceDuration != null ? itemRequest.serviceDuration : 0);

                paymentItems.add(paymentItem);
            }

            // Save new payment items
            if (!paymentItems.isEmpty()) {
                paymentItemDAO.saveAll(paymentItems);
            }
        }

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
            String requestBody = sb.toString();
            LOGGER.info("Request body: " + requestBody);
            
            if (requestBody.trim().isEmpty()) {
                LOGGER.warning("Request body is empty");
                return null;
            }
            
            T result = gson.fromJson(requestBody, clazz);
            LOGGER.info("Successfully parsed request body to " + clazz.getSimpleName());
            return result;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to parse request body to " + clazz.getSimpleName(), e);
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
        String subtotalAmount;
        String taxAmount;
        String paymentMethod;
        String paymentStatus;
        String paymentDate;
        String notes;
        String referenceNumber;
        List<PaymentItemRequest> paymentItems;

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

        public BigDecimal getSubtotalAmountAsBigDecimal() {
            if (subtotalAmount == null || subtotalAmount.trim().isEmpty()) {
                return BigDecimal.ZERO;
            }
            try {
                String cleanAmount = subtotalAmount.replaceAll("[^\\d]", "");
                return new BigDecimal(cleanAmount);
            } catch (NumberFormatException e) {
                return BigDecimal.ZERO;
            }
        }

        public BigDecimal getTaxAmountAsBigDecimal() {
            if (taxAmount == null || taxAmount.trim().isEmpty()) {
                return BigDecimal.ZERO;
            }
            try {
                String cleanAmount = taxAmount.replaceAll("[^\\d]", "");
                return new BigDecimal(cleanAmount);
            } catch (NumberFormatException e) {
                return BigDecimal.ZERO;
            }
        }
    }

    private static class PaymentItemRequest {
        Integer serviceId;
        Integer quantity;
        String unitPrice;
        String totalPrice;
        Integer serviceDuration;

        public BigDecimal getUnitPriceAsBigDecimal() {
            if (unitPrice == null || unitPrice.trim().isEmpty()) {
                return BigDecimal.ZERO;
            }
            try {
                String cleanAmount = unitPrice.replaceAll("[^\\d]", "");
                return new BigDecimal(cleanAmount);
            } catch (NumberFormatException e) {
                return BigDecimal.ZERO;
            }
        }

        public BigDecimal getTotalPriceAsBigDecimal() {
            if (totalPrice == null || totalPrice.trim().isEmpty()) {
                return BigDecimal.ZERO;
            }
            try {
                String cleanAmount = totalPrice.replaceAll("[^\\d]", "");
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
