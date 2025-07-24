/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.booking;

import booking.BookingManagerFilter;
import booking.BookingManagerView;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.BookingDAO;
import dao.ServiceTypeDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ServiceType;
import model.User;


@WebServlet("/manager/show-bookings")
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
        String userRole = (String) session.getAttribute("role");
        
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
            request.getRequestDispatcher("/WEB-INF/views/manager/bookings.jsp")
                    .forward(request, response);
        }
    }
    
    private void handleDataTableRequest(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            // Build filter from request parameters
            BookingManagerFilter filter = buildFilterFromRequest(request);
            
            // Get DataTables pagination parameters
            int draw = Integer.parseInt(request.getParameter("draw"));
            int start = Integer.parseInt(request.getParameter("start"));
            int length = Integer.parseInt(request.getParameter("length"));
            
            // Set pagination
            filter.setLimit(length);
            filter.setOffset(start);
            
            // Get data
            List<BookingManagerView> bookings = bookingDAO.findBookingsForManager(filter);
            int totalRecords = bookingDAO.countBookingsForManager(filter);
            
            // Create DataTables response format
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("draw", draw);
            jsonResponse.addProperty("recordsTotal", totalRecords);
            jsonResponse.addProperty("recordsFiltered", totalRecords);
            
            Gson gson = new Gson();
            jsonResponse.add("data", gson.toJsonTree(bookings));
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(jsonResponse));
            
        } catch (SQLException | NumberFormatException ex) {
            LOGGER.log(Level.SEVERE, "Error fetching manager bookings", ex);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Unable to fetch bookings\"}");
        }
    }
    
    private BookingManagerFilter buildFilterFromRequest(HttpServletRequest request) {
        BookingManagerFilter filter = new BookingManagerFilter();
        
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