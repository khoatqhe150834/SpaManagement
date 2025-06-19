package dao;

import db.DBContext;
import model.Blog;
import model.Category;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO thao tác bảng blogs.
 */
public class BlogDAO extends DBContext {

    /* ===== mapping ===== */
    private Blog getFromResultSet(ResultSet rs) throws SQLException {
        Blog b = new Blog();
        b.setBlogId(rs.getInt("blog_id"));
        b.setAuthor_userId(rs.getInt("author_user_id"));
        b.setAuthorName(rs.getString("author_name"));
        b.setTitle(rs.getString("title"));
        b.setSlug(rs.getString("slug"));
        b.setSummary(rs.getString("summary"));
        b.setContent(rs.getString("content"));
        b.setFeatureImageUrl(rs.getString("feature_image_url"));
        b.setStatus(rs.getString("status"));
        b.setViewCount(rs.getInt("view_count"));
        b.setPublishedAt(rs.getTimestamp("published_at") == null ? null
                : rs.getTimestamp("published_at").toLocalDateTime());
        b.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        b.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        return b;
    }

    /* ========= ĐẾM tổng bài viết (lọc theo title) ========= */
    public int countBlogs(String searchFilter) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM blogs WHERE status='PUBLISHED' ");
        List<Object> params = new ArrayList<>();

        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append("AND title LIKE ? ");
            params.add("%" + searchFilter.trim() + "%");
        }

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("countBlogs: " + e.getMessage());
        }
        return 0;
    }

    /* ========= LẤY danh sách theo trang (lọc title) ========= */
    public List<Blog> findBlogsWithFilters(String searchFilter,
            int page, int pageSize) {
        List<Blog> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT b.*, u.full_name AS author_name "
                + "FROM blogs b JOIN users u ON b.author_user_id = u.user_id "
                + "WHERE b.status = 'PUBLISHED' ");

        List<Object> params = new ArrayList<>();
        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append("AND b.title LIKE ? ");
            params.add("%" + searchFilter.trim() + "%");
        }
        sql.append("ORDER BY b.published_at DESC, b.created_at DESC "
                + "LIMIT ? OFFSET ?");

        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println("findBlogsWithFilters: " + e.getMessage());
        }

        return list;
    }

    /* ===== BÀI mới nhất cho sidebar ===== */
    public List<Blog> findRecent(int limit) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name AS author_name "
                + "FROM blogs b JOIN users u ON b.author_user_id=u.user_id "
                + "WHERE b.status='PUBLISHED' "
                + "ORDER BY b.published_at DESC, b.created_at DESC LIMIT ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println("findRecent(): " + e.getMessage());
        }
        return list;
    }

    // Lấy các category thực tế có blog (chỉ BLOG_POST, chỉ active)
    public List<Category> findCategoriesHavingBlogs() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT DISTINCT c.* "
                + "FROM categories c "
                + "JOIN blog_categories bc ON c.category_id = bc.category_id "
                + "WHERE c.module_type = 'BLOG_POST' AND c.is_active = 1 "
                + "ORDER BY c.sort_order, c.name";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                c.setSlug(rs.getString("slug"));
                c.setDescription(rs.getString("description"));
                c.setImageUrl(rs.getString("image_url"));
                c.setModuleType(rs.getString("module_type"));
                c.setActive(rs.getBoolean("is_active"));
                c.setSortOrder(rs.getInt("sort_order"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("findCategoriesHavingBlogs: " + e.getMessage());
        }
        return list;
    }

    // Đếm số blog theo category (có thể kết hợp search)
    public int countBlogsByCategory(Integer categoryId, String searchFilter) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM blogs b "
                + "JOIN blog_categories bc ON b.blog_id = bc.blog_id "
                + "WHERE b.status='PUBLISHED' AND bc.category_id=? "
        );
        List<Object> params = new ArrayList<>();
        params.add(categoryId);
        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append("AND b.title LIKE ? ");
            params.add("%" + searchFilter.trim() + "%");
        }
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("countBlogsByCategory: " + e.getMessage());
        }
        return 0;
    }

    // Lấy danh sách blog theo category (có thể kết hợp search và phân trang)
    public List<Blog> findBlogsByCategory(Integer categoryId, String searchFilter, int page, int pageSize) {
        List<Blog> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT b.*, u.full_name AS author_name "
                + "FROM blogs b "
                + "JOIN users u ON b.author_user_id = u.user_id "
                + "JOIN blog_categories bc ON b.blog_id = bc.blog_id "
                + "WHERE b.status='PUBLISHED' AND bc.category_id=? "
        );
        List<Object> params = new ArrayList<>();
        params.add(categoryId);
        if (searchFilter != null && !searchFilter.trim().isEmpty()) {
            sql.append("AND b.title LIKE ? ");
            params.add("%" + searchFilter.trim() + "%");
        }
        sql.append("ORDER BY b.published_at DESC, b.created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(getFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println("findBlogsByCategory: " + e.getMessage());
        }
        return list;
    }

}
