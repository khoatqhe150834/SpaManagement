<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm nhân viên mới</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <style>
        .profile-body {
            background-color: #f8f9fa;
        }
        .form-card {
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.07);
            border: 1px solid #e9ecef;
            overflow: hidden;
        }
        .form-card .card-header {
            background-color: #ffffff;
            border-bottom: 1px solid #e9ecef;
            padding: 24px;
        }
        .form-card .card-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 4px;
        }
        .form-card .card-subtitle {
            font-size: 1rem;
            color: #7f8c8d;
        }
        .form-card .card-body {
            padding: 24px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            font-weight: 600;
            margin-bottom: 8px;
            color: #34495e;
        }
        .form-control, .form-select {
            min-height: 48px;
            height: 48px;
            border-radius: 12px;
            font-size: 1rem;
            padding: 12px 16px;
            border: 1px solid #ced4da;
            transition: border-color 0.3s, box-shadow 0.3s;
            box-shadow: none;
            background: #fff;
        }
        .form-select {
            text-overflow: ellipsis;
            white-space: nowrap;
            overflow: hidden;
            min-height: 48px;
            line-height: 1.5;
            position: relative;
        }
        .form-select option {
            padding: 8px 12px;
            white-space: normal;
            word-wrap: break-word;
        }
        .form-control:focus, .form-select:focus {
            border-color: #8e44ad;
            box-shadow: 0 0 0 3px rgba(142, 68, 173, 0.15);
        }
        .form-control[readonly] {
            background-color: #e9ecef;
            cursor: not-allowed;
        }
        .form-actions {
            border-top: 1px solid #e9ecef;
            padding: 24px;
            text-align: right;
            background-color: #fdfdff;
        }
        .btn-cancel {
            background-color: #e9ecef;
            border: none;
        }
        .btn-cancel:hover {
            background-color: #dee2e6;
        }
        .validation-message {
            font-size: 0.875rem;
            margin-top: 4px;
        }
        /* Thêm styles từ AddService */
        .is-valid {
            border: 2px solid #22c55e !important;
        }
        .is-invalid {
            border: 2px solid #f44336 !important;
        }
        .invalid-feedback {
            margin-top: 4px;
            font-size: 0.95em;
            min-height: 18px;
            color: red;
            display: block;
        }
        .is-valid ~ .invalid-feedback {
            color: #22c55e;
        }
        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }
        .section-icon {
            width: 40px;
            height: 40px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .section-title {
            font-weight: 600;
            color: #2c3e50;
            margin: 0;
        }

        /* 
          START: Final & Robust Styles for Select2
          Using Flexbox to re-order elements and solve conflicts.
        */
        .select2-container .select2-selection--single {
            display: flex !important;
            align-items: center !important;
            position: relative;
        }
        .select2-container--default .select2-selection--single .select2-selection__arrow {
            order: 3;
            width: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            right: 0;
            left: auto;
            margin-left: auto;
            pointer-events: none;
            background: transparent;
            z-index: 1;
        }
        .select2-container--default .select2-selection--single .select2-selection__rendered {
            order: 2;
            flex-grow: 1;
            line-height: 48px;
            color: #495057;
            padding: 0 16px 0 5px !important;
            padding-right: 40px !important;
        }
        .select2-container--default.select2-container--allow-clear .select2-selection--single .select2-selection__rendered {
            padding-right: 60px !important;
        }
        .select2-dropdown {
            border-radius: 12px !important;
            border: 1px solid #ced4da !important;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .select2-search--dropdown .select2-search__field {
             border-radius: 8px;
             border: 1px solid #ced4da;
             padding: 8px 12px;
        }

        /* Validation styles for Select2 */
        select.is-invalid + .select2-container .select2-selection--single {
            border: 2px solid #f44336 !important;
        }
        select.is-valid + .select2-container .select2-selection--single {
            border: 2px solid #22c55e !important;
        }
        .valid-feedback {
            color: #22c55e !important;
            font-size: 0.95em;
            margin-top: 4px;
            min-height: 18px;
            display: block;
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
    </style>
</head>
<body class="profile-body">
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Thêm nhân viên mới</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="staff" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Trở lại danh sách nhân viên
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Thêm nhân viên mới</li>
                </ul>
            </div>

            <div class="card form-card">
                <div class="card-header">
                    <h5 class="card-title">Thông tin cơ bản</h5>
                    <p class="card-subtitle mb-0">Vui lòng điền đầy đủ các thông tin dưới đây.</p>
                </div>
                <div class="card-body">
                    <div class="row justify-content-center">
                        <div class="col-xl-10">
                            <form id="addStaffForm" action="staff" method="post">
                                <input type="hidden" name="service" value="insert" />
                                
                                <!-- =================================== Thông tin người dùng =================================== -->
                                <div class="mb-32">
                                    <div class="section-header">
                                        <div class="section-icon bg-primary-50">
                                            <iconify-icon icon="solar:user-outline" class="text-primary text-xl"></iconify-icon>
                                        </div>
                                        <h6 class="section-title">Thông tin người dùng</h6>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="userSelect" class="form-label">
                                                    Chọn người dùng <span class="text-danger-600">*</span>
                                                </label>
                                                <select id="userSelect" name="userId" required>
                                                    <option></option> <!-- Option trống cho placeholder của Select2 -->
                                                    <c:forEach var="user" items="${userList}">
                                                        <option value="${user.userId}" data-fullname="${user.fullName}" data-birthday="${user.birthday}">${user.userId} - ${user.fullName}</option>
                                                    </c:forEach>
                                                </select>
                                                <div class="valid-feedback" id="userSelectValid"></div>
                                                <div class="invalid-feedback" id="userSelectError"></div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label for="fullNameInput" class="form-label">Họ và tên</label>
                                                <input type="text" id="fullNameInput" name="fullName" class="form-control" readonly placeholder="Tên sẽ tự động điền..." />
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- =================================== Thông tin chuyên môn =================================== -->
                                <div class="mb-32">
                                    <div class="section-header">
                                        <div class="section-icon bg-info-50">
                                            <iconify-icon icon="solar:user-id-outline" class="text-info text-xl"></iconify-icon>
                                        </div>
                                        <h6 class="section-title">Thông tin chuyên môn</h6>
                                    </div>
                                    <div class="form-group position-relative" style="max-width:100%;">
                                        <label for="bio" class="form-label">Tiểu sử <span class="text-danger-600">*</span></label>
                                        <div style="position:relative;">
                                            <textarea name="bio" class="form-control" id="bio"
                                                placeholder="Viết mô tả ngắn về nhân viên (tối thiểu 20 ký tự)..."
                                                rows="4" minlength="20" maxlength="500" required
                                                style="transition: height 0.2s; resize: none; min-height: 120px; max-height: 220px;"></textarea>
                                        </div>
                                        <div class="valid-feedback" id="bioValid"></div>
                                        <div class="invalid-feedback" id="bioError"></div>
                                        <button type="button" id="toggleBioSize" class="btn btn-outline-secondary btn-sm mt-2">Mở rộng</button>
                                        <div class="d-flex justify-content-end align-items-center" style="margin-top: 4px;">
                                            <small class="text-muted"><span id="bioCharCount">0</span>/500</small>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="serviceTypeId" class="form-label">
                                                Loại dịch vụ <span class="text-danger-600">*</span>
                                            </label>
                                            <select name="serviceTypeId" id="serviceTypeId" required>
                                                <option></option> <!-- Option trống cho placeholder của Select2 -->
                                                <c:forEach var="serviceType" items="${serviceTypes}">
                                                    <option value="${serviceType.serviceTypeId}">${serviceType.name}</option>
                                                </c:forEach>
                                            </select>
                                            <div class="valid-feedback" id="serviceTypeIdValid"></div>
                                            <div class="invalid-feedback" id="serviceTypeIdError"></div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label for="availabilityStatus" class="form-label">
                                                Trạng thái làm việc <span class="text-danger-600">*</span>
                                            </label>
                                            <select name="availabilityStatus" id="availabilityStatus" required>
                                                 <option></option> <!-- Option trống cho placeholder của Select2 -->
                                                <option value="AVAILABLE">Sẵn sàng</option>
                                                <option value="BUSY">Bận</option>
                                                <option value="OFFLINE">Ngoại tuyến</option>
                                                <option value="ON_LEAVE">Nghỉ phép</option>
                                            </select>
                                            <div class="valid-feedback" id="availabilityStatusValid"></div>
                                            <div class="invalid-feedback" id="availabilityStatusError"></div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                         <div class="form-group">
                                            <label for="yearsOfExperience" class="form-label">
                                                Số năm kinh nghiệm <span class="text-danger-600">*</span>
                                            </label>
                                            <input type="number" id="yearsOfExperience" name="yearsOfExperience"
                                                class="form-control" required min="0" max="27"
                                                inputmode="numeric" pattern="[0-9]*" autocomplete="off" />
                                            <div class="invalid-feedback" id="yearsOfExperienceError"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center justify-content-end gap-3 mt-4">
                                     <a href="staff" class="btn btn-outline-danger border border-danger-600 px-40 py-11 radius-8">Hủy</a>
                                     <button type="submit" class="btn btn-primary border border-primary-600 text-md px-40 py-12 radius-8">Lưu thông tin</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // --- Initialize Select2 ---
            $('#userSelect').select2({
                placeholder: "-- Chọn người dùng --",
                allowClear: true,
                width: '100%'
            });
             $('#serviceTypeId').select2({
                placeholder: "-- Chọn loại dịch vụ --",
                allowClear: true,
                width: '100%'
            });
             $('#availabilityStatus').select2({
                placeholder: "-- Chọn trạng thái --",
                allowClear: true,
                width: '100%'
            });


            // --- User Selection ---
            const userSelect = document.getElementById('userSelect');
            const fullNameInput = document.getElementById('fullNameInput');
            const experienceInput = document.getElementById('yearsOfExperience');

            $('#userSelect').on('change', function() {
                const selectedOption = this.options[this.selectedIndex];
                const fullName = $(selectedOption).data('fullname');
                const birthday = $(selectedOption).data('birthday');
                fullNameInput.value = fullName || 'Tên sẽ tự động điền...';

                if (this.value !== '') {
                    $.get('staff', { service: 'check-duplicate', userId: this.value }, function(res) {
                        if (res.exists) {
                            setFieldInvalid(userSelect, res.message);
                            userSelect.value = '';
                            fullNameInput.value = '';
                        } else {
                            setFieldValid(userSelect, 'Đã chọn người dùng.');
                        }
                    }, 'json');
                } else {
                    setFieldInvalid(userSelect, 'Vui lòng chọn một người dùng.');
                }

                // Tính số năm kinh nghiệm tối đa
                if (birthday) {
                    const birthDate = new Date(birthday);
                    const today = new Date();
                    let age = today.getFullYear() - birthDate.getFullYear();
                    const m = today.getMonth() - birthDate.getMonth();
                    if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                        age--;
                    }
                    const maxExp = Math.max(0, age - 18);
                    experienceInput.max = maxExp;
                    experienceInput.value = '';
                    experienceInput.placeholder = `Tối đa: ${maxExp}`;
                }
            });

            // --- Bio Validation ---
            const bioTextarea = document.getElementById('bio');
            const bioValidMsg = document.getElementById('bioValidMsg');
            const bioError = document.getElementById('bioError');
            const toggleBioSizeBtn = document.getElementById('toggleBioSize');
            const bioCharCount = document.getElementById('bioCharCount');

            const DEFAULT_HEIGHT = 120;
            const EXPANDED_HEIGHT = 220;
            let isExpanded = false;

            const validateBio = () => {
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
            };
            bioTextarea.addEventListener('input', validateBio);

            // --- Experience Validation ---
            const experienceError = document.getElementById('yearsOfExperienceError');
            const maxExp = parseInt(experienceInput.max, 10);

            experienceInput.addEventListener('input', function() {
                const value = this.value;
                if (value === '') {
                    setFieldInvalid(experienceInput, 'Số năm kinh nghiệm không được để trống.');
                } else if (isNaN(value) || value < 0) {
                    setFieldInvalid(experienceInput, 'Kinh nghiệm phải là số không âm.');
                } else if (parseInt(value, 10) > maxExp) {
                    setFieldInvalid(experienceInput, `Số năm kinh nghiệm phải nhỏ hơn hoặc bằng ${maxExp}.`);
                } else {
                    setFieldValid(experienceInput, ''); // Không hiện "Kinh nghiệm hợp lệ."
                }
            });

            // --- Service Type Validation ---
            const serviceTypeSelect = document.getElementById('serviceTypeId');
            $('#serviceTypeId').on('change', function() {
                if (this.value === '') {
                    setFieldInvalid(this, 'Vui lòng chọn loại dịch vụ.');
                } else {
                    setFieldValid(this, 'Đã chọn loại dịch vụ.');
                }
            });

            // --- Availability Validation ---
            const availabilitySelect = document.getElementById('availabilityStatus');
            $('#availabilityStatus').on('change', function() {
                if (this.value === '') {
                    setFieldInvalid(this, 'Vui lòng chọn trạng thái làm việc.');
                } else {
                    setFieldValid(this, 'Đã chọn trạng thái.');
                }
            });

            // --- Form Submission ---
            const form = document.getElementById('addStaffForm');
            form.addEventListener('submit', function(e) {
                const isUserValid = userSelect.value !== '';
                const isBioValid = validateBio();
                const isExperienceValid = validateExperience();
                const isServiceTypeValid = serviceTypeSelect.value !== '';
                const isAvailabilityValid = availabilitySelect.value !== '';
                
                if (!isUserValid) {
                    setFieldInvalid(userSelect, 'Vui lòng chọn một người dùng.');
                }
                if (!isServiceTypeValid) {
                    setFieldInvalid(serviceTypeSelect, 'Vui lòng chọn loại dịch vụ.');
                }
                if (!isAvailabilityValid) {
                    setFieldInvalid(availabilitySelect, 'Vui lòng chọn trạng thái làm việc.');
                }

                if (!isUserValid || !isBioValid || !isExperienceValid || !isServiceTypeValid || !isAvailabilityValid) {
                    e.preventDefault();
                    alert('Vui lòng kiểm tra lại các thông tin đã nhập.');
                }
            });

            // Helper functions for validation
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

            // Đếm ký tự
            bioTextarea.addEventListener('input', function() {
                bioCharCount.textContent = this.value.length;
            });

            // Chặn nhập ký tự không phải số
            experienceInput.addEventListener('keypress', function(e) {
                if (e.key.length === 1 && !/[0-9]/.test(e.key)) {
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html>
