package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

import dao.PromotionDAO;
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
            
            // Lấy thông tin khuyến mãi của khách hàng
            dao.PromotionUsageDAO promotionUsageDAO = new dao.PromotionUsageDAO();
            java.util.Map<String, Object> promotionSummary = promotionUsageDAO.getCustomerPromotionSummary(customerId);
            java.util.List<java.util.Map<String, Object>> customerPromotions = promotionUsageDAO.getCustomerPromotionsWithRemainingCount(customerId);
            
            request.setAttribute("promotionSummary", promotionSummary);
            request.setAttribute("customerPromotions", customerPromotions);
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
            // Lấy tất cả promotion đang ACTIVE
            List<Promotion> allPromotions = promotionDAO.findByStatus("ACTIVE", 1, 100, "start_date", "DESC");
            
            // Lọc những promotion còn hiệu lực
            LocalDateTime now = LocalDateTime.now();
            List<Promotion> availablePromotions = allPromotions.stream()
                .filter(p -> p.getStartDate() != null && p.getEndDate() != null)
                .filter(p -> p.getStartDate().isBefore(now) && p.getEndDate().isAfter(now))
                .collect(Collectors.toList());

            request.setAttribute("availablePromotions", availablePromotions);

            // Thông báo nếu có
            if (availablePromotions.isEmpty()) {
                request.setAttribute("message", "Hiện tại không có khuyến mãi nào đang áp dụng. Hãy quay lại sau nhé!");
            }

            request.getRequestDispatcher("/WEB-INF/view/customer_pages/available_promotions.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading available promotions", e);
            handleError(request, response, "Không thể tải danh sách khuyến mãi");
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

            // Bước 1: Validate input
            if (promotionCode == null || promotionCode.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng nhập mã khuyến mãi");
                handleShowApplyForm(request, response);
                return;
            }

            promotionCode = promotionCode.trim().toUpperCase();

            // Bước 2: Tìm promotion theo code
            Optional<Promotion> promotionOpt = promotionDAO.findByCode(promotionCode);
            if (!promotionOpt.isPresent()) {
                request.setAttribute("errorMessage", "Mã khuyến mãi không tồn tại hoặc đã hết hạn");
                handleShowApplyForm(request, response);
                return;
            }

            Promotion promotion = promotionOpt.get();

            // Bước 3: Validate promotion (sử dụng PromotionService)
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
                    request.setAttribute("errorMessage", "Giá trị đơn hàng không hợp lệ");
                    handleShowApplyForm(request, response);
                    return;
                }
            }

            // Sử dụng PromotionService để validate và tính toán
            PromotionService.PromotionApplicationResult result = promotionService.previewPromotion(promotionCode, customerId, totalAmount);
            if (!result.isSuccess()) {
                request.setAttribute("errorMessage", result.getMessage());
                handleShowApplyForm(request, response);
                return;
            }

            // Bước 4: Lấy kết quả từ PromotionService
            BigDecimal discountAmount = result.getDiscountAmount();
            BigDecimal finalAmount = result.getFinalAmount();

            // Bước 5: Lưu thông tin vào session
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
} 
 