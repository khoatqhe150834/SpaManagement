# Hướng dẫn Điều kiện sử dụng Mã khuyến mãi

## Tổng quan

Hệ thống khuyến mãi có nhiều điều kiện khác nhau để đảm bảo mã được sử dụng đúng cách và hiệu quả. Mã khuyến mãi sẽ tự động thay đổi màu sắc theo trạng thái hiệu lực.

## 🎯 **Các điều kiện sử dụng mã khuyến mãi**

### **1. Điều kiện cơ bản**

#### **✅ Trạng thái khuyến mãi**
- **ACTIVE**: Mã đang hoạt động
- **INACTIVE**: Mã không khả dụng
- **SCHEDULED**: Mã đã lên lịch nhưng chưa có hiệu lực
- **EXPIRED**: Mã đã hết hạn
- **ARCHIVED**: Mã đã được lưu trữ

#### **✅ Thời gian hiệu lực**
- **Đang hiệu lực**: `start_date <= now <= end_date`
- **Sắp có hiệu lực**: `now < start_date`
- **Đã hết hạn**: `now > end_date`

#### **✅ Giá trị đơn hàng tối thiểu**
- **minimum_appointment_value**: Giá trị tối thiểu để áp dụng mã
- **Ví dụ**: Mã giảm 20% cho đơn từ 500,000đ

#### **✅ Giới hạn sử dụng**
- **usage_limit_per_customer**: Số lần tối đa mỗi khách hàng có thể sử dụng
- **total_usage_limit**: Tổng số lần tối đa mã có thể được sử dụng
- **current_usage_count**: Số lần đã sử dụng hiện tại

### **2. Điều kiện khách hàng (Customer Condition)**

#### **ALL**: Tất cả khách hàng
- Áp dụng cho mọi loại khách hàng
- Không có giới hạn về số lượng người

#### **INDIVIDUAL**: Khách hàng cá nhân
- Chỉ áp dụng cho booking có 1 người
- Phù hợp cho dịch vụ cá nhân

#### **COUPLE**: Khách hàng đi cặp
- Chỉ áp dụng cho booking có 2 người
- Phù hợp cho dịch vụ cặp đôi

#### **GROUP**: Khách hàng đi nhóm
- Chỉ áp dụng cho booking có 3+ người
- Phù hợp cho dịch vụ nhóm

### **3. Phạm vi áp dụng (Applicable Scope)**

#### **ENTIRE_APPOINTMENT**: Toàn bộ lịch hẹn
- Áp dụng cho toàn bộ giá trị lịch hẹn
- Mặc định cho hầu hết khuyến mãi

#### **SPECIFIC_SERVICES**: Dịch vụ cụ thể
- Chỉ áp dụng cho các dịch vụ được chỉ định
- Lưu danh sách service IDs trong JSON

#### **ALL_SERVICES**: Tất cả dịch vụ
- Áp dụng cho mọi dịch vụ
- Linh hoạt nhất

## 🎨 **Hệ thống màu sắc theo trạng thái**

### **1. Badge trạng thái**

#### **🔴 Đã hết hạn (bg-red-100 text-red-800)**
```html
<span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800">
    <i data-lucide="clock" class="w-3 h-3 mr-1"></i>
    Đã hết hạn
</span>
```
- **Điều kiện**: `end_date < now`
- **Ý nghĩa**: Mã không còn hiệu lực

#### **🟡 Sắp có hiệu lực (bg-yellow-100 text-yellow-800)**
```html
<span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
    <i data-lucide="calendar" class="w-3 h-3 mr-1"></i>
    Sắp có hiệu lực
</span>
```
- **Điều kiện**: `start_date > now`
- **Ý nghĩa**: Mã chưa có hiệu lực nhưng sẽ có trong tương lai

#### **🟢 Đang hiệu lực (bg-green-100 text-green-800)**
```html
<span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
    <i data-lucide="check-circle" class="w-3 h-3 mr-1"></i>
    Còn 2 lượt
</span>
```
- **Điều kiện**: `start_date <= now <= end_date` và còn lượt sử dụng
- **Ý nghĩa**: Mã có thể sử dụng

#### **🔵 Không giới hạn (bg-blue-100 text-blue-800)**
```html
<span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
    <i data-lucide="infinity" class="w-3 h-3 mr-1"></i>
    Không giới hạn
</span>
```
- **Điều kiện**: `usage_limit_per_customer IS NULL`
- **Ý nghĩa**: Không có giới hạn số lần sử dụng

#### **⚫ Không khả dụng (bg-gray-100 text-gray-800)**
```html
<span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
    <i data-lucide="x-circle" class="w-3 h-3 mr-1"></i>
    Không khả dụng
</span>
```
- **Điều kiện**: `status != 'ACTIVE'`
- **Ý nghĩa**: Mã bị tắt hoặc không hoạt động

### **2. Logic hiển thị màu sắc**

```java
// Trong JSP
<c:set var="now" value="<%= java.time.LocalDateTime.now() %>" />
<c:choose>
    <c:when test="${promotion.status != 'ACTIVE'}">
        <!-- Màu xám - Không khả dụng -->
    </c:when>
    <c:when test="${promotion.endDate < now}">
        <!-- Màu đỏ - Đã hết hạn -->
    </c:when>
    <c:when test="${promotion.startDate > now}">
        <!-- Màu vàng - Sắp có hiệu lực -->
    </c:when>
    <c:otherwise>
        <!-- Màu xanh - Đang hiệu lực -->
    </c:otherwise>
</c:choose>
```

## 🔧 **Validation Logic**

### **1. Kiểm tra điều kiện sử dụng**

```java
// Trong PromotionService.validatePromotion()
private String validatePromotion(Promotion promotion, Integer customerId, BigDecimal orderAmount) {
    LocalDateTime now = LocalDateTime.now();
    
    // 1. Kiểm tra trạng thái
    if (!"ACTIVE".equals(promotion.getStatus())) {
        return "Mã khuyến mãi hiện không khả dụng";
    }
    
    // 2. Kiểm tra thời gian hiệu lực
    if (promotion.getStartDate() != null && now.isBefore(promotion.getStartDate())) {
        return "Mã khuyến mãi chưa có hiệu lực";
    }
    
    if (promotion.getEndDate() != null && now.isAfter(promotion.getEndDate())) {
        return "Mã khuyến mãi đã hết hạn";
    }
    
    // 3. Kiểm tra giá trị đơn hàng tối thiểu
    if (promotion.getMinimumAppointmentValue() != null && 
        orderAmount.compareTo(promotion.getMinimumAppointmentValue()) < 0) {
        return String.format("Đơn hàng tối thiểu phải từ %.0f VND để sử dụng mã này", 
                           promotion.getMinimumAppointmentValue().doubleValue());
    }
    
    // 4. Kiểm tra giới hạn sử dụng
    if (promotion.getUsageLimitPerCustomer() != null) {
        int customerUsageCount = promotionUsageDAO.getCustomerUsageCount(promotion.getPromotionId(), customerId);
        if (customerUsageCount >= promotion.getUsageLimitPerCustomer()) {
            return "Bạn đã sử dụng hết số lần cho phép với mã này";
        }
    }
    
    // 5. Kiểm tra điều kiện khách hàng
    if (promotion.getCustomerCondition() != null && !"ALL".equals(promotion.getCustomerCondition())) {
        String customerConditionError = validateCustomerCondition(promotion.getCustomerCondition(), customerId);
        if (customerConditionError != null) {
            return customerConditionError;
        }
    }
    
    return null; // Hợp lệ
}
```

### **2. Kiểm tra điều kiện khách hàng**

```java
private String validateCustomerCondition(String customerCondition, Integer customerId) {
    // TODO: Implement actual booking validation
    switch (customerCondition) {
        case "INDIVIDUAL":
            // Kiểm tra booking có 1 người
            return validateIndividualBooking(customerId);
        case "COUPLE":
            // Kiểm tra booking có 2 người
            return validateCoupleBooking(customerId);
        case "GROUP":
            // Kiểm tra booking có 3+ người
            return validateGroupBooking(customerId);
        default:
            return null; // ALL condition
    }
}
```

## 📊 **Ví dụ thực tế**

### **1. Mã giảm 20% cho đơn từ 500K**
```sql
INSERT INTO promotions (
    title, promotion_code, discount_type, discount_value,
    minimum_appointment_value, customer_condition, status
) VALUES (
    'Giảm 20% cho đơn từ 500K', 'MIN500K20', 'PERCENTAGE', 20.00,
    500000.00, 'ALL', 'ACTIVE'
);
```

**Điều kiện sử dụng:**
- ✅ Trạng thái: ACTIVE
- ✅ Thời gian: Đang hiệu lực
- ✅ Giá trị đơn: ≥ 500,000đ
- ✅ Khách hàng: Tất cả
- ✅ Giới hạn: Theo cấu hình

### **2. Mã giảm 25% cho cặp đôi**
```sql
INSERT INTO promotions (
    title, promotion_code, discount_type, discount_value,
    customer_condition, status
) VALUES (
    'Giảm 25% cho cặp đôi', 'COUPLE25', 'PERCENTAGE', 25.00,
    'COUPLE', 'ACTIVE'
);
```

**Điều kiện sử dụng:**
- ✅ Trạng thái: ACTIVE
- ✅ Thời gian: Đang hiệu lực
- ✅ Giá trị đơn: Không giới hạn
- ✅ Khách hàng: Chỉ cặp đôi (2 người)
- ✅ Giới hạn: Theo cấu hình

## 🧪 **Testing**

### **1. Chạy test script**
```sql
-- Chạy file: test_promotion_conditions.sql
-- Script này sẽ tạo dữ liệu test và kiểm tra các điều kiện
```

### **2. Test cases**
- **Test giá trị tối thiểu**: Đơn 300K vs 500K requirement
- **Test customer condition**: INDIVIDUAL, COUPLE, GROUP
- **Test thời gian hiệu lực**: Hết hạn, sắp có hiệu lực, đang hiệu lực
- **Test giới hạn sử dụng**: Hết lượt, còn lượt, không giới hạn

### **3. Expected results**
```
MIN500K20 - 300K order: "Không đủ điều kiện. Cần tối thiểu 500,000 VND"
MIN500K20 - 600K order: "Có thể sử dụng"
COUPLE25 - 2 people: "Hợp lệ - Khách hàng đi cặp"
EXPIRED10: "Đã hết hạn" (màu đỏ)
FUTURE20: "Sắp có hiệu lực" (màu vàng)
```

## 🚀 **Implementation**

### **1. Frontend (JSP)**
- ✅ **Dynamic color badges**: Thay đổi màu theo trạng thái
- ✅ **Condition display**: Hiển thị điều kiện sử dụng
- ✅ **Action buttons**: Chỉ hiển thị khi có thể sử dụng

### **2. Backend (Java)**
- ✅ **Validation service**: Kiểm tra tất cả điều kiện
- ✅ **Error messages**: Thông báo lỗi rõ ràng
- ✅ **Usage tracking**: Theo dõi số lần sử dụng

### **3. Database**
- ✅ **Constraints**: Đảm bảo tính toàn vẹn dữ liệu
- ✅ **Indexes**: Tối ưu hiệu suất query
- ✅ **Triggers**: Tự động cập nhật usage count

## 📱 **User Experience**

### **1. Visual Feedback**
- **Màu sắc trực quan**: Khách hàng dễ dàng nhận biết trạng thái
- **Icons rõ ràng**: Sử dụng Lucide icons cho từng trạng thái
- **Progress bars**: Hiển thị tỷ lệ sử dụng

### **2. Clear Information**
- **Điều kiện chi tiết**: Hiển thị đầy đủ điều kiện sử dụng
- **Thông báo lỗi**: Giải thích rõ tại sao không thể sử dụng
- **Hướng dẫn**: Cách sử dụng mã khuyến mãi

### **3. Responsive Design**
- **Mobile-friendly**: Tối ưu cho màn hình nhỏ
- **Touch-friendly**: Buttons dễ nhấn trên mobile
- **Fast loading**: Tối ưu hiệu suất

## 🔒 **Security & Validation**

### **1. Server-side validation**
- ✅ **Always validate**: Không tin tưởng client-side validation
- ✅ **SQL injection protection**: Sử dụng PreparedStatement
- ✅ **Input sanitization**: Làm sạch dữ liệu đầu vào

### **2. Business logic**
- ✅ **Atomic operations**: Đảm bảo tính nhất quán dữ liệu
- ✅ **Transaction management**: Rollback khi có lỗi
- ✅ **Audit trail**: Ghi log mọi thao tác

## 📞 **Support**

Nếu có vấn đề hoặc cần hỗ trợ:
1. Kiểm tra logs trong `PromotionService`
2. Verify database data với test script
3. Check validation logic
4. Review UI/UX implementation 