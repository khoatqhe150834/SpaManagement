/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class BookingGroup {
    private Integer bookingGroupId;
    private Integer customerId;

    private LocalDate bookingDate;
    private BigDecimal totalAmount;

    private String paymentStatus; // PENDING, PAID
    private String bookingStatus; // CONFIRMED, IN_PROGRESS, COMPLETED, CANCELLED
    private String paymentMethod; // Default: ONLINE_BANKING
    private String specialNotes;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Enums for status values to match database
    public enum PaymentStatus {
        PENDING, PAID
    }

    public enum BookingStatus {
        CONFIRMED, IN_PROGRESS, COMPLETED, CANCELLED
    }
}
