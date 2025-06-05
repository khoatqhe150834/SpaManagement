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
import model.Customer;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet(name = "DebugLoginController", urlPatterns = {"/debug-login"})
public class DebugLoginController extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    private CustomerDAO customerDAO = new CustomerDAO();
    private AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Debug Login</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; padding: 20px; }");
            out.println(".success { color: green; }");
            out.println(".error { color: red; }");
            out.println(".info { color: blue; }");
            out.println("pre { background-color: #f5f5f5; padding: 10px; border-radius: 5px; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Debug Login Controller</h1>");
            
            // Test form
            out.println("<form method='get'>");
            out.println("<h3>Test Login:</h3>");
            out.println("Email: <input type='email' name='email' value='" + (email != null ? email : "") + "' required><br><br>");
            out.println("Password: <input type='password' name='password' value='" + (password != null ? password : "") + "' required><br><br>");
            out.println("<input type='submit' value='Debug Login'>");
            out.println("</form>");
            
            out.println("<hr>");
            
            // Test 1: Database connectivity
            out.println("<h3>1. Database Connectivity Test</h3>");
            try {
                Connection conn = DBContext.getConnection();
                if (conn != null && !conn.isClosed()) {
                    out.println("<span class='success'>✓ Database connection successful</span><br>");
                } else {
                    out.println("<span class='error'>✗ Database connection failed</span><br>");
                }
            } catch (Exception e) {
                out.println("<span class='error'>✗ Database connection error: " + e.getMessage() + "</span><br>");
            }
            
            // Test 2: Table structure check
            out.println("<h3>2. Database Table Check</h3>");
            try (Connection conn = DBContext.getConnection()) {
                // Check customers table
                PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM customers");
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    int customerCount = rs.getInt(1);
                    out.println("<span class='success'>✓ Customers table exists with " + customerCount + " records</span><br>");
                }
                
                // Check users table
                ps = conn.prepareStatement("SELECT COUNT(*) FROM users");
                rs = ps.executeQuery();
                if (rs.next()) {
                    int userCount = rs.getInt(1);
                    out.println("<span class='success'>✓ Users table exists with " + userCount + " records</span><br>");
                }
            } catch (Exception e) {
                out.println("<span class='error'>✗ Table check error: " + e.getMessage() + "</span><br>");
            }
            
            if (email != null && password != null) {
                out.println("<h3>3. Login Debug for: " + email + "</h3>");
                
                // Test 3: Check if email exists in system
                boolean emailExistsInSystem = accountDAO.isEmailTakenInSystem(email);
                out.println("<span class='" + (emailExistsInSystem ? "success" : "error") + "'>" + 
                           (emailExistsInSystem ? "✓" : "✗") + " Email exists in system: " + emailExistsInSystem + "</span><br>");
                
                // Test 4: Check customer table specifically
                boolean customerEmailExists = accountDAO.isCustomerEmailExists(email);
                out.println("<span class='" + (customerEmailExists ? "success" : "info") + "'>" + 
                           (customerEmailExists ? "✓" : "ℹ") + " Email exists in customers table: " + customerEmailExists + "</span><br>");
                
                // Test 5: Check user table specifically  
                boolean userEmailExists = accountDAO.isUserEmailExists(email);
                out.println("<span class='" + (userEmailExists ? "success" : "info") + "'>" + 
                           (userEmailExists ? "✓" : "ℹ") + " Email exists in users table: " + userEmailExists + "</span><br>");
                
                // Test 6: Try to retrieve customer by email
                if (customerEmailExists) {
                    Optional<Customer> customerOpt = customerDAO.findCustomerByEmail(email);
                    if (customerOpt.isPresent()) {
                        Customer customer = customerOpt.get();
                        out.println("<span class='success'>✓ Customer found by email</span><br>");
                        out.println("<span class='info'>Customer ID: " + customer.getCustomerId() + "</span><br>");
                        out.println("<span class='info'>Full Name: " + customer.getFullName() + "</span><br>");
                        out.println("<span class='info'>Is Active: " + customer.getIsActive() + "</span><br>");
                        
                        // Test password
                        try (Connection conn = DBContext.getConnection()) {
                            PreparedStatement ps = conn.prepareStatement("SELECT hash_password FROM customers WHERE email = ?");
                            ps.setString(1, email);
                            ResultSet rs = ps.executeQuery();
                            if (rs.next()) {
                                String storedHash = rs.getString("hash_password");
                                out.println("<span class='info'>Stored hash (first 20 chars): " + storedHash.substring(0, Math.min(20, storedHash.length())) + "...</span><br>");
                                
                                boolean passwordMatch = BCrypt.checkpw(password, storedHash);
                                out.println("<span class='" + (passwordMatch ? "success" : "error") + "'>" + 
                                           (passwordMatch ? "✓" : "✗") + " Password match: " + passwordMatch + "</span><br>");
                            }
                        }
                        
                        // Test DAO method
                        Customer loginCustomer = customerDAO.getCustomerByEmailAndPassword(email, password);
                        out.println("<span class='" + (loginCustomer != null ? "success" : "error") + "'>" + 
                                   (loginCustomer != null ? "✓" : "✗") + " CustomerDAO login method: " + (loginCustomer != null ? "SUCCESS" : "FAILED") + "</span><br>");
                    }
                }
                
                // Test 7: Try to retrieve user by email
                if (userEmailExists) {
                    Optional<User> userOpt = userDAO.findUserByEmail(email);
                    if (userOpt.isPresent()) {
                        User user = userOpt.get();
                        out.println("<span class='success'>✓ User found by email</span><br>");
                        out.println("<span class='info'>User ID: " + user.getUserId() + "</span><br>");
                        out.println("<span class='info'>Full Name: " + user.getFullName() + "</span><br>");
                        out.println("<span class='info'>Is Active: " + user.getIsActive() + "</span><br>");
                        
                        // Test password
                        try (Connection conn = DBContext.getConnection()) {
                            PreparedStatement ps = conn.prepareStatement("SELECT hash_password FROM users WHERE email = ?");
                            ps.setString(1, email);
                            ResultSet rs = ps.executeQuery();
                            if (rs.next()) {
                                String storedHash = rs.getString("hash_password");
                                out.println("<span class='info'>Stored hash (first 20 chars): " + storedHash.substring(0, Math.min(20, storedHash.length())) + "...</span><br>");
                                
                                boolean passwordMatch = BCrypt.checkpw(password, storedHash);
                                out.println("<span class='" + (passwordMatch ? "success" : "error") + "'>" + 
                                           (passwordMatch ? "✓" : "✗") + " Password match: " + passwordMatch + "</span><br>");
                            }
                        }
                        
                        // Test DAO method
                        User loginUser = userDAO.getUserByEmailAndPassword(email, password);
                        out.println("<span class='" + (loginUser != null ? "success" : "error") + "'>" + 
                                   (loginUser != null ? "✓" : "✗") + " UserDAO login method: " + (loginUser != null ? "SUCCESS" : "FAILED") + "</span><br>");
                    }
                }
                
                // Test 8: Show sample password hash for reference
                out.println("<h3>4. Password Hash Test</h3>");
                String testPassword = "123456";
                String testHash = BCrypt.hashpw(testPassword, BCrypt.gensalt());
                out.println("<span class='info'>Test password '" + testPassword + "' hashed to: " + testHash.substring(0, 20) + "...</span><br>");
                boolean testMatch = BCrypt.checkpw(testPassword, testHash);
                out.println("<span class='success'>Test hash verification: " + testMatch + "</span><br>");
            }
            
            out.println("</body>");
            out.println("</html>");
        } catch (Exception e) {
            throw new ServletException("Debug error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 