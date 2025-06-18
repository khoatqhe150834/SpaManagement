/**
 *
 * @author ADMIN
 */
package model;

import lombok.*;
import java.time.LocalDateTime;

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
    private Integer parentCommentId;
    private Integer customerId;

    private String guestName;
    private String guestEmail;
    private String commentText;
    private String status; 

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private String customerName;
    private String avatarUrl;
}

