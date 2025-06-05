package controller;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "TestRegistrationController", urlPatterns = {"/test-registration"})
public class TestRegistrationController extends HttpServlet {
    
    private CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Test Registration</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; padding: 20px; }");
            out.println(".success { color: green; background: #d4edda; padding: 10px; border-radius: 5px; margin: 10px 0; }");
            out.println(".error { color: red; background: #f8d7da; padding: 10px; border-radius: 5px; margin: 10px 0; }");
            out.println(".info { color: blue; background: #d1ecf1; padding: 10px; border-radius: 5px; margin: 10px 0; }");
            out.println("form { background: #f8f9fa; padding: 20px; border-radius: 5px; max-width: 500px; margin: 20px 0; }");
            out.println("input, select { width: 100%; padding: 8px; margin: 5px 0; }");
            out.println("button { background: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 3px; cursor: pointer; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Test Registration Process</h1>");
            out.println("<p>This will test if the registration fixes work correctly.</p>");
            
            // Quick test form
            out.println("<form method='post'>");
            out.println("<h3>Create Test Account</h3>");
            out.println("<label>Full Name:</label><br>");
            out.println("<input type='text' name='fullName' value='Test User Registration' required><br><br>");
            out.println("<label>Email:</label><br>");
            out.println("<input type='email' name='email' value='testuser" + System.currentTimeMillis() + "@example.com' required><br><br>");
            out.println("<label>Phone:</label><br>");
            out.println("<input type='text' name='phone' value='09" + (System.currentTimeMillis() % 100000000L) + "' required><br><br>");
            out.println("<label>Password:</label><br>");
            out.println("<input type='text' name='password' value='123456' required><br><br>");
            out.println("<button type='submit'>Create Test Account</button>");
            out.println("</form>");
            
            out.println("<hr>");
            out.println("<h3>Quick Links:</h3>");
            out.println("<a href='" + request.getContextPath() + "/register'>Go to Registration Page</a><br>");
            out.println("<a href='" + request.getContextPath() + "/login'>Go to Login Page</a><br>");
            out.println("<a href='" + request.getContextPath() + "/debug-login'>Debug Login Tool</a>");
            
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Registration Test Result</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; padding: 20px; }");
            out.println(".success { color: green; background: #d4edda; padding: 10px; border-radius: 5px; margin: 10px 0; }");
            out.println(".error { color: red; background: #f8d7da; padding: 10px; border-radius: 5px; margin: 10px 0; }");
            out.println(".info { color: blue; background: #d1ecf1; padding: 10px; border-radius: 5px; margin: 10px 0; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Registration Test Result</h1>");
            
            try {
                // Test the same logic as RegisterController
                out.println("<h3>Step 1: Creating Customer Object</h3>");
                Customer newCustomer = new Customer(fullName, email, password, phone);
                newCustomer.setIsActive(true);
                newCustomer.setLoyaltyPoints(0);
                out.println("<div class='success'>✅ Customer object created successfully</div>");
                out.println("<div class='info'>Full Name: " + newCustomer.getFullName() + "</div>");
                out.println("<div class='info'>Email: " + newCustomer.getEmail() + "</div>");
                out.println("<div class='info'>Phone: " + newCustomer.getPhoneNumber() + "</div>");
                out.println("<div class='info'>Password (plain): " + password + "</div>");
                out.println("<div class='info'>Role ID: " + newCustomer.getRoleId() + "</div>");
                out.println("<div class='info'>Is Active: " + newCustomer.getIsActive() + "</div>");
                out.println("<div class='info'>Loyalty Points: " + newCustomer.getLoyaltyPoints() + "</div>");
                
                out.println("<h3>Step 2: Saving to Database</h3>");
                Customer savedCustomer = customerDAO.save(newCustomer);
                out.println("<div class='success'>✅ Customer saved to database successfully</div>");
                out.println("<div class='info'>Generated Customer ID: " + savedCustomer.getCustomerId() + "</div>");
                
                out.println("<h3>Step 3: Testing Login</h3>");
                Customer loginTest = customerDAO.getCustomerByEmailAndPassword(email, password);
                if (loginTest != null) {
                    out.println("<div class='success'>✅ LOGIN TEST SUCCESSFUL!</div>");
                    out.println("<div class='success'>The registration process is now working correctly.</div>");
                    out.println("<div class='info'>You can login with:</div>");
                    out.println("<div class='info'>Email: " + email + "</div>");
                    out.println("<div class='info'>Password: " + password + "</div>");
                } else {
                    out.println("<div class='error'>❌ Login test failed - there might still be an issue</div>");
                }
                
                out.println("<h3>Step 4: Password Hash Verification</h3>");
                // Get the stored hash and verify it
                try {
                    java.sql.Connection conn = db.DBContext.getConnection();
                    java.sql.PreparedStatement ps = conn.prepareStatement("SELECT hash_password FROM customers WHERE email = ?");
                    ps.setString(1, email);
                    java.sql.ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        String storedHash = rs.getString("hash_password");
                        boolean matches = BCrypt.checkpw(password, storedHash);
                        out.println("<div class='" + (matches ? "success" : "error") + "'>" + 
                                   (matches ? "✅" : "❌") + " Password hash verification: " + matches + "</div>");
                        out.println("<div class='info'>Stored hash: " + storedHash.substring(0, 30) + "...</div>");
                    }
                } catch (Exception e) {
                    out.println("<div class='error'>Error verifying hash: " + e.getMessage() + "</div>");
                }
                
            } catch (Exception e) {
                out.println("<div class='error'>❌ Registration failed: " + e.getMessage() + "</div>");
                e.printStackTrace();
            }
            
            out.println("<hr>");
            out.println("<h3>Next Steps:</h3>");
            out.println("<a href='" + request.getContextPath() + "/test-registration'>← Test Again</a><br>");
            out.println("<a href='" + request.getContextPath() + "/login'>Try Login Page</a><br>");
            out.println("<a href='" + request.getContextPath() + "/register'>Try Registration Page</a>");
            
            out.println("</body>");
            out.println("</html>");
        }
    }
} 