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
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import model.Appointment;

@WebServlet(name = "AppointmentController", urlPatterns = {"/appointment"})
public class AppointmentController extends HttpServlet {

    private AppointmentDAO appointmentDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO(); // Inject DAO
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            listWithFilters(request, response);
        }else {
            switch (action) {
                case "details":

                    break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
            if (page < 1) page = 1;
        } catch (NumberFormatException e) {
            page = 1;
        }
    }

    AppointmentDAO appointmentDAO = new AppointmentDAO();
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

}
