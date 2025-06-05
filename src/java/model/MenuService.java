package model;

import model.User;
import model.Customer;
import java.util.ArrayList;
import java.util.List;

/**
 * Service class to generate role-based navigation menu items
 */
public class MenuService {

  public static class MenuItem {
    private String label;
    private String url;
    private String icon;
    private boolean isDivider;

    public MenuItem(String label, String url, String icon) {
      this.label = label;
      this.url = url;
      this.icon = icon;
      this.isDivider = false;
    }

    public MenuItem() {
      this.isDivider = true;
    }

    // Getters and setters
    public String getLabel() {
      return label;
    }

    public void setLabel(String label) {
      this.label = label;
    }

    public String getUrl() {
      return url;
    }

    public void setUrl(String url) {
      this.url = url;
    }

    public String getIcon() {
      return icon;
    }

    public void setIcon(String icon) {
      this.icon = icon;
    }

    public boolean isDivider() {
      return isDivider;
    }

    public void setDivider(boolean divider) {
      isDivider = divider;
    }
  }

  /**
   * Generate menu items for Customer role
   */
  public static List<MenuItem> getCustomerMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    menuItems.add(new MenuItem("Hồ sơ của bạn", contextPath + "/profile", "fa fa-user"));
    menuItems.add(new MenuItem("Lịch hẹn đã đặt", contextPath + "/customer/appointments", "fa fa-calendar"));
    menuItems.add(new MenuItem("Lịch sử dịch vụ", contextPath + "/customer/service-history", "fa fa-history"));
    menuItems.add(new MenuItem("Đánh giá của tôi", contextPath + "/customer/reviews", "fa fa-star"));
    menuItems.add(new MenuItem("Cài đặt tài khoản", contextPath + "/profile/settings", "fa fa-cog"));
    menuItems.add(new MenuItem()); // Divider
    menuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "fa fa-sign-out"));

    return menuItems;
  }

  /**
   * Generate menu items for Admin role
   */
  public static List<MenuItem> getAdminMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    menuItems.add(new MenuItem("Hồ sơ cá nhân", contextPath + "/profile", "fa fa-user"));
    menuItems.add(new MenuItem("Bảng điều khiển", contextPath + "/admin/dashboard", "fa fa-tachometer"));
    menuItems.add(new MenuItem("Quản lý người dùng", contextPath + "/admin/users", "fa fa-users"));
    menuItems.add(new MenuItem("Quản lý dịch vụ", contextPath + "/admin/services", "fa fa-tasks"));
    menuItems.add(new MenuItem("Báo cáo hệ thống", contextPath + "/admin/reports", "fa fa-bar-chart"));
    menuItems.add(new MenuItem("Cài đặt hệ thống", contextPath + "/admin/settings", "fa fa-cog"));
    menuItems.add(new MenuItem()); // Divider
    menuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "fa fa-sign-out"));

    return menuItems;
  }

  /**
   * Generate menu items for Manager role
   */
  public static List<MenuItem> getManagerMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    menuItems.add(new MenuItem("Hồ sơ cá nhân", contextPath + "/profile", "fa fa-user"));
    menuItems.add(new MenuItem("Bảng điều khiển", contextPath + "/admin/dashboard", "fa fa-tachometer"));
    menuItems.add(new MenuItem("Quản lý nhân viên", contextPath + "/admin/staff", "fa fa-users"));
    menuItems.add(new MenuItem("Quản lý lịch hẹn", contextPath + "/appointment", "fa fa-calendar"));
    menuItems.add(new MenuItem("Quản lý dịch vụ", contextPath + "/admin/services", "fa fa-tasks"));
    menuItems.add(new MenuItem("Báo cáo doanh thu", contextPath + "/admin/revenue-reports", "fa fa-line-chart"));
    menuItems.add(new MenuItem("Cài đặt", contextPath + "/profile/settings", "fa fa-cog"));
    menuItems.add(new MenuItem()); // Divider
    menuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "fa fa-sign-out"));

    return menuItems;
  }

  /**
   * Generate menu items for Therapist role
   */
  public static List<MenuItem> getTherapistMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    menuItems.add(new MenuItem("Hồ sơ cá nhân", contextPath + "/profile", "fa fa-user"));
    menuItems.add(new MenuItem("Lịch làm việc", contextPath + "/therapist/schedule", "fa fa-calendar"));
    menuItems.add(new MenuItem("Khách hàng của tôi", contextPath + "/therapist/clients", "fa fa-users"));
    menuItems.add(new MenuItem("Dịch vụ thực hiện", contextPath + "/therapist/services", "fa fa-hand-o-up"));
    menuItems.add(new MenuItem("Báo cáo hiệu suất", contextPath + "/therapist/performance", "fa fa-bar-chart"));
    menuItems.add(new MenuItem("Cài đặt", contextPath + "/profile/settings", "fa fa-cog"));
    menuItems.add(new MenuItem()); // Divider
    menuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "fa fa-sign-out"));

    return menuItems;
  }

  /**
   * Generate menu items for Receptionist role
   */
  public static List<MenuItem> getReceptionistMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    menuItems.add(new MenuItem("Hồ sơ cá nhân", contextPath + "/profile", "fa fa-user"));
    menuItems.add(new MenuItem("Quản lý lịch hẹn", contextPath + "/receptionist/appointments", "fa fa-calendar"));
    menuItems.add(
        new MenuItem("Đăng ký khách hàng", contextPath + "/receptionist/customer-registration", "fa fa-user-plus"));
    menuItems.add(new MenuItem("Thanh toán", contextPath + "/receptionist/payments", "fa fa-credit-card"));
    menuItems.add(new MenuItem("Liên hệ khách hàng", contextPath + "/receptionist/customer-contact", "fa fa-phone"));
    menuItems.add(new MenuItem("Cài đặt", contextPath + "/profile/settings", "fa fa-cog"));
    menuItems.add(new MenuItem()); // Divider
    menuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "fa fa-sign-out"));

    return menuItems;
  }

  /**
   * Get menu items based on user role
   */
  public static List<MenuItem> getMenuItemsByRole(String roleName, String contextPath) {
    if (roleName == null) {
      return new ArrayList<>();
    }

    switch (roleName.toUpperCase()) {
      case "ADMIN":
        return getAdminMenuItems(contextPath);
      case "MANAGER":
        return getManagerMenuItems(contextPath);
      case "THERAPIST":
        return getTherapistMenuItems(contextPath);
      case "RECEPTIONIST":
        return getReceptionistMenuItems(contextPath);
      case "CUSTOMER":
        return getCustomerMenuItems(contextPath);
      default:
        return new ArrayList<>();
    }
  }

  /**
   * Get menu items for Customer (from Customer object)
   */
  public static List<MenuItem> getCustomerMenuItems(Customer customer, String contextPath) {
    return getCustomerMenuItems(contextPath);
  }

  /**
   * Get menu items for User (from User object with role)
   */
  public static List<MenuItem> getUserMenuItems(User user, String contextPath) {
    // You'll need to get the role name from user.getRoleId()
    // This assumes you have a way to get role name from role ID
    // For now, returning admin items as example
    return getAdminMenuItems(contextPath);
  }
}