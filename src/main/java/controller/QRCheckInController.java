package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.Gson;

import dao.BookingDAO;
import dao.CustomerDAO;
import dao.ServiceDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Customer;
import model.Service;
import model.User;

/**
 * Controller for QR code check-in functionality
 * Handles customer arrival verification and booking status updates
 * 
 * @author SpaManagement
 */
@WebServlet({"/checkin/qr", "/booking/checkin", "/api/checkin/qr"})
public class QRCheckInController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(QRCheckInController.class.getName());
    private final Gson gson = new Gson();
    
    private final BookingDAO bookingDAO;
    private final CustomerDAO customerDAO;
    private final ServiceDAO serviceDAO;
    private final UserDAO userDAO;
    
    public QRCheckInController() {
        this.bookingDAO = new BookingDAO();
        this.customerDAO = new CustomerDAO();
        this.serviceDAO = new ServiceDAO();
        this.userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check authorization - only RECEPTIONIST, MANAGER, or ADMIN
        if (user == null || !isAuthorizedRole(user.getRoleId())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        String requestURI = request.getRequestURI();
        
        try {
            if (requestURI.startsWith(request.getContextPath() + "/api/checkin/qr")) {
                handleApiRequest(request, response, user);
            } else {
                handlePageRequest(request, response, user);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in QRCheckInController", e);
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
                case "checkin_qr":
                    handleQRCheckIn(request, response, user);
                    break;
                case "manual_checkin":
                    handleManualCheckIn(request, response, user);
                    break;
                case "validate_qr":
                    handleValidateQR(request, response, user);
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
     * Check if user role is authorized for check-in operations
     */
    private boolean isAuthorizedRole(int roleId) {
        // ADMIN = 1, MANAGER = 2, RECEPTIONIST = 4
        return roleId == 1 || roleId == 2 || roleId == 4;
    }
    
    /**
     * Handle page requests (JSP views)
     */
    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response, User user) 
            throws ServletException, IOException {
        
        // Set attributes for JSP
        request.setAttribute("pageTitle", "QR Check-in - Spa Hương Sen");
        request.setAttribute("currentUser", user);
        
        // Forward to QR check-in JSP
        request.getRequestDispatcher("/WEB-INF/view/staff/qr-checkin.jsp").forward(request, response);
    }
    
    /**
     * Handle API requests (AJAX/JSON responses)
     */
    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String qrData = request.getParameter("qrData");
        if (qrData == null || qrData.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"QR data is required\"}");
            return;
        }
        
        try {
            CheckInResult result = processQRCheckIn(qrData, user.getUserId());
            
            PrintWriter out = response.getWriter();
            ApiResponse<CheckInResult> apiResponse = new ApiResponse<>();
            apiResponse.setSuccess(result.isSuccess());
            apiResponse.setData(result);
            apiResponse.setMessage(result.getMessage());
            
            out.write(gson.toJson(apiResponse));
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing QR check-in", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Internal server error\"}");
        }
    }
    
    /**
     * Handle QR code check-in
     */
    private void handleQRCheckIn(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        String qrData = request.getParameter("qrData");
        if (qrData == null || qrData.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "QR data is required");
            return;
        }
        
        try {
            CheckInResult result = processQRCheckIn(qrData, user.getUserId());
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            
            ApiResponse<CheckInResult> apiResponse = new ApiResponse<>();
            apiResponse.setSuccess(result.isSuccess());
            apiResponse.setData(result);
            apiResponse.setMessage(result.getMessage());
            
            out.write(gson.toJson(apiResponse));
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing QR check-in", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Internal server error\"}");
        }
    }
    
    /**
     * Handle manual check-in (fallback when QR fails)
     */
    private void handleManualCheckIn(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        int bookingId = getIntParameter(request, "bookingId", 0);
        if (bookingId == 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid booking ID");
            return;
        }
        
        try {
            CheckInResult result = processManualCheckIn(bookingId, user.getUserId());
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            
            ApiResponse<CheckInResult> apiResponse = new ApiResponse<>();
            apiResponse.setSuccess(result.isSuccess());
            apiResponse.setData(result);
            apiResponse.setMessage(result.getMessage());
            
            out.write(gson.toJson(apiResponse));
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing manual check-in", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Internal server error\"}");
        }
    }
    
    /**
     * Handle QR validation (without check-in)
     */
    private void handleValidateQR(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        String qrData = request.getParameter("qrData");
        if (qrData == null || qrData.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "QR data is required");
            return;
        }
        
        try {
            QRValidationResult result = validateQRData(qrData);
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            
            ApiResponse<QRValidationResult> apiResponse = new ApiResponse<>();
            apiResponse.setSuccess(result.isValid());
            apiResponse.setData(result);
            apiResponse.setMessage(result.getMessage());
            
            out.write(gson.toJson(apiResponse));
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error validating QR", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Internal server error\"}");
        }
    }
    
    /**
     * Process QR code check-in
     */
    private CheckInResult processQRCheckIn(String qrData, int checkedInByUserId) {
        try {
            // Parse QR data (format: bookingId:securityToken)
            QRData parsedData = parseQRData(qrData);
            if (parsedData == null) {
                return new CheckInResult(false, "Invalid QR code format", null);
            }
            
            // Validate QR data
            QRValidationResult validation = validateQRData(qrData);
            if (!validation.isValid()) {
                return new CheckInResult(false, validation.getMessage(), null);
            }
            
            // Get booking
            Optional<Booking> bookingOpt = bookingDAO.findById(parsedData.getBookingId());
            if (bookingOpt.isEmpty()) {
                return new CheckInResult(false, "Booking not found", null);
            }
            Booking booking = bookingOpt.get();
            
            // Check if booking can be checked in
            String validationError = validateBookingForCheckIn(booking);
            if (validationError != null) {
                return new CheckInResult(false, validationError, null);
            }
            
            // Update booking status and set actual start time
            boolean success = updateBookingForCheckIn(booking, checkedInByUserId);
            if (success) {
                // Get updated booking with related data
                BookingDetails details = getBookingDetails(booking.getBookingId());
                
                // Log check-in activity
                LOGGER.info(String.format("Customer checked in: Booking ID %d, Customer: %s, Checked in by User ID: %d", 
                    booking.getBookingId(), details.getCustomerName(), checkedInByUserId));
                
                return new CheckInResult(true, "Check-in successful", details);
            } else {
                return new CheckInResult(false, "Failed to update booking status", null);
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing QR check-in", e);
            return new CheckInResult(false, "Internal error during check-in", null);
        }
    }

    /**
     * Process manual check-in
     */
    private CheckInResult processManualCheckIn(int bookingId, int checkedInByUserId) {
        try {
            Optional<Booking> bookingOpt = bookingDAO.findById(bookingId);
            if (bookingOpt.isEmpty()) {
                return new CheckInResult(false, "Booking not found", null);
            }
            Booking booking = bookingOpt.get();

            // Check if booking can be checked in
            String validationError = validateBookingForCheckIn(booking);
            if (validationError != null) {
                return new CheckInResult(false, validationError, null);
            }

            // Update booking status
            boolean success = updateBookingForCheckIn(booking, checkedInByUserId);
            if (success) {
                BookingDetails details = getBookingDetails(booking.getBookingId());

                LOGGER.info(String.format("Manual check-in: Booking ID %d, Customer: %s, Checked in by User ID: %d",
                    booking.getBookingId(), details.getCustomerName(), checkedInByUserId));

                return new CheckInResult(true, "Manual check-in successful", details);
            } else {
                return new CheckInResult(false, "Failed to update booking status", null);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing manual check-in", e);
            return new CheckInResult(false, "Internal error during manual check-in", null);
        }
    }

    /**
     * Parse QR data
     */
    private QRData parseQRData(String qrData) {
        try {
            // Expected format: bookingId:securityToken
            String[] parts = qrData.split(":");
            if (parts.length != 2) {
                return null;
            }

            int bookingId = Integer.parseInt(parts[0]);
            String securityToken = parts[1];

            return new QRData(bookingId, securityToken);

        } catch (NumberFormatException e) {
            return null;
        }
    }

    /**
     * Validate QR data
     */
    private QRValidationResult validateQRData(String qrData) {
        QRData parsedData = parseQRData(qrData);
        if (parsedData == null) {
            return new QRValidationResult(false, "Invalid QR code format", null);
        }

        try {
            // Get booking
            Optional<Booking> bookingOpt = bookingDAO.findById(parsedData.getBookingId());
            if (bookingOpt.isEmpty()) {
                return new QRValidationResult(false, "Booking not found", null);
            }
            Booking booking = bookingOpt.get();

            // Validate security token
            String expectedToken = generateSecurityToken(booking);
            if (!expectedToken.equals(parsedData.getSecurityToken())) {
                return new QRValidationResult(false, "Invalid security token", null);
            }

            // Get booking details
            BookingDetails details = getBookingDetails(booking.getBookingId());

            return new QRValidationResult(true, "QR code is valid", details);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error validating QR data", e);
            return new QRValidationResult(false, "Error validating QR code", null);
        }
    }

    /**
     * Validate booking for check-in
     */
    private String validateBookingForCheckIn(Booking booking) {
        // Check booking status
        if (booking.getBookingStatus() == Booking.BookingStatus.CANCELLED) {
            return "Booking has been cancelled";
        }

        if (booking.getBookingStatus() == Booking.BookingStatus.COMPLETED) {
            return "Booking has already been completed";
        }

        if (booking.getBookingStatus() == Booking.BookingStatus.IN_PROGRESS) {
            return "Customer has already checked in";
        }

        if (booking.getBookingStatus() == Booking.BookingStatus.NO_SHOW) {
            return "Booking was marked as no-show";
        }

        // Check appointment date (must be today)
        LocalDate today = LocalDate.now();
        LocalDate appointmentDate = booking.getAppointmentDate().toLocalDate();

        if (!appointmentDate.equals(today)) {
            if (appointmentDate.isBefore(today)) {
                return "Booking date has passed";
            } else {
                return "Booking is scheduled for a future date";
            }
        }

        // Check time window (allow check-in 30 minutes before to 2 hours after appointment time)
        LocalTime now = LocalTime.now();
        LocalTime appointmentTime = booking.getAppointmentTime().toLocalTime();
        LocalTime earliestCheckIn = appointmentTime.minusMinutes(30);
        LocalTime latestCheckIn = appointmentTime.plusHours(2);

        if (now.isBefore(earliestCheckIn)) {
            return "Too early for check-in. Please arrive within 30 minutes of your appointment time.";
        }

        if (now.isAfter(latestCheckIn)) {
            return "Check-in window has expired. Please contact reception.";
        }

        return null; // Valid for check-in
    }

    /**
     * Update booking for check-in
     */
    private boolean updateBookingForCheckIn(Booking booking, int checkedInByUserId) {
        try {
            // Update booking status to IN_PROGRESS
            booking.setBookingStatus(Booking.BookingStatus.IN_PROGRESS);

            // Note: actual_start_time field would need to be added to the database schema
            // For now, we'll use the booking_notes field to record check-in time
            String checkInNote = "Checked in at: " + new Timestamp(System.currentTimeMillis()) +
                                " by user ID: " + checkedInByUserId;

            if (booking.getBookingNotes() != null && !booking.getBookingNotes().trim().isEmpty()) {
                booking.setBookingNotes(booking.getBookingNotes() + "\n" + checkInNote);
            } else {
                booking.setBookingNotes(checkInNote);
            }

            // Update the booking
            bookingDAO.update(booking);

            return true;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating booking for check-in", e);
            return false;
        }
    }

    /**
     * Generate security token for booking
     */
    private String generateSecurityToken(Booking booking) {
        try {
            // Create token based on booking ID, customer ID, and appointment date
            String data = booking.getBookingId() + ":" + booking.getCustomerId() + ":" +
                         booking.getAppointmentDate() + ":" + "SPA_SECRET_KEY";

            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(data.getBytes("UTF-8"));

            // Convert to hex string and take first 8 characters
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }

            return hexString.toString().substring(0, 8).toUpperCase();

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error generating security token", e);
            return "INVALID";
        }
    }

    /**
     * Get booking details with related information
     */
    private BookingDetails getBookingDetails(int bookingId) {
        try {
            Optional<Booking> bookingOpt = bookingDAO.findById(bookingId);
            if (bookingOpt.isEmpty()) {
                return null;
            }
            Booking booking = bookingOpt.get();

            Customer customer = customerDAO.findById(booking.getCustomerId()).orElse(null);
            Service service = serviceDAO.findById(booking.getServiceId()).orElse(null);
            User therapist = userDAO.findById(booking.getTherapistUserId()).orElse(null);

            BookingDetails details = new BookingDetails();
            details.setBookingId(booking.getBookingId());
            details.setCustomerId(booking.getCustomerId());
            details.setCustomerName(customer != null ? customer.getFullName() : "Unknown");
            details.setCustomerPhone(customer != null ? customer.getPhoneNumber() : "");
            details.setServiceId(booking.getServiceId());
            details.setServiceName(service != null ? service.getName() : "Unknown Service");
            details.setTherapistId(booking.getTherapistUserId());
            details.setTherapistName(therapist != null ? therapist.getFullName() : "Unknown Therapist");
            details.setAppointmentDate(booking.getAppointmentDate());
            details.setAppointmentTime(booking.getAppointmentTime());
            details.setDurationMinutes(booking.getDurationMinutes());
            details.setBookingStatus(booking.getBookingStatus().name());
            details.setBookingNotes(booking.getBookingNotes());

            return details;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting booking details", e);
            return null;
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

    // Inner classes for data transfer

    /**
     * QR Data structure
     */
    private static class QRData {
        private final int bookingId;
        private final String securityToken;

        public QRData(int bookingId, String securityToken) {
            this.bookingId = bookingId;
            this.securityToken = securityToken;
        }

        public int getBookingId() { return bookingId; }
        public String getSecurityToken() { return securityToken; }
    }

    /**
     * Check-in result
     */
    public static class CheckInResult {
        private boolean success;
        private String message;
        private BookingDetails bookingDetails;

        public CheckInResult(boolean success, String message, BookingDetails bookingDetails) {
            this.success = success;
            this.message = message;
            this.bookingDetails = bookingDetails;
        }

        // Getters and setters
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        public BookingDetails getBookingDetails() { return bookingDetails; }
        public void setBookingDetails(BookingDetails bookingDetails) { this.bookingDetails = bookingDetails; }
    }

    /**
     * QR validation result
     */
    public static class QRValidationResult {
        private boolean valid;
        private String message;
        private BookingDetails bookingDetails;

        public QRValidationResult(boolean valid, String message, BookingDetails bookingDetails) {
            this.valid = valid;
            this.message = message;
            this.bookingDetails = bookingDetails;
        }

        // Getters and setters
        public boolean isValid() { return valid; }
        public void setValid(boolean valid) { this.valid = valid; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        public BookingDetails getBookingDetails() { return bookingDetails; }
        public void setBookingDetails(BookingDetails bookingDetails) { this.bookingDetails = bookingDetails; }
    }

    /**
     * Booking details for display
     */
    public static class BookingDetails {
        private int bookingId;
        private int customerId;
        private String customerName;
        private String customerPhone;
        private int serviceId;
        private String serviceName;
        private int therapistId;
        private String therapistName;
        private Date appointmentDate;
        private java.sql.Time appointmentTime;
        private int durationMinutes;
        private String bookingStatus;
        private String bookingNotes;

        // Getters and setters
        public int getBookingId() { return bookingId; }
        public void setBookingId(int bookingId) { this.bookingId = bookingId; }
        public int getCustomerId() { return customerId; }
        public void setCustomerId(int customerId) { this.customerId = customerId; }
        public String getCustomerName() { return customerName; }
        public void setCustomerName(String customerName) { this.customerName = customerName; }
        public String getCustomerPhone() { return customerPhone; }
        public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }
        public int getServiceId() { return serviceId; }
        public void setServiceId(int serviceId) { this.serviceId = serviceId; }
        public String getServiceName() { return serviceName; }
        public void setServiceName(String serviceName) { this.serviceName = serviceName; }
        public int getTherapistId() { return therapistId; }
        public void setTherapistId(int therapistId) { this.therapistId = therapistId; }
        public String getTherapistName() { return therapistName; }
        public void setTherapistName(String therapistName) { this.therapistName = therapistName; }
        public Date getAppointmentDate() { return appointmentDate; }
        public void setAppointmentDate(Date appointmentDate) { this.appointmentDate = appointmentDate; }
        public java.sql.Time getAppointmentTime() { return appointmentTime; }
        public void setAppointmentTime(java.sql.Time appointmentTime) { this.appointmentTime = appointmentTime; }
        public int getDurationMinutes() { return durationMinutes; }
        public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }
        public String getBookingStatus() { return bookingStatus; }
        public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }
        public String getBookingNotes() { return bookingNotes; }
        public void setBookingNotes(String bookingNotes) { this.bookingNotes = bookingNotes; }
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
