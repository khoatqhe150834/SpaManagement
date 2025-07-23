package controller;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

import dao.ServiceDAO;
import dao.ServiceImageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Service;
import model.ServiceImage;

@WebServlet(name = "ServiceDetailsController", urlPatterns = {"/service-details"})
public class ServiceDetailsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String serviceIdParam = request.getParameter("id");
        
        if (serviceIdParam == null || serviceIdParam.trim().isEmpty()) {
            // Redirect to services page if no ID provided
            response.sendRedirect(request.getContextPath() + "/services");
            return;
        }
        
        try {
            int serviceId = Integer.parseInt(serviceIdParam.trim());
            
            ServiceDAO serviceDAO = new ServiceDAO();
            Optional<Service> serviceOptional = serviceDAO.findById(serviceId);
            
            if (serviceOptional.isPresent()) {
                Service service = serviceOptional.get();
                
                // Get service images
                ServiceImageDAO serviceImageDAO = new ServiceImageDAO();
                List<ServiceImage> serviceImages = serviceImageDAO.findByServiceId(serviceId);

                // Get related services (same service type, excluding current service)
                List<Service> relatedServices = serviceDAO.findByServiceTypeId(service.getServiceTypeId().getServiceTypeId());
                relatedServices.removeIf(s -> s.getServiceId() == serviceId); // Remove current service

                // Limit to 4 related services for display
                if (relatedServices.size() > 4) {
                    relatedServices = relatedServices.subList(0, 4);
                }

                // Set attributes for JSP
                request.setAttribute("service", service);
                request.setAttribute("serviceImages", serviceImages);
                request.setAttribute("relatedServices", relatedServices);
                
                // Forward to service details page
                request.getRequestDispatcher("/WEB-INF/view/service-details.jsp").forward(request, response);
            } else {
                // Service not found, redirect to services page
                response.sendRedirect(request.getContextPath() + "/services?error=service-not-found");
            }
            
        } catch (NumberFormatException e) {
            // Invalid service ID format, redirect to services page
            response.sendRedirect(request.getContextPath() + "/services?error=invalid-id");
        } catch (Exception e) {
            // Log the error and redirect
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/services?error=server-error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST requests to GET
        doGet(request, response);
    }
}
