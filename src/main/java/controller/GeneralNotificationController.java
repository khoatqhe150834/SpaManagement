package controller;

import com.google.gson.Gson;
import model.GeneralNotification;
import model.User;
import model.Customer;
import service.NotificationService;

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
 * Controller for general notification system
 * Handles notification display and management for all user roles
 * 
 * @author SpaManagement
 */
@WebServlet({"/notifications", "/notifications/*", "/api/notifications", "/api/notifications/*"})
public class GeneralNotificationController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(GeneralNotificationController.class.getName());
    private final Gson gson = new Gson();
    private final NotificationService notificationService;
    
    public GeneralNotificationController() {
        this.notificationService = new NotificationService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String requestURI = request.getRequestURI();
        
        try {
            if (requestURI.startsWith(request.getContextPath() + "/api/notifications")) {
                handleApiRequest(request, response, session);
            } else {
                handlePageRequest(request, response, session);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in GeneralNotificationController", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "mark_as_read":
                    handleMarkAsRead(request, response, session);
                    break;
                case "mark_as_dismissed":
                    handleMarkAsDismissed(request, response, session);
                    break;
                case "create_notification":
                    handleCreateNotification(request, response, session);
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
    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws ServletException, IOException {
        
        User user = (User) session.getAttribute("user");
        Customer customer = (Customer) session.getAttribute("customer");
        
        if (user == null && customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get filter parameters
        boolean unreadOnly = "unread".equals(request.getParameter("filter"));
        
        List<GeneralNotification> notifications;
        int unreadCount = 0;
        
        if (user != null) {
            // Staff user notifications
            notifications = notificationService.getNotificationsForUser(user.getUserId(), unreadOnly);
            unreadCount = notificationService.getUnreadCountForUser(user.getUserId());
        } else {
            // Customer notifications
            notifications = notificationService.getNotificationsForCustomer(customer.getCustomerId(), unreadOnly);
            unreadCount = notificationService.getUnreadCountForCustomer(customer.getCustomerId());
        }
        
        // Set attributes for JSP
        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
        request.setAttribute("totalCount", notifications.size());
        request.setAttribute("filter", request.getParameter("filter"));
        request.setAttribute("pageTitle", "Thông Báo - Spa Hương Sen");
        
        // Forward to appropriate JSP based on user type
        if (user != null) {
            // Check role for different views
            if (user.getRoleId() == 1 || user.getRoleId() == 2) { // Admin or Manager
                request.getRequestDispatcher("/WEB-INF/view/admin/notifications.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/WEB-INF/view/staff/notifications.jsp").forward(request, response);
            }
        } else {
            request.getRequestDispatcher("/WEB-INF/view/customer/notifications.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle API requests (AJAX/JSON responses)
     */
    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        User user = (User) session.getAttribute("user");
        Customer customer = (Customer) session.getAttribute("customer");
        
        if (user == null && customer == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Authentication required\"}");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        PrintWriter out = response.getWriter();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                handleGetNotificationsApi(request, response, user, customer, out);
            } else if (pathInfo.equals("/count")) {
                handleGetNotificationCountApi(request, response, user, customer, out);
            } else if (pathInfo.startsWith("/")) {
                // Handle specific notification ID
                try {
                    int notificationId = Integer.parseInt(pathInfo.substring(1));
                    handleGetNotificationDetailsApi(request, response, user, customer, out, notificationId);
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
            User user, Customer customer, PrintWriter out) {
        
        boolean unreadOnly = "true".equals(request.getParameter("unreadOnly"));
        
        List<GeneralNotification> notifications;
        if (user != null) {
            notifications = notificationService.getNotificationsForUser(user.getUserId(), unreadOnly);
        } else {
            notifications = notificationService.getNotificationsForCustomer(customer.getCustomerId(), unreadOnly);
        }
        
        ApiResponse<List<GeneralNotification>> apiResponse = new ApiResponse<>();
        apiResponse.setSuccess(true);
        apiResponse.setData(notifications);
        apiResponse.setMessage("Notifications retrieved successfully");
        
        out.write(gson.toJson(apiResponse));
    }
    
    /**
     * Handle get notification count API
     */
    private void handleGetNotificationCountApi(HttpServletRequest request, HttpServletResponse response, 
            User user, Customer customer, PrintWriter out) {
        
        boolean unreadOnly = "true".equals(request.getParameter("unreadOnly"));
        
        int count;
        if (user != null) {
            if (unreadOnly) {
                count = notificationService.getUnreadCountForUser(user.getUserId());
            } else {
                count = notificationService.getNotificationsForUser(user.getUserId(), false).size();
            }
        } else {
            if (unreadOnly) {
                count = notificationService.getUnreadCountForCustomer(customer.getCustomerId());
            } else {
                count = notificationService.getNotificationsForCustomer(customer.getCustomerId(), false).size();
            }
        }
        
        ApiResponse<Integer> apiResponse = new ApiResponse<>();
        apiResponse.setSuccess(true);
        apiResponse.setData(count);
        apiResponse.setMessage("Count retrieved successfully");
        
        out.write(gson.toJson(apiResponse));
    }
    
    /**
     * Handle get notification details API
     */
    private void handleGetNotificationDetailsApi(HttpServletRequest request, HttpServletResponse response, 
            User user, Customer customer, PrintWriter out, int notificationId) {
        
        GeneralNotification notification = notificationService.getNotificationById(notificationId);
        
        if (notification == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.write("{\"error\": \"Notification not found\"}");
            return;
        }
        
        ApiResponse<GeneralNotification> apiResponse = new ApiResponse<>();
        apiResponse.setSuccess(true);
        apiResponse.setData(notification);
        apiResponse.setMessage("Notification details retrieved successfully");
        
        out.write(gson.toJson(apiResponse));
    }
    
    /**
     * Handle mark as read
     */
    private void handleMarkAsRead(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws IOException {
        
        int notificationId = getIntParameter(request, "notificationId", 0);
        if (notificationId == 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid notification ID");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        Customer customer = (Customer) session.getAttribute("customer");
        
        boolean success = false;
        if (user != null) {
            success = notificationService.markAsReadForUser(notificationId, user.getUserId());
        } else if (customer != null) {
            success = notificationService.markAsReadForCustomer(notificationId, customer.getCustomerId());
        }
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        ApiResponse<Boolean> apiResponse = new ApiResponse<>();
        apiResponse.setSuccess(success);
        apiResponse.setData(success);
        apiResponse.setMessage(success ? "Marked as read" : "Failed to mark as read");
        
        out.write(gson.toJson(apiResponse));
    }
    
    /**
     * Handle mark as dismissed
     */
    private void handleMarkAsDismissed(HttpServletRequest request, HttpServletResponse response, HttpSession session) 
            throws IOException {
        
        int notificationId = getIntParameter(request, "notificationId", 0);
        if (notificationId == 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid notification ID");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        Customer customer = (Customer) session.getAttribute("customer");
        
        boolean success = false;
        if (user != null) {
            success = notificationService.markAsDismissedForUser(notificationId, user.getUserId());
        } else if (customer != null) {
            success = notificationService.markAsDismissedForCustomer(notificationId, customer.getCustomerId());
        }
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        ApiResponse<Boolean> apiResponse = new ApiResponse<>();
        apiResponse.setSuccess(success);
        apiResponse.setData(success);
        apiResponse.setMessage(success ? "Marked as dismissed" : "Failed to mark as dismissed");
        
        out.write(gson.toJson(apiResponse));
    }

    /**
     * Handle create notification (admin only)
     */
    private void handleCreateNotification(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {

        User user = (User) session.getAttribute("user");

        // Check if user is admin or manager
        if (user == null || (user.getRoleId() != 1 && user.getRoleId() != 2)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Insufficient privileges");
            return;
        }

        String title = request.getParameter("title");
        String message = request.getParameter("message");
        String notificationType = request.getParameter("notificationType");
        String priority = request.getParameter("priority");
        String targetType = request.getParameter("targetType");

        if (title == null || title.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Title and message are required");
            return;
        }

        boolean success = false;

        try {
            switch (targetType != null ? targetType : "ALL_USERS") {
                case "ALL_USERS":
                    success = notificationService.createSystemAnnouncement(title, message, priority, user.getUserId());
                    break;
                case "ROLE_BASED":
                    String[] roleIdStrings = request.getParameterValues("roleIds");
                    if (roleIdStrings != null && roleIdStrings.length > 0) {
                        List<Integer> roleIds = new java.util.ArrayList<>();
                        for (String roleIdStr : roleIdStrings) {
                            try {
                                roleIds.add(Integer.parseInt(roleIdStr));
                            } catch (NumberFormatException e) {
                                LOGGER.warning("Invalid role ID: " + roleIdStr);
                            }
                        }
                        success = notificationService.createRoleBasedNotification(title, message,
                            notificationType, priority, roleIds, user.getUserId());
                    }
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid target type");
                    return;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating notification", e);
            success = false;
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        ApiResponse<Boolean> apiResponse = new ApiResponse<>();
        apiResponse.setSuccess(success);
        apiResponse.setData(success);
        apiResponse.setMessage(success ? "Notification created successfully" : "Failed to create notification");

        out.write(gson.toJson(apiResponse));
    }

    /**
     * Get integer parameter with default value
     */
    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
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
