package controller;

import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import model.Category;

@WebServlet(urlPatterns = {"/category/*"})
public class CategoryController extends HttpServlet {

    private CategoryDAO categoryDAO;
    private static final Logger logger = Logger.getLogger(CategoryController.class.getName());
    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
                handleListCategories(request, response);
                return;
            }

            String[] pathParts = pathInfo.split("/");
            if (pathParts.length < 2) {
                handleListCategories(request, response);
                return;
            }

            String action = pathParts[1].toLowerCase();
            switch (action) {
                case "view":
                    handleViewCategory(request, response);
                    break;
                case "create":
                    handleShowCreateForm(request, response);
                    break;
                case "edit":
                    handleShowEditForm(request, response);
                    break;
                case "delete":
                    handleDeleteCategory(request, response);
                    break;
                case "deactivate":
                    handleDeactivateCategory(request, response);
                    break;
                case "activate":
                    handleActivateCategory(request, response);
                    break;
                default:
                    handleListCategories(request, response);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in CategoryController doGet", e);
            handleError(request, response, "Error processing request: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "create":
                    handleCreateCategory(request, response);
                    break;
                case "edit":
                    handleUpdateCategory(request, response);
                    break;
                default:
                    handleListCategories(request, response);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in CategoryController doPost", e);
            handleError(request, response, "Error processing request: " + e.getMessage());
        }
    }

    private void handleListCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int page = getIntParameter(request, "page", 1);
            int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);
            String searchValue = request.getParameter("searchValue");
            String status = request.getParameter("status");
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");

            // Validate sort parameters
            if (sortBy != null && !sortBy.matches("^(id|name)$")) {
                sortBy = "id";
            }
            if (sortOrder == null || !sortOrder.matches("^(asc|desc)$")) {
                sortOrder = "asc";
            }

            List<Category> categories;
            int totalCategories;

            if (searchValue != null && !searchValue.trim().isEmpty()) {
                categories = categoryDAO.search(searchValue, status, page, pageSize, sortBy, sortOrder);
                totalCategories = categoryDAO.countSearchResults(searchValue, status);
            } else {
                categories = categoryDAO.findAll(status, page, pageSize, sortBy, sortOrder);
                totalCategories = categoryDAO.countAll(status);
            }

            int totalPages = (int) Math.ceil((double) totalCategories / pageSize);

            request.setAttribute("categories", categories);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("status", status);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("searchValue", searchValue);

            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Category/category_list.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading category list", e);
            handleError(request, response, "Error loading category list: " + e.getMessage());
        }
    }

    private void handleViewCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int categoryId = getIntParameter(request, "id", 0);
            if (categoryId <= 0) {
                throw new IllegalArgumentException("Invalid category ID");
            }

            Optional<Category> categoryOpt = categoryDAO.findById(categoryId);
            if (categoryOpt.isPresent()) {
                request.setAttribute("category", categoryOpt.get());
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/Category/category_details.jsp")
                        .forward(request, response);
            } else {
                handleError(request, response, "Category not found");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error viewing category", e);
            handleError(request, response, "Error viewing category: " + e.getMessage());
        }
    }

    private void handleShowCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("category", new Category());
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Category/category_add.jsp")
                .forward(request, response);
    }

    private void handleShowEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int categoryId = getIntParameter(request, "id", 0);
            if (categoryId <= 0) {
                throw new IllegalArgumentException("Invalid category ID");
            }

            Optional<Category> categoryOpt = categoryDAO.findById(categoryId);
            if (categoryOpt.isPresent()) {
                request.setAttribute("category", categoryOpt.get());
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/Category/category_edit.jsp")
                        .forward(request, response);
            } else {
                handleError(request, response, "Category not found");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing edit form", e);
            handleError(request, response, "Error showing edit form: " + e.getMessage());
        }
    }

    private void handleCreateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Category category = new Category();
            populateCategoryFromRequest(category, request);

            if (categoryDAO.create(category)) {
                request.setAttribute("toastMessage", "Category created successfully!");
                request.setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/category/list");
            } else {
                throw new Exception("Failed to create category");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error creating category", e);
            request.setAttribute("toastMessage", "Error creating category: " + e.getMessage());
            request.setAttribute("toastType", "error");
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Category/category_add.jsp")
                    .forward(request, response);
        }
    }

    private void handleUpdateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int categoryId = getIntParameter(request, "id", 0);
            if (categoryId <= 0) {
                throw new IllegalArgumentException("Invalid category ID");
            }

            Category category = new Category();
            category.setCategoryId(categoryId);
            populateCategoryFromRequest(category, request);

            if (categoryDAO.update(category)) {
                request.setAttribute("toastMessage", "Category updated successfully!");
                request.setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/category/list");
            } else {
                throw new Exception("Failed to update category");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating category", e);
            request.setAttribute("toastMessage", "Error updating category: " + e.getMessage());
            request.setAttribute("toastType", "error");
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Category/category_edit.jsp")
                    .forward(request, response);
        }
    }

    private void handleDeleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int categoryId = getIntParameter(request, "id", 0);
            if (categoryId <= 0) {
                throw new IllegalArgumentException("Invalid category ID");
            }

            if (categoryDAO.deleteById(categoryId)) {
                request.setAttribute("toastMessage", "Category deleted successfully!");
                request.setAttribute("toastType", "success");
            } else {
                request.setAttribute("toastMessage", "Failed to delete category");
                request.setAttribute("toastType", "error");
            }
            response.sendRedirect(request.getContextPath() + "/category/list");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deleting category", e);
            handleError(request, response, "Error deleting category: " + e.getMessage());
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Category/category_list.jsp")
                .forward(request, response);
    }

    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try {
                return Integer.parseInt(paramValue.trim());
            } catch (NumberFormatException e) {
                logger.warning("Invalid number parameter " + paramName + ": " + paramValue);
            }
        }
        return defaultValue;
    }

    private void populateCategoryFromRequest(Category category, HttpServletRequest request) {
        String parentIdStr = request.getParameter("parentCategoryId");
        if (parentIdStr != null && !parentIdStr.trim().isEmpty()) {
            category.setParentCategoryId(Integer.parseInt(parentIdStr));
        }

        category.setName(request.getParameter("name"));
        category.setSlug(request.getParameter("slug"));
        category.setDescription(request.getParameter("description"));
        category.setImageUrl(request.getParameter("imageUrl"));
        category.setModuleType(request.getParameter("moduleType"));
        category.setActive(Boolean.parseBoolean(request.getParameter("isActive")));

        String sortOrderStr = request.getParameter("sortOrder");
        if (sortOrderStr != null && !sortOrderStr.trim().isEmpty()) {
            category.setSortOrder(Integer.parseInt(sortOrderStr));
        }
    }

    private void handleDeactivateCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
          String redirectUrl = buildListRedirectUrl(request);

        try {
            int categoryId = getIntParameter(request, "id", 0);
            if (categoryId <= 0) {
                request.getSession().setAttribute("errorMessage", "Invalid category ID provided.");
                response.sendRedirect(redirectUrl);
                return;
            }

            if (categoryDAO.deactivateCategory(categoryId)) {
                request.getSession().setAttribute("successMessage", " Category  has been deactivated successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to deactivate the category.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deactivating customer", e);
            request.getSession().setAttribute("errorMessage", "Error deactivating category: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }

    private void handleActivateCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
          String redirectUrl = buildListRedirectUrl(request);

        try {
            int categoryId = getIntParameter(request, "id", 0);
            if (categoryId <= 0) {
                request.getSession().setAttribute("errorMessage", "Invalid category ID provided.");
                response.sendRedirect(redirectUrl);
                return;
            }

            if (categoryDAO.deactivateCategory(categoryId)) {
                request.getSession().setAttribute("successMessage", " Category  has been Activated successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to Activate the category.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deactivating customer", e);
            request.getSession().setAttribute("errorMessage", "Error Activateing category: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);

        
    }
    
        private String buildListRedirectUrl(HttpServletRequest request) {
        String page = request.getParameter("page");
        String search = request.getParameter("search");
        String status = request.getParameter("status");

        List<String> params = new ArrayList<>();
        if (page != null && !page.isEmpty()) {
            params.add("page=" + page);
        }
        if (search != null && !search.isEmpty()) {
            try {
                // Quan trọng: Mã hóa giá trị tìm kiếm để tránh lỗi URL
                params.add("search=" + URLEncoder.encode(search, StandardCharsets.UTF_8.toString()));
            } catch (Exception e) {
                logger.warning("Could not encode search parameter: " + e.getMessage());
            }
        }
        if (status != null && !status.isEmpty()) {
            params.add("status=" + status);
        }

        String queryString = String.join("&", params);
        if (queryString.isEmpty()) {
            return request.getContextPath() + "/category/list";
        } else {
            return request.getContextPath() + "/category/list?" + queryString;
        }
    }

    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }
}
