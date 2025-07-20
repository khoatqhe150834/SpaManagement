# Hướng Dẫn Sửa Lỗi Phân Quyền Promotion

## 🚨 **Vấn Đề Đã Phát Hiện**

Lỗi **403 Forbidden** khi khách hàng truy cập `/spa/promotions/my-promotions` do cấu hình phân quyền sai trong `AuthorizationFilter.java`.

### **Nguyên Nhân:**
- URL `/promotions` chỉ cho phép ADMIN, MANAGER, MARKETING truy cập
- Khách hàng (CUSTOMER_ID = 5) bị chặn truy cập
- Thiếu pattern `/promotions/*` cho khách hàng

## 🔧 **Giải Pháp Đã Áp Dụng**

### **1. Sửa URL Role Mappings**

**File:** `AuthorizationFilter.java`

**Trước:**
```java
URL_ROLE_MAPPINGS.put("/promotions", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.MARKETING_ID)));
```

**Sau:**
```java
// Promotion management (Admin/Manager/Marketing only)
URL_ROLE_MAPPINGS.put("/promotion", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.MARKETING_ID)));

// Customer promotions (Customer can access)
URL_ROLE_MAPPINGS.put("/promotions", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.MARKETING_ID, RoleConstants.CUSTOMER_ID)));
```

### **2. Thêm Pattern Role Mappings**

**File:** `AuthorizationFilter.java`

**Thêm:**
```java
// Promotion patterns (Admin/Manager/Marketing can manage, Customer can view)
PATTERN_ROLE_MAPPINGS.put("/promotions/*", new HashSet<>(Arrays.asList(RoleConstants.ADMIN_ID, RoleConstants.MANAGER_ID, RoleConstants.MARKETING_ID, RoleConstants.CUSTOMER_ID)));
```

## 📋 **Phân Quyền Sau Khi Sửa**

### **✅ Có Quyền Truy Cập `/promotions/*`:**

| Role | Role ID | Quyền Truy Cập |
|------|---------|----------------|
| **ADMIN** | 1 | ✅ Toàn quyền |
| **MANAGER** | 2 | ✅ Toàn quyền |
| **MARKETING** | 6 | ✅ Toàn quyền |
| **CUSTOMER** | 5 | ✅ Xem khuyến mãi |

### **❌ Không Có Quyền:**

| Role | Role ID | Lý Do |
|------|---------|-------|
| **THERAPIST** | 3 | Chỉ xem promotion được áp dụng |
| **RECEPTIONIST** | 4 | Chỉ xem promotion được áp dụng |

## 🔗 **URLs Có Thể Truy Cập**

### **Khách Hàng (CUSTOMER):**
- ✅ `/promotions/my-promotions` - Khuyến mãi của tôi
- ✅ `/promotions/available` - Tất cả khuyến mãi
- ✅ `/promotions/notification` - Thông báo khuyến mãi
- ✅ `/apply-promotion` - Áp dụng khuyến mãi
- ❌ `/promotion/list` - Quản lý khuyến mãi (chỉ admin/manager/marketing)

### **Admin/Manager/Marketing:**
- ✅ `/promotion/list` - Danh sách khuyến mãi
- ✅ `/promotion/create` - Tạo khuyến mãi
- ✅ `/promotion/edit` - Sửa khuyến mãi
- ✅ `/promotion/view` - Xem chi tiết
- ✅ `/promotions/*` - Tất cả tính năng khách hàng

## 🧪 **Cách Test**

### **1. Test với Khách Hàng:**
```bash
# Đăng nhập với tài khoản khách hàng
Email: nam.tran@email.com
Password: 123456

# Truy cập các URL
http://localhost:8080/spa/promotions/my-promotions
http://localhost:8080/spa/promotions/available
http://localhost:8080/spa/promotions/notification
```

### **2. Test với Admin:**
```bash
# Đăng nhập với tài khoản admin
Email: admin@beautyzone.com
Password: 123456

# Truy cập tất cả URL
http://localhost:8080/spa/promotion/list
http://localhost:8080/spa/promotions/my-promotions
```

### **3. Chạy Script Test:**
```sql
-- Chạy file: test_promotion_permissions.sql
-- Script này sẽ kiểm tra:
-- - Cấu trúc roles
-- - Tài khoản test
-- - Phân quyền URLs
```

## 🔍 **Kiểm Tra Logs**

### **AuthorizationFilter Debug:**
```java
System.out.println("[DEBUG] hasPermission called: path=" + path + ", userRoleId=" + userRoleId);
System.out.println("[DEBUG] Final matched pattern: " + matchedPattern + ", allowedRoles: " + allowedRoles);
```

### **CustomerPromotionController Debug:**
```java
logger.info("GET request - PathInfo: " + pathInfo);
logger.info("CustomerPromotionController initialized successfully");
```

## ⚠️ **Lưu Ý Quan Trọng**

### **1. Restart Ứng Dụng:**
- Sau khi sửa `AuthorizationFilter.java`, **bắt buộc restart** ứng dụng
- Filter được load khi khởi động, thay đổi không có hiệu lực ngay

### **2. Clear Cache:**
- Xóa cache trình duyệt
- Xóa session cũ
- Đăng nhập lại

### **3. Kiểm Tra Session:**
- Đảm bảo customer object có trong session
- Kiểm tra `customer.getRoleId()` trả về đúng giá trị

## 🎯 **Kết Quả Mong Đợi**

### **Trước Khi Sửa:**
- ❌ 403 Forbidden khi truy cập `/promotions/my-promotions`
- ❌ Khách hàng không thể xem khuyến mãi

### **Sau Khi Sửa:**
- ✅ 200 OK khi truy cập `/promotions/my-promotions`
- ✅ Khách hàng có thể xem khuyến mãi của mình
- ✅ Khách hàng có thể xem tất cả khuyến mãi
- ✅ Khách hàng có thể nhận thông báo khuyến mãi

## 📞 **Troubleshooting**

### **Nếu vẫn bị 403:**
1. Kiểm tra logs để xem role ID
2. Đảm bảo customer có `role_id = 5`
3. Kiểm tra session có customer object
4. Restart ứng dụng

### **Nếu bị 404:**
1. Kiểm tra URL mapping trong `CustomerPromotionController`
2. Đảm bảo JSP file tồn tại
3. Kiểm tra context path

### **Nếu bị 500:**
1. Kiểm tra database connection
2. Kiểm tra DAO methods
3. Xem server logs chi tiết 