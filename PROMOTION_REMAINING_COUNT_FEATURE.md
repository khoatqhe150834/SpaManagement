# Tính năng Tính Số Lượng Mã Khuyến Mãi Còn Lại

## Tổng quan

Tính năng này cho phép hệ thống tự động tính toán và hiển thị số lượng mã khuyến mãi còn lại cho từng khách hàng. Hệ thống sẽ tự động trừ số lượng khi khách hàng sử dụng mã.

## Tính năng chính

### ✅ **1. Tính toán số lượng còn lại**
- Tự động tính số lượt sử dụng còn lại cho từng khách hàng
- Hỗ trợ cả mã có giới hạn và không giới hạn
- Real-time cập nhật khi khách hàng sử dụng mã

### ✅ **2. Hiển thị trong Customer Detail View**
- Tổng quan số lượng mã có sẵn
- Chi tiết từng mã với số lượt còn lại
- Progress bar hiển thị mức độ sử dụng
- Thống kê tổng hợp

### ✅ **3. Tự động trừ số lượng**
- Khi khách hàng áp dụng mã → tự động trừ số lượng
- Cập nhật `current_usage_count` trong bảng `promotions`
- Ghi nhận vào bảng `promotion_usage` để tracking

## Cấu trúc Database

### Bảng `promotions`
```sql
-- Các cột liên quan đến giới hạn sử dụng
`usage_limit_per_customer` int DEFAULT NULL,    -- Giới hạn per customer
`total_usage_limit` int DEFAULT NULL,           -- Tổng giới hạn
`current_usage_count` int DEFAULT '0',          -- Số lần đã sử dụng
```

### Bảng `promotion_usage`
```sql
-- Tracking chi tiết việc sử dụng
`usage_id` int NOT NULL AUTO_INCREMENT,
`promotion_id` int NOT NULL,
`customer_id` int NOT NULL,
`discount_amount` decimal(10,2) NOT NULL,
`original_amount` decimal(10,2) NOT NULL,
`final_amount` decimal(10,2) NOT NULL,
`used_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
```

## API Methods

### PromotionUsageDAO.java

#### 1. Tính số lượng còn lại cho một mã cụ thể
```java
public Integer getRemainingUsageCount(Integer promotionId, Integer customerId)
```
**Trả về:**
- `null`: Mã không giới hạn
- `0`: Đã hết lượt
- `> 0`: Số lượt còn lại

#### 2. Lấy tất cả mã với số lượng còn lại
```java
public List<Map<String, Object>> getCustomerPromotionsWithRemainingCount(Integer customerId)
```
**Trả về:** Danh sách mã với thông tin:
- `promotionId`, `title`, `promotionCode`
- `discountType`, `discountValue`
- `usageLimitPerCustomer`, `usedCount`, `remainingCount`
- `status`, `startDate`, `endDate`

#### 3. Thống kê tổng hợp
```java
public Map<String, Object> getCustomerPromotionSummary(Integer customerId)
```
**Trả về:**
- `totalPromotions`: Tổng số mã có sẵn
- `unlimitedPromotions`: Số mã không giới hạn
- `totalRemainingUses`: Tổng lượt còn lại

## Cách sử dụng

### 1. Trong Customer Detail View
```java
// Trong CustomerManagementController.handleViewCustomerDetail()
PromotionUsageDAO promotionUsageDAO = new PromotionUsageDAO();
Map<String, Object> promotionSummary = promotionUsageDAO.getCustomerPromotionSummary(customerId);
List<Map<String, Object>> customerPromotions = promotionUsageDAO.getCustomerPromotionsWithRemainingCount(customerId);

request.setAttribute("promotionSummary", promotionSummary);
request.setAttribute("customerPromotions", customerPromotions);
```

### 2. Trong PromotionService
```java
// Tự động cập nhật khi áp dụng mã
public PromotionApplicationResult applyPromotionCode(String promotionCode, Integer customerId, 
                                                   BigDecimal originalAmount, Integer paymentId, Integer bookingId) {
    // ... validation logic ...
    
    // Ghi nhận sử dụng
    PromotionUsage usage = new PromotionUsage(promotion.getPromotionId(), customerId, 
                                            discountAmount, originalAmount, finalAmount);
    promotionUsageDAO.save(usage);
    
    // Cập nhật số lượng
    updatePromotionUsageCount(promotion.getPromotionId());
    
    return result;
}
```

## Giao diện hiển thị

### 1. Tổng quan trong Account Status
```
Khuyến mãi có sẵn: 5 mã (12 lượt còn lại)
```

### 2. Chi tiết từng mã
```
┌─────────────────────────────────────────────────────────┐
│ Khuyến mãi mùa hè                    [Còn 2 lượt]      │
│ Mã: SUMMER20                                           │
│ Giảm 20% • Hết hạn: 31/12/2024                        │
│ Đã dùng: 1/3                                           │
│ ████████████████████████████████████████████████████████ │
└─────────────────────────────────────────────────────────┘
```

### 3. Thống kê tổng hợp
```
┌─────────────┬─────────────┬─────────────┐
│   5 mã     │  2 mã       │  12 lượt    │
│  khuyến mãi │ không giới  │  còn lại    │
│             │  hạn        │             │
└─────────────┴─────────────┴─────────────┘
```

## Test

### Chạy script test
```sql
-- Chạy file: test_promotion_remaining_count.sql
-- Script này sẽ tạo dữ liệu test và kiểm tra các query
```

### Kết quả mong đợi
- Customer 1: TEST1 còn 1 lượt, TEST2 không giới hạn, TEST3 còn 2 lượt
- Customer 2: TEST1 còn 2 lượt, TEST2 không giới hạn, TEST3 hết lượt

## Lưu ý quan trọng

### 1. Performance
- Sử dụng indexes cho các query phức tạp
- Cache kết quả nếu cần thiết
- Pagination cho danh sách dài

### 2. Data Consistency
- Sử dụng transaction khi cập nhật nhiều bảng
- Backup dữ liệu trước khi chạy migration
- Validate dữ liệu đầu vào

### 3. Security
- Kiểm tra quyền truy cập customer data
- Validate customer ID trước khi query
- Log các thao tác quan trọng

## Troubleshooting

### Lỗi thường gặp

#### 1. Số lượng không cập nhật
```sql
-- Kiểm tra bảng promotion_usage
SELECT * FROM promotion_usage WHERE customer_id = ? AND promotion_id = ?;

-- Kiểm tra current_usage_count
SELECT current_usage_count FROM promotions WHERE promotion_id = ?;
```

#### 2. Query chậm
```sql
-- Kiểm tra indexes
SHOW INDEX FROM promotion_usage;
SHOW INDEX FROM promotions;

-- Tạo index nếu cần
CREATE INDEX idx_customer_promotion ON promotion_usage(customer_id, promotion_id);
```

#### 3. Dữ liệu không khớp
```sql
-- Đồng bộ current_usage_count với promotion_usage
UPDATE promotions p 
SET current_usage_count = (
    SELECT COUNT(*) FROM promotion_usage pu 
    WHERE pu.promotion_id = p.promotion_id
);
```

## Migration

### Nếu chưa có bảng promotion_usage
```sql
-- Chạy file: create_promotion_usage_table.sql
-- Script này sẽ tạo bảng và indexes cần thiết
```

### Nếu cần cập nhật dữ liệu hiện có
```sql
-- Đồng bộ current_usage_count
UPDATE promotions p 
SET current_usage_count = (
    SELECT COUNT(*) FROM promotion_usage pu 
    WHERE pu.promotion_id = p.promotion_id
);
``` 