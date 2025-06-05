/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Appointment;
import model.AppointmentDetails;
import model.User;
import model.Customer;

@WebServlet(name = "AppointmentController", urlPatterns = {"/appointment"})
public class AppointmentController extends HttpServlet {

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Customer customer = (Customer) session.getAttribute("customer");
        
        if (user == null && customer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            if (user != null && user.getRoleId() == 2) { // Admin
                listWithFilters(request, response);
            } else { // User or Customer
                int userId = user != null ? user.getUserId() : customer.getCustomerId();
                listUserAppointments(request, response, userId);
            }
        } else if (action.equals("details")) {
            if (user != null && user.getRoleId() == 2) { // Admin
                viewDetails(request, response);
            } else { // User or Customer
                int userId = user != null ? user.getUserId() : customer.getCustomerId();
                viewUserAppointmentDetails(request, response, userId);
            }
        } else {
            if (user != null && user.getRoleId() == 2) { // Admin
                listWithFilters(request, response);
            } else { // User or Customer
                int userId = user != null ? user.getUserId() : customer.getCustomerId();
                listUserAppointments(request, response, userId);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and is admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action.equals("update")) {
            updateStatusAndPayment(request, response);
        } else {
            doGet(request, response);
        }
    }

    public void listWithFilters(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String statusFilter = request.getParameter("status");
        String paymentStatusFilter = request.getParameter("paymentStatus");
        String searchFilter = request.getParameter("search");

        int page = 1;
        int pageSize = 10;

        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Appointment> appointments = appointmentDAO.findAppointmentsWithFilters(
                statusFilter, paymentStatusFilter, searchFilter, page, pageSize);

        int totalAppointments = appointmentDAO.getTotalFilteredAppointments(
                statusFilter, paymentStatusFilter, searchFilter);

        int totalPages = (int) Math.ceil((double) totalAppointments / pageSize);

        request.setAttribute("appointments", appointments);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalpages", totalPages);

        request.getRequestDispatcher("/WEB-INF/view/admin_pages/appointment_list.jsp").forward(request, response);
    }

    public void listUserAppointments(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        String statusFilter = request.getParameter("status");
        String paymentStatusFilter = request.getParameter("paymentStatus");
        String searchFilter = request.getParameter("search");

        int page = 1;
        int pageSize = 10;

        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Appointment> appointments = appointmentDAO.findUserAppointmentsWithFilters(
                userId, statusFilter, paymentStatusFilter, searchFilter, page, pageSize);

        int totalAppointments = appointmentDAO.getTotalUserFilteredAppointments(
                userId, statusFilter, paymentStatusFilter, searchFilter);

        int totalPages = (int) Math.ceil((double) totalAppointments / pageSize);

        request.setAttribute("appointments", appointments);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalpages", totalPages);

        request.getRequestDispatcher("/WEB-INF/view/home_pages/appointment_list.jsp").forward(request, response);
    }

    public void viewDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/appointment?action=list");
            return;
        }

        int appointmentId;
        try {
            appointmentId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/appointment?action=list");
            return;
        }

        String serviceSearch = request.getParameter("serviceSearch");
        List<AppointmentDetails> details = appointmentDAO.findDetailsByAppointmentId(appointmentId, serviceSearch);

        String currentStatus = "";
        String currentPaymentStatus = "";
        if (!details.isEmpty()) {
            currentStatus = details.get(0).getStatus();
            currentPaymentStatus = details.get(0).getPaymentStatus();
        }

        request.setAttribute("details", details);
        request.setAttribute("appointmentId", appointmentId);
        request.setAttribute("currentStatus", currentStatus);
        request.setAttribute("currentPaymentStatus", currentPaymentStatus);
        request.setAttribute("serviceSearch", serviceSearch == null ? "" : serviceSearch);

        request.getRequestDispatcher("/WEB-INF/view/admin_pages/appointment_details.jsp").forward(request, response);
    }

    public void viewUserAppointmentDetails(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/appointment?action=list");
            return;
        }

        int appointmentId;
        try {
            appointmentId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/appointment?action=list");
            return;
        }

        // Verify that the appointment belongs to the user
        Appointment appointment = appointmentDAO.findById(appointmentId).orElse(null);
        if (appointment == null || appointment.getCustomerId() != userId) {
            response.sendRedirect(request.getContextPath() + "/appointment?action=list");
            return;
        }

        String serviceSearch = request.getParameter("serviceSearch");
        List<AppointmentDetails> details = appointmentDAO.findDetailsByAppointmentId(appointmentId, serviceSearch);

        request.setAttribute("details", details);
        request.setAttribute("appointmentId", appointmentId);
        request.setAttribute("appointment", appointment);
        request.setAttribute("serviceSearch", serviceSearch == null ? "" : serviceSearch);

        request.getRequestDispatcher("/WEB-INF/view/home_pages/appointment_details.jsp").forward(request, response);
    }

    public void updateStatusAndPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("appointmentId");
        String newStatus = request.getParameter("status");
        String newPaymentStatus = request.getParameter("paymentStatus");

        if (idStr == null || idStr.isEmpty() || newStatus == null || newPaymentStatus == null) {
            response.sendRedirect(request.getContextPath() + "/appointment?action=list");
            return;
        }

        int appointmentId;
        try {
            appointmentId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/appointment?action=list");
            return;
        }

        boolean updated = appointmentDAO.updateStatusAndPayment(appointmentId, newStatus, newPaymentStatus);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/appointment?action=details&id=" + appointmentId + "&success=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/appointment?action=details&id=" + appointmentId + "&error=true");
        }
    }
}
