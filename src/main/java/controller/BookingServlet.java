// src/main/java/controller/BookingServlet.java
package controller;

import booking.*;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import dao.BookingDAO;
import dao.SchedulingConstraintDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
@WebServlet("/manager/schedule-booking")
public class BookingServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BookingServlet.class.getName());
    
    private BookingDAO bookingDAO;
    private SchedulingConstraintDAO constraintDAO;
    private SpaCspSolver cspSolver;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        super.init();
        bookingDAO = new BookingDAO();
        constraintDAO = new SchedulingConstraintDAO();
        cspSolver = new SpaCspSolver();
        
        // Configure Gson for LocalDateTime serialization
        gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) -> 
                context.serialize(src.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)))
            .registerTypeAdapter(LocalDate.class, (JsonSerializer<LocalDate>) (src, typeOfSrc, context) -> 
                context.serialize(src.format(DateTimeFormatter.ISO_LOCAL_DATE)))
            .registerTypeAdapter(LocalTime.class, (JsonSerializer<LocalTime>) (src, typeOfSrc, context) -> 
                context.serialize(src.format(DateTimeFormatter.ofPattern("HH:mm"))))
            .create();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "showBookingPage") {
                case "loadPaymentItems":
                    loadPaymentItems(request, response);
                    break;
                case "getAvailableSlots":
                    getAvailableSlots(request, response);
                    break;
                case "getAvailableResources":
                    getAvailableResources(request, response);
                    break;
                case "showBookingPage":
                default:
                    showBookingPage(request, response);
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in BookingServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        try {
            if ("createBooking".equals(action)) {
                createBooking(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in BookingServlet POST", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }
    
    private void showBookingPage(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException, SQLException {
    
    HttpSession session = request.getSession();
    Integer customerId = (Integer) session.getAttribute("customerId");
    
    if (customerId == null) {
        // For testing, use a default customer ID
        customerId = 114; // Use an existing customer ID from your database
        session.setAttribute("customerId", customerId);
    }
    
    // Check if a specific paymentItemId was requested
    String paymentItemIdParam = request.getParameter("paymentItemId");
    Integer selectedPaymentItemId = null;
    PaymentItemDetails selectedPaymentItem = null;
    
    if (paymentItemIdParam != null && !paymentItemIdParam.isEmpty()) {
        try {
            selectedPaymentItemId = Integer.parseInt(paymentItemIdParam);
            // Get the specific payment item details
            selectedPaymentItem = bookingDAO.getPaymentItemForBooking(selectedPaymentItemId);
            
            // Verify the payment item belongs to this customer
            int paymentItemCustomerId = bookingDAO.getCustomerIdFromPaymentItem(selectedPaymentItemId);
            if (paymentItemCustomerId != customerId) {
                // Payment item doesn't belong to this customer
                selectedPaymentItemId = null;
                selectedPaymentItem = null;
                LOGGER.warning("Customer " + customerId + " tried to access payment item " + 
                             selectedPaymentItemId + " belonging to customer " + paymentItemCustomerId);
            }
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid paymentItemId parameter: " + paymentItemIdParam);
            selectedPaymentItemId = null;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving payment item details", e);
            selectedPaymentItemId = null;
        }
    }
    
    // Load all available payment items for the customer
    List<PaymentItemDetails> paymentItems = bookingDAO.getAvailablePaymentItems(customerId);
    
    // Set request attributes
    request.setAttribute("paymentItems", paymentItems);
    request.setAttribute("customerId", customerId);
    request.setAttribute("selectedPaymentItemId", selectedPaymentItemId);
    request.setAttribute("selectedPaymentItem", selectedPaymentItem);
    
    // If a specific payment item was selected and is valid, you might want to
    // pre-populate the booking form or highlight the selected item
    if (selectedPaymentItem != null) {
        LOGGER.info("Pre-selecting payment item: " + selectedPaymentItem.getServiceName() + 
                   " (ID: " + selectedPaymentItemId + ") for customer " + customerId);
    }
    
    request.getRequestDispatcher("/booking.jsp").forward(request, response);
}
    
    private void getAvailableSlots(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        
        int paymentItemId = Integer.parseInt(request.getParameter("paymentItemId"));
        LocalDate selectedDate = LocalDate.parse(request.getParameter("date"));
        
        // Get payment item details
        PaymentItemDetails paymentItem = bookingDAO.getPaymentItemForBooking(paymentItemId);
        if (paymentItem == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Payment item not found");
            return;
        }
        
        // Find available slots using CSP
        List<AvailableTimeSlot> availableSlots = cspSolver.findAvailableSlots(
            selectedDate, paymentItem.getServiceId(), 50);
        
        // Prepare response data
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("paymentItem", paymentItem);
        responseData.put("selectedDate", selectedDate);
        responseData.put("availableSlots", availableSlots);
        responseData.put("totalSlots", availableSlots.size());
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(responseData));
        }
        
        LOGGER.info("Found " + availableSlots.size() + " available slots for payment item " + 
                   paymentItemId + " on " + selectedDate);
    }
    
    private void getAvailableResources(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        
        int paymentItemId = Integer.parseInt(request.getParameter("paymentItemId"));
        LocalDate selectedDate = LocalDate.parse(request.getParameter("date"));
        LocalTime selectedTime = LocalTime.parse(request.getParameter("time"));
        
        // Get payment item details
        PaymentItemDetails paymentItem = bookingDAO.getPaymentItemForBooking(paymentItemId);
        if (paymentItem == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Payment item not found");
            return;
        }
        
        // Find available slots for the specific time
        List<AvailableTimeSlot> availableSlots = cspSolver.findAvailableSlots(
            selectedDate, paymentItem.getServiceId(), 100);
        
        // Find the slot that matches the selected time
        LocalDateTime selectedDateTime = LocalDateTime.of(selectedDate, selectedTime);
        AvailableTimeSlot matchingSlot = null;
        
        for (AvailableTimeSlot slot : availableSlots) {
            if (slot.getTimeSlot().getStartTime().equals(selectedDateTime)) {
                matchingSlot = slot;
                break;
            }
        }
        
        Map<String, Object> responseData = new HashMap<>();
        if (matchingSlot != null) {
            responseData.put("availableResources", matchingSlot.getAvailableResources());
            responseData.put("totalCombinations", matchingSlot.getTotalCombinations());
        } else {
            responseData.put("availableResources", List.of());
            responseData.put("totalCombinations", 0);
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(responseData));
        }
    }
    
    private void createBooking(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        
        try {
            int paymentItemId = Integer.parseInt(request.getParameter("paymentItemId"));
            LocalDate appointmentDate = LocalDate.parse(request.getParameter("appointmentDate"));
            LocalTime appointmentTime = LocalTime.parse(request.getParameter("appointmentTime"));
            int therapistId = Integer.parseInt(request.getParameter("therapistId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            Integer bedId = request.getParameter("bedId") != null && !request.getParameter("bedId").isEmpty() ? 
                           Integer.parseInt(request.getParameter("bedId")) : null;
            
            // Get payment item and customer details
            PaymentItemDetails paymentItem = bookingDAO.getPaymentItemForBooking(paymentItemId);
            if (paymentItem == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Payment item not found");
                return;
            }
            
            if (!paymentItem.hasRemainingQuantity()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No remaining quantity for this payment item");
                return;
            }
            
            int customerId = bookingDAO.getCustomerIdFromPaymentItem(paymentItemId);
            
            // Create the booking
            int bookingId = bookingDAO.createBooking(
                customerId, paymentItemId, paymentItem.getServiceId(), therapistId,
                roomId, bedId, appointmentDate, appointmentTime, paymentItem.getServiceDuration()
            );
            
            // Prepare success response
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", true);
            responseData.put("bookingId", bookingId);
            responseData.put("message", "Booking created successfully!");
            responseData.put("appointmentDate", appointmentDate);
            responseData.put("appointmentTime", appointmentTime);
            responseData.put("serviceName", paymentItem.getServiceName());
            responseData.put("remainingQuantity", paymentItem.getRemainingQuantity() - 1);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(responseData));
            }
            
            LOGGER.info("Successfully created booking ID: " + bookingId + 
                       " for payment item: " + paymentItemId);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameter format");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating booking", e);
            
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to create booking: " + e.getMessage());
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(errorResponse));
            }
        }
    }

    private void loadPaymentItems(HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}