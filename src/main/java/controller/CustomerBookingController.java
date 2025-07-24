package controller;

import dao.BookingDAO;
import dao.PaymentDAO;
import dao.ServiceDAO;
import model.Booking;
import model.Customer;
import model.User;
import util.DBContext;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Controller for handling customer booking views and management
 */
@WebServlet(name = "CustomerBookingController", urlPatterns = {
    "/customer/bookings",
    "/customer/bookings/details",
    "/customer/bookings/cancel"
})
public class CustomerBookingController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(CustomerBookingController.class.getName());
    
    private BookingDAO bookingDAO;
    private PaymentDAO paymentDAO;
    private ServiceDAO serviceDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            this.bookingDAO = new BookingDAO();
            this.paymentDAO = new PaymentDAO();
            this.serviceDAO = new ServiceDAO();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error initializing CustomerBookingController", e);
            throw new ServletException("Failed to initialize controller", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Customer customer = (Customer) session.getAttribute("customer");
        String pathInfo = request.getPathInfo();
        String servletPath = request.getServletPath();
        
        try {
            if (servletPath.equals("/customer/bookings")) {
                if (pathInfo == null || pathInfo.equals("/")) {
                    handleBookingsList(request, response, customer);
                } else if (pathInfo.equals("/details")) {
                    handleBookingDetails(request, response, customer);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in CustomerBookingController", e);
            request.setAttribute("errorMessage", "Lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/view/common/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Customer customer = (Customer) session.getAttribute("customer");
        String servletPath = request.getServletPath();
        
        try {
            if (servletPath.equals("/customer/bookings/cancel")) {
                handleBookingCancellation(request, response, customer);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in CustomerBookingController POST", e);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi hệ thống\"}");
        }
    }
    
    /**
     * Handle customer bookings list page
     */
    private void handleBookingsList(HttpServletRequest request, HttpServletResponse response, Customer customer) 
            throws ServletException, IOException, SQLException {
        
        Integer customerId = customer.getCustomerId();
        
        // Get filter parameters
        String statusFilter = request.getParameter("status");
        String dateFromStr = request.getParameter("dateFrom");
        String dateToStr = request.getParameter("dateTo");
        
        // Get all bookings for the customer
        List<Booking> allBookings = bookingDAO.findByCustomerId(customerId);
        
        // Apply filters if provided
        List<Booking> filteredBookings = allBookings;
        if (statusFilter != null && !statusFilter.isEmpty()) {
            filteredBookings = filteredBookings.stream()
                .filter(booking -> booking.getBookingStatus().toString().equals(statusFilter))
                .collect(java.util.stream.Collectors.toList());
        }
        
        // Get booking statistics
        Map<String, Integer> bookingStats = bookingDAO.getBookingStatsByCustomerId(customerId);
        
        // Calculate additional statistics
        Map<String, Object> dashboardStats = new HashMap<>();
        dashboardStats.put("totalBookings", allBookings.size());
        dashboardStats.put("upcomingBookings", allBookings.stream()
            .filter(booking -> booking.getAppointmentDate() != null && 
                    booking.getAppointmentDate().toLocalDate().isAfter(LocalDate.now().minusDays(1)))
            .count());
        dashboardStats.put("completedBookings", bookingStats.getOrDefault("completed_count", 0));
        dashboardStats.put("cancelledBookings", bookingStats.getOrDefault("cancelled_count", 0));
        
        // Set request attributes
        request.setAttribute("bookings", filteredBookings);
        request.setAttribute("bookingStats", bookingStats);
        request.setAttribute("dashboardStats", dashboardStats);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("pageTitle", "Dịch vụ đã đặt - Spa Hương Sen");
        
        // Forward to bookings list page
        request.getRequestDispatcher("/WEB-INF/view/customer/customer-bookings.jsp")
                .forward(request, response);
    }
    
    /**
     * Handle booking details view
     */
    private void handleBookingDetails(HttpServletRequest request, HttpServletResponse response, Customer customer) 
            throws ServletException, IOException, SQLException {
        
        String bookingIdStr = request.getParameter("id");
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing booking ID");
            return;
        }
        
        try {
            Integer bookingId = Integer.parseInt(bookingIdStr);
            
            // Get booking details
            var bookingOpt = bookingDAO.findById(bookingId);
            if (bookingOpt.isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found");
                return;
            }
            
            Booking booking = bookingOpt.get();
            
            // Verify that this booking belongs to the current customer
            if (!booking.getCustomerId().equals(customer.getCustomerId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
            
            // Set request attributes
            request.setAttribute("booking", booking);
            request.setAttribute("pageTitle", "Chi tiết đặt lịch - Spa Hương Sen");
            
            // Forward to booking details page
            request.getRequestDispatcher("/WEB-INF/view/customer/booking-details.jsp")
                    .forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid booking ID");
        }
    }
    
    /**
     * Handle booking cancellation
     */
    private void handleBookingCancellation(HttpServletRequest request, HttpServletResponse response, Customer customer) 
            throws ServletException, IOException, SQLException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String bookingIdStr = request.getParameter("bookingId");
        String cancellationReason = request.getParameter("reason");
        
        if (bookingIdStr == null || bookingIdStr.isEmpty()) {
            response.getWriter().write("{\"success\": false, \"message\": \"Missing booking ID\"}");
            return;
        }
        
        try {
            Integer bookingId = Integer.parseInt(bookingIdStr);
            
            // Get booking details
            var bookingOpt = bookingDAO.findById(bookingId);
            if (bookingOpt.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Booking not found\"}");
                return;
            }
            
            Booking booking = bookingOpt.get();
            
            // Verify that this booking belongs to the current customer
            if (!booking.getCustomerId().equals(customer.getCustomerId())) {
                response.getWriter().write("{\"success\": false, \"message\": \"Access denied\"}");
                return;
            }
            
            // Check if booking can be cancelled
            if (booking.getBookingStatus() == Booking.BookingStatus.CANCELLED ||
                booking.getBookingStatus() == Booking.BookingStatus.COMPLETED) {
                response.getWriter().write("{\"success\": false, \"message\": \"Không thể hủy lịch hẹn này\"}");
                return;
            }
            
            // Update booking status
            booking.setBookingStatus(Booking.BookingStatus.CANCELLED);
            booking.setCancellationReason(cancellationReason);
            booking.setCancelledAt(new java.sql.Timestamp(System.currentTimeMillis()));
            booking.setCancelledBy(customer.getCustomerId()); // Customer cancelled
            
            bookingDAO.update(booking);
            
            response.getWriter().write("{\"success\": true, \"message\": \"Đã hủy lịch hẹn thành công\"}");
            
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid booking ID\"}");
        }
    }
}
