package model;

import java.util.Date;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
@Builder
@NoArgsConstructor

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
  private Date lastLoginAt;
  private Date createdAt;
  private Date updatedAt;

    
    public User(Integer userId, Integer roleId, String fullName, String email, String hashPassword, String phoneNumber, String gender, Date birthday, String avatarUrl, String address, Boolean isActive, Date lastLoginAt, Date createdAt, Date updatedAt) {
        this.userId = userId;
        this.roleId = roleId;
        this.fullName = fullName;
        this.email = email;
        this.hashPassword = hashPassword;
        this.phoneNumber = phoneNumber;
        this.gender = gender;
        this.birthday = birthday;
        this.avatarUrl = avatarUrl;
        this.address = address;
        this.isActive = isActive;
        this.lastLoginAt = lastLoginAt;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
  
  
  
}