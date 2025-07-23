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
import util.CloudinaryConfig;

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
import java.net.URLEncoder;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.UUID;

@WebServlet(name = "ServiceController", urlPatterns = { "/manager/service" })
@MultipartConfig(fileSizeThreshold = 0, maxFileSize = 2097152, maxRequestSize = 10485760) // 10MB
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
                        String toastMessage = URLEncoder.encode("Dịch vụ không tồn tại", "UTF-8");
                        response.sendRedirect("service?service=list-all&toastType=error&toastMessage=" + toastMessage);
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
                        String toastMessage = URLEncoder.encode("Dịch vụ không tồn tại", "UTF-8");
                        response.sendRedirect("service?service=list-all&toastType=error&toastMessage=" + toastMessage);
                        return;
                    }
                    
                    serviceDAO.deleteById(id);
                    String toastMessage = URLEncoder.encode("Đã xóa dịch vụ thành công", "UTF-8");
                    response.sendRedirect("service?service=list-all&toastType=success&toastMessage=" + toastMessage);
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
                        String toastMessage = URLEncoder.encode("Dịch vụ không tồn tại", "UTF-8");
                        response.sendRedirect("service?service=list-all&toastType=error&toastMessage=" + toastMessage);
                        return;
                    }
                    
                    serviceDAO.deactivateById(id);
                    // Lấy tham số truy vấn để redirect giữ nguyên trang
                    String pageParam = request.getParameter("page");
                    String keyword = request.getParameter("keyword");
                    String status = request.getParameter("status");
                    String serviceTypeIdStr = request.getParameter("serviceTypeId");
                    StringBuilder redirectUrl = new StringBuilder("service?service=list-all&toastType=success&toastMessage=").append(URLEncoder.encode("Đã vô hiệu hóa dịch vụ thành công", "UTF-8"));
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
                        String toastMessage = URLEncoder.encode("Dịch vụ không tồn tại", "UTF-8");
                        response.sendRedirect("service?service=list-all&toastType=error&toastMessage=" + toastMessage);
                        return;
                    }
                    
                    serviceDAO.activateById(id);
                    // Lấy tham số truy vấn để redirect giữ nguyên trang
                    String pageParam = request.getParameter("page");
                    String keyword = request.getParameter("keyword");
                    String status = request.getParameter("status");
                    String serviceTypeIdStr = request.getParameter("serviceTypeId");
                    StringBuilder redirectUrl = new StringBuilder("service?service=list-all&toastType=success&toastMessage=").append(URLEncoder.encode("Đã kích hoạt dịch vụ thành công", "UTF-8"));
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
                        String toastMessage = URLEncoder.encode("Không tìm thấy dịch vụ", "UTF-8");
                        response.sendRedirect(
                                "service?service=list-all&toastType=error&toastMessage=" + toastMessage);
                    }
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid service ID format: " + request.getParameter("id"));
                    response.sendRedirect("service?service=list-all&toastType=error&toastMessage=ID+dịch+vụ+không+hợp+lệ");
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Error viewing service detail", e);
                    String toastMessage = URLEncoder.encode("Có lỗi xảy ra khi xem chi tiết dịch vụ", "UTF-8");
                    response.sendRedirect(
                            "service?service=list-all&toastType=error&toastMessage=" + toastMessage);
                }
                return;
            }
            case "check-duplicate-name": {
                handleCheckDuplicateName(request, response);
                return; // DỪNG LUỒNG, KHÔNG FORWARD JSP NỮA
            }
            case "singleImageUpload": {
                try {
                    int serviceId = Integer.parseInt(request.getParameter("serviceId"));
                    Service serviceObj = serviceDAO.findById(serviceId).orElse(null);
                    if (serviceObj == null) {
                        response.sendRedirect("service?service=list-all&toastType=error&toastMessage=Không+tìm+thấy+Dịch+vụ");
                        return;
                    }
                    List<ServiceImage> existingImages = serviceImageDAO.findByServiceId(serviceId);
                    request.setAttribute("service", serviceObj);
                    request.setAttribute("existingImages", existingImages);
                    request.getRequestDispatcher("/WEB-INF/view/admin_pages/Service/SingleImageUpload.jsp").forward(request, response);
                } catch (Exception e) {
                    response.sendRedirect("service?service=list-all&toastType=error&toastMessage=ID+Dịch+vụ+không+hợp+lệ");
                }
                return;
            }
        }

        request.getRequestDispatcher(SERVICE_MANAGER_URL).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("uploadImage".equals(action)) {
            handleAjaxImageUpload(request, response);
            return;
        }

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
                
                String toastMessage = URLEncoder.encode("Đã tạo dịch vụ thành công", "UTF-8");
                response.sendRedirect("service?service=list-all&toastType=success&toastMessage=" + toastMessage);
                return;

            } else if (service.equals("update")) {
                try {
                    int id = Integer.parseInt(request.getParameter("id").trim());
                    Service existingService = serviceDAO.findById(id).orElse(null);
                    
                    if (existingService == null) {
                        String toastMessage = URLEncoder.encode("Dịch vụ không tồn tại", "UTF-8");
                        response.sendRedirect("service?service=list-all&toastType=error&toastMessage=" + toastMessage);
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
                    
                    String toastMessage = URLEncoder.encode("Đã cập nhật dịch vụ thành công", "UTF-8");
                    response.sendRedirect("service?service=list-all&toastType=success&toastMessage=" + toastMessage);
                    return;
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid service ID format: " + request.getParameter("id"));
                    String toastMessage = URLEncoder.encode("ID dịch vụ không hợp lệ", "UTF-8");
                    response.sendRedirect("service?service=list-all&toastType=error&toastMessage=" + toastMessage);
                    return;
                }
            }
        } catch (IllegalStateException ex) {
            // Lỗi vượt quá dung lượng file upload
            String toastMessage = URLEncoder.encode("File upload vượt quá giới hạn", "UTF-8");
            response.sendRedirect("service?service=list-all&toastType=error&toastMessage=" + toastMessage);
            return;
        } catch (NumberFormatException e) {
            // Lỗi dữ liệu số không hợp lệ
            String toastMessage = URLEncoder.encode("Dữ liệu không hợp lệ", "UTF-8");
            response.sendRedirect("service?service=list-all&toastType=error&toastMessage=" + toastMessage);
            return;
        } catch (Exception e) {
            // Lỗi không xác định
            LOGGER.log(Level.SEVERE, "Error processing service form", e);
            String toastMessage = URLEncoder.encode("Có lỗi xảy ra khi xử lý dữ liệu", "UTF-8");
            response.sendRedirect("service?service=list-all&toastType=error&toastMessage=" + toastMessage);
            return;
        }
    }

    /**
     * Process image uploads using the modern ImageUploadUtil approach
     */
    private void processServiceImages(HttpServletRequest request, int serviceId) throws IOException, ServletException {
        ServiceImageDAO serviceImageDAO = new ServiceImageDAO();
        int sortOrder = getNextSortOrder(serviceId);

        Collection<Part> fileParts = request.getParts();
        for (Part filePart : fileParts) {
            if (!"images".equals(filePart.getName()) || filePart.getSize() == 0) {
                continue;
            }

            try {
                // Validate file (giữ lại nếu muốn)
                ImageUploadUtil.ValidationResult validation = ImageUploadUtil.validateFile(filePart);
                if (!validation.isValid()) {
                    LOGGER.warning("Image validation failed: " + validation.getErrors());
                    continue;
                }

                // Validate image dimensions (giữ lại nếu muốn)
                ImageUploadUtil.ValidationResult dimensionValidation = ImageUploadUtil
                        .validateImageDimensions(filePart.getInputStream());
                if (!dimensionValidation.isValid()) {
                    LOGGER.warning("Image dimension validation failed: " + dimensionValidation.getErrors());
                    continue;
                }

                // Đọc file thành byte[]
                byte[] fileBytes;
                try (InputStream inputStream = filePart.getInputStream();
                     ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
                    byte[] buffer = new byte[8192];
                    int bytesRead;
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        baos.write(buffer, 0, bytesRead);
                    }
                    fileBytes = baos.toByteArray();
                }

                // Upload lên Cloudinary
                String publicId = "services/" + serviceId + "/" + UUID.randomUUID().toString();
                Map<String, Object> uploadResult = CloudinaryConfig.uploadImage(fileBytes, publicId);
                String fileUrl = (String) uploadResult.get("secure_url");

                // Lưu DB
                ServiceImage serviceImage = new ServiceImage();
                serviceImage.setServiceId(serviceId);
                serviceImage.setUrl(fileUrl);
                serviceImage.setAltText("Service image for " + filePart.getSubmittedFileName());
                serviceImage.setIsPrimary(sortOrder == 0);
                serviceImage.setSortOrder(sortOrder);
                serviceImage.setIsActive(true);
                serviceImage.setCaption("Uploaded via ServiceController");
                serviceImage.setFileSize(fileBytes.length); // <--- Thêm dòng này

                serviceImageDAO.save(serviceImage);

                LOGGER.info("Successfully saved image: " + fileUrl);
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

    private void handleAjaxImageUpload(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String serviceIdParam = request.getParameter("serviceId");
        int serviceId;
        try {
            serviceId = Integer.parseInt(serviceIdParam);
        } catch (Exception e) {
            response.getWriter().write("{\"success\":false,\"error\":\"ID dịch vụ không hợp lệ\"}");
            return;
        }

        ServiceImageDAO serviceImageDAO = new ServiceImageDAO();
        List<ServiceImage> existingImages = serviceImageDAO.findByServiceId(serviceId);
        if (existingImages.size() >= 5) {
            response.getWriter().write("{\"success\":false,\"error\":\"Mỗi dịch vụ chỉ được tối đa 5 ảnh!\"}");
            return;
        }

        Part filePart = request.getPart("images");
        if (filePart == null || filePart.getSize() == 0) {
            response.getWriter().write("{\"success\":false,\"error\":\"Không có file ảnh\"}");
            return;
        }

        try {
            // Validate file
            ImageUploadUtil.ValidationResult validation = ImageUploadUtil.validateFile(filePart);
            if (!validation.isValid()) {
                response.getWriter().write("{\"success\":false,\"error\":\"" + validation.getErrors() + "\"}");
                return;
            }
            // Validate image dimensions
            ImageUploadUtil.ValidationResult dimensionValidation = ImageUploadUtil.validateImageDimensions(filePart.getInputStream());
            if (!dimensionValidation.isValid()) {
                response.getWriter().write("{\"success\":false,\"error\":\"" + dimensionValidation.getErrors() + "\"}");
                return;
            }
            // Đọc file thành byte[]
            byte[] fileBytes;
            try (InputStream inputStream = filePart.getInputStream();
                 ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    baos.write(buffer, 0, bytesRead);
                }
                fileBytes = baos.toByteArray();
            }
            // Upload lên Cloudinary
            String publicId = "services/" + serviceId + "/" + UUID.randomUUID().toString();
            Map<String, Object> uploadResult = CloudinaryConfig.uploadImage(fileBytes, publicId);
            String fileUrl = (String) uploadResult.get("secure_url");
            // Lưu DB
            int sortOrder = getNextSortOrder(serviceId);
            ServiceImage serviceImage = new ServiceImage();
            serviceImage.setServiceId(serviceId);
            serviceImage.setUrl(fileUrl);
            serviceImage.setAltText("Service image for " + filePart.getSubmittedFileName());
            serviceImage.setIsPrimary(sortOrder == 0);
            serviceImage.setSortOrder(sortOrder);
            serviceImage.setIsActive(true);
            serviceImage.setCaption("Uploaded via ServiceController");
            serviceImage.setFileSize(fileBytes.length);
            serviceImageDAO.save(serviceImage);
            response.getWriter().write("{\"success\":true,\"url\":\"" + fileUrl + "\"}");
        } catch (Exception e) {
            response.getWriter().write("{\"success\":false,\"error\":\"Upload thất bại: " + e.getMessage().replace("\"", "'") + "\"}");
        }
    }

    @Override
    public String getServletInfo() {
        return "Controller for managing Services";
    }
}
