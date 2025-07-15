package model;

import java.util.ArrayList;
import java.util.List;

/**
 * Service class to generate role-based navigation menu items
 * Based on SPA_DASHBOARD_ROLE_MANAGEMENT.md specifications
 */
public class MenuService {

  public static class MenuItem {
    private String label;
    private String url;
    private String icon;
    private boolean isDivider;
    private String section; // New field for menu section grouping
    private boolean hasNotification;
    private String notificationText;
    private String notificationColor;
    private List<MenuItem> subItems; // For dropdown menus

    public MenuItem(String label, String url, String icon) {
      this.label = label;
      this.url = url;
      this.icon = icon;
      this.isDivider = false;
      this.subItems = new ArrayList<>();
    }

    public MenuItem(String label, String url, String icon, String section) {
      this.label = label;
      this.url = url;
      this.icon = icon;
      this.section = section;
      this.isDivider = false;
      this.subItems = new ArrayList<>();
    }

    public MenuItem() {
      this.isDivider = true;
      this.subItems = new ArrayList<>();
    }

    // New constructor for section headers
    public MenuItem(String section, boolean isSection) {
      if (isSection) {
        this.section = section;
        this.isDivider = false;
        this.subItems = new ArrayList<>();
      }
    }

    // Add notification support
    public MenuItem withNotification(String text, String color) {
      this.hasNotification = true;
      this.notificationText = text;
      this.notificationColor = color;
      return this;
    }

    // Add sub-item support
    public MenuItem addSubItem(MenuItem subItem) {
      this.subItems.add(subItem);
      return this;
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

    public String getSection() {
      return section;
    }

    public void setSection(String section) {
      this.section = section;
    }

    public boolean isHasNotification() {
      return hasNotification;
    }

    public void setHasNotification(boolean hasNotification) {
      this.hasNotification = hasNotification;
    }

    public String getNotificationText() {
      return notificationText;
    }

    public void setNotificationText(String notificationText) {
      this.notificationText = notificationText;
    }

    public String getNotificationColor() {
      return notificationColor;
    }

    public void setNotificationColor(String notificationColor) {
      this.notificationColor = notificationColor;
    }

    public List<MenuItem> getSubItems() {
      return subItems;
    }

    public void setSubItems(List<MenuItem> subItems) {
      this.subItems = subItems;
    }
  }

  /**
   * Generate main navigation menu items for public pages
   */
  public static List<MenuItem> getMainNavigationMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();
    menuItems.add(new MenuItem("Trang chủ", contextPath + "/", "home"));
    menuItems.add(new MenuItem("Giới thiệu", contextPath + "/about", "info"));
    menuItems.add(new MenuItem("Blog", contextPath + "/blog", "book-open"));
    menuItems.add(new MenuItem("Dịch vụ", contextPath + "/services", "sparkles"));
    // menuItems.add(new MenuItem("Khuyến mãi", contextPath + "/promotions", "gift"));
    menuItems.add(new MenuItem("Đặt lịch", contextPath + "/booking", "calendar-plus"));
   
    menuItems.add(new MenuItem("Liên hệ", contextPath + "/contact", "phone"));
    return menuItems;
  }

  /**
   * Generate menu items for ADMIN role
   * Full system access with comprehensive management capabilities
   */
  public static List<MenuItem> getAdminMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    // Dashboard Section
    menuItems.add(new MenuItem("QUẢN LÝ", true));
    menuItems.add(new MenuItem("Dashboard", contextPath + "/dashboard", "layout-dashboard", "management"));

    // User Management with sub-items
    MenuItem userAccountMgmt = new MenuItem("Quản lí tài khoản người dùng", contextPath + "/user/list", "users", "management");
    userAccountMgmt.addSubItem(new MenuItem("Tài khoản nhân viên", contextPath + "/user/list", "users"));
    userAccountMgmt.addSubItem(new MenuItem("Tài khoản khách hàng", contextPath + "/admin/customer-account", "user"));
    menuItems.add(userAccountMgmt);

    // System Management
    menuItems.add(new MenuItem("Cài đặt hệ thống", contextPath + "/admin/settings", "settings", "management"));
    menuItems.add(new MenuItem("Hoạt động hệ thống", contextPath + "/admin/activity", "activity", "management"));

    // Financial Management Section
    menuItems.add(new MenuItem("TÀI CHÍNH", true));
    menuItems.add(new MenuItem("Báo cáo doanh thu", contextPath + "/admin/revenue", "bar-chart", "financial"));
    menuItems.add(new MenuItem("Quản lý thanh toán", contextPath + "/admin/payments", "credit-card", "financial"));
    menuItems
        .add(new MenuItem("Báo cáo tài chính", contextPath + "/admin/financial-reports", "file-text", "financial"));

    return menuItems;
  }

  /**
   * Generate menu items for MANAGER role
   * Departmental management with staff and service oversight
   */
  public static List<MenuItem> getManagerMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    // Dashboard Section
    menuItems.add(new MenuItem("QUẢN LÝ", true));
    menuItems.add(new MenuItem("Dashboard", contextPath + "/dashboard", "layout-dashboard", "management"));

    // Staff Management Section
    MenuItem staffMgmt = new MenuItem("Quản lý nhân viên", contextPath + "/manager/staff", "users", "management");
    staffMgmt.addSubItem(new MenuItem("Tất cả nhân viên", contextPath + "/manager/staff/all", "users"));
    staffMgmt.addSubItem(new MenuItem("Tuyển dụng", contextPath + "/manager/staff/recruitment", "user-plus"));
    staffMgmt.addSubItem(new MenuItem("Đánh giá hiệu suất", contextPath + "/manager/staff/performance", "star"));
    staffMgmt.addSubItem(new MenuItem("Đào tạo", contextPath + "/manager/staff/training", "book-open"));
    staffMgmt.addSubItem(new MenuItem("Lịch làm việc", contextPath + "/manager/staff/schedules", "calendar"));
    menuItems.add(staffMgmt);
    // Thêm sidebar Quản lý khách hàng ngay dưới Quản lý nhân viên
    MenuItem customerMgmt = new MenuItem("Quản lý khách hàng", contextPath + "/manager/customers", "users", "management");
    customerMgmt.addSubItem(new MenuItem("Tất cả khách hàng", contextPath + "/manager/customers", "users"));
    menuItems.add(customerMgmt);
    // Service Management Section
    menuItems.add(new MenuItem("DỊCH VỤ & VẬN HÀNH", true));

    MenuItem serviceMgmt = new MenuItem("Quản lý dịch vụ", contextPath + "/manager/service", "sparkles", "services");
    serviceMgmt.addSubItem(new MenuItem("Menu dịch vụ", contextPath + "/manager/service", "list"));
    serviceMgmt.addSubItem(new MenuItem("Loại dịch vụ", contextPath + "/manager/servicetype", "grid"));
    serviceMgmt.addSubItem(new MenuItem("Quy trình điều trị", contextPath + "/manager/service/protocols", "file-text"));
    serviceMgmt
        .addSubItem(new MenuItem("Kiểm soát chất lượng", contextPath + "/manager/service/quality", "shield-check"));
    serviceMgmt.addSubItem(new MenuItem("Quản lý sản phẩm", contextPath + "/manager/service/products", "package"));
    serviceMgmt.addSubItem(new MenuItem("Thiết bị", contextPath + "/manager/service/equipment", "settings"));
    menuItems.add(serviceMgmt);

    menuItems.add(new MenuItem("Lịch hẹn phòng ban", contextPath + "/manager/appointments", "calendar", "services"));
    menuItems.add(new MenuItem("Quản lý phòng", contextPath + "/manager/rooms", "door-open", "services"));

    // Promotions Management (moved from Admin)
    MenuItem promotionMgmt = new MenuItem("Khuyến mãi", contextPath + "/promotion/list", "gift", "services");
    promotionMgmt.addSubItem(new MenuItem("Tất cả khuyến mãi", contextPath + "/promotion/list", "list"));
    promotionMgmt.addSubItem(new MenuItem("Tạo khuyến mãi", contextPath + "/promotion/add", "plus"));
    menuItems.add(promotionMgmt);

    // Operations Section
    menuItems.add(new MenuItem("VẬN HÀNH", true));
    menuItems.add(new MenuItem("Kho & Vật tư", contextPath + "/manager/inventory", "package", "operations"));
    menuItems.add(new MenuItem("Báo cáo phòng ban", contextPath + "/manager/reports", "bar-chart", "operations"));
    menuItems.add(new MenuItem("Khách hàng", contextPath + "/manager/customers", "users", "operations"));
    
    // Financial Section
    menuItems.add(new MenuItem("TÀI CHÍNH", true));
    menuItems.add(new MenuItem("Doanh thu phòng ban", contextPath + "/manager/revenue", "trending-up", "financial"));
    menuItems.add(new MenuItem("Hoa hồng nhân viên", contextPath + "/manager/commissions", "coins", "financial"));

    // Human Resources Section (moved from Admin)
    menuItems.add(new MenuItem("NHÂN SỰ", true));
    menuItems.add(new MenuItem("Lương & Thưởng", contextPath + "/manager/payroll", "dollar-sign", "hr"));
    menuItems.add(new MenuItem("Đánh giá hiệu suất", contextPath + "/manager/performance", "trending-up", "hr"));

    menuItems.add(new MenuItem("KHÁC", true));
    menuItems.add(new MenuItem("Duyệt Blog", contextPath + "/manager/blog", "file-text", "marketing"));

    return menuItems;
  }

  /**
   * Generate menu items for THERAPIST role
   * Service delivery focused with client management
   */
  public static List<MenuItem> getTherapistMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    // Dashboard Section
    menuItems.add(new MenuItem("NHÂN VIÊN", true));
    menuItems.add(new MenuItem("Dashboard", contextPath + "/dashboard", "layout-dashboard", "staff"));

    // Schedule & Appointments
    menuItems.add(new MenuItem("Lịch hôm nay", contextPath + "/therapist/schedule", "clock", "staff")
        .withNotification("8", "yellow"));
    menuItems.add(new MenuItem("Lịch làm việc", contextPath + "/therapist/calendar", "calendar", "staff"));
    menuItems.add(new MenuItem("Quản lý lịch hẹn", contextPath + "/appointment", "calendar-check", "staff"));

    // Client Management Section
    menuItems.add(new MenuItem("KHÁCH HÀNG", true));
    menuItems.add(new MenuItem("Khách hàng của tôi", contextPath + "/therapist/clients", "users", "clients"));
    menuItems.add(new MenuItem("Hồ sơ điều trị", contextPath + "/therapist/treatment-records", "file-text", "clients"));
    menuItems.add(new MenuItem("Ghi chú điều trị", contextPath + "/therapist/notes", "book-open", "clients"));

    // Performance Section
    menuItems.add(new MenuItem("HIỆU SUẤT", true));
    menuItems.add(new MenuItem("Thống kê cá nhân", contextPath + "/therapist/stats", "bar-chart", "performance"));
    menuItems.add(new MenuItem("Đánh giá từ khách", contextPath + "/therapist/reviews", "star", "performance"));
    menuItems.add(new MenuItem("Hoa hồng", contextPath + "/therapist/commission", "dollar-sign", "performance"));

    return menuItems;
  }

  /**
   * Generate menu items for RECEPTIONIST role
   * Front desk operations and customer service
   */
  public static List<MenuItem> getReceptionistMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    // Dashboard Section
    menuItems.add(new MenuItem("LỄ TÂN", true));
    menuItems.add(new MenuItem("Dashboard", contextPath + "/dashboard", "layout-dashboard", "frontdesk"));

    // Customer Service Section
    menuItems.add(new MenuItem("DỊCH VỤ KHÁCH HÀNG", true));
    menuItems.add(new MenuItem("Đặt lịch hẹn", contextPath + "/receptionist/booking", "calendar-plus", "customer"));
    menuItems.add(new MenuItem("Check-in/Check-out", contextPath + "/receptionist/checkin", "user-check", "customer"));
    menuItems.add(new MenuItem("Quản lý lịch hẹn", contextPath + "/appointment", "calendar", "customer"));

    // Transaction Management
    menuItems.add(new MenuItem("GIAO DỊCH", true));
    menuItems.add(new MenuItem("Thanh toán", contextPath + "/receptionist/payments", "credit-card", "transactions"));
    menuItems.add(new MenuItem("Bán gói dịch vụ", contextPath + "/receptionist/packages", "package", "transactions"));
    menuItems
        .add(new MenuItem("Phiếu quà tặng", contextPath + "/receptionist/gift-certificates", "gift", "transactions"));

    // Customer Database
    menuItems.add(new MenuItem("KHÁCH HÀNG", true));
    menuItems.add(new MenuItem("Hồ sơ khách hàng", contextPath + "/receptionist/customers", "users", "customers"));
    menuItems.add(new MenuItem("Đăng ký khách mới", contextPath + "/receptionist/register", "user-plus", "customers"));
    menuItems.add(new MenuItem("Chương trình thành viên", contextPath + "/receptionist/loyalty", "star", "customers"));

    return menuItems;
  }

  /**
   * Generate menu items for MARKETING role
   * Marketing campaigns and customer acquisition
   */
  public static List<MenuItem> getMarketingMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    // Dashboard Section
    menuItems.add(new MenuItem("MARKETING", true));
    menuItems.add(new MenuItem("Dashboard", contextPath + "/dashboard", "layout-dashboard", "marketing"));
   

    // Campaign Management
    menuItems.add(new MenuItem("CHIẾN DỊCH", true));
    menuItems.add(new MenuItem("Quản lý chiến dịch", contextPath + "/marketing/campaigns", "megaphone", "campaigns"));
    menuItems.add(new MenuItem("Email Marketing", contextPath + "/marketing/email", "mail", "campaigns"));
    menuItems.add(new MenuItem("Mạng xã hội", contextPath + "/marketing/social", "share-2", "campaigns"));
    menuItems.add(new MenuItem("Quảng cáo", contextPath + "/marketing/ads", "target", "campaigns"));

    // Analytics Section
    menuItems.add(new MenuItem("PHÂN TÍCH", true));
    menuItems.add(new MenuItem("Hiệu quả chiến dịch", contextPath + "/marketing/analytics", "bar-chart", "analytics"));
    menuItems.add(new MenuItem("Khách hàng mới", contextPath + "/marketing/acquisition", "user-plus", "analytics"));
    menuItems.add(new MenuItem("Phân tích hành vi", contextPath + "/marketing/behavior", "eye", "analytics"));

    // Content Management
    menuItems.add(new MenuItem("NỘI DUNG", true));
    menuItems.add(new MenuItem("Quản lý nội dung", contextPath + "/marketing/content", "edit", "content"));
    menuItems.add(new MenuItem("Quản lý Blog", contextPath + "/marketing/blog", "file-text", "marketing"));
    menuItems.add(new MenuItem("Thư viện media", contextPath + "/marketing/media", "image", "content"));
    menuItems.add(new MenuItem("Thương hiệu", contextPath + "/marketing/brand", "heart", "content"));

    return menuItems;
  }

  /**
   * Generate menu items for CUSTOMER role
   * Self-service portal for customers
   */
  public static List<MenuItem> getCustomerMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    // Dashboard Section
    menuItems.add(new MenuItem("KHÁCH HÀNG", true));
    menuItems.add(new MenuItem("Dashboard", contextPath + "/dashboard", "layout-dashboard", "customer"));

    // Appointments Section
    menuItems.add(new MenuItem("LỊCH HẸN", true));
    menuItems.add(new MenuItem("Lịch hẹn của tôi", contextPath + "/customer/view", "calendar", "appointments")
        .withNotification("3", "yellow"));
    menuItems.add(new MenuItem("Đặt dịch vụ", contextPath + "/booking", "calendar-plus", "appointments"));
    menuItems.add(new MenuItem("Lịch sử điều trị", contextPath + "/customer/history", "history", "appointments"));

    // Account Management
    menuItems.add(new MenuItem("TÀI KHOẢN", true));
    menuItems.add(new MenuItem("Điểm tích lũy", contextPath + "/customer/loyalty", "gift", "account")
        .withNotification("2,450", "yellow"));
    menuItems.add(new MenuItem("Lịch sử thanh toán", contextPath + "/customer/payments", "credit-card", "account"));
    menuItems.add(new MenuItem("Ưu đãi đặc biệt", contextPath + "/promotions", "star", "account")
        .withNotification("Mới", "red"));

    return menuItems;
  }

  /**
   * Get menu items based on user role with enhanced role detection
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
      case "MARKETING":
        return getMarketingMenuItems(contextPath);
      case "CUSTOMER":
        return getCustomerMenuItems(contextPath);
      default:
        return new ArrayList<>();
    }
  }

  /**
   * Check if a role has access to a specific feature
   */
  public static boolean hasAccess(String roleName, String feature) {
    if (roleName == null || feature == null) {
      return false;
    }

    String role = roleName.toUpperCase();
    String featureKey = feature.toUpperCase();

    switch (role) {
      case "ADMIN":
        return true; // Admin has access to everything
      case "MANAGER":
        return !featureKey.contains("SYSTEM_SETTINGS") &&
            !featureKey.contains("USER_MANAGEMENT_ALL") &&
            !featureKey.contains("FINANCIAL_ALL");
      case "THERAPIST":
        return featureKey.contains("SCHEDULE") ||
            featureKey.contains("CLIENT") ||
            featureKey.contains("TREATMENT") ||
            featureKey.contains("PERSONAL");
      case "RECEPTIONIST":
        return featureKey.contains("CUSTOMER") ||
            featureKey.contains("APPOINTMENT") ||
            featureKey.contains("PAYMENT") ||
            featureKey.contains("BOOKING");
      case "MARKETING":
        return featureKey.contains("CAMPAIGN") ||
            featureKey.contains("CONTENT") ||
            featureKey.contains("ANALYTICS") ||
            featureKey.contains("CUSTOMER_ACQUISITION");
      case "CUSTOMER":
        return featureKey.contains("OWN") ||
            featureKey.contains("PERSONAL") ||
            featureKey.contains("BOOKING") ||
            featureKey.contains("SELF_SERVICE");
      default:
        return false;
    }
  }

  /**
   * Get grouped menu items by section for better organization
   */
  public static List<List<MenuItem>> getGroupedMenuItems(String roleName, String contextPath) {
    List<MenuItem> allItems = getMenuItemsByRole(roleName, contextPath);
    List<List<MenuItem>> groupedItems = new ArrayList<>();
    List<MenuItem> currentGroup = new ArrayList<>();

    for (MenuItem item : allItems) {
      if (item.getSection() != null && !item.getSection().isEmpty() && item.getUrl() == null) {
        // This is a section header, start a new group
        if (!currentGroup.isEmpty()) {
          groupedItems.add(new ArrayList<>(currentGroup));
          currentGroup.clear();
        }
      } else if (!item.isDivider()) {
        currentGroup.add(item);
      }
    }

    // Add the last group if not empty
    if (!currentGroup.isEmpty()) {
      groupedItems.add(currentGroup);
    }

    return groupedItems;
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
    // Convert role ID to role name and get appropriate menu items
    String roleName = RoleConstants.getUserTypeFromRole(user.getRoleId());
    return getMenuItemsByRole(roleName, contextPath);
  }
}