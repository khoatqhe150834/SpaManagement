/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dao.PasswordResetTokenDAO;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import service.email.PasswordResetToken;

/**
 *
 * @author quang
 */
@WebServlet(name = "PasswordController", urlPatterns = {"/reset-password", "/change-password"})
public class PasswordController extends HttpServlet {

    private CustomerDAO customerDAO;
    private PasswordResetTokenDAO passwordResetTokenDao;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/OverriddenMethodBody

        customerDAO = new CustomerDAO();
        passwordResetTokenDao = new PasswordResetTokenDAO();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ResetPasswordController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ResetPasswordController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();

        if (servletPath == null) {

            request.getRequestDispatcher("/").forward(request, response);
        }

        switch (servletPath) {
            case "/reset-password":
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
                break;

            case "/change-password":
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);

                break;
            default:
                throw new AssertionError();
        }

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if (servletPath == null) {

            request.getRequestDispatcher("/").forward(request, response);
        }

        switch (servletPath) {
            case "/reset-password":
                handleResetPassword(request, response);
                break;

            case "/change-password":
                request.getRequestDispatcher("/reset-password.jsp").forward(request, response);

                break;
            default:
                throw new AssertionError();
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String email = request.getParameter("email").trim();

        // check if email is in database
        boolean isExistsByEmail = customerDAO.isExistsByEmail(email);

        if (isExistsByEmail) {

            try {
                String message = "Email tồn tại trong hệ thống";
                request.setAttribute("message", message);

                // find user or customer by email
                PasswordResetToken passwordResetToken = new PasswordResetToken(email);

                passwordResetTokenDao.save(passwordResetToken);
            } catch (SQLException ex) {
                Logger.getLogger(PasswordController.class.getName()).log(Level.SEVERE, null, ex);
            }

            // send email 
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);

        } else {

            // email khong ton tai trong he thong
            String error = "Email không tồn tại trong hệ thống";

            request.setAttribute("error", error);

            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        }

    }

}
