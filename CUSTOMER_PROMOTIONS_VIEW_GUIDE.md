# Hướng dẫn tính năng Khách hàng xem Khuyến mãi

## Tổng quan

Tính năng cho phép khách hàng xem danh sách khuyến mãi của mình với thông tin chi tiết về số lượt còn lại, trạng thái sử dụng và các thông tin khác.

## 🔗 **URLs và Navigation**

### **1. Khuyến mãi của tôi**
- **URL**: `/promotions/my-promotions`
- **Menu**: "Khuyến mãi của tôi" trong menu customer
- **Mô tả**: Xem khuyến mãi cá nhân với thông tin chi tiết

### **2. Tất cả khuyến mãi**
- **URL**: `/promotions/available`
- **Menu**: "Tất cả khuyến mãi" trong menu customer
- **Mô tả**: Xem tất cả khuyến mãi có sẵn

## 🎯 **Tính năng chính**

### **1. Tổng quan khuyến mãi**
- **Tổng mã khuyến mãi**: Số lượng mã có thể sử dụng
- **Mã không giới hạn**: Số mã không có giới hạn sử dụng
- **Lượt còn lại**: Tổng số lượt còn lại có thể sử dụng

### **2. Chi tiết từng mã**
- **Tên và mã khuyến mãi**
- **Loại giảm giá**: Phần trăm hoặc số tiền cố định
- **Ngày hết hạn**
- **Trạng thái**: Có thể sử dụng/Sắp áp dụng
- **Số lượt còn lại**: Hiển thị với badge màu sắc
- **Progress bar**: Hiển thị tỷ lệ đã sử dụng

### **3. Hành động**
- **Sao chép mã**: Copy mã vào clipboard
- **Đặt dịch vụ**: Link đến trang đặt dịch vụ

## 🎨 **UI/UX Features**

### **1. Badge trạng thái**
```html
<!-- Không giới hạn -->
<span class="bg-blue-100 text-blue-800">
    <i data-lucide="infinity"></i> Không giới hạn
</span>

<!-- Còn lượt -->
<span class="bg-green-100 text-green-800">
    <i data-lucide="check-circle"></i> Còn 2 lượt
</span>

<!-- Hết lượt -->
<span class="bg-red-100 text-red-800">
    <i data-lucide="x-circle"></i> Đã hết lượt
</span>
```

### **2. Progress bar**
```html
<div class="w-32">
    <div class="flex justify-between text-xs text-gray-600 mb-1">
        <span>Đã dùng: 1</span>
        <span>Giới hạn: 3</span>
    </div>
    <div class="w-full bg-gray-200 rounded-full h-2">
        <div class="bg-primary h-2 rounded-full" style="width: 33%"></div>
    </div>
</div>
```

### **3. Responsive Design**
- **Desktop**: Layout 2 cột với thông tin chi tiết
- **Mobile**: Layout 1 cột, tối ưu cho màn hình nhỏ
- **Tablet**: Layout linh hoạt

## 🔧 **Technical Implementation**

### **1. Controller (CustomerPromotionController.java)**
```java
@WebServlet(urlPatterns = {"/promotions/*", "/apply-promotion", "/remove-promotion"})

// Method xử lý khuyến mãi của khách hàng
private void handleMyPromotions(HttpServletRequest request, HttpServletResponse response) {
    // Lấy customer ID từ session
    // Gọi PromotionUsageDAO để lấy dữ liệu
    // Forward đến JSP
}
```

### **2. DAO (PromotionUsageDAO.java)**
```java
// Lấy tổng quan khuyến mãi
public Map<String, Object> getCustomerPromotionSummary(Integer customerId)

// Lấy chi tiết khuyến mãi với số lượt còn lại
public List<Map<String, Object>> getCustomerPromotionsWithRemainingCount(Integer customerId)
```

### **3. JSP (my_promotions.jsp)**
- **Tailwind CSS**: Styling hiện đại
- **Lucide Icons**: Icons đẹp và nhất quán
- **JSTL**: Logic hiển thị động
- **JavaScript**: Copy to clipboard functionality

## 📊 **Database Schema**

### **1. Bảng promotions**
```sql
CREATE TABLE promotions (
    promotion_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    promotion_code VARCHAR(50) UNIQUE,
    discount_type ENUM('PERCENTAGE', 'FIXED_AMOUNT'),
    discount_value DECIMAL(10,2),
    usage_limit_per_customer INT NULL, -- NULL = không giới hạn
    status ENUM('ACTIVE', 'INACTIVE'),
    start_date DATETIME,
    end_date DATETIME,
    -- ... other fields
);
```

### **2. Bảng promotion_usage**
```sql
CREATE TABLE promotion_usage (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    promotion_id INT,
    customer_id INT,
    used_at DATETIME,
    booking_id INT,
    payment_id INT,
    discount_amount DECIMAL(10,2),
    original_amount DECIMAL(10,2),
    final_amount DECIMAL(10,2),
    FOREIGN KEY (promotion_id) REFERENCES promotions(promotion_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
```

## 🧪 **Testing**

### **1. Chạy test script**
```sql
-- Chạy file: test_customer_promotions_view.sql
-- Script này sẽ tạo dữ liệu test và kiểm tra các query
```

### **2. Test cases**
- **Customer1**: Có 4 mã, 1 không giới hạn, 3 có giới hạn
- **Customer2**: Có 4 mã, đã dùng hết một số mã
- **Kiểm tra**: Summary và details cho cả 2 customers

### **3. Expected results**
```
Customer1 Summary:
- Total promotions: 4
- Unlimited promotions: 1
- Total remaining uses: 5

Customer2 Summary:
- Total promotions: 4
- Unlimited promotions: 1
- Total remaining uses: 2
```

## 🚀 **Deployment**

### **1. Files cần deploy**
- `CustomerPromotionController.java`
- `my_promotions.jsp`
- `MenuService.java` (cập nhật menu)
- `test_customer_promotions_view.sql`

### **2. Database setup**
```sql
-- Đảm bảo bảng promotion_usage đã có
-- Chạy test script để tạo dữ liệu mẫu
```

### **3. Configuration**
- **Session management**: Đảm bảo customer object trong session
- **Authorization**: Chỉ customer mới truy cập được
- **Error handling**: Redirect về login nếu chưa đăng nhập

## 📱 **User Flow**

### **1. Khách hàng đăng nhập**
1. Vào menu "Khuyến mãi của tôi"
2. Hệ thống kiểm tra session
3. Lấy customer ID từ session
4. Hiển thị tổng quan và danh sách khuyến mãi

### **2. Xem chi tiết**
1. Xem tổng quan: Số mã, số lượt còn lại
2. Xem từng mã: Thông tin chi tiết, trạng thái
3. Sao chép mã hoặc đặt dịch vụ

### **3. Sử dụng mã**
1. Sao chép mã từ trang "Khuyến mãi của tôi"
2. Vào trang đặt dịch vụ
3. Nhập mã khi thanh toán
4. Hệ thống tự động cập nhật số lượt còn lại

## 🔒 **Security & Validation**

### **1. Authentication**
- Kiểm tra session customer
- Redirect về login nếu chưa đăng nhập
- Validate customer ID

### **2. Authorization**
- Chỉ customer mới xem được khuyến mãi của mình
- Không thể xem khuyến mãi của customer khác

### **3. Data validation**
- Validate customer ID
- Handle null/empty data
- Error handling cho database queries

## 🎯 **Future Enhancements**

### **1. Notifications**
- Thông báo khi có khuyến mãi mới
- Reminder khi mã sắp hết hạn
- Email notification

### **2. Analytics**
- Tracking usage patterns
- Popular promotions
- Customer behavior analysis

### **3. Personalization**
- Recommend promotions based on history
- Customized offers
- Loyalty tier benefits

## 📞 **Support**

Nếu có vấn đề hoặc cần hỗ trợ:
1. Kiểm tra logs trong `CustomerPromotionController`
2. Verify database data với test script
3. Check session management
4. Review authorization settings 