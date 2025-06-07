/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dao.EmailVerificationTokenDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import model.Customer;
import model.EmailVerificationToken;
import service.email.AsyncEmailService;
import validation.RegisterValidator;

/**
 *
 * @author quang
 */
@WebServlet(name = "RegisterController", urlPatterns = { "/register" })
public class RegisterController extends HttpServlet {

    final CustomerDAO customerDAO;
    final AsyncEmailService asyncEmailService;
    final EmailVerificationTokenDAO verificationTokenDAO;

    public RegisterController() {
        this.customerDAO = new CustomerDAO();
        this.asyncEmailService = new AsyncEmailService();
        this.verificationTokenDAO = new EmailVerificationTokenDAO();
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
            out.println("<title>Servlet SignUpController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Hello at " + request.getContextPath() + "</h1>");
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

        // Check if this is an AJAX validation request
        String validateType = request.getParameter("validate");
        String value = request.getParameter("value");

        if (validateType != null && value != null) {
            handleAjaxValidation(request, response, validateType, value);
            return;
        }

        String url = request.getContextPath();
        request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);

    }

    /**
     * Handle AJAX validation requests for duplicate checking
     */
    private void handleAjaxValidation(HttpServletRequest request, HttpServletResponse response,
            String validateType, String value) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        RegisterValidator validator = new RegisterValidator();
        boolean isDuplicate = false;
        String message = "";

        try (PrintWriter out = response.getWriter()) {
            if (value.trim().isEmpty()) {
                out.print("{\"valid\": false, \"message\": \"Giá trị không được để trống\"}");
                return;
            }

            switch (validateType.toLowerCase()) {
                case "email":
                    isDuplicate = validator.isEmailDuplicate(value.trim());
                    if (isDuplicate) {
                        message = "Email đã tồn tại trong hệ thống.";
                    } else {
                        message = "Email có thể sử dụng.";
                    }
                    break;

                case "phone":
                    isDuplicate = validator.isPhoneDuplicate(value.trim());
                    if (isDuplicate) {
                        message = "Số điện thoại đã tồn tại trong hệ thống.";
                    } else {
                        message = "Số điện thoại có thể sử dụng.";
                    }
                    break;

                default:
                    out.print("{\"valid\": false, \"message\": \"Loại validation không hỗ trợ\"}");
                    return;
            }

            // Return JSON response
            out.print("{\"valid\": " + !isDuplicate + ", \"isDuplicate\": " + isDuplicate + ", \"message\": \""
                    + message + "\"}");

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"valid\": false, \"message\": \"Lỗi hệ thống, vui lòng thử lại.\"}");
            }
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

        // retrieve form data and trim whitespace
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Trim all input fields to remove leading/trailing spaces
        if (fullName != null)
            fullName = fullName.trim();
        if (phone != null)
            phone = phone.trim();
        if (email != null)
            email = email.trim();
        // Note: Don't trim password as spaces might be intentional
        if (confirmPassword != null)
            confirmPassword = confirmPassword.trim();

        // Create validator instance
        RegisterValidator validator = new RegisterValidator();
        if (fullName == null || fullName.isBlank() || fullName.isEmpty() || fullName.length() < 6) {
            request.setAttribute("error", "Họ tên phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        }

        // Validate phone
        if (phone == null || !phone.matches("[0-9]{10,11}")) {
            request.setAttribute("error", "Số điện thoại phải là 10 hoặc 11 chữ số.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        }

        // Validate email
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("error", "Vui lòng nhập đúng định dạng email.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        }

        // Validate password
        if (password == null || password.trim().isEmpty() || password.length() < 6 || password.length() > 32) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        }

        // Check password confirmation
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu không khớp.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        }

        // Check for duplicate email
        if (validator.isEmailDuplicate(email)) {
            request.setAttribute("error", "Email đã tồn tại.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        }

        // Check for duplicate phone
        if (validator.isPhoneDuplicate(phone)) {
            request.setAttribute("error", "Số điện thoại đã tồn tại.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
            return;
        }

        // create new customer to store form data - pass plain password, it will be
        // hashed in DAO
        Customer newCustomer = new Customer(fullName, email, password, phone);

        // Set default values
        newCustomer.setIsActive(true);
        newCustomer.setLoyaltyPoints(0);

        // save data to database
        customerDAO.save(newCustomer);

        // Use POST-redirect-GET pattern to prevent refresh issues
        // Store success data in session temporarily
        HttpSession session = request.getSession();
        session.setAttribute("registrationEmail", email);
        session.setAttribute("registrationFullName", fullName);
        session.setAttribute("registrationPassword", password); // Store password for login pre-filling
        session.setAttribute("registrationSuccess", true);

        // Redirect to register success page with email parameter for refresh-proof
        // access
        response.sendRedirect(request.getContextPath() + "/register-success?email=" +
                java.net.URLEncoder.encode(email, "UTF-8"));

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
