package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.PromotionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Promotion;

/**
 * Controller để xử lý khuyến mãi cho khách hàng
 * Cho phép khách hàng xem và áp dụng mã khuyến mãi
 */
@WebServlet(urlPatterns = {"/promotions/*", "/apply-promotion", "/remove-promotion"})
public class CustomerPromotionController extends HttpServlet {

    private PromotionDAO promotionDAO;
    private static final Logger logger = Logger.getLogger(CustomerPromotionController.class.getName());

    @Override
    public void init() throws ServletException {
        promotionDAO = new PromotionDAO();
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
                case "apply":
                    handleShowApplyForm(request, response);
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
     * Xử lý áp dụng mã khuyến mãi
     */
    private void handleApplyPromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String promotionCode = request.getParameter("promotionCode");
            String totalAmountStr = request.getParameter("totalAmount");

            // Validate input
            if (promotionCode == null || promotionCode.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng nhập mã khuyến mãi");
                handleShowApplyForm(request, response);
                return;
            }

            promotionCode = promotionCode.trim().toUpperCase();

            // Tìm promotion theo code
            Optional<Promotion> promotionOpt = promotionDAO.findByCode(promotionCode);
            if (!promotionOpt.isPresent()) {
                request.setAttribute("errorMessage", "Mã khuyến mãi không tồn tại hoặc đã hết hạn");
                handleShowApplyForm(request, response);
                return;
            }

            Promotion promotion = promotionOpt.get();

            // Kiểm tra điều kiện áp dụng
            String validationError = validatePromotionUsage(promotion, totalAmountStr);
            if (validationError != null) {
                request.setAttribute("errorMessage", validationError);
                handleShowApplyForm(request, response);
                return;
            }

            // Lưu promotion vào session
            HttpSession session = request.getSession();
            session.setAttribute("appliedPromotion", promotion);
            
            // Tính toán và lưu số tiền giảm
            calculateDiscountAmount(request, promotion);

            request.setAttribute("successMessage", "Áp dụng mã khuyến mãi thành công!");
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
     * Validate điều kiện sử dụng promotion
     */
    private String validatePromotionUsage(Promotion promotion, String totalAmountStr) {
        // Kiểm tra trạng thái
        if (!"ACTIVE".equals(promotion.getStatus())) {
            return "Mã khuyến mãi hiện không có hiệu lực";
        }

        // Kiểm tra thời gian
        LocalDateTime now = LocalDateTime.now();
        if (promotion.getStartDate() != null && promotion.getStartDate().isAfter(now)) {
            return "Mã khuyến mãi chưa có hiệu lực";
        }
        if (promotion.getEndDate() != null && promotion.getEndDate().isBefore(now)) {
            return "Mã khuyến mãi đã hết hạn";
        }

        // Kiểm tra giá trị đơn hàng tối thiểu
        if (totalAmountStr != null && !totalAmountStr.isEmpty()) {
            try {
                BigDecimal totalAmount = new BigDecimal(totalAmountStr);
                if (promotion.getMinimumAppointmentValue() != null && 
                    promotion.getMinimumAppointmentValue().compareTo(BigDecimal.ZERO) > 0) {
                    if (totalAmount.compareTo(promotion.getMinimumAppointmentValue()) < 0) {
                        return "Đơn hàng chưa đạt giá trị tối thiểu: " + 
                               promotion.getMinimumAppointmentValue() + "đ";
                    }
                }
            } catch (NumberFormatException e) {
                return "Giá trị đơn hàng không hợp lệ";
            }
        }

        // TODO: Kiểm tra giới hạn sử dụng theo khách hàng
        // TODO: Kiểm tra điều kiện khách hàng (INDIVIDUAL, COUPLE, GROUP)

        return null; // Hợp lệ
    }

    /**
     * Tính toán số tiền giảm giá
     */
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
                BigDecimal discountAmount = BigDecimal.ZERO;

                if ("PERCENTAGE".equals(promotion.getDiscountType())) {
                    // Giảm theo phần trăm
                    discountAmount = totalAmount.multiply(promotion.getDiscountValue())
                                              .divide(new BigDecimal("100"));
                } else if ("FIXED".equals(promotion.getDiscountType())) {
                    // Giảm số tiền cố định
                    discountAmount = promotion.getDiscountValue();
                    
                    // Không được giảm quá tổng tiền
                    if (discountAmount.compareTo(totalAmount) > 0) {
                        discountAmount = totalAmount;
                    }
                }

                BigDecimal finalAmount = totalAmount.subtract(discountAmount);
                if (finalAmount.compareTo(BigDecimal.ZERO) < 0) {
                    finalAmount = BigDecimal.ZERO;
                }

                request.setAttribute("discountAmount", discountAmount);
                request.setAttribute("finalAmount", finalAmount);
                
                // Lưu vào session
                HttpSession session = request.getSession();
                session.setAttribute("discountAmount", discountAmount);
                session.setAttribute("finalAmount", finalAmount);
            }

        } catch (Exception e) {
            logger.log(Level.WARNING, "Error calculating discount amount", e);
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
 