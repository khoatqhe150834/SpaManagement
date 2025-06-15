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

@WebServlet(name = "ServiceController", urlPatterns = { "/service" })
public class ServiceController extends HttpServlet {

    private final String SERVICE_MANAGER_URL = "WEB-INF/view/admin_pages/Service/ServiceManager.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String service = request.getParameter("service");
        if (service == null || service.isEmpty()) {
            service = "list-all";
        }

        ServiceDAO serviceDAO = new ServiceDAO();
        ServiceTypeDAO typeDAO = new ServiceTypeDAO();

        int limit = 5;
        if (request.getParameter("limit") != null) {
            try {
                limit = Integer.parseInt(request.getParameter("limit"));
            } catch (Exception ignored) {}
        }
        int page = 1;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (Exception ignored) {}
        }
        int offset = (page - 1) * limit;

        switch (service) {
            case "list-all": {
                List<Service> services = serviceDAO.findPaginated(offset, limit);
                int totalRecords = serviceDAO.countAll();
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
                request.getRequestDispatcher("WEB-INF/view/admin_pages/Service/AddService.jsp").forward(request, response);
                return;
            }
            case "pre-update": {
                int id = Integer.parseInt(request.getParameter("id"));
                Service s = serviceDAO.findById(id).orElse(null);
                List<ServiceType> types = typeDAO.findAll();
                request.setAttribute("serviceTypes", types);
                request.setAttribute("service", s);
                request.getRequestDispatcher("WEB-INF/view/admin_pages/Service/UpdateService.jsp").forward(request, response);
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
                response.sendRedirect("service");
                return;
            }
            case "searchByKeyword":
            case "searchByKeywordAndStatus": {
                String keyword = request.getParameter("keyword");
                String status = request.getParameter("status");

                List<Service> services = serviceDAO.searchByKeywordAndStatus(keyword, status, offset, limit);
                int totalRecords = serviceDAO.countSearchResult(keyword, status);
                int totalPages = (int) Math.ceil((double) totalRecords / limit);

                request.setAttribute("services", services);
                request.setAttribute("keyword", keyword);
                request.setAttribute("status", status);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("totalEntries", totalRecords);
                request.setAttribute("limit", limit);
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
