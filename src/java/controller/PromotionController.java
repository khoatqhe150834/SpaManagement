package controller;

import dao.PromotionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Promotion;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Complete PromotionController with proper error handling and validation
 * URL Pattern: /promotion/*
 * Actions: list, view, create, edit, delete, search
 */
@WebServlet(urlPatterns = {"/promotion/*"})
public class PromotionController extends HttpServlet {
    
    private PromotionDAO promotionDAO;
    private static final Logger logger = Logger.getLogger(PromotionController.class.getName());
    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    public void init() throws ServletException {
        promotionDAO = new PromotionDAO();
        logger.info("PromotionController initialized successfully");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        logger.info("PromotionController GET request - PathInfo: " + pathInfo);
        
        try {
            // Handle root path or null path - show promotion list
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
                handleListPromotions(request, response);
                return;
            }
            
            // Parse path to get action and parameters
            String[] pathParts = pathInfo.split("/");
            if (pathParts.length < 2) {
                handleListPromotions(request, response);
                return;
            }
            
            String action = pathParts[1].toLowerCase();
            
            switch (action) {
                case "list":
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
                case "delete":
                    handleDeletePromotion(request, response);
                    break;
                case "search":
                    handleListPromotions(request, response);
                    break;
                default:
                    logger.warning("Unknown action: " + action);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Unknown action: " + action);
                    break;
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in PromotionController GET", e);
            handleError(request, response, "An error occurred: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        logger.info("PromotionController POST request - Action: " + action);
        
        try {
            if (action == null || action.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter");
                return;
            }
            
            switch (action.toLowerCase()) {
                case "create":
                    handleCreatePromotion(request, response);
                    break;
                case "update":
                    handleUpdatePromotion(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
                    break;
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in PromotionController POST", e);
            handleError(request, response, "An error occurred: " + e.getMessage());
        }
    }

    /**
     * Handle list promotions with pagination and filtering
     */
    private void handleListPromotions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get pagination parameters
            int page = getIntParameter(request, "page", 1);
            int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);
            String status = request.getParameter("status");
            
            // Get sorting parameters
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");
            
            // Get search parameters
            String searchType = request.getParameter("searchType");
            String searchValue = request.getParameter("searchValue");
            
            // Validate pagination parameters
            if (page < 1) page = 1;
            if (pageSize < 1) pageSize = DEFAULT_PAGE_SIZE;
            if (pageSize > 999999) pageSize = 999999; // Allow "all" option
            
            List<Promotion> promotions;
            int totalPromotions;
            
            // Handle search first
            if (searchValue != null && !searchValue.trim().isEmpty()) {
                // Use existing search method
                promotions = promotionDAO.searchPromotions(searchValue.trim(), 1, Integer.MAX_VALUE, "created_at", "desc");
                totalPromotions = promotions.size();
            } else {
                // Load all promotions
                promotions = promotionDAO.findAll();
                totalPromotions = promotions.size();
            }
            
            // Apply status filter if provided
            if (status != null && !status.trim().isEmpty()) {
                promotions = promotions.stream()
                        .filter(p -> status.equalsIgnoreCase(p.getStatus()))
                        .collect(java.util.stream.Collectors.toList());
                totalPromotions = promotions.size();
            }
            
            // Apply sorting
            if (sortBy != null && sortOrder != null) {
                switch (sortBy) {
                    case "id":
                        if ("asc".equals(sortOrder)) {
                            promotions.sort(java.util.Comparator.comparing(Promotion::getPromotionId));
                        } else {
                            promotions.sort(java.util.Comparator.comparing(Promotion::getPromotionId).reversed());
                        }
                        break;
                    case "title":
                        if ("asc".equals(sortOrder)) {
                            promotions.sort(java.util.Comparator.comparing(Promotion::getTitle));
                        } else {
                            promotions.sort(java.util.Comparator.comparing(Promotion::getTitle).reversed());
                        }
                        break;
                    case "code":
                        if ("asc".equals(sortOrder)) {
                            promotions.sort(java.util.Comparator.comparing(Promotion::getPromotionCode));
                        } else {
                            promotions.sort(java.util.Comparator.comparing(Promotion::getPromotionCode).reversed());
                        }
                        break;
                }
            }
            
            // Apply pagination to results
            int totalPages = (int) Math.ceil((double) totalPromotions / pageSize);
            if (totalPages < 1) totalPages = 1;
            if (page > totalPages) page = totalPages;
            
            int startIndex = (page - 1) * pageSize;
            int endIndex = Math.min(startIndex + pageSize, promotions.size());
            if (startIndex < promotions.size()) {
                promotions = promotions.subList(startIndex, endIndex);
            } else {
                promotions = new java.util.ArrayList<>();
            }
            
            // Set request attributes
            request.setAttribute("listPromotion", promotions);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalPromotions", totalPromotions);
            request.setAttribute("status", status);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("searchType", searchType);
            request.setAttribute("searchValue", searchValue);
            
            logger.info(String.format("Promotion list loaded - Page: %d, Size: %d, Total: %d, Found: %d",
                    page, pageSize, totalPromotions, promotions.size()));
            
            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/promotion_list.jsp")
                    .forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading promotion list", e);
            handleError(request, response, "Error loading promotion list: " + e.getMessage());
        }
    }

    /**
     * Handle view single promotion
     */
    private void handleViewPromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int promotionId = getIntParameter(request, "id", 0);
            if (promotionId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid promotion ID");
                return;
            }
            
            Optional<Promotion> promotionOpt = promotionDAO.findById(promotionId);
            if (promotionOpt.isPresent()) {
                request.setAttribute("promotion", promotionOpt.get());
                request.getRequestDispatcher("/WEB-INF/view/promotion/view.jsp")
                        .forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Promotion not found");
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error viewing promotion", e);
            handleError(request, response, "Error viewing promotion: " + e.getMessage());
        }
    }

    /**
     * Handle show create form
     */
    private void handleShowCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/WEB-INF/view/promotion/form.jsp")
                .forward(request, response);
    }

    /**
     * Handle show edit form
     */
    private void handleShowEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int promotionId = getIntParameter(request, "id", 0);
            if (promotionId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid promotion ID");
                return;
            }
            
            Optional<Promotion> promotionOpt = promotionDAO.findById(promotionId);
            if (promotionOpt.isPresent()) {
                request.setAttribute("promotion", promotionOpt.get());
                request.getRequestDispatcher("/WEB-INF/view/promotion/form.jsp")
                        .forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Promotion not found");
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing edit form", e);
            handleError(request, response, "Error loading promotion for edit: " + e.getMessage());
        }
    }

    /**
     * Handle create promotion
     */
    private void handleCreatePromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Validate required fields
            String title = getStringParameter(request, "title");
            String promotionCode = getStringParameter(request, "promotionCode");
            String discountType = getStringParameter(request, "discountType");
            String discountValueStr = getStringParameter(request, "discountValue");
            
            if (title == null || promotionCode == null || discountType == null || discountValueStr == null) {
                throw new IllegalArgumentException("Title, promotion code, discount type, and discount value are required");
            }
            
            // Create promotion object
            Promotion promotion = new Promotion();
            promotion.setTitle(title);
            promotion.setPromotionCode(promotionCode.toUpperCase());
            promotion.setDiscountType(discountType);
            promotion.setDiscountValue(new BigDecimal(discountValueStr));
            promotion.setDescription(request.getParameter("description"));
            promotion.setStatus(request.getParameter("status") != null ? request.getParameter("status") : "active");
            promotion.setStartDate(LocalDateTime.now());
            promotion.setEndDate(LocalDateTime.now().plusMonths(1));
            promotion.setCurrentUsageCount(0);
            promotion.setIsAutoApply(false);
            
            // Save promotion
            promotionDAO.save(promotion);
            
            logger.info("Promotion created successfully: " + promotion.getPromotionId());
            
            // Return success response for AJAX
            response.setStatus(200);
            response.getWriter().write("Promotion created successfully");
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error creating promotion", e);
            request.setAttribute("error", "Error creating promotion: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/promotion/form.jsp")
                    .forward(request, response);
        }
    }

    /**
     * Handle update promotion
     */
    private void handleUpdatePromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get promotion ID
            int promotionId = getIntParameter(request, "id", 0);
            if (promotionId <= 0) {
                throw new IllegalArgumentException("Invalid promotion ID");
            }
            
            // Check if promotion exists
            Optional<Promotion> promotionOpt = promotionDAO.findById(promotionId);
            if (!promotionOpt.isPresent()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Promotion not found");
                return;
            }
            
            Promotion promotion = promotionOpt.get();
            
            // Validate required fields
            String title = getStringParameter(request, "title");
            String promotionCode = getStringParameter(request, "promotionCode");
            String discountType = getStringParameter(request, "discountType");
            String discountValueStr = getStringParameter(request, "discountValue");
            
            if (title == null || promotionCode == null || discountType == null || discountValueStr == null) {
                throw new IllegalArgumentException("Title, promotion code, discount type, and discount value are required");
            }
            
            // Update promotion fields
            promotion.setTitle(title);
            promotion.setPromotionCode(promotionCode.toUpperCase());
            promotion.setDiscountType(discountType);
            promotion.setDiscountValue(new BigDecimal(discountValueStr));
            promotion.setDescription(request.getParameter("description"));
            promotion.setStatus(request.getParameter("status") != null ? request.getParameter("status") : promotion.getStatus());
            
            // Update promotion
            promotionDAO.update(promotion);
            
            logger.info("Promotion updated successfully: " + promotionId);
            
            // Return success response for AJAX
            response.setStatus(200);
            response.getWriter().write("Promotion updated successfully");
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating promotion", e);
            request.setAttribute("error", "Error updating promotion: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/promotion/form.jsp")
                    .forward(request, response);
        }
    }

    /**
     * Handle delete promotion
     */
    private void handleDeletePromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int promotionId = getIntParameter(request, "id", 0);
            if (promotionId <= 0) {
                response.setStatus(400);
                response.getWriter().write("Invalid promotion ID");
                return;
            }
            
            // Delete promotion
            promotionDAO.deleteById(promotionId);
            logger.info("Promotion deleted successfully: " + promotionId);
            
            // Return success for AJAX
            response.setStatus(200);
            response.getWriter().write("Promotion deleted successfully");
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deleting promotion", e);
            response.setStatus(500);
            response.getWriter().write("Error deleting promotion: " + e.getMessage());
        }
    }

    /**
     * Handle error by forwarding to error page
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        
        request.setAttribute("error", errorMessage);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/promotion_list.jsp")
                .forward(request, response);
    }

    /**
     * Utility method to get integer parameter with default value
     */
    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try {
                return Integer.parseInt(paramValue.trim());
            } catch (NumberFormatException e) {
                logger.warning("Invalid integer parameter " + paramName + ": " + paramValue);
            }
        }
        return defaultValue;
    }

    /**
     * Utility method to get string parameter with trimming and null check
     */
    private String getStringParameter(HttpServletRequest request, String paramName) {
        String paramValue = request.getParameter(paramName);
        return (paramValue != null && !paramValue.trim().isEmpty()) ? paramValue.trim() : null;
    }
} 