package controller;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "TestCustomerController", urlPatterns = {"/test-customer"})
public class TestCustomerController extends HttpServlet {
    
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Test database connection and fetch customers
            List<Customer> customers = customerDAO.findAll(1, 10);
            int totalCustomers = customerDAO.getTotalCustomers();
            
            // Set attributes for JSP
            request.setAttribute("msg", "Customer List Test - Found " + totalCustomers + " customers");
            request.setAttribute("customers", customers);
            request.setAttribute("totalCustomers", totalCustomers);
            
            // Forward to test.jsp
            request.getRequestDispatcher("/test.jsp").forward(request, response);
            
        } catch (Exception e) {
            // If there's an error, show it
            request.setAttribute("msg", "Error: " + e.getMessage());
            request.setAttribute("error", e.getStackTrace());
            request.getRequestDispatcher("/test.jsp").forward(request, response);
        }
    }
}