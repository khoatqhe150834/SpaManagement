<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Thêm Người Dùng Mới - Bảng Điều Khiển Quản Trị</title>
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
    </style>
</head>
<body>
     <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
     <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-primary mb-0">Thêm Người Dùng Mới</h3>
        
    </div>

    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-user-plus me-2"></i>
                Thông tin người dùng
            </h5>
        </div>
        <div class="card-body p-4">
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/user/create" method="post" novalidate id="userForm">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label for="fullName" class="form-label">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control ${not empty errors.fullName ? 'is-invalid' : ''}" 
                                   id="fullName" name="fullName" required maxlength="100" 
                                   value="${not empty userInput.fullName ? userInput.fullName : ''}"
                                   placeholder="Nhập họ và tên">
                            <div class="error-text"></div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control ${not empty errors.email ? 'is-invalid' : ''}" 
                                   id="email" name="email" required 
                                   value="${not empty userInput.email ? userInput.email : ''}"
                                   placeholder="Nhập email">
                            <div class="error-text">${errors.email}</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <input type="password" class="form-control ${not empty errors.password ? 'is-invalid' : ''}" 
                                   id="password" name="password" required minlength="6"
                                   placeholder="Nhập mật khẩu (ít nhất 6 ký tự)">
                            <div class="error-text"></div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label for="phone" class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="text" class="form-control ${not empty errors.phoneNumber ? 'is-invalid' : ''}" 
                                   id="phone" name="phone" pattern="^0\d{9}$" 
                                   title="Số điện thoại phải có 10 chữ số bắt đầu với 0." 
                                   value="${not empty userInput.phoneNumber ? userInput.phoneNumber : ''}"
                                   placeholder="Nhập số điện thoại" required>
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
                                <option value="Male" ${userInput.gender == 'Male' ? 'selected' : ''}>Nam</option>
                                <option value="Female" ${userInput.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                                <option value="Other" ${userInput.gender == 'Other' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="birthday">Ngày sinh</label>
                            <input type="date" class="form-control ${not empty errors.birthday ? 'is-invalid' : ''}" 
                                   id="birthday" name="birthday" value="${userInput.birthday}">
                            <div class="error-text"></div>
                        </div>
                    </div>
                </div>

                <div class="form-group mb-3">
                    <label class="form-label" for="address">Địa chỉ</label>
                    <textarea class="form-control" id="address" name="address" rows="3" 
                              placeholder="Nhập địa chỉ">${not empty userInput.address ? userInput.address : ''}</textarea>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label required-field" for="roleId">Vai trò</label>
                            <select class="form-control ${not empty errors.roleId ? 'is-invalid' : ''}" 
                                    id="roleId" name="roleId" required>
                                <option value="">-- Chọn vai trò --</option>
                                <option value="1" ${userInput.roleId == 1 ? 'selected' : ''}>Admin</option>
                                <option value="2" ${userInput.roleId == 2 ? 'selected' : ''}>Quản lý</option>
                                <option value="3" ${userInput.roleId == 3 ? 'selected' : ''}>Chuyên gia trị liệu</option>
                                <option value="4" ${userInput.roleId == 4 ? 'selected' : ''}>Lễ tân</option>
                            </select>
                            <div class="error-text"></div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="avatarFile">Ảnh đại diện</label>
                            <input type="file" class="form-control" id="avatarFile" name="avatarFile" accept="image/*">
                            <div id="avatarPreview" class="mt-2"></div>
                        </div>
                    </div>
                </div>

                <div class="form-group mb-4">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="isActive" name="isActive" 
                               ${userInput.isActive ? 'checked' : ''}>
                        <label class="form-check-label" for="isActive">
                            <i class="fas fa-check-circle me-1"></i>
                            Kích hoạt tài khoản người dùng
                        </label>
                    </div>
                </div>

                <div class="d-flex gap-2 justify-content-end">
                    <a href="${pageContext.request.contextPath}/user/list" class="btn btn-secondary">
                        <i class="fas fa-times me-1"></i> Hủy
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Tạo Người Dùng
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
            $('#phone').on('blur', function() {
                const phone = $(this).val().trim();
                if (phone) {
                    $.get('/api/check-phone', { phone }, function(data) {
                        if (data.exists) {
                            showError($('#phone'), 'Số điện thoại đã tồn tại.');
                            phoneUnique = false;
                        } else {
                            clearError($('#phone'));
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
                if (!fullName) {
                    showError($('#fullName'), 'Full name is required.');
                    valid = false;
                } else if (fullName.length > 100) {
                    showError($('#fullName'), 'Full name must be at most 100 characters.');
                    valid = false;
                } else {
                    clearError($('#fullName'));
                }
                // Validate Email
                const email = $('#email').val().trim();
                const emailRegex = /^[^\s@]+@[^-\u007f]+$/;
                if (!email) {
                    showError($('#email'), 'Email is required.');
                    valid = false;
                } else if (!emailRegex.test(email)) {
                    showError($('#email'), 'Invalid email format.');
                    valid = false;
                } else if (!emailUnique) {
                    showError($('#email'), 'Email đã tồn tại.');
                    valid = false;
                } else {
                    clearError($('#email'));
                }
                // Validate Password
                const password = $('#password').val();
                if (!password) {
                    showError($('#password'), 'Password is required.');
                    valid = false;
                } else if (password.length < 6) {
                    showError($('#password'), 'Password must be at least 6 characters.');
                    valid = false;
                } else {
                    clearError($('#password'));
                }
                // Validate Phone Number (optional)
                const phone = $('#phone').val().trim();
                if (phone && !/^0\d{9}$/.test(phone)) {
                    showError($('#phone'), 'Phone number must be 10 digits starting with 0.');
                    valid = false;
                } else if (!phoneUnique) {
                    showError($('#phone'), 'Số điện thoại đã tồn tại.');
                    valid = false;
                } else {
                    clearError($('#phone'));
                }
                // Validate Birthday (optional)
                const birthday = $('#birthday').val();
                if (birthday) {
                    const inputDate = new Date(birthday);
                    const today = new Date();
                    today.setHours(0,0,0,0);
                    if (inputDate > today) {
                        showError($('#birthday'), 'Birthday cannot be in the future.');
                        valid = false;
                    } else {
                        clearError($('#birthday'));
                    }
                } else {
                    clearError($('#birthday'));
                }
                // Validate Role
                const roleId = $('#roleId').val();
                if (!roleId) {
                    showError($('#roleId'), 'Vai trò là bắt buộc.');
                    valid = false;
                } else {
                    clearError($('#roleId'));
                }
                if (!valid) e.preventDefault();
            });

            $('#avatarFile').on('change', function(e) {
                const file = this.files[0];
                const preview = $('#avatarPreview');
                preview.empty();
                if (file) {
                    if (!file.type.startsWith('image/')) {
                        preview.html('<span class="text-danger">File không phải là ảnh.</span>');
                        this.value = '';
                        return;
                    }
                    if (file.size > 5 * 1024 * 1024) {
                        preview.html('<span class="text-danger">Ảnh phải nhỏ hơn 5MB.</span>');
                        this.value = '';
                        return;
                    }
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        preview.html('<img src="' + e.target.result + '" alt="Avatar Preview" class="rounded-circle" style="width:80px;height:80px;object-fit:cover;border:2px solid #eee;">');
                    };
                    reader.readAsDataURL(file);
                }
            });
        });
     </script>
</body>
</html>
