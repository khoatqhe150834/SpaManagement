package controller;

import dao.CustomerDAO;
import dao.UserDAO;
import dao.AccountDAO;
import db.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "ResetPasswordDebugController", urlPatterns = {"/reset-password-debug"})
public class ResetPasswordDebugController extends HttpServlet {
    
    private AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Reset Password Debug</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; padding: 20px; }");
            out.println(".success { color: green; }");
            out.println(".error { color: red; }");
            out.println(".warning { color: orange; }");
            out.println("form { background: #f5f5f5; padding: 20px; border-radius: 5px; max-width: 500px; }");
            out.println("input { width: 100%; padding: 8px; margin: 5px 0; }");
            out.println("button { background: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 3px; cursor: pointer; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Password Reset Debug Tool</h1>");
            out.println("<p class='warning'><strong>⚠️ WARNING:</strong> This is a debug tool for development only!</p>");
            
            out.println("<form method='post'>");
            out.println("<h3>Reset Password</h3>");
            out.println("<label>Email:</label><br>");
            out.println("<input type='email' name='email' required placeholder='Enter email address'><br><br>");
            out.println("<label>New Password:</label><br>");
            out.println("<input type='text' name='password' required placeholder='Enter new password'><br><br>");
            out.println("<label>Account Type:</label><br>");
            out.println("<select name='accountType' style='width: 100%; padding: 8px;'>");
            out.println("<option value='customer'>Customer</option>");
            out.println("<option value='user'>User/Staff</option>");
            out.println("</select><br><br>");
            out.println("<button type='submit'>Reset Password</button>");
            out.println("</form>");
            
            out.println("<hr>");
            out.println("<h3>Quick Reset for Your Account</h3>");
            out.println("<p>Click to reset <strong>lanepyn@mailinator.com</strong> password to <strong>123456</strong>:</p>");
            out.println("<form method='post'>");
            out.println("<input type='hidden' name='email' value='lanepyn@mailinator.com'>");
            out.println("<input type='hidden' name='password' value='123456'>");
            out.println("<input type='hidden' name='accountType' value='customer'>");
            out.println("<button type='submit' style='background: #28a745;'>Reset to 123456</button>");
            out.println("</form>");
            
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String accountType = request.getParameter("accountType");
        
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Password Reset Result</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; padding: 20px; }");
            out.println(".success { color: green; background: #d4edda; padding: 10px; border-radius: 5px; }");
            out.println(".error { color: red; background: #f8d7da; padding: 10px; border-radius: 5px; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Password Reset Result</h1>");
            
            try {
                boolean success = false;
                
                if ("customer".equals(accountType)) {
                    success = accountDAO.updateCustomerPassword(email, password);
                } else if ("user".equals(accountType)) {
                    success = accountDAO.updateUserPassword(email, password);
                }
                
                if (success) {
                    out.println("<div class='success'>");
                    out.println("<h3>✅ Password Reset Successful!</h3>");
                    out.println("<p><strong>Email:</strong> " + email + "</p>");
                    out.println("<p><strong>New Password:</strong> " + password + "</p>");
                    out.println("<p><strong>Account Type:</strong> " + accountType + "</p>");
                    out.println("<p>You can now login with these credentials.</p>");
                    out.println("</div>");
                    
                    out.println("<p><a href='" + request.getContextPath() + "/login'>Go to Login Page</a></p>");
                    out.println("<p><a href='" + request.getContextPath() + "/debug-login?email=" + email + "&password=" + password + "'>Test Login Again</a></p>");
                } else {
                    out.println("<div class='error'>");
                    out.println("<h3>❌ Password Reset Failed!</h3>");
                    out.println("<p>Email might not exist in the " + accountType + " table.</p>");
                    out.println("</div>");
                }
                
            } catch (Exception e) {
                out.println("<div class='error'>");
                out.println("<h3>❌ Error occurred:</h3>");
                out.println("<p>" + e.getMessage() + "</p>");
                out.println("</div>");
            }
            
            out.println("<p><a href='" + request.getContextPath() + "/reset-password-debug'>← Back to Reset Tool</a></p>");
            out.println("</body>");
            out.println("</html>");
        }
    }
} 