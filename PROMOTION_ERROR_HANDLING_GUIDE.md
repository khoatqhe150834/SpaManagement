# Hướng Dẫn Xử Lý Lỗi Hệ Thống Promotion

## 🚨 **Các Lỗi Thường Gặp**

### 1. **Lỗi "Đã xảy ra lỗi hệ thống"**
**Nguyên nhân:**
- Dữ liệu NULL trong database
- Phép tính toán bị lỗi (chia cho 0)
- Kết nối database bị gián đoạn
- Lỗi trong JSP expression

**Cách xử lý:**
```sql
-- Kiểm tra dữ liệu NULL
SELECT * FROM promotions 
WHERE current_usage_count IS NULL 
   OR usage_limit_per_customer IS NULL 
   OR total_usage_limit IS NULL;

-- Sửa dữ liệu NULL
UPDATE promotions 
SET current_usage_count = 0 
WHERE current_usage_count IS NULL;
```

### 2. **Lỗi Phép Tính Trong JSP**
**Nguyên nhân:**
- Chia cho 0 trong phép tính tỷ lệ sử dụng
- Giá trị null trong phép tính

**Cách xử lý:**
```jsp
<%-- Sử dụng c:choose thay vì phép tính trực tiếp --%>
<c:choose>
    <c:when test="${promotion.totalUsageLimit > 0}">
        <fmt:formatNumber value="${(promotion.currentUsageCount / promotion.totalUsageLimit) * 100}" maxFractionDigits="1"/>%
    </c:when>
    <c:otherwise>
        0%
    </c:otherwise>
</c:choose>
```

## 🔧 **Cải Thiện Xử Lý Lỗi**

### 1. **Trong Controller (PromotionController.java)**
```java
private void handleViewPromotion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    try {
        // ... code hiện tại ...
        
        if (promotionOpt.isPresent()) {
            Promotion promotion = promotionOpt.get();
            
            // Đảm bảo các giá trị null được xử lý an toàn
            if (promotion.getCurrentUsageCount() == null) {
                promotion.setCurrentUsageCount(0);
            }
            if (promotion.getUsageLimitPerCustomer() == null) {
                promotion.setUsageLimitPerCustomer(0);
            }
            // ... các giá trị khác ...
            
            request.setAttribute("promotion", promotion);
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/Promotion/promotion_details.jsp").forward(request, response);
        }
    } catch (Exception e) {
        logger.log(Level.SEVERE, "Error viewing promotion details", e);
        request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống khi tải thông tin khuyến mãi. Vui lòng thử lại sau.");
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/Promotion/promotion_details.jsp").forward(request, response);
    }
}
```

### 2. **Trong JSP (promotion_details.jsp)**
```jsp
<%-- Hiển thị thông báo lỗi --%>
<c:if test="${not empty errorMessage}">
    <div class="bg-red-50 border-l-4 border-red-400 p-4 mb-6">
        <div class="flex">
            <div class="flex-shrink-0">
                <i data-lucide="alert-circle" class="h-5 w-5 text-red-400"></i>
            </div>
            <div class="ml-3">
                <p class="text-sm text-red-700">
                    ${errorMessage}
                </p>
            </div>
        </div>
    </div>
</c:if>

<%-- Xử lý phép tính an toàn --%>
<c:choose>
    <c:when test="${promotion.totalUsageLimit > 0}">
        <fmt:formatNumber value="${(promotion.currentUsageCount / promotion.totalUsageLimit) * 100}" maxFractionDigits="1"/>%
    </c:when>
    <c:otherwise>
        <span class="text-orange-600">0%</span>
    </c:otherwise>
</c:choose>
```

## 🛠️ **Script Sửa Lỗi Database**

### 1. **Kiểm Tra Lỗi**
```sql
-- Chạy script test_promotion_error_fix.sql
USE spa_management;

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

### 2. **Sửa Lỗi Database**
```sql
-- Sửa tất cả dữ liệu null
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

## 📊 **Monitoring và Logging**

### 1. **Log Lỗi Trong Controller**
```java
private static final Logger logger = Logger.getLogger(PromotionController.class.getName());

// Log lỗi chi tiết
logger.log(Level.SEVERE, "Error viewing promotion details", e);
```

### 2. **Kiểm Tra Log**
```bash
# Kiểm tra log ứng dụng
tail -f /path/to/application.log | grep "PromotionController"

# Kiểm tra log database
tail -f /path/to/mysql.log | grep "spa_management"
```

## 🚀 **Prevention (Ngăn Chặn Lỗi)**

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

## 🔍 **Debugging Steps**

### 1. **Kiểm Tra Database**
```sql
-- Kiểm tra cấu trúc bảng
DESCRIBE promotions;

-- Kiểm tra dữ liệu
SELECT * FROM promotions WHERE promotion_id = [ID_CỦA_PROMOTION];

-- Kiểm tra constraints
SHOW CREATE TABLE promotions;
```

### 2. **Kiểm Tra Log**
```bash
# Kiểm tra log ứng dụng
grep "Error" /path/to/application.log

# Kiểm tra log database
grep "ERROR" /path/to/mysql.log
```

### 3. **Test Manual**
```bash
# Test API endpoint
curl -X GET "http://localhost:8080/promotion/view?id=1"

# Test database connection
mysql -u username -p spa_management -e "SELECT * FROM promotions LIMIT 1;"
```

## 📋 **Checklist Xử Lý Lỗi**

- [ ] Kiểm tra log ứng dụng
- [ ] Kiểm tra log database
- [ ] Kiểm tra dữ liệu null trong database
- [ ] Sửa dữ liệu null nếu có
- [ ] Kiểm tra constraints database
- [ ] Test lại tính năng
- [ ] Cập nhật documentation

## 🎯 **Kết Quả Mong Đợi**

Sau khi áp dụng các cải thiện:
- ✅ Không còn lỗi "Đã xảy ra lỗi hệ thống"
- ✅ Hiển thị thông báo lỗi rõ ràng nếu có
- ✅ Xử lý an toàn các giá trị null
- ✅ Phép tính tỷ lệ sử dụng chính xác
- ✅ Log lỗi chi tiết để debug
- ✅ Database có constraints để tránh lỗi tương lai 