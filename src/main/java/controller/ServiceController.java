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
import util.ImageUploadUtil;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.google.gson.JsonObject;

@WebServlet(name = "ServiceController", urlPatterns = { "/manager/service" })
@MultipartConfig(fileSizeThreshold = 0, maxFileSize = 2097152, // 2MB
        maxRequestSize = 2097152)
public class ServiceController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ServiceController.class.getName());
    private final String SERVICE_MANAGER_URL = "/WEB-INF/view/admin_pages/Service/ServiceManager.jsp";

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
            } catch (Exception ignored) {
            }
        }
        int page = 1;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (Exception ignored) {
            }
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
                        serviceThumbnails.put(s.getServiceId(), images.get(0).getUrl());
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
                int start = totalRecords == 0 ? 0 : offset + 1;
                int end = Math.min(offset + services.size(), totalRecords);
                request.setAttribute("start", start);
                request.setAttribute("end", end);
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
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/Service/AddService.jsp").forward(request,
                        response);
                return;
            }
            case "pre-update": {
                try {
                    int id = Integer.parseInt(request.getParameter("id").trim());
                    Service s = serviceDAO.findById(id).orElse(null);
                    
                    if (s == null) {
                        response.sendRedirect("service?service=list-all&toastType=error&toastMessage=Dịch+vụ+không+tồn+tại");
                        return;
                    }
                    
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

                    request.getRequestDispatcher("/WEB-INF/view/admin_pages/Service/UpdateService.jsp").forward(request,
                            response);
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid service ID format: " + request.getParameter("id"));
                    response.sendRedirect("service?service=list-all&toastType=error&toastMessage=ID+dịch+vụ+không+hợp+lệ");
                }
                return;
            }
            case "delete": {
                try {
                    int id = Integer.parseInt(request.getParameter("id").trim());
                    Service serviceToDelete = serviceDAO.findById(id).orElse(null);
                    
                    if (serviceToDelete == null) {
                        response.sendRedirect("service?service=list-all&toastType=error&toastMessage=Dịch+vụ+không+tồn+tại");
                        return;
                    }
                    
                    serviceDAO.deleteById(id);
                    response.sendRedirect("service?service=list-all&toastType=success&toastMessage=Đã+xóa+dịch+vụ+thành+công");
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid service ID format: " + request.getParameter("id"));
                    response.sendRedirect("service?service=list-all&toastType=error&toastMessage=ID+dịch+vụ+không+hợp+lệ");
                }
                return;
            }
            case "deactivate": {
                try {
                    int id = Integer.parseInt(request.getParameter("id").trim());
                    Service serviceToDeactivate = serviceDAO.findById(id).orElse(null);
                    
                    if (serviceToDeactivate == null) {
                        response.sendRedirect("service?service=list-all&toastType=error&toastMessage=Dịch+vụ+không+tồn+tại");
                        return;
                    }
                    
                    serviceDAO.deactivateById(id);
                    // Lấy tham số truy vấn để redirect giữ nguyên trang
                    String pageParam = request.getParameter("page");
                    String keyword = request.getParameter("keyword");
                    String status = request.getParameter("status");
                    String serviceTypeIdStr = request.getParameter("serviceTypeId");
                    StringBuilder redirectUrl = new StringBuilder("service?service=list-all&toastType=success&toastMessage=Đã+vô+hiệu+hóa+dịch+vụ+thành+công");
                    if (pageParam != null)
                        redirectUrl.append("&page=").append(pageParam);
                    if (limitParam != null)
                        redirectUrl.append("&limit=").append(limitParam);
                    if (keyword != null && !keyword.isEmpty())
                        redirectUrl.append("&keyword=").append(keyword);
                    if (status != null && !status.isEmpty())
                        redirectUrl.append("&status=").append(status);
                    if (serviceTypeIdStr != null && !serviceTypeIdStr.isEmpty())
                        redirectUrl.append("&serviceTypeId=").append(serviceTypeIdStr);
                    response.sendRedirect(redirectUrl.toString());
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid service ID format: " + request.getParameter("id"));
                    response.sendRedirect("service?service=list-all&toastType=error&toastMessage=ID+dịch+vụ+không+hợp+lệ");
                }
                return;
            }
            case "activate": {
                try {
                    int id = Integer.parseInt(request.getParameter("id").trim());
                    Service serviceToActivate = serviceDAO.findById(id).orElse(null);
                    
                    if (serviceToActivate == null) {
                        response.sendRedirect("service?service=list-all&toastType=error&toastMessage=Dịch+vụ+không+tồn+tại");
                        return;
                    }
                    
                    serviceDAO.activateById(id);
                    // Lấy tham số truy vấn để redirect giữ nguyên trang
                    String pageParam = request.getParameter("page");
                    String keyword = request.getParameter("keyword");
                    String status = request.getParameter("status");
                    String serviceTypeIdStr = request.getParameter("serviceTypeId");
                    StringBuilder redirectUrl = new StringBuilder("service?service=list-all&toastType=success&toastMessage=Đã+kích+hoạt+dịch+vụ+thành+công");
                    if (pageParam != null)
                        redirectUrl.append("&page=").append(pageParam);
                    if (limitParam != null)
                        redirectUrl.append("&limit=").append(limitParam);
                    if (keyword != null && !keyword.isEmpty())
                        redirectUrl.append("&keyword=").append(keyword);
                    if (status != null && !status.isEmpty())
                        redirectUrl.append("&status=").append(status);
                    if (serviceTypeIdStr != null && !serviceTypeIdStr.isEmpty())
                        redirectUrl.append("&serviceTypeId=").append(serviceTypeIdStr);
                    response.sendRedirect(redirectUrl.toString());
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid service ID format: " + request.getParameter("id"));
                    response.sendRedirect("service?service=list-all&toastType=error&toastMessage=ID+dịch+vụ+không+hợp+lệ");
                }
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
                int start = totalRecords == 0 ? 0 : offset + 1;
                int end = Math.min(offset + services.size(), totalRecords);
                request.setAttribute("start", start);
                request.setAttribute("end", end);
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
                        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Service/ViewDetailService.jsp")
                                .forward(request, response);
                    } else {
                        response.sendRedirect(
                                "service?service=list-all&toastType=error&toastMessage=Không+tìm+thấy+dịch+vụ");
                    }
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid service ID format: " + request.getParameter("id"));
                    response.sendRedirect("service?service=list-all&toastType=error&toastMessage=ID+dịch+vụ+không+hợp+lệ");
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Error viewing service detail", e);
                    response.sendRedirect(
                            "service?service=list-all&toastType=error&toastMessage=Có+lỗi+xảy+ra+khi+xem+chi+tiết+dịch+vụ");
                }
                return;
            }
            case "check-duplicate-name": {
                handleCheckDuplicateName(request, response);
                return; // DỪNG LUỒNG, KHÔNG FORWARD JSP NỮA
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

        try {
            String serviceTypeIdStr = request.getParameter("service_type_id");
            int serviceTypeId = Integer.parseInt(serviceTypeIdStr);
            ServiceType serviceType = typeDAO.findById(serviceTypeId).orElse(null);
            
            if (serviceType == null) {
                response.sendRedirect("service?service=list-all&toastType=error&toastMessage=Loại+dịch+vụ+không+tồn+tại");
                return;
            }

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

            if (service.equals("insert")) {
                // Save service first to get the service ID
                serviceDAO.save(s);
                int serviceId = s.getServiceId();

                // Process image uploads using modern approach
                processServiceImages(request, serviceId);
                
                response.sendRedirect("service?service=list-all&toastType=success&toastMessage=Đã+tạo+dịch+vụ+thành+công");

            } else if (service.equals("update")) {
                try {
                    int id = Integer.parseInt(request.getParameter("id").trim());
                    Service existingService = serviceDAO.findById(id).orElse(null);
                    
                    if (existingService == null) {
                        response.sendRedirect("service?service=list-all&toastType=error&toastMessage=Dịch+vụ+không+tồn+tại");
                        return;
                    }
                    
                    s.setServiceId(id);
                    serviceDAO.update(s);

                    // Handle image deletion
                    String[] deleteImageIds = request.getParameterValues("delete_image_ids");
                    if (deleteImageIds != null) {
                        ServiceImageDAO serviceImageDAO = new ServiceImageDAO();
                        for (String imgIdStr : deleteImageIds) {
                            try {
                                int imgId = Integer.parseInt(imgIdStr);
                                serviceImageDAO.deleteById(imgId);
                            } catch (NumberFormatException ignored) {
                            }
                        }
                    }

                    // Process new image uploads
                    processServiceImages(request, id);
                    
                    response.sendRedirect("service?service=list-all&toastType=success&toastMessage=Đã+cập+nhật+dịch+vụ+thành+công");
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid service ID format: " + request.getParameter("id"));
                    response.sendRedirect("service?service=list-all&toastType=error&toastMessage=ID+dịch+vụ+không+hợp+lệ");
                }
            }
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid number format in form data");
            response.sendRedirect("service?service=list-all&toastType=error&toastMessage=Dữ+liệu+không+hợp+lệ");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing service form", e);
            response.sendRedirect("service?service=list-all&toastType=error&toastMessage=Có+lỗi+xảy+ra+khi+xử+lý+dữ+liệu");
        }
    }

    /**
     * Process image uploads using the modern ImageUploadUtil approach
     */
    private void processServiceImages(HttpServletRequest request, int serviceId) throws IOException, ServletException {
        // Save to D: drive spa-uploads directory
        String webappPath = "D:/spa-uploads";
        ImageUploadUtil.ensureDirectoriesExist(webappPath);

        ServiceImageDAO serviceImageDAO = new ServiceImageDAO();
        int sortOrder = getNextSortOrder(serviceId);

        // Process each uploaded image
        Collection<Part> fileParts = request.getParts();
        for (Part filePart : fileParts) {
            if (!"images".equals(filePart.getName()) || filePart.getSize() == 0) {
                continue;
            }

            try {
                // Validate file
                ImageUploadUtil.ValidationResult validation = ImageUploadUtil.validateFile(filePart);
                if (!validation.isValid()) {
                    LOGGER.warning("Image validation failed: " + validation.getErrors());
                    continue;
                }

                // Validate image dimensions
                ImageUploadUtil.ValidationResult dimensionValidation = ImageUploadUtil
                        .validateImageDimensions(filePart.getInputStream());
                if (!dimensionValidation.isValid()) {
                    LOGGER.warning("Image dimension validation failed: " + dimensionValidation.getErrors());
                    continue;
                }

                // Create ServiceImage entity first to get ID
                ServiceImage serviceImage = new ServiceImage();
                serviceImage.setServiceId(serviceId);
                serviceImage.setUrl(""); // Temporary, will be updated after processing
                serviceImage.setAltText("Ảnh dịch vụ");
                serviceImage.setIsPrimary(sortOrder == 0); // First image is primary
                serviceImage.setSortOrder(sortOrder);
                serviceImage.setIsActive(true);

                // Save to get the image ID
                ServiceImage savedImage = serviceImageDAO.save(serviceImage);
                if (savedImage == null || savedImage.getImageId() == null) {
                    LOGGER.warning("Failed to save image record");
                    continue;
                }

                // Process and save image files using ImageUploadUtil
                ImageUploadUtil.ProcessedImageResult processedResult = ImageUploadUtil.processAndSaveFullSizeImageOnly(
                        filePart, webappPath, serviceId, savedImage.getImageId());

                // Update the ServiceImage with the actual URL and metadata
                savedImage.setUrl(processedResult.getFullSizeUrl());
                savedImage.setFileSize(processedResult.getFileSize());
                serviceImageDAO.update(savedImage);

                LOGGER.info("Successfully saved image: " + processedResult.getFullSizeUrl());
                sortOrder++;

            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error processing image upload: " + e.getMessage(), e);
            }
        }
    }

    /**
     * Gets the next sort order for images of a service
     */
    private int getNextSortOrder(int serviceId) {
        ServiceImageDAO serviceImageDAO = new ServiceImageDAO();
        List<ServiceImage> existingImages = serviceImageDAO.findByServiceId(serviceId);
        return existingImages.size();
    }

    private String getSubmittedFileName(Part part) {
        if (part == null)
            return "";
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null)
            return "";
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    // Add this method to handle duplicate name check
    private void handleCheckDuplicateName(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String idParam = request.getParameter("id");
        
        if (name == null || name.trim().isEmpty()) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"valid\": false, \"message\": \"Tên dịch vụ không được để trống\"}");
            return;
        }

        name = name.trim();
        ServiceDAO serviceDAO = new ServiceDAO();
        ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO();
        boolean isDuplicate;

        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                isDuplicate = serviceDAO.existsByNameExceptId(name, id) || serviceTypeDAO.existsByName(name);
            } catch (NumberFormatException e) {
                isDuplicate = serviceDAO.existsByName(name) || serviceTypeDAO.existsByName(name);
            }
        } else {
            isDuplicate = serviceDAO.existsByName(name) || serviceTypeDAO.existsByName(name);
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String message = isDuplicate ? "Tên này đã tồn tại trong hệ thống." : "Tên hợp lệ.";
        response.getWriter().write("{\"valid\": " + !isDuplicate + ", \"message\": \"" + message + "\"}");
    }

    @Override
    public String getServletInfo() {
        return "Controller for managing Services";
    }
}
