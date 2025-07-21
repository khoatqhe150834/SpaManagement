package controller;

import com.google.gson.Gson;
import model.PaymentSchedulingNotification;
import model.User;
import service.PaymentSchedulingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Controller for payment scheduling notifications
 * Handles manager notifications for payment-to-scheduling workflow
 * 
 * @author SpaManagement
 */
@WebServlet({"/manager/payment-notifications", "/manager/payment-notifications/*", 
             "/api/manager/payment-notifications", "/api/manager/payment-notifications/*"})
public class PaymentSchedulingController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(PaymentSchedulingController.class.getName());
    private final Gson gson = new Gson();
    private final PaymentSchedulingService paymentSchedulingService;
    
    public PaymentSchedulingController() {
        this.paymentSchedulingService = new PaymentSchedulingService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check authorization - only managers and admins
        if (user == null || (user.getRoleId() != 1 && user.getRoleId() != 2)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        String requestURI = request.getRequestURI();
        
        try {
            if (requestURI.startsWith(request.getContextPath() + "/api/manager/payment-notifications")) {
                handleApiRequest(request, response, user);
            } else {
                handlePageRequest(request, response, user);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in PaymentSchedulingController", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check authorization - only managers and admins
        if (user == null || (user.getRoleId() != 1 && user.getRoleId() != 2)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "mark_as_read":
                    handleMarkAsRead(request, response, user);
                    break;
                case "mark_as_acknowledged":
                    handleMarkAsAcknowledged(request, response, user);
                    break;
                case "create_booking":
                    handleCreateBooking(request, response, user);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in POST request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }
    
    /**
     * Handle page requests (JSP views)
     */
    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        // Get filter parameters
        boolean unreadOnly = "unread".equals(request.getParameter("filter"));
        
        List<PaymentSchedulingNotification> notifications = 
            paymentSchedulingService.getNotificationsForUser(user.getUserId(), unreadOnly);
        
        int unreadCount = paymentSchedulingService.getUnreadCountForUser(user.getUserId());
        int unacknowledgedCount = paymentSchedulingService.getUnacknowledgedCountForUser(user.getUserId());
        
        // Set attributes for JSP
        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
        request.setAttribute("unacknowledgedCount", unacknowledgedCount);
        request.setAttribute("totalCount", notifications.size());
        request.setAttribute("filter", request.getParameter("filter"));
        request.setAttribute("pageTitle", "Thông Báo Thanh Toán - Spa Hương Sen");
        
        // Forward to JSP
        request.getRequestDispatcher("/WEB-INF/view/manager/payment-notifications.jsp").forward(request, response);
    }
    
    /**
     * Handle API requests (AJAX/JSON responses)
     */
    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String pathInfo = request.getPathInfo();
        PrintWriter out = response.getWriter();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                handleGetNotificationsApi(request, response, user, out);
            } else if (pathInfo.equals("/count")) {
                handleGetNotificationCountApi(request, response, user, out);
            } else if (pathInfo.equals("/unacknowledged-count")) {
                handleGetUnacknowledgedCountApi(request, response, user, out);
            } else if (pathInfo.startsWith("/")) {
                // Handle specific notification ID
                try {
                    int notificationId = Integer.parseInt(pathInfo.substring(1));
                    handleGetNotificationDetailsApi(request, response, user, out, notificationId);
                } catch (NumberFormatException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.write("{\"error\": \"Invalid notification ID\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.write("{\"error\": \"API endpoint not found\"}");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in API request", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"Internal server error\"}");
        }
    }
    
    /**
     * Handle get notifications API
     */
    private void handleGetNotificationsApi(HttpServletRequest request, HttpServletResponse response, 
            User user, PrintWriter out) {
        
        boolean unreadOnly = "true".equals(request.getParameter("unreadOnly"));
        
        List<PaymentSchedulingNotification> notifications = 
            paymentSchedulingService.getNotificationsForUser(user.getUserId(), unreadOnly);
        
        ApiResponse<List<PaymentSchedulingNotification>> apiResponse = new ApiResponse<>();
        apiResponse.setSuccess(true);
        apiResponse.setData(notifications);
        apiResponse.setMessage("Notifications retrieved successfully");
        
        out.write(gson.toJson(apiResponse));
    }
    
    /**
     * Handle get notification count API
     */
    private void handleGetNotificationCountApi(HttpServletRequest request, HttpServletResponse response, 
            User user, PrintWriter out) {
        
        boolean unreadOnly = "true".equals(request.getParameter("unreadOnly"));
        
        int count;
        if (unreadOnly) {
            count = paymentSchedulingService.getUnreadCountForUser(user.getUserId());
        } else {
            count = paymentSchedulingService.getNotificationsForUser(user.getUserId(), false).size();
        }
        
        ApiResponse<Integer> apiResponse = new ApiResponse<>();
        apiResponse.setSuccess(true);
        apiResponse.setData(count);
        apiResponse.setMessage("Count retrieved successfully");
        
        out.write(gson.toJson(apiResponse));
    }
    
    /**
     * Handle get unacknowledged count API
     */
    private void handleGetUnacknowledgedCountApi(HttpServletRequest request, HttpServletResponse response, 
            User user, PrintWriter out) {
        
        int count = paymentSchedulingService.getUnacknowledgedCountForUser(user.getUserId());
        
        ApiResponse<Integer> apiResponse = new ApiResponse<>();
        apiResponse.setSuccess(true);
        apiResponse.setData(count);
        apiResponse.setMessage("Unacknowledged count retrieved successfully");
        
        out.write(gson.toJson(apiResponse));
    }
    
    /**
     * Handle get notification details API
     */
    private void handleGetNotificationDetailsApi(HttpServletRequest request, HttpServletResponse response, 
            User user, PrintWriter out, int notificationId) {
        
        PaymentSchedulingNotification notification = paymentSchedulingService.getNotificationById(notificationId);
        
        if (notification == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.write("{\"error\": \"Notification not found\"}");
            return;
        }
        
        // Check if user has access to this notification
        if (!notification.getRecipientUserId().equals(user.getUserId())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.write("{\"error\": \"Access denied\"}");
            return;
        }
        
        ApiResponse<PaymentSchedulingNotification> apiResponse = new ApiResponse<>();
        apiResponse.setSuccess(true);
        apiResponse.setData(notification);
        apiResponse.setMessage("Notification details retrieved successfully");
        
        out.write(gson.toJson(apiResponse));
    }
    
    /**
     * Handle mark as read
     */
    private void handleMarkAsRead(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        int notificationId = getIntParameter(request, "notificationId", 0);
        if (notificationId == 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid notification ID");
            return;
        }
        
        boolean success = paymentSchedulingService.markAsRead(notificationId);
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        ApiResponse<Boolean> apiResponse = new ApiResponse<>();
        apiResponse.setSuccess(success);
        apiResponse.setData(success);
        apiResponse.setMessage(success ? "Marked as read" : "Failed to mark as read");
        
        out.write(gson.toJson(apiResponse));
    }
    
    /**
     * Handle mark as acknowledged
     */
    private void handleMarkAsAcknowledged(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        int notificationId = getIntParameter(request, "notificationId", 0);
        if (notificationId == 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid notification ID");
            return;
        }
        
        boolean success = paymentSchedulingService.markAsAcknowledged(notificationId, user.getUserId());
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        ApiResponse<Boolean> apiResponse = new ApiResponse<>();
        apiResponse.setSuccess(success);
        apiResponse.setData(success);
        apiResponse.setMessage(success ? "Marked as acknowledged" : "Failed to mark as acknowledged");
        
        out.write(gson.toJson(apiResponse));
    }
    
    /**
     * Handle create booking from payment item
     */
    private void handleCreateBooking(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        int paymentItemId = getIntParameter(request, "paymentItemId", 0);
        int therapistUserId = getIntParameter(request, "therapistUserId", 0);
        int roomId = getIntParameter(request, "roomId", 0);
        Integer bedId = getIntParameter(request, "bedId", null);
        String appointmentDate = request.getParameter("appointmentDate");
        String appointmentTime = request.getParameter("appointmentTime");
        String notes = request.getParameter("notes");
        
        if (paymentItemId == 0 || therapistUserId == 0 || roomId == 0 || 
            appointmentDate == null || appointmentTime == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }
        
        boolean success = paymentSchedulingService.createBookingFromPaymentItem(
            paymentItemId, therapistUserId, appointmentDate, appointmentTime, roomId, bedId, notes);
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        ApiResponse<Boolean> apiResponse = new ApiResponse<>();
        apiResponse.setSuccess(success);
        apiResponse.setData(success);
        apiResponse.setMessage(success ? "Booking created successfully" : "Failed to create booking");
        
        out.write(gson.toJson(apiResponse));
    }
    
    /**
     * Get integer parameter with default value
     */
    private Integer getIntParameter(HttpServletRequest request, String paramName, Integer defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try {
                return Integer.parseInt(paramValue);
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid integer parameter " + paramName + ": " + paramValue);
            }
        }
        return defaultValue;
    }
    
    /**
     * API Response wrapper class
     */
    private static class ApiResponse<T> {
        private boolean success;
        private T data;
        private String message;
        
        // Getters and setters
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        public T getData() { return data; }
        public void setData(T data) { this.data = data; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
    }
}
