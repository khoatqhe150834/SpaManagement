<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add New User - Admin Dashboard</title>
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
        <h3 class="text-primary mb-0">Add New User</h3>
        <a href="${pageContext.request.contextPath}/user/list" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back to User List
        </a>
    </div>

    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-user-plus me-2"></i>
                User Information
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
                                   placeholder="Nhập họ và tên" oninput="validateFullName()">
                            <div class="invalid-feedback d-block" id="fullNameError" style="display:none">Vui lòng nhập họ và tên.</div>
                            <div class="valid-feedback d-block" id="fullNameValid" style="display:none;color:#219653;font-size:0.95em;">Hợp lệ!</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control ${not empty errors.email ? 'is-invalid' : ''}" 
                                   id="email" name="email" required 
                                   value="${not empty userInput.email ? userInput.email : ''}"
                                   placeholder="Nhập email" oninput="validateEmail()">
                            <div class="invalid-feedback d-block" id="emailError" style="display:none">Email không hợp lệ.</div>
                            <div class="valid-feedback d-block" id="emailValid" style="display:none;color:#219653;font-size:0.95em;">Hợp lệ!</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control ${not empty errors.password ? 'is-invalid' : ''}" 
                                   id="password" name="password" required minlength="6"
                                   placeholder="Enter password (min 6 characters)">
                            <div class="error-text">${errors.password}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label for="phone" class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="text" class="form-control ${not empty errors.phoneNumber ? 'is-invalid' : ''}" 
                                   id="phone" name="phone" pattern="^0\d{9}$" 
                                   title="Phone number must be 10 digits starting with 0." 
                                   value="${not empty userInput.phoneNumber ? userInput.phoneNumber : ''}"
                                   placeholder="Nhập số điện thoại" required oninput="validatePhone()">
                            <div class="invalid-feedback d-block" id="phoneError" style="display:none">Vui lòng nhập số điện thoại hợp lệ.</div>
                            <div class="valid-feedback d-block" id="phoneValid" style="display:none;color:#219653;font-size:0.95em;">Hợp lệ!</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="gender">Gender</label>
                            <select class="form-control" name="gender">
                                <option value="">-- Select Gender --</option>
                                <option value="Male" ${userInput.gender == 'Male' ? 'selected' : ''}>Male</option>
                                <option value="Female" ${userInput.gender == 'Female' ? 'selected' : ''}>Female</option>
                                <option value="Other" ${userInput.gender == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="birthday">Birthday</label>
                            <input type="date" class="form-control ${not empty errors.birthday ? 'is-invalid' : ''}" 
                                   id="birthday" name="birthday" value="${userInput.birthday}">
                            <div class="error-text">${errors.birthday}</div>
                        </div>
                    </div>
                </div>

                <div class="form-group mb-3">
                    <label class="form-label" for="address">Address</label>
                    <textarea class="form-control" id="address" name="address" rows="3" 
                              placeholder="Enter address">${not empty userInput.address ? userInput.address : ''}</textarea>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label required-field" for="roleId">Role</label>
                            <select class="form-control ${not empty errors.roleId ? 'is-invalid' : ''}" 
                                    id="roleId" name="roleId" required>
                                <option value="">-- Select Role --</option>
                                <option value="1" ${userInput.roleId == 1 ? 'selected' : ''}>Admin</option>
                                <option value="2" ${userInput.roleId == 2 ? 'selected' : ''}>Manager</option>
                                <option value="3" ${userInput.roleId == 3 ? 'selected' : ''}>Therapist</option>
                                <option value="4" ${userInput.roleId == 4 ? 'selected' : ''}>Receptionist</option>
                            </select>
                            <div class="error-text">${errors.roleId}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="avatarFile">Avatar Image</label>
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
                            Active User Account
                        </label>
                    </div>
                </div>

                <div class="d-flex gap-2 justify-content-end">
                    <a href="${pageContext.request.contextPath}/user/list" class="btn btn-secondary">
                        <i class="fas fa-times me-1"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Create User
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
            function showError(input, message) {
                input.addClass('is-invalid');
                input.next('.error-text').text(message);
            }
            function clearError(input) {
                input.removeClass('is-invalid');
                input.next('.error-text').text('');
            }
            // Full Name
            $('#fullName').on('input blur', function() {
                const val = $(this).val().trim();
                if (!val) showError($(this), 'Full name is required.');
                else if (val.length > 100) showError($(this), 'Max 100 characters.');
                else clearError($(this));
            });
            // Email
            $('#email').on('input blur', function() {
                const val = $(this).val().trim();
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!val) showError($(this), 'Email is required.');
                else if (!emailRegex.test(val)) showError($(this), 'Invalid email format.');
                else clearError($(this));
            });
            // Password
            $('#password').on('input blur', function() {
                const val = $(this).val();
                if (!val) showError($(this), 'Password is required.');
                else if (val.length < 6) showError($(this), 'Password must be at least 6 characters.');
                else clearError($(this));
            });
            // Phone Number (optional)
            $('#phone').on('input blur', function() {
                const val = $(this).val().trim();
                if (val && !/^0\d{9}$/.test(val)) showError($(this), 'Phone number must be 10 digits starting with 0.');
                else clearError($(this));
            });
            // Birthday (optional)
            $('#birthday').on('change blur', function() {
                const val = $(this).val();
                if (val) {
                    const inputDate = new Date(val);
                    const today = new Date();
                    today.setHours(0,0,0,0);
                    if (inputDate > today) showError($(this), 'Birthday cannot be in the future.');
                    else clearError($(this));
                } else {
                    clearError($(this));
                }
            });
            // Role
            $('#roleId').on('change blur', function() {
                const val = $(this).val();
                if (!val) showError($(this), 'Role is required.');
                else clearError($(this));
            });
            // Avatar image preview
            $('#avatarFile').on('change', function(e) {
                const file = this.files[0];
                const preview = $('#avatarPreview');
                preview.empty();
                if (file) {
                    if (!file.type.startsWith('image/')) {
                        preview.html('<span class="text-danger">Selected file is not an image.</span>');
                        this.value = '';
                        return;
                    }
                    if (file.size > 5 * 1024 * 1024) {
                        preview.html('<span class="text-danger">Image size must be less than 5MB.</span>');
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
            // On submit: check all
            $('form').on('submit', function(e) {
                let valid = true;
                $('#fullName').trigger('blur');
                $('#email').trigger('blur');
                $('#password').trigger('blur');
                $('#phone').trigger('blur');
                $('#birthday').trigger('blur');
                $('#roleId').trigger('blur');
                $(this).find('input,select,textarea').each(function() {
                    if ($(this).hasClass('is-invalid')) valid = false;
                });
                if (!valid) e.preventDefault();
            });
        });

        function validateFullName() {
            const value = document.getElementById('fullName').value.trim();
            document.getElementById('fullNameError').style.display = value ? 'none' : 'block';
            document.getElementById('fullNameValid').style.display = value ? 'block' : 'none';
        }
        function validateEmail() {
            const value = document.getElementById('email').value.trim();
            const valid = /^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(value);
            document.getElementById('emailError').style.display = valid ? 'none' : 'block';
            document.getElementById('emailValid').style.display = value && valid ? 'block' : 'none';
        }
        function validatePhone() {
            const value = document.getElementById('phone').value.trim();
            const valid = /^0\d{9,10}$/.test(value);
            document.getElementById('phoneError').style.display = valid ? 'none' : 'block';
            document.getElementById('phoneValid').style.display = value && valid ? 'block' : 'none';
        }
        const form = document.querySelector('form');
        if(form) {
            form.onsubmit = function(e) {
                validateFullName(); validateEmail(); validatePhone();
                if(document.getElementById('fullNameError').style.display === 'block' ||
                   document.getElementById('emailError').style.display === 'block' ||
                   document.getElementById('phoneError').style.display === 'block') {
                    e.preventDefault();
                }
            }
        }
     </script>
</body>
</html> 