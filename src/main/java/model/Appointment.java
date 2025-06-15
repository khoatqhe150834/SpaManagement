package model;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Appointment {
    private Integer appointmentId;
    private Integer customerId;
    private Integer bookingGroupId;
    private Integer therapistUserId;

    // Hiển thị tên thay vì chỉ ID
    private String customerName;
    private String bookingGroupName;
    private String therapistName;

    private LocalDateTime startTime;
    private LocalDateTime endTime;

    private BigDecimal totalOriginalPrice;
    private BigDecimal totalDiscountAmount;
    private BigDecimal pointsRedeemedValue;
    private BigDecimal totalFinalPrice;

    private Integer promotionId;
    private String status;         // e.g. "PENDING_CONFIRMATION", "CONFIRMED", ...
    private String paymentStatus;  // e.g. "UNPAID", "PAID", ...

    private String cancelReason;
    private Integer createdFromCartItemId;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

