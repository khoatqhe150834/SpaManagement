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
                                                Tiểu sử <span class="text-danger-600">*</span>
                                            </label>
                                            <div style="position:relative;">
                                                <textarea 
                                                    name="bio" 
                                                    class="form-control" 
                                                    id="bio" 
                                                    placeholder="Viết mô tả ngắn về nhân viên (tối thiểu 20 ký tự)..."
                                                    rows="4" minlength="20" maxlength="500" required
                                                    style="transition: height 0.2s; resize: none; min-height: 120px; max-height: 220px;"
                                                >${staff.bio}</textarea>
                                            </div>
                                            <div class="valid-feedback" id="bioValid"></div>
                                            <div class="invalid-feedback" id="bioError"></div>
                                            <button type="button" id="toggleBioSize" class="btn btn-outline-secondary btn-sm mt-2">Mở rộng</button>
                                            <div class="d-flex justify-content-end align-items-center" style="margin-top: 4px;">
                                                <small class="text-muted"><span id="bioCharCount">0</span>/500</small>
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
            // --- Bio Validation ---
            const bioTextarea = document.getElementById('bio');
            const bioValid = document.getElementById('bioValid');
            const bioError = document.getElementById('bioError');
            const toggleBioSizeBtn = document.getElementById('toggleBioSize');
            const bioCharCount = document.getElementById('bioCharCount');

            const DEFAULT_HEIGHT = 120;
            const EXPANDED_HEIGHT = 220;
            let isExpanded = false;

            function setFieldInvalid(field, message) {
                field.classList.remove('is-valid');
                field.classList.add('is-invalid');
                if (bioError) {
                    bioError.textContent = message;
                    bioError.style.display = 'block';
                }
                if (bioValid) bioValid.style.display = 'none';
            }
            function setFieldValid(field, message) {
                field.classList.remove('is-invalid');
                field.classList.add('is-valid');
                if (bioValid) {
                    bioValid.textContent = message;
                    bioValid.style.display = 'block';
                }
                if (bioError) bioError.style.display = 'none';
            }

            function validateBio() {
                const length = bioTextarea.value.trim().length;
                if (length === 0) {
                    setFieldInvalid(bioTextarea, 'Tiểu sử không được để trống.');
                    return false;
                } else if (length < 20) {
                    setFieldInvalid(bioTextarea, 'Cần ít nhất 20 ký tự.');
                    return false;
                } else {
                    setFieldValid(bioTextarea, 'Tiểu sử hợp lệ.');
                    return true;
                }
            }
            bioTextarea.addEventListener('input', function() {
                validateBio();
                bioCharCount.textContent = this.value.length;
            });

            // Toggle mở rộng/thu gọn
            toggleBioSizeBtn.onclick = function() {
                if (!isExpanded) {
                    bioTextarea.classList.add('expanded');
                    toggleBioSizeBtn.textContent = 'Thu gọn';
                    isExpanded = true;
                } else {
                    bioTextarea.classList.remove('expanded');
                    bioTextarea.style.height = DEFAULT_HEIGHT + 'px';
                    toggleBioSizeBtn.textContent = 'Mở rộng';
                    isExpanded = false;
                }
            };

            // Đảm bảo khi load lại form, textarea ở trạng thái thu gọn
            bioTextarea.classList.remove('expanded');
            bioTextarea.style.height = DEFAULT_HEIGHT + 'px';
            toggleBioSizeBtn.textContent = 'Mở rộng';
            isExpanded = false;

            // Khởi tạo đếm ký tự khi load trang
            bioCharCount.textContent = bioTextarea.value.length;

            // Validate khi submit form
            document.querySelector('form').addEventListener('submit', function(e) {
                if (!validateBio()) {
                    e.preventDefault();
                    bioTextarea.focus();
                }
            });

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
                min-height: 120px;
                max-height: 220px;
                height: 120px;
                transition: height 0.2s;
                resize: none !important;
            }
            
            textarea#bio.expanded {
                height: 220px !important;
            }
            
            /* Ẩn icon tích xanh mặc định của Bootstrap cho textarea khi is-valid */
            textarea.is-valid, textarea.form-control.is-valid {
                background-image: none !important;
                padding-right: 0 !important;
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

