/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dao.RememberMeTokenDAO;
import dao.UserDAO;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;
import model.RememberMeToken;
import model.RoleConstants;
import model.User;

/**
 *
 * @author quang
 */
@WebServlet(name = "LoginController", urlPatterns = { "/login" })
public class LoginController extends HttpServlet {

    private final int COOKIE_DURATION = 30;

    private CustomerDAO customerDAO;
    private UserDAO userDAO;

    private RememberMeTokenDAO rememberMeTokenDAO;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        customerDAO = new CustomerDAO();
        userDAO = new UserDAO();
        rememberMeTokenDAO = new RememberMeTokenDAO();
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

        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("authenticated") != null
                && (Boolean) session.getAttribute("authenticated")) {

            // User is already logged in, check their type and redirect accordingly
            if (session.getAttribute("customer") != null) {
                // Customer is logged in - check if verified
                Customer customer = (Customer) session.getAttribute("customer");
                try {
                    if (!customerDAO.isCustomerVerified(customer.getEmail())) {
                        // Email not verified, redirect to verification pending page
                        response.sendRedirect(request.getContextPath() + "/verification-pending");
                        return;
                    }
                } catch (RuntimeException ex) {
                    Logger.getLogger(LoginController.class.getName()).log(Level.SEVERE,
                            "Error checking customer verification status", ex);
                    // If verification check fails, redirect to verification pending as safety
                    // measure
                    response.sendRedirect(request.getContextPath() + "/verification-pending");
                    return;
                }
                // Customer is verified, redirect to homepage
                response.sendRedirect(request.getContextPath() + "/");
                return;
            } else if (session.getAttribute("user") != null) {
                // Staff/Admin is logged in
                User user = (User) session.getAttribute("user");
                String redirectUrl = getRedirectUrlForRole(user.getRoleId());
                response.sendRedirect(request.getContextPath() + redirectUrl);
                return;
            }
        }

        // Check for remember me cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberedUser".equals(cookie.getName())) {
                    String tokenValue = cookie.getValue();
                    if (tokenValue != null && !tokenValue.isEmpty()) {
                        try {
                            // Get token from database
                            RememberMeToken token = rememberMeTokenDAO.findToken(tokenValue);
                            if (token != null) {
                                // Set email and password as request attributes to pre-fill form
                                request.setAttribute("rememberedEmail", token.getEmail());
                                request.setAttribute("rememberedPassword", token.getPassword());
                                request.setAttribute("rememberMeChecked", true);
                            }
                        } catch (SQLException ex) {
                            Logger.getLogger(LoginController.class.getName()).log(Level.SEVERE,
                                    "Error retrieving remember me token", ex);
                            // Continue without pre-filling - don't break the login page
                        }
                    }
                    break; // Found the cookie, no need to continue
                }
            }
        }

        // Check if verification email was resent successfully
        String resent = request.getParameter("resent");
        if ("true".equals(resent)) {
            request.setAttribute("success",
                    "Email xác thực đã được gửi lại thành công! Vui lòng kiểm tra hộp thư của bạn.");
        }

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
            // Preserve attempted values
            request.setAttribute("attemptedEmail", email != null ? email : "");
            request.setAttribute("attemptedPassword", password != null ? password : "");
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

            handleRememberLogin(request, response, email, password);
            // Redirect based on role
            String redirectUrl = getRedirectUrlForRole(user.getRoleId());
            response.sendRedirect(request.getContextPath() + redirectUrl);
            return;
        }

        // If not staff, try customer login
        Customer customer = customerDAO.getCustomerByEmailAndPassword(email, password);
        if (customer != null) {
            // Check if customer's email is verified BEFORE allowing login
            try {
                if (!customerDAO.isCustomerVerified(email)) {
                    // Email not verified, redirect to email verification required page
                    response.sendRedirect(request.getContextPath() + "/email-verification-required?email=" +
                            java.net.URLEncoder.encode(email, "UTF-8"));
                    return;
                }
            } catch (RuntimeException ex) {
                Logger.getLogger(LoginController.class.getName()).log(Level.SEVERE,
                        "Error checking customer verification status", ex);
                // If verification check fails, redirect to verification page as safety measure
                response.sendRedirect(request.getContextPath() + "/email-verification-required?email=" +
                        java.net.URLEncoder.encode(email, "UTF-8"));
                return;
            }

            // Customer login successful AND verified
            HttpSession session = request.getSession();
            session.setAttribute("customer", customer);
            session.setAttribute("authenticated", true);

            // Set userType based on role using RoleConstants
            String userType = RoleConstants.getUserTypeFromRole(customer.getRoleId());
            session.setAttribute("userType", userType);

            handleRememberLogin(request, response, email, password);

            // Email is verified, redirect to homepage for customers
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // If both logins failed
        request.setAttribute("error", "Sai mật khẩu hoặc tài khoản. Vui lòng thử lại!");
        // Preserve attempted values so user doesn't have to retype
        request.setAttribute("attemptedEmail", email);
        request.setAttribute("attemptedPassword", password);
        request.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(request, response);
    }

    private String getRedirectUrlForRole(Integer roleId) {
        if (roleId == null) {
            return "/";
        }

        switch (roleId) {
            case RoleConstants.ADMIN_ID:
                // return "/admin/dashboard";
                return "/";

            case RoleConstants.MANAGER_ID:
                return "/";
            // return "/manager/dashboard";
            case RoleConstants.THERAPIST_ID:
                return "/";
            // return "/therapist/dashboard";
            case RoleConstants.RECEPTIONIST_ID:
                return "/";
            // return "/receptionist/dashboard";
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

    public void handleRememberLogin(HttpServletRequest request, HttpServletResponse response, String email,
            String password) throws ServletException, IOException {

        String rememberMe = request.getParameter("rememberMe");

        // Check if the checkbox is checked (true) or not (false)
        boolean isRememberMe = "true".equals(rememberMe);

        if (isRememberMe) {
            try {
                // Delete any existing tokens for this email first to ensure only one token per
                // email
                rememberMeTokenDAO.deleteTokensByEmail(email);

                // ⚠️ SECURITY WARNING: This stores the password - NOT RECOMMENDED!
                RememberMeToken token = new RememberMeToken(email, password);

                // Save token to database
                rememberMeTokenDAO.insertToken(token);

                // Create cookie with the token as value
                Cookie userCookie = new Cookie("rememberedUser", token.getToken());
                userCookie.setMaxAge(COOKIE_DURATION * 24 * 60 * 60); // 30 days
                userCookie.setPath("/");
                userCookie.setHttpOnly(true);
                userCookie.setSecure(request.isSecure());

                // Add cookie to response
                response.addCookie(userCookie);

            } catch (SQLException ex) {
                Logger.getLogger(LoginController.class.getName()).log(Level.SEVERE,
                        "Error saving remember me token", ex);
                // Don't fail login just because remember me failed
            }
        } else {
            // User unchecked remember me - clear existing tokens
            try {
                // Delete existing tokens for this user
                rememberMeTokenDAO.deleteTokensByEmail(email);

                // Clear the cookie
                Cookie clearCookie = new Cookie("rememberedUser", "");
                clearCookie.setMaxAge(0); // Delete immediately
                clearCookie.setPath("/");
                response.addCookie(clearCookie);

            } catch (SQLException ex) {
                Logger.getLogger(LoginController.class.getName()).log(Level.SEVERE,
                        "Error clearing remember me token", ex);
            }
        }
    }
}
