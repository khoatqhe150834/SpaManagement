package controller.booking;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.JsonObject;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;

@WebServlet(name = "BookingCancelServlet", urlPatterns = {"/customer/booking/cancel/*"})
public class BookingCancelServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BookingCancelServlet.class.getName());
    private BookingDAO bookingDAO;
    
    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");
        
        if (customerId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            sendJsonError(response, "Unauthorized access");
            return;
        }
        
        // Extract booking ID from URL path
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            sendJsonError(response, "Booking ID is required");
            return;
        }
        
        try {
            Integer bookingId = Integer.parseInt(pathInfo.substring(1));
            handleCancelBooking(request, response, customerId, bookingId);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            sendJsonError(response, "Invalid booking ID");
        }
    }
    
    private void handleCancelBooking(HttpServletRequest request, HttpServletResponse response,
                                   Integer customerId, Integer bookingId) throws IOException {
        try {
            // First, verify that the booking belongs to this customer
            var bookingOpt = bookingDAO.findById(bookingId);
            if (bookingOpt.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                sendJsonError(response, "Booking not found");
                return;
            }
            
            Booking booking = bookingOpt.get();
            if (!booking.getCustomerId().equals(customerId)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                sendJsonError(response, "You can only cancel your own bookings");
                return;
            }
            
            // Check if booking can be cancelled
            if (!canBeCancelled(booking.getBookingStatus())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                sendJsonError(response, "This booking cannot be cancelled. Current status: " + 
                            booking.getBookingStatus());
                return;
            }
            
            // Get cancellation reason from request
            String cancellationReason = request.getParameter("reason");
            if (cancellationReason == null || cancellationReason.trim().isEmpty()) {
                cancellationReason = "Cancelled by customer";
            }
            
            // Perform the cancellation
            boolean success = bookingDAO.cancelBooking(bookingId, cancellationReason, customerId);
            
            if (success) {
                // Return success response
                JsonObject jsonResponse = new JsonObject();
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Booking cancelled successfully");
                jsonResponse.addProperty("bookingId", bookingId);
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(jsonResponse.toString());
                
                LOGGER.info("Booking " + bookingId + " cancelled successfully by customer " + customerId);
                
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                sendJsonError(response, "Failed to cancel booking. Please try again.");
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error while cancelling booking", ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            sendJsonError(response, "Database error occurred. Please try again later.");
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error while cancelling booking", ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            sendJsonError(response, "An unexpected error occurred. Please try again later.");
        }
    }
    
    private boolean canBeCancelled(Booking.BookingStatus status) {
        return status == Booking.BookingStatus.SCHEDULED || 
               status == Booking.BookingStatus.CONFIRMED;
    }
    
    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        JsonObject errorResponse = new JsonObject();
        errorResponse.addProperty("success", false);
        errorResponse.addProperty("error", message);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(errorResponse.toString());
    }
}