/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.CustomerDAO;
import dao.UserDAO;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import model.Customer;
import model.RoleConstants;
import model.User;

/**
 *
 * @author quang
 */
@WebServlet(name = "LoginController", urlPatterns = { "/login" })
public class LoginController extends HttpServlet {

    private CustomerDAO customerDAO;
    private UserDAO userDAO;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        customerDAO = new CustomerDAO();
        userDAO = new UserDAO();
    }

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
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginController at " + request.getContextPath() + "</h1>");
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
        
        
        
        
        request.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(request, response);
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
        // get email and password
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Các trường không được để trống.");
            request.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(request, response);
            return;
        }

        // First try to login as staff/admin
        User user = userDAO.getUserByEmailAndPassword(email, password);
        if (user != null) {
            // Staff/Admin login successful
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("authenticated", true);

            // Set userType based on role using RoleConstants
            String userType = RoleConstants.getUserTypeFromRole(user.getRoleId());
            session.setAttribute("userType", userType);

            // Redirect based on role
            String redirectUrl = getRedirectUrlForRole(user.getRoleId());
            response.sendRedirect(request.getContextPath() + redirectUrl);
            return;
        }

        // If not staff, try customer login
        Customer customer = customerDAO.getCustomerByEmailAndPassword(email, password);
        if (customer != null) {
            // Customer login successful
            HttpSession session = request.getSession();
            session.setAttribute("customer", customer);
            session.setAttribute("authenticated", true);

            // Set userType based on role using RoleConstants
            String userType = RoleConstants.getUserTypeFromRole(customer.getRoleId());
            session.setAttribute("userType", userType);

            // Redirect to homepage for customers
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // If both logins failed
        request.setAttribute("error", "Sai mật khẩu hoặc tài khoản. Vui lòng thử lại!");
        request.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(request, response);
    }

    private String getRedirectUrlForRole(Integer roleId) {
        if (roleId == null) {
            return "/";
        }

        switch (roleId) {
            case RoleConstants.ADMIN_ID:
                return "/admin/dashboard";
            case RoleConstants.MANAGER_ID:
                return "/manager/dashboard";
            case RoleConstants.THERAPIST_ID:
                return "/therapist/dashboard";
            case RoleConstants.RECEPTIONIST_ID:
                return "/receptionist/dashboard";
            default:
                return "/";
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

}
