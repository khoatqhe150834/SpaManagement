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
    // menuItems.add(new MenuItem("Khuyến mãi", contextPath + "/promotions",
    // "gift"));
    // menuItems.add(new MenuItem("Đặt lịch", contextPath + "/booking", "calendar-plus"));

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

    // Notifications Section
    menuItems.add(new MenuItem("Thông báo", contextPath + "/notifications", "bell", "management")
        .withNotification("0", "red"));

    // User Management (Admin - full access)
    MenuItem userMgmt = new MenuItem("Quản lý nhân viên", contextPath + "/user-management/list", "users", "management");
    userMgmt.addSubItem(new MenuItem("Danh sách nhân viên", contextPath + "/admin/staff", "list"));
    userMgmt.addSubItem(new MenuItem("Thêm nhân viên", contextPath + "/user-management/add", "user-plus"));
    userMgmt.addSubItem(new MenuItem("Phân quyền hệ thống", contextPath + "/user-management/permissions", "shield"));
    menuItems.add(userMgmt);

    // Customer Management
    MenuItem customerMgmt = new MenuItem("Quản lý thông tin khách hàng", contextPath + "/customer-management/list", "users", "management");
    customerMgmt.addSubItem(new MenuItem("Danh sách khách hàng", contextPath + "/customer-management/list", "list"));
    customerMgmt.addSubItem(new MenuItem("Thêm khách hàng", contextPath + "/customer-management/add", "user-plus"));
    customerMgmt.addSubItem(new MenuItem("Kích hoạt tài khoản", contextPath + "/customer-management/activate", "toggle-right"));
    customerMgmt.addSubItem(new MenuItem("Đặt lại mật khẩu", contextPath + "/customer-management/reset-password", "key"));
    menuItems.add(customerMgmt);

    // System Management
   

    // Financial Management Section
    menuItems.add(new MenuItem("TÀI CHÍNH", true));
    menuItems.add(new MenuItem("Báo cáo doanh thu", contextPath + "/admin/revenue", "bar-chart", "financial"));
    menuItems.add(new MenuItem("Quản lý thanh toán", contextPath + "/admin/payments", "credit-card", "financial"));
    menuItems.add(new MenuItem("Báo cáo tài chính", contextPath + "/admin/financial-reports", "file-text", "financial"));

    // Loyalty Points Management
    menuItems.add(new MenuItem("ĐIỂM THƯỞNG", true));
    menuItems.add(new MenuItem("Chính sách điểm thưởng", contextPath + "/loyalty-policy", "star", "loyalty"));
    menuItems.add(new MenuItem("Quản lý điểm thưởng", contextPath + "/loyalty-points", "gift", "loyalty"));
    menuItems.add(new MenuItem("Báo cáo điểm thưởng", contextPath + "/loyalty-report", "chart-bar", "loyalty"));

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

    // Notifications Section
    menuItems.add(new MenuItem("Thông báo", contextPath + "/notifications", "bell", "management")
        .withNotification("0", "red"));
    menuItems.add(new MenuItem("Thông báo thanh toán", contextPath + "/manager/payment-notifications", "credit-card", "management")
        .withNotification("0", "red"));

    // User Management (Manager - limited access)
    MenuItem userMgmt = new MenuItem("Quản lý nhân viên", contextPath + "/user-management/list", "users", "management");
    userMgmt.addSubItem(new MenuItem("Danh sách cấp dưới", contextPath + "/user-management/list", "list"));
    userMgmt.addSubItem(new MenuItem("Thêm nhân viên", contextPath + "/user-management/add", "user-plus"));
    userMgmt.addSubItem(new MenuItem("Thông tin cá nhân", contextPath + "/user-management/view?id=self", "user"));
    menuItems.add(userMgmt);

    // Customer Management
    MenuItem customerMgmt = new MenuItem("Quản lý thông tin khách hàng", contextPath + "/customer-management/list", "users", "management");
    customerMgmt.addSubItem(new MenuItem("Danh sách khách hàng", contextPath + "/customer-management/list", "list"));
    customerMgmt.addSubItem(new MenuItem("Thêm khách hàng", contextPath + "/customer-management/add", "user-plus"));
    customerMgmt.addSubItem(new MenuItem("Kích hoạt tài khoản", contextPath + "/customer-management/activate", "toggle-right"));
    customerMgmt.addSubItem(new MenuItem("Đặt lại mật khẩu", contextPath + "/customer-management/reset-password", "key"));
    menuItems.add(customerMgmt);

    // Payment Management Section
    MenuItem paymentMgmt = new MenuItem("Quản lý thanh toán", contextPath + "/manager/payments-management", "credit-card", "payments");
    paymentMgmt.addSubItem(new MenuItem("Tất cả thanh toán", contextPath + "/manager/payments-management", "list"));
    
    paymentMgmt.addSubItem(new MenuItem("Yêu cầu hoàn tiền", contextPath + "/manager/payments-management?status=REFUNDED", "refresh-cw"));
    menuItems.add(paymentMgmt);

    // Service Management Section
    menuItems.add(new MenuItem("DỊCH VỤ & VẬN HÀNH", true));

    MenuItem serviceMgmt = new MenuItem("Quản lý dịch vụ", contextPath + "/manager/service", "sparkles", "services");
    serviceMgmt.addSubItem(new MenuItem("Menu dịch vụ", contextPath + "/manager/service", "list"));
    serviceMgmt.addSubItem(new MenuItem("Loại dịch vụ", contextPath + "/manager/servicetype", "grid"));
    serviceMgmt.addSubItem(new MenuItem("Đánh giá dịch vụ", contextPath + "/manager/service-review", "star"));
    serviceMgmt
        .addSubItem(new MenuItem("Kiểm soát chất lượng", contextPath + "/manager/service/quality", "shield-check"));
    serviceMgmt.addSubItem(new MenuItem("Quản lý sản phẩm", contextPath + "/manager/service/products", "package"));
    serviceMgmt.addSubItem(new MenuItem("Thiết bị", contextPath + "/manager/service/equipment", "settings"));
    menuItems.add(serviceMgmt);

    menuItems.add(new MenuItem("Quản lý điểm thưởng", contextPath + "/manager/loyalty-points", "gift", "loyalty"));

    
    menuItems.add(new MenuItem("Quản lý phòng", contextPath + "/manager/rooms-management", "door-open", "services"));

    // Promotions Management (moved from Admin)
    MenuItem promotionMgmt = new MenuItem("Khuyến mãi", contextPath + "/promotion/list", "gift", "services");
    promotionMgmt.addSubItem(new MenuItem("Tất cả khuyến mãi", contextPath + "/promotion/list", "list"));
    promotionMgmt.addSubItem(new MenuItem("Tạo khuyến mãi", contextPath + "/promotion/create", "plus"));
    menuItems.add(promotionMgmt);

    // Operations Section
    menuItems.add(new MenuItem("VẬN HÀNH", true));
    menuItems.add(new MenuItem("Quản lý lịch hẹn", contextPath + "/manager/scheduling", "calendar-plus", "operations"));
    menuItems.add(new MenuItem("Lịch đã đặt", contextPath + "/manager/show-bookings", "calendar-check", "operations"));
    menuItems.add(new MenuItem("Báo cáo phòng ban", contextPath + "/manager/reports", "bar-chart", "operations"));
    menuItems.add(new MenuItem("Khách hàng", contextPath + "/manager/customers", "users", "operations"));
    
    // Inventory Management Section (for Manager)
    menuItems.add(new MenuItem("QUẢN LÝ KHO", true));
    menuItems.add(new MenuItem("Phê duyệt phiếu xuất kho", contextPath + "/manager-admin/inventory/issue", "check-circle", "management"));

    
    // Financial Section
    menuItems.add(new MenuItem("TÀI CHÍNH", true));

    // Payment Statistics with sub-menu
    MenuItem paymentStats = new MenuItem("Thống kê thanh toán", contextPath + "/manager/payment-statistics", "bar-chart-3", "financial");
    paymentStats.addSubItem(new MenuItem("Tổng quan doanh thu", contextPath + "/manager/payment-statistics/revenue", "trending-up", "financial"));
    paymentStats.addSubItem(new MenuItem("Phân tích phương thức", contextPath + "/manager/payment-statistics/methods", "credit-card", "financial"));
    paymentStats.addSubItem(new MenuItem("Thống kê theo thời gian", contextPath + "/manager/payment-statistics/timeline", "calendar", "financial"));
    paymentStats.addSubItem(new MenuItem("Báo cáo khách hàng", contextPath + "/manager/payment-statistics/customers", "users", "financial"));
    paymentStats.addSubItem(new MenuItem("Doanh thu dịch vụ", contextPath + "/manager/payment-statistics/services", "package", "financial"));
    menuItems.add(paymentStats);

    menuItems.add(new MenuItem("Doanh thu phòng ban", contextPath + "/manager/revenue", "trending-up", "financial"));
    menuItems.add(new MenuItem("Hoa hồng nhân viên", contextPath + "/manager/commissions", "coins", "financial"));

    // Human Resources Section (moved from Admin)
    menuItems.add(new MenuItem("NHÂN SỰ", true));
    menuItems.add(new MenuItem("Lương & Thưởng", contextPath + "/manager/payroll", "dollar-sign", "hr"));
    menuItems.add(new MenuItem("Đánh giá hiệu suất", contextPath + "/manager/performance", "trending-up", "hr"));

    // === Thêm dropdown thống kê nhân viên vào mục NHÂN SỰ ===
    MenuItem staffStatsHR = new MenuItem("Thống kê nhân viên", contextPath + "/manager/staff-statistics", "user-check", "hr");
    staffStatsHR.addSubItem(new MenuItem("Tổng số booking đã thực hiện", contextPath + "/manager/staff-statistics/bookings", "calendar-check", "hr"));
    staffStatsHR.addSubItem(new MenuItem("Tổng doanh thu cá nhân", contextPath + "/manager/staff-statistics/revenue", "dollar-sign", "hr"));
    staffStatsHR.addSubItem(new MenuItem("Điểm đánh giá trung bình & số lượng đánh giá", contextPath + "/manager/staff-statistics/reviews", "star", "hr"));
    staffStatsHR.addSubItem(new MenuItem("Số khách hàng phục vụ (mới/quay lại)", contextPath + "/manager/staff-statistics/customers", "users", "hr"));
    staffStatsHR.addSubItem(new MenuItem("Top dịch vụ đã thực hiện", contextPath + "/manager/staff-statistics/top-services", "award", "hr"));
    staffStatsHR.addSubItem(new MenuItem("Số giờ làm việc", contextPath + "/manager/staff-statistics/working-hours", "clock", "hr"));
    staffStatsHR.addSubItem(new MenuItem("Số booking bị hủy/khách không đến", contextPath + "/manager/staff-statistics/cancelled", "x-circle", "hr"));
    staffStatsHR.addSubItem(new MenuItem("Số vật tư đã sử dụng", contextPath + "/manager/staff-statistics/inventory", "package", "hr"));
    staffStatsHR.addSubItem(new MenuItem("So sánh hiệu suất với trung bình phòng ban", contextPath + "/manager/staff-statistics/compare", "bar-chart-2", "hr"));
    menuItems.add(staffStatsHR);
    // === Kết thúc thêm dropdown ===

    menuItems.add(new MenuItem("KHÁC", true));
    menuItems.add(new MenuItem("Duyệt Blog", contextPath + "/manager/blog", "file-text", "marketing"));

    // Loyalty Points Management for Manager
    menuItems.add(new MenuItem("ĐIỂM THƯỞNG", true));
    menuItems.add(new MenuItem("Quản lý điểm thưởng", contextPath + "/manager/loyalty-points", "gift", "loyalty"));

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

    // Personal Information
    menuItems.add(new MenuItem("Thông tin cá nhân", contextPath + "/user-management/view?id=self", "user", "staff"));

    // Schedule & Appointments
    
    menuItems.add(new MenuItem("Lịch làm việc", contextPath + "/therapist/show-bookings", "calendar", "staff"));
    

    // Client Management Section
    menuItems.add(new MenuItem("KHÁCH HÀNG", true));
    menuItems.add(new MenuItem("Khách hàng của tôi", contextPath + "/therapist/clients", "users", "clients"));
    menuItems.add(new MenuItem("Hồ sơ điều trị", contextPath + "/therapist/treatment-records", "file-text", "clients"));
    menuItems.add(new MenuItem("Ghi chú điều trị", contextPath + "/therapist/notes", "book-open", "clients"));

    // Inventory Section (for Therapist)
    menuItems.add(new MenuItem("VẬT TƯ", true));
    menuItems.add(new MenuItem("Xem tồn kho", contextPath + "/therapist/inventory/stock", "package", "inventory"));
    menuItems.add(new MenuItem("Đề xuất vật tư", contextPath + "/therapist/inventory/propose", "plus", "inventory"));
    menuItems.add(new MenuItem("Xác nhận nhận vật tư", contextPath + "/therapist/inventory/confirm", "check-circle", "inventory"));

    // Performance Section
    menuItems.add(new MenuItem("HIỆU SUẤT", true));
    menuItems.add(new MenuItem("Thống kê cá nhân", contextPath + "/therapist/stats", "bar-chart", "performance"));
    menuItems.add(new MenuItem("Đánh giá từ khách", contextPath + "/therapist/reviews", "star", "performance"));
    menuItems.add(new MenuItem("Hoa hồng", contextPath + "/therapist/commission", "dollar-sign", "performance"));
    menuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "log-out", "account"));

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

    // Personal Information
    menuItems.add(new MenuItem("Thông tin cá nhân", contextPath + "/user-management/view?id=self", "user", "frontdesk"));

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
    
    // Customer Management (Admin, Manager, Receptionist)
    MenuItem customerMgmt = new MenuItem("Quản lý thông tin khách hàng", contextPath + "/customer-management/list", "users", "customers");
    customerMgmt.addSubItem(new MenuItem("Danh sách khách hàng", contextPath + "/customer-management/list", "list"));
    customerMgmt.addSubItem(new MenuItem("Thêm khách hàng", contextPath + "/customer-management/add", "user-plus"));
    customerMgmt.addSubItem(new MenuItem("Kích hoạt tài khoản", contextPath + "/customer-management/activate", "toggle-right"));
    customerMgmt.addSubItem(new MenuItem("Đặt lại mật khẩu", contextPath + "/customer-management/reset-password", "key"));
    menuItems.add(customerMgmt);
    
    menuItems.add(new MenuItem("Chương trình thành viên", contextPath + "/receptionist/loyalty", "star", "customers"));

    // Inventory Section (for Receptionist)
    menuItems.add(new MenuItem("VẬT TƯ", true));
    menuItems.add(new MenuItem("Xem tồn kho", contextPath + "/receptionist/inventory/stock", "package", "inventory"));
    menuItems.add(new MenuItem("Yêu cầu xuất vật tư", contextPath + "/receptionist/inventory/request", "file-text", "inventory"));

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

    // Personal Information
    menuItems.add(new MenuItem("Thông tin cá nhân", contextPath + "/user-management/view?id=self", "user", "marketing"));

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
   * Generate menu items for INVENTORY_MANAGER role
   * Inventory management focused with comprehensive stock control
   */
  public static List<MenuItem> getInventoryManagerMenuItems(String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    // Dashboard Section
    menuItems.add(new MenuItem("QUẢN LÝ KHO", true));
    menuItems.add(new MenuItem("Dashboard", contextPath + "/dashboard", "layout-dashboard", "inventory"));

    // Inventory Management Section
    menuItems.add(new MenuItem("VẬT TƯ", true));
    
    MenuItem itemMgmt = new MenuItem("Quản lý vật tư", contextPath + "/inventory-manager/item", "package", "inventory");
    itemMgmt.addSubItem(new MenuItem("Danh sách vật tư", contextPath + "/inventory-manager/item", "list"));
    itemMgmt.addSubItem(new MenuItem("Thêm vật tư mới", contextPath + "/inventory-manager/item?action=create", "plus"));
    itemMgmt.addSubItem(new MenuItem("Vật tư sắp hết", contextPath + "/inventory-manager/item?action=low-stock", "alert-triangle"));
    menuItems.add(itemMgmt);

    MenuItem categoryMgmt = new MenuItem("Loại vật tư", contextPath + "/inventory-manager/category", "grid", "inventory");
    categoryMgmt.addSubItem(new MenuItem("Danh sách loại", contextPath + "/inventory-manager/category", "list"));
    categoryMgmt.addSubItem(new MenuItem("Thêm loại mới", contextPath + "/inventory-manager/category?action=create", "plus"));
    menuItems.add(categoryMgmt);

    MenuItem supplierMgmt = new MenuItem("Nhà cung cấp", contextPath + "/inventory-manager/supplier", "truck", "inventory");
    supplierMgmt.addSubItem(new MenuItem("Danh sách NCC", contextPath + "/inventory-manager/supplier", "list"));
    supplierMgmt.addSubItem(new MenuItem("Thêm NCC mới", contextPath + "/inventory-manager/supplier?action=create", "plus"));
    menuItems.add(supplierMgmt);

    // Stock Operations Section
    menuItems.add(new MenuItem("NHẬP XUẤT KHO", true));
    
    MenuItem receiptMgmt = new MenuItem("Phiếu nhập kho", contextPath + "/inventory-manager/receipt", "download", "operations");
    receiptMgmt.addSubItem(new MenuItem("Danh sách phiếu nhập", contextPath + "/inventory-manager/receipt", "list"));
    receiptMgmt.addSubItem(new MenuItem("Tạo phiếu nhập", contextPath + "/inventory-manager/receipt/create", "plus"));
    menuItems.add(receiptMgmt);

    MenuItem issueMgmt = new MenuItem("Phiếu xuất kho", contextPath + "/inventory-manager/issue", "upload", "operations");
    issueMgmt.addSubItem(new MenuItem("Danh sách phiếu xuất", contextPath + "/inventory-manager/issue", "list"));
    issueMgmt.addSubItem(new MenuItem("Tạo phiếu xuất", contextPath + "/inventory-manager/issue/create", "plus"));
    menuItems.add(issueMgmt);



    return menuItems;
  }

  /**
   * Generate menu items for CUSTOMER role
   * Self-service portal for customers
   */
  public static List<MenuItem> getCustomerMenuItems(Customer customer, String contextPath) {
    List<MenuItem> menuItems = new ArrayList<>();

    // Dashboard Section
    menuItems.add(new MenuItem("Dashboard", contextPath + "/dashboard", "layout-dashboard", "customer"));

    // Appointments Section
    menuItems.add(new MenuItem("Lịch hẹn của tôi", contextPath + "/customer/view", "calendar", "appointments")
        .withNotification("3", "yellow"));
    menuItems.add(new MenuItem("Dịch vụ đã đặt", contextPath + "/customer/show-bookings", "calendar-check", "appointments"));
    menuItems.add(new MenuItem("Lịch sử đặt lịch", contextPath + "/customer/booking-history", "clock", "appointments"));
    // menuItems.add(new MenuItem("Lịch sử điều trị", contextPath + "/customer/history", "history", "appointments"));

    // Account Management
    int loyaltyPoints = 0;
    if (customer != null) {
      loyaltyPoints = customer.getLoyaltyPoints();
    }
    String formattedPoints = String.format("%,d", loyaltyPoints);
    menuItems.add(new MenuItem("Điểm tích lũy", contextPath + "/customer/loyalty", "gift", "account")
        .withNotification(formattedPoints, "yellow"));
    menuItems.add(new MenuItem("Lịch sử thanh toán", contextPath + "/customer/payments", "credit-card", "account"));
    
    // Promotion Section
    MenuItem promotionMenu = new MenuItem("Kho khuyến mãi", contextPath + "/promotions/available", "star", "account")
        .withNotification("Mới", "red");

    promotionMenu.addSubItem(new MenuItem("Lịch sử khuyến mãi", contextPath + "/promotions/my-promotions", "history"));
    promotionMenu.addSubItem(new MenuItem("Thông báo khuyến mãi", contextPath + "/promotions/notification", "bell"));
    menuItems.add(promotionMenu);

    // --- Tích hợp menu đổi điểm ---
    MenuItem redeemMenu = new MenuItem("Đổi điểm lấy mã giảm giá", contextPath + "/redeem", "gift");
    redeemMenu.addSubItem(new MenuItem("Lịch sử đổi điểm", contextPath + "/redeem/history", "history"));
    menuItems.add(redeemMenu);
    // --- End tích hợp ---
    
    menuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "log-out", "account"));

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
      case "INVENTORY_MANAGER":
        return getInventoryManagerMenuItems(contextPath);
      case "CUSTOMER":
        // Bắt buộc phải dùng getCustomerMenuItems(customer, contextPath) ở nơi gọi
        return new ArrayList<>();
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
   * Get menu items for User (from User object with role)
   */
  public static List<MenuItem> getUserMenuItems(User user, String contextPath) {
    // Convert role ID to role name and get appropriate menu items
    String roleName = RoleConstants.getUserTypeFromRole(user.getRoleId());
    return getMenuItemsByRole(roleName, contextPath);
  }

  /**
   * Get sidebar-specific menu items (navigation items for main application features)
   * These are the main navigation items that should appear in the sidebar
   */
  public static List<MenuItem> getSidebarMenuItems(String roleName, String contextPath) {
    // Return the full menu items for sidebar navigation
    List<MenuItem> menuItems = getMenuItemsByRole(roleName, contextPath);

    // Update notification counts for managers and admins
    if ("ADMIN".equals(roleName) || "MANAGER".equals(roleName)) {
      updateNotificationCounts(menuItems);
    }

    return menuItems;
  }

  /**
   * Update notification counts for menu items
   */
  private static void updateNotificationCounts(List<MenuItem> menuItems) {
    try {
      // This would be called from a service to get actual counts
      // For now, we'll set default values that can be updated via JavaScript
      for (MenuItem item : menuItems) {
        if ("Thông báo".equals(item.getLabel())) {
          item.withNotification("0", "red");
        } else if ("Thông báo thanh toán".equals(item.getLabel())) {
          item.withNotification("0", "red");
        }
      }
    } catch (Exception e) {
      // Log error but don't break menu rendering
      System.err.println("Error updating notification counts: " + e.getMessage());
    }
  }

  /**
   * Get avatar dropdown-specific menu items (user-specific actions only)
   * These are personal/account actions that should appear in the user avatar dropdown
   */
  public static List<MenuItem> getAvatarDropdownMenuItems(String roleName, String contextPath) {
    List<MenuItem> avatarMenuItems = new ArrayList<>();

    if (roleName == null) {
      return avatarMenuItems;
    }

    switch (roleName.toUpperCase()) {
      case "ADMIN":
      avatarMenuItems.add(new MenuItem("Trang điều khiển", contextPath + "/dashboard", "bar-chart"));
        avatarMenuItems.add(new MenuItem("Hồ sơ cá nhân", contextPath + "/profile", "user"));
        avatarMenuItems.add(new MenuItem("Thay đổi mật khẩu", contextPath + "/password/change", "key"));
        avatarMenuItems.add(new MenuItem()); // Divider
        avatarMenuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "log-out"));
        break;

      case "MANAGER":
              avatarMenuItems.add(new MenuItem("Trang điều khiển", contextPath + "/dashboard", "bar-chart"));

        avatarMenuItems.add(new MenuItem("Hồ sơ cá nhân", contextPath + "/profile", "user"));
        avatarMenuItems.add(new MenuItem("Thay đổi mật khẩu", contextPath + "/password/change", "key"));
        avatarMenuItems.add(new MenuItem()); // Divider
        
        avatarMenuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "log-out"));
        break;

      case "THERAPIST":
avatarMenuItems.add(new MenuItem("Trang điều khiển", contextPath + "/dashboard", "bar-chart"));
        avatarMenuItems.add(new MenuItem("Hồ sơ cá nhân", contextPath + "/profile", "user"));
        avatarMenuItems.add(new MenuItem("Thay đổi mật khẩu", contextPath + "/password/change", "key"));
        avatarMenuItems.add(new MenuItem()); // Divider
        avatarMenuItems.add(new MenuItem("Lịch cá nhân", contextPath + "/therapist/schedule", "calendar"));
        
        avatarMenuItems.add(new MenuItem()); // Divider
        avatarMenuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "log-out"));
        break;

      case "RECEPTIONIST":
      avatarMenuItems.add(new MenuItem("Trang điều khiển", contextPath + "/dashboard", "bar-chart"));
        avatarMenuItems.add(new MenuItem("Hồ sơ cá nhân", contextPath + "/profile", "user"));
        avatarMenuItems.add(new MenuItem("Thay đổi mật khẩu", contextPath + "/password/change", "key"));
        avatarMenuItems.add(new MenuItem()); // Divider
        avatarMenuItems.add(new MenuItem("Ca làm việc", contextPath + "/receptionist/shifts", "clock"));
        avatarMenuItems.add(new MenuItem()); // Divider
        avatarMenuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "log-out"));
        break;

      case "MARKETING":
      avatarMenuItems.add(new MenuItem("Trang điều khiển", contextPath + "/dashboard", "bar-chart"));
        avatarMenuItems.add(new MenuItem("Hồ sơ cá nhân", contextPath + "/profile", "user"));
        avatarMenuItems.add(new MenuItem("Thay đổi mật khẩu", contextPath + "/password/change", "key"));
        avatarMenuItems.add(new MenuItem()); // Divider
        avatarMenuItems.add(new MenuItem("Chiến dịch của tôi", contextPath + "/marketing/my-campaigns", "megaphone"));
        avatarMenuItems.add(new MenuItem()); // Divider
        avatarMenuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "log-out"));
        break;

      case "INVENTORY_MANAGER":
      avatarMenuItems.add(new MenuItem("Trang điều khiển", contextPath + "/dashboard", "bar-chart"));
        avatarMenuItems.add(new MenuItem("Hồ sơ cá nhân", contextPath + "/profile", "user"));
        avatarMenuItems.add(new MenuItem("Thay đổi mật khẩu", contextPath + "/password/change", "key"));
        avatarMenuItems.add(new MenuItem()); // Divider
        avatarMenuItems.add(new MenuItem("Báo cáo cá nhân", contextPath + "/inventory-manager/personal-reports", "file-text"));
        avatarMenuItems.add(new MenuItem()); // Divider
        avatarMenuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "log-out"));
        break;

      case "CUSTOMER":
      avatarMenuItems.add(new MenuItem("Trang điều khiển", contextPath + "/dashboard", "bar-chart"));
        avatarMenuItems.add(new MenuItem("Hồ sơ cá nhân", contextPath + "/profile", "user"));
        avatarMenuItems.add(new MenuItem("Thay đổi mật khẩu", contextPath + "/password/change", "key"));
        avatarMenuItems.add(new MenuItem()); // Divider
        avatarMenuItems.add(new MenuItem("Điểm tích lũy", contextPath + "/customer/loyalty", "gift"));
        avatarMenuItems.add(new MenuItem("Lịch sử thanh toán", contextPath + "/customer/payments", "credit-card"));
        avatarMenuItems.add(new MenuItem()); // Divider
        avatarMenuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "log-out"));
        break;

      default:
        avatarMenuItems.add(new MenuItem("Đăng xuất", contextPath + "/logout", "log-out"));
        break;
    }

    return avatarMenuItems;
  }
}