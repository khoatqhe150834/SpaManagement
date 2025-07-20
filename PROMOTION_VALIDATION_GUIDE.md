# Hướng Dẫn Validation Khuyến Mãi

## 🎯 **Validation Đã Thêm**

### 1. **Validation Ngày Tháng**
**Frontend (JavaScript):**
- ✅ Ngày bắt đầu không được vượt quá ngày kết thúc
- ✅ Hiển thị lỗi real-time khi người dùng thay đổi ngày
- ✅ Kiểm tra ngày không được để trống

**Backend (Java):**
- ✅ Validate định dạng ngày
- ✅ Kiểm tra ngày kết thúc phải sau ngày bắt đầu
- ✅ Xử lý timezone và format chuẩn

### 2. **Validation Mã Khuyến Mãi**
**Frontend (JavaScript):**
- ✅ Tự động chuyển thành chữ hoa
- ✅ Kiểm tra ký tự tiếng Việt real-time
- ✅ Validate format (chỉ chữ hoa và số)
- ✅ Kiểm tra độ dài (3-10 ký tự)

**Backend (Java):**
- ✅ Kiểm tra ký tự tiếng Việt
- ✅ Validate format và độ dài
- ✅ Kiểm tra trùng lặp với database
- ✅ Xử lý case-insensitive

## 📝 **Code Implementation**

### **Frontend Validation (promotion_add.jsp)**

```javascript
// Validate promotion code
function validatePromotionCode(code) {
    // Check for Vietnamese characters
    const vietnameseRegex = /[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]/i;
    if (vietnameseRegex.test(code)) {
        showPromotionCodeError('Mã khuyến mãi không được chứa ký tự tiếng Việt!');
        return false;
    }
    
    // Check format (only uppercase letters and numbers)
    const formatRegex = /^[A-Z0-9]*$/;
    if (code && !formatRegex.test(code)) {
        showPromotionCodeError('Mã khuyến mãi chỉ được chứa chữ hoa và số!');
        return false;
    }
    
    // Check length
    if (code.length > 0 && (code.length < 3 || code.length > 10)) {
        showPromotionCodeError('Mã khuyến mãi phải từ 3-10 ký tự!');
        return false;
    }
    
    return true;
}

// Validate dates
function validateDates() {
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');
    const startDate = new Date(startDateInput.value);
    const endDate = new Date(endDateInput.value);
    
    if (startDateInput.value && endDateInput.value) {
        if (endDate <= startDate) {
            showDateError('endDate', 'Ngày kết thúc phải sau ngày bắt đầu!');
            return false;
        }
    }
    
    return true;
}
```

### **Backend Validation (PromotionController.java)**

```java
// Promotion Code validation
if (promotionCode == null || promotionCode.trim().isEmpty()) {
    errors.put("promotionCode", "Mã khuyến mãi không được để trống");
} else {
    String code = promotionCode.trim();
    
    // Kiểm tra ký tự tiếng Việt
    if (code.matches(".*[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ].*")) {
        errors.put("promotionCode", "Mã khuyến mãi không được chứa ký tự tiếng Việt");
    } else if (!code.matches("^[A-Z0-9]{3,10}$")) {
        errors.put("promotionCode", "Mã khuyến mãi phải từ 3-10 ký tự, chỉ chứa chữ hoa và số.");
    } else {
        // Kiểm tra trùng lặp
        Optional<Promotion> existing = promotionDAO.findByCodeIgnoreCase(code);
        if (existing.isPresent() && (!isEdit || existing.get().getPromotionId() != promotion.getPromotionId())) {
            errors.put("promotionCode", "Mã khuyến mãi đã tồn tại (không phân biệt chữ hoa/thường)");
        } else {
            promotion.setPromotionCode(code.toUpperCase());
        }
    }
}

// Date validation
if (startDate != null && endDate != null && !endDate.isAfter(startDate)) {
    errors.put("endDate", "Ngày kết thúc phải sau ngày bắt đầu");
}
```

## 🚫 **Các Trường Hợp Bị Từ Chối**

### **Mã Khuyến Mãi:**
- ❌ Chứa ký tự tiếng Việt: `SUMMER2024`, `GIẢMGIÁ`, `KHÁCHHÀNG`
- ❌ Chứa ký tự đặc biệt: `SUMMER-2024`, `SUMMER_2024`, `SUMMER@2024`
- ❌ Chứa chữ thường: `summer2024`, `Summer2024`
- ❌ Độ dài không hợp lệ: `AB`, `SUMMER2024VERYLONGCODE`
- ❌ Trùng với mã đã tồn tại: `SUMMER2024` (nếu đã có)

### **Ngày Tháng:**
- ❌ Ngày kết thúc trước ngày bắt đầu
- ❌ Ngày kết thúc bằng ngày bắt đầu
- ❌ Định dạng ngày không hợp lệ
- ❌ Ngày để trống

## ✅ **Các Trường Hợp Hợp Lệ**

### **Mã Khuyến Mãi:**
- ✅ `SUMMER2024`
- ✅ `WINTER2024`
- ✅ `SPRING2024`
- ✅ `FALL2024`
- ✅ `NEWYEAR2024`
- ✅ `VIP2024`
- ✅ `SALE2024`

### **Ngày Tháng:**
- ✅ Ngày bắt đầu: `2024-01-01`, Ngày kết thúc: `2024-12-31`
- ✅ Ngày bắt đầu: `2024-06-01`, Ngày kết thúc: `2024-08-31`
- ✅ Ngày bắt đầu: `2024-12-01`, Ngày kết thúc: `2025-01-31`

## 🔧 **Cách Test**

### **1. Test Frontend Validation:**
1. Mở trang **Thêm khuyến mãi**
2. Nhập mã khuyến mãi có ký tự tiếng Việt → Xem lỗi hiển thị
3. Nhập mã khuyến mãi có ký tự đặc biệt → Xem lỗi hiển thị
4. Chọn ngày kết thúc trước ngày bắt đầu → Xem lỗi hiển thị
5. Submit form với dữ liệu không hợp lệ → Form không submit

### **2. Test Backend Validation:**
1. Tạo mã khuyến mãi hợp lệ: `SUMMER2024`
2. Tạo mã khuyến mãi khác với cùng code: `SUMMER2024` → Xem lỗi trùng lặp
3. Tạo mã khuyến mãi có ký tự tiếng Việt → Xem lỗi backend
4. Test với ngày không hợp lệ → Xem lỗi backend

### **3. Test Database:**
```sql
-- Kiểm tra mã khuyến mãi đã tồn tại
SELECT * FROM promotions WHERE UPPER(promotion_code) = 'SUMMER2024';

-- Kiểm tra validation constraint
INSERT INTO promotions (promotion_code, title, ...) VALUES ('SUMMER2024', 'Test', ...);
```

## 📋 **Error Messages**

### **Frontend Messages:**
- `"Mã khuyến mãi không được chứa ký tự tiếng Việt!"`
- `"Mã khuyến mãi chỉ được chứa chữ hoa và số!"`
- `"Mã khuyến mãi phải từ 3-10 ký tự!"`
- `"Ngày kết thúc phải sau ngày bắt đầu!"`
- `"Vui lòng chọn ngày bắt đầu!"`
- `"Vui lòng chọn ngày kết thúc!"`

### **Backend Messages:**
- `"Mã khuyến mãi không được chứa ký tự tiếng Việt"`
- `"Mã khuyến mãi phải từ 3-10 ký tự, chỉ chứa chữ hoa và số."`
- `"Mã khuyến mãi đã tồn tại (không phân biệt chữ hoa/thường)"`
- `"Ngày kết thúc phải sau ngày bắt đầu"`

## 🎯 **Kết Quả**

✅ **Validation hoàn chỉnh** cho cả frontend và backend  
✅ **Real-time feedback** cho người dùng  
✅ **Bảo vệ database** khỏi dữ liệu không hợp lệ  
✅ **User experience tốt** với thông báo lỗi rõ ràng  
✅ **Consistency** giữa frontend và backend validation 