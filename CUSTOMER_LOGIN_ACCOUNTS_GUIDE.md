# Hướng Dẫn Tài Khoản Khách Hàng Có Thể Đăng Nhập

## 📊 **Tổng Quan Hệ Thống**

Dựa trên phân tích database, hệ thống có các loại tài khoản khách hàng sau:

### **Điều Kiện Để Đăng Nhập:**
- ✅ **Có email** (không null)
- ✅ **Có mật khẩu** (hash_password không null)
- ✅ **Tài khoản hoạt động** (is_active = 1)

## 🔍 **Phân Tích Database**

### **Từ file `duongdoDB.sql` và `schema_data_main.sql`:**

#### **Tài Khoản Có Thể Đăng Nhập (Active + Email + Password):**

| ID | Tên | Email | SĐT | Trạng Thái |
|----|-----|-------|-----|------------|
| 1 | Nguyễn Thị Mai | mai.nguyen@email.com | 0988111222 | ✅ Hoạt động |
| 2 | Trần Văn Nam | nam.tran@email.com | 0977333444 | ✅ Hoạt động |
| 3 | Lê Thị Lan | lan.le@email.com | 0966555666 | ✅ Hoạt động |
| 5 | Võ Thị Kim Chi | kimchi.vo@email.com | 0944999000 | ✅ Hoạt động |
| 7 | Clementine Shields | qaxyb@mailinator.com | 0075252946 | ✅ Hoạt động |
| 8 | Preston Reeves | wogelyvi@mailinator.com | 0621707951 | ✅ Hoạt động |
| 9 | Hector Gill | qepem@mailinator.com | 0488215435 | ✅ Hoạt động |
| 10 | John Walters | hybux@mailinator.com | 0764611157 | ✅ Hoạt động |
| 11 | Gregory Jacobs | fetoryby@mailinator.com | 0868681648 | ✅ Hoạt động |
| 12 | Taylor Gross | jygemi@mailinator.com | 0370784956 | ✅ Hoạt động |
| 14 | Kameko Leach | vadyrud@mailinator.com | 0575726427 | ✅ Hoạt động |
| 15 | Geoffrey White | hudyq@mailinator.com | 0838898566 | ✅ Hoạt động |
| 16 | Denton Holder | quangkhoa51123@gmail.com | 0367449306 | ✅ Hoạt động |
| 17 | Thieu Quang Khoa | begig@mailinator.com | 0770634550 | ✅ Hoạt động |
| 18 | Eleanor Tran | sopehoxyq@mailinator.com | 0863647205 | ✅ Hoạt động |
| 19 | Bert Keller | gimibokuk@mailinator.com | 0315448491 | ✅ Hoạt động |
| 20 | Ian Schwartz | kuwidozata@mailinator.com | 0981727583 | ✅ Hoạt động |
| 21 | Ian Bradshaw | hyjoz@mailinator.com | 0994918210 | ✅ Hoạt động |
| 22 | Alea Compton | xapymabo@mailinator.com | 0526799608 | ✅ Hoạt động |
| 60 | Emmanuel Garcia | quangkhoa51132@5dulieu.com | 0567692940 | ✅ Hoạt động |
| 83 | Melanie Lancaster | quangkhoa5112@gmail.com | 0722572791 | ✅ Hoạt động |
| 109 | Odessa Stanton | khoatqhe150834@gmail.com | 0543516697 | ✅ Hoạt động |
| 110 | Dương Đỗ | abc@gmail.com | 0782376648 | ✅ Hoạt động |
| 111 | Đỗ Hoàng Dương | dohoangduong2708@gmail.com | 0705711546 | ✅ Hoạt động |
| 113 | Perry Bowen | khoatqhe150834@gmail.com | 0899339325 | ✅ Hoạt động |

#### **Tài Khoản KHÔNG Thể Đăng Nhập:**

| ID | Tên | Email | SĐT | Lý Do |
|----|-----|-------|-----|--------|
| 4 | Phạm Văn Hùng | hung.pham@email.com | 0955777888 | ❌ Tài khoản không hoạt động |
| 6 | Khách Vãng Lai A | NULL | 0912345001 | ❌ Không có email |

## 🔐 **Tài Khoản Test Để Đăng Nhập**

### **Tài Khoản Thật (Có Mật Khẩu Hash):**

#### **1. Tài khoản VIP:**
- **Email:** `mai.nguyen@email.com`
- **SĐT:** `0988111222`
- **Điểm tích lũy:** 250 điểm
- **Trạng thái:** Đã xác thực email

#### **2. Tài khoản thường:**
- **Email:** `nam.tran@email.com`
- **SĐT:** `0977333444`
- **Điểm tích lũy:** 60 điểm
- **Trạng thái:** Chưa xác thực email

#### **3. Tài khoản test (mailinator.com):**
- **Email:** `qaxyb@mailinator.com`
- **SĐT:** `0075252946`
- **Trạng thái:** Hoạt động

### **Tài Khoản Có Remember Me Tokens:**

| Email | Tên | Trạng Thái Token |
|-------|-----|------------------|
| `xapymabo@mailinator.com` | Alea Compton | Còn hiệu lực |
| `quangkhoa5112@gmail.com` | Melanie Lancaster | Còn hiệu lực |
| `khoatqhe150834@gmail.com` | Perry Bowen | Còn hiệu lực |

## 🚫 **Tài Khoản Không Thể Đăng Nhập**

### **Lý Do Không Đăng Nhập Được:**

1. **Không có email:** Tài khoản chỉ có số điện thoại
2. **Không có mật khẩu:** Tài khoản chưa set password
3. **Tài khoản không hoạt động:** `is_active = 0`
4. **Chưa xác thực email:** `is_verified = 0`

## 📋 **Cách Kiểm Tra Bằng SQL**

### **Chạy script `check_customer_login_accounts.sql`:**

```sql
-- Kiểm tra tài khoản có thể đăng nhập
SELECT 
    customer_id,
    full_name,
    email,
    phone_number,
    loyalty_points,
    is_verified
FROM customers 
WHERE email IS NOT NULL 
    AND hash_password IS NOT NULL 
    AND is_active = 1
ORDER BY customer_id;
```

### **Kiểm tra tài khoản cụ thể:**

```sql
-- Kiểm tra tài khoản theo email
SELECT 
    customer_id,
    full_name,
    email,
    phone_number,
    CASE WHEN is_active = 1 THEN 'Hoạt động' ELSE 'Không hoạt động' END as status,
    CASE WHEN hash_password IS NOT NULL THEN 'Có mật khẩu' ELSE 'Không có mật khẩu' END as password_status
FROM customers 
WHERE email = 'mai.nguyen@email.com';
```

## 🔧 **Cách Tạo Tài Khoản Test**

### **1. Tạo tài khoản mới:**
```sql
INSERT INTO customers (
    full_name, 
    email, 
    phone_number, 
    hash_password, 
    is_active, 
    role_id,
    loyalty_points
) VALUES (
    'Test Customer',
    'test@example.com',
    '0123456789',
    '$2a$10$hashedpasswordhere',
    1,
    5,
    0
);
```

### **2. Kích hoạt tài khoản:**
```sql
UPDATE customers 
SET is_active = 1 
WHERE email = 'test@example.com';
```

### **3. Set mật khẩu:**
```sql
UPDATE customers 
SET hash_password = '$2a$10$newhashedpassword' 
WHERE email = 'test@example.com';
```

## ⚠️ **Lưu Ý Quan Trọng**

### **Bảo Mật:**
- Mật khẩu được hash bằng BCrypt
- Không lưu mật khẩu plain text
- Email phải unique trong hệ thống

### **Validation:**
- Email không được null để đăng nhập
- Tài khoản phải active
- Có thể đăng nhập dù chưa verify email

### **Remember Me:**
- Tokens có thời hạn 30 ngày
- Tự động xóa khi hết hạn
- Mỗi email có thể có nhiều tokens

## 🎯 **Kết Luận**

**Tổng cộng có khoảng 25+ tài khoản khách hàng có thể đăng nhập được** trong hệ thống, bao gồm:
- Tài khoản VIP với điểm tích lũy cao
- Tài khoản thường với thông tin đầy đủ
- Tài khoản test từ mailinator.com
- Tài khoản có remember me tokens

**Để test đăng nhập, sử dụng các email từ danh sách trên với mật khẩu tương ứng.** 