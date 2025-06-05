/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import model.Customer;
import org.mindrot.jbcrypt.BCrypt;
import validation.RegisterValidator;

/**
 *
 * @author quang
 */
@WebServlet(name = "RegisterController", urlPatterns = { "/register" })
public class RegisterController extends HttpServlet {

    final CustomerDAO customerDAO;

    public RegisterController() {
        this.customerDAO = new CustomerDAO();
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

        String url = request.getContextPath();
        request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);

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

        // retrieve form data
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Create validator instance
        RegisterValidator validator = new RegisterValidator();
        if (fullName == null || fullName.length() < 6) {
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

        // create new customer to store form data - pass plain password, it will be hashed in DAO
        Customer newCustomer = new Customer(fullName, email, password, phone);
        
        // Set default values
        newCustomer.setIsActive(true);
        newCustomer.setLoyaltyPoints(0);

        // save data to database
        customerDAO.save(newCustomer);

        // Set success message in session for login page
        request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập với tài khoản mới.");

        // redirect to login page
        request.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(request, response);

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
