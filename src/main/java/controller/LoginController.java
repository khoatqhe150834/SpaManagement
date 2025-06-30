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
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.Map;

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
    private Gson gson;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        customerDAO = new CustomerDAO();
        userDAO = new UserDAO();
        rememberMeTokenDAO = new RememberMeTokenDAO();
        gson = new Gson();
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
                        // Email not verified, redirect to email verification required page
                        response.sendRedirect(request.getContextPath() + "/email-verification-required?email=" +
                                java.net.URLEncoder.encode(customer.getEmail(), "UTF-8"));
                        return;
                    }
                } catch (RuntimeException ex) {
                    Logger.getLogger(LoginController.class.getName()).log(Level.SEVERE,
                            "Error checking customer verification status", ex);
                    // If verification check fails, redirect to email verification required as
                    // safety measure
                    response.sendRedirect(request.getContextPath() + "/email-verification-required?email=" +
                            java.net.URLEncoder.encode(customer.getEmail(), "UTF-8"));
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

        // Check if verification email was resent successfully
        String resent = request.getParameter("resent");
        if ("true".equals(resent)) {
            request.setAttribute("success",
                    "Email xác thực đã được gửi lại thành công! Vui lòng kiểm tra hộp thư của bạn.");
        }

        // Check if user just changed password successfully - THIS TAKES PRECEDENCE
        String passwordChanged = request.getParameter("passwordChanged");
        boolean isPasswordChange = "true".equals(passwordChanged);

        if (isPasswordChange && session != null) {
            Boolean passwordChangeSuccess = (Boolean) session.getAttribute("passwordChangeSuccess");
            String passwordChangeEmail = (String) session.getAttribute("passwordChangeEmail");
            String passwordChangePassword = (String) session.getAttribute("passwordChangeLoginPassword");

            if (passwordChangeSuccess != null && passwordChangeSuccess && passwordChangeEmail != null) {
                request.setAttribute("success",
                        "Mật khẩu đã được thay đổi thành công! Vui lòng đăng nhập bằng mật khẩu mới.");
                request.setAttribute("prefillEmail", passwordChangeEmail);

                // Prefill the new password for convenience
                if (passwordChangePassword != null) {
                    request.setAttribute("prefillPassword", passwordChangePassword);
                }

                // Clear the session data after use
                session.removeAttribute("passwordChangeSuccess");
                session.removeAttribute("passwordChangeEmail");
                session.removeAttribute("passwordChangeLoginPassword");

                // Don't use remember-me data when coming from password change
                request.setAttribute("rememberMeChecked", false);
            }
        }

        // Check for remember me cookie ONLY if NOT coming from password change
        if (!isPasswordChange) {
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
        }

        // Check for email parameter to pre-fill the form (e.g., from verification
        // success page)
        // BUT NOT if coming from password change (which has higher priority)
        String emailParam = request.getParameter("email");
        String verifiedParam = request.getParameter("verified");

        if (emailParam != null && !emailParam.trim().isEmpty() && !isPasswordChange) {
            // Only set prefillEmail if not already set by password change
            if (request.getAttribute("prefillEmail") == null) {
                request.setAttribute("prefillEmail", emailParam);
            }

            // If coming from successful verification, show success message
            if ("true".equals(verifiedParam)) {
                request.setAttribute("success",
                        "Tài khoản của bạn đã được xác thực thành công! Vui lòng đăng nhập để tiếp tục.");
            }

            // Check if there's verification login data in session
            if (session != null) {
                String verificationEmail = (String) session.getAttribute("verificationLoginEmail");
                String verificationPassword = (String) session.getAttribute("verificationLoginPassword");

                if (verificationEmail != null && verificationEmail.equals(emailParam.trim())
                        && verificationPassword != null) {
                    // Use the password from recent registration
                    request.setAttribute("prefillPassword", verificationPassword);
                    // Clear the verification data after use for security
                    session.removeAttribute("verificationLoginEmail");
                    session.removeAttribute("verificationLoginPassword");
                } else {
                    // When coming from email verification without registration password, don't use
                    // remember-me data
                    // This prevents old passwords from interfering with newly verified accounts
                    request.removeAttribute("rememberedPassword");
                }
            }

            // Don't use remember-me data when coming from email verification
            request.removeAttribute("rememberedEmail");
            request.setAttribute("rememberMeChecked", false);
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
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> jsonResponse = new HashMap<>();

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Email và mật khẩu không được để trống.");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        // First try to login as staff/admin
        User user = userDAO.getUserByEmailAndPassword(email, password);
        if (user != null) {
            // Staff/Admin login successful
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("authenticated", true);

            String userType = RoleConstants.getUserTypeFromRole(user.getRoleId());
            session.setAttribute("userType", userType);

            handleRememberLogin(request, response, email, password);
            String redirectUrl = getRedirectUrlForRole(user.getRoleId());

            jsonResponse.put("success", true);
            jsonResponse.put("redirectUrl", request.getContextPath() + redirectUrl);
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        // If not staff, try customer login
        Customer customer = customerDAO.getCustomerByEmailAndPassword(email, password);
        if (customer != null) {
            try {
                if (!customerDAO.isCustomerVerified(email)) {
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "Tài khoản của bạn chưa được xác thực. Vui lòng kiểm tra email.");
                    jsonResponse.put("verificationRequired", true);
                    jsonResponse.put("email", email);
                    response.getWriter().write(gson.toJson(jsonResponse));
                    return;
                }
            } catch (RuntimeException ex) {
                Logger.getLogger(LoginController.class.getName()).log(Level.SEVERE,
                        "Error checking customer verification status", ex);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Lỗi hệ thống khi kiểm tra xác thực tài khoản.");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            // Customer login successful AND verified
            HttpSession session = request.getSession();
            session.setAttribute("customer", customer);
            session.setAttribute("authenticated", true);

            String userType = RoleConstants.getUserTypeFromRole(customer.getRoleId());
            session.setAttribute("userType", userType);

            handleRememberLogin(request, response, email, password);

            jsonResponse.put("success", true);
            jsonResponse.put("redirectUrl", request.getContextPath() + "/");
            response.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        // If both logins failed
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        jsonResponse.put("success", false);
        jsonResponse.put("message", "Email hoặc mật khẩu không chính xác.");
        response.getWriter().write(gson.toJson(jsonResponse));
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
