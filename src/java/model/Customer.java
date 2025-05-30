/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;
import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;


@ToString
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Customer {
    private Integer customerId;
    private String fullName;
    private String email;
    private String hashPassword;
    private String phoneNumber;
    private String gender;
    private Date birthday;
    private String address;
    private Boolean isActive;
    private Integer loyaltyPoints;
    private Integer roleId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Customer(String fullName, String email, String hashPassword, String phoneNumber) {
        this.fullName = fullName;
        this.email = email;
        this.hashPassword = hashPassword;
        this.phoneNumber = phoneNumber;
        this.roleId = RoleConstants.CUSTOMER_ID;
    }

    
    
    
    
    
    
    
    
}