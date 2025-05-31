/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 *
 * @author ADMIN
 */
@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Appointment {
    private int appointmentId;
    private int customerId;
    private Integer bookingGroupId;
    private Integer therapistUserId;
    private int serviceId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private BigDecimal originalServicePrice;
    private BigDecimal discountAmountApplied;
    private BigDecimal finalPriceAfterDiscount;
    private BigDecimal pointsRedeemedValue;
    private BigDecimal finalAmountPayable;
    private Integer promotionId;
    private String status;
    private String paymentStatus;
    private String notesByCustomer;
    private String notesByStaff;
    private String cancelReason;
    private Integer createdFromCartItemId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
