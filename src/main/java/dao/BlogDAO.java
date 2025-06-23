package dao;

import db.DBContext;
import model.Blog;
import model.Category;
import model.BlogComment;

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

    // Lấy blog theo slug, không lọc status
    public Blog findBySlug(String slug) {
        String sql = "SELECT b.*, u.full_name AS author_name " +
                "FROM blogs b " +
                "JOIN users u ON b.author_user_id = u.user_id " +
                "WHERE b.slug = ? LIMIT 1";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, slug);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return getFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.out.println("findBySlug: " + e.getMessage());
        }
        return null;
    }

    // Lấy tất cả comment đã duyệt cho 1 blog (bỏ parentCommentId, chỉ lấy comment cha là null)
    public List<BlogComment> findCommentsByBlogId(int blogId) {
        List<BlogComment> list = new ArrayList<>();
        String sql = "SELECT c.*, cu.full_name AS customerName, cu.avatar_url AS avatarUrl " +
                "FROM blog_comments c " +
                "LEFT JOIN customers cu ON c.customer_id = cu.customer_id " +
                "WHERE c.blog_id = ? AND c.status = 'APPROVED' " +
                "ORDER BY c.created_at ASC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, blogId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BlogComment c = new BlogComment();
                c.setCommentId(rs.getInt("comment_id"));
                c.setBlogId(rs.getInt("blog_id"));
                c.setCustomerId(rs.getObject("customer_id") == null ? null : rs.getInt("customer_id"));
                c.setGuestName(rs.getString("guest_name"));
                c.setGuestEmail(rs.getString("guest_email"));
                c.setCommentText(rs.getString("comment_text"));
                c.setStatus(rs.getString("status"));
                c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                c.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                c.setCustomerName(rs.getString("customerName"));
                c.setAvatarUrl(rs.getString("avatarUrl"));
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("findCommentsByBlogId: " + e.getMessage());
        }
        return list;
    }

    // Thêm comment mới (bỏ parentCommentId, luôn lưu là null)
    public void addComment(BlogComment comment) {
        String sql = "INSERT INTO blog_comments (blog_id, customer_id, guest_name, guest_email, comment_text, status, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, comment.getBlogId());
            // parent_comment_id luôn là NULL
            if (comment.getCustomerId() != null) {
                ps.setInt(2, comment.getCustomerId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setString(3, comment.getGuestName());
            ps.setString(4, comment.getGuestEmail());
            ps.setString(5, comment.getCommentText());
            ps.setString(6, comment.getStatus() == null ? "APPROVED" : comment.getStatus());
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("addComment: " + e.getMessage());
        }
    }

    // Tăng view count cho blog
    public void incrementViewCount(int blogId) {
        String sql = "UPDATE blogs SET view_count = view_count + 1 WHERE blog_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, blogId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("incrementViewCount: " + e.getMessage());
        }
    }

    /* ========= MARKETING METHODS ========= */
    
    // Đếm tổng blog cho marketing (có thể lọc theo status và search)
    public int countBlogsForMarketing(String searchFilter, String statusFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM blogs b ");
        List<Object> params = new ArrayList<>();

        if (searchFilter != null && !searchFilter.trim().isEmpty() || 
            statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append("WHERE ");
            boolean hasCondition = false;
            
            if (searchFilter != null && !searchFilter.trim().isEmpty()) {
                sql.append("b.title LIKE ? ");
                params.add("%" + searchFilter.trim() + "%");
                hasCondition = true;
            }
            
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                if (hasCondition) sql.append("AND ");
                sql.append("b.status = ? ");
                params.add(statusFilter.trim());
            }
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
            System.out.println("countBlogsForMarketing: " + e.getMessage());
        }
        return 0;
    }

    // Lấy danh sách blog cho marketing (có thể lọc theo status và search)
    public List<Blog> findBlogsForMarketing(String searchFilter, String statusFilter, int page, int pageSize) {
        List<Blog> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT b.*, u.full_name AS author_name "
                + "FROM blogs b JOIN users u ON b.author_user_id = u.user_id ");

        List<Object> params = new ArrayList<>();
        
        if (searchFilter != null && !searchFilter.trim().isEmpty() || 
            statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append("WHERE ");
            boolean hasCondition = false;
            
            if (searchFilter != null && !searchFilter.trim().isEmpty()) {
                sql.append("b.title LIKE ? ");
                params.add("%" + searchFilter.trim() + "%");
                hasCondition = true;
            }
            
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                if (hasCondition) sql.append("AND ");
                sql.append("b.status = ? ");
                params.add(statusFilter.trim());
            }
        }
        
        sql.append("ORDER BY b.created_at DESC LIMIT ? OFFSET ?");
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
            System.out.println("findBlogsForMarketing: " + e.getMessage());
        }

        return list;
    }

    // Lấy blog theo slug cho marketing (không lọc status)
    public Blog findBySlugForMarketing(String slug) {
        String sql = "SELECT b.*, u.full_name AS author_name " +
                "FROM blogs b " +
                "JOIN users u ON b.author_user_id = u.user_id " +
                "WHERE b.slug = ? LIMIT 1";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, slug);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return getFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.out.println("findBySlugForMarketing: " + e.getMessage());
        }
        return null;
    }

    // Đổi trạng thái comment (APPROVED/REJECTED)
    public boolean updateCommentStatus(int commentId, String status) {
        String sql = "UPDATE blog_comments SET status = ?, updated_at = NOW() WHERE comment_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, commentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("updateCommentStatus: " + e.getMessage());
            return false;
        }
    }

    /**
     * Thêm blog mới và liên kết category
     * @param blog Blog object (title, slug, summary, content, featureImageUrl, status, publishedAt, author_userId)
     * @param categoryIds List<Integer> category IDs
     * @return blogId nếu thành công, -1 nếu lỗi
     */
    public int addBlog(Blog blog, List<Integer> categoryIds) {
        String sql = "INSERT INTO blogs (author_user_id, title, slug, summary, content, feature_image_url, status, published_at, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        int blogId = -1;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, blog.getAuthor_userId());
            ps.setString(2, blog.getTitle());
            ps.setString(3, blog.getSlug());
            ps.setString(4, blog.getSummary());
            ps.setString(5, blog.getContent());
            ps.setString(6, blog.getFeatureImageUrl());
            ps.setString(7, blog.getStatus());
            if (blog.getPublishedAt() != null) {
                ps.setTimestamp(8, Timestamp.valueOf(blog.getPublishedAt()));
            } else {
                ps.setNull(8, Types.TIMESTAMP);
            }
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    blogId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("addBlog: " + e.getMessage());
            return -1;
        }
        // Insert blog_categories
        if (blogId > 0 && categoryIds != null) {
            String sqlCat = "INSERT INTO blog_categories (blog_id, category_id) VALUES (?, ?)";
            try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sqlCat)) {
                for (Integer catId : categoryIds) {
                    ps.setInt(1, blogId);
                    ps.setInt(2, catId);
                    ps.addBatch();
                }
                ps.executeBatch();
            } catch (SQLException e) {
                System.out.println("addBlog - blog_categories: " + e.getMessage());
            }
        }
        return blogId;
    }

}
