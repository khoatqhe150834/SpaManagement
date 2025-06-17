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
import dao.ServiceDAO;
import dao.ServiceTypeDAO;
import model.Service;
import model.ServiceType;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.stream.Collectors;

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
        "/products/shop",
        "/api/services/search"
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
                // Load service types and services for individual booking
                loadServiceData(request);
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

            case "/api/services/search":
                handleServiceSearch(request, response);
                return;

            default:
                // Default to booking selection
                jspPath = "/WEB-INF/view/customer/appointments/booking-selection.jsp";
                break;
        }

        request.getRequestDispatcher(jspPath).forward(request, response);
    }

    /**
     * Load service types and services data for booking pages
     */
    private void loadServiceData(HttpServletRequest request) {
        try {
            ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO();
            ServiceDAO serviceDAO = new ServiceDAO();

            // Get all active service types
            List<ServiceType> serviceTypes = serviceTypeDAO.getActiveServiceTypes();

            // Get top 3 hot service types
            List<ServiceType> hotServiceTypes = serviceTypeDAO.getHotServiceTypes();

            // Get all active services grouped by service type
            Map<Integer, List<Service>> servicesByType = new HashMap<>();

            for (ServiceType serviceType : serviceTypes) {
                List<Service> services = serviceDAO.findByServiceTypeId(serviceType.getServiceTypeId())
                        .stream()
                        .filter(s -> s.isIsActive() && s.isBookableOnline())
                        .collect(Collectors.toList());
                servicesByType.put(serviceType.getServiceTypeId(), services);
            }

            // Set attributes for JSP
            request.setAttribute("serviceTypes", serviceTypes);
            request.setAttribute("hotServiceTypes", hotServiceTypes);
            request.setAttribute("servicesByType", servicesByType);

            // Create featured services list (first from each category)
            List<Service> featuredServices = new ArrayList<>();
            for (ServiceType serviceType : serviceTypes) {
                List<Service> services = servicesByType.get(serviceType.getServiceTypeId());
                if (!services.isEmpty()) {
                    featuredServices.add(services.get(0)); // Add first service from each category
                }
            }
            request.setAttribute("featuredServices", featuredServices);

        } catch (Exception e) {
            // Log error and set empty lists to prevent JSP errors
            e.printStackTrace();
            request.setAttribute("serviceTypes", new ArrayList<>());
            request.setAttribute("hotServiceTypes", new ArrayList<>());
            request.setAttribute("servicesByType", new HashMap<>());
            request.setAttribute("featuredServices", new ArrayList<>());
        }
    }

    /**
     * Handle AJAX service search requests
     */
    private void handleServiceSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        String query = request.getParameter("q");
        String categoryId = request.getParameter("category");

        try {
            ServiceDAO serviceDAO = new ServiceDAO();
            ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO();

            List<Service> services = new ArrayList<>();

            if (query != null && !query.trim().isEmpty()) {
                // Search services by name or description
                services = serviceDAO.findAll().stream()
                        .filter(s -> s.isIsActive() && s.isBookableOnline())
                        .filter(s -> s.getName().toLowerCase().contains(query.toLowerCase()) ||
                                (s.getDescription() != null
                                        && s.getDescription().toLowerCase().contains(query.toLowerCase())))
                        .collect(Collectors.toList());
            } else if (categoryId != null && !categoryId.isEmpty()) {
                if (categoryId.startsWith("type-")) {
                    int typeId = Integer.parseInt(categoryId.substring(5));
                    services = serviceDAO.findByServiceTypeId(typeId).stream()
                            .filter(s -> s.isIsActive() && s.isBookableOnline())
                            .collect(Collectors.toList());
                }
            }

            // Build JSON response
            StringBuilder json = new StringBuilder();
            json.append("{\"services\":[");

            for (int i = 0; i < services.size(); i++) {
                Service service = services.get(i);
                if (i > 0)
                    json.append(",");
                json.append("{")
                        .append("\"id\":").append(service.getServiceId()).append(",")
                        .append("\"name\":\"").append(escapeJson(service.getName())).append("\",")
                        .append("\"description\":\"").append(escapeJson(service.getDescription())).append("\",")
                        .append("\"price\":").append(service.getPrice()).append(",")
                        .append("\"duration\":").append(service.getDurationMinutes()).append(",")
                        .append("\"typeId\":").append(service.getServiceTypeId().getServiceTypeId()).append(",")
                        .append("\"typeName\":\"").append(escapeJson(service.getServiceTypeId().getName())).append("\"")
                        .append("}");
            }

            json.append("]}");

            try (PrintWriter out = response.getWriter()) {
                out.print(json.toString());
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"error\":\"Internal server error\"}");
            }
        }
    }

    /**
     * Escape JSON strings
     */
    private String escapeJson(String str) {
        if (str == null)
            return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
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
