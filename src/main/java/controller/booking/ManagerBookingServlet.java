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

import booking.BookingManagerFilter;
import booking.BookingManagerView;
import dao.BookingDAO;
import dao.ServiceTypeDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ServiceType;
import model.User;


@WebServlet(name = "ManagerShowBookingsServlet", urlPatterns = {"/manager/show-bookings"})
public class ManagerBookingServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ManagerBookingServlet.class.getName());
    private BookingDAO bookingDAO;
    private UserDAO userDAO;
    private ServiceTypeDAO serviceTypeDAO;
    
    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        userDAO = new UserDAO();
        serviceTypeDAO = new ServiceTypeDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");

        if (!"MANAGER".equals(userRole) && !"ADMIN".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("data".equals(action)) {
            // Return JSON data for DataTables
            handleDataTableRequest(request, response);
        } else {
            // Load filter options and show the main page
            List<User> therapists = null;
            try {
                therapists = userDAO.findByRole("THERAPIST");
            } catch (SQLException ex) {
                Logger.getLogger(ManagerBookingServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            List<ServiceType> serviceTypes = serviceTypeDAO.findAll();
            request.setAttribute("therapists", therapists);
            request.setAttribute("serviceTypes", serviceTypes);
            request.getRequestDispatcher("/WEB-INF/view/manager/booking.jsp")
                    .forward(request, response);
        }
    }
    
    private void handleDataTableRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            LOGGER.info("Loading manager bookings data");
            LOGGER.info("Request parameters: draw=" + request.getParameter("draw") +
                       ", start=" + request.getParameter("start") +
                       ", length=" + request.getParameter("length"));

            // Build filter from request parameters
            BookingManagerFilter filter = buildFilterFromRequest(request);
            
            // Get DataTables pagination parameters with defaults
            int draw = 1;
            int start = 0;
            int length = 25;

            try {
                String drawParam = request.getParameter("draw");
                if (drawParam != null && !drawParam.isEmpty()) {
                    draw = Integer.parseInt(drawParam);
                }

                String startParam = request.getParameter("start");
                if (startParam != null && !startParam.isEmpty()) {
                    start = Integer.parseInt(startParam);
                }

                String lengthParam = request.getParameter("length");
                if (lengthParam != null && !lengthParam.isEmpty()) {
                    length = Integer.parseInt(lengthParam);
                }
            } catch (NumberFormatException ex) {
                LOGGER.log(Level.WARNING, "Invalid pagination parameters, using defaults", ex);
            }
            
            // Set pagination
            filter.setLimit(length);
            filter.setOffset(start);

            LOGGER.info("Filter configured - limit: " + length + ", offset: " + start);

            // Get data
            List<BookingManagerView> bookings;
            int totalRecords;

            try {
                bookings = bookingDAO.findBookingsForManager(filter);
                if (bookings == null) {
                    bookings = new java.util.ArrayList<>();
                    LOGGER.warning("DAO returned null, using empty list");
                }
                LOGGER.info("Retrieved " + bookings.size() + " bookings from DAO");

                totalRecords = bookingDAO.countBookingsForManager(filter);
                LOGGER.info("Total records count: " + totalRecords);
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Error calling DAO methods", ex);
                throw ex; // Re-throw to be caught by outer catch block
            }

            LOGGER.info("Found " + bookings.size() + " bookings for manager, total records: " + totalRecords);
            
            // Create DataTables response format
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("draw", draw);
            jsonResponse.addProperty("recordsTotal", totalRecords);
            jsonResponse.addProperty("recordsFiltered", totalRecords);

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
            LOGGER.log(Level.SEVERE, "SQL Error loading manager bookings", ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("error", true);
            errorResponse.addProperty("errorType", "DATABASE_ERROR");
            errorResponse.addProperty("message", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            errorResponse.addProperty("statusCode", 500);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(errorResponse));
        } catch (NumberFormatException ex) {
            LOGGER.log(Level.WARNING, "Invalid number format in request parameters", ex);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("error", true);
            errorResponse.addProperty("errorType", "PARAMETER_ERROR");
            errorResponse.addProperty("message", "Tham số không hợp lệ");
            errorResponse.addProperty("statusCode", 400);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(errorResponse));
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error loading manager bookings", ex);
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
    
    private BookingManagerFilter buildFilterFromRequest(HttpServletRequest request) {
        BookingManagerFilter filter = new BookingManagerFilter();
        LOGGER.info("Building filter from request parameters");
        
        // Date filters
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        try {
            if (startDate != null && !startDate.isEmpty()) {
                filter.setStartDate(LocalDate.parse(startDate));
            }
            if (endDate != null && !endDate.isEmpty()) {
                filter.setEndDate(LocalDate.parse(endDate));
            }
        } catch (DateTimeParseException ex) {
            LOGGER.log(Level.WARNING, "Invalid date format in filter", ex);
        }
        
        // Therapist filter
        String therapistId = request.getParameter("therapistId");
        if (therapistId != null && !therapistId.isEmpty()) {
            try {
                filter.setTherapistId(Integer.parseInt(therapistId));
            } catch (NumberFormatException ex) {
                LOGGER.log(Level.WARNING, "Invalid therapist ID: " + therapistId);
            }
        }
        
        // Status filter
        String status = request.getParameter("status");
        if (status != null && !status.isEmpty()) {
            filter.setBookingStatus(status);
        }
        
        // Service type filter
        String serviceTypeId = request.getParameter("serviceTypeId");
        if (serviceTypeId != null && !serviceTypeId.isEmpty()) {
            try {
                filter.setServiceTypeId(Integer.parseInt(serviceTypeId));
            } catch (NumberFormatException ex) {
                LOGGER.log(Level.WARNING, "Invalid service type ID: " + serviceTypeId);
            }
        }
        
        return filter;
    }
}