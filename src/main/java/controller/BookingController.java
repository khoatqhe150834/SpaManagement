package controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

import dao.BookingDAO;
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
import model.Booking;
import model.PaymentItem;
import model.PaymentItemUsage;
import model.User;

@WebServlet(name = "BookingController", urlPatterns = {
    "/booking",
    "/customer/booking",
    "/customer/book-service",
    "/customer/booking-history"
})
public class BookingController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(BookingController.class.getName());

    private BookingDAO bookingDAO;
    private PaymentItemDAO paymentItemDAO;
    private PaymentItemUsageDAO paymentItemUsageDAO;
    private UserDAO userDAO;
    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.bookingDAO = new BookingDAO();
        this.paymentItemDAO = new PaymentItemDAO();
        this.paymentItemUsageDAO = new PaymentItemUsageDAO();
        this.userDAO = new UserDAO();
        this.serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getServletPath();

        switch (pathInfo) {
            case "/customer/booking":
            case "/customer/book-service":
                handleCustomerBookingPage(request, response);
                break;
            case "/customer/booking-history":
                handleCustomerBookingHistory(request, response);
                break;
            case "/booking":
            default:
                // Legacy booking page
                request.getRequestDispatcher("/WEB-INF/view/booking-multistep.jsp")
                    .forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getServletPath();

        switch (pathInfo) {
            case "/customer/booking":
            case "/customer/book-service":
                // Check if this is a cancellation request
                String action = request.getParameter("action");
                if ("cancel".equals(action)) {
                    handleBookingCancellation(request, response);
                } else {
                    handleBookingSubmission(request, response);
                }
                break;
            case "/customer/booking-history":
                // Handle AJAX cancellation requests from booking history page
                String historyAction = request.getParameter("action");
                if ("cancel".equals(historyAction)) {
                    handleBookingCancellation(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                }
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/booking");
                break;
        }
    }

    private void handleCustomerBookingPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");
        String userRole = (String) session.getAttribute("userRole");

        // Check authentication
        if (customerId == null || !"CUSTOMER".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get customer's paid services that still have remaining usage
            List<PaymentItem> availableServices = paymentItemDAO.findByCustomerId(customerId);

            // Filter to only show services with remaining usage
            availableServices = availableServices.stream()
                .filter(item -> {
                    try {
                        var usageOpt = paymentItemUsageDAO.findByPaymentItemId(item.getPaymentItemId());
                        if (usageOpt.isPresent()) {
                            return usageOpt.get().getRemainingQuantity() > 0;
                        } else {
                            return item.getQuantity() > 0; // No usage record means all quantity available
                        }
                    } catch (SQLException e) {
                        LOGGER.log(Level.WARNING, "Error checking usage for payment item: " + item.getPaymentItemId(), e);
                        return false;
                    }
                })
                .collect(Collectors.toList());

            // Get available therapists (role_id = 3 for THERAPIST)
            List<User> therapists = userDAO.findByRoleId(3, 1, 100); // Get first 100 therapists

            // Set request attributes
            request.setAttribute("availableServices", availableServices);
            request.setAttribute("therapists", therapists);
            request.setAttribute("pageTitle", "Đặt Lịch Dịch Vụ - BeautyZone Spa");

            // Forward to customer booking page
            request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp")
                    .forward(request, response);

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error loading booking page", ex);
            request.setAttribute("errorMessage", "Lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/view/common/error.jsp")
                    .forward(request, response);
        }
    }

    private void handleBookingSubmission(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");
        String userRole = (String) session.getAttribute("userRole");

        // Check authentication
        if (customerId == null || !"CUSTOMER".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get form parameters
            String paymentItemIdStr = request.getParameter("paymentItemId");
            String therapistIdStr = request.getParameter("therapistId");
            String appointmentDateStr = request.getParameter("appointmentDate");
            String appointmentTimeStr = request.getParameter("appointmentTime");
            String notes = request.getParameter("notes");

            // Validate parameters
            if (paymentItemIdStr == null || therapistIdStr == null ||
                appointmentDateStr == null || appointmentTimeStr == null) {
                request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin đặt lịch.");
                handleCustomerBookingPage(request, response);
                return;
            }

            int paymentItemId = Integer.parseInt(paymentItemIdStr);
            int therapistId = Integer.parseInt(therapistIdStr);

            // Get payment item and validate ownership
            var paymentItemOpt = paymentItemDAO.findById(paymentItemId);
            if (paymentItemOpt.isEmpty()) {
                request.setAttribute("errorMessage", "Dịch vụ không tồn tại.");
                handleCustomerBookingPage(request, response);
                return;
            }

            PaymentItem paymentItem = paymentItemOpt.get();

            // Verify customer owns this payment item
            if (!paymentItem.getPayment().getCustomerId().equals(customerId)) {
                request.setAttribute("errorMessage", "Bạn không có quyền đặt lịch cho dịch vụ này.");
                handleCustomerBookingPage(request, response);
                return;
            }

            // Check remaining usage
            var usageOpt = paymentItemUsageDAO.findByPaymentItemId(paymentItemId);
            PaymentItemUsage usage = usageOpt.orElse(null);

            if (usage != null && usage.getRemainingQuantity() <= 0) {
                request.setAttribute("errorMessage", "Dịch vụ này đã được sử dụng hết.");
                handleCustomerBookingPage(request, response);
                return;
            }

            // Parse date and time
            LocalDate appointmentDate = LocalDate.parse(appointmentDateStr);
            LocalTime appointmentTime = LocalTime.parse(appointmentTimeStr);

            // Create booking
            Booking booking = new Booking();
            booking.setCustomerId(customerId);
            booking.setPaymentItemId(paymentItemId);
            booking.setServiceId(paymentItem.getServiceId());
            booking.setTherapistUserId(therapistId);
            booking.setAppointmentDate(Date.valueOf(appointmentDate));
            booking.setAppointmentTime(Time.valueOf(appointmentTime));
            booking.setDurationMinutes(paymentItem.getServiceDuration());
            booking.setBookingStatus(Booking.BookingStatus.SCHEDULED);
            booking.setBookingNotes(notes);

            // Save booking
            booking = bookingDAO.save(booking);

            // Update usage if exists, or create new usage record
            if (usage != null) {
                usage.setBookedQuantity(usage.getBookedQuantity() + 1);
                paymentItemUsageDAO.update(usage);
            } else {
                // Create new usage record
                usage = new PaymentItemUsage();
                usage.setPaymentItemId(paymentItemId);
                usage.setTotalQuantity(paymentItem.getQuantity());
                usage.setBookedQuantity(1);
                paymentItemUsageDAO.save(usage);
            }

            // Success - redirect to booking confirmation or customer dashboard
            session.setAttribute("successMessage", "Đặt lịch thành công! Mã đặt lịch: #" + booking.getBookingId());
            response.sendRedirect(request.getContextPath() + "/customer/dashboard");

        } catch (NumberFormatException ex) {
            request.setAttribute("errorMessage", "Thông tin đặt lịch không hợp lệ.");
            handleCustomerBookingPage(request, response);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error creating booking", ex);
            request.setAttribute("errorMessage", "Lỗi hệ thống. Vui lòng thử lại sau.");
            handleCustomerBookingPage(request, response);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error creating booking", ex);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau.");
            handleCustomerBookingPage(request, response);
        }
    }

    /**
     * Handles customer booking history page
     */
    private void handleCustomerBookingHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");
        String userRole = (String) session.getAttribute("userRole");

        // Check authentication
        if (customerId == null || !"CUSTOMER".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get pagination parameters
            int page = 1;
            int pageSize = 10;

            String pageParam = request.getParameter("page");
            String pageSizeParam = request.getParameter("pageSize");

            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeParam);
                    if (pageSize < 5) pageSize = 5;
                    if (pageSize > 50) pageSize = 50;
                } catch (NumberFormatException e) {
                    pageSize = 10;
                }
            }

            // Get filter parameters
            String statusFilter = request.getParameter("status");
            String dateFromParam = request.getParameter("dateFrom");
            String dateToParam = request.getParameter("dateTo");

            Date dateFrom = null;
            Date dateTo = null;

            if (dateFromParam != null && !dateFromParam.isEmpty()) {
                try {
                    dateFrom = Date.valueOf(dateFromParam);
                } catch (IllegalArgumentException e) {
                    // Invalid date format, ignore
                }
            }

            if (dateToParam != null && !dateToParam.isEmpty()) {
                try {
                    dateTo = Date.valueOf(dateToParam);
                } catch (IllegalArgumentException e) {
                    // Invalid date format, ignore
                }
            }

            // Get customer's bookings with pagination and filters
            List<Booking> bookings = bookingDAO.findByCustomerIdWithFilters(
                customerId, statusFilter, dateFrom, dateTo, page, pageSize);

            // Get total count for pagination
            int totalBookings = bookingDAO.countByCustomerIdWithFilters(
                customerId, statusFilter, dateFrom, dateTo);

            int totalPages = (int) Math.ceil((double) totalBookings / pageSize);

            // Get booking statistics for the customer
            Map<String, Integer> bookingStats = bookingDAO.getBookingStatsByCustomerId(customerId);

            // Set request attributes
            request.setAttribute("bookings", bookings);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("bookingStats", bookingStats);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("dateFrom", dateFromParam);
            request.setAttribute("dateTo", dateToParam);
            request.setAttribute("pageTitle", "Lịch Sử Đặt Lịch - BeautyZone Spa");

            // Forward to booking history JSP
            request.getRequestDispatcher("/WEB-INF/view/customer/booking-history.jsp")
                    .forward(request, response);

        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error loading booking history", ex);
            request.setAttribute("errorMessage", "Lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/view/common/error.jsp")
                    .forward(request, response);
        }
    }

    /**
     * Handles booking cancellation requests
     */
    private void handleBookingCancellation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");
        String userRole = (String) session.getAttribute("userRole");

        // Check authentication
        if (customerId == null || !"CUSTOMER".equals(userRole)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Unauthorized access\"}");
            return;
        }

        try {
            // Get booking ID parameter
            String bookingIdStr = request.getParameter("bookingId");

            if (bookingIdStr == null || bookingIdStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Booking ID is required\"}");
                return;
            }

            int bookingId = Integer.parseInt(bookingIdStr);

            // Get the booking to verify ownership and status
            var bookingOpt = bookingDAO.findById(bookingId);
            if (bookingOpt.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"success\": false, \"message\": \"Booking not found\"}");
                return;
            }

            Booking booking = bookingOpt.get();

            // Verify customer owns this booking
            if (!booking.getCustomerId().equals(customerId)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"success\": false, \"message\": \"You can only cancel your own bookings\"}");
                return;
            }

            // Check if booking can be cancelled (only SCHEDULED bookings can be cancelled)
            if (!Booking.BookingStatus.SCHEDULED.equals(booking.getBookingStatus())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Only scheduled bookings can be cancelled\"}");
                return;
            }

            // Update booking status to CANCELLED
            booking.setBookingStatus(Booking.BookingStatus.CANCELLED);
            booking.setBookingNotes(booking.getBookingNotes() + " [Cancelled by customer]");

            // Save the updated booking
            bookingDAO.update(booking);

            // Update payment item usage (restore the used quantity)
            if (booking.getPaymentItemId() != null) {
                var usageOpt = paymentItemUsageDAO.findByPaymentItemId(booking.getPaymentItemId());
                if (usageOpt.isPresent()) {
                    PaymentItemUsage usage = usageOpt.get();
                    usage.setBookedQuantity(usage.getBookedQuantity() - 1);
                    paymentItemUsageDAO.update(usage);
                }
            }

            // Return success response
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"message\": \"Booking cancelled successfully\"}");

        } catch (NumberFormatException ex) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid booking ID format\"}");
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error cancelling booking", ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Database error occurred\"}");
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error cancelling booking", ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"An unexpected error occurred\"}");
        }
    }
}
