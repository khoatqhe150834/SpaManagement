package controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.PromotionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Promotion;
import util.ImageUploadValidator;

/**
 * Controller xử lý các yêu cầu liên quan đến khuyến mãi.
 * URL Pattern: /promotion/*
 * Hỗ trợ các hành động: list, view, create, edit, activate, deactivate, usage-report.
 */
@WebServlet(urlPatterns = {"/promotion/*"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 1024 * 1024 * 10,     // 10 MB
    maxRequestSize = 1024 * 1024 * 50   // 50 MB
)
public class PromotionController extends HttpServlet {

    private PromotionDAO promotionDAO;
    private static final Logger logger = Logger.getLogger(PromotionController.class.getName());
    private static final int DEFAULT_PAGE_SIZE = 10;
    private static final String UPLOAD_DIR = "/uploads/promotions/";

    @Override
    public void init() {
        promotionDAO = new PromotionDAO();
        logger.info("PromotionController initialized successfully.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        

        String pathInfo = request.getPathInfo();
        logger.info("GET request received for path: " + pathInfo);

        try {
            String action = (pathInfo == null || pathInfo.equals("/")) ? "list" : pathInfo.split("/")[1].toLowerCase();

            switch (action) {
                case "list":
                case "search":
                    handleListPromotions(request, response);
                    break;
                case "view":
                    handleViewPromotion(request, response);
                    break;
                case "create":
                    handleShowCreateForm(request, response);
                    break;
                case "edit":
                    handleShowEditForm(request, response);
                    break;
                case "deactivate":
                    handleDeactivatePromotion(request, response);
                    break;
                case "activate":
                    handleActivatePromotion(request, response);
                    break;
                case "usage-report":
                    handleUsageReport(request, response);
                    break;
                default:
                    logger.warning("Invalid action in GET request: " + action);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Action not found: " + action);
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing GET request", e);
            handleError(request, response, "An unexpected error occurred: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        

        String action = request.getParameter("action");
        logger.info("POST request received for action: " + action);

        try {
            if (action == null || action.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action parameter is missing.");
                return;
            }

            switch (action.toLowerCase()) {
                case "create":
                    handleCreateOrUpdatePromotion(request, response, false);
                    break;
                case "update":
                    handleCreateOrUpdatePromotion(request, response, true);
                    break;
                default:
                    logger.warning("Invalid action in POST request: " + action);
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action specified.");
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing POST request", e);
            handleError(request, response, "An unexpected error occurred: " + e.getMessage());
        }
    }

    private void handleListPromotions(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int page = getIntParameter(request, "page", 1);
        int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);
        String searchValue = request.getParameter("searchValue");
        String status = request.getParameter("status");
        String sortBy = Optional.ofNullable(request.getParameter("sortBy")).filter(s -> s.matches("^(id|title|status|code|discount_value)$")).orElse("id");
        String sortOrder = Optional.ofNullable(request.getParameter("sortOrder")).filter(s -> s.matches("^(asc|desc)$")).orElse("asc");

        List<Promotion> promotions;
        int totalPromotions;

        if (searchValue != null && !searchValue.trim().isEmpty()) {
            promotions = promotionDAO.search(searchValue, status, page, pageSize, sortBy, sortOrder);
            totalPromotions = promotionDAO.countSearchResults(searchValue, status);
        } else {
            promotions = promotionDAO.findAll(status, page, pageSize, sortBy, sortOrder);
            totalPromotions = promotionDAO.countAll(status);
        }

        int totalPages = (int) Math.ceil((double) totalPromotions / pageSize);

        request.setAttribute("listPromotion", promotions);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("status", status);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("searchValue", searchValue);
        request.setAttribute("totalPromotions", totalPromotions);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Promotion/promotion_list.jsp").forward(request, response);
    }

    private void handleViewPromotion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int promotionId = getIntParameter(request, "id", 0);
            if (promotionId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid or missing Promotion ID.");
                return;
            }

            Optional<Promotion> promotionOpt = promotionDAO.findById(promotionId);
            if (promotionOpt.isPresent()) {
                request.setAttribute("promotion", promotionOpt.get());
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/Promotion/promotion_details.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Promotion not found with ID: " + promotionId);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid promotion ID format.");
        }
    }

    private void handleShowCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("promotion", new Promotion()); // Dùng 'promotion' cho nhất quán
        request.setAttribute("isEdit", false);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Promotion/promotion_form.jsp").forward(request, response);
    }

    private void handleShowEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int promotionId = getIntParameter(request, "id", 0);
            if (promotionId <= 0) {
                handleError(request, response, "Invalid Promotion ID.");
                return;
            }

            Optional<Promotion> promotionOpt = promotionDAO.findById(promotionId);
            if (promotionOpt.isPresent()) {
                request.setAttribute("promotion", promotionOpt.get());
                request.setAttribute("isEdit", true);
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/Promotion/promotion_form.jsp").forward(request, response);
            } else {
                handleError(request, response, "Promotion not found with ID: " + promotionId);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error displaying edit form", e);
            handleError(request, response, "Error loading promotion for editing.");
        }
    }
    
    private void handleCreateOrUpdatePromotion(HttpServletRequest request, HttpServletResponse response, boolean isEdit) throws ServletException, IOException {
        Promotion promotion;
        int promotionId = 0;

        if (isEdit) {
            promotionId = getIntParameter(request, "id", 0);
            Optional<Promotion> existingPromotionOpt = promotionDAO.findById(promotionId);
            if (!existingPromotionOpt.isPresent()) {
                handleError(request, response, "Promotion not found for update.");
                return;
            }
            promotion = existingPromotionOpt.get();
        } else {
            promotion = new Promotion();
        }
        
        // Gán dữ liệu từ request vào object và validate
        Map<String, String> errors = mapAndValidateRequestToPromotion(request, promotion, isEdit);

        // Xử lý upload ảnh
        try {
            String newImageUrl = handleImageUpload(request);
            if (newImageUrl != null) {
                // Xóa ảnh cũ nếu có và đang cập nhật ảnh mới
                if (isEdit && promotion.getImageUrl() != null && !promotion.getImageUrl().isEmpty()) {
                    // Cần có logic xóa file ảnh cũ tại đây
                }
                promotion.setImageUrl(newImageUrl);
            }
        } catch (IOException e) {
            errors.put("imageUrl", e.getMessage());
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("promotion", promotion);
            request.setAttribute("isEdit", isEdit);
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Promotion/promotion_form.jsp").forward(request, response);
            return;
        }

        // Lưu hoặc cập nhật
        boolean success;
        String successMessage;

        if (isEdit) {
            success = promotionDAO.update(promotion);
            successMessage = "Khuyến mãi đã được cập nhật thành công!";
        } else {
            success = promotionDAO.save(promotion);
            successMessage = "Khuyến mãi đã được tạo thành công!";
        }

        if (success) {
            request.getSession().setAttribute("successMessage", successMessage);
            response.sendRedirect(request.getContextPath() + "/promotion/list");
        } else {
            errors.put("general", "Không thể lưu khuyến mãi vào cơ sở dữ liệu. Vui lòng thử lại.");
            request.setAttribute("errors", errors);
            request.setAttribute("promotion", promotion);
            request.setAttribute("isEdit", isEdit);
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Promotion/promotion_form.jsp").forward(request, response);
        }
    }

    private Map<String, String> mapAndValidateRequestToPromotion(HttpServletRequest request, Promotion promotion, boolean isEdit) {
        Map<String, String> errors = new HashMap<>();
        
        // Lấy dữ liệu từ request
        String title = getStringParameter(request, "title");
        String promotionCode = getStringParameter(request, "promotionCode");
        String discountType = getStringParameter(request, "discountType");
        String discountValueStr = getStringParameter(request, "discountValue");
        String description = getStringParameter(request, "description");
        String status = getStringParameter(request, "status", "SCHEDULED");
        String startDateStr = getStringParameter(request, "startDate");
        String endDateStr = getStringParameter(request, "endDate");
        String customerCondition = getStringParameter(request, "customerCondition", "ALL");

        // Validate và gán dữ liệu vào object
        // Title
        if (title == null || title.trim().length() < 3) errors.put("title", "Tên khuyến mãi phải có ít nhất 3 ký tự");
        else if (title.trim().length() > 255) errors.put("title", "Tên khuyến mãi không được vượt quá 255 ký tự");
        promotion.setTitle(title);
        
        // Promotion Code
        if (promotionCode != null && !promotionCode.trim().isEmpty()) {
            if (!promotionCode.matches("^[A-Z0-9]{3,50}$")) {
                errors.put("promotionCode", "Mã khuyến mãi phải từ 3-50 ký tự, chỉ chứa chữ hoa và số.");
            } else {
                // Kiểm tra trùng lặp, bỏ qua chính nó khi đang edit
                Optional<Promotion> existing = promotionDAO.findByCode(promotionCode.toUpperCase());
                if (existing.isPresent() && (!isEdit || existing.get().getPromotionId() != promotion.getPromotionId())) {
                    errors.put("promotionCode", "Mã khuyến mãi đã tồn tại.");
                }
            }
            promotion.setPromotionCode(promotionCode.toUpperCase());
        }

        // Discount Type and Value
        if (discountType == null || discountType.trim().isEmpty()) errors.put("discountType", "Vui lòng chọn loại giảm giá");
        promotion.setDiscountType(discountType);

        if (discountValueStr == null || discountValueStr.trim().isEmpty()) {
            errors.put("discountValue", "Vui lòng nhập giá trị giảm giá");
        } else {
            try {
                BigDecimal discountValue = new BigDecimal(discountValueStr);
                if (discountValue.compareTo(BigDecimal.ZERO) <= 0) errors.put("discountValue", "Giá trị giảm giá phải lớn hơn 0");
                if ("PERCENTAGE".equalsIgnoreCase(discountType) && discountValue.compareTo(new BigDecimal("100")) > 0) errors.put("discountValue", "Giảm giá theo % không được vượt quá 100");
                promotion.setDiscountValue(discountValue);
            } catch (NumberFormatException e) {
                errors.put("discountValue", "Giá trị giảm giá không hợp lệ");
            }
        }
        
        // Description
        if (description == null || description.trim().isEmpty()) errors.put("description", "Vui lòng nhập mô tả");
        else if (description.trim().length() > 1000) errors.put("description", "Mô tả không được vượt quá 1000 ký tự");
        promotion.setDescription(description);

        // Dates
        LocalDateTime startDate = null, endDate = null;
        if (startDateStr == null || startDateStr.trim().isEmpty()) errors.put("startDate", "Vui lòng chọn ngày bắt đầu");
        else {
            try { startDate = LocalDate.parse(startDateStr).atStartOfDay(); promotion.setStartDate(startDate); } 
            catch (Exception e) { errors.put("startDate", "Định dạng ngày bắt đầu không hợp lệ"); }
        }
        if (endDateStr == null || endDateStr.trim().isEmpty()) errors.put("endDate", "Vui lòng chọn ngày kết thúc");
        else {
            try { endDate = LocalDate.parse(endDateStr).atTime(23, 59, 59); promotion.setEndDate(endDate); }
            catch (Exception e) { errors.put("endDate", "Định dạng ngày kết thúc không hợp lệ"); }
        }
        if (startDate != null && endDate != null && !endDate.isAfter(startDate)) errors.put("endDate", "Ngày kết thúc phải sau ngày bắt đầu");
        
        promotion.setStatus(status);
        promotion.setCustomerCondition(customerCondition);
        
        // Các giá trị mặc định cho các trường mới
        if (!isEdit) {
            promotion.setCurrentUsageCount(0);
            promotion.setIsAutoApply(false);
            promotion.setMinimumAppointmentValue(BigDecimal.ZERO);
            promotion.setApplicableScope("ENTIRE_APPOINTMENT");
        }

        return errors;
    }

    private String handleImageUpload(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("imageUrl");
        if (filePart == null || filePart.getSize() == 0) {
            return null; // Không có file mới được upload
        }
    
        if (!ImageUploadValidator.isValidImage(filePart)) {
            throw new IOException(ImageUploadValidator.getErrorMessage(filePart));
        }

        String fileName = getSubmittedFileName(filePart);
        String uniqueFileName = System.currentTimeMillis() + "_" + fileName.replaceAll("[^a-zA-Z0-9.-]", "_");
        
        String uploadPath = getServletContext().getRealPath(UPLOAD_DIR);
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, Paths.get(uploadPath, uniqueFileName), StandardCopyOption.REPLACE_EXISTING);
        }
        
        return request.getContextPath() + UPLOAD_DIR + uniqueFileName;
    }
    
    private void handleDeactivatePromotion(HttpServletRequest request, HttpServletResponse response) throws IOException {
        updatePromotionStatus(request, response, "deactivate");
    }

    private void handleActivatePromotion(HttpServletRequest request, HttpServletResponse response) throws IOException {
        updatePromotionStatus(request, response, "activate");
    }

    private void updatePromotionStatus(HttpServletRequest request, HttpServletResponse response, String statusAction) throws IOException {
        String redirectUrl = buildListRedirectUrl(request);
        try {
            int promotionId = getIntParameter(request, "id", 0);
            if (promotionId <= 0) {
                request.getSession().setAttribute("errorMessage", "Invalid promotion ID.");
            } else {
                boolean success = false;
                String actionVerb = "";

                if ("activate".equals(statusAction)) {
                    success = promotionDAO.activatePromotion(promotionId);
                    actionVerb = "activated";
                } else {
                    success = promotionDAO.deactivatePromotion(promotionId);
                    actionVerb = "deactivated";
                }

                if (success) {
                    request.getSession().setAttribute("successMessage", "Promotion has been " + actionVerb + " successfully.");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to " + statusAction + " the promotion.");
                }
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating promotion status to " + statusAction, e);
            request.getSession().setAttribute("errorMessage", "Error: " + e.getMessage());
        }
        response.sendRedirect(redirectUrl);
    }
    
    private void handleUsageReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int promotionId = getIntParameter(request, "id", 0);
            if (promotionId <= 0) {
                handleError(request, response, "Invalid promotion ID for usage report.");
                return;
            }

            Optional<Promotion> promotionOpt = promotionDAO.findById(promotionId);
            if (!promotionOpt.isPresent()) {
                handleError(request, response, "Promotion not found with ID: " + promotionId);
                return;
            }

            Promotion promotion = promotionOpt.get();
            request.setAttribute("promotion", promotion);

            int page = getIntParameter(request, "page", 1);
            int pageSize = getIntParameter(request, "pageSize", 10);

            List<Map<String, Object>> usageReportData = promotionDAO.getPromotionUsageReport(promotionId, page, pageSize);
            int totalUsage = promotionDAO.getTotalUsageCount(promotionId);
            int totalPages = (int) Math.ceil((double) totalUsage / pageSize);

            request.setAttribute("usageReportData", usageReportData);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalUsage", totalUsage);

            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Promotion/promotion_usage_report.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error generating usage report", e);
            handleError(request, response, "Error generating usage report: " + e.getMessage());
        }
    }
    
    // --- UTILITY METHODS ---

    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try {
                return Integer.parseInt(paramValue.trim());
            } catch (NumberFormatException e) {
                logger.warning("Invalid number format for parameter " + paramName + ": " + paramValue);
            }
        }
        return defaultValue;
    }

    private String getStringParameter(HttpServletRequest request, String paramName, String defaultValue) {
        String paramValue = request.getParameter(paramName);
        return (paramValue != null) ? paramValue.trim() : defaultValue;
    }

    private String getStringParameter(HttpServletRequest request, String paramName) {
        return getStringParameter(request, paramName, null);
    }

    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    private String buildListRedirectUrl(HttpServletRequest request) {
        List<String> params = new ArrayList<>();
        addParamIfPresent(params, "page", request.getParameter("page"));
        addParamIfPresent(params, "status", request.getParameter("status"));
        addParamIfPresent(params, "sortBy", request.getParameter("sortBy"));
        addParamIfPresent(params, "sortOrder", request.getParameter("sortOrder"));
        
        try {
            if (request.getParameter("searchValue") != null && !request.getParameter("searchValue").isEmpty()) {
                params.add("searchValue=" + URLEncoder.encode(request.getParameter("searchValue"), StandardCharsets.UTF_8.toString()));
            }
        } catch (Exception e) {
            logger.warning("Could not encode search parameter: " + e.getMessage());
        }

        String queryString = String.join("&", params);
        return request.getContextPath() + "/promotion/list" + (queryString.isEmpty() ? "" : "?" + queryString);
    }
    
    private void addParamIfPresent(List<String> params, String key, String value) {
        if (value != null && !value.isEmpty()) {
            params.add(key + "=" + value);
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage) throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Promotion/promotion_list.jsp").forward(request, response);
    }

    
}