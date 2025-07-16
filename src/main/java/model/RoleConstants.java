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
    public static final int MARKETING_ID = 6;
    public static final int INVENTORY_MANAGER_ID = 7;

    public static String getUserTypeFromRole(Integer roleId) {
        if (roleId == null) {
            return "CUSTOMER"; // Default to customer if no role specified
        }

        switch (roleId) {
            case ADMIN_ID:
                return "ADMIN";
            case MANAGER_ID:
                return "MANAGER";
            case THERAPIST_ID:
                return "THERAPIST";
            case RECEPTIONIST_ID:
                return "RECEPTIONIST";
            case CUSTOMER_ID:
                return "CUSTOMER";
            case MARKETING_ID:
                return "MARKETING";
            case INVENTORY_MANAGER_ID:
                return "INVENTORY_MANAGER";
            default:
                return "CUSTOMER"; // Default to customer for unknown roles
        }
    }
}
