package controller.booking;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Customer;
import model.User;

@WebServlet(name = "BookingCancelServlet", urlPatterns = {"/customer/cancel-booking/*", "/manager/cancel-booking/*"})
public class BookingCancelServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BookingCancelServlet.class.getName());
    
    private BookingDAO bookingDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        super.init();
        bookingDAO = new BookingDAO();
        
        // Configure Gson with proper serializers
        gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) -> 
                context.serialize(src.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)))
            .setPrettyPrinting()
            .create();
        
        LOGGER.info("BookingCancelServlet initialized successfully");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        LOGGER.info("=== BookingCancelServlet doPost START ===");
        
        // Set response headers early
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");
        Integer userRoleId = (Integer) session.getAttribute("userRoleId");

        // Also check for user and customer objects in session (set by filters)
        User user = (User) session.getAttribute("user");
        Customer customer = (Customer) session.getAttribute("customer");

        // Check request attributes as well (set by AuthenticationFilter)
        if (userRoleId == null) {
            userRoleId = (Integer) request.getAttribute("userRoleId");
        }

        LOGGER.info("Session info - customerId: " + customerId + ", userRoleId: " + userRoleId +
                   ", user: " + (user != null ? user.getUserId() : "null") +
                   ", customer: " + (customer != null ? customer.getCustomerId() : "null"));

        // Check authorization - user must be either a customer or staff member
        if (customerId == null && userRoleId == null && user == null && customer == null) {
            LOGGER.warning("Unauthorized access attempt - no valid session found");
            sendErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED, "Không có quyền truy cập");
            return;
        }

        // Set userRoleId if not already set (for customers)
        if (userRoleId == null && customer != null) {
            userRoleId = customer.getRoleId();
        }
        if (userRoleId == null && user != null) {
            userRoleId = user.getRoleId();
        }

        // Set customerId if not already set (for customers)
        if (customerId == null && customer != null) {
            customerId = customer.getCustomerId();
        }
        
        // Extract booking ID from URL path
        String pathInfo = request.getPathInfo();
        LOGGER.info("Path info: " + pathInfo);
        
        if (pathInfo == null || pathInfo.length() <= 1) {
            LOGGER.warning("Missing booking ID in URL path");
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID lịch hẹn");
            return;
        }
        
        try {
            // Parse booking ID
            Integer bookingId = Integer.parseInt(pathInfo.substring(1));
            LOGGER.info("Processing cancellation for booking ID: " + bookingId);
            
            // Get cancellation reason
            String cancellationReason = request.getParameter("reason");
            LOGGER.info("Cancellation reason: " + (cancellationReason != null ? cancellationReason : "No reason provided"));
            
            // Process the cancellation
            processCancellation(response, customerId, userRoleId, bookingId, cancellationReason);
            
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid booking ID format: " + pathInfo);
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "ID lịch hẹn không hợp lệ");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in BookingCancelServlet", e);
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Lỗi hệ thống: " + e.getMessage());
        }
        
        LOGGER.info("=== BookingCancelServlet doPost END ===");
    }
    
    private void processCancellation(HttpServletResponse response, Integer customerId, Integer userRoleId, 
                                   Integer bookingId, String cancellationReason) throws IOException {
        
        try {
            LOGGER.info("Starting cancellation process for booking " + bookingId);
            
            // Get booking details
            Optional<Booking> bookingOpt = bookingDAO.findById(bookingId);
            if (bookingOpt.isEmpty()) {
                LOGGER.warning("Booking not found: " + bookingId);
                sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy lịch hẹn");
                return;
            }
            
            Booking booking = bookingOpt.get();
            LOGGER.info("Found booking: " + booking.getBookingId() + " for customer: " + booking.getCustomerId() + 
                       " with status: " + booking.getBookingStatus());
            
            // Check access permissions
            boolean hasAccess = false;
            String accessType = "";
            
            if (customerId != null && booking.getCustomerId().equals(customerId)) {
                hasAccess = true;
                accessType = "customer";
            } else if (userRoleId != null && userRoleId >= 2) { // Manager or admin
                hasAccess = true;
                accessType = "manager";
            }
            
            LOGGER.info("Access check - hasAccess: " + hasAccess + ", accessType: " + accessType);
            
            if (!hasAccess) {
                LOGGER.warning("Access denied for booking " + bookingId + 
                              " - customer: " + customerId + ", userRole: " + userRoleId);
                sendErrorResponse(response, HttpServletResponse.SC_FORBIDDEN, 
                                 "Bạn không có quyền hủy lịch hẹn này");
                return;
            }
            
            // Check if booking can be cancelled
            if (!canBeCancelled(booking.getBookingStatus())) {
                LOGGER.warning("Booking " + bookingId + " cannot be cancelled. Status: " + booking.getBookingStatus());
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, 
                                 "Lịch hẹn này không thể hủy. Trạng thái hiện tại: " + 
                                 booking.getBookingStatus().getDisplayName());
                return;
            }
            
            // Store original status for logging
            Booking.BookingStatus originalStatus = booking.getBookingStatus();
            
            // Update booking status to CANCELLED
            booking.setBookingStatus(Booking.BookingStatus.CANCELLED);
            
            // Add cancellation note
            String currentNotes = booking.getBookingNotes() != null ? booking.getBookingNotes() : "";
            String cancellationNote = "\n[" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) + "] " +
                                    "Lịch hẹn bị hủy bởi " + accessType;
            
            if (cancellationReason != null && !cancellationReason.trim().isEmpty()) {
                cancellationNote += ". Lý do: " + cancellationReason.trim();
            }
            
            booking.setBookingNotes(currentNotes + cancellationNote);
            
            LOGGER.info("Updating booking status from " + originalStatus + " to CANCELLED");
            
            // Save the updated booking
            bookingDAO.update(booking);
            
            LOGGER.info("Successfully cancelled booking " + bookingId);
            
            // Prepare success response
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", true);
            responseData.put("message", "Hủy lịch hẹn thành công!");
            responseData.put("bookingId", bookingId);
            responseData.put("originalStatus", originalStatus.getDisplayName());
            responseData.put("newStatus", "Đã hủy");
            responseData.put("cancelledBy", accessType);
            responseData.put("cancelledAt", LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
            
            if (cancellationReason != null && !cancellationReason.trim().isEmpty()) {
                responseData.put("reason", cancellationReason.trim());
            }
            
            // Additional booking info for confirmation
            responseData.put("serviceName", booking.getService() != null ? 
                           booking.getService().getName(): "N/A");
            responseData.put("appointmentDate", booking.getAppointmentDate().toString());
            responseData.put("appointmentTime", booking.getAppointmentTime().toString());
            
            sendSuccessResponse(response, responseData);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during cancellation", e);
            
            // Handle specific database errors
            String userMessage = getUserFriendlyErrorMessage(e);
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, userMessage);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during cancellation", e);
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Lỗi không mong muốn: " + e.getMessage());
        }
    }
    
    private boolean canBeCancelled(Booking.BookingStatus status) {
        // Only scheduled and confirmed bookings can be cancelled
        return status == Booking.BookingStatus.SCHEDULED || 
               status == Booking.BookingStatus.CONFIRMED;
    }
    
    private String getUserFriendlyErrorMessage(SQLException e) {
        int errorCode = e.getErrorCode();
        String errorMessage = e.getMessage().toLowerCase();
        
        LOGGER.info("SQL Error - Code: " + errorCode + ", Message: " + errorMessage);
        
        // Handle specific SQL errors
        switch (errorCode) {
            case 1452: // Foreign key constraint fails
                return "Lỗi ràng buộc dữ liệu. Vui lòng liên hệ hỗ trợ.";
            case 1048: // Column cannot be null
                return "Thiếu thông tin bắt buộc trong cơ sở dữ liệu.";
            case 1054: // Unknown column
                return "Lỗi cấu trúc cơ sở dữ liệu. Vui lòng liên hệ hỗ trợ.";
            default:
                return "Lỗi cơ sở dữ liệu. Vui lòng thử lại sau hoặc liên hệ hỗ trợ.";
        }
    }
    
    private void sendSuccessResponse(HttpServletResponse response, Map<String, Object> data) throws IOException {
        LOGGER.info("Sending success response");
        
        response.setStatus(HttpServletResponse.SC_OK);
        
        try (PrintWriter out = response.getWriter()) {
            String jsonResponse = gson.toJson(data);
            LOGGER.info("Success response JSON: " + jsonResponse);
            out.print(jsonResponse);
            out.flush();
        }
    }
    
    private void sendErrorResponse(HttpServletResponse response, int statusCode, String message) throws IOException {
        LOGGER.warning("Sending error response - Status: " + statusCode + ", Message: " + message);
        
        Map<String, Object> errorData = new HashMap<>();
        errorData.put("success", false);
        errorData.put("error", message);
        errorData.put("statusCode", statusCode);
        errorData.put("timestamp", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
        
        response.setStatus(statusCode);
        
        try (PrintWriter out = response.getWriter()) {
            String jsonResponse = gson.toJson(errorData);
            LOGGER.info("Error response JSON: " + jsonResponse);
            out.print(jsonResponse);
            out.flush();
        }
    }
}