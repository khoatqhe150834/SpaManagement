package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

import com.google.gson.Gson;

import dao.PromotionDAO;
import dao.PromotionUsageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.Promotion;
import service.PromotionService;

/**
 * Controller để xử lý khuyến mãi cho khách hàng
 * Cho phép khách hàng xem và áp dụng mã khuyến mãi
 * Implement quy trình 5 bước áp dụng mã khuyến mãi
 */
@WebServlet(urlPatterns = {"/promotions/*", "/apply-promotion", "/remove-promotion"})
public class CustomerPromotionController extends HttpServlet {

    private PromotionDAO promotionDAO;
    private PromotionService promotionService;
    private static final Logger logger = Logger.getLogger(CustomerPromotionController.class.getName());

    @Override
    public void init() throws ServletException {
        promotionDAO = new PromotionDAO();
        promotionService = new PromotionService();
        logger.info("CustomerPromotionController initialized successfully");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        logger.info("GET request - PathInfo: " + pathInfo);

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                handleListAvailablePromotions(request, response);
                return;
            }

            String[] pathParts = pathInfo.split("/");
            if (pathParts.length < 2) {
                handleListAvailablePromotions(request, response);
                return;
            }

            String action = pathParts[1].toLowerCase();

            switch (action) {
                case "available":
                    handleListAvailablePromotions(request, response);
                    break;
                case "my-promotions":
                    handleMyPromotions(request, response);
                    break;
                case "apply":
                    handleShowApplyForm(request, response);
                    break;
                case "notification":
                    handleShowNotification(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Action not found: " + action);
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in GET request", e);
            handleError(request, response, "Đã xảy ra lỗi: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestURI = request.getRequestURI();
        logger.info("POST request - URI: " + requestURI);

        try {
            if (requestURI.endsWith("/apply-promotion")) {
                handleApplyPromotion(request, response);
            } else if (requestURI.endsWith("/remove-promotion")) {
                handleRemovePromotion(request, response);
            } else if (requestURI.contains("/promotions/use-now")) {
                handleUseNow(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request");
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in POST request", e);
            handleError(request, response, "Đã xảy ra lỗi: " + e.getMessage());
        }
    }

    /**
     * Hiển thị khuyến mãi của khách hàng với thông tin chi tiết
     */
    private void handleMyPromotions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Customer customer = (Customer) session.getAttribute("customer");
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            Integer customerId = customer.getCustomerId();
            if (customerId == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            // Lấy danh sách khuyến mãi với số lượt còn lại
            PromotionUsageDAO promotionUsageDAO = new PromotionUsageDAO();
            java.util.List<java.util.Map<String, Object>> customerPromotions = promotionUsageDAO.getCustomerPromotionsWithRemainingCount(customerId);
            // Lấy lịch sử đã dùng
            java.util.List<model.PromotionUsage> promotionUsageHistory = promotionUsageDAO.getCustomerUsageHistory(customerId, 1, 20);
            request.setAttribute("customerPromotions", customerPromotions);
            request.setAttribute("promotionUsageHistory", promotionUsageHistory);
            request.setAttribute("customerId", customerId);
            request.getRequestDispatcher("/WEB-INF/view/customer_pages/my_promotions.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading customer promotions", e);
            handleError(request, response, "Không thể tải thông tin khuyến mãi của bạn");
        }
    }

    /**
     * Hiển thị danh sách khuyến mãi có sẵn cho khách hàng
     */
    private void handleListAvailablePromotions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Customer customer = (Customer) session.getAttribute("customer");
            Integer customerId = (customer != null) ? customer.getCustomerId() : null;
            List<Promotion> availablePromotions = new ArrayList<>();
            PromotionDAO promotionDAO = new PromotionDAO();
            PromotionUsageDAO promotionUsageDAO = new PromotionUsageDAO();
            LocalDateTime now = LocalDateTime.now();

            if (customerId == null) {
                // Chưa đăng nhập: chỉ lấy các mã ACTIVE, còn hạn
                List<Promotion> allPromotions = promotionDAO.findByStatus("ACTIVE", 1, 1000, "start_date", "DESC");
                for (Promotion p : allPromotions) {
                    if ((p.getStartDate() == null || !now.isBefore(p.getStartDate())) &&
                        (p.getEndDate() == null || !now.isAfter(p.getEndDate()))) {
                        availablePromotions.add(p);
                    }
                }
            } else {
                // Đã đăng nhập: chỉ lấy các mã còn lượt sử dụng, còn hạn
                List<java.util.Map<String, Object>> customerPromotions = promotionUsageDAO.getCustomerPromotionsWithRemainingCount(customerId);
                for (java.util.Map<String, Object> promo : customerPromotions) {
                    // Kiểm tra còn lượt và còn hạn
                    Integer remaining = (promo.get("remainingCount") != null) ? ((Number) promo.get("remainingCount")).intValue() : 0;
                    String status = (String) promo.get("status");
                    java.sql.Timestamp startDate = (java.sql.Timestamp) promo.get("startDate");
                    java.sql.Timestamp endDate = (java.sql.Timestamp) promo.get("endDate");
                    boolean inDate = (startDate == null || !now.isBefore(startDate.toLocalDateTime())) &&
                                     (endDate == null || !now.isAfter(endDate.toLocalDateTime()));
                    if ("ACTIVE".equals(status) && remaining > 0 && inDate) {
                        // Map về Promotion object để truyền sang JSP
                        Promotion p = new Promotion();
                        p.setPromotionId((Integer) promo.get("promotionId"));
                        p.setTitle((String) promo.get("title"));
                        p.setPromotionCode((String) promo.get("promotionCode"));
                        p.setDiscountType((String) promo.get("discountType"));
                        p.setDiscountValue((java.math.BigDecimal) promo.get("discountValue"));
                        p.setUsageLimitPerCustomer((promo.get("usageLimitPerCustomer") != null) ? ((Number) promo.get("usageLimitPerCustomer")).intValue() : 0);
                        p.setStatus(status);
                        p.setStartDate((startDate != null) ? startDate.toLocalDateTime() : null);
                        p.setEndDate((endDate != null) ? endDate.toLocalDateTime() : null);
                        availablePromotions.add(p);
                    }
                }
            }

            request.setAttribute("availablePromotions", availablePromotions);
            request.setAttribute("totalActivePromotions", availablePromotions.size());

            if (availablePromotions.isEmpty()) {
                request.setAttribute("message", "Hiện tại không có khuyến mãi nào phù hợp với bạn. Hãy quay lại sau nhé!");
            }

            request.getRequestDispatcher("/WEB-INF/view/customer_pages/available_promotions.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading available promotions", e);
            handleError(request, response, "Không thể tải danh sách khuyến mãi: " + e.getMessage());
        }
    }

    /**
     * Hiển thị form áp dụng mã khuyến mãi
     */
    private void handleShowApplyForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy thông tin booking từ session (nếu có)
            HttpSession session = request.getSession();
            Object bookingInfo = session.getAttribute("bookingInfo");
            
            if (bookingInfo != null) {
                request.setAttribute("bookingInfo", bookingInfo);
            }

            // Kiểm tra có promotion đã áp dụng không
            Object appliedPromotion = session.getAttribute("appliedPromotion");
            if (appliedPromotion != null) {
                request.setAttribute("appliedPromotion", appliedPromotion);
                
                // Tính toán số tiền giảm và số tiền cuối cùng
                calculateDiscountAmount(request, (Promotion) appliedPromotion);
            }

            // Lấy danh sách mã khuyến mãi còn hiệu lực, còn lượt cho khách hàng
            Customer customer = (Customer) session.getAttribute("customer");
            Integer customerId = (customer != null) ? customer.getCustomerId() : null;
            List<Promotion> availablePromotions = new ArrayList<>();
            if (customerId != null) {
                PromotionUsageDAO promotionUsageDAO = new PromotionUsageDAO();
                LocalDateTime now = LocalDateTime.now();
                List<java.util.Map<String, Object>> customerPromotions = promotionUsageDAO.getCustomerPromotionsWithRemainingCount(customerId);
                for (java.util.Map<String, Object> promo : customerPromotions) {
                    Integer remaining = (promo.get("remainingCount") != null) ? ((Number) promo.get("remainingCount")).intValue() : 0;
                    String status = (String) promo.get("status");
                    java.sql.Timestamp startDate = (java.sql.Timestamp) promo.get("startDate");
                    java.sql.Timestamp endDate = (java.sql.Timestamp) promo.get("endDate");
                    boolean inDate = (startDate == null || !now.isBefore(startDate.toLocalDateTime())) &&
                                     (endDate == null || !now.isAfter(endDate.toLocalDateTime()));
                    if ("ACTIVE".equals(status) && remaining > 0 && inDate) {
                        Promotion p = new Promotion();
                        p.setPromotionId((Integer) promo.get("promotionId"));
                        p.setTitle((String) promo.get("title"));
                        p.setPromotionCode((String) promo.get("promotionCode"));
                        p.setDiscountType((String) promo.get("discountType"));
                        p.setDiscountValue((java.math.BigDecimal) promo.get("discountValue"));
                        p.setUsageLimitPerCustomer((promo.get("usageLimitPerCustomer") != null) ? ((Number) promo.get("usageLimitPerCustomer")).intValue() : 0);
                        p.setStatus(status);
                        p.setStartDate((startDate != null) ? startDate.toLocalDateTime() : null);
                        p.setEndDate((endDate != null) ? endDate.toLocalDateTime() : null);
                        availablePromotions.add(p);
                    }
                }
            }
            request.setAttribute("availablePromotions", availablePromotions);

            request.getRequestDispatcher("/WEB-INF/view/customer_pages/apply_promotion.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing apply form", e);
            handleError(request, response, "Không thể hiển thị form áp dụng mã");
        }
    }

    /**
     * Xử lý áp dụng mã khuyến mãi - Quy trình 5 bước
     */
    private void handleApplyPromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String promotionCode = request.getParameter("promotionCode");
            String totalAmountStr = request.getParameter("totalAmount");
            String customerIdStr = request.getParameter("customerId");
            String serviceIdsStr = request.getParameter("serviceIds");

            // Bước 1: Validate input
            if (promotionCode == null || promotionCode.trim().isEmpty()) {
                if (isAjaxRequest(request)) {
                    sendJsonResponse(response, false, 0, 0, "Vui lòng nhập mã khuyến mãi");
                    return;
                }
                request.setAttribute("errorMessage", "Vui lòng nhập mã khuyến mãi");
                handleShowApplyForm(request, response);
                return;
            }

            promotionCode = promotionCode.trim().toUpperCase();

            // Bước 2: Tìm promotion theo code
            Optional<Promotion> promotionOpt = promotionDAO.findByCode(promotionCode);
            if (!promotionOpt.isPresent()) {
                if (isAjaxRequest(request)) {
                    sendJsonResponse(response, false, 0, 0, "Mã khuyến mãi không tồn tại hoặc đã hết hạn");
                    return;
                }
                request.setAttribute("errorMessage", "Mã khuyến mãi không tồn tại hoặc đã hết hạn");
                handleShowApplyForm(request, response);
                return;
            }

            Promotion promotion = promotionOpt.get();

            // Bước 3: Parse serviceIds
            List<Integer> selectedServiceIds = null;
            if (serviceIdsStr != null && !serviceIdsStr.trim().isEmpty()) {
                try {
                    selectedServiceIds = Arrays.stream(serviceIdsStr.split(","))
                        .map(String::trim)
                        .map(Integer::parseInt)
                        .collect(Collectors.toList());
                } catch (NumberFormatException e) {
                    logger.warning("Invalid serviceIds format: " + serviceIdsStr);
                }
            }

            // Bước 4: Validate promotion (sử dụng PromotionService)
            Integer customerId = null;
            if (customerIdStr != null && !customerIdStr.isEmpty()) {
                try {
                    customerId = Integer.parseInt(customerIdStr);
                } catch (NumberFormatException e) {
                    logger.warning("Invalid customer ID: " + customerIdStr);
                }
            }

            BigDecimal totalAmount = BigDecimal.ZERO;
            if (totalAmountStr != null && !totalAmountStr.isEmpty()) {
                try {
                    totalAmount = new BigDecimal(totalAmountStr);
                } catch (NumberFormatException e) {
                    if (isAjaxRequest(request)) {
                        sendJsonResponse(response, false, 0, 0, "Giá trị đơn hàng không hợp lệ");
                        return;
                    }
                    request.setAttribute("errorMessage", "Giá trị đơn hàng không hợp lệ");
                    handleShowApplyForm(request, response);
                    return;
                }
            }

            // Sử dụng PromotionService để validate và tính toán với selectedServiceIds
            PromotionService.PromotionApplicationResult result = promotionService.previewPromotionWithServices(promotionCode, customerId, totalAmount, selectedServiceIds);
            if (!result.isSuccess()) {
                if (isAjaxRequest(request)) {
                    sendJsonResponse(response, false, 0, 0, result.getMessage());
                    return;
                }
                request.setAttribute("errorMessage", result.getMessage());
                handleShowApplyForm(request, response);
                return;
            }

            // Bước 5: Lấy kết quả từ PromotionService
            BigDecimal discountAmount = result.getDiscountAmount();
            BigDecimal finalAmount = result.getFinalAmount();

            // Nếu là AJAX, trả về JSON
            if (isAjaxRequest(request)) {
                sendJsonResponse(response, true, discountAmount, finalAmount, "Áp dụng mã giảm giá thành công!");
                return;
            }

            // Bước 6: Lưu thông tin vào session
            HttpSession session = request.getSession();
            session.setAttribute("appliedPromotion", promotion);
            session.setAttribute("discountAmount", discountAmount);
            session.setAttribute("finalAmount", finalAmount);
            session.setAttribute("originalAmount", totalAmount);

            // Ghi nhận sử dụng promotion (nếu có customerId)
            if (customerId != null) {
                try {
                    // Sử dụng PromotionService để ghi nhận sử dụng
                    PromotionService.PromotionApplicationResult applyResult = 
                        promotionService.applyPromotionCode(promotionCode, customerId, totalAmount, null, null);
                    if (applyResult.isSuccess()) {
                        logger.info("Recorded promotion usage - Promotion Code: " + promotionCode + ", Customer ID: " + customerId);
                    } else {
                        logger.warning("Failed to record promotion usage: " + applyResult.getMessage());
                    }
                } catch (Exception e) {
                    logger.log(Level.WARNING, "Failed to record promotion usage", e);
                    // Không block việc áp dụng promotion nếu ghi nhận thất bại
                }
            }

            request.setAttribute("successMessage", "Áp dụng mã khuyến mãi thành công! Giảm giá: " + 
                               discountAmount + "đ");
            request.setAttribute("discountAmount", discountAmount);
            request.setAttribute("finalAmount", finalAmount);
            
            handleShowApplyForm(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error applying promotion", e);
            if (isAjaxRequest(request)) {
                sendJsonResponse(response, false, 0, 0, "Không thể áp dụng mã khuyến mãi: " + e.getMessage());
                return;
            }
            request.setAttribute("errorMessage", "Không thể áp dụng mã khuyến mãi: " + e.getMessage());
            handleShowApplyForm(request, response);
        }
    }

    /**
     * Xử lý bỏ mã khuyến mãi
     */
    private void handleRemovePromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            session.removeAttribute("appliedPromotion");
            session.removeAttribute("discountAmount");
            session.removeAttribute("finalAmount");

            request.setAttribute("successMessage", "Đã bỏ mã khuyến mãi");
            handleShowApplyForm(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error removing promotion", e);
            request.setAttribute("errorMessage", "Không thể bỏ mã khuyến mãi");
            handleShowApplyForm(request, response);
        }
    }

    /**
     * Xử lý nút "Dùng ngay" - lưu mã khuyến mãi vào session và chuyển sang trang dịch vụ
     */
    private void handleUseNow(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String promotionCode = request.getParameter("promotionCode");
            logger.info("Use Now request - Promotion Code: " + promotionCode);
            
            if (promotionCode != null && !promotionCode.isEmpty()) {
                HttpSession session = request.getSession();
                session.setAttribute("pendingPromotionCode", promotionCode);
                logger.info("Saved promotion code to session: " + promotionCode);
            }
            
            // Redirect sang trang chọn dịch vụ
            response.sendRedirect(request.getContextPath() + "/services");
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in handleUseNow", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể xử lý yêu cầu");
        }
    }

    /**
     * Validate điều kiện sử dụng promotion - Đã được thay thế bằng PromotionService
     * @deprecated Sử dụng PromotionService.previewPromotion() thay thế
     */
    @Deprecated
    private String validatePromotionUsage(Promotion promotion, String totalAmountStr) {
        // Chuyển sang sử dụng PromotionService
        try {
            BigDecimal totalAmount = BigDecimal.ZERO;
            if (totalAmountStr != null && !totalAmountStr.isEmpty()) {
                totalAmount = new BigDecimal(totalAmountStr);
            }
            PromotionService.PromotionApplicationResult result = promotionService.previewPromotion(promotion.getPromotionCode(), null, totalAmount);
            return result.isSuccess() ? null : result.getMessage();
        } catch (Exception e) {
            return "Lỗi validate promotion: " + e.getMessage();
        }
    }

    /**
     * Tính toán số tiền giảm giá - Đã được thay thế bằng PromotionService
     * @deprecated Sử dụng PromotionService.previewPromotion() thay thế
     */
    @Deprecated
    private void calculateDiscountAmount(HttpServletRequest request, Promotion promotion) {
        try {
            String totalAmountStr = request.getParameter("totalAmount");
            if (totalAmountStr == null || totalAmountStr.isEmpty()) {
                // Lấy từ booking info trong session
                Object bookingInfo = request.getSession().getAttribute("bookingInfo");
                if (bookingInfo != null) {
                    // TODO: Extract total amount from booking info
                    totalAmountStr = "1000000"; // Placeholder
                }
            }

            if (totalAmountStr != null && !totalAmountStr.isEmpty()) {
                BigDecimal totalAmount = new BigDecimal(totalAmountStr);
                
                // Sử dụng PromotionService để tính toán
                PromotionService.PromotionApplicationResult result = promotionService.previewPromotion(promotion.getPromotionCode(), null, totalAmount);
                if (result.isSuccess()) {
                    BigDecimal discountAmount = result.getDiscountAmount();
                    BigDecimal finalAmount = result.getFinalAmount();

                    request.setAttribute("discountAmount", discountAmount);
                    request.setAttribute("finalAmount", finalAmount);
                    
                    // Lưu vào session
                    HttpSession session = request.getSession();
                    session.setAttribute("discountAmount", discountAmount);
                    session.setAttribute("finalAmount", finalAmount);
                }
            }

        } catch (Exception e) {
            logger.log(Level.WARNING, "Error calculating discount amount", e);
        }
    }

    /**
     * Hiển thị trang thông báo promotion cho khách hàng
     */
    private void handleShowNotification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy customer ID từ session
            HttpSession session = request.getSession();
            Customer customer = (Customer) session.getAttribute("customer");
            
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // Lấy customer ID
            Integer customerId = customer.getCustomerId();
            
            if (customerId == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // Lấy promotions mới cho khách hàng này (tạm thời lấy tất cả ACTIVE)
            List<Promotion> newPromotions = promotionDAO.findByStatus("ACTIVE", 1, 10, "created_at", "DESC");
            
            request.setAttribute("newPromotions", newPromotions);
            request.setAttribute("customerId", customerId);
            
            request.getRequestDispatcher("/WEB-INF/view/customer_pages/promotion_notification.jsp")
                    .forward(request, response);
                    
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading promotion notification", e);
            handleError(request, response, "Không thể tải thông báo khuyến mãi");
        }
    }

    /**
     * Xử lý lỗi chung
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/WEB-INF/view/customer_pages/available_promotions.jsp")
                .forward(request, response);
    }

    private boolean isAjaxRequest(HttpServletRequest request) {
        String requestedWith = request.getHeader("X-Requested-With");
        return requestedWith != null && requestedWith.equalsIgnoreCase("XMLHttpRequest");
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, Number discountAmount, Number finalAmount, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Gson gson = new Gson();
        String json = gson.toJson(new java.util.HashMap<String, Object>() {{
            put("success", success);
            put("discountAmount", discountAmount);
            put("finalAmount", finalAmount);
            put("message", message);
        }});
        response.getWriter().write(json);
    }
} 
 