package controller.test;

import booking.BookingCustomerView;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/test/booking-dao")
public class BookingTestController extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BookingTestController.class.getName());
    private BookingDAO bookingDAO;
    
    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        // Get customer ID from session or use a test ID
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");
        
        // If no customer in session, use a test customer ID
        if (customerId == null) {
            String testCustomerIdParam = request.getParameter("customerId");
            if (testCustomerIdParam != null) {
                try {
                    customerId = Integer.parseInt(testCustomerIdParam);
                } catch (NumberFormatException e) {
                    customerId = 1; // Default test customer ID
                }
            } else {
                customerId = 1; // Default test customer ID
            }
        }
        
        try {
            LOGGER.info("Testing BookingDAO.findBookingsForCustomer with customerId: " + customerId);
            
            List<BookingCustomerView> bookings = bookingDAO.findBookingsForCustomer(customerId);
            
            LOGGER.info("Found " + bookings.size() + " bookings for customer " + customerId);
            
            // Configure Gson for proper serialization
            Gson gson = new GsonBuilder()
                .registerTypeAdapter(java.time.LocalDate.class, 
                    (com.google.gson.JsonSerializer<java.time.LocalDate>) (src, typeOfSrc, context) -> 
                        new com.google.gson.JsonPrimitive(src.format(java.time.format.DateTimeFormatter.ISO_LOCAL_DATE)))
                .registerTypeAdapter(java.time.LocalTime.class, 
                    (com.google.gson.JsonSerializer<java.time.LocalTime>) (src, typeOfSrc, context) -> 
                        new com.google.gson.JsonPrimitive(src.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss"))))
                .setPrettyPrinting()
                .create();
            
            StringBuilder html = new StringBuilder();
            html.append("<!DOCTYPE html>");
            html.append("<html><head><title>Booking DAO Test</title></head><body>");
            html.append("<h1>Booking DAO Test Results</h1>");
            html.append("<h2>Customer ID: ").append(customerId).append("</h2>");
            html.append("<h3>Found ").append(bookings.size()).append(" bookings</h3>");
            
            if (bookings.isEmpty()) {
                html.append("<p style='color: red;'>No bookings found for this customer.</p>");
                html.append("<p>Try different customer IDs: ");
                for (int i = 1; i <= 10; i++) {
                    html.append("<a href='?customerId=").append(i).append("'>").append(i).append("</a> ");
                }
                html.append("</p>");
            } else {
                html.append("<h3>Raw Data (as returned by DAO):</h3>");
                html.append("<pre style='background: #f5f5f5; padding: 10px; border: 1px solid #ccc;'>");
                
                for (int i = 0; i < bookings.size(); i++) {
                    BookingCustomerView booking = bookings.get(i);
                    html.append("Booking ").append(i + 1).append(":\n");
                    html.append("  bookingId: ").append(booking.getBookingId()).append("\n");
                    html.append("  appointmentDate: ").append(booking.getAppointmentDate()).append("\n");
                    html.append("  appointmentTime: ").append(booking.getAppointmentTime()).append("\n");
                    html.append("  serviceName: ").append(booking.getServiceName()).append("\n");
                    html.append("  therapistName: ").append(booking.getTherapistName()).append("\n");
                    html.append("  roomName: ").append(booking.getRoomName()).append("\n");
                    html.append("  bookingStatus: ").append(booking.getBookingStatus()).append("\n");
                    html.append("  paymentStatus: ").append(booking.getPaymentStatus()).append("\n");
                    html.append("  totalAmount: ").append(booking.getTotalAmount()).append("\n");
                    html.append("  durationMinutes: ").append(booking.getDurationMinutes()).append("\n");
                    html.append("\n");
                }
                html.append("</pre>");
                
                html.append("<h3>JSON Format (as sent to DataTable):</h3>");
                html.append("<pre style='background: #f0f8ff; padding: 10px; border: 1px solid #ccc;'>");
                html.append(gson.toJson(bookings));
                html.append("</pre>");
            }
            
            html.append("<p><a href='").append(request.getContextPath()).append("/customer/show-bookings'>Go to Customer Bookings Page</a></p>");
            html.append("</body></html>");
            
            response.getWriter().write(html.toString());
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error testing BookingDAO", ex);
            response.getWriter().write("<html><body>");
            response.getWriter().write("<h1>Error Testing BookingDAO</h1>");
            response.getWriter().write("<p style='color: red;'>SQLException: " + ex.getMessage() + "</p>");
            response.getWriter().write("<pre>" + ex.toString() + "</pre>");
            response.getWriter().write("</body></html>");
        }
    }
}
