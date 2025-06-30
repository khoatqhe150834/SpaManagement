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
import java.util.Optional;

@WebServlet(name = "ServiceController", urlPatterns = {"/manager/service"})
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
        String limitParam = request.getParameter("limit");
        if (limitParam != null && !limitParam.isEmpty()) {
            try {
                limit = Integer.parseInt(limitParam);
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
                // Lấy tham số page, limit, keyword, status, serviceTypeId nếu có
                String pageParam = request.getParameter("page");
                String keyword = request.getParameter("keyword");
                String status = request.getParameter("status");
                // Biến serviceTypeIdParam đã có ở đầu hàm
                request.setAttribute("page", pageParam);
                request.setAttribute("keyword", keyword);
                request.setAttribute("status", status);
                request.setAttribute("serviceTypeId", serviceTypeIdParam);
                request.setAttribute("limit", limit);
                request.getRequestDispatcher("WEB-INF/view/admin_pages/Service/AddService.jsp").forward(request, response);
                return;
            }
            case "pre-update": {
                int id = Integer.parseInt(request.getParameter("id").trim());
                Service s = serviceDAO.findById(id).orElse(null);
                List<ServiceType> types = typeDAO.findAll();
                request.setAttribute("serviceTypes", types);
                request.setAttribute("service", s);
                List<ServiceImage> serviceImages = serviceImageDAO.findByServiceId(id);
                request.setAttribute("serviceImages", serviceImages);

                // Lấy tham số page, limit, searchParams nếu có
                String pageParam = request.getParameter("page");
                String keyword = request.getParameter("keyword");
                String status = request.getParameter("status");

                request.setAttribute("page", pageParam);
                request.setAttribute("keyword", keyword);
                request.setAttribute("status", status);
                request.setAttribute("serviceTypeId", serviceTypeIdParam);
                request.setAttribute("limit", limit);

                request.getRequestDispatcher("WEB-INF/view/admin_pages/Service/UpdateService.jsp").forward(request, response);
                return;
            }
            case "delete": {
                int id = Integer.parseInt(request.getParameter("id").trim());
                serviceDAO.deleteById(id);
                response.sendRedirect("service");
                return;
            }
            case "deactivate": {
                int id = Integer.parseInt(request.getParameter("id").trim());
                serviceDAO.deactivateById(id);
                // Lấy tham số truy vấn để redirect giữ nguyên trang
                String pageParam = request.getParameter("page");
                String keyword = request.getParameter("keyword");
                String status = request.getParameter("status");
                String serviceTypeIdStr = request.getParameter("serviceTypeId");
                StringBuilder redirectUrl = new StringBuilder("service?service=list-all");
                if (pageParam != null) redirectUrl.append("&page=").append(pageParam);
                if (limitParam != null) redirectUrl.append("&limit=").append(limitParam);
                if (keyword != null && !keyword.isEmpty()) redirectUrl.append("&keyword=").append(keyword);
                if (status != null && !status.isEmpty()) redirectUrl.append("&status=").append(status);
                if (serviceTypeIdStr != null && !serviceTypeIdStr.isEmpty()) redirectUrl.append("&serviceTypeId=").append(serviceTypeIdStr);
                response.sendRedirect(redirectUrl.toString());
                return;
            }
            case "activate": {
                int id = Integer.parseInt(request.getParameter("id").trim());
                serviceDAO.activateById(id);
                // Lấy tham số truy vấn để redirect giữ nguyên trang
                String pageParam = request.getParameter("page");
                String keyword = request.getParameter("keyword");
                String status = request.getParameter("status");
                String serviceTypeIdStr = request.getParameter("serviceTypeId");
                StringBuilder redirectUrl = new StringBuilder("service?service=list-all");
                if (pageParam != null) redirectUrl.append("&page=").append(pageParam);
                if (limitParam != null) redirectUrl.append("&limit=").append(limitParam);
                if (keyword != null && !keyword.isEmpty()) redirectUrl.append("&keyword=").append(keyword);
                if (status != null && !status.isEmpty()) redirectUrl.append("&status=").append(status);
                if (serviceTypeIdStr != null && !serviceTypeIdStr.isEmpty()) redirectUrl.append("&serviceTypeId=").append(serviceTypeIdStr);
                response.sendRedirect(redirectUrl.toString());
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
            case "view-detail": {
                try {
                    int id = Integer.parseInt(request.getParameter("id").trim());
                    Optional<Service> serviceOptional = serviceDAO.findById(id);

                    if (serviceOptional.isPresent()) {
                        Service serviceDetail = serviceOptional.get();
                        List<ServiceImage> serviceImages = serviceImageDAO.findByServiceId(id);

                        request.setAttribute("page", request.getParameter("page"));
                        request.setAttribute("limit", request.getParameter("limit"));
                        request.setAttribute("keyword", request.getParameter("keyword"));
                        request.setAttribute("status", request.getParameter("status"));
                        request.setAttribute("serviceTypeId", request.getParameter("serviceTypeId"));

                        request.setAttribute("service", serviceDetail);
                        request.setAttribute("serviceImages", serviceImages);
                        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Service/ViewDetailService.jsp").forward(request, response);
                    } else {
                        response.sendRedirect("service?service=list-all&toastType=error&toastMessage=Service+not+found");
                    }
                } catch (NumberFormatException e) {
                    response.sendRedirect("service?service=list-all&toastType=error&toastMessage=Invalid+service+ID");
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("service?service=list-all&toastType=error&toastMessage=An+unexpected+error+occurred");
                }
                return;
            }
            case "check-duplicate-name": {
                String name = request.getParameter("name");
                String idParam = request.getParameter("id");
                boolean isDuplicate;
                if (idParam != null && !idParam.isEmpty()) {
                    int id = Integer.parseInt(idParam);
                    isDuplicate = serviceDAO.existsByNameExceptId(name, id);
                } else {
                    isDuplicate = serviceDAO.existsByName(name);
                }
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String message = isDuplicate ? "Tên này đã tồn tại trong hệ thống." : "Tên hợp lệ";
                response.getWriter().write("{\"valid\": " + !isDuplicate + ", \"message\": \"" + message + "\"}");
                return;
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
                String originalFileName = getSubmittedFileName(part);
                String fileName = System.currentTimeMillis() + "_" + originalFileName;
                String uploadPath = getServletContext().getRealPath("/assets/uploads/services/");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                try {
                    part.write(uploadPath + File.separator + fileName);
                    System.out.println("Saved file: " + uploadPath + File.separator + fileName);
                    String imageUrl = "/assets/uploads/services/" + fileName;
                    imageUrls.add(imageUrl);
                } catch (Exception ex) {
                    ex.printStackTrace();
                    System.out.println("Error saving file: " + fileName);
                }
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
            int id = Integer.parseInt(request.getParameter("id").trim());
            s.setServiceId(id);
            serviceDAO.update(s);
            
            // Xử lý xóa ảnh cũ
            String[] deleteImageIds = request.getParameterValues("delete_image_ids");
            if (deleteImageIds != null) {
                ServiceImageDAO serviceImageDAO = new ServiceImageDAO();
                for (String imgIdStr : deleteImageIds) {
                    try {
                        int imgId = Integer.parseInt(imgIdStr);
                        serviceImageDAO.deleteById(imgId);
                    } catch (NumberFormatException ignored) {}
                }
            }

            // Thêm ảnh mới
            if (!imageUrls.isEmpty()) {
                ServiceImageDAO serviceImageDAO = new ServiceImageDAO();
                for (String url : imageUrls) {
                    serviceImageDAO.save(new ServiceImage(id, url));
                }
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
