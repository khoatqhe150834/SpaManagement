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

    menuItems.add(new MenuItem("Hồ sơ của bạn", contextPath + "/customer-dashboard", "solar:user-outline"));
    menuItems.add(new MenuItem("Lịch hẹn đã đặt", contextPath + "/appointment", "solar:calendar-outline"));
    menuItems.add(new MenuItem("Lịch sử dịch vụ", contextPath + "/customer/service-history", "solar:history-outline"));
    menuItems.add(new MenuItem("Đánh giá của tôi", contextPath + "/customer/reviews", "solar:star-outline"));
    menuItems.add(new MenuItem("Cài đặt tài khoản", contextPath + "/profile/settings", "solar:settings-outline"));
    menuItems.add(new MenuItem()); // Divider
    menuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "solar:logout-outline"));

    return menuItems;
  }

  /**
   * Generate menu items for Admin role
   */
  public static List<MenuItem> getAdminMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    menuItems.add(new MenuItem("Hồ sơ cá nhân", contextPath + "/profile", "solar:user-outline"));
    menuItems.add(new MenuItem("Bảng điều khiển", contextPath + "/admin/dashboard", "solar:widget-outline"));
    menuItems
        .add(new MenuItem("Quản lý người dùng", contextPath + "/customer/list", "solar:users-group-rounded-outline"));
    menuItems.add(new MenuItem("Quản lý dịch vụ", contextPath + "/admin/services", "solar:spa-outline"));
    menuItems.add(new MenuItem("Báo cáo hệ thống", contextPath + "/admin/reports", "solar:chart-2-outline"));
    menuItems.add(new MenuItem("Cài đặt hệ thống", contextPath + "/admin/settings", "solar:settings-outline"));
    menuItems.add(new MenuItem()); // Divider
    menuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "solar:logout-outline"));

    return menuItems;
  }

  /**
   * Generate menu items for Manager role
   */
  public static List<MenuItem> getManagerMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    menuItems.add(new MenuItem("Hồ sơ cá nhân", contextPath + "/manager-dashboard", "solar:user-outline"));
    menuItems.add(new MenuItem("Bảng điều khiển", contextPath + "/admin/dashboard", "solar:widget-outline"));
    menuItems.add(new MenuItem("Quản lý nhân viên", contextPath + "/staff", "solar:users-group-rounded-outline"));
    menuItems.add(new MenuItem("Quản lý lịch hẹn", contextPath + "/appointment", "solar:calendar-outline"));
    menuItems.add(new MenuItem("Quản lý dịch vụ", contextPath + "/servicetype", "solar:list-check-outline"));
    menuItems.add(new MenuItem("Báo cáo doanh thu", contextPath + "/admin/revenue-reports", "solar:chart-outline"));
    menuItems.add(new MenuItem("Cài đặt", contextPath + "/profile/settings", "solar:settings-outline"));
    menuItems.add(new MenuItem()); // Divider
    menuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "solar:logout-outline"));

    return menuItems;
  }

  /**
   * Generate menu items for Therapist role
   */
  public static List<MenuItem> getTherapistMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    menuItems.add(new MenuItem("Hồ sơ cá nhân", contextPath + "/therapist-dashboard", "solar:user-outline"));
    menuItems.add(new MenuItem("Lịch làm việc", contextPath + "/therapist/schedule", "solar:calendar-outline"));
    menuItems.add(
        new MenuItem("Khách hàng của tôi", contextPath + "/therapist/clients", "solar:users-group-rounded-outline"));
    menuItems.add(new MenuItem("Dịch vụ thực hiện", contextPath + "/therapist/services", "solar:heart-outline"));
    menuItems.add(new MenuItem("Báo cáo hiệu suất", contextPath + "/therapist/performance", "solar:chart-2-outline"));
    menuItems.add(new MenuItem("Cài đặt", contextPath + "/profile/settings", "solar:settings-outline"));
    menuItems.add(new MenuItem()); // Divider
    menuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "solar:logout-outline"));

    return menuItems;
  }

  /**
   * Generate menu items for Receptionist role
   */
  public static List<MenuItem> getReceptionistMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    menuItems.add(new MenuItem("Hồ sơ cá nhân", contextPath + "/profile", "solar:user-outline"));
    menuItems
        .add(new MenuItem("Quản lý lịch hẹn", contextPath + "/receptionist/appointments", "solar:calendar-outline"));
    menuItems.add(
        new MenuItem("Đăng ký khách hàng", contextPath + "/receptionist/customer-registration",
            "solar:user-plus-outline"));
    menuItems.add(new MenuItem("Thanh toán", contextPath + "/receptionist/payments", "solar:card-outline"));
    menuItems
        .add(new MenuItem("Liên hệ khách hàng", contextPath + "/receptionist/customer-contact", "solar:phone-outline"));
    menuItems.add(new MenuItem("Cài đặt", contextPath + "/profile/settings", "solar:settings-outline"));
    menuItems.add(new MenuItem()); // Divider
    menuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "solar:logout-outline"));

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