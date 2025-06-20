package controller;

import dao.BlogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Blog;
import model.Category;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BlogController", urlPatterns = {"/blog", "/blog-detail"})
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

        if (slug != null && !slug.isEmpty()) {
            viewDetail(request, response);
            return;
        }

        if (action == null || action.equals("list")) {
            listWithFilters(request, response);
        }
    }

    /*=============================  POST  ============================*/
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý submit comment cho blog details
        String slug = request.getParameter("slug");
        if (slug != null && !slug.isEmpty()) {
            submitComment(request, response);
            return;
        }
        doGet(request, response);
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
        Blog blog = blogDAO.findBySlug(slug);
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
        response.sendRedirect(request.getContextPath() + "/blog-detail?slug=" + slug + "#comments");
    }
}
