package controller;

import dao.ServiceDAO;
import dao.ServiceTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Service;
import model.ServiceType;
import model.ServiceImage;
import dao.ServiceImageDAO;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet(name = "ServiceController", urlPatterns = { "/service" })
@MultipartConfig(
    fileSizeThreshold = 0,
    maxFileSize = 2097152, // 2MB
    maxRequestSize = 2097152
)
public class ServiceController extends HttpServlet {

    private final String SERVICE_MANAGER_URL = "WEB-INF/view/admin_pages/Service/ServiceManager.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ServiceImageDAO serviceImageDAO = new ServiceImageDAO();

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

        String serviceTypeIdParam = request.getParameter("serviceTypeId");
        Integer serviceTypeId = null;
        if (serviceTypeIdParam != null && !serviceTypeIdParam.isEmpty()) {
            serviceTypeId = Integer.parseInt(serviceTypeIdParam);
        }

        List<ServiceType> serviceTypes = typeDAO.findAll();
        request.setAttribute("serviceTypes", serviceTypes);

        switch (service) {
            case "list-all": {
                List<Service> services = serviceDAO.findPaginated(offset, limit);
                int totalRecords = serviceDAO.countAll();
                int totalPages = (int) Math.ceil((double) totalRecords / limit);

                Map<Integer, String> serviceThumbnails = new HashMap<>();
                for (Service s : services) {
                    List<ServiceImage> images = serviceImageDAO.findByServiceId(s.getServiceId());
                    if (!images.isEmpty()) {
                        serviceThumbnails.put(s.getServiceId(), images.get(0).getImageUrl());
                    } else {
                        serviceThumbnails.put(s.getServiceId(), "/assets/images/no-image.png");
                    }
                }
                request.setAttribute("serviceThumbnails", serviceThumbnails);

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
                List<ServiceImage> serviceImages = serviceImageDAO.findByServiceId(id);
                request.setAttribute("serviceImages", serviceImages);
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
            case "search": {
                String keyword = request.getParameter("keyword");
                String status = request.getParameter("status");

                List<Service> services = serviceDAO.searchServices(keyword, status, serviceTypeId, offset, limit);
                int totalRecords = serviceDAO.countSearchResult(keyword, status, serviceTypeId);
                int totalPages = (int) Math.ceil((double) totalRecords / limit);

                request.setAttribute("services", services);
                request.setAttribute("keyword", keyword);
                request.setAttribute("status", status);
                request.setAttribute("serviceTypeId", serviceTypeId);
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

        String serviceTypeIdStr = request.getParameter("service_type_id");
        int serviceTypeId = Integer.parseInt(serviceTypeIdStr);
        ServiceType serviceType = typeDAO.findById(serviceTypeId).orElse(null);

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int duration = Integer.parseInt(request.getParameter("duration_minutes"));
        int buffer = Integer.parseInt(request.getParameter("buffer_time_after_minutes"));
        boolean isActive = request.getParameter("is_active") != null;
        boolean bookable = request.getParameter("bookable_online") != null;
        boolean requiresConsultation = request.getParameter("requires_consultation") != null;

        Service s = new Service();
        s.setServiceTypeId(serviceType);
        s.setName(name);
        s.setDescription(description);
        s.setPrice(price);
        s.setDurationMinutes(duration);
        s.setBufferTimeAfterMinutes(buffer);
        s.setIsActive(isActive);
        s.setBookableOnline(bookable);
        s.setRequiresConsultation(requiresConsultation);
        s.setAverageRating(BigDecimal.ZERO);

        // Xử lý upload nhiều ảnh
        List<String> imageUrls = new ArrayList<>();
        for (Part part : request.getParts()) {
            if (part.getName().equals("images") && part.getSize() > 0) {
                String fileName = getSubmittedFileName(part);
                String uploadPath = getServletContext().getRealPath("/assets/uploads/services/");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                part.write(uploadPath + File.separator + fileName);
                String imageUrl = "/assets/uploads/services/" + fileName;
                imageUrls.add(imageUrl);
            }
        }

        if (service.equals("insert")) {
            serviceDAO.save(s);
            int serviceId = s.getServiceId();
            ServiceImageDAO serviceImageDAO = new ServiceImageDAO();
            for (String url : imageUrls) {
                serviceImageDAO.save(new ServiceImage(serviceId, url));
            }
        } else if (service.equals("update")) {
            int id = Integer.parseInt(request.getParameter("id"));
            s.setServiceId(id);
            serviceDAO.update(s);

            ServiceImageDAO serviceImageDAO = new ServiceImageDAO();
            // Xóa ảnh cũ trước khi thêm mới
            serviceImageDAO.deleteByServiceId(id);
            for (String url : imageUrls) {
                serviceImageDAO.save(new ServiceImage(id, url));
            }
        }

        response.sendRedirect("service");
    }

    private String getSubmittedFileName(Part part) {
        if (part == null) return "";
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) return "";
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    @Override
    public String getServletInfo() {
        return "Controller for managing Services";
    }
}
