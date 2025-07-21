# Hướng Dẫn Sửa Lỗi Tài Khoản Khách Hàng Và Đường Link Promotion

## 🚨 **Vấn Đề Đã Phát Hiện**

### **1. Lỗi 500 Internal Server Error**
- **URL**: `/promotions/notification`
- **Nguyên nhân**: Thiếu taglib prefix `fn` cho JSTL functions
- **File**: `promotion_notification.jsp` dòng 114
- **Lỗi**: `The attribute prefix [fn]` không được định nghĩa

### **2. Lỗi Customer ID trong Controller**
- **File**: `CustomerPromotionController.java`
- **Nguyên nhân**: Sử dụng reflection để lấy customer ID thay vì cast trực tiếp
- **Lỗi**: `Could not get customer ID from session`

## 🔧 **Giải Pháp Đã Áp Dụng**

### **1. Sửa Lỗi JSP Taglib**

**File:** `promotion_notification.jsp`

**Trước:**
```jsp
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
```

**Sau:**
```jsp
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
```

### **2. Sửa Lỗi Customer ID**

**File:** `CustomerPromotionController.java`

**Trước:**
```java
// Lấy customer ID từ session
HttpSession session = request.getSession();
Object customerObj = session.getAttribute("customer");

if (customerObj == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

// Lấy customer ID (giả sử customer object có method getId())
Integer customerId = null;
try {
    // Sử dụng reflection để lấy customer ID
    java.lang.reflect.Method getIdMethod = customerObj.getClass().getMethod("getId");
    customerId = (Integer) getIdMethod.invoke(customerObj);
} catch (Exception e) {
    logger.warning("Could not get customer ID from session: " + e.getMessage());
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}
```

**Sau:**
```java
// Lấy customer ID từ session
HttpSession session = request.getSession();
Customer customer = (Customer) session.getAttribute("customer");

if (customer == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

// Lấy customer ID
Integer customerId = customer.getCustomerId();
```

### **3. Thêm Import Customer**

**File:** `CustomerPromotionController.java`

**Thêm:**
```java
import model.Customer;
```

## 📋 **Kiểm Tra Tài Khoản Khách Hàng**

### **1. Chạy Script Test**

```sql
-- Chạy file: test_customer_promotion_links.sql
-- Script này sẽ kiểm tra:
-- - Tài khoản khách hàng test
-- - Role và quyền truy cập
-- - Promotions có sẵn
-- - URLs có thể truy cập
```

### **2. Tài Khoản Test**

| Email | Password | Role | Status |
|-------|----------|------|--------|
| `nam.tran@email.com` | `123456` | CUSTOMER (5) | ✅ Active & Verified |
| `mai.nguyen@email.com` | `123456` | CUSTOMER (5) | ✅ Active & Verified |
| `lan.le@email.com` | `123456` | CUSTOMER (5) | ✅ Active & Verified |

### **3. URLs Có Thể Truy Cập**

| URL | Mô Tả | Quyền |
|-----|-------|-------|
| `/promotions/my-promotions` | Khuyến mãi của tôi | ✅ CUSTOMER |
| `/promotions/available` | Tất cả khuyến mãi | ✅ CUSTOMER |
| `/promotions/notification` | Thông báo khuyến mãi | ✅ CUSTOMER |
| `/apply-promotion` | Áp dụng khuyến mãi | ✅ CUSTOMER |

## 🎯 **Menu Links Trong MenuService**

### **Customer Menu Items**
```java
// Khuyến mãi của tôi
menuItems.add(new MenuItem("Khuyến mãi của tôi", 
    contextPath + "/promotions/my-promotions", "gift", "account")
    .withNotification("Mới", "red"));

// Tất cả khuyến mãi  
menuItems.add(new MenuItem("Tất cả khuyến mãi", 
    contextPath + "/promotions/available", "star", "account"));

// Thông báo khuyến mãi
menuItems.add(new MenuItem("Thông báo khuyến mãi", 
    contextPath + "/promotions/notification", "bell", "account")
    .withNotification("3", "blue"));
```

## 🔍 **JSP Files Cần Kiểm Tra**

### **1. Customer Pages**
- ✅ `my_promotions.jsp` - Khuyến mãi của tôi
- ✅ `available_promotions.jsp` - Tất cả khuyến mãi  
- ✅ `promotion_notification.jsp` - Thông báo khuyến mãi

### **2. Taglib Declarations**
Tất cả JSP files đã có đầy đủ taglib:
```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
```

## 🧪 **Cách Test**

### **1. Test Đăng Nhập**
```bash
# Đăng nhập với tài khoản khách hàng
Email: nam.tran@email.com
Password: 123456
```

### **2. Test URLs**
```bash
# Truy cập các URL promotion
http://localhost:8080/spa/promotions/my-promotions
http://localhost:8080/spa/promotions/available  
http://localhost:8080/spa/promotions/notification
```

### **3. Test Menu Navigation**
1. Đăng nhập với tài khoản khách hàng
2. Kiểm tra menu có hiển thị các link promotion
3. Click vào từng link để test

## 🔒 **Session Data Cần Kiểm Tra**

### **1. Customer Session**
```java
// Kiểm tra session có customer object
Customer customer = (Customer) session.getAttribute("customer");
if (customer != null) {
    Integer customerId = customer.getCustomerId();
    // customerId sẽ được sử dụng để lấy promotions
}
```

### **2. Authentication Status**
```java
// Kiểm tra đã đăng nhập
Boolean authenticated = (Boolean) session.getAttribute("authenticated");
if (authenticated != null && authenticated) {
    // User đã đăng nhập
}
```

## 📞 **Support**

Nếu vẫn gặp lỗi:

1. **Kiểm tra logs** trong `CustomerPromotionController`
2. **Chạy script test** `test_customer_promotion_links.sql`
3. **Verify session data** khi đăng nhập
4. **Check JSP compilation** errors

### **Debug Commands**
```bash
# Kiểm tra JSP compilation
mvn clean compile

# Kiểm tra logs
tail -f logs/application.log

# Test database connection
mysql -u root -p < test_customer_promotion_links.sql
``` 