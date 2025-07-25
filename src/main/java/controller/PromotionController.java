package controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
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
                Promotion promotion = promotionOpt.get();
                
                // Đảm bảo các giá trị null được xử lý an toàn
                if (promotion.getCurrentUsageCount() == null) {
                    promotion.setCurrentUsageCount(0);
                }
                if (promotion.getUsageLimitPerCustomer() == null) {
                    promotion.setUsageLimitPerCustomer(0);
                }
                if (promotion.getTotalUsageLimit() == null) {
                    promotion.setTotalUsageLimit(0);
                }
                if (promotion.getMinimumAppointmentValue() == null) {
                    promotion.setMinimumAppointmentValue(BigDecimal.ZERO);
                }
                
                request.setAttribute("promotion", promotion);
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/Promotion/promotion_details.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Promotion not found with ID: " + promotionId);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid promotion ID format.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error viewing promotion details", e);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống khi tải thông tin khuyến mãi. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Promotion/promotion_details.jsp").forward(request, response);
        }
    }

    private void handleShowCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("promotion", new Promotion()); // Dùng 'promotion' cho nhất quán
        request.setAttribute("isEdit", false);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Promotion/promotion_add.jsp").forward(request, response);
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
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/Promotion/promotion_edit.jsp").forward(request, response);
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
        Map<String, List<String>> errors = mapAndValidateRequestToPromotion(request, promotion, isEdit);

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
            logger.log(Level.WARNING, "Image upload error: " + e.getMessage(), e);
            errors.put("imageUrl", new ArrayList<>(List.of(e.getMessage())));
        }

        if (!errors.isEmpty()) {
            logger.warning("Validation errors: " + errors);
            request.setAttribute("errors", errors);
            request.setAttribute("promotion", promotion);
            request.setAttribute("isEdit", isEdit);
            String jspPath = isEdit ? "/WEB-INF/view/admin_pages/Promotion/promotion_edit.jsp" : "/WEB-INF/view/admin_pages/Promotion/promotion_add.jsp";
            request.getRequestDispatcher(jspPath).forward(request, response);
            return;
        }

        // Lưu hoặc cập nhật
        boolean success;
        String successMessage;

        try {
            if (isEdit) {
                success = promotionDAO.update(promotion);
                successMessage = "Khuyến mãi đã được cập nhật thành công!";
            } else {
                success = promotionDAO.save(promotion);
                successMessage = "Khuyến mãi đã được tạo thành công!";
                
                // Gửi thông báo cho khách hàng khi tạo promotion mới
                if (success && "ACTIVE".equals(promotion.getStatus())) {
                    try {
                        service.PromotionNotificationService notificationService = new service.PromotionNotificationService();
                        notificationService.notifyNewPromotion(promotion);
                        logger.info("Promotion notification sent to customers for new promotion: " + promotion.getPromotionCode());
                    } catch (Exception e) {
                        logger.log(Level.WARNING, "Failed to send promotion notifications", e);
                        // Không block việc tạo promotion nếu gửi thông báo thất bại
                    }
                    // --- BẮT ĐẦU: Thêm promotion vào kho khuyến mãi của khách hàng ---
                    try {
                        dao.CustomerDAO customerDAO = new dao.CustomerDAO();
                        dao.PromotionUsageDAO promotionUsageDAO = new dao.PromotionUsageDAO();
                        int totalCustomers = customerDAO.getTotalCustomers();
                        int pageSize = 100; // batch size
                        for (int page = 1; page <= (int)Math.ceil((double)totalCustomers/pageSize); page++) {
                            java.util.List<model.Customer> customers = customerDAO.findAll(page, pageSize);
                            for (model.Customer customer : customers) {
                                // Chỉ thêm nếu chưa có usage cho promotion này
                                if (!promotionUsageDAO.hasCustomerUsedPromotion(promotion.getPromotionId(), customer.getCustomerId())) {
                                    model.PromotionUsage usage = new model.PromotionUsage();
                                    usage.setPromotionId(promotion.getPromotionId());
                                    usage.setCustomerId(customer.getCustomerId());
                                    usage.setDiscountAmount(java.math.BigDecimal.ZERO);
                                    usage.setOriginalAmount(java.math.BigDecimal.ZERO);
                                    usage.setFinalAmount(java.math.BigDecimal.ZERO);
                                    usage.setUsedAt(null); // Chưa dùng
                                    usage.setPaymentId(null);
                                    usage.setBookingId(null);
                                    promotionUsageDAO.save(usage);
                                }
                            }
                        }
                        logger.info("Added new promotion to all customers' promotion store");
                    } catch (Exception e) {
                        logger.log(Level.WARNING, "Failed to add new promotion to all customers' store", e);
                        // Không block việc tạo promotion nếu thêm vào kho thất bại
                    }
                    // --- KẾT THÚC ---
                }
            }

            if (success) {
                logger.info("Promotion " + (isEdit ? "updated" : "created") + " successfully with ID: " + promotion.getPromotionId());
                request.getSession().setAttribute("successMessage", successMessage);
                response.sendRedirect(request.getContextPath() + "/promotion/list");
                return;
            } else {
                logger.severe("Failed to " + (isEdit ? "update" : "save") + " promotion to database");
                errors.put("general", new ArrayList<>(List.of("Không thể lưu khuyến mãi vào cơ sở dữ liệu. Vui lòng thử lại.")));
                request.setAttribute("errors", errors);
                request.setAttribute("promotion", promotion);
                request.setAttribute("isEdit", isEdit);
                String jspPath = isEdit ? "/WEB-INF/view/admin_pages/Promotion/promotion_edit.jsp" : "/WEB-INF/view/admin_pages/Promotion/promotion_add.jsp";
                request.getRequestDispatcher(jspPath).forward(request, response);
                return;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error saving promotion", e);
            errors.put("general", new ArrayList<>(List.of("Lỗi hệ thống: " + e.getMessage())));
            request.setAttribute("errors", errors);
            request.setAttribute("promotion", promotion);
            request.setAttribute("isEdit", isEdit);
            String jspPath = isEdit ? "/WEB-INF/view/admin_pages/Promotion/promotion_edit.jsp" : "/WEB-INF/view/admin_pages/Promotion/promotion_add.jsp";
            request.getRequestDispatcher(jspPath).forward(request, response);
            return;
        }
    }

    private Map<String, List<String>> mapAndValidateRequestToPromotion(HttpServletRequest request, Promotion promotion, boolean isEdit) {
        Map<String, List<String>> errors = new HashMap<>();
        
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
        List<String> titleErrors = new ArrayList<>();
        if (title == null || title.trim().length() < 3) {
            titleErrors.add("Tên khuyến mãi phải có ít nhất 3 ký tự");
        }
        if (title != null && title.trim().length() > 255) {
            titleErrors.add("Tên khuyến mãi không được vượt quá 255 ký tự");
        }
        if (title != null && title.trim().length() >= 3 && title.trim().length() <= 255) {
            Optional<Promotion> existingByTitle = promotionDAO.findByTitleIgnoreCase(title.trim());
            if (existingByTitle.isPresent() && (!isEdit || existingByTitle.get().getPromotionId() != promotion.getPromotionId())) {
                titleErrors.add("Tên khuyến mãi đã tồn tại (không phân biệt chữ hoa/thường)");
            } else {
                promotion.setTitle(title.trim());
            }
        }
        if (!titleErrors.isEmpty()) errors.put("title", titleErrors);
        // Promotion Code
        List<String> codeErrors = new ArrayList<>();
        if (promotionCode == null || promotionCode.trim().isEmpty()) {
            codeErrors.add("Mã khuyến mãi không được để trống");
        } else {
            String code = promotionCode.trim();
            
            // Kiểm tra ký tự tiếng Việt
            if (code.matches(".*[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ].*")) {
                codeErrors.add("Mã khuyến mãi không được chứa ký tự tiếng Việt");
            } else if (!code.matches("^[A-Z0-9]{3,10}$")) {
                codeErrors.add("Mã khuyến mãi phải từ 3-10 ký tự, chỉ chứa chữ hoa và số.");
            } else {
                // Kiểm tra trùng lặp (không phân biệt chữ hoa/thường), bỏ qua chính nó khi đang edit
                Optional<Promotion> existing = promotionDAO.findByCodeIgnoreCase(code);
                if (existing.isPresent() && (!isEdit || existing.get().getPromotionId() != promotion.getPromotionId())) {
                    codeErrors.add("Mã khuyến mãi đã tồn tại (không phân biệt chữ hoa/thường)");
                } else {
                    promotion.setPromotionCode(code.toUpperCase());
                }
            }
        }
        if (!codeErrors.isEmpty()) errors.put("promotionCode", codeErrors);
        // Discount Type
        List<String> typeErrors = new ArrayList<>();
        if (discountType == null || discountType.trim().isEmpty()) {
            typeErrors.add("Vui lòng chọn loại giảm giá");
        } else {
            promotion.setDiscountType(discountType);
        }
        if (!typeErrors.isEmpty()) errors.put("discountType", typeErrors);
        // Discount Value
        List<String> valueErrors = new ArrayList<>();
        if (discountValueStr == null || discountValueStr.trim().isEmpty()) {
            valueErrors.add("Vui lòng nhập giá trị giảm giá");
        } else {
            try {
                BigDecimal discountValue = new BigDecimal(discountValueStr);
                if (discountValue.compareTo(BigDecimal.ZERO) <= 0) {
                    valueErrors.add("Giá trị giảm giá phải lớn hơn 0");
                } else if ("PERCENTAGE".equalsIgnoreCase(discountType) && discountValue.compareTo(new BigDecimal("100")) > 0) {
                    valueErrors.add("Giảm giá theo % không được vượt quá 100");
                } else {
                    promotion.setDiscountValue(discountValue);
                }
            } catch (NumberFormatException e) {
                valueErrors.add("Giá trị giảm giá không hợp lệ");
            }
        }
        if (!valueErrors.isEmpty()) errors.put("discountValue", valueErrors);
        // Description
        List<String> descErrors = new ArrayList<>();
        if (description == null || description.trim().isEmpty()) {
            descErrors.add("Vui lòng nhập mô tả");
        } else if (description.trim().length() > 1000) {
            descErrors.add("Mô tả không được vượt quá 1000 ký tự");
        } else {
            promotion.setDescription(description);
        }
        if (!descErrors.isEmpty()) errors.put("description", descErrors);
        // Dates
        List<String> startDateErrors = new ArrayList<>();
        List<String> endDateErrors = new ArrayList<>();
        LocalDateTime startDate = null, endDate = null;
        if (startDateStr == null || startDateStr.trim().isEmpty()) {
            startDateErrors.add("Vui lòng chọn ngày bắt đầu");
        } else {
            try { 
                startDate = LocalDate.parse(startDateStr).atStartOfDay(); 
                promotion.setStartDate(startDate); 
            } catch (Exception e) { 
                startDateErrors.add("Định dạng ngày bắt đầu không hợp lệ"); 
            }
        }
        if (endDateStr == null || endDateStr.trim().isEmpty()) {
            endDateErrors.add("Vui lòng chọn ngày kết thúc");
        } else {
            try { 
                endDate = LocalDate.parse(endDateStr).atTime(23, 59, 59); 
                promotion.setEndDate(endDate); 
            } catch (Exception e) { 
                endDateErrors.add("Định dạng ngày kết thúc không hợp lệ"); 
            }
        }
        if (startDate != null && endDate != null && !endDate.isAfter(startDate)) {
            endDateErrors.add("Ngày kết thúc phải sau ngày bắt đầu");
        }
        if (!startDateErrors.isEmpty()) errors.put("startDate", startDateErrors);
        if (!endDateErrors.isEmpty()) errors.put("endDate", endDateErrors);
        
        promotion.setStatus(status);
        
        // Validate customer condition
        // Luôn set customerCondition = 'ALL' để mọi khách hàng đều áp dụng được
        promotion.setCustomerCondition("ALL");
        
        // Các giá trị mặc định cho các trường mới
        if (!isEdit) {
            promotion.setCurrentUsageCount(0);
            promotion.setIsAutoApply(false);
            promotion.setMinimumAppointmentValue(BigDecimal.ZERO);
            promotion.setApplicableScope("ENTIRE_APPOINTMENT");
        }
        
        logger.info("Validation completed. Errors: " + errors.size());
        return errors;
    }

    private String handleImageUpload(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("imageUrl");
        if (filePart == null || filePart.getSize() == 0) {
            return null; // Không có file mới được upload
        }
    
        // Validate file
        if (!ImageUploadValidator.isValidImage(filePart)) {
            throw new IOException(ImageUploadValidator.getErrorMessage(filePart));
        }

        // Get file name and create unique name
        String fileName = getSubmittedFileName(filePart);
        if (fileName == null || fileName.trim().isEmpty()) {
            throw new IOException("Tên file không hợp lệ");
        }
        
        String fileExtension = "";
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex > 0) {
            fileExtension = fileName.substring(lastDotIndex);
        }
        
        String uniqueFileName = System.currentTimeMillis() + "_promotion" + fileExtension;
        
        // Create upload directory
        String uploadPath = getServletContext().getRealPath(UPLOAD_DIR);
        if (uploadPath == null) {
            // Fallback to a default path if getRealPath returns null
            uploadPath = System.getProperty("user.home") + "/spa-uploads/promotions/";
        }
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            if (!created) {
                throw new IOException("Không thể tạo thư mục upload: " + uploadPath);
            }
        }

        // Save file
        File targetFile = new File(uploadDir, uniqueFileName);
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
        }
        
        // Return the URL path
        return UPLOAD_DIR + uniqueFileName;
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