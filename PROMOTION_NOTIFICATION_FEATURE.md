# Tính năng Thông Báo Khuyến Mãi

## Tổng quan

Tính năng thông báo khuyến mãi cho phép hệ thống tự động gửi thông báo cho khách hàng khi có khuyến mãi mới hoặc khuyến mãi sắp hết hạn.

## 🎯 Tính năng chính

### ✅ **1. Thông báo khuyến mãi mới**
- Tự động gửi thông báo khi admin tạo promotion mới với status ACTIVE
- Hiển thị trong menu khách hàng với badge "Mới"
- Trang thông báo chi tiết với danh sách khuyến mãi mới

### ✅ **2. Thông báo khuyến mãi sắp hết hạn**
- Kiểm tra promotions sắp hết hạn trong 7 ngày tới
- Gửi thông báo cho khách hàng đã sử dụng promotion đó
- Cảnh báo để khách hàng sử dụng trước khi hết hạn

### ✅ **3. Trang thông báo khuyến mãi**
- Hiển thị danh sách khuyến mãi mới
- Thông tin chi tiết về từng khuyến mãi
- Call-to-action để khách hàng sử dụng ngay
- Tips sử dụng mã khuyến mãi

## 🏗️ Kiến trúc hệ thống

### 1. **PromotionNotificationService.java**
```java
// Service chính để gửi thông báo
public class PromotionNotificationService {
    // Gửi thông báo promotion mới
    public void notifyNewPromotion(Promotion promotion)
    
    // Gửi thông báo promotion sắp hết hạn
    public void notifyExpiringPromotions()
}
```

### 2. **PromotionController.java**
```java
// Tích hợp thông báo khi tạo promotion mới
if (success && "ACTIVE".equals(promotion.getStatus())) {
    PromotionNotificationService notificationService = new PromotionNotificationService();
    notificationService.notifyNewPromotion(promotion);
}
```

### 3. **CustomerPromotionController.java**
```java
// Route để hiển thị trang thông báo
case "notification":
    handleShowNotification(request, response);
    break;
```

### 4. **promotion_notification.jsp**
- Trang hiển thị thông báo khuyến mãi cho khách hàng
- Responsive design với Bootstrap
- Chia sẻ khuyến mãi với bạn bè

## 📱 Giao diện người dùng

### Menu khách hàng
```
Khuyến mãi của tôi [Mới] 🔴
Tất cả khuyến mãi ⭐
Thông báo khuyến mãi [3] 🔵
```

### Trang thông báo
- **Header**: "🎉 Bạn Có Mã Giảm Giá Mới!"
- **Danh sách khuyến mãi**: Hiển thị từng khuyến mãi với thông tin chi tiết
- **Call-to-action**: "Xem Tất Cả Khuyến Mãi", "Đặt Dịch Vụ Ngay"
- **Tips**: Hướng dẫn sử dụng mã khuyến mãi

## 🔧 Cách sử dụng

### Cho Admin/Manager
1. Tạo promotion mới với status "ACTIVE"
2. Hệ thống tự động gửi thông báo cho khách hàng
3. Log thông tin gửi thông báo

### Cho Khách hàng
1. Đăng nhập vào tài khoản
2. Vào menu "Thông báo khuyến mãi"
3. Xem danh sách khuyến mãi mới
4. Sử dụng mã khuyến mãi khi đặt dịch vụ

## 🚀 Mở rộng tương lai

### 1. **Email Notification**
```java
// Gửi email thông báo
public void sendEmailNotification(String email, Promotion promotion) {
    // Sử dụng EmailService để gửi email
    emailService.sendPromotionNotification(email, promotion);
}
```

### 2. **Push Notification**
```java
// Gửi push notification
public void sendPushNotification(String deviceToken, Promotion promotion) {
    // Sử dụng Firebase hoặc service tương tự
    pushService.sendNotification(deviceToken, promotion);
}
```

### 3. **Database Notification**
```java
// Lưu thông báo vào database
public void saveNotificationToDatabase(Integer customerId, Integer promotionId) {
    // Lưu vào bảng notifications
    notificationDAO.save(new Notification(customerId, promotionId));
}
```

### 4. **Scheduled Notifications**
```java
// Chạy định kỳ để kiểm tra promotions sắp hết hạn
@Scheduled(cron = "0 0 9 * * ?") // Chạy lúc 9h sáng mỗi ngày
public void checkExpiringPromotions() {
    notifyExpiringPromotions();
}
```

## 📊 Monitoring & Analytics

### Logs
```java
// Log thông báo đã gửi
logger.info("Promotion notification sent to customers for new promotion: " + promotion.getPromotionCode());

// Log lỗi nếu có
logger.log(Level.WARNING, "Failed to send promotion notifications", e);
```

### Metrics
- Số lượng thông báo đã gửi
- Tỷ lệ khách hàng mở thông báo
- Tỷ lệ sử dụng mã khuyến mãi sau thông báo
- Hiệu quả của từng loại thông báo

## 🧪 Testing

### Test Script
```sql
-- Chạy file: test_promotion_notification.sql
-- Tạo dữ liệu test và kiểm tra tính năng
```

### Test Cases
1. **Tạo promotion mới**: Kiểm tra thông báo được gửi
2. **Promotion sắp hết hạn**: Kiểm tra cảnh báo
3. **Khách hàng xem thông báo**: Kiểm tra hiển thị đúng
4. **Sử dụng mã khuyến mãi**: Kiểm tra quy trình end-to-end

## 🔐 Bảo mật

### Access Control
- Chỉ khách hàng đã đăng nhập mới xem được thông báo
- Session validation trước khi hiển thị
- Redirect về trang login nếu chưa đăng nhập

### Data Protection
- Không lưu thông tin nhạy cảm trong thông báo
- Mã hóa thông tin khách hàng khi gửi email
- Tuân thủ GDPR và quy định bảo mật

## 📝 Kết luận

Tính năng thông báo khuyến mãi đã được implement với:
- ✅ Thông báo tự động khi tạo promotion mới
- ✅ Trang hiển thị thông báo cho khách hàng
- ✅ Menu navigation với badge thông báo
- ✅ Cơ sở để mở rộng email/push notification
- ✅ Logging và monitoring cơ bản

Hệ thống sẵn sàng để sử dụng và có thể mở rộng thêm các tính năng nâng cao trong tương lai. 