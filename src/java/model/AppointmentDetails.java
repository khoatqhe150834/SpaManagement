package model;
import lombok.*;
import java.math.BigDecimal;

@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class AppointmentDetails {
    private Integer detailId;
    private Integer appointmentId;
    private Integer serviceId;
    private String serviceName;
    private BigDecimal originalServicePrice;
    private BigDecimal discountAmountApplied;
    private BigDecimal finalPriceAfterDiscount;
    private String notesByCustomer;
    private String notesByStaff;
    private String status;        
    private String paymentStatus;
}
