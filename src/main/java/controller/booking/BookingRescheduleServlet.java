package controller.booking;

import booking.AvailableTimeSlot;
import booking.PaymentItemDetails;
import booking.SpaCspSolver;
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
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import model.Booking;

@WebServlet(name = "BookingRescheduleServlet", urlPatterns = {"/customer/reschedule/*", "/manager/reschedule/*"})
public class BookingRescheduleServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BookingRescheduleServlet.class.getName());
    
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
        
        // Configure Gson for LocalDateTime serialization (same as BookingServlet)
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
        
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");
        Integer userRoleId = (Integer) session.getAttribute("userRoleId");
        
        // Check authorization
        if (customerId == null && userRoleId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Extract booking ID from URL path
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendRedirect(request.getContextPath() + "/customer/show-bookings");
            return;
        }
        
        try {
            Integer bookingId = Integer.parseInt(pathInfo.substring(1));
            
            String action = request.getParameter("action");
            LOGGER.info("BookingRescheduleServlet doGet - Booking ID: " + bookingId + ", Action: " + action);
            
            switch (action != null ? action : "showRescheduleForm") {
                case "getAvailableSlots":
                    LOGGER.info("Handling getAvailableSlots request for reschedule");
                    getAvailableSlotsForReschedule(request, response, customerId, userRoleId, bookingId);
                    break;
                case "getAvailableResources":
                    LOGGER.info("Handling getAvailableResources request for reschedule");
                    getAvailableResourcesForReschedule(request, response, customerId, userRoleId, bookingId);
                    break;
                case "showRescheduleForm":
                default:
                    LOGGER.info("Handling showRescheduleForm request");
                    showRescheduleForm(request, response, customerId, userRoleId, bookingId);
                    break;
            }
            
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid booking ID in URL: " + pathInfo);
            response.sendRedirect(request.getContextPath() + "/customer/show-bookings");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in BookingRescheduleServlet doGet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");
        Integer userRoleId = (Integer) session.getAttribute("userRoleId");
        
        // Check authorization
        if (customerId == null && userRoleId == null) {
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
            LOGGER.info("BookingRescheduleServlet doPost - Booking ID: " + bookingId);
            
            String action = request.getParameter("action");
            if ("rescheduleBooking".equals(action)) {
                LOGGER.info("Calling rescheduleBooking method");
                handleRescheduleBooking(request, response, customerId, userRoleId, bookingId);
            } else {
                LOGGER.warning("Invalid action received: " + action);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            sendJsonError(response, "Invalid booking ID");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in BookingRescheduleServlet doPost", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }
    
    private void showRescheduleForm(HttpServletRequest request, HttpServletResponse response,
                                  Integer customerId, Integer userRoleId, Integer bookingId) 
                                  throws ServletException, IOException {
        try {
            // Get booking details
            Optional<Booking> bookingOpt = bookingDAO.findById(bookingId);
            if (bookingOpt.isEmpty()) {
                request.setAttribute("error", "Đặt lịch không tồn tại");
                request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp")
                       .forward(request, response);
                return;
            }
            
            Booking booking = bookingOpt.get();
            
            // Check access permissions
            boolean hasAccess = false;
            if (customerId != null && booking.getCustomerId().equals(customerId)) {
                hasAccess = true; // Customer accessing their own booking
            } else if (userRoleId != null && (userRoleId == 2 || userRoleId == 3)) {
                hasAccess = true; // Manager or admin accessing any booking
            }
            
            if (!hasAccess) {
                request.setAttribute("error", "Bạn không có quyền thay đổi lịch hẹn này");
                request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp")
                       .forward(request, response);
                return;
            }
            
            // Check if booking can be rescheduled
            if (!canBeRescheduled(booking.getBookingStatus())) {
                request.setAttribute("error", "Lịch hẹn này không thể thay đổi. Trạng thái hiện tại: " + 
                                    booking.getBookingStatus().getDisplayName());
                request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp")
                       .forward(request, response);
                return;
            }
            
            // Get payment item details if available
            PaymentItemDetails paymentItem = null;
            if (booking.getPaymentItemId() != null) {
                try {
                    paymentItem = bookingDAO.getPaymentItemForBooking(booking.getPaymentItemId());
                } catch (SQLException e) {
                    LOGGER.log(Level.WARNING, "Could not load payment item details", e);
                }
            }
            
            // Set request attributes
            request.setAttribute("booking", booking);
            request.setAttribute("paymentItem", paymentItem);
            request.setAttribute("customerId", booking.getCustomerId());
            request.setAttribute("isManagerAccess", userRoleId != null && userRoleId >= 2);
            
            // Forward to reschedule page (reuse booking.jsp with reschedule mode)
            request.setAttribute("rescheduleMode", true);
            request.setAttribute("originalBookingId", bookingId);
            
            request.getRequestDispatcher("/reschedule.jsp").forward(request, response);
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error while loading reschedule form", ex);
            request.setAttribute("error", "Lỗi cơ sở dữ liệu. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp")
                   .forward(request, response);
        }
    }
    
    private void getAvailableSlotsForReschedule(HttpServletRequest request, HttpServletResponse response,
                                              Integer customerId, Integer userRoleId, Integer bookingId) 
                                              throws IOException, SQLException {
        
        String dateStr = request.getParameter("date");
        
        LOGGER.info("getAvailableSlotsForReschedule called with bookingId: " + bookingId + ", date: " + dateStr);
        
        if (dateStr == null) {
            LOGGER.warning("Missing required parameter: date");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameter: date");
            return;
        }
        
        // Get booking details
        Optional<Booking> bookingOpt = bookingDAO.findById(bookingId);
        if (bookingOpt.isEmpty()) {
            LOGGER.warning("Booking not found: " + bookingId);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found");
            return;
        }
        
        Booking booking = bookingOpt.get();
        
        // Check access permissions
        boolean hasAccess = false;
        if (customerId != null && booking.getCustomerId().equals(customerId)) {
            hasAccess = true;
        } else if (userRoleId != null && userRoleId >= 2) {
            hasAccess = true;
        }
        
        if (!hasAccess) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        LocalDate selectedDate = LocalDate.parse(dateStr);
        
        LOGGER.info("Found booking for service ID: " + booking.getServiceId() + " with customer: " + booking.getCustomerId());
        
        // Use CSP solver to find available slots, same as main booking system
        List<AvailableTimeSlot> availableSlots = cspSolver.findAvailableSlots(
            selectedDate, booking.getServiceId(), 50);
        
        LOGGER.info("CSP solver returned " + availableSlots.size() + " available slots for reschedule");
        
        // Filter out slots that conflict with customer's OTHER bookings (exclude current booking)
        List<AvailableTimeSlot> filteredSlots = filterCustomerConflictsForReschedule(
            availableSlots, booking.getCustomerId(), selectedDate, booking.getDurationMinutes(), bookingId);
        
        int removedSlots = availableSlots.size() - filteredSlots.size();
        if (removedSlots > 0) {
            LOGGER.info("Filtered out " + removedSlots + " slots due to customer conflicts (excluding current booking)");
        }
        
        // Prepare response data
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("booking", booking);
        responseData.put("selectedDate", selectedDate);
        responseData.put("availableSlots", filteredSlots);
        responseData.put("totalSlots", filteredSlots.size());
        responseData.put("originalBookingTime", booking.getAppointmentTime().toLocalTime());
        responseData.put("originalBookingDate", booking.getAppointmentDate().toLocalDate());
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(responseData));
        }
        
        LOGGER.info("Response sent with " + filteredSlots.size() + " available slots for reschedule of booking " +
                   bookingId + " on " + selectedDate);
    }
    
    private void getAvailableResourcesForReschedule(HttpServletRequest request, HttpServletResponse response,
                                                  Integer customerId, Integer userRoleId, Integer bookingId) 
                                                  throws IOException, SQLException {
        
        String dateStr = request.getParameter("date");
        String timeStr = request.getParameter("time");
        
        LOGGER.info("getAvailableResourcesForReschedule called with bookingId: " + bookingId +
                   ", date: " + dateStr + ", time: " + timeStr);
        
        if (dateStr == null || timeStr == null) {
            LOGGER.warning("Missing required parameters for getAvailableResourcesForReschedule");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }
        
        // Get booking details
        Optional<Booking> bookingOpt = bookingDAO.findById(bookingId);
        if (bookingOpt.isEmpty()) {
            LOGGER.warning("Booking not found: " + bookingId);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found");
            return;
        }
        
        Booking booking = bookingOpt.get();
        
        // Check access permissions
        boolean hasAccess = false;
        if (customerId != null && booking.getCustomerId().equals(customerId)) {
            hasAccess = true;
        } else if (userRoleId != null && userRoleId >= 2) {
            hasAccess = true;
        }
        
        if (!hasAccess) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        LocalDate selectedDate;
        LocalTime selectedTime;
        
        try {
            selectedDate = LocalDate.parse(dateStr);
            selectedTime = LocalTime.parse(timeStr);
        } catch (DateTimeParseException e) {
            LOGGER.log(Level.WARNING, "Invalid parameter format in getAvailableResourcesForReschedule", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameter format: " + e.getMessage());
            return;
        }
        
        // Find available slots for the specific time using CSP solver
        List<AvailableTimeSlot> availableSlots = cspSolver.findAvailableSlots(
            selectedDate, booking.getServiceId(), 100);
        
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
            responseData.put("originalTherapistId", booking.getTherapistUserId());
            responseData.put("originalRoomId", booking.getRoomId());
            responseData.put("originalBedId", booking.getBedId());
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
    
    private void handleRescheduleBooking(HttpServletRequest request, HttpServletResponse response,
                                       Integer customerId, Integer userRoleId, Integer bookingId) 
                                       throws IOException {
        
        LOGGER.info("handleRescheduleBooking called with parameters:");
        LOGGER.info("bookingId: " + bookingId);
        LOGGER.info("newDate: " + request.getParameter("newDate"));
        LOGGER.info("newTime: " + request.getParameter("newTime"));
        LOGGER.info("newTherapistId: " + request.getParameter("newTherapistId"));
        LOGGER.info("newRoomId: " + request.getParameter("newRoomId"));
        LOGGER.info("newBedId: " + request.getParameter("newBedId"));
        
        try {
            // Parse request parameters
            String newDateStr = request.getParameter("newDate");
            String newTimeStr = request.getParameter("newTime");
            String newTherapistIdStr = request.getParameter("newTherapistId");
            String newRoomIdStr = request.getParameter("newRoomId");
            String newBedIdStr = request.getParameter("newBedId");
            String rescheduleReason = request.getParameter("reason");
            
            if (newDateStr == null || newTimeStr == null || newTherapistIdStr == null || newRoomIdStr == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                sendJsonError(response, "Thiếu thông tin bắt buộc để thay đổi lịch hẹn");
                return;
            }
            
            LocalDate newDate = LocalDate.parse(newDateStr);
            LocalTime newTime = LocalTime.parse(newTimeStr);
            Integer newTherapistId = Integer.parseInt(newTherapistIdStr);
            Integer newRoomId = Integer.parseInt(newRoomIdStr);
            Integer newBedId = newBedIdStr != null && !newBedIdStr.isEmpty() ?
                              Integer.parseInt(newBedIdStr) : null;
            
            // Get existing booking
            Optional<Booking> bookingOpt = bookingDAO.findById(bookingId);
            if (bookingOpt.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                sendJsonError(response, "Đặt lịch không tồn tại");
                return;
            }
            
            Booking booking = bookingOpt.get();
            
            // Check access permissions
            boolean hasAccess = false;
            if (customerId != null && booking.getCustomerId().equals(customerId)) {
                hasAccess = true;
            } else if (userRoleId != null && userRoleId >= 2) {
                hasAccess = true;
            }
            
            if (!hasAccess) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                sendJsonError(response, "Bạn không có quyền thay đổi lịch hẹn này");
                return;
            }
            
            // Check if booking can be rescheduled
            if (!canBeRescheduled(booking.getBookingStatus())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                sendJsonError(response, "Lịch hẹn này không thể thay đổi. Trạng thái hiện tại: " + 
                            booking.getBookingStatus().getDisplayName());
                return;
            }
            
            // Validate new date is not in the past (allow same day)
            if (newDate.isBefore(LocalDate.now())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                sendJsonError(response, "Không thể đặt lịch vào ngày trong quá khứ");
                return;
            }
            
            // Store original booking details for logging
            LocalDate originalDate = booking.getAppointmentDate().toLocalDate();
            LocalTime originalTime = booking.getAppointmentTime().toLocalTime();
            Integer originalTherapistId = booking.getTherapistUserId();
            Integer originalRoomId = booking.getRoomId();
            Integer originalBedId = booking.getBedId();
            
            // Update the booking
            booking.setAppointmentDate(Date.valueOf(newDate));
            booking.setAppointmentTime(Time.valueOf(newTime));
            booking.setTherapistUserId(newTherapistId);
            booking.setRoomId(newRoomId);
            booking.setBedId(newBedId);
            
            // Add reschedule reason to notes
            String currentNotes = booking.getBookingNotes() != null ? booking.getBookingNotes() : "";
            String rescheduleNote = "\n[" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) + "] " +
                                  "Lịch hẹn được thay đổi từ " + originalDate + " " + originalTime +
                                  " sang " + newDate + " " + newTime;
            
            if (rescheduleReason != null && !rescheduleReason.trim().isEmpty()) {
                rescheduleNote += ". Lý do: " + rescheduleReason.trim();
            }
            
            String updatedBy = customerId != null ? "khách hàng" : "quản lý";
            rescheduleNote += " (bởi " + updatedBy + ")";
            
            booking.setBookingNotes(currentNotes + rescheduleNote);
            
            // Save the updated booking using the same method as main booking system
            bookingDAO.update(booking);
            
            // Prepare success response
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", true);
            responseData.put("message", "Thay đổi lịch hẹn thành công!");
            responseData.put("bookingId", bookingId);
            responseData.put("originalDate", originalDate);
            responseData.put("originalTime", originalTime);
            responseData.put("newDate", newDate);
            responseData.put("newTime", newTime);
            responseData.put("serviceName", booking.getService() != null ? booking.getService().getName() : "N/A");
            responseData.put("serviceDuration", booking.getDurationMinutes());
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(responseData));
            }
            
            LOGGER.info("Successfully rescheduled booking ID: " + bookingId + 
                       " from " + originalDate + " " + originalTime + 
                       " to " + newDate + " " + newTime + 
                       " by " + (customerId != null ? "customer " + customerId : "manager"));
            
        } catch (DateTimeParseException | NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid parameter format in reschedule", e);
            
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Định dạng tham số không hợp lệ: " + e.getMessage());
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(errorResponse));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error rescheduling booking", e);
            
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", getUserFriendlyErrorMessage(e));
            errorResponse.put("sqlState", e.getSQLState());
            errorResponse.put("errorCode", e.getErrorCode());
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(errorResponse));
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error rescheduling booking", e);
            
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi không mong muốn: " + e.getMessage());
            errorResponse.put("errorType", e.getClass().getSimpleName());
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(errorResponse));
            }
        }
    }
    
    /**
     * Filter out time slots that conflict with customer's existing bookings
     * Similar to main booking system but excludes the current booking being rescheduled
     */
    private List<AvailableTimeSlot> filterCustomerConflictsForReschedule(List<AvailableTimeSlot> availableSlots,
                                                                        int customerId, LocalDate selectedDate,
                                                                        int serviceDuration, int excludeBookingId) 
                                                                        throws SQLException {
        
        // Get customer's existing bookings for the selected date
        List<Booking> customerBookings = bookingDAO.findByCustomerAndDate(customerId, selectedDate);
        
        // Filter out cancelled, no-show bookings, and the booking being rescheduled
        List<Booking> activeBookings = customerBookings.stream()
            .filter(booking -> booking.getBookingStatus() != Booking.BookingStatus.CANCELLED &&
                             booking.getBookingStatus() != Booking.BookingStatus.NO_SHOW &&
                             !booking.getBookingId().equals(excludeBookingId)) // Exclude current booking
            .collect(Collectors.toList());
        
        if (activeBookings.isEmpty()) {
            LOGGER.info("No conflicting customer bookings found for date " + selectedDate + 
                       " (excluding booking " + excludeBookingId + ")");
            return availableSlots;
        }
        
        LOGGER.info("Found " + activeBookings.size() + " active customer bookings to check for conflicts " +
                   "(excluding booking " + excludeBookingId + ")");
        
        List<AvailableTimeSlot> filteredSlots = new ArrayList<>();
        
        for (AvailableTimeSlot slot : availableSlots) {
            boolean hasConflict = false;
            
            // Calculate the proposed booking time range
            LocalDateTime slotStart = slot.getTimeSlot().getStartTime();
            LocalDateTime slotEnd = slotStart.plusMinutes(serviceDuration);
            
            // Check against each existing booking
            for (Booking existingBooking : activeBookings) {
                LocalDateTime bookingStart = LocalDateTime.of(
                    existingBooking.getAppointmentDate().toLocalDate(),
                    existingBooking.getAppointmentTime().toLocalTime()
                );
                LocalDateTime bookingEnd = bookingStart.plusMinutes(existingBooking.getDurationMinutes());
                
                // Check for time overlap
                if (!(slotEnd.isBefore(bookingStart) || slotStart.isAfter(bookingEnd))) {
                    hasConflict = true;
                    LOGGER.fine("Slot " + slotStart + "-" + slotEnd + " conflicts with existing booking " +
                              bookingStart + "-" + bookingEnd + " (Booking ID: " + existingBooking.getBookingId() + ")");
                    break;
                }
            }
            
            if (!hasConflict) {
                filteredSlots.add(slot);
            }
        }
        
        return filteredSlots;
    }
    
    private boolean canBeRescheduled(Booking.BookingStatus status) {
        return status == Booking.BookingStatus.SCHEDULED || 
               status == Booking.BookingStatus.CONFIRMED;
    }
    
    /**
     * Convert database constraint violations to user-friendly messages
     * Same as main booking system
     */
    private String getUserFriendlyErrorMessage(SQLException e) {
        int errorCode = e.getErrorCode();
        String errorMessage = e.getMessage().toLowerCase();
        
        // Handle MySQL constraint violations (Error Code 1062 = Duplicate entry)
        if (errorCode == 1062) {
            if (errorMessage.contains("uk_therapist_no_overlap")) {
                return "Nhân viên này đã có lịch hẹn vào thời gian đã chọn. Vui lòng chọn thời gian khác hoặc nhân viên khác.";
            } else if (errorMessage.contains("uk_bed_no_overlap")) {
                return "Giường này đã được đặt vào thời gian đã chọn. Vui lòng chọn giường khác hoặc thời gian khác.";
            } else if (errorMessage.contains("uk_room_single_bed_no_overlap")) {
                return "Phòng này đã được đặt vào thời gian đã chọn. Vui lòng chọn phòng khác hoặc thời gian khác.";
            } else {
                return "Thời gian đã chọn không khả dụng. Vui lòng chọn thời gian khác.";
            }
        }
        
        // Handle other common database errors
        switch (errorCode) {
            case 1452: // Foreign key constraint fails
                return "Dữ liệu tham chiếu không hợp lệ. Vui lòng kiểm tra lại thông tin đặt lịch.";
            case 1048: // Column cannot be null
                return "Thiếu thông tin bắt buộc. Vui lòng điền đầy đủ thông tin.";
            case 1406: // Data too long for column
                return "Thông tin nhập vào quá dài. Vui lòng rút gọn nội dung.";
            default:
                // For unknown errors, provide a generic message
                return "Không thể thay đổi lịch hẹn. Vui lòng thử lại sau hoặc liên hệ hỗ trợ.";
        }
    }
    
    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("success", false);
        errorResponse.put("error", message);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(errorResponse));
        }
    }
}