package controller;

import dao.BlogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Blog;
import model.Category;
import model.User;
import model.Customer;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BlogController", urlPatterns = {"/blog"})
public class BlogController extends HttpServlet {

    private BlogDAO blogDAO;

    @Override
    public void init() throws ServletException {
        blogDAO = new BlogDAO();
    }

    /*=============================  GET  =============================*/
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String slug = request.getParameter("slug");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Customer customer = (Customer) session.getAttribute("customer");

        // Marketing blog details view
        if (slug != null && !slug.isEmpty() && user != null && user.getRoleId() == 6) {
            viewMarketingDetail(request, response);
            return;
        }

        if (slug != null && !slug.isEmpty()) {
            viewDetail(request, response);
            return;
        }

        if (action == null || action.equals("list")) {
            // Check user role and redirect accordingly
            if (user != null && user.getRoleId() == 6) { // Marketing role
                listMarketingBlogs(request, response);
            } else { // Customer or Guest
                listWithFilters(request, response);
            }
        }
    }

    /*=============================  POST  ============================*/
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String slug = request.getParameter("slug");
        if ("rejectComment".equals(action)) {
            handleRejectComment(request, response);
            return;
        }
        if (slug != null && !slug.isEmpty()) {
            submitComment(request, response);
            return;
        }
        doGet(request, response);
    }

    private void listMarketingBlogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchFilter = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        String categoryIdStr = request.getParameter("category");
        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try { categoryId = Integer.parseInt(categoryIdStr); } catch (NumberFormatException ignore) {}
        }
        int page = 1;
        int pageSize = 12;

        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException ignored) {
            }
        }

        // Lấy danh sách category cho filter
        List<Category> categories = blogDAO.findCategoriesHavingBlogs();
        request.setAttribute("categories", categories);

        int totalRows;
        List<Blog> blogs;
        if (categoryId != null) {
            totalRows = blogDAO.countBlogsByCategory(categoryId, searchFilter);
            blogs = blogDAO.findBlogsByCategory(categoryId, searchFilter, page, pageSize);
        } else {
            totalRows = blogDAO.countBlogsForMarketing(searchFilter, statusFilter);
            blogs = blogDAO.findBlogsForMarketing(searchFilter, statusFilter, page, pageSize);
        }
        int totalPages = (int) Math.ceil(totalRows / (double) pageSize);

        request.setAttribute("blogs", blogs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", searchFilter == null ? "" : searchFilter);
        request.setAttribute("statusFilter", statusFilter == null ? "" : statusFilter);
        request.setAttribute("selectedCategory", categoryId);

        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Blog/blog_list.jsp")
                .forward(request, response);
    }

    private void listWithFilters(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String searchFilter = request.getParameter("search");
        String categoryIdStr = request.getParameter("category");
        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try { categoryId = Integer.parseInt(categoryIdStr); } catch (NumberFormatException ignore) {}
        }
        int page = 1;
        int pageSize = 6;

        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException ignored) {
            }
        }

        int totalRows;
        List<Blog> blogs;
        if (categoryId != null) {
            totalRows = blogDAO.countBlogsByCategory(categoryId, searchFilter);
            blogs = blogDAO.findBlogsByCategory(categoryId, searchFilter, page, pageSize);
        } else {
            totalRows = blogDAO.countBlogs(searchFilter);
            blogs = blogDAO.findBlogsWithFilters(searchFilter, page, pageSize);
        }
        int totalPages = (int) Math.ceil(totalRows / (double) pageSize);

        List<Blog> recent = blogDAO.findRecent(3);          // sidebar
        List<Category> categories = blogDAO.findCategoriesHavingBlogs();
        request.setAttribute("categories", categories);

        request.setAttribute("blogs", blogs);
        request.setAttribute("recentBlogs", recent);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", searchFilter == null ? "" : searchFilter);
        request.setAttribute("selectedCategory", categoryId);

        request.getRequestDispatcher("/WEB-INF/view/customer/blog/blog_list.jsp")
                .forward(request, response);
    }

    // Xem chi tiết blog
    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String slug = request.getParameter("slug");
        if (slug == null || slug.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }
        Blog blog = blogDAO.findBySlug(slug); // no status filter
        if (blog == null) {
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }
        // Tăng view count mỗi lần xem chi tiết
        blogDAO.incrementViewCount(blog.getBlogId());
        // Lấy lại blog để cập nhật view count mới nhất
        blog = blogDAO.findBySlug(slug);
        List<model.BlogComment> comments = blogDAO.findCommentsByBlogId(blog.getBlogId());
        List<Blog> recentBlogs = blogDAO.findRecent(3);
        List<Category> categories = blogDAO.findCategoriesHavingBlogs();
        request.setAttribute("blog", blog);
        request.setAttribute("comments", comments);
        request.setAttribute("recentBlogs", recentBlogs);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/view/customer/blog/blog_details.jsp").forward(request, response);
    }

    private void viewMarketingDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String slug = request.getParameter("slug");
        if (slug == null || slug.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }
        Blog blog = blogDAO.findBySlug(slug); // no status filter
        if (blog == null) {
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }
        List<model.BlogComment> comments = blogDAO.findCommentsByBlogId(blog.getBlogId());
        List<Blog> recentBlogs = blogDAO.findRecent(3);
        request.setAttribute("blog", blog);
        request.setAttribute("comments", comments);
        request.setAttribute("recentBlogs", recentBlogs);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Blog/blog_details.jsp").forward(request, response);
    }

    // Xử lý submit comment cho blog details
    private void submitComment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String slug = request.getParameter("slug");
        Blog blog = blogDAO.findBySlug(slug);
        if (blog == null) {
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }
        String commentText = request.getParameter("commentText");
        String guestName = request.getParameter("guestName");
        String guestEmail = request.getParameter("guestEmail");
        Integer customerId = (Integer) request.getSession().getAttribute("customerId");
        model.BlogComment comment = new model.BlogComment();
        comment.setBlogId(blog.getBlogId());
        comment.setCustomerId(customerId);
        comment.setGuestName(guestName);
        comment.setGuestEmail(guestEmail);
        comment.setCommentText(commentText);
        comment.setStatus("APPROVED"); // hoặc PENDING nếu muốn duyệt
        blogDAO.addComment(comment);
        response.sendRedirect(request.getContextPath() + "/blog?slug=" + slug + "#comments");
    }

    // Xử lý reject comment (chỉ cho marketing)
    private void handleRejectComment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleId() != 6) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        String commentIdStr = request.getParameter("commentId");
        String slug = request.getParameter("slug");
        if (commentIdStr == null || slug == null) {
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }
        try {
            int commentId = Integer.parseInt(commentIdStr);
            blogDAO.updateCommentStatus(commentId, "REJECTED");
        } catch (NumberFormatException ignore) {}
        response.sendRedirect(request.getContextPath() + "/blog?slug=" + slug);
    }
}
