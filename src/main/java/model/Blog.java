package model;

import lombok.*;
import java.time.LocalDateTime;
import java.util.Date;
import java.sql.Timestamp;

@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Blog {
    private Integer blogId;
    private Integer author_userId;   // FK → users.user_id
    private String  authorName;      // u.full_name

    private String  title;
    private String  slug;
    private String  summary;
    private String  content;
    private String  featureImageUrl;

    private String  status;          // DRAFT / PUBLISHED / ...
    private Integer viewCount;

    private LocalDateTime publishedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    /* ===== helper cho JSP – BEGIN ===== */
    public Date getPublishedAtDate() {
        return publishedAt == null ? null : Timestamp.valueOf(publishedAt);
    }
    public Date getCreatedAtDate() {
        return createdAt == null ? null : Timestamp.valueOf(createdAt);
    }
    /* ===== helper cho JSP – END ===== */
}
