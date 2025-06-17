package model;

import lombok.*;
import java.time.LocalDateTime;

/**
 * Model representing a customer check-in for an appointment
 * 
 * @author quang
 */
@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Checkin {
  private Integer checkinId;
  private Integer appointmentId;
  private Integer customerId;
  private LocalDateTime checkinTime;
  private String status; // SUCCESS, FAILED, PENDING
  private String notes;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;
}