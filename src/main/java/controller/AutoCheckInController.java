/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.BookingAppointmentDAO;
import dao.CheckinDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Optional;
import model.BookingAppointment;
import model.Checkin;

/**
 * Controller for handling automatic check-in via QR codes
 * 
 * @author quang
 */
@WebServlet(name = "AutoCheckInController", urlPatterns = { "/autocheckin" })
public class AutoCheckInController extends HttpServlet {

    private BookingAppointmentDAO bookingAppointmentDAO;
    private CheckinDAO checkinDAO;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     * 
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */

    // init method
    @Override
    public void init() throws ServletException {
        super.init();
        bookingAppointmentDAO = new BookingAppointmentDAO();
        checkinDAO = new CheckinDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AutoCheckInController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AutoCheckInController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     * 
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // get appointment id from request
        String appointmentIdStr = request.getParameter("appointmentId");

        if (appointmentIdStr == null || appointmentIdStr.trim().isEmpty()) {
            request.setAttribute("error", "ID lịch hẹn không hợp lệ");
            request.getRequestDispatcher("/WEB-INF/view/checkin/checkin-result.jsp").forward(request, response);
            return;
        }

        try {
            Integer appointmentId = Integer.parseInt(appointmentIdStr);

            // get appointment from database
            Optional<BookingAppointment> appointmentOpt = bookingAppointmentDAO.findById(appointmentId);

            if (!appointmentOpt.isPresent()) {
                request.setAttribute("error", "Không tìm thấy lịch hẹn với ID: " + appointmentId);
                request.getRequestDispatcher("/WEB-INF/view/checkin/checkin-result.jsp").forward(request, response);
                return;
            }

            BookingAppointment appointment = appointmentOpt.get();
            LocalDateTime now = LocalDateTime.now();

            // Check if appointment is in confirmed status (using SCHEDULED instead of
            // CONFIRMED for BookingAppointment)
            if (!"SCHEDULED".equals(appointment.getStatus())) {
                request.setAttribute("error", "Lịch hẹn chưa được xác nhận hoặc đã bị hủy");
                request.setAttribute("appointment", appointment);
                request.getRequestDispatcher("/WEB-INF/view/checkin/checkin-result.jsp").forward(request, response);
                return;
            }

            // Check if check-in is within allowed time window (10 minutes before
            // appointment start time)
            LocalDateTime appointmentStart = appointment.getStartTime();
            LocalDateTime earliestCheckinTime = appointmentStart.minusMinutes(10);
            LocalDateTime latestCheckinTime = appointmentStart.plusMinutes(30); // Allow 30 minutes after start for late
                                                                                // check-in

            if (now.isBefore(earliestCheckinTime)) {
                long minutesUntilCheckin = ChronoUnit.MINUTES.between(now, earliestCheckinTime);
                request.setAttribute("error",
                        "Bạn có thể check-in từ " + minutesUntilCheckin + " phút nữa (10 phút trước giờ hẹn)");
                request.setAttribute("appointment", appointment);
                request.getRequestDispatcher("/WEB-INF/view/checkin/checkin-result.jsp").forward(request, response);
                return;
            }

            if (now.isAfter(latestCheckinTime)) {
                request.setAttribute("error", "Đã quá thời gian check-in cho lịch hẹn này");
                request.setAttribute("appointment", appointment);
                request.getRequestDispatcher("/WEB-INF/view/checkin/checkin-result.jsp").forward(request, response);
                return;
            }

            // Check if already checked in
            if (checkinDAO.existsByAppointmentId(appointmentId)) {
                request.setAttribute("error", "Lịch hẹn này đã được check-in trước đó");
                request.setAttribute("appointment", appointment);
                request.getRequestDispatcher("/WEB-INF/view/checkin/checkin-result.jsp").forward(request, response);
                return;
            }

            // Perform check-in
            Checkin checkin = new Checkin();
            checkin.setAppointmentId(appointmentId);
            // Note: BookingAppointment doesn't have direct customerId, so we'll use a
            // placeholder for now
            // TODO: Get customer ID from BookingGroup via bookingGroupId
            checkin.setCustomerId(1); // Placeholder - needs to be fixed to get actual customer ID
            checkin.setCheckinTime(now);
            checkin.setStatus("SUCCESS");
            checkin.setNotes("Check-in tự động qua QR code");

            Checkin savedCheckin = checkinDAO.save(checkin);

            if (savedCheckin != null) {
                // Update appointment status to IN_PROGRESS if successfully checked in
                bookingAppointmentDAO.updateStatus(appointmentId, "IN_PROGRESS");

                // Set success attributes
                request.setAttribute("success", "Check-in thành công!");
                request.setAttribute("appointment", appointment);
                request.setAttribute("checkin", savedCheckin);
                request.getRequestDispatcher("/WEB-INF/view/checkin/checkin-result.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi thực hiện check-in. Vui lòng thử lại.");
                request.setAttribute("appointment", appointment);
                request.getRequestDispatcher("/WEB-INF/view/checkin/checkin-result.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID lịch hẹn không hợp lệ: " + appointmentIdStr);
            request.getRequestDispatcher("/WEB-INF/view/checkin/checkin-result.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/checkin/checkin-result.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * 
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     * 
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Auto Check-In Controller for QR Code based appointments";
    }// </editor-fold>

}
