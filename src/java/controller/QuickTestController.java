package controller;

import dao.CustomerDAO;
import dao.UserDAO;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "QuickTestController", urlPatterns = {"/quick-test"})
public class QuickTestController extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    private CustomerDAO customerDAO = new CustomerDAO();
    private AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Quick Login Test</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; padding: 20px; }");
            out.println(".success { color: green; background: #d4edda; padding: 10px; border-radius: 5px; margin: 10px 0; }");
            out.println(".error { color: red; background: #f8d7da; padding: 10px; border-radius: 5px; margin: 10px 0; }");
            out.println(".info { color: blue; background: #d1ecf1; padding: 10px; border-radius: 5px; margin: 10px 0; }");
            out.println("button { background: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 3px; cursor: pointer; margin: 5px; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Quick Login Test</h1>");
            
            // Test 1: Reset password to 123456
            out.println("<h3>Step 1: Reset Password</h3>");
            try {
                boolean resetSuccess = accountDAO.updateCustomerPassword("lanepyn@mailinator.com", "123456");
                if (resetSuccess) {
                    out.println("<div class='success'>✅ Password successfully reset to '123456' for lanepyn@mailinator.com</div>");
                } else {
                    out.println("<div class='error'>❌ Failed to reset password</div>");
                    out.println("</body></html>");
                    return;
                }
            } catch (Exception e) {
                out.println("<div class='error'>❌ Error resetting password: " + e.getMessage() + "</div>");
                out.println("</body></html>");
                return;
            }
            
            // Test 2: Verify the password was set correctly
            out.println("<h3>Step 2: Verify Password Reset</h3>");
            String testEmail = "lanepyn@mailinator.com";
            String testPassword = "123456";
            
            // Test with CustomerDAO method (same as LoginController uses)
            Customer customer = customerDAO.getCustomerByEmailAndPassword(testEmail, testPassword);
            
            if (customer != null) {
                out.println("<div class='success'>✅ CustomerDAO.getCustomerByEmailAndPassword() - SUCCESS</div>");
                out.println("<div class='info'>Customer ID: " + customer.getCustomerId() + "</div>");
                out.println("<div class='info'>Full Name: " + customer.getFullName() + "</div>");
                out.println("<div class='info'>Is Active: " + customer.getIsActive() + "</div>");
            } else {
                out.println("<div class='error'>❌ CustomerDAO.getCustomerByEmailAndPassword() - FAILED</div>");
            }
            
            // Test 3: Simulate exact LoginController logic
            out.println("<h3>Step 3: Simulate LoginController Logic</h3>");
            
            // This is the exact logic from your LoginController
            User user = userDAO.getUserByEmailAndPassword(testEmail, testPassword);
            if (user != null) {
                out.println("<div class='info'>Found in Users table (staff/admin)</div>");
            } else {
                out.println("<div class='info'>Not found in Users table (expected for customer account)</div>");
                
                // Try customer login (this should work)
                Customer customerLogin = customerDAO.getCustomerByEmailAndPassword(testEmail, testPassword);
                if (customerLogin != null) {
                    out.println("<div class='success'>✅ CUSTOMER LOGIN SUCCESSFUL!</div>");
                    out.println("<div class='success'>Login should work with these credentials:</div>");
                    out.println("<div class='success'>Email: lanepyn@mailinator.com</div>");
                    out.println("<div class='success'>Password: 123456</div>");
                } else {
                    out.println("<div class='error'>❌ Customer login failed</div>");
                }
            }
            
            // Test 4: Direct password verification
            out.println("<h3>Step 4: Manual Password Check</h3>");
            try {
                java.sql.Connection conn = db.DBContext.getConnection();
                java.sql.PreparedStatement ps = conn.prepareStatement("SELECT hash_password FROM customers WHERE email = ?");
                ps.setString(1, testEmail);
                java.sql.ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    String storedHash = rs.getString("hash_password");
                    boolean matches = BCrypt.checkpw(testPassword, storedHash);
                    out.println("<div class='" + (matches ? "success" : "error") + "'>" + 
                               (matches ? "✅" : "❌") + " Direct BCrypt check: " + matches + "</div>");
                    out.println("<div class='info'>Stored hash: " + storedHash.substring(0, 30) + "...</div>");
                }
            } catch (Exception e) {
                out.println("<div class='error'>Error checking password: " + e.getMessage() + "</div>");
            }
            
            out.println("<hr>");
            out.println("<h3>Next Steps:</h3>");
            out.println("<button onclick=\"window.open('" + request.getContextPath() + "/login', '_blank')\">Test Login Page</button>");
            out.println("<button onclick=\"window.open('" + request.getContextPath() + "/debug-login?email=lanepyn@mailinator.com&password=123456', '_blank')\">Run Full Debug</button>");
            out.println("<button onclick=\"location.reload()\">Run Test Again</button>");
            
            out.println("</body>");
            out.println("</html>");
        }
    }
} 