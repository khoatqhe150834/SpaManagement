package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import dao.BookingDAO;
import dao.CustomerDAO;
import dao.PaymentDAO;
import dao.PaymentItemDAO;
import dao.PaymentItemUsageDAO;
import dao.ServiceDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ApiResponse;
import model.AvailabilityResult;
import model.Booking;
import model.BookingDetails;
import model.BookingResult;
import model.Customer;
import model.Payment;
import model.PaymentItem;
import model.PaymentItemUsage;
import model.SchedulablePaymentItem;
import model.Service;
import model.User;
import service.NotificationService;

/**
 * Controller for Manager Scheduling Interface
 * Handles scheduling of paid spa services by managers and admins
 * 
 * @author SpaManagement
 */
@WebServlet({"/manager/scheduling", "/manager/scheduling/*", "/api/manager/scheduling/*"})
public class ManagerSchedulingController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(ManagerSchedulingController.class.getName());
    private final Gson gson = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd HH:mm:ss")
            .create();
    
    // DAOs
    private final PaymentDAO paymentDAO;
    private final PaymentItemDAO paymentItemDAO;
    private final PaymentItemUsageDAO paymentItemUsageDAO;
    private final CustomerDAO customerDAO;
    private final ServiceDAO serviceDAO;
    private final UserDAO userDAO;
    private final BookingDAO bookingDAO;
    private final NotificationService notificationService;
    
    public ManagerSchedulingController() {
        this.paymentDAO = new PaymentDAO();
        this.paymentItemDAO = new PaymentItemDAO();
        this.paymentItemUsageDAO = new PaymentItemUsageDAO();
        this.customerDAO = new CustomerDAO();
        this.serviceDAO = new ServiceDAO();
        this.userDAO = new UserDAO();
        this.bookingDAO = new BookingDAO();
        this.notificationService = new NotificationService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check authorization - only MANAGER and ADMIN
        if (user == null || !isAuthorizedRole(user.getRoleId())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        String requestURI = request.getRequestURI();
        
        try {
            if (requestURI.startsWith(request.getContextPath() + "/api/manager/scheduling/")) {
                handleApiRequest(request, response, user);
            } else {
                handlePageRequest(request, response, user);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in ManagerSchedulingController", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check authorization
        if (user == null || !isAuthorizedRole(user.getRoleId())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "create_booking":
                    handleCreateBooking(request, response, user);
                    break;
                case "check_availability":
                    handleCheckAvailability(request, response, user);
                    break;
                case "get_therapists":
                    handleGetTherapists(request, response, user);
                    break;
                case "get_rooms":
                    handleGetRooms(request, response, user);
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
     * Check if user role is authorized for scheduling operations
     */
    private boolean isAuthorizedRole(int roleId) {
        // ADMIN = 1, MANAGER = 2
        return roleId == 1 || roleId == 2;
    }
    
    /**
     * Handle page requests (JSP views)
     */
    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        try {
            // Load initial data for the scheduling interface
            List<SchedulablePaymentItem> schedulableItems = getSchedulablePaymentItems();
            Map<String, Object> statistics = getSchedulingStatistics();
            
            // Set attributes for JSP
            request.setAttribute("pageTitle", "Quản lý lịch hẹn - Spa Hương Sen");
            request.setAttribute("currentUser", user);
            request.setAttribute("schedulableItems", schedulableItems);
            request.setAttribute("statistics", statistics);
            
            // Forward to scheduling JSP
            request.getRequestDispatcher("/WEB-INF/view/manager/manager-scheduling.jsp").forward(request, response);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error loading scheduling page", e);
            request.setAttribute("errorMessage", "Lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/view/common/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle API requests (AJAX/JSON responses)
     */
    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid API endpoint\"}");
            return;
        }
        
        try {
            switch (pathInfo) {
                case "/schedulable-items":
                    handleGetSchedulableItems(request, response, user);
                    break;
                case "/customer-search":
                    handleCustomerSearch(request, response, user);
                    break;
                case "/therapist-availability":
                    handleTherapistAvailability(request, response, user);
                    break;
                case "/room-availability":
                    handleRoomAvailability(request, response, user);
                    break;
                case "/statistics":
                    handleGetStatistics(request, response, user);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("{\"error\": \"API endpoint not found\"}");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error handling API request", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Internal server error\"}");
        }
    }
    
    /**
     * Handle creating a new booking from paid payment item
     */
    private void handleCreateBooking(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // Parse request parameters
            int paymentItemId = getIntParameter(request, "paymentItemId", 0);
            int therapistId = getIntParameter(request, "therapistId", 0);
            String appointmentDateStr = request.getParameter("appointmentDate");
            String appointmentTimeStr = request.getParameter("appointmentTime");
            int roomId = getIntParameter(request, "roomId", 0);
            Integer bedId = getIntParameter(request, "bedId", null);
            String notes = request.getParameter("notes");
            
            // Validate required parameters
            if (paymentItemId == 0 || therapistId == 0 || 
                appointmentDateStr == null || appointmentTimeStr == null || roomId == 0) {
                
                ApiResponse<String> apiResponse = new ApiResponse<>();
                apiResponse.setSuccess(false);
                apiResponse.setMessage("Thiếu thông tin bắt buộc");
                out.write(gson.toJson(apiResponse));
                return;
            }
            
            // Create booking
            BookingResult result = createBookingFromPaymentItem(
                paymentItemId, therapistId, appointmentDateStr, appointmentTimeStr, 
                roomId, bedId, notes, user.getUserId()
            );
            
            ApiResponse<BookingResult> apiResponse = new ApiResponse<>();
            apiResponse.setSuccess(result.isSuccess());
            apiResponse.setData(result);
            apiResponse.setMessage(result.getMessage());
            
            out.write(gson.toJson(apiResponse));
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating booking", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"Internal server error\"}");
        }
    }
    
    /**
     * Handle availability checking
     */
    private void handleCheckAvailability(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            int therapistId = getIntParameter(request, "therapistId", 0);
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("time");
            int durationMinutes = getIntParameter(request, "duration", 60);
            
            if (therapistId == 0 || dateStr == null || timeStr == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"error\": \"Missing required parameters\"}");
                return;
            }
            
            AvailabilityResult result = checkTherapistAvailability(therapistId, dateStr, timeStr, durationMinutes);
            
            ApiResponse<AvailabilityResult> apiResponse = new ApiResponse<>();
            apiResponse.setSuccess(true);
            apiResponse.setData(result);
            
            out.write(gson.toJson(apiResponse));
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking availability", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"Internal server error\"}");
        }
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
     * Get integer parameter with nullable return
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
     * Get schedulable payment items (paid but not fully scheduled)
     */
    private List<SchedulablePaymentItem> getSchedulablePaymentItems() throws SQLException {
        List<SchedulablePaymentItem> schedulableItems = new ArrayList<>();

        // Get all payment item usages with remaining quantity > 0
        List<PaymentItemUsage> availableUsages = paymentItemUsageDAO.findAvailableForBooking();

        for (PaymentItemUsage usage : availableUsages) {
            try {
                // Get payment item details
                Optional<PaymentItem> paymentItemOpt = paymentItemDAO.findById(usage.getPaymentItemId());
                if (paymentItemOpt.isEmpty()) continue;
                PaymentItem paymentItem = paymentItemOpt.get();

                // Get payment details
                Optional<Payment> paymentOpt = paymentDAO.findById(paymentItem.getPaymentId());
                if (paymentOpt.isEmpty()) continue;
                Payment payment = paymentOpt.get();

                // Only include PAID payments
                if (!Payment.PaymentStatus.PAID.equals(payment.getPaymentStatus())) continue;

                // Get customer details
                Optional<Customer> customerOpt = customerDAO.findById(payment.getCustomerId());
                if (customerOpt.isEmpty()) continue;
                Customer customer = customerOpt.get();

                // Get service details
                Optional<Service> serviceOpt = serviceDAO.findById(paymentItem.getServiceId());
                if (serviceOpt.isEmpty()) continue;
                Service service = serviceOpt.get();

                // Create schedulable item
                SchedulablePaymentItem schedulableItem = new SchedulablePaymentItem();
                schedulableItem.setPaymentItemId(paymentItem.getPaymentItemId());
                schedulableItem.setPaymentId(payment.getPaymentId());
                schedulableItem.setCustomerId(customer.getCustomerId());
                schedulableItem.setCustomerName(customer.getFullName());
                schedulableItem.setCustomerPhone(customer.getPhoneNumber());
                schedulableItem.setServiceId(service.getServiceId());
                schedulableItem.setServiceName(service.getName());
                schedulableItem.setServiceDuration(paymentItem.getServiceDuration());
                schedulableItem.setUnitPrice(paymentItem.getUnitPrice());
                schedulableItem.setTotalQuantity(usage.getTotalQuantity());
                schedulableItem.setBookedQuantity(usage.getBookedQuantity());
                schedulableItem.setRemainingQuantity(usage.getRemainingQuantity());
                schedulableItem.setPaymentDate(payment.getPaymentDate());
                schedulableItem.setReferenceNumber(payment.getReferenceNumber());

                schedulableItems.add(schedulableItem);

            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error processing payment item usage: " + usage.getUsageId(), e);
            }
        }

        // Sort by payment date (newest first)
        schedulableItems.sort((a, b) -> b.getPaymentDate().compareTo(a.getPaymentDate()));

        return schedulableItems;
    }

    /**
     * Get scheduling statistics
     */
    private Map<String, Object> getSchedulingStatistics() throws SQLException {
        Map<String, Object> stats = paymentItemUsageDAO.getUsageStatistics();

        // Add additional statistics
        stats.put("totalPaidPayments", getTotalPaidPayments());
        stats.put("totalCustomersWithUnscheduled", getTotalCustomersWithUnscheduled());

        return stats;
    }

    /**
     * Check therapist availability
     */
    private AvailabilityResult checkTherapistAvailability(int therapistId, String dateStr, String timeStr, int durationMinutes) {
        try {
            LocalDate date = LocalDate.parse(dateStr);
            LocalTime startTime = LocalTime.parse(timeStr);
            LocalTime endTime = startTime.plusMinutes(durationMinutes);

            // Check if therapist exists and is active
            Optional<User> therapistOpt = userDAO.findById(therapistId);
            if (therapistOpt.isEmpty()) {
                return new AvailabilityResult(false, "Kỹ thuật viên không tồn tại", null);
            }

            User therapist = therapistOpt.get();
            if (!therapist.getIsActive()) {
                return new AvailabilityResult(false, "Kỹ thuật viên không hoạt động", null);
            }

            // Check for conflicting bookings
            List<Booking> existingBookings = bookingDAO.findByTherapistAndDate(therapistId, Date.valueOf(date));

            for (Booking booking : existingBookings) {
                if (booking.getBookingStatus() == Booking.BookingStatus.CANCELLED ||
                    booking.getBookingStatus() == Booking.BookingStatus.NO_SHOW) {
                    continue; // Skip cancelled/no-show bookings
                }

                LocalTime bookingStart = booking.getAppointmentTime().toLocalTime();
                LocalTime bookingEnd = bookingStart.plusMinutes(booking.getDurationMinutes());

                // Check for time overlap
                if (!(endTime.isBefore(bookingStart) || startTime.isAfter(bookingEnd))) {
                    return new AvailabilityResult(false,
                        "Kỹ thuật viên đã có lịch từ " + bookingStart + " đến " + bookingEnd,
                        booking);
                }
            }

            return new AvailabilityResult(true, "Có lịch trống", null);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking therapist availability", e);
            return new AvailabilityResult(false, "Lỗi kiểm tra lịch trống", null);
        }
    }

    /**
     * Get total paid payments count
     */
    private int getTotalPaidPayments() throws SQLException {
        String sql = "SELECT COUNT(*) FROM payments WHERE payment_status = 'PAID'";
        try (var conn = db.DBContext.getConnection();
             var stmt = conn.prepareStatement(sql);
             var rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /**
     * Get total customers with unscheduled services
     */
    private int getTotalCustomersWithUnscheduled() throws SQLException {
        String sql = "SELECT COUNT(DISTINCT p.customer_id) FROM payments p " +
                    "JOIN payment_items pi ON p.payment_id = pi.payment_id " +
                    "JOIN payment_item_usage piu ON pi.payment_item_id = piu.payment_item_id " +
                    "WHERE p.payment_status = 'PAID' AND piu.remaining_quantity > 0";
        try (var conn = db.DBContext.getConnection();
             var stmt = conn.prepareStatement(sql);
             var rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /**
     * Handle getting schedulable items via API
     */
    private void handleGetSchedulableItems(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        try {
            List<SchedulablePaymentItem> items = getSchedulablePaymentItems();

            ApiResponse<List<SchedulablePaymentItem>> apiResponse = new ApiResponse<>();
            apiResponse.setSuccess(true);
            apiResponse.setData(items);
            apiResponse.setMessage("Schedulable items retrieved successfully");

            response.getWriter().write(gson.toJson(apiResponse));

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting schedulable items", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error\"}");
        }
    }

    /**
     * Handle customer search via API
     */
    private void handleCustomerSearch(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        String searchTerm = request.getParameter("q");
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Search term is required\"}");
            return;
        }

        try {
            List<Customer> customers = searchCustomers(searchTerm.trim());

            ApiResponse<List<Customer>> apiResponse = new ApiResponse<>();
            apiResponse.setSuccess(true);
            apiResponse.setData(customers);
            apiResponse.setMessage("Customer search completed");

            response.getWriter().write(gson.toJson(apiResponse));

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error searching customers", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error\"}");
        }
    }

    /**
     * Handle therapist availability check via API
     */
    private void handleTherapistAvailability(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        int therapistId = getIntParameter(request, "therapistId", 0);
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        int duration = getIntParameter(request, "duration", 60);

        if (therapistId == 0 || date == null || time == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing required parameters\"}");
            return;
        }

        try {
            AvailabilityResult result = checkTherapistAvailability(therapistId, date, time, duration);

            ApiResponse<AvailabilityResult> apiResponse = new ApiResponse<>();
            apiResponse.setSuccess(true);
            apiResponse.setData(result);
            apiResponse.setMessage("Availability check completed");

            response.getWriter().write(gson.toJson(apiResponse));

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking therapist availability", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Internal server error\"}");
        }
    }

    /**
     * Handle room availability check via API
     */
    private void handleRoomAvailability(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        // This would implement room availability checking
        // For now, return a simple response
        ApiResponse<String> apiResponse = new ApiResponse<>();
        apiResponse.setSuccess(true);
        apiResponse.setData("Room availability feature coming soon");
        apiResponse.setMessage("Room availability check");

        response.getWriter().write(gson.toJson(apiResponse));
    }

    /**
     * Handle getting statistics via API
     */
    private void handleGetStatistics(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        try {
            Map<String, Object> stats = getSchedulingStatistics();

            ApiResponse<Map<String, Object>> apiResponse = new ApiResponse<>();
            apiResponse.setSuccess(true);
            apiResponse.setData(stats);
            apiResponse.setMessage("Statistics retrieved successfully");

            response.getWriter().write(gson.toJson(apiResponse));

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting statistics", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error\"}");
        }
    }

    /**
     * Handle getting therapists
     */
    private void handleGetTherapists(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        try {
            // Get therapists (role_id = 3)
            List<User> therapists = userDAO.findByRoleId(3, 1, 100);

            ApiResponse<List<User>> apiResponse = new ApiResponse<>();
            apiResponse.setSuccess(true);
            apiResponse.setData(therapists);
            apiResponse.setMessage("Therapists retrieved successfully");

            response.getWriter().write(gson.toJson(apiResponse));

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting therapists", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error\"}");
        }
    }

    /**
     * Handle getting rooms
     */
    private void handleGetRooms(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        // This would implement room retrieval
        // For now, return a simple response
        ApiResponse<String> apiResponse = new ApiResponse<>();
        apiResponse.setSuccess(true);
        apiResponse.setData("Room management feature coming soon");
        apiResponse.setMessage("Rooms retrieved");

        response.getWriter().write(gson.toJson(apiResponse));
    }

    /**
     * Create booking details from booking entity
     */
    private BookingDetails createBookingDetails(Booking booking) {
        try {
            BookingDetails details = new BookingDetails();
            details.setBookingId(booking.getBookingId());
            details.setCustomerId(booking.getCustomerId());
            details.setServiceId(booking.getServiceId());
            details.setTherapistId(booking.getTherapistUserId());
            details.setAppointmentDate(booking.getAppointmentDate());
            details.setAppointmentTime(booking.getAppointmentTime());
            details.setDurationMinutes(booking.getDurationMinutes());
            details.setBookingStatus(booking.getBookingStatus().name());
            details.setBookingNotes(booking.getBookingNotes());
            details.setRoomId(booking.getRoomId());
            details.setBedId(booking.getBedId());
            details.setPaymentItemId(booking.getPaymentItemId());
            details.setCreatedAt(booking.getCreatedAt());

            // Load related data
            Optional<Customer> customerOpt = customerDAO.findById(booking.getCustomerId());
            if (customerOpt.isPresent()) {
                Customer customer = customerOpt.get();
                details.setCustomerName(customer.getFullName());
                details.setCustomerPhone(customer.getPhoneNumber());
            }

            Optional<Service> serviceOpt = serviceDAO.findById(booking.getServiceId());
            if (serviceOpt.isPresent()) {
                details.setServiceName(serviceOpt.get().getName());
            }

            Optional<User> therapistOpt = userDAO.findById(booking.getTherapistUserId());
            if (therapistOpt.isPresent()) {
                details.setTherapistName(therapistOpt.get().getFullName());
            }

            // Get payment reference number
            Optional<PaymentItem> paymentItemOpt = paymentItemDAO.findById(booking.getPaymentItemId());
            if (paymentItemOpt.isPresent()) {
                Optional<Payment> paymentOpt = paymentDAO.findById(paymentItemOpt.get().getPaymentId());
                if (paymentOpt.isPresent()) {
                    details.setReferenceNumber(paymentOpt.get().getReferenceNumber());
                }
            }

            return details;

        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error creating booking details", e);
            return null;
        }
    }

    /**
     * Send booking confirmation notification to customer
     */
    private void sendBookingConfirmationNotification(Booking booking, Payment payment, PaymentItem paymentItem) {
        try {
            // This would integrate with the notification system
            // For now, just log the notification
            LOGGER.info(String.format("Booking confirmation notification should be sent to customer %d for booking %d",
                payment.getCustomerId(), booking.getBookingId()));

        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error sending booking confirmation notification", e);
        }
    }

    /**
     * Search customers by name or phone
     */
    private List<Customer> searchCustomers(String searchTerm) {
        try {
            // Use existing findAll method and filter
            List<Customer> allCustomers = customerDAO.findAll();
            List<Customer> matchingCustomers = new ArrayList<>();

            String lowerSearchTerm = searchTerm.toLowerCase();

            for (Customer customer : allCustomers) {
                if ((customer.getFullName() != null && customer.getFullName().toLowerCase().contains(lowerSearchTerm)) ||
                    (customer.getPhoneNumber() != null && customer.getPhoneNumber().contains(searchTerm)) ||
                    (customer.getEmail() != null && customer.getEmail().toLowerCase().contains(lowerSearchTerm))) {
                    matchingCustomers.add(customer);
                }
            }

            return matchingCustomers;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error searching customers", e);
            return new ArrayList<>();
        }
    }

    /**
     * Create booking from payment item - main business logic method
     */
    private BookingResult createBookingFromPaymentItem(int paymentItemId, int therapistId,
            String appointmentDateStr, String appointmentTimeStr, int roomId, Integer bedId,
            String notes, int createdByUserId) {

        try {
            // Validate payment item and usage
            Optional<PaymentItemUsage> usageOpt = paymentItemUsageDAO.findByPaymentItemId(paymentItemId);
            if (usageOpt.isEmpty()) {
                return new BookingResult(false, "Không tìm thấy thông tin sử dụng dịch vụ", null);
            }

            PaymentItemUsage usage = usageOpt.get();
            if (!usage.hasRemainingQuantity()) {
                return new BookingResult(false, "Dịch vụ đã được đặt lịch hết", null);
            }

            // Get payment item details
            Optional<PaymentItem> paymentItemOpt = paymentItemDAO.findById(paymentItemId);
            if (paymentItemOpt.isEmpty()) {
                return new BookingResult(false, "Không tìm thấy thông tin dịch vụ", null);
            }
            PaymentItem paymentItem = paymentItemOpt.get();

            // Get payment details
            Optional<Payment> paymentOpt = paymentDAO.findById(paymentItem.getPaymentId());
            if (paymentOpt.isEmpty()) {
                return new BookingResult(false, "Không tìm thấy thông tin thanh toán", null);
            }
            Payment payment = paymentOpt.get();

            // Validate payment status
            if (!Payment.PaymentStatus.PAID.equals(payment.getPaymentStatus())) {
                return new BookingResult(false, "Thanh toán chưa được xác nhận", null);
            }

            // Parse date and time
            LocalDate appointmentDate = LocalDate.parse(appointmentDateStr);
            LocalTime appointmentTime = LocalTime.parse(appointmentTimeStr);

            // Check therapist availability
            AvailabilityResult availability = checkTherapistAvailability(
                therapistId, appointmentDateStr, appointmentTimeStr, paymentItem.getServiceDuration()
            );

            if (!availability.isAvailable()) {
                return new BookingResult(false, "Kỹ thuật viên không có lịch trống: " + availability.getReason(), null);
            }

            // Create booking
            Booking booking = new Booking();
            booking.setCustomerId(payment.getCustomerId());
            booking.setPaymentItemId(paymentItemId);
            booking.setServiceId(paymentItem.getServiceId());
            booking.setTherapistUserId(therapistId);
            booking.setAppointmentDate(Date.valueOf(appointmentDate));
            booking.setAppointmentTime(Time.valueOf(appointmentTime));
            booking.setDurationMinutes(paymentItem.getServiceDuration());
            booking.setBookingStatus(Booking.BookingStatus.SCHEDULED);
            booking.setBookingNotes(notes);
            booking.setRoomId(roomId);
            booking.setBedId(bedId);

            // Save booking
            Booking savedBooking = bookingDAO.save(booking);
            if (savedBooking == null || savedBooking.getBookingId() == null) {
                return new BookingResult(false, "Lỗi khi tạo lịch hẹn", null);
            }

            // Update payment item usage
            boolean usageUpdated = paymentItemUsageDAO.incrementBookedQuantity(paymentItemId);
            if (!usageUpdated) {
                // Rollback booking if usage update fails
                bookingDAO.deleteById(savedBooking.getBookingId());
                return new BookingResult(false, "Lỗi cập nhật số lượng dịch vụ", null);
            }

            // Send notification to customer
            try {
                sendBookingConfirmationNotification(savedBooking, payment, paymentItem);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Failed to send booking confirmation notification", e);
            }

            // Create booking details for response
            BookingDetails bookingDetails = createBookingDetails(savedBooking);

            LOGGER.info(String.format("Booking created successfully: ID %d for customer %d by user %d",
                savedBooking.getBookingId(), payment.getCustomerId(), createdByUserId));

            return new BookingResult(true, "Đặt lịch thành công", bookingDetails);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating booking from payment item", e);
            return new BookingResult(false, "Lỗi hệ thống khi tạo lịch hẹn", null);
        }
    }
}
