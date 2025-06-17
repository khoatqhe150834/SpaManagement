/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author quang
 */
@WebServlet(name = "BookingController", urlPatterns = {
        "/book",
        "/booking/process",
        "/appointments/booking-selection",
        "/appointments/booking-individual",
        "/appointments/booking-group",
        "/membership/packages",
        "/giftcard/purchase",
        "/products/shop"
})
public class BookingController extends HttpServlet {

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
            out.println("<title>Servlet BookingController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BookingController at " + request.getContextPath() + "</h1>");
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

        String path = request.getServletPath();
        String jspPath = "";

        switch (path) {
            case "/book":
            case "/appointments/booking-selection":
                jspPath = "/WEB-INF/view/customer/appointments/booking-selection.jsp";
                break;

            case "/appointments/booking-individual":
                jspPath = "/WEB-INF/view/customer/appointments/booking-individual.jsp";
                break;

            case "/appointments/booking-group":
                jspPath = "/WEB-INF/view/customer/appointments/booking-group.jsp";
                break;

            case "/membership/packages":
                jspPath = "/WEB-INF/view/customer/membership/packages.jsp";
                break;

            case "/giftcard/purchase":
                jspPath = "/WEB-INF/view/customer/giftcard/purchase.jsp";
                break;

            case "/products/shop":
                jspPath = "/WEB-INF/view/customer/products/shop.jsp";
                break;

            default:
                // Default to booking selection
                jspPath = "/WEB-INF/view/customer/appointments/booking-selection.jsp";
                break;
        }

        request.getRequestDispatcher(jspPath).forward(request, response);
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

        String path = request.getServletPath();

        if ("/booking/process".equals(path)) {
            // Handle booking selection form submission
            String bookingType = request.getParameter("bookingType");
            String redirectUrl = "";

            if (bookingType != null) {
                switch (bookingType) {
                    case "individual":
                        redirectUrl = request.getContextPath() + "/appointments/booking-individual";
                        break;
                    case "group":
                        redirectUrl = request.getContextPath() + "/appointments/booking-group";
                        break;
                    case "membership":
                        redirectUrl = request.getContextPath() + "/membership/packages";
                        break;
                    case "giftcard":
                        redirectUrl = request.getContextPath() + "/giftcard/purchase";
                        break;
                    case "products":
                        redirectUrl = request.getContextPath() + "/products/shop";
                        break;
                    default:
                        redirectUrl = request.getContextPath() + "/appointments/booking-selection";
                        break;
                }

                response.sendRedirect(redirectUrl);
            } else {
                // No booking type selected, redirect back to selection
                response.sendRedirect(request.getContextPath() + "/appointments/booking-selection");
            }
        } else {
            // Handle other POST requests
            processRequest(request, response);
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

}
