package model;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {
  private Integer userId;
  private Integer roleId;
  private String fullName;
  private String email;
  private String passwordHash;
  private String phoneNumber;
  private String gender;
  private Date birthday;
  private String avatarUrl;
  private Boolean isActive;
  private Date lastLoginAt;
  private Date registeredAt;
  private Date updatedAt;
}