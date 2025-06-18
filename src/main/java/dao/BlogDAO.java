package dao;

import db.DBContext;
import model.Blog;

import java.sql.*;
import java.util.*;

public class BlogDAO extends DBContext {

    /*===================== LIST + SEARCH + PAGINATION =====================*/
    public List<Blog> findPublishedBlogs(String search, int page, int pageSize) {
        List<Blog> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
              "SELECT b.blog_id, b.author_user_id, u.full_name AS author_name, "
            + "       b.title, b.slug, b.summary, b.feature_image_url, "
            + "       b.published_at, b.created_at, b.view_count "
            + "FROM   blogs b "
            + "JOIN   users u ON b.author_user_id = u.user_id "
            + "WHERE  b.status = 'PUBLISHED' ");

        List<Object> p = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (b.title LIKE ? OR b.summary LIKE ?) ");
            String kw = "%" + search.trim() + "%";
            p.add(kw); p.add(kw);
        }
        sql.append(" ORDER BY b.published_at DESC LIMIT ? OFFSET ? ");
        p.add(pageSize);
        p.add((page - 1) * pageSize);

        try (Connection c = DBContext.getConnection();
             PreparedStatement st = c.prepareStatement(sql.toString())) {

            for (int i = 0; i < p.size(); i++) st.setObject(i + 1, p.get(i));

            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(fromRS(rs));

        } catch (SQLException e) {
            System.out.println("BlogDAO findPublishedBlogs: " + e.getMessage());
        } finally { closeConnection(); }
        return list;
    }

    public int countPublishedBlogs(String search) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM blogs b WHERE b.status='PUBLISHED' ");
        List<Object> p = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (b.title LIKE ? OR b.summary LIKE ?) ");
            String kw = "%" + search.trim() + "%";
            p.add(kw); p.add(kw);
        }
        try (Connection c = DBContext.getConnection();
             PreparedStatement st = c.prepareStatement(sql.toString())) {

            for (int i = 0; i < p.size(); i++) st.setObject(i + 1, p.get(i));
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (SQLException e) {
            System.out.println("BlogDAO countPublishedBlogs: " + e.getMessage());
        } finally { closeConnection(); }
        return 0;
    }

    /*===================== Helper =====================*/
    private Blog fromRS(ResultSet rs) throws SQLException {
        return Blog.builder()
                .blogId        (rs.getInt("blog_id"))
                .author_userId (rs.getInt("author_user_id"))
                .authorName    (rs.getString("author_name"))
                .title         (rs.getString("title"))
                .slug          (rs.getString("slug"))
                .summary       (rs.getString("summary"))
                .featureImageUrl(rs.getString("feature_image_url"))
                .publishedAt   (rs.getTimestamp("published_at").toLocalDateTime())
                .createdAt     (rs.getTimestamp("created_at").toLocalDateTime())
                .viewCount     (rs.getInt("view_count"))
                .build();
    }
}
