<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chỉnh sửa người dùng - Trang quản trị</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/remixicon.css"/>
    <style>
        .container { max-width: 800px; margin-top: 40px; }
        .form-label { font-weight: 600; color: #495057; }
        .error-text { width: 100%; margin-top: .25rem; font-size: 80%; color: #dc3545; }
        .is-invalid { border-color: #dc3545 !important; }
        .card { border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
        .card-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 12px 12px 0 0 !important; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; }
        .btn-primary:hover { background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%); }
        .form-control:focus { border-color: #667eea; box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25); }
        .required-field::after { content: " *"; color: #dc3545; }
        .user-avatar { width: 80px; height: 80px; object-fit: cover; border-radius: 50%; border: 3px solid #dee2e6; }
        .current-info { background-color: #f8f9fa; border-radius: 8px; padding: 15px; margin-bottom: 20px; }
    </style>
</head>
<body>
     <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
     <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-primary mb-0">Chỉnh sửa người dùng</h3>
        <a href="${pageContext.request.contextPath}/user/list" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách
        </a>
    </div>

    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-user-edit me-2"></i>
                Thông tin người dùng
            </h5>
        </div>
        <div class="card-body p-4">
            <!-- Current User Info -->
            <div class="current-info">
                <div class="row align-items-center">
                    <div class="col-md-2 text-center">
                        <img src="${not empty user.avatarUrl ? user.avatarUrl : 'https://placehold.co/80x80/7C3AED/FFFFFF?text=USER'}" 
                             alt="Ảnh đại diện" class="user-avatar">
                    </div>
                    <div class="col-md-10">
                        <h6 class="mb-1">${user.fullName}</h6>
                        <p class="text-muted mb-1">
                            <i class="fas fa-envelope me-1"></i>${user.email}
                        </p>
                        <p class="text-muted mb-0">
                            <i class="fas fa-id-card me-1"></i>Mã người dùng: #${user.userId}
                            <span class="badge ${user.isActive ? 'bg-success' : 'bg-secondary'} ms-2">
                                ${user.isActive ? 'Đang hoạt động' : 'Ngưng hoạt động'}
                            </span>
                        </p>
                    </div>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/user/update" method="post" novalidate id="userEditForm" enctype="multipart/form-data">
                <input type="hidden" name="userId" value="${user.userId}" />
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label required-field" for="fullName">Họ và tên</label>
                            <input type="text" class="form-control ${not empty errors.fullName ? 'is-invalid' : ''}" 
                                   id="fullName" name="fullName" required maxlength="100" 
                                   value="${user.fullName}" placeholder="Nhập họ và tên">
                            <div class="error-text">${errors.fullName}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label required-field" for="email">Email</label>
                            <input type="email" class="form-control ${not empty errors.email ? 'is-invalid' : ''}" 
                                   id="email" name="email" required value="${user.email}"
                                   placeholder="Nhập địa chỉ email">
                            <div class="error-text">${errors.email}</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="password">Mật khẩu mới</label>
                            <input type="password" class="form-control ${not empty errors.password ? 'is-invalid' : ''}" 
                                   id="password" name="password" minlength="6"
                                   placeholder="Để trống nếu không đổi mật khẩu">
                            <div class="error-text">${errors.password}</div>
                            <small class="form-text text-muted">
                                <i class="fas fa-info-circle me-1"></i>
                                Để trống nếu không muốn thay đổi mật khẩu hiện tại
                            </small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="phoneNumber">Số điện thoại</label>
                            <input type="tel" class="form-control ${not empty errors.phoneNumber ? 'is-invalid' : ''}" 
                                   id="phoneNumber" name="phoneNumber" pattern="^0\d{9}$" 
                                   title="Số điện thoại phải gồm 10 số và bắt đầu bằng số 0." 
                                   value="${user.phoneNumber}" placeholder="Nhập số điện thoại">
                            <div class="error-text">${errors.phoneNumber}</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="gender">Giới tính</label>
                            <select class="form-control" name="gender">
                                <option value="">-- Chọn giới tính --</option>
                                <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                <option value="Other" ${user.gender == 'Other' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="birthday">Ngày sinh</label>
                            <input type="date" class="form-control ${not empty errors.birthday ? 'is-invalid' : ''}" 
                                   id="birthday" name="birthday" 
                                   value="<fmt:formatDate value='${user.birthday}' pattern='yyyy-MM-dd'/>">
                            <div class="error-text">${errors.birthday}</div>
                        </div>
                    </div>
                </div>

                <div class="form-group mb-3">
                    <label class="form-label" for="address">Địa chỉ</label>
                    <textarea class="form-control" id="address" name="address" rows="3" 
                              placeholder="Nhập địa chỉ">${user.address}</textarea>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label required-field" for="roleId">Vai trò</label>
                            <select class="form-control ${not empty errors.roleId ? 'is-invalid' : ''}" 
                                    id="roleId" name="roleId" required>
                                <option value="">-- Chọn vai trò --</option>
                                <option value="1" ${user.roleId == 1 ? 'selected' : ''}>Quản trị viên</option>
                                <option value="2" ${user.roleId == 2 ? 'selected' : ''}>Quản lý</option>
                                <option value="3" ${user.roleId == 3 ? 'selected' : ''}>Chuyên viên</option>
                                <option value="4" ${user.roleId == 4 ? 'selected' : ''}>Lễ tân</option>
                            </select>
                            <div class="error-text">${errors.roleId}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="avatarFile">Ảnh đại diện</label>
                            <div class="mb-2">
                                <img src="${not empty user.avatarUrl ? user.avatarUrl : 'https://placehold.co/80x80/7C3AED/FFFFFF?text=USER'}" 
                                     alt="Ảnh đại diện hiện tại" class="user-avatar" style="width:60px;height:60px;object-fit:cover;border-radius:50%;border:2px solid #dee2e6;">
                            </div>
                            <input type="file" class="form-control-file" id="avatarFile" name="avatarFile" accept="image/*">
                            <small class="form-text text-muted">Chọn ảnh mới nếu muốn thay đổi ảnh đại diện.</small>
                        </div>
                    </div>
                </div>

                <div class="form-group mb-4">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="isActive" name="isActive" 
                               ${user.isActive ? 'checked' : ''}>
                        <label class="form-check-label" for="isActive">
                            <i class="fas fa-check-circle me-1"></i>
                            Tài khoản đang hoạt động
                        </label>
                    </div>
                </div>

                <div class="d-flex gap-2 justify-content-end">
                    <a href="${pageContext.request.contextPath}/user/list" class="btn btn-secondary">
                        <i class="fas fa-times me-1"></i> Hủy bỏ
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Cập nhật
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

     <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
     <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
     <script>
     $(document).ready(function() {
         let emailUnique = true;
         let phoneUnique = true;
         function showError(input, message) {
             input.addClass('is-invalid');
             input.closest('.form-group').find('.error-text').text(message);
         }
         function clearError(input) {
             input.removeClass('is-invalid');
             input.closest('.form-group').find('.error-text').text('');
         }
         // AJAX check email
         $('#email').on('blur', function() {
             const email = $(this).val().trim();
             if (email) {
                 $.get('/api/check-email', { email }, function(data) {
                     if (data.exists) {
                         showError($('#email'), 'Email đã tồn tại.');
                         emailUnique = false;
                     } else {
                         clearError($('#email'));
                         emailUnique = true;
                     }
                 });
             }
         });
         // AJAX check phone
         $('#phoneNumber').on('blur', function() {
             const phone = $(this).val().trim();
             if (phone) {
                 $.get('/api/check-phone', { phone }, function(data) {
                     if (data.exists) {
                         showError($('#phoneNumber'), 'Số điện thoại đã tồn tại.');
                         phoneUnique = false;
                     } else {
                         clearError($('#phoneNumber'));
                         phoneUnique = true;
                     }
                 });
             }
         });
         // On submit: check all
         $('form').on('submit', function(e) {
             let valid = true;
             // Validate Full Name
             const fullName = $('#fullName').val().trim();
             let nameErrors = [];
             if (!fullName) {
                 nameErrors.push('Tên là bắt buộc.');
             }
             if (/[^\p{L}\s]/u.test(fullName)) {
                 nameErrors.push('Tên chỉ được chứa chữ cái và khoảng trắng, không được chứa số hoặc ký tự đặc biệt.');
             }
             if (fullName.length < 2 || fullName.length > 100) {
                 nameErrors.push('Tên phải có độ dài từ 2 đến 100 ký tự.');
             }
             if (fullName.includes('  ')) {
                 nameErrors.push('Tên không được có nhiều khoảng trắng liền kề.');
             }
             if (!fullName.includes(' ') && fullName.length > 0) {
                 nameErrors.push('Tên đầy đủ cần có ít nhất hai từ (ví dụ: An Nguyen).');
             }
             if (nameErrors.length > 0) {
                 showError($('#fullName'), nameErrors.join('<br>'));
                 valid = false;
             } else {
                 clearError($('#fullName'));
             }
             // Validate Email
             const email = $('#email').val().trim();
             let emailErrors = [];
             const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
             if (!email) {
                 showError($('#email'), 'Email là bắt buộc.');
                 valid = false;
             } else if (!emailRegex.test(email)) {
                 showError($('#email'), 'Email không đúng định dạng.');
                 valid = false;
             } else if (!emailUnique) {
                 showError($('#email'), 'Email đã tồn tại.');
                 valid = false;
             } else {
                 clearError($('#email'));
             }
             // Validate Password (nếu nhập)
             const password = $('#password').val();
             if (password && password.length < 7) {
                 showError($('#password'), 'Mật khẩu phải có ít nhất 7 ký tự.');
                 valid = false;
             } else {
                 clearError($('#password'));
             }
             // Validate Phone Number (required)
             const phone = $('#phoneNumber').val().trim();
             if (!phone) {
                 showError($('#phoneNumber'), 'Số điện thoại là bắt buộc.');
                 valid = false;
             } else if (!/^0\d{9}$/.test(phone)) {
                 showError($('#phoneNumber'), 'Số điện thoại phải gồm 10 số, bắt đầu bằng số 0 và không chứa ký tự đặc biệt.');
                 valid = false;
             } else if (/[^0-9]/.test(phone)) {
                 showError($('#phoneNumber'), 'Số điện thoại chỉ được chứa số, không được chứa ký tự đặc biệt.');
                 valid = false;
             } else if (!phoneUnique) {
                 showError($('#phoneNumber'), 'Số điện thoại đã tồn tại.');
                 valid = false;
             } else {
                 clearError($('#phoneNumber'));
             }
             // Validate Birthday (required)
             const birthday = $('#birthday').val();
             if (!birthday) {
                 showError($('#birthday'), 'Ngày sinh là bắt buộc.');
                 valid = false;
             } else {
                 const inputDate = new Date(birthday);
                 const today = new Date();
                 today.setHours(0,0,0,0);
                 if (inputDate > today) {
                     showError($('#birthday'), 'Ngày sinh không thể ở trong tương lai.');
                     valid = false;
                 } else {
                     clearError($('#birthday'));
                 }
             }
             // Validate Avatar (image)
             const fileInput = document.getElementById('avatarFile');
             const file = fileInput.files[0];
             const preview = $('#avatarPreview');
             if (preview.length) preview.empty();
             if (file) {
                 if (!['image/jpeg', 'image/png', 'image/gif'].includes(file.type)) {
                     preview.html('<span class="text-danger">Chỉ chấp nhận JPEG, PNG hoặc GIF.</span>');
                     fileInput.value = '';
                     valid = false;
                 } else if (file.size > 2 * 1024 * 1024) {
                     preview.html('<span class="text-danger">Ảnh phải nhỏ hơn 2MB.</span>');
                     fileInput.value = '';
                     valid = false;
                 } else {
                     const reader = new FileReader();
                     reader.onload = function(e) {
                         const img = new Image();
                         img.onload = function() {
                             if (img.width < 150 || img.height < 150) {
                                 preview.html('<span class="text-danger">Kích thước ảnh tối thiểu 150x150px.</span>');
                                 fileInput.value = '';
                                 valid = false;
                             } else {
                                 preview.html('<img src="' + e.target.result + '" alt="Avatar Preview" class="rounded-circle" style="width:80px;height:80px;object-fit:cover;border:2px solid #eee;">');
                             }
                         };
                         img.src = e.target.result;
                     };
                     reader.readAsDataURL(file);
                 }
             }
             if (!valid) e.preventDefault();
         });
     });
     </script>
</body>
</html>
