package controller.booking;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import booking.BookingCustomerView;
import dao.BookingDAO;
import db.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CustomerShowBookingsServlet", urlPatterns = {"/customer/show-bookings"})
public class CustomerBookingServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CustomerBookingServlet.class.getName());
    private BookingDAO bookingDAO;
    
    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");
        
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");

        if ("data".equals(action)) {
            // Return JSON data for DataTables
            handleDataTableRequest(request, response, customerId);
        } else if ("debug".equals(action)) {
            // Debug endpoint to check data
            handleDebugRequest(request, response, customerId);
        } else {
            // Show the main page
            request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp")
                   .forward(request, response);
        }
    }
    
    private void handleDataTableRequest(HttpServletRequest request, HttpServletResponse response,
                                      Integer customerId) throws IOException {
        try {
            LOGGER.info("Loading bookings for customer ID: " + customerId);
            List<BookingCustomerView> bookings = bookingDAO.findBookingsForCustomer(customerId);
            LOGGER.info("Retrieved " + bookings.size() + " bookings from DAO");
            
            // Create DataTables response format
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("draw", request.getParameter("draw"));
            jsonResponse.addProperty("recordsTotal", bookings.size());
            jsonResponse.addProperty("recordsFiltered", bookings.size());

            // Configure Gson to properly serialize LocalDate and LocalTime
            Gson gson = new com.google.gson.GsonBuilder()
                .registerTypeAdapter(java.time.LocalDate.class,
                    (com.google.gson.JsonSerializer<java.time.LocalDate>) (src, typeOfSrc, context) -> 
                        new com.google.gson.JsonPrimitive(src.format(java.time.format.DateTimeFormatter.ISO_LOCAL_DATE)))
                .registerTypeAdapter(java.time.LocalTime.class,
                    (com.google.gson.JsonSerializer<java.time.LocalTime>) (src, typeOfSrc, context) -> 
                        new com.google.gson.JsonPrimitive(src.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss"))))
                .create();
            jsonResponse.add("data", gson.toJsonTree(bookings));
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            String jsonString = gson.toJson(jsonResponse);
            LOGGER.info("Sending JSON response: " + jsonString);
            response.getWriter().write(jsonString);
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching customer bookings", ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Unable to fetch bookings\"}");
        }
    }

    private void handleDebugRequest(HttpServletRequest request, HttpServletResponse response,
                                  Integer customerId) throws IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        StringBuilder html = new StringBuilder();
        html.append("<html><head><title>Customer Booking Debug</title></head><body>");
        html.append("<h1>Customer Booking Debug Information</h1>");
        html.append("<p><strong>Customer ID from session:</strong> ").append(customerId).append("</p>");

        try {
            // Test basic database connection
            html.append("<h2>Database Connection Test</h2>");
            List<BookingCustomerView> bookings = bookingDAO.findBookingsForCustomer(customerId);
            html.append("<p><strong>Number of bookings found:</strong> ").append(bookings.size()).append("</p>");

            if (!bookings.isEmpty()) {
                html.append("<h2>Booking Details</h2>");
                html.append("<table border='1' style='border-collapse: collapse;'>");
                html.append("<tr><th>ID</th><th>Date</th><th>Time</th><th>Service</th><th>Status</th></tr>");
                for (BookingCustomerView booking : bookings) {
                    html.append("<tr>");
                    html.append("<td>").append(booking.getBookingId()).append("</td>");
                    html.append("<td>").append(booking.getAppointmentDate()).append("</td>");
                    html.append("<td>").append(booking.getAppointmentTime()).append("</td>");
                    html.append("<td>").append(booking.getServiceName()).append("</td>");
                    html.append("<td>").append(booking.getBookingStatus()).append("</td>");
                    html.append("</tr>");
                }
                html.append("</table>");
            } else {
                html.append("<p><em>No bookings found for this customer.</em></p>");

                // Check if there are any bookings at all in the database
                html.append("<h2>Database Check</h2>");
                try (java.sql.Connection conn = DBContext.getConnection();
                     java.sql.PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM bookings");
                     java.sql.ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int totalBookings = rs.getInt(1);
                        html.append("<p><strong>Total bookings in database:</strong> ").append(totalBookings).append("</p>");
                    }
                }

                // Check if this customer exists
                try (java.sql.Connection conn = DBContext.getConnection();
                     java.sql.PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM customers WHERE customer_id = ?")) {
                    stmt.setInt(1, customerId);
                    try (java.sql.ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            int customerExists = rs.getInt(1);
                            html.append("<p><strong>Customer exists:</strong> ").append(customerExists > 0 ? "Yes" : "No").append("</p>");
                        }
                    }
                }
            }

        } catch (Exception ex) {
            html.append("<p><strong>Error:</strong> ").append(ex.getMessage()).append("</p>");
            html.append("<pre>").append(ex.toString()).append("</pre>");
        }

        html.append("<p><a href='").append(request.getContextPath()).append("/customer/show-bookings'>Back to Bookings</a></p>");
        html.append("</body></html>");

        response.getWriter().write(html.toString());
    }
}
