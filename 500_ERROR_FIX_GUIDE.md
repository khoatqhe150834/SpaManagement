# Hướng Dẫn Sửa Lỗi 500 Trong Promotion Details

## 🚨 **Vấn Đề Đã Phát Hiện**

### **Mô tả lỗi:**
- Lỗi 500 Internal Server Error khi truy cập trang chi tiết promotion
- Hiển thị thông báo "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau."
- Có thể do lỗi JSP, dữ liệu null, hoặc phép tính toán

### **Nguyên nhân có thể:**
1. **Lỗi JSP:** Phép tính toán phức tạp gây lỗi
2. **Dữ liệu null:** Các trường null trong database
3. **HTML trùng lặp:** File JSP có cấu trúc không đúng
4. **Biến không định nghĩa:** Sử dụng biến chưa được khởi tạo

## 🔧 **Giải Pháp Đã Áp Dụng**

### 1. **Sửa JSP Gốc**

**File:** `promotion_details.jsp`
- Đơn giản hóa các phép tính phức tạp
- Xử lý an toàn các giá trị null
- Loại bỏ progress bar phức tạp để tránh lỗi

### 2. **Cập Nhật Controller**

**PromotionController.java:**
```java
// Sử dụng file gốc promotion_details.jsp
request.getRequestDispatcher("/WEB-INF/view/admin_pages/Promotion/promotion_details.jsp").forward(request, response);
```

### 3. **Xử Lý Dữ Liệu An Toàn**

**Trong Controller:**
```java
// Đảm bảo các giá trị null được xử lý an toàn
if (promotion.getCurrentUsageCount() == null) {
    promotion.setCurrentUsageCount(0);
}
if (promotion.getUsageLimitPerCustomer() == null) {
    promotion.setUsageLimitPerCustomer(0);
}
if (promotion.getTotalUsageLimit() == null) {
    promotion.setTotalUsageLimit(0);
}
if (promotion.getMinimumAppointmentValue() == null) {
    promotion.setMinimumAppointmentValue(BigDecimal.ZERO);
}
```

### 4. **Sửa Database**

**Script:** `test_500_error_fix.sql`
```sql
-- Sửa dữ liệu null để tránh lỗi 500
UPDATE promotions 
SET current_usage_count = 0 
WHERE current_usage_count IS NULL;

UPDATE promotions 
SET usage_limit_per_customer = 0 
WHERE usage_limit_per_customer IS NULL;

UPDATE promotions 
SET total_usage_limit = 0 
WHERE total_usage_limit IS NULL;

UPDATE promotions 
SET minimum_appointment_value = 0 
WHERE minimum_appointment_value IS NULL;

UPDATE promotions 
SET customer_condition = 'ALL' 
WHERE customer_condition IS NULL;
```

## 🛠️ **Các Bước Sửa Lỗi**

### 1. **Chạy Script Database**
```bash
# Chạy script sửa dữ liệu
mysql -u username -p spa_management < test_500_error_fix.sql
```

### 2. **Restart Ứng Dụng**
```bash
# Restart Tomcat/Server để áp dụng code changes
```

### 3. **Test Thủ Công**
1. Vào trang **Danh sách khuyến mãi**
2. Click **Xem** trên một promotion
3. Kiểm tra không còn lỗi 500
4. Kiểm tra ảnh hiển thị đúng

### 4. **Kiểm Tra Log**
```bash
# Kiểm tra log lỗi
tail -f /path/to/application.log | grep "PromotionController"
```

## 🔍 **Debugging Steps**

### 1. **Kiểm Tra Database**
```sql
-- Kiểm tra dữ liệu null
SELECT 
    promotion_id,
    title,
    current_usage_count,
    usage_limit_per_customer,
    total_usage_limit,
    minimum_appointment_value,
    customer_condition
FROM promotions 
WHERE current_usage_count IS NULL 
   OR usage_limit_per_customer IS NULL 
   OR total_usage_limit IS NULL 
   OR minimum_appointment_value IS NULL
   OR customer_condition IS NULL;
```

### 2. **Kiểm Tra Log Ứng Dụng**
```bash
# Kiểm tra log Tomcat
tail -f /path/to/tomcat/logs/catalina.out

# Kiểm tra log ứng dụng
tail -f /path/to/application.log
```

### 3. **Kiểm Tra Browser**
```javascript
// Mở Developer Tools (F12)
// Vào tab Console
// Kiểm tra lỗi JavaScript
// Vào tab Network
// Kiểm tra response code
```

## 🚀 **Prevention (Ngăn Chặn Lỗi Tương Lai)**

### 1. **Validation Trong DAO**
```java
public Optional<Promotion> findById(Integer id) {
    try {
        // ... code hiện tại ...
        
        if (promotion != null) {
            // Đảm bảo giá trị mặc định
            if (promotion.getCurrentUsageCount() == null) {
                promotion.setCurrentUsageCount(0);
            }
            if (promotion.getUsageLimitPerCustomer() == null) {
                promotion.setUsageLimitPerCustomer(0);
            }
            // ... các giá trị khác ...
        }
        
        return Optional.ofNullable(promotion);
    } catch (SQLException e) {
        logger.log(Level.SEVERE, "Error finding promotion by ID: " + id, e);
        return Optional.empty();
    }
}
```

### 2. **Database Constraints**
```sql
-- Thêm constraints để tránh null
ALTER TABLE promotions 
MODIFY COLUMN current_usage_count INT NOT NULL DEFAULT 0,
MODIFY COLUMN usage_limit_per_customer INT NOT NULL DEFAULT 0,
MODIFY COLUMN total_usage_limit INT NOT NULL DEFAULT 0,
MODIFY COLUMN minimum_appointment_value DECIMAL(10,2) NOT NULL DEFAULT 0.00,
MODIFY COLUMN customer_condition VARCHAR(20) NOT NULL DEFAULT 'ALL';
```

### 3. **Error Handling Trong JSP**
```jsp
<c:catch var="error">
    <%-- Code có thể gây lỗi --%>
    <fmt:formatNumber value="${(promotion.currentUsageCount / promotion.totalUsageLimit) * 100}" maxFractionDigits="1"/>%
</c:catch>
<c:if test="${not empty error}">
    <span class="text-orange-600">0%</span>
</c:if>
```

## 📋 **Checklist Sửa Lỗi 500**

- [ ] Chạy script sửa dữ liệu database
- [ ] Restart ứng dụng
- [ ] Test trang chi tiết promotion
- [ ] Kiểm tra log lỗi
- [ ] Kiểm tra dữ liệu null
- [ ] Test với dữ liệu mới
- [ ] Kiểm tra ảnh hiển thị
- [ ] Cập nhật documentation

## 🎯 **Kết Quả Mong Đợi**

Sau khi áp dụng các cải thiện:
- ✅ Không còn lỗi 500 khi truy cập trang chi tiết
- ✅ Dữ liệu null được xử lý an toàn
- ✅ Ảnh hiển thị đúng với đường dẫn chính xác
- ✅ Phép tính toán không gây lỗi
- ✅ Log lỗi chi tiết để debug
- ✅ Fallback cho các trường hợp lỗi

## 🔧 **Các Bước Thực Hiện**

1. **Chạy script database:**
   ```bash
   mysql -u username -p spa_management < test_500_error_fix.sql
   ```

2. **Restart ứng dụng:**
   ```bash
   # Restart Tomcat/Server
   ```

3. **Test thủ công:**
   - Vào trang danh sách promotion
   - Click xem chi tiết một promotion
   - Kiểm tra không còn lỗi 500
   - Kiểm tra ảnh hiển thị

4. **Kiểm tra log:**
   ```bash
   tail -f /path/to/application.log | grep "PromotionController"
   ```

## 📊 **Monitoring**

### **Bảng Log Lỗi:**
```sql
-- Tạo bảng log lỗi
CREATE TABLE IF NOT EXISTS error_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    error_message TEXT,
    stack_trace TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    page_url VARCHAR(500),
    user_id INT,
    session_id VARCHAR(100)
);
```

### **Kiểm Tra Định Kỳ:**
```sql
-- Kiểm tra lỗi gần đây
SELECT * FROM error_logs 
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 1 DAY)
ORDER BY created_at DESC;
``` 