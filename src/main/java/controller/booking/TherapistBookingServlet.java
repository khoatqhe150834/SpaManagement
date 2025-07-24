/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.booking;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import booking.BookingTherapistView;
import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.RoleConstants;
import model.User;

@WebServlet("/therapist/show-bookings")
public class TherapistBookingServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TherapistBookingServlet.class.getName());
    private BookingDAO bookingDAO;
    
    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();

        // Get therapist ID from the user object in session
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer therapistId = user.getUserId();

        // Verify that the user is actually a therapist
        if (!user.getRoleId().equals(RoleConstants.THERAPIST_ID)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Therapist role required.");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("data".equals(action)) {
            // Return JSON data for DataTables
            handleDataTableRequest(request, response, therapistId);
        } else {
            // Show the main page
            request.getRequestDispatcher("/WEB-INF/view/therapist/booking.jsp")
                   .forward(request, response);
        }
    }
    
    private void handleDataTableRequest(HttpServletRequest request, HttpServletResponse response,
                                      Integer therapistId) throws IOException {
        try {
            LOGGER.info("Loading bookings for therapist ID: " + therapistId);

            String dateParam = request.getParameter("date");
            LocalDate filterDate = null;

            if (dateParam != null && !dateParam.isEmpty()) {
                try {
                    filterDate = LocalDate.parse(dateParam);
                    LOGGER.info("Using date filter: " + filterDate);
                } catch (DateTimeParseException e) {
                    LOGGER.log(Level.WARNING, "Invalid date format: " + dateParam);
                    // Don't set filterDate, let it remain null to show all bookings
                }
            } else {
                LOGGER.info("No date filter provided, showing all bookings");
            }

            List<BookingTherapistView> bookings = bookingDAO.findBookingsForTherapist(therapistId, filterDate);
            LOGGER.info("Found " + bookings.size() + " bookings for therapist " + therapistId);

            // Debug: Log first booking details if any exist
            if (!bookings.isEmpty()) {
                BookingTherapistView firstBooking = bookings.get(0);
                LOGGER.info("First booking details - ID: " + firstBooking.getBookingId() +
                           ", Customer: " + firstBooking.getCustomerName() +
                           ", Service: " + firstBooking.getServiceName() +
                           ", Date: " + firstBooking.getAppointmentDate() +
                           ", Time: " + firstBooking.getAppointmentTime());
            }
            
            // Create DataTables response format
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("draw", request.getParameter("draw"));
            jsonResponse.addProperty("recordsTotal", bookings.size());
            jsonResponse.addProperty("recordsFiltered", bookings.size());

            // Create Gson with custom date/time serializers
            Gson gson = new com.google.gson.GsonBuilder()
                .registerTypeAdapter(java.time.LocalDate.class,
                    (com.google.gson.JsonSerializer<java.time.LocalDate>) (src, typeOfSrc, context) ->
                        new com.google.gson.JsonPrimitive(src.toString()))
                .registerTypeAdapter(java.time.LocalTime.class,
                    (com.google.gson.JsonSerializer<java.time.LocalTime>) (src, typeOfSrc, context) ->
                        new com.google.gson.JsonPrimitive(src.toString()))
                .create();

            jsonResponse.add("data", gson.toJsonTree(bookings));
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(jsonResponse));
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "SQL Error loading therapist bookings for therapist " + therapistId, ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("error", true);
            errorResponse.addProperty("errorType", "DATABASE_ERROR");
            errorResponse.addProperty("message", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            errorResponse.addProperty("statusCode", 500);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(errorResponse));
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error loading therapist bookings for therapist " + therapistId, ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("error", true);
            errorResponse.addProperty("errorType", "SYSTEM_ERROR");
            errorResponse.addProperty("message", "Đã xảy ra lỗi hệ thống: " + ex.getMessage());
            errorResponse.addProperty("statusCode", 500);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(errorResponse));
        }
    }
    
@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("updateStatus".equals(action)) {
            handleStatusUpdate(request, response);
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    private void handleStatusUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Integer bookingId = Integer.parseInt(request.getParameter("bookingId"));
            String newStatus = request.getParameter("status");

            // Validate status values
            if (!isValidBookingStatus(newStatus)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid status value\"}");
                return;
            }

            // Convert string to enum and update booking status
            Booking.BookingStatus statusEnum = Booking.BookingStatus.valueOf(newStatus);
            boolean updated = bookingDAO.updateBookingStatus(bookingId, statusEnum);

            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("success", updated);
            if (updated) {
                jsonResponse.addProperty("message", "Booking status updated successfully");
            } else {
                jsonResponse.addProperty("message", "Failed to update booking status");
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(jsonResponse));

        } catch (NumberFormatException ex) {
            LOGGER.log(Level.SEVERE, "Invalid booking ID format", ex);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid booking ID\"}");
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating booking status", ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Database error occurred\"}");
        }
    }

    private boolean isValidBookingStatus(String status) {
        return status != null && (
            status.equals("SCHEDULED") ||
            status.equals("CONFIRMED") ||
            status.equals("IN_PROGRESS") ||
            status.equals("COMPLETED") ||
            status.equals("CANCELLED") ||
            status.equals("NO_SHOW")
        );
    }
}