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
public class BookingAppointment {
  private Integer appointmentId;
  private Integer bookingGroupId;
  private Integer serviceId;
  private Integer therapistUserId;

  private LocalDateTime startTime;
  private LocalDateTime endTime;

  private BigDecimal servicePrice;
  private String status; // SCHEDULED, IN_PROGRESS, COMPLETED, CANCELLED
  private String serviceNotes;

  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  // Enum for status values to match database
  public enum Status {
    SCHEDULED, IN_PROGRESS, COMPLETED, CANCELLED
  }
}