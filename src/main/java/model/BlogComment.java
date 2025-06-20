/**
 *
 * @author ADMIN
 */
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
@Getter
@Setter
public class BlogComment {
    private Integer commentId;
    private Integer blogId;
    private Integer customerId;

    private String guestName;
    private String guestEmail;
    private String commentText;
    private String status; 

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private String customerName;
    private String avatarUrl;

    public Date getCreatedAtDate() {
        return createdAt == null ? null : Timestamp.valueOf(createdAt);
    }
    public Date getUpdatedAtDate() {
        return updatedAt == null ? null : Timestamp.valueOf(updatedAt);
    }
}

