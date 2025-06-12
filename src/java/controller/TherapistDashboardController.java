/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * TherapistDashboardController handles all therapist dashboard routes
 * URL Pattern: /therapist-dashboard/*
 */
@WebServlet(name = "TherapistDashboardController", urlPatterns = { "/therapist-dashboard/*" })
public class TherapistDashboardController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     * 
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Check authentication
            HttpSession session = request.getSession();
            if (session == null || session.getAttribute("user") == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Get the path info
            String pathInfo = request.getPathInfo();
            if (pathInfo == null) {
                pathInfo = "/";
            }

            // Route handling
            String viewPath = getViewPath(pathInfo);
            if (viewPath != null) {
                request.getRequestDispatcher(viewPath).forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Trang không tồn tại");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/common/error.jsp").forward(request, response);
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
        processRequest(request, response);
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
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     * 
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }

    private String getViewPath(String pathInfo) {
        switch (pathInfo) {
            // Main Dashboard
            case "/":
                return "/WEB-INF/view/therapist/dashboard/dashboard.jsp";

            // Appointments
            case "/appointments/today":
                return "/WEB-INF/view/therapist/appointments/today/today.jsp";
            case "/appointments/upcoming":
                return "/WEB-INF/view/therapist/appointments/upcoming/upcoming.jsp";
            case "/appointments/history":
                return "/WEB-INF/view/therapist/appointments/history/history.jsp";

            // Treatments
            case "/treatments/active":
                return "/WEB-INF/view/therapist/treatments/active/active.jsp";
            case "/treatments/completed":
                return "/WEB-INF/view/therapist/treatments/completed/completed.jsp";
            case "/treatments/notes":
                return "/WEB-INF/view/therapist/treatments/notes/notes.jsp";

            // Clients
            case "/clients/assigned":
                return "/WEB-INF/view/therapist/clients/assigned/assigned.jsp";
            case "/clients/history":
                return "/WEB-INF/view/therapist/clients/history/history.jsp";
            case "/clients/notes":
                return "/WEB-INF/view/therapist/clients/notes/notes.jsp";

            // Schedule
            case "/schedule/daily":
                return "/WEB-INF/view/therapist/schedule/daily/daily.jsp";
            case "/schedule/weekly":
                return "/WEB-INF/view/therapist/schedule/weekly/weekly.jsp";
            case "/schedule/requests":
                return "/WEB-INF/view/therapist/schedule/requests/requests.jsp";

            // Performance
            case "/performance/stats":
                return "/WEB-INF/view/therapist/performance/stats/stats.jsp";
            case "/performance/feedback":
                return "/WEB-INF/view/therapist/performance/feedback/feedback.jsp";

            // Training
            case "/training/courses":
                return "/WEB-INF/view/therapist/training/courses/courses.jsp";
            case "/training/certificates":
                return "/WEB-INF/view/therapist/training/certificates/certificates.jsp";

            // Inventory
            case "/inventory/supplies":
                return "/WEB-INF/view/therapist/inventory/supplies/supplies.jsp";
            case "/inventory/requests":
                return "/WEB-INF/view/therapist/inventory/requests/requests.jsp";

            // Dashboard sub-pages
            case "/dashboard/profile":
                return "/WEB-INF/view/therapist/dashboard/profile.jsp";
            case "/dashboard/notifications":
                return "/WEB-INF/view/therapist/dashboard/notifications.jsp";

            default:
                return null;
        }
    }
    // </editor-fold>

}
