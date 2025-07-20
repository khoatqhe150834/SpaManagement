# Tính năng Customer Condition trong Promotion System

## Tổng quan

Tính năng `customer_condition` cho phép admin thiết lập điều kiện áp dụng khuyến mãi dựa trên loại khách hàng (cá nhân, cặp đôi, nhóm).

## Các giá trị có thể có

- **ALL**: Áp dụng cho tất cả khách hàng
- **INDIVIDUAL**: Chỉ áp dụng cho khách hàng cá nhân (1 người)
- **COUPLE**: Chỉ áp dụng cho khách hàng đi cặp (2 người)
- **GROUP**: Chỉ áp dụng cho khách hàng đi nhóm (3+ người)

## Cài đặt Database

### 1. Chạy script SQL
```sql
-- Chạy file: add_customer_condition_column.sql
-- Script này sẽ tự động kiểm tra và thêm cột nếu chưa có
```

### 2. Kiểm tra kết quả
```sql
DESCRIBE promotions;
SELECT promotion_id, title, promotion_code, customer_condition, status 
FROM promotions LIMIT 5;
```

## Cập nhật Code

### 1. Model (Promotion.java)
✅ Đã có field `customerCondition` và getter/setter

### 2. DAO (PromotionDAO.java)
✅ Đã handle cột `customer_condition` với fallback logic
- Tự động kiểm tra cột có tồn tại không
- Set default value "ALL" nếu cột chưa có
- Map đầy đủ trong tất cả các method

### 3. Service (PromotionService.java)
✅ Đã có validation logic
- Validate customer condition trong `validatePromotion()`
- Placeholder cho logic kiểm tra booking data thực tế

### 4. Controllers
✅ Đã handle trong cả admin và customer controllers
- **PromotionController**: Validation và CRUD operations
- **CustomerPromotionController**: Áp dụng promotion với validation

### 5. JSP Views
✅ Đã có UI cho `customer_condition`
- Form tạo/sửa promotion
- Hiển thị thông tin promotion
- Danh sách promotion cho khách hàng

## Sử dụng

### 1. Tạo Promotion với Customer Condition
```java
Promotion promotion = new Promotion();
promotion.setTitle("Khuyến mãi cặp đôi");
promotion.setCustomerCondition("COUPLE");
// ... các field khác
promotionDAO.save(promotion);
```

### 2. Validate Promotion
```java
PromotionService service = new PromotionService();
PromotionApplicationResult result = service.previewPromotion(
    "COUPLE20", 
    customerId, 
    totalAmount
);

if (result.isSuccess()) {
    // Áp dụng promotion
    BigDecimal discount = result.getDiscountAmount();
    BigDecimal finalAmount = result.getFinalAmount();
}
```

### 3. Kiểm tra điều kiện khách hàng
```java
// Trong PromotionService.validateCustomerCondition()
switch (customerCondition) {
    case "INDIVIDUAL":
        // TODO: Kiểm tra booking có 1 người
        break;
    case "COUPLE":
        // TODO: Kiểm tra booking có 2 người
        break;
    case "GROUP":
        // TODO: Kiểm tra booking có 3+ người
        break;
}
```

## TODO: Hoàn thiện Logic Validation

### 1. Booking Data Integration
Cần implement logic thực tế để kiểm tra số lượng người trong booking:

```java
// Ví dụ logic cần implement
private String validateCustomerCondition(String customerCondition, Integer customerId) {
    // Lấy booking hiện tại của customer
    Booking currentBooking = bookingDAO.getCurrentBooking(customerId);
    
    if (currentBooking == null) {
        return "Không tìm thấy booking để kiểm tra điều kiện";
    }
    
    int numberOfPeople = currentBooking.getNumberOfPeople();
    
    switch (customerCondition) {
        case "INDIVIDUAL":
            return numberOfPeople == 1 ? null : "Khuyến mãi chỉ áp dụng cho 1 người";
        case "COUPLE":
            return numberOfPeople == 2 ? null : "Khuyến mãi chỉ áp dụng cho 2 người";
        case "GROUP":
            return numberOfPeople >= 3 ? null : "Khuyến mãi chỉ áp dụng cho nhóm 3+ người";
        default:
            return null; // ALL condition
    }
}
```

### 2. Booking Model Integration
Cần thêm field `numberOfPeople` vào Booking model và cập nhật booking creation process.

## Testing

### 1. Test Database
```sql
-- Test tạo promotion với customer condition
INSERT INTO promotions (
    title, promotion_code, discount_type, discount_value, 
    description, status, start_date, end_date, customer_condition
) VALUES (
    'Test Couple Promotion', 'COUPLE20', 'PERCENTAGE', 20.00,
    'Test description', 'ACTIVE', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 'COUPLE'
);

-- Test query
SELECT * FROM promotions WHERE customer_condition = 'COUPLE';
```

### 2. Test Java Code
```java
// Test DAO
PromotionDAO dao = new PromotionDAO();
Optional<Promotion> promo = dao.findByCode("COUPLE20");
if (promo.isPresent()) {
    System.out.println("Customer condition: " + promo.get().getCustomerCondition());
}

// Test Service
PromotionService service = new PromotionService();
PromotionApplicationResult result = service.previewPromotion("COUPLE20", 1, new BigDecimal("1000000"));
System.out.println("Valid: " + result.isSuccess());
```

## Lưu ý

1. **Backward Compatibility**: Code đã handle trường hợp cột chưa tồn tại
2. **Default Value**: Tất cả promotion cũ sẽ có `customer_condition = 'ALL'`
3. **Validation**: Có validation ở cả frontend và backend
4. **UI**: Đã có dropdown cho admin chọn customer condition
5. **Logging**: Có log warning khi cột chưa tồn tại

## Troubleshooting

### Lỗi "Column customer_condition not found"
- Chạy script `add_customer_condition_column.sql`
- Kiểm tra database connection
- Restart application

### Lỗi validation
- Kiểm tra giá trị trong dropdown (ALL, INDIVIDUAL, COUPLE, GROUP)
- Kiểm tra constraint trong database
- Xem log để debug

### Logic validation chưa hoạt động
- Hiện tại chỉ là placeholder
- Cần implement logic thực tế với booking data
- Cần thêm field `numberOfPeople` vào Booking model 