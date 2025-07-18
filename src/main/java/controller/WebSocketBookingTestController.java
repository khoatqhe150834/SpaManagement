package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Service;
import model.User;

/**
 * WebSocket Booking Test Controller
 * Handles the test page for real-time booking slot reservation functionality
 * 
 * @author SpaManagement
 */
@WebServlet("/test/websocket-booking")
public class WebSocketBookingTestController extends HttpServlet {
    
    private final ServiceDAO serviceDAO;
    
    public WebSocketBookingTestController() {
        this.serviceDAO = new ServiceDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check authentication and authorization
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        // Only MANAGER and ADMIN can access test pages
        if (user == null || (!"MANAGER".equals(userRole) && !"ADMIN".equals(userRole))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Generate sample time slots for testing
        List<Map<String, Object>> timeSlots = generateSampleTimeSlots();

        // Get sample services for booking context
        List<Service> services = serviceDAO.findAll();
        if (services.isEmpty()) {
            // Create sample services if none exist
            services = generateSampleServices();
        }

        // Set attributes for JSP
        request.setAttribute("timeSlots", timeSlots);
        request.setAttribute("services", services);
        request.setAttribute("currentUser", user);
        request.setAttribute("pageTitle", "WebSocket Booking Test - Spa Hương Sen");

        // Forward to test JSP
        request.getRequestDispatcher("/WEB-INF/view/test/websocket-booking-test.jsp")
                .forward(request, response);
    }
    
    /**
     * Generate sample time slots for testing
     */
    private List<Map<String, Object>> generateSampleTimeSlots() {
        List<Map<String, Object>> timeSlots = new ArrayList<>();
        
        // Generate time slots from 9:00 AM to 6:00 PM
        String[] slots = {
            "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
            "12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
            "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00"
        };
        
        for (String slot : slots) {
            Map<String, Object> timeSlot = new HashMap<>();
            timeSlot.put("time", slot);
            timeSlot.put("displayTime", formatTimeDisplay(slot));
            timeSlot.put("status", "available"); // available, booked, selected, pending
            timeSlot.put("bookedBy", null);
            timeSlot.put("slotId", "slot_" + slot.replace(":", ""));
            timeSlots.add(timeSlot);
        }
        
        return timeSlots;
    }
    
    /**
     * Format time for display (24h to 12h format)
     */
    private String formatTimeDisplay(String time24) {
        String[] parts = time24.split(":");
        int hour = Integer.parseInt(parts[0]);
        int minute = Integer.parseInt(parts[1]);
        
        String period = hour >= 12 ? "PM" : "AM";
        int displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
        
        return String.format("%d:%02d %s", displayHour, minute, period);
    }
    
    /**
     * Generate sample services if none exist in database
     */
    private List<Service> generateSampleServices() {
        List<Service> services = new ArrayList<>();
        
        // Create sample services for testing
        Service massage = new Service();
        massage.setServiceId(1);
        massage.setName("Massage Thư Giãn");
        massage.setDescription("Massage toàn thân thư giãn");
        massage.setDurationMinutes(60);
        services.add(massage);

        Service facial = new Service();
        facial.setServiceId(2);
        facial.setName("Chăm Sóc Da Mặt");
        facial.setDescription("Làm sạch và dưỡng da mặt");
        facial.setDurationMinutes(90);
        services.add(facial);

        Service manicure = new Service();
        manicure.setServiceId(3);
        manicure.setName("Làm Móng Tay");
        manicure.setDescription("Chăm sóc và trang trí móng tay");
        manicure.setDurationMinutes(45);
        services.add(manicure);

        Service bodyTreatment = new Service();
        bodyTreatment.setServiceId(4);
        bodyTreatment.setName("Tắm Trắng Toàn Thân");
        bodyTreatment.setDescription("Liệu trình tắm trắng và dưỡng da");
        bodyTreatment.setDurationMinutes(120);
        services.add(bodyTreatment);
        
        return services;
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Handle POST requests (if needed for test actions)
        String action = request.getParameter("action");
        
        if ("reset".equals(action)) {
            // Reset test data - could clear any persistent test state
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"message\": \"Test data reset successfully\"}");
        } else {
            // Redirect back to GET for other actions
            response.sendRedirect(request.getContextPath() + "/test/websocket-booking");
        }
    }
}
