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
import model.AppointmentDetails;

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
        } else {
            switch (action) {
                case "details":
                    viewDetails(request, response);
                    break;
                default:
                    listWithFilters(request, response);
                    break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chúng ta để update bằng POST
        String action = request.getParameter("action");
        if (action.equals("update")) {
            updateStatusAndPayment(request, response);
        } else {
            // Nếu còn các POST action khác, đặt ở đây
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

    public void viewDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1) Lấy appointment_id từ parameter, nếu không hợp lệ thì redirect về list
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

        // 2) Lấy thêm tham số tìm kiếm serviceName (có thể null hoặc rỗng)
        String serviceSearch = request.getParameter("serviceSearch");

        // 3) Gọi DAO để lấy danh sách chi tiết theo appointmentId và serviceSearch
        List<AppointmentDetails> details = appointmentDAO.findDetailsByAppointmentId(appointmentId, serviceSearch);

        // 4) Lấy thông tin appointment để hiển thị status hiện tại
        String currentStatus = "";
        String currentPaymentStatus = "";
        if (!details.isEmpty()) {
            // Lấy status từ detail đầu tiên (vì tất cả details của cùng 1 appointment sẽ có cùng status)
            currentStatus = details.get(0).getStatus();
            currentPaymentStatus = details.get(0).getPaymentStatus();
        }

        // 5) Truyền sang JSP:
        request.setAttribute("details", details);
        request.setAttribute("appointmentId", appointmentId);
        request.setAttribute("currentStatus", currentStatus);
        request.setAttribute("currentPaymentStatus", currentPaymentStatus);
        // Giữ lại giá trị serviceSearch để hiển thị trong ô tìm kiếm
        request.setAttribute("serviceSearch", serviceSearch == null ? "" : serviceSearch);

        request.getRequestDispatcher("/WEB-INF/view/admin_pages/appointment_details.jsp").forward(request, response);
    }

    public void updateStatusAndPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1) Lấy tham số từ form: appointmentId, status, paymentStatus.
        String idStr = request.getParameter("appointmentId");
        String newStatus = request.getParameter("status");
        String newPaymentStatus = request.getParameter("paymentStatus");

        if (idStr == null || idStr.isEmpty() || newStatus == null || newPaymentStatus == null) {
            // Thiếu dữ liệu → redirect về list
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

        // 2) Gọi DAO để cập nhật
        boolean updated = appointmentDAO.updateStatusAndPayment(appointmentId, newStatus, newPaymentStatus);

        // 3) Sau khi cập nhật xong, redirect về trang details với thông báo thành công
        if (updated) {
            response.sendRedirect(request.getContextPath() + "/appointment?action=details&id=" + appointmentId + "&success=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/appointment?action=details&id=" + appointmentId + "&error=true");
        }
    }

}
