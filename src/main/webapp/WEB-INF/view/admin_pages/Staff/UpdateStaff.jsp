<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en" data-theme="light">
    <head>
        <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Staff - Admin Dashboard</title>
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    </head>
    <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Edit Staff Profile</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="staff" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Back to Staff List
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Edit Staff Profile</li>
                </ul>
            </div>

            <div class="card h-100 p-0 radius-12">
                <div class="card-body p-24">
                    <div class="row justify-content-center">
                        <div class="col-xxl-6 col-xl-8 col-lg-10">
                            <div class="card border">
                                <div class="card-body">
                                    <form action="staff" method="post">
                                        <input type="hidden" name="service" value="update" />
                                        <input type="hidden" name="userId" value="${staff.user.userId}" />

                                        <!-- Họ và tên (Readonly) -->
                                        <div class="mb-20">
                                            <label for="fullName" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Họ và tên <span class="text-danger-600">*</span>
                                            </label>
                                            <input type="text" name="fullName" class="form-control radius-8" id="fullName" value="${staff.user.fullName}" required readonly />
                                        </div>

                                        <!-- Tiểu sử -->
                                        <div class="mb-20">
                                            <label for="bio" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Tiểu sử
                                                <span class="text-muted text-sm">(20-500 ký tự)</span>
                                            </label>
                                            <div class="position-relative">
                                                <textarea 
                                                    name="bio" 
                                                    class="form-control radius-8" 
                                                    id="bio" 
                                                    placeholder="Viết tiểu sử ngắn về nhân viên (tối thiểu 20 ký tự)..." 
                                                    rows="4"
                                                    style="resize: none;"
                                                    minlength="20"
                                                    maxlength="500"
                                                    required
                                                >${staff.bio}</textarea>
                                                <div class="form-text text-end">
                                                    <span id="bioCharCount">0</span>/500 ký tự
                                                    <span id="bioValidationMessage" class="ms-2"></span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Loại dịch vụ -->
                                        <div class="mb-20">
                                            <label for="serviceTypeId" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Loại dịch vụ <span class="text-danger-600">*</span>
                                            </label>
                                            <select name="serviceTypeId" class="form-control radius-8" id="serviceTypeId" required>
                                                <c:forEach var="serviceType" items="${serviceTypes}">
                                                    <option value="${serviceType.serviceTypeId}" ${serviceType.serviceTypeId == staff.serviceType.serviceTypeId ? "selected" : ""}>${serviceType.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Trạng thái làm việc -->
                                        <div class="mb-20">
                                            <label for="availabilityStatus" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Trạng thái làm việc <span class="text-danger-600">*</span>
                                            </label>
                                            <select name="availabilityStatus" class="form-control radius-8" id="availabilityStatus" required>
                                                <option value="AVAILABLE" ${staff.availabilityStatus == 'AVAILABLE' ? "selected" : ""}>Sẵn sàng</option>
                                                <option value="BUSY" ${staff.availabilityStatus == 'BUSY' ? "selected" : ""}>Đang bận</option>
                                                <option value="OFFLINE" ${staff.availabilityStatus == 'OFFLINE' ? "selected" : ""}>Ngoại tuyến</option>
                                                <option value="ON_LEAVE" ${staff.availabilityStatus == 'ON_LEAVE' ? "selected" : ""}>Đang nghỉ phép</option>
                                            </select>
                                        </div>

                                        <!-- Số năm kinh nghiệm -->
                                        <div class="mb-20">
                                            <label for="yearsOfExperience" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Số năm kinh nghiệm <span class="text-danger-600">*</span>
                                            </label>
                                            <input type="number" name="yearsOfExperience" class="form-control radius-8" id="yearsOfExperience"
                                                value="${staff.yearsOfExperience}" required
                                                data-birthday="<fmt:formatDate value='${staff.user.birthday}' pattern='yyyy-MM-dd'/>" />
                                            <div class="invalid-feedback" id="yearsOfExperienceError"></div>
                                            <div class="valid-feedback" id="yearsOfExperienceValid"></div>
                                        </div>

                                        <!-- Nút thao tác -->
                                        <div class="d-flex align-items-center justify-content-center gap-3">
                                            <a href="staff" class="btn btn-outline-danger border border-danger-600 px-56 py-11 radius-8">Hủy</a>
                                            <button type="submit" class="btn btn-primary border border-primary-600 text-md px-56 py-12 radius-8">Cập nhật</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Xử lý bio textarea
            const bioTextarea = document.getElementById('bio');
            const bioCharCount = document.getElementById('bioCharCount');
            const bioValidationMessage = document.getElementById('bioValidationMessage');
            const minLength = 20;
            const maxLength = 500;

            // Hàm format bio: loại bỏ khoảng trắng thừa
            function formatBio(text) {
                // Thay thế 2 hoặc nhiều khoảng trắng bằng 1 khoảng trắng
                return text.replace(/\s{2,}/g, ' ').trim();
            }

            // Hàm validate bio
            function validateBio(text) {
                const formattedText = formatBio(text);
                const length = formattedText.length;
                
                if (length < minLength) {
                    bioValidationMessage.textContent = `Please enter at least ${minLength} characters`;
                    bioValidationMessage.className = 'ms-2 text-danger';
                    return false;
                } else if (length > maxLength) {
                    bioValidationMessage.textContent = `Maximum ${maxLength} characters allowed`;
                    bioValidationMessage.className = 'ms-2 text-danger';
                    return false;
                } else {
                    bioValidationMessage.textContent = '';
                    bioValidationMessage.className = 'ms-2';
                    return true;
                }
            }

            // Hàm cập nhật số ký tự
            function updateCharCount() {
                const currentText = bioTextarea.value;
                const formattedText = formatBio(currentText);
                const currentLength = formattedText.length;
                
                bioCharCount.textContent = currentLength;
                
                if (currentLength > maxLength) {
                    bioCharCount.classList.add('text-danger');
                } else {
                    bioCharCount.classList.remove('text-danger');
                }

                validateBio(currentText);
            }

            // Xử lý sự kiện input
            bioTextarea.addEventListener('input', function(e) {
                const currentText = this.value;
                const formattedText = formatBio(currentText);
                
                // Nếu text đã được format khác với text hiện tại
                if (currentText !== formattedText) {
                    const cursorPosition = this.selectionStart;
                    const diff = currentText.length - formattedText.length;
                    
                    this.value = formattedText;
                    
                    // Giữ vị trí con trỏ
                    this.setSelectionRange(cursorPosition - diff, cursorPosition - diff);
                }
                
                updateCharCount();
            });

            // Xử lý sự kiện blur (khi rời khỏi textarea)
            bioTextarea.addEventListener('blur', function() {
                this.value = formatBio(this.value);
                updateCharCount();
            });

            // Xử lý sự kiện submit form
            document.querySelector('form').addEventListener('submit', function(e) {
                const bioText = bioTextarea.value;
                if (!validateBio(bioText)) {
                    e.preventDefault();
                    bioTextarea.focus();
                }
            });

            // Khởi tạo khi trang load
            updateCharCount();

            // Validate Số năm kinh nghiệm
            const experienceInput = document.getElementById('yearsOfExperience');
            const experienceError = document.getElementById('yearsOfExperienceError');
            const experienceValid = document.getElementById('yearsOfExperienceValid');
            let maxExp = 100;
            const birthday = experienceInput.getAttribute('data-birthday');
            if (birthday) {
                const birthDate = new Date(birthday);
                const today = new Date();
                let age = today.getFullYear() - birthDate.getFullYear();
                const m = today.getMonth() - birthDate.getMonth();
                if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }
                maxExp = Math.max(0, age - 18);
                experienceInput.max = maxExp;
                experienceInput.placeholder = `Tối đa: ${maxExp}`;
            }

            function setFieldInvalid(field, message) {
                field.classList.remove('is-valid');
                field.classList.add('is-invalid');
                const errorElement = document.getElementById(field.id + 'Error');
                const validElement = document.getElementById(field.id + 'Valid');
                if (errorElement) {
                    errorElement.textContent = message;
                    errorElement.style.display = 'block';
                }
                if (validElement) validElement.style.display = 'none';
            }
            function setFieldValid(field, message) {
                field.classList.remove('is-invalid');
                field.classList.add('is-valid');
                const errorElement = document.getElementById(field.id + 'Error');
                const validElement = document.getElementById(field.id + 'Valid');
                if (validElement) {
                    validElement.textContent = message;
                    validElement.style.display = 'block';
                }
                if (errorElement) errorElement.style.display = 'none';
            }

            function validateExperience() {
                const value = experienceInput.value;
                if (value === '') {
                    setFieldInvalid(experienceInput, 'Số năm kinh nghiệm phải nhỏ hơn hoặc bằng ' + maxExp + '.');
                    return false;
                } else {
                    setFieldValid(experienceInput, 'Số năm kinh nghiệm hợp lệ.');
                    return true;
                }
            }

            // Lắng nghe sự kiện nhập liệu
            experienceInput.addEventListener('input', validateExperience);

            // Chặn nhập ký tự không phải số
            experienceInput.addEventListener('keypress', function(e) {
                if (e.key.length === 1 && !/[0-9]/.test(e.key)) {
                    e.preventDefault();
                }
            });

            // Validate khi submit form
            document.querySelector('form').addEventListener('submit', function(e) {
                if (!validateExperience()) {
                    e.preventDefault();
                    experienceInput.focus();
                }
            });

            // Khởi tạo validate khi load trang
            validateExperience();
        </script>

        <style>
            .form-text {
                font-size: 0.875rem;
                color: #6c757d;
            }
            
            .text-danger {
                color: #dc3545 !important;
            }
            
            textarea#bio {
                transition: border-color 0.15s ease-in-out;
            }
            
            textarea#bio:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.2rem rgba(var(--primary-rgb), 0.25);
            }
            
            textarea#bio.error {
                border-color: #dc3545;
            }
            
            #bioValidationMessage {
                font-size: 0.875rem;
                transition: color 0.15s ease-in-out;
            }
        </style>

        <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    </body>
</html>

