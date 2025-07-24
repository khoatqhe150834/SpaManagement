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
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/customer/show-bookings")
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
        } else {
            // Show the main page
            request.getRequestDispatcher("/WEB-INF/view/customer/booking.jsp")
                   .forward(request, response);
        }
    }
    
    private void handleDataTableRequest(HttpServletRequest request, HttpServletResponse response, 
                                      Integer customerId) throws IOException {
        try {
            List<BookingCustomerView> bookings = bookingDAO.findBookingsForCustomer(customerId);
            
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
}