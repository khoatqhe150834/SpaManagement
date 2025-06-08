# 🎁 Hệ thống CRUD Promotion - Hướng dẫn sử dụng

## 📋 Tổng quan
Hệ thống CRUD Promotion cho phép quản lý hoàn chỉnh các chương trình khuyến mãi/giảm giá cho spa, bao gồm:
- ✅ **Create** (Thêm mới)
- 👁️ **Read** (Xem/Danh sách)
- ✏️ **Update** (Chỉnh sửa)
- 🗑️ **Delete** (Xóa)
- 🔍 **Search** (Tìm kiếm)
- 📊 **Sort** (Sắp xếp)

## 🚀 Cài đặt

### 1. Tạo bảng cơ sở dữ liệu
```sql
-- Chạy file SQL để tạo bảng promotions
-- File: src/java/sql/create_promotions_table.sql
```

### 2. Cấu trúc file đã tạo:
```
📁 src/java/
├── 📁 dao/
│   └── PromotionDAO.java          # Data Access Object
├── 📁 controller/
│   └── PromotionController.java   # Servlet Controller
├── 📁 model/
│   └── Promotion.java            # Model class (đã có)
└── 📁 sql/
    └── create_promotions_table.sql # Script tạo bảng

📁 web/WEB-INF/view/admin_pages/
├── promotion-list.jsp            # Danh sách promotions
├── promotion-add.jsp             # Form thêm mới
├── promotion-edit.jsp            # Form chỉnh sửa
└── promotion-view.jsp            # Xem chi tiết
```

## 🌐 URL và chức năng

### Danh sách các URL:
- `/promotion` hoặc `/promotion?action=list` - Danh sách tất cả
- `/promotion?action=search&keyword=...` - Tìm kiếm
- `/promotion?action=view&id=...` - Xem chi tiết
- `/promotion?action=pre-add` - Form thêm mới
- `/promotion?action=pre-edit&id=...` - Form chỉnh sửa
- `/promotion?action=delete&id=...` - Xóa promotion

## 🎯 Tính năng chính

### 1. 📋 Danh sách Promotions
- Hiển thị tất cả promotions với thông tin cơ bản
- Phân loại theo status (Active, Inactive, Expired, Upcoming)
- Hiển thị discount badge với màu sắc phù hợp
- Action buttons: View, Edit, Delete

### 2. 🔍 Tìm kiếm
- Tìm kiếm theo **tên promotion**
- Tìm kiếm theo **promotion code**
- Tìm kiếm theo **ID**
- Giao diện thân thiện với placeholder và clear button

### 3. 📊 Sắp xếp
Sắp xếp theo các tiêu chí:
- 📅 **Ngày tạo** (mặc định)
- 📝 **Tên promotion**
- 🏷️ **Mã promotion**
- 💰 **Giá trị giảm giá**
- 🟢 **Ngày bắt đầu**
- 🔴 **Ngày kết thúc**
- 📊 **Trạng thái**

Thứ tự: **Tăng dần** ↗️ hoặc **Giảm dần** ↘️

### 4. ➕ Thêm mới Promotion
Form bao gồm các trường:
- **Bắt buộc**: Title, Promotion Code, Discount Type, Discount Value, Status
- **Tùy chọn**: Description, Minimum Order Value, Start/End Date, Usage Limits, etc.
- **Validation**: Kiểm tra dữ liệu đầu vào, format code tự động uppercase

### 5. ✏️ Chỉnh sửa Promotion
- Form tương tự Add nhưng với dữ liệu đã điền sẵn
- Có thể chỉnh sửa tất cả thông tin
- Validation đầy đủ

### 6. 👁️ Xem chi tiết
- Hiển thị toàn bộ thông tin promotion
- Giao diện read-only với styling đẹp
- Chia sections rõ ràng: Basic Info, Discount Info, Validity Period, Usage Stats
- Action buttons: Edit, Delete, Back to List

### 7. 🗑️ Xóa Promotion
- Confirmation dialog với SweetAlert2
- Hiển thị loading state
- Redirect về list sau khi xóa thành công

## 💾 Cấu trúc Database

### Bảng `promotions`:
```sql
promotion_id           INT (Primary Key, Auto-increment)
title                 NVARCHAR(255) NOT NULL
description           NVARCHAR(MAX)
promotion_code        NVARCHAR(50) UNIQUE NOT NULL
discount_type         NVARCHAR(20) ('percentage' | 'fixed')
discount_value        DECIMAL(10,2)
applies_to_service_id INT
minimum_appointment_value DECIMAL(10,2)
start_date           DATETIME
end_date             DATETIME
status               NVARCHAR(20) ('active'|'inactive'|'expired'|'upcoming')
usage_limit_per_customer INT
total_usage_limit    INT
current_usage_count  INT DEFAULT 0
applicable_scope     NVARCHAR(50) ('all'|'specific'|'category')
applicable_service_ids_json NVARCHAR(MAX)
image_url            NVARCHAR(500)
terms_and_conditions NVARCHAR(MAX)
created_by_user_id   INT
is_auto_apply        BIT DEFAULT 0
created_at           DATETIME DEFAULT GETDATE()
updated_at           DATETIME DEFAULT GETDATE()
```

## 🎨 Giao diện và UX

### Design Features:
- **Bootstrap 5** responsive design
- **Emoji icons** cho trực quan
- **Color-coded badges** cho status và discount types
- **SweetAlert2** cho confirmations
- **Hover effects** và animations
- **Form validation** real-time
- **Loading states** cho UX tốt hơn

### Color Scheme:
- 🟢 **Active**: Green badges
- ❌ **Inactive**: Gray badges  
- ⏰ **Expired**: Red badges
- ⏳ **Upcoming**: Yellow/Orange badges
- 💙 **Percentage**: Blue discount badges
- 💚 **Fixed Amount**: Green discount badges

## 📱 Responsive Design
- Desktop: Full layout với tất cả columns
- Tablet: Compact layout, ẩn một số thông tin phụ
- Mobile: Stacked layout, action buttons nhỏ gọn

## 🔧 Customization

### Thêm field mới:
1. Cập nhật `Promotion.java` model
2. Cập nhật `PromotionDAO.java` (save, update, mapResultSet methods)
3. Cập nhật form JSP files
4. Cập nhật database schema

### Thêm validation:
1. Frontend: JavaScript validation trong JSP
2. Backend: Validation trong Controller
3. Database: CHECK constraints

## 🚨 Error Handling
- Database connection errors
- Validation errors
- Not found errors (404)
- Permission errors
- Friendly error messages với emojis

## 📊 Sample Data
Hệ thống bao gồm 5 sample promotions:
1. **WELCOME20** - 20% off cho khách hàng mới
2. **SUMMER30** - 30% off summer special
3. **SAVE50** - $50 fixed discount
4. **VIP15** - 15% VIP member exclusive (upcoming)
5. **HOLIDAY25** - 25% holiday discount (expired)

## 🔗 Integration
- Có thể integrate với:
  - User management system (created_by_user_id)
  - Service management (applies_to_service_id)
  - Order/Appointment system
  - Email marketing system

## 📞 Support
Nếu có vấn đề:
1. Kiểm tra database connection
2. Kiểm tra web.xml có servlet mapping
3. Kiểm tra JSP includes có đúng path
4. Kiểm tra log files cho errors

## 🎉 Kết luận
Hệ thống CRUD Promotion này cung cấp đầy đủ tính năng quản lý khuyến mãi với:
- ✅ Giao diện đẹp, thân thiện
- ✅ Tính năng đầy đủ (CRUD + Search + Sort)
- ✅ Responsive design
- ✅ Error handling tốt
- ✅ Sample data để test
- ✅ Documentation đầy đủ

**Happy coding! 🚀** 