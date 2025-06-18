package controller;

import dao.BlogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Blog;

@WebServlet(name = "BlogController", urlPatterns = {"/blog"})
public class BlogController extends HttpServlet {

    private BlogDAO blogDAO;

    @Override
    public void init() {
        blogDAO = new BlogDAO();
    }

    /*========= GET =========*/
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String search = req.getParameter("search");
        int page = 1;
        int pageSize = 6;

        try {
            if (req.getParameter("page") != null) {
                page = Math.max(1, Integer.parseInt(req.getParameter("page")));
            }
        } catch (NumberFormatException ignored) {
        }

        List<Blog> blogs = blogDAO.findPublishedBlogs(search, page, pageSize);
        int totalPages = (int) Math.ceil(
                (double) blogDAO.countPublishedBlogs(search) / pageSize);

        req.setAttribute("blogs", blogs);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("search", search == null ? "" : search);

        req.getRequestDispatcher("/WEB-INF/view/customer/blog/blog_list.jsp")
                .forward(req, resp);
    }

    /*========= POST (search form) =========*/
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String kw = req.getParameter("text");
        String url = req.getContextPath() + "/blog";
        if (kw != null && !kw.trim().isEmpty()) {
            url += "?search=" + java.net.URLEncoder.encode(kw.trim(), "UTF-8");
        }
        resp.sendRedirect(url);
    }
}
