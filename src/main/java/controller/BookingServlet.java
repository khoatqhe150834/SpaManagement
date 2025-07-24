// src/main/java/controller/BookingServlet.java
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;

import booking.AvailableTimeSlot;
import booking.BookingConstraint;
import booking.PaymentItemDetails;
import booking.RoomBedInfo;
import booking.ServiceInfo;
import booking.SpaCspSolver;
import booking.TherapistInfo;
import dao.BookingDAO;
import dao.SchedulingConstraintDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet({"/manager/schedule-booking", "/manager/booking-api"})
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
        String requestURI = request.getRequestURI();

        LOGGER.info("BookingServlet doGet - URI: " + requestURI + ", Action: " + action);

        try {
            switch (action != null ? action : "showBookingPage") {
                case "loadPaymentItems":
                    LOGGER.info("Handling loadPaymentItems request");
                    loadPaymentItems(request, response);
                    break;
                case "getAvailableSlots":
                    LOGGER.info("Handling getAvailableSlots request");
                    getAvailableSlots(request, response);
                    break;
                case "getAvailableResources":
                    LOGGER.info("Handling getAvailableResources request");
                    getAvailableResources(request, response);
                    break;
                case "debugService":
                    LOGGER.info("Handling debugService request");
                    debugServiceData(request, response);
                    break;
                case "showBookingPage":
                default:
                    LOGGER.info("Handling showBookingPage request");
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
        String requestURI = request.getRequestURI();

        LOGGER.info("BookingServlet doPost - URI: " + requestURI + ", Action: " + action);
        LOGGER.info("Content-Type: " + request.getContentType());
        LOGGER.info("Method: " + request.getMethod());

        // Log all parameters for debugging
        LOGGER.info("All parameters:");
        request.getParameterMap().forEach((key, values) -> {
            LOGGER.info("  " + key + " = " + String.join(", ", values));
        });

        try {
            if ("createBooking".equals(action)) {
                LOGGER.info("Calling createBooking method");
                createBooking(request, response);
            } else {
                LOGGER.warning("Invalid action received: " + action);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
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
    Integer userRoleId = (Integer) request.getAttribute("userRoleId");

    // If user is a manager/admin and no customerId in session, check for paymentItemId parameter
    if (customerId == null) {
        String paymentItemIdParam = request.getParameter("paymentItemId");
        if (paymentItemIdParam != null && !paymentItemIdParam.isEmpty()) {
            try {
                int paymentItemId = Integer.parseInt(paymentItemIdParam);
                // Get customer ID from the payment item
                customerId = bookingDAO.getCustomerIdFromPaymentItem(paymentItemId);
                LOGGER.info("Manager/Admin accessing booking for customer " + customerId + " via payment item " + paymentItemId);
            } catch (NumberFormatException | SQLException e) {
                LOGGER.log(Level.WARNING, "Error getting customer ID from payment item", e);
            }
        }
    }

    if (customerId == null) {
        // For testing, use a default customer ID
        customerId = 114; // Use an existing customer ID from your database
        LOGGER.warning("No customer ID found, using default customer ID for testing: " + customerId);
    } else {
        LOGGER.info("Using customer ID: " + customerId);
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

    LOGGER.info("Loaded " + paymentItems.size() + " payment items for customer " + customerId);
    if (selectedPaymentItem != null) {
        LOGGER.info("Selected payment item: " + selectedPaymentItem.getServiceName() + " (ID: " + selectedPaymentItemId + ")");
    } else if (paymentItemIdParam != null) {
        LOGGER.warning("Payment item " + paymentItemIdParam + " not found or not accessible");
    }

    // If no payment items found, log this for debugging
    if (paymentItems.isEmpty()) {
        LOGGER.warning("No payment items found for customer " + customerId + ". Customer may not have any paid services.");
    }

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

        String paymentItemIdStr = request.getParameter("paymentItemId");
        String dateStr = request.getParameter("date");

        LOGGER.info("getAvailableSlots called with paymentItemId: " + paymentItemIdStr + ", date: " + dateStr);

        if (paymentItemIdStr == null || dateStr == null) {
            LOGGER.warning("Missing required parameters: paymentItemId=" + paymentItemIdStr + ", date=" + dateStr);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        int paymentItemId = Integer.parseInt(paymentItemIdStr);
        LocalDate selectedDate = LocalDate.parse(dateStr);

        // Get payment item details
        PaymentItemDetails paymentItem = bookingDAO.getPaymentItemForBooking(paymentItemId);
        if (paymentItem == null) {
            LOGGER.warning("Payment item not found: " + paymentItemId);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Payment item not found");
            return;
        }

        LOGGER.info("Found payment item: " + paymentItem.getServiceName() + " for service ID: " + paymentItem.getServiceId());

        // Find available slots using CSP
        LOGGER.info("Calling CSP solver for service ID: " + paymentItem.getServiceId() + " on date: " + selectedDate);

        // Quick check of basic data before calling CSP solver
        try {
            SchedulingConstraintDAO dao = new SchedulingConstraintDAO();
            List<TherapistInfo> therapists = dao.getQualifiedTherapists(paymentItem.getServiceId());
            LOGGER.info("Found " + therapists.size() + " qualified therapists for service " + paymentItem.getServiceId());

            List<RoomBedInfo> roomBeds = dao.loadRoomsAndBeds();
            LOGGER.info("Found " + roomBeds.size() + " room-bed combinations");

            if (therapists.isEmpty()) {
                LOGGER.warning("No qualified therapists found for service ID: " + paymentItem.getServiceId());
            }
            if (roomBeds.isEmpty()) {
                LOGGER.warning("No room-bed combinations found");
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error checking basic data", e);
        }

        List<AvailableTimeSlot> availableSlots = cspSolver.findAvailableSlots(
            selectedDate, paymentItem.getServiceId(), 50);

        LOGGER.info("CSP solver returned " + availableSlots.size() + " available slots");

        // If no slots found, let's debug why
        if (availableSlots.isEmpty()) {
            LOGGER.warning("No available slots found. This could be due to:");
            LOGGER.warning("1. No qualified therapists for service ID: " + paymentItem.getServiceId());
            LOGGER.warning("2. No available room-bed combinations");
            LOGGER.warning("3. All time slots are booked");
            LOGGER.warning("4. Service not found in database");
            LOGGER.warning("5. Date is outside business hours or in the past");
        }

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

        LOGGER.info("Response sent with " + availableSlots.size() + " available slots for payment item " +
                   paymentItemId + " on " + selectedDate);
    }
    
    private void getAvailableResources(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        String paymentItemIdStr = request.getParameter("paymentItemId");
        String dateStr = request.getParameter("date");
        String timeStr = request.getParameter("time");

        LOGGER.info("getAvailableResources called with paymentItemId: " + paymentItemIdStr +
                   ", date: " + dateStr + ", time: " + timeStr);

        if (paymentItemIdStr == null || dateStr == null || timeStr == null) {
            LOGGER.warning("Missing required parameters for getAvailableResources");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        int paymentItemId;
        LocalDate selectedDate;
        LocalTime selectedTime;
        PaymentItemDetails paymentItem;

        try {
            paymentItemId = Integer.parseInt(paymentItemIdStr);
            selectedDate = LocalDate.parse(dateStr);
            selectedTime = LocalTime.parse(timeStr);

            // Get payment item details
            paymentItem = bookingDAO.getPaymentItemForBooking(paymentItemId);
            if (paymentItem == null) {
                LOGGER.warning("Payment item not found: " + paymentItemId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Payment item not found");
                return;
            }
        } catch (NumberFormatException | DateTimeParseException e) {
            LOGGER.log(Level.WARNING, "Invalid parameter format in getAvailableResources", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameter format: " + e.getMessage());
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

        LOGGER.info("createBooking called with parameters:");
        LOGGER.info("paymentItemId: " + request.getParameter("paymentItemId"));
        LOGGER.info("appointmentDate: " + request.getParameter("appointmentDate"));
        LOGGER.info("appointmentTime: " + request.getParameter("appointmentTime"));
        LOGGER.info("therapistId: " + request.getParameter("therapistId"));
        LOGGER.info("roomId: " + request.getParameter("roomId"));
        LOGGER.info("bedId: " + request.getParameter("bedId"));

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
            LOGGER.log(Level.WARNING, "Invalid parameter format in booking creation", e);

            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Invalid parameter format: " + e.getMessage());

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(errorResponse));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error creating booking", e);

            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Database error: " + e.getMessage());
            errorResponse.put("sqlState", e.getSQLState());
            errorResponse.put("errorCode", e.getErrorCode());

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(errorResponse));
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error creating booking", e);

            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Unexpected error: " + e.getMessage());
            errorResponse.put("errorType", e.getClass().getSimpleName());

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

    /**
     * Debug method to check service data and constraints
     */
    private void debugServiceData(HttpServletRequest request, HttpServletResponse response)
            throws IOException, SQLException {

        String serviceIdStr = request.getParameter("serviceId");
        String dateStr = request.getParameter("date");

        if (serviceIdStr == null || dateStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing serviceId or date parameter");
            return;
        }

        int serviceId = Integer.parseInt(serviceIdStr);
        LocalDate targetDate = LocalDate.parse(dateStr);

        Map<String, Object> debugData = new HashMap<>();

        try {
            // Check service info
            SchedulingConstraintDAO dao = new SchedulingConstraintDAO();

            // Get service information
            debugData.put("serviceId", serviceId);
            debugData.put("targetDate", targetDate);

            // Get qualified therapists
            List<TherapistInfo> therapists = dao.getQualifiedTherapists(serviceId);
            debugData.put("qualifiedTherapists", therapists);
            debugData.put("therapistCount", therapists.size());

            // Get room-bed combinations
            List<RoomBedInfo> roomBeds = dao.loadRoomsAndBeds();
            debugData.put("roomBedCombinations", roomBeds);
            debugData.put("roomBedCount", roomBeds.size());

            // Get existing bookings for the date
            List<BookingConstraint> bookings = dao.loadExistingBookings(targetDate);
            debugData.put("existingBookings", bookings);
            debugData.put("bookingCount", bookings.size());

            // Get service info
            ServiceInfo serviceInfo = dao.getServiceInfo(serviceId);
            debugData.put("serviceInfo", serviceInfo);

        } catch (Exception e) {
            debugData.put("error", e.getMessage());
            LOGGER.log(Level.SEVERE, "Error in debug service data", e);
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(debugData));
        }
    }
}