# Hướng dẫn Phân quyền Promotion System

## Tổng quan

Hệ thống promotion có phân quyền rõ ràng dựa trên role của user. Chỉ những role có quyền mới có thể truy cập và quản lý promotions.

## 🔐 Phân quyền theo Role

### ✅ **Có quyền truy cập Promotion Management:**

#### **1. ADMIN (Role ID: 1)**
- ✅ **Toàn quyền**: Tạo, sửa, xóa, kích hoạt/tắt promotion
- ✅ **Truy cập**: Tất cả tính năng promotion
- ✅ **URLs**: `/promotion/*`, `/promotions/*`

#### **2. MANAGER (Role ID: 2)**
- ✅ **Quản lý**: Tạo, sửa, kích hoạt/tắt promotion
- ✅ **Truy cập**: Tất cả tính năng promotion
- ✅ **URLs**: `/promotion/*`, `/promotions/*`

#### **3. MARKETING (Role ID: 6)**
- ✅ **Quản lý**: Tạo, sửa, kích hoạt/tắt promotion
- ✅ **Truy cập**: Tất cả tính năng promotion
- ✅ **URLs**: `/promotion/*`, `/promotions/*`

### ❌ **KHÔNG có quyền truy cập Promotion Management:**

#### **4. THERAPIST (Role ID: 3)**
- ❌ **Không thể**: Truy cập promotion management
- ✅ **Chỉ có thể**: Xem promotion được áp dụng cho booking

#### **5. RECEPTIONIST (Role ID: 4)**
- ❌ **Không thể**: Truy cập promotion management
- ✅ **Chỉ có thể**: Xem promotion được áp dụng cho booking

#### **6. CUSTOMER (Role ID: 5)**
- ❌ **Không thể**: Truy cập promotion management
- ✅ **Chỉ có thể**: Sử dụng promotion qua CustomerPromotionController

## 🛡️ Cấu hình Authorization

### AuthorizationFilter.java
```java
// Marketing areas
URL_ROLE_MAPPINGS.put("/marketing", new HashSet<>(Arrays.asList(
    RoleConstants.ADMIN_ID, 
    RoleConstants.MANAGER_ID, 
    RoleConstants.MARKETING_ID
)));

URL_ROLE_MAPPINGS.put("/promotions", new HashSet<>(Arrays.asList(
    RoleConstants.ADMIN_ID, 
    RoleConstants.MANAGER_ID, 
    RoleConstants.MARKETING_ID
)));

URL_ROLE_MAPPINGS.put("/promotion", new HashSet<>(Arrays.asList(
    RoleConstants.ADMIN_ID, 
    RoleConstants.MANAGER_ID, 
    RoleConstants.MARKETING_ID
)));
```

### RoleConstants.java
```java
public class RoleConstants {
    public static final int ADMIN_ID = 1;
    public static final int MANAGER_ID = 2;
    public static final int THERAPIST_ID = 3;
    public static final int RECEPTIONIST_ID = 4;
    public static final int CUSTOMER_ID = 5;
    public static final int MARKETING_ID = 6;
}
```

## 📋 URLs và Quyền Truy cập

### Admin/Manager/Marketing URLs:
```
/promotion/list          - Danh sách promotion
/promotion/create        - Tạo promotion mới
/promotion/edit          - Sửa promotion
/promotion/view          - Xem chi tiết promotion
/promotion/activate      - Kích hoạt promotion
/promotion/deactivate    - Tắt promotion
/promotion/usage-report  - Báo cáo sử dụng
```

### Customer URLs:
```
/promotions/available    - Xem promotion có sẵn
/apply-promotion         - Áp dụng promotion
/remove-promotion        - Bỏ promotion
```

## 🔍 Kiểm tra Phân quyền

### 1. Test với Database
```sql
-- Chạy script: test_promotion_permissions.sql
-- Script này sẽ kiểm tra:
-- - Cấu trúc bảng roles
-- - Users với role marketing
-- - Quyền truy cập theo role
```

### 2. Test thủ công
1. **Đăng nhập với role ADMIN/MANAGER/MARKETING**
   - Truy cập `/promotion/list` → ✅ Thành công
   - Tạo promotion mới → ✅ Thành công
   - Sửa promotion → ✅ Thành công

2. **Đăng nhập với role THERAPIST/RECEPTIONIST**
   - Truy cập `/promotion/list` → ❌ 403 Forbidden
   - Tạo promotion mới → ❌ 403 Forbidden

3. **Đăng nhập với role CUSTOMER**
   - Truy cập `/promotion/list` → ❌ 403 Forbidden
   - Truy cập `/promotions/available` → ✅ Thành công
   - Áp dụng promotion → ✅ Thành công

## 🚨 Xử lý Lỗi Phân quyền

### 1. 403 Forbidden Error
```java
// AuthorizationFilter.java
private void handleUnauthorizedAccess(HttpServletRequest request, HttpServletResponse response,
        String path, Integer userRoleId) throws IOException, ServletException {
    
    if (isAjaxRequest(request)) {
        // Return JSON error for AJAX requests
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"error\":\"Access denied\",\"code\":403}");
    } else {
        // Redirect to appropriate error page
        if (userRoleId != null && userRoleId == RoleConstants.CUSTOMER_ID) {
            request.getRequestDispatcher("/WEB-INF/view/common/error-403.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/view/admin/error-403.jsp").forward(request, response);
        }
    }
}
```

### 2. Error Pages
- **Staff Error Page**: `/WEB-INF/view/admin/error-403.jsp`
- **Customer Error Page**: `/WEB-INF/view/common/error-403.jsp`

## 🔧 Cách Thêm Quyền Mới

### 1. Thêm Role mới
```sql
INSERT INTO roles (role_name, description) 
VALUES ('NEW_ROLE', 'Mô tả role mới');
```

### 2. Cập nhật AuthorizationFilter
```java
// Thêm URL mapping mới
URL_ROLE_MAPPINGS.put("/new-feature", new HashSet<>(Arrays.asList(
    RoleConstants.ADMIN_ID,
    RoleConstants.MANAGER_ID,
    RoleConstants.NEW_ROLE_ID
)));
```

### 3. Cập nhật RoleConstants
```java
public static final int NEW_ROLE_ID = 7;
```

## 📊 Bảng Phân quyền Chi tiết

| Chức năng | Admin | Manager | Marketing | Therapist | Receptionist | Customer |
|-----------|-------|---------|-----------|-----------|--------------|----------|
| **Xem danh sách** | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Tạo mới** | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Chỉnh sửa** | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Xem chi tiết** | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Kích hoạt/Tắt** | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Báo cáo sử dụng** | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Sử dụng promotion** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Xem promotion có sẵn** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |

## 🛠️ Troubleshooting

### Lỗi thường gặp

#### 1. "Access denied" khi truy cập promotion
```bash
# Kiểm tra:
1. User đã đăng nhập chưa?
2. User có role đúng không?
3. URL có trong authorization mapping không?
```

#### 2. Customer không thể sử dụng promotion
```bash
# Kiểm tra:
1. Customer đã đăng nhập chưa?
2. Promotion có status ACTIVE không?
3. Promotion có trong thời gian hiệu lực không?
```

#### 3. Marketing user không thể truy cập
```bash
# Kiểm tra:
1. User có role_id = 6 không?
2. Role "Marketing" có tồn tại trong database không?
3. AuthorizationFilter có được load không?
```

### Debug Authorization
```java
// Thêm log trong AuthorizationFilter
System.out.println("[DEBUG] User Role: " + userRoleId);
System.out.println("[DEBUG] Request Path: " + path);
System.out.println("[DEBUG] Has Permission: " + hasPermission(path, userRoleId));
```

## ✅ Kết luận

Phân quyền promotion đã được cấu hình đúng:
- ✅ **Admin, Manager, Marketing**: Có thể quản lý promotion
- ✅ **Therapist, Receptionist**: Không thể quản lý promotion
- ✅ **Customer**: Chỉ có thể sử dụng promotion
- ✅ **Security**: Được bảo vệ bởi AuthorizationFilter
- ✅ **Error Handling**: Xử lý lỗi phân quyền đầy đủ

Bây giờ bạn có thể test phân quyền promotion với các role khác nhau! 