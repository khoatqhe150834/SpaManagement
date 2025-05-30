/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author quang
 */
public class RoleConstants {
     public static final int ADMIN_ID = 1;
    public static final int MANAGER_ID = 2;
    public static final int THERAPIST_ID = 3;
    public static final int RECEPTIONIST_ID = 4;
    public static final int CUSTOMER_ID = 5;
    
    public static String getUserTypeFromRole(Integer roleId) {
        if (roleId == null) {
            return "customer"; // Default to customer if no role specified
        }
        
        switch (roleId) {
            case ADMIN_ID:
                return "admin";
            case MANAGER_ID:
                return "manager";
            case THERAPIST_ID:
                return "therapist";
            case RECEPTIONIST_ID:
                return "receptionist";
            case CUSTOMER_ID:
                return "customer";
            default:
                return "customer"; // Default to customer for unknown roles
        }
    }
}
