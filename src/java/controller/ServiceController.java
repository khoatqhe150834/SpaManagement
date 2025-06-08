package controller;

import dao.ServiceDAO;
import dao.ServiceTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Service;
import model.ServiceType;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "ServiceController", urlPatterns = {"/service"})
public class ServiceController extends HttpServlet {

    private final String SERVICE_MANAGER_URL = "WEB-INF/view/admin_pages/ServiceManager.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String service = request.getParameter("service");
        if (service == null) {
            service = "list-all";
        }

        ServiceDAO serviceDAO = new ServiceDAO();
        ServiceTypeDAO typeDAO = new ServiceTypeDAO();

        switch (service) {
            case "list-all": {
                int page = 1, limit = 5;
                try {
                    page = Integer.parseInt(request.getParameter("page"));
                } catch (Exception ignored) {
                }
                int offset = (page - 1) * limit;

                List<Service> services = serviceDAO.findAll(); // Consider adding pagination support
                int totalRecords = services.size();
                int totalPages = (int) Math.ceil((double) totalRecords / limit);

                request.setAttribute("services", services);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("totalEntries", totalRecords);
                request.setAttribute("limit", limit);
                break;
            }
            case "pre-insert": {
                List<ServiceType> types = typeDAO.findAll();
                request.setAttribute("serviceTypes", types);
                request.getRequestDispatcher("WEB-INF/view/admin_pages/AddService.jsp").forward(request, response);
                return;
            }
            case "pre-update": {
                int id = Integer.parseInt(request.getParameter("id"));
                Service s = serviceDAO.findById(id).orElse(null);
                List<ServiceType> types = typeDAO.findAll();
                request.setAttribute("serviceTypes", types);
                request.setAttribute("service", s);
                request.getRequestDispatcher("WEB-INF/view/admin_pages/UpdateService.jsp").forward(request, response);
                return;
            }
            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                serviceDAO.deleteById(id);
                response.sendRedirect("service");
                return;
            }
            case "deactivate": {
                int id = Integer.parseInt(request.getParameter("id"));
                serviceDAO.deactivateById(id);
                request.setAttribute("toastType", "success");
                request.setAttribute("toastMessage", "Deactivated Service (ID = " + id + ") successfully.");
                break;
            }
            case "searchByKeyword": {
                String keyword = request.getParameter("keyword");
                List<Service> services = serviceDAO.findByKeyword(keyword);

                if (services == null || services.isEmpty()) {
                    request.setAttribute("notFoundMessage", "No services matched your keyword.");
                    services = serviceDAO.findAll();
                }
                request.setAttribute("services", services);
                request.setAttribute("keyword", keyword);
                break;
            }
            case "viewByServiceType": {
                int id = Integer.parseInt(request.getParameter("id"));
                List<Service> services = serviceDAO.findByServiceTypeId(id);
                request.setAttribute("services", services);
                break;
            }
        }

        request.getRequestDispatcher(SERVICE_MANAGER_URL).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String service = request.getParameter("service");
        ServiceDAO serviceDAO = new ServiceDAO();
        ServiceTypeDAO typeDAO = new ServiceTypeDAO();

        int serviceTypeId = Integer.parseInt(request.getParameter("service_type_id"));
        ServiceType serviceType = typeDAO.findById(serviceTypeId).orElse(null);

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int duration = Integer.parseInt(request.getParameter("duration_minutes"));
        int buffer = Integer.parseInt(request.getParameter("buffer_time_after_minutes"));
        String image = request.getParameter("image_url");
        boolean isActive = request.getParameter("is_active") != null;
        BigDecimal rating = new BigDecimal(request.getParameter("average_rating"));
        boolean bookable = request.getParameter("bookable_online") != null;
        boolean requiresConsultation = request.getParameter("requires_consultation") != null;

        Service s = new Service();
        s.setServiceTypeId(serviceType);
        s.setName(name);
        s.setDescription(description);
        s.setPrice(price);
        s.setDurationMinutes(duration);
        s.setBufferTimeAfterMinutes(buffer);
        s.setImageUrl(image);
        s.setIsActive(isActive);
        s.setAverageRating(rating);
        s.setBookableOnline(bookable);
        s.setRequiresConsultation(requiresConsultation);

        if (service.equals("insert")) {
            serviceDAO.save(s);
        } else if (service.equals("update")) {
            int id = Integer.parseInt(request.getParameter("id"));
            s.setServiceId(id);
            serviceDAO.update(s);
        }

        response.sendRedirect("service");
    }

    @Override
    public String getServletInfo() {
        return "Controller for managing Services";
    }
}
