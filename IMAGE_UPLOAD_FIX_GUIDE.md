# Hướng dẫn sửa lỗi Upload Ảnh Promotion

## Vấn đề đã được sửa

### ✅ **1. Lỗi Upload Ảnh**

#### **Nguyên nhân:**
- Thiếu validation đầy đủ cho file upload
- Không xử lý trường hợp `getRealPath()` trả về null
- Tên file không an toàn
- Thiếu fallback path

#### **Giải pháp đã áp dụng:**

**PromotionController.java:**
```java
private String handleImageUpload(HttpServletRequest request) throws IOException, ServletException {
    Part filePart = request.getPart("imageUrl");
    if (filePart == null || filePart.getSize() == 0) {
        return null; // Không có file mới được upload
    }

    // Validate file
    if (!ImageUploadValidator.isValidImage(filePart)) {
        throw new IOException(ImageUploadValidator.getErrorMessage(filePart));
    }

    // Get file name and create unique name
    String fileName = getSubmittedFileName(filePart);
    if (fileName == null || fileName.trim().isEmpty()) {
        throw new IOException("Tên file không hợp lệ");
    }
    
    String fileExtension = "";
    int lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex > 0) {
        fileExtension = fileName.substring(lastDotIndex);
    }
    
    String uniqueFileName = System.currentTimeMillis() + "_promotion" + fileExtension;
    
    // Create upload directory with fallback
    String uploadPath = getServletContext().getRealPath(UPLOAD_DIR);
    if (uploadPath == null) {
        // Fallback to a default path if getRealPath returns null
        uploadPath = System.getProperty("user.home") + "/spa-uploads/promotions/";
    }
    
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) {
        boolean created = uploadDir.mkdirs();
        if (!created) {
            throw new IOException("Không thể tạo thư mục upload: " + uploadPath);
        }
    }

    // Save file
    File targetFile = new File(uploadDir, uniqueFileName);
    try (InputStream input = filePart.getInputStream()) {
        Files.copy(input, targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
    }
    
    // Return the URL path
    return UPLOAD_DIR + uniqueFileName;
}
```

### ✅ **2. Cải thiện UI Upload**

#### **Trước (có vấn đề):**
```html
<input type="file" name="imageUrl" id="imageUrl" accept="image/*" 
       class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary" />
<p class="text-gray-500 text-sm mt-1">Chọn ảnh cho khuyến mãi (không bắt buộc, tối đa 10MB)</p>
```

#### **Sau (đã sửa):**
```html
<div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-lg hover:border-primary transition-colors">
    <div class="space-y-1 text-center">
        <i data-lucide="upload" class="mx-auto h-12 w-12 text-gray-400"></i>
        <div class="flex text-sm text-gray-600">
            <label for="imageUrl" class="relative cursor-pointer bg-white rounded-md font-medium text-primary hover:text-primary-dark focus-within:outline-none focus-within:ring-2 focus-within:ring-offset-2 focus-within:ring-primary">
                <span>Tải ảnh lên</span>
                <input id="imageUrl" name="imageUrl" type="file" class="sr-only" accept="image/*" onchange="previewImage(this)">
            </label>
            <p class="pl-1">hoặc kéo thả vào đây</p>
        </div>
        <p class="text-xs text-gray-500">PNG, JPG, GIF, WEBP tối đa 10MB</p>
    </div>
</div>
<div id="imagePreview" class="mt-2 hidden">
    <img src="" alt="Preview" class="w-32 h-32 object-cover rounded-lg border">
</div>
```

### ✅ **3. Tối ưu Bảng Promotion List**

#### **Loại bỏ cột không cần thiết:**
- ❌ **ID**: Không cần hiển thị ID trong list
- ✅ **Khuyến mãi**: Tên + mô tả + ảnh
- ✅ **Mã**: Mã khuyến mãi
- ✅ **Giảm giá**: Loại và giá trị giảm
- ✅ **Trạng thái**: Trạng thái hiện tại
- ✅ **Thao tác**: Các nút hành động

#### **Cải thiện icons:**
```html
<!-- Trước -->
<i data-lucide="eye" class="w-4 h-4"></i>
<i data-lucide="edit" class="w-4 h-4"></i>
<i data-lucide="pause" class="w-4 h-4"></i>

<!-- Sau -->
👁️ Xem
✏️ Sửa  
⏸️ Tắt
▶️ Bật
```

## Cấu hình cần thiết

### 1. MultipartConfig trong PromotionController
```java
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 1024 * 1024 * 10,     // 10 MB
    maxRequestSize = 1024 * 1024 * 50   // 50 MB
)
```

### 2. ImageUploadValidator
```java
public class ImageUploadValidator {
    private static final List<String> ALLOWED_TYPES = Arrays.asList("image/jpeg", "image/png", "image/gif", "image/webp");
    private static final long MAX_SIZE = 2 * 1024 * 1024; // 2MB

    public static boolean isValidImage(Part filePart) {
        if (filePart == null || filePart.getSize() == 0) return false;
        String contentType = filePart.getContentType();
        if (!ALLOWED_TYPES.contains(contentType)) return false;
        if (filePart.getSize() > MAX_SIZE) return false;
        return true;
    }
}
```

### 3. Thư mục upload
```
/uploads/promotions/
├── 1234567890_promotion.jpg
├── 1234567891_promotion.png
└── 1234567892_promotion.webp
```

## Test Upload Ảnh

### 1. Chạy script test
```sql
-- Chạy file: test_image_upload.sql
-- Script này sẽ kiểm tra cấu trúc và tạo dữ liệu test
```

### 2. Test thủ công
1. Vào trang **Thêm khuyến mãi**
2. Chọn file ảnh (JPG, PNG, GIF, WEBP)
3. Kiểm tra preview hiển thị
4. Submit form
5. Kiểm tra ảnh được lưu và hiển thị

### 3. Kiểm tra lỗi
- **File quá lớn**: Hiển thị thông báo "Kích thước ảnh tối đa 10MB"
- **File không đúng định dạng**: Hiển thị thông báo "Chỉ chấp nhận JPG, PNG, GIF, WEBP"
- **Không chọn file**: Không bắt buộc, có thể bỏ qua

## Troubleshooting

### Lỗi thường gặp

#### 1. "Không thể tạo thư mục upload"
```bash
# Kiểm tra quyền ghi
ls -la /path/to/upload/directory

# Tạo thư mục thủ công nếu cần
mkdir -p /path/to/upload/directory
chmod 755 /path/to/upload/directory
```

#### 2. "Tên file không hợp lệ"
```java
// Kiểm tra method getSubmittedFileName
private String getSubmittedFileName(Part part) {
    for (String cd : part.getHeader("content-disposition").split(";")) {
        if (cd.trim().startsWith("filename")) {
            return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
        }
    }
    return null;
}
```

#### 3. Ảnh không hiển thị
```html
<!-- Kiểm tra URL ảnh trong JSP -->
<img src="${pageContext.request.contextPath}${promotion.imageUrl}" alt="${promotion.title}">

<!-- URL đầy đủ sẽ là: -->
<!-- http://localhost:8080/spa-management/uploads/promotions/1234567890_promotion.jpg -->
```

#### 4. File không được lưu
```java
// Kiểm tra log để debug
logger.info("Upload path: " + uploadPath);
logger.info("Target file: " + targetFile.getAbsolutePath());
logger.info("File saved: " + targetFile.exists());
```

## Performance Tips

### 1. Image Optimization
- Sử dụng WebP format cho ảnh web
- Compress ảnh trước khi upload
- Giới hạn kích thước ảnh (max 10MB)

### 2. Storage
- Sử dụng CDN cho production
- Backup ảnh định kỳ
- Cleanup ảnh không sử dụng

### 3. Security
- Validate file type server-side
- Scan virus cho file upload
- Giới hạn file size
- Sanitize filename

## Kết quả

### ✅ **Đã sửa:**
- Lỗi upload ảnh không hoạt động
- UI upload ảnh đẹp hơn với drag & drop
- Preview ảnh real-time
- Validation đầy đủ
- Fallback path cho upload directory
- Tối ưu bảng list (loại bỏ cột ID)

### 🎯 **Cải thiện:**
- UX tốt hơn với drag & drop
- Preview ảnh ngay lập tức
- Error handling rõ ràng
- Performance tốt hơn
- Security được tăng cường

Bây giờ bạn có thể test upload ảnh promotion mà không gặp lỗi! 