package model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Date;

@Data                   // sinh Getter/Setter, toString, equals, hashCode
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Blog {

    private Integer blogId;
    private Integer author_userId;    // FK → users.user_id  (giữ đúng tên cột)
    private String authorName;       // u.full_name

    private String title;
    private String slug;
    private String summary;
    private String content;
    private String featureImageUrl;

    private String status;           // DRAFT / PUBLISHED / ...
    private Integer viewCount;

    private LocalDateTime publishedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    /* ===== helper cho JSP ===== */
    public Date getPublishedAtDate() {
        return publishedAt == null ? null : Timestamp.valueOf(publishedAt);
    }

    public Date getCreatedAtDate() {
        return createdAt == null ? null : Timestamp.valueOf(createdAt);
    }

    public void setPublishedAtDate(LocalDateTime dt) {
        this.publishedAt = dt;
    }

}
