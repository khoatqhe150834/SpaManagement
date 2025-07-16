package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Customer;
import model.User;

/**
 * Controller for handling booking checkout functionality
 * Provides secure access to the checkout page for authenticated customers
 * 
 * @author G1_SpaManagement Team
 */
@WebServlet(name = "BookingCheckoutController", urlPatterns = {"/booking-checkout"})
public class BookingCheckoutController extends HttpServlet {

    /**
     * Handles GET requests to display the booking checkout page
     * 
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get session and check authentication
        HttpSession session = request.getSession(false);
        if (session == null) {
            // This should not happen due to AuthenticationFilter, but handle gracefully
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get user information from session
        User user = (User) session.getAttribute("user");
        Customer customer = (Customer) session.getAttribute("customer");
        
        // Set user context for the JSP
        if (user != null) {
            request.setAttribute("currentUser", user);
            request.setAttribute("userType", "user");
            request.setAttribute("isAuthenticated", true);
        } else if (customer != null) {
            request.setAttribute("currentCustomer", customer);
            request.setAttribute("userType", "customer");
            request.setAttribute("isAuthenticated", true);
        } else {
            // No valid user found, redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Set additional attributes for the checkout page
        request.setAttribute("pageTitle", "Thanh toán - BeautyZone Spa");
        request.setAttribute("showBookingFeatures", true);
        
        // Forward to the checkout JSP page
        request.getRequestDispatcher("/WEB-INF/view/booking-checkout.jsp")
                .forward(request, response);
    }

    /**
     * Handles POST requests for checkout form submissions
     * Currently redirects back to GET for display
     * 
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // For now, redirect back to the checkout page
        // In the future, this could handle payment processing
        response.sendRedirect(request.getContextPath() + "/booking-checkout");
    }

    /**
     * Returns a short description of the servlet
     * 
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Booking Checkout Controller - Handles secure checkout functionality for spa services";
    }
}
