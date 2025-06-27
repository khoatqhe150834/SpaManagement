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
                                        <!-- Upload Image Start -->
                                        <div class="mb-24 mt-16">
                                            <div class="avatar-upload">
                                                <div class="avatar-edit position-absolute bottom-0 end-0 me-24 mt-16 z-1 cursor-pointer">
                                                    <input type='file' id="imageUpload" accept=".png, .jpg, .jpeg" hidden>
                                                    <label for="imageUpload" class="w-32-px h-32-px d-flex justify-content-center align-items-center bg-primary-50 text-primary-600 border border-primary-600 bg-hover-primary-100 text-lg rounded-circle">
                                                        <iconify-icon icon="solar:camera-outline" class="icon"></iconify-icon>
                                                    </label>
                                                </div>
                                                <div class="avatar-preview">
                                                    <div id="imagePreview"> </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Full Name -->
                                        <!-- Full Name (Readonly) -->
                                        <div class="mb-20">
                                            <label for="fullName" class="form-label fw-semibold text-primary-light text-sm mb-8">Full Name <span class="text-danger-600">*</span></label>
                                            <input type="text" name="fullName" class="form-control radius-8" id="fullName" value="${staff.user.fullName}" required readonly />
                                        </div>


                                        <!-- Bio -->
                                        <div class="form-group position-relative" style="max-width:100%;">
                                            <label for="bio" class="form-label">Tiểu sử <span class="text-danger-600">*</span></label>
                                            <div style="position:relative;">
                                                <textarea name="bio" class="form-control" id="bio"
                                                    placeholder="Viết mô tả ngắn về nhân viên (tối thiểu 20 ký tự)..."
                                                    rows="4" minlength="20" maxlength="500" required>${staff.bio}</textarea>
                                            </div>
                                            <div class="valid-feedback" id="bioValid"></div>
                                            <div class="invalid-feedback" id="bioError"></div>
                                            <div class="d-flex justify-content-end align-items-center" style="margin-top: 4px;">
                                                <small class="text-muted"><span id="bioCharCount">0</span>/500</small>
                                            </div>
                                        </div>

                                        <!-- Service Type -->
                                        <div class="mb-20">
                                            <label for="serviceTypeId" class="form-label fw-semibold text-primary-light text-sm mb-8">
                                                Loại dịch vụ <span class="text-danger-600">*</span>
                                            </label>
                                            <select name="serviceTypeId" class="form-control radius-8" id="serviceTypeId" required>
                                                <c:forEach var="serviceType" items="${serviceTypes}">
                                                    <option value="${serviceType.serviceTypeId}" ${serviceType.serviceTypeId == staff.serviceType.serviceTypeId ? "selected" : ""}>${serviceType.name}</option>
                                                </c:forEach>
                                            </select>
                                            <div class="valid-feedback" id="serviceTypeIdValid"></div>
                                            <div class="invalid-feedback" id="serviceTypeIdError"></div>
                                        </div>

                                        <!-- Availability Status -->
                                        <div class="mb-20">
                                            <label for="availabilityStatus" class="form-label fw-semibold text-primary-light text-sm mb-8">Availability Status <span class="text-danger-600">*</span></label>
                                            <select name="availabilityStatus" class="form-control radius-8" id="availabilityStatus" required>
                                                <option value="AVAILABLE" ${staff.availabilityStatus == 'AVAILABLE' ? "selected" : ""}>Available</option>
                                                <option value="BUSY" ${staff.availabilityStatus == 'BUSY' ? "selected" : ""}>Busy</option>
                                                <option value="OFFLINE" ${staff.availabilityStatus == 'OFFLINE' ? "selected" : ""}>Offline</option>
                                                <option value="ON_LEAVE" ${staff.availabilityStatus == 'ON_LEAVE' ? "selected" : ""}>On Leave</option>
                                            </select>
                                        </div>

                                        <!-- Years of Experience -->
                                        <div class="form-group">
                                            <label for="yearsOfExperience" class="form-label">Số năm kinh nghiệm <span class="text-danger-600">*</span></label>
                                            <input type="number" name="yearsOfExperience" class="form-control" id="yearsOfExperience"
                                                value="${staff.yearsOfExperience}" required data-birthday="<fmt:formatDate value='${staff.user.birthday}' pattern='yyyy-MM-dd'/>" />
                                            <div class="invalid-feedback" id="yearsOfExperienceError"></div>
                                        </div>

                                        <!-- Action Buttons -->
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
            $(document).ready(function() {
                // --- Bio Validation ---
                const bioTextarea = document.getElementById('bio');
                const bioValid = document.getElementById('bioValid');
                const bioError = document.getElementById('bioError');
                const bioCharCount = document.getElementById('bioCharCount');

                function validateBio() {
                    const length = bioTextarea.value.trim().length;
                    bioCharCount.textContent = length;
                    if (length === 0) {
                        setFieldInvalid(bioTextarea, 'Tiểu sử không được để trống.');
                        return false;
                    } else if (length < 20) {
                        setFieldInvalid(bioTextarea, 'Cần ít nhất 20 ký tự.');
                        return false;
                    } else {
                        setFieldValid(bioTextarea, 'Đã nhập tiểu sử đúng.');
                        return true;
                    }
                }
                bioTextarea.addEventListener('input', validateBio);

                // --- Experience Validation ---
                const experienceInput = document.getElementById('yearsOfExperience');
                const experienceError = document.getElementById('yearsOfExperienceError');
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
                experienceInput.addEventListener('input', function() {
                    const value = this.value;
                    if (value === '') {
                        setFieldInvalid(experienceInput, 'Số năm kinh nghiệm không được để trống.');
                    } else if (isNaN(value) || value < 0) {
                        setFieldInvalid(experienceInput, 'Kinh nghiệm phải là số không âm.');
                    } else if (parseInt(value, 10) > maxExp) {
                        setFieldInvalid(experienceInput, `Số năm kinh nghiệm phải nhỏ hơn hoặc bằng ${maxExp}.`);
                    } else {
                        setFieldValid(experienceInput, '');
                    }
                });

                // Đếm ký tự bio khi load lại
                bioCharCount.textContent = bioTextarea.value.trim().length;

                // Helper
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
            });
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

