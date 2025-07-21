package model;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class User {
  private Integer userId;
  private Integer roleId;
  private String fullName;
  private String email;
  private String hashPassword;
  private String phoneNumber;
  private String gender;
  private Date birthday;
  private String avatarUrl;
  private String address;
  private Boolean isActive;
  private Boolean isEmailVerified; // Email verification status
  private Date lastLoginAt;
  private Date createdAt;
  private Date updatedAt;


}