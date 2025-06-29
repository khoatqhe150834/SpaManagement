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
import org.commonmark.node.*;
import org.commonmark.parser.Parser;
import org.commonmark.renderer.html.HtmlRenderer;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.ArrayList;

@WebServlet(name = "BlogController", urlPatterns = {"/blog"})
@MultipartConfig(
    fileSizeThreshold = 0,
    maxFileSize = 5 * 1024 * 1024, // 5MB
    maxRequestSize = 10 * 1024 * 1024
)
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
        String idStr = request.getParameter("id");
        Integer id = null;
        if (idStr != null && !idStr.isEmpty()) {
            try { id = Integer.parseInt(idStr); } catch (Exception ignore) {}
        }

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Customer customer = (Customer) session.getAttribute("customer");

        // Add Blog (GET)
        if ("add".equals(action) && user != null && user.getRoleId() == 6) {
            List<Category> categories = blogDAO.findCategoriesHavingBlogs();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Blog/blog_add.jsp").forward(request, response);
            return;
        }

        // Edit Blog (GET)
        if ("edit".equals(action) && user != null && user.getRoleId() == 6 && id != null) {
            Blog blog = blogDAO.findById(id);
            if (blog == null) {
                response.sendRedirect(request.getContextPath() + "/blog?action=list");
                return;
            }
            List<Category> categories = blogDAO.findCategoriesHavingBlogs();
            List<Integer> selectedCategoryIds = blogDAO.findCategoryIdsByBlogId(blog.getBlogId());
            request.setAttribute("categories", categories);
            request.setAttribute("blog", blog);
            request.setAttribute("selectedCategoryIds", selectedCategoryIds);
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Blog/blog_edit.jsp").forward(request, response);
            return;
        }

        // Marketing blog details view
        if (id != null && user != null && user.getRoleId() == 6) {
            viewMarketingDetailById(request, response, id);
            return;
        }
        // Manager blog details view
        if (id != null && user != null && user.getRoleId() == 2) {
            viewMarketingDetailById(request, response, id);
            return;
        }
        if (id != null) {
            viewDetailById(request, response, id);
            return;
        }

        if (action == null || action.equals("list")) {
            // Check user role and redirect accordingly
            if (user != null && user.getRoleId() == 6) { // Marketing role
                listMarketingBlogs(request, response);
            } else if (user != null && user.getRoleId() == 2) { // Manager role
                listManagerBlogs(request, response);
            } else { // Customer or Guest
                listWithFilters(request, response);
            }
        }

        // AJAX check title duplicate
        if ("checkTitle".equals(action)) {
            String title = request.getParameter("title");
            String excludeIdStr = request.getParameter("excludeId");
            Integer excludeId = null;
            if (excludeIdStr != null && !excludeIdStr.isEmpty()) {
                try { excludeId = Integer.parseInt(excludeIdStr); } catch (Exception ignore) {}
            }
            boolean duplicate = blogDAO.isTitleDuplicate(title, excludeId);
            response.setContentType("application/json");
            response.getWriter().write("{\"duplicate\":" + duplicate + "}");
            return;
        }
    }

    /*=============================  POST  ============================*/
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        Integer id = null;
        if (idStr != null && !idStr.isEmpty()) {
            try { id = Integer.parseInt(idStr); } catch (Exception ignore) {}
        }
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if ("add".equals(action) && user != null && user.getRoleId() == 6) {
            handleAddBlog(request, response, user);
            return;
        }
        if ("edit".equals(action) && user != null && user.getRoleId() == 6 && id != null) {
            handleEditBlog(request, response, user, id);
            return;
        }
        if ("rejectComment".equals(action)) {
            handleRejectComment(request, response);
            return;
        }
        if ("updateBlogStatus".equals(action)) {
            handleUpdateBlogStatus(request, response);
            return;
        }
        if ("submitComment".equals(action)) {
            submitComment(request, response);
            return;
        }
        doGet(request, response);
    }

    private void handleAddBlog(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String summary = request.getParameter("summary");
        String content = request.getParameter("content");
        String status = request.getParameter("status");
        String[] categoryIds = request.getParameterValues("category");
        List<Integer> catIds = new ArrayList<>();
        if (categoryIds != null) {
            for (String cid : categoryIds) {
                try { catIds.add(Integer.parseInt(cid)); } catch (Exception ignore) {}
            }
        }
        // Handle image upload
        String featureImageUrl = null;
        Part imagePart = request.getPart("featureImage");
        if (imagePart != null && imagePart.getSize() > 0) {
            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            String ext = fileName.lastIndexOf('.') > 0 ? fileName.substring(fileName.lastIndexOf('.')) : "";
            String newFileName = System.currentTimeMillis() + ext;
            String uploadDir = getServletContext().getRealPath("/assets/home/images/blog/");
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();
            File file = new File(dir, newFileName);
            imagePart.write(file.getAbsolutePath());
            featureImageUrl = "assets/home/images/blog/" + newFileName;
        }
        Blog blog = new Blog();
        blog.setAuthor_userId(user.getUserId());
        blog.setTitle(title);
        blog.setSummary(summary);
        blog.setContent(content);
        blog.setFeatureImageUrl(featureImageUrl);
        blog.setStatus("DRAFT"); // Marketing can only create DRAFT blogs
        // Set publishedAt only if status is PUBLISHED
        if ("PUBLISHED".equalsIgnoreCase(status)) {
            blog.setPublishedAt(java.time.LocalDateTime.now());
        }
        int blogId = blogDAO.addBlog(blog, catIds);
        if (blogId > 0) {
            response.sendRedirect(request.getContextPath() + "/blog?action=list");
        } else {
            request.setAttribute("error", "Failed to add blog. Please try again.");
            List<Category> categories = blogDAO.findCategoriesHavingBlogs();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Blog/blog_add.jsp").forward(request, response);
        }
    }

    private void handleEditBlog(HttpServletRequest request, HttpServletResponse response, User user, int id)
            throws ServletException, IOException {
        Blog oldBlog = blogDAO.findById(id);
        if (oldBlog == null) {
            response.sendRedirect(request.getContextPath() + "/blog?action=list");
            return;
        }
        String title = request.getParameter("title");
        String summary = request.getParameter("summary");
        String content = request.getParameter("content");
        String status = request.getParameter("status");
        String[] categoryIds = request.getParameterValues("category");
        List<Integer> catIds = new ArrayList<>();
        if (categoryIds != null) {
            for (String cid : categoryIds) {
                try { catIds.add(Integer.parseInt(cid)); } catch (Exception ignore) {}
            }
        }
        // Handle image upload
        String featureImageUrl = oldBlog.getFeatureImageUrl();
        Part imagePart = request.getPart("featureImage");
        if (imagePart != null && imagePart.getSize() > 0) {
            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            String ext = fileName.lastIndexOf('.') > 0 ? fileName.substring(fileName.lastIndexOf('.')) : "";
            String newFileName = System.currentTimeMillis() + ext;
            String uploadDir = getServletContext().getRealPath("/assets/home/images/blog/");
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();
            File file = new File(dir, newFileName);
            imagePart.write(file.getAbsolutePath());
            featureImageUrl = "assets/home/images/blog/" + newFileName;
        }
        Blog blog = new Blog();
        blog.setBlogId(oldBlog.getBlogId());
        blog.setAuthor_userId(oldBlog.getAuthor_userId());
        blog.setTitle(title);
        blog.setSummary(summary);
        blog.setContent(content);
        blog.setFeatureImageUrl(featureImageUrl);
        blog.setStatus("DRAFT"); // Khi edit, luôn chuyển về DRAFT
        // Set publishedAt về null khi chuyển về DRAFT
        blog.setPublishedAt(null);
        boolean ok = blogDAO.updateBlog(blog, catIds);
        if (ok) {
            // Sau khi update thành công, forward lại trang edit với thông báo thành công
            List<Category> categories = blogDAO.findCategoriesHavingBlogs();
            request.setAttribute("categories", categories);
            request.setAttribute("blog", blogDAO.findById(id)); // lấy lại blog mới nhất
            request.setAttribute("selectedCategoryIds", catIds);
            request.setAttribute("success", "Cập nhật blog thành công!");
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Blog/blog_edit.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Failed to update blog. Please try again.");
            List<Category> categories = blogDAO.findCategoriesHavingBlogs();
            request.setAttribute("categories", categories);
            request.setAttribute("blog", blog);
            request.setAttribute("selectedCategoryIds", catIds);
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Blog/blog_edit.jsp").forward(request, response);
        }
    }

    private void listMarketingBlogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchFilter = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        String categoryIdStr = request.getParameter("category");
        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException ignore) {
            }
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

        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Blog/blog_list.jsp").forward(request, response);
    }

    private void listManagerBlogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchFilter = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        String categoryIdStr = request.getParameter("category");
        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException ignore) {
            }
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
            totalRows = blogDAO.countBlogsForManager(searchFilter, statusFilter);
            blogs = blogDAO.findBlogsForManager(searchFilter, statusFilter, page, pageSize);
        }
        int totalPages = (int) Math.ceil(totalRows / (double) pageSize);

        request.setAttribute("blogs", blogs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", searchFilter == null ? "" : searchFilter);
        request.setAttribute("statusFilter", statusFilter == null ? "" : statusFilter);
        request.setAttribute("selectedCategory", categoryId);

        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Blog/blog_list.jsp").forward(request, response);
    }

    private void listWithFilters(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String searchFilter = request.getParameter("search");
        String categoryIdStr = request.getParameter("category");
        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException ignore) {
            }
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

        List<Blog> recent = blogDAO.findRecent(4);          // sidebar
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

    // Xem chi tiết blog theo id
    private void viewDetailById(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {
        Blog blog = blogDAO.findById(id);
        if (blog == null) {
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }
        blogDAO.incrementViewCount(blog.getBlogId());
        blog = blogDAO.findById(id);
        Parser mdParser = Parser.builder().build();
        Node document = mdParser.parse(blog.getContent());
        HtmlRenderer renderer = HtmlRenderer.builder().build();
        String htmlContent = renderer.render(document);
        request.setAttribute("contentHtml", htmlContent);
        List<model.BlogComment> comments = blogDAO.findCommentsByBlogId(blog.getBlogId());
        List<Blog> recentBlogs = blogDAO.findRecent(4);
        List<Category> categories = blogDAO.findCategoriesHavingBlogs();
        request.setAttribute("blog", blog);
        request.setAttribute("comments", comments);
        request.setAttribute("recentBlogs", recentBlogs);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/view/customer/blog/blog_details.jsp")
                .forward(request, response);
    }

    private void viewMarketingDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // This method is no longer used
        response.sendRedirect(request.getContextPath() + "/blog");
    }

    // Xử lý submit comment cho blog details (customer)
    private void submitComment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        Integer id = null;
        if (idStr != null && !idStr.isEmpty()) {
            try { id = Integer.parseInt(idStr); } catch (Exception ignore) {}
        }
        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }
        Blog blog = blogDAO.findById(id);
        if (blog == null) {
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }
        // Kiểm tra customer đã đăng nhập
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            // Nếu chưa đăng nhập, chuyển hướng về trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/login?returnUrl=" + request.getRequestURI() + "?id=" + id);
            return;
        }
        String commentText = request.getParameter("commentText");
        if (commentText == null || commentText.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/blog?id=" + id + "#comments");
            return;
        }
        model.BlogComment comment = new model.BlogComment();
        comment.setBlogId(blog.getBlogId());
        comment.setCustomerId(customer.getCustomerId());
        comment.setGuestName(null);
        comment.setGuestEmail(null);
        comment.setCommentText(commentText);
        comment.setStatus("APPROVED"); // hoặc PENDING nếu muốn duyệt
        blogDAO.addComment(comment);
        response.sendRedirect(request.getContextPath() + "/blog?id=" + id + "#comments");
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
        if (commentIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }
        try {
            int commentId = Integer.parseInt(commentIdStr);
            blogDAO.updateCommentStatus(commentId, "REJECTED");
        } catch (NumberFormatException ignore) {
        }
        response.sendRedirect(request.getContextPath() + "/blog");
    }

    private void handleUpdateBlogStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleId() != 2) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        String blogIdStr = request.getParameter("blogId");
        String status = request.getParameter("status");
        String page = request.getParameter("page");
        if (blogIdStr == null || status == null) {
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }
        try {
            int blogId = Integer.parseInt(blogIdStr);
            boolean ok = blogDAO.updateBlogStatus(blogId, status);
            if (ok) {
                String redirectUrl = request.getContextPath() + "/blog?action=list";
                if (page != null && !page.isEmpty()) {
                    redirectUrl += "&page=" + page;
                }
                // Giữ lại filter/search nếu có
                String search = request.getParameter("search");
                String statusFilter = request.getParameter("statusFilter");
                String category = request.getParameter("category");
                if (search != null && !search.isEmpty()) redirectUrl += "&search=" + java.net.URLEncoder.encode(search, "UTF-8");
                if (statusFilter != null && !statusFilter.isEmpty()) redirectUrl += "&status=" + java.net.URLEncoder.encode(statusFilter, "UTF-8");
                if (category != null && !category.isEmpty()) redirectUrl += "&category=" + java.net.URLEncoder.encode(category, "UTF-8");
                response.sendRedirect(redirectUrl);
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (NumberFormatException ignore) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void viewMarketingDetailById(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {
        Blog blog = blogDAO.findById(id);
        if (blog == null) {
            response.sendRedirect(request.getContextPath() + "/blog");
            return;
        }
        Parser mdParser = Parser.builder().build();
        Node document = mdParser.parse(blog.getContent());
        HtmlRenderer renderer = HtmlRenderer.builder().build();
        String htmlContent = renderer.render(document);
        request.setAttribute("contentHtml", htmlContent);
        List<model.BlogComment> comments = blogDAO.findCommentsByBlogId(blog.getBlogId());
        List<Blog> recentBlogs = blogDAO.findRecent(6);
        request.setAttribute("blog", blog);
        request.setAttribute("contentHtml", htmlContent);
        request.setAttribute("comments", comments);
        request.setAttribute("recentBlogs", recentBlogs);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Blog/blog_details.jsp")
                .forward(request, response);
    }
}
