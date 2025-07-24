package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import dao.BookingDAO;
import dao.ServiceDAO;
import dao.StaffDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Booking;
import model.RoleConstants;
import model.Service;
import model.Staff;
import model.User;

/**
 * API Controller for Therapist Schedule Management
 * Provides real booking data from database for schedule analysis
 */
@WebServlet("/api/therapist-schedule")
public class TherapistScheduleAPI extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(TherapistScheduleAPI.class.getName());
    private final BookingDAO bookingDAO;
    private final UserDAO userDAO;
    private final ServiceDAO serviceDAO;
    private final StaffDAO staffDAO;
    private final Gson gson;

    public TherapistScheduleAPI() {
        this.bookingDAO = new BookingDAO();
        this.userDAO = new UserDAO();
        this.serviceDAO = new ServiceDAO();
        this.staffDAO = new StaffDAO();
        this.gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
                .create();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "getTherapists":
                    getTherapists(response);
                    break;
                case "getServices":
                    getServices(response);
                    break;
                case "getSchedule":
                    getTherapistSchedule(request, response);
                    break;
                case "getScheduleStats":
                    getScheduleStats(request, response);
                    break;
                default:
                    sendError(response, "Invalid action parameter");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing request", e);
            sendError(response, "Internal server error: " + e.getMessage());
        }
    }
    
    /**
     * Get all therapists (staff with therapist role)
     */
    private void getTherapists(HttpServletResponse response) throws IOException, SQLException {
        // Get users with therapist role (role_id = 3)
        List<User> therapistUsers = userDAO.findByRoleId(RoleConstants.THERAPIST_ID, 1, 1000);

        List<Map<String, Object>> therapistList = new ArrayList<>();
        for (User therapist : therapistUsers) {
            Map<String, Object> therapistData = new HashMap<>();
            therapistData.put("userId", therapist.getUserId());
            therapistData.put("fullName", therapist.getFullName());
            therapistData.put("email", therapist.getEmail());
            therapistData.put("phoneNumber", therapist.getPhoneNumber());
            therapistData.put("isActive", therapist.getIsActive());

            // Try to get additional staff information
            try {
                Staff staffInfo = staffDAO.findById(therapist.getUserId()).orElse(null);
                if (staffInfo != null) {
                    therapistData.put("bio", staffInfo.getBio());
                    therapistData.put("yearsOfExperience", staffInfo.getYearsOfExperience());
                    therapistData.put("availabilityStatus", staffInfo.getAvailabilityStatus().toString());
                    if (staffInfo.getServiceType() != null) {
                        therapistData.put("serviceTypeName", staffInfo.getServiceType().getName());
                    }
                }
            } catch (Exception e) {
                // Staff info not available, continue with basic user info
                LOGGER.log(Level.WARNING, "Could not load staff info for user " + therapist.getUserId(), e);
            }

            therapistList.add(therapistData);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("therapists", therapistList);

        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(result));
        }
    }
    
    /**
     * Get all active services
     */
    private void getServices(HttpServletResponse response) throws IOException {
        List<Service> services = serviceDAO.findAll();
        
        List<Map<String, Object>> serviceList = new ArrayList<>();
        for (Service service : services) {
            if (service.isIsActive()) {
                Map<String, Object> serviceData = new HashMap<>();
                serviceData.put("serviceId", service.getServiceId());
                serviceData.put("name", service.getName());
                serviceData.put("description", service.getDescription());
                serviceData.put("durationMinutes", service.getDurationMinutes());
                serviceData.put("bufferTimeAfterMinutes", service.getBufferTimeAfterMinutes());
                serviceData.put("price", service.getPrice());
                serviceList.add(serviceData);
            }
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("services", serviceList);
        
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(result));
        }
    }
    
    /**
     * Get therapist schedule with filters
     */
    private void getTherapistSchedule(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        
        String therapistIdStr = request.getParameter("therapistId");
        String dateFilter = request.getParameter("date");
        String serviceIdStr = request.getParameter("serviceId");
        String statusFilter = request.getParameter("status");
        
        List<Booking> bookings = new ArrayList<>();
        
        if (therapistIdStr != null && !therapistIdStr.isEmpty()) {
            Integer therapistId = Integer.parseInt(therapistIdStr);
            
            if (dateFilter != null && !dateFilter.isEmpty()) {
                // Get bookings for specific date
                LocalDate filterDate = LocalDate.parse(dateFilter);
                bookings = bookingDAO.findByTherapistAndDate(therapistId, Date.valueOf(filterDate));
            } else {
                // Get all bookings for therapist
                bookings = bookingDAO.findByTherapistId(therapistId);
            }
            
            // Apply additional filters
            if (serviceIdStr != null && !serviceIdStr.isEmpty()) {
                Integer serviceId = Integer.parseInt(serviceIdStr);
                bookings = bookings.stream()
                        .filter(b -> b.getServiceId().equals(serviceId))
                        .collect(Collectors.toList());
            }
            
            if (statusFilter != null && !statusFilter.isEmpty()) {
                bookings = bookings.stream()
                        .filter(b -> b.getBookingStatus().toString().equals(statusFilter))
                        .collect(Collectors.toList());
            }
        }
        
        // Convert bookings to JSON format
        List<Map<String, Object>> bookingList = new ArrayList<>();
        for (Booking booking : bookings) {
            Map<String, Object> bookingData = new HashMap<>();
            bookingData.put("bookingId", booking.getBookingId());
            bookingData.put("customerId", booking.getCustomerId());
            bookingData.put("serviceId", booking.getServiceId());
            bookingData.put("therapistUserId", booking.getTherapistUserId());
            bookingData.put("appointmentDate", booking.getAppointmentDate().toString());
            bookingData.put("appointmentTime", booking.getAppointmentTime().toString());
            bookingData.put("durationMinutes", booking.getDurationMinutes());
            bookingData.put("bookingStatus", booking.getBookingStatus().toString());
            bookingData.put("bookingNotes", booking.getBookingNotes());
            bookingData.put("roomId", booking.getRoomId());
            bookingData.put("bedId", booking.getBedId());
            
            // Add related entity data if available
            if (booking.getCustomer() != null) {
                bookingData.put("customerName", booking.getCustomer().getFullName());
            }
            if (booking.getService() != null) {
                bookingData.put("serviceName", booking.getService().getName());
            }
            if (booking.getTherapist() != null) {
                bookingData.put("therapistName", booking.getTherapist().getFullName());
            }
            
            bookingList.add(bookingData);
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("bookings", bookingList);
        result.put("totalCount", bookingList.size());
        
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(result));
        }
    }
    
    /**
     * Get schedule statistics
     */
    private void getScheduleStats(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, SQLException {
        
        String therapistIdStr = request.getParameter("therapistId");
        String dateFilter = request.getParameter("date");
        
        Map<String, Object> stats = new HashMap<>();
        
        if (therapistIdStr != null && !therapistIdStr.isEmpty()) {
            Integer therapistId = Integer.parseInt(therapistIdStr);
            List<Booking> bookings;
            
            if (dateFilter != null && !dateFilter.isEmpty()) {
                LocalDate filterDate = LocalDate.parse(dateFilter);
                bookings = bookingDAO.findByTherapistAndDate(therapistId, Date.valueOf(filterDate));
            } else {
                bookings = bookingDAO.findByTherapistId(therapistId);
            }
            
            // Calculate statistics
            int totalAppointments = bookings.size();
            int confirmedAppointments = (int) bookings.stream()
                    .filter(b -> b.getBookingStatus() == Booking.BookingStatus.CONFIRMED)
                    .count();
            int scheduledAppointments = (int) bookings.stream()
                    .filter(b -> b.getBookingStatus() == Booking.BookingStatus.SCHEDULED)
                    .count();
            
            int totalMinutes = bookings.stream()
                    .mapToInt(b -> b.getDurationMinutes() != null ? b.getDurationMinutes() : 0)
                    .sum();
            double totalHours = totalMinutes / 60.0;
            
            stats.put("totalAppointments", totalAppointments);
            stats.put("confirmedAppointments", confirmedAppointments);
            stats.put("scheduledAppointments", scheduledAppointments);
            stats.put("totalHours", String.format("%.1f", totalHours));
            
            // Get therapist info
            User therapist = userDAO.findById(therapistId).orElse(null);
            if (therapist != null) {
                stats.put("therapistName", therapist.getFullName());
                stats.put("therapistEmail", therapist.getEmail());
                stats.put("therapistPhone", therapist.getPhoneNumber());
            }
        } else {
            stats.put("totalAppointments", 0);
            stats.put("confirmedAppointments", 0);
            stats.put("scheduledAppointments", 0);
            stats.put("totalHours", "0.0");
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("stats", stats);
        
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(result));
        }
    }
    
    private void sendError(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("error", message);
        
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(error));
        }
    }
}
