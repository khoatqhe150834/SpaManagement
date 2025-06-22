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
            border-radius: 12px;
            padding: 12px 16px;
            border: 1px solid #ced4da;
            transition: all 0.3s ease;
        }
        .form-select {
            text-overflow: ellipsis;
            white-space: nowrap;
            overflow: hidden;
            min-height: 48px;
            line-height: 1.5;
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
    </style>
</head>
<body class="profile-body">
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h4 class="page-title">Tạo hồ sơ nhân viên</h4>
                <a href="staff" class="btn btn-light d-flex align-items-center gap-1">
                    <iconify-icon icon="solar:arrow-left-outline" class="icon text-lg"></iconify-icon>
                    Quay lại danh sách
                </a>
            </div>

            <div class="card form-card">
                <div class="card-header">
                    <h5 class="card-title">Thông tin cơ bản</h5>
                    <p class="card-subtitle mb-0">Vui lòng điền đầy đủ các thông tin dưới đây.</p>
                </div>
                <div class="card-body">
                    <form id="addStaffForm" action="staff" method="post">
                        <input type="hidden" name="service" value="insert" />
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="userSelect" class="form-label">Chọn người dùng</label>
                                    <select id="userSelect" name="userId" class="form-select" required>
                                        <option value="" data-fullname="">-- Chọn từ danh sách người dùng --</option>
                                        <c:forEach var="user" items="${userList}">
                                            <option value="${user.userId}" data-fullname="${user.fullName}">${user.userId} - ${user.fullName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="fullNameInput" class="form-label">Họ và tên</label>
                                    <input type="text" id="fullNameInput" name="fullName" class="form-control" readonly placeholder="Tên sẽ tự động điền..." />
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="bio" class="form-label">Tiểu sử</label>
                            <textarea name="bio" class="form-control" id="bio" placeholder="Viết mô tả ngắn về nhân viên (tối thiểu 20 ký tự)..." rows="4" style="resize: none;" minlength="20" maxlength="500" required></textarea>
                            <div class="d-flex justify-content-between">
                                <small id="bioValidationMessage" class="validation-message text-danger"></small>
                                <small class="text-muted"><span id="bioCharCount">0</span>/500</small>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="serviceTypeId" class="form-label">Loại dịch vụ</label>
                                    <select name="serviceTypeId" class="form-select" id="serviceTypeId" required>
                                        <c:forEach var="serviceType" items="${serviceTypes}">
                                            <option value="${serviceType.serviceTypeId}">${serviceType.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="availabilityStatus" class="form-label">Trạng thái làm việc</label>
                                    <select name="availabilityStatus" class="form-select" id="availabilityStatus" required>
                                        <option value="AVAILABLE">Sẵn sàng</option>
                                        <option value="BUSY">Bận</option>
                                        <option value="OFFLINE">Ngoại tuyến</option>
                                        <option value="ON_LEAVE">Nghỉ phép</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-4">
                                 <div class="form-group">
                                    <label for="yearsOfExperience" class="form-label">Số năm kinh nghiệm</label>
                                    <input type="number" name="yearsOfExperience" class="form-control" id="yearsOfExperience" required min="0" max="100" placeholder="Ví dụ: 5"/>
                                    <small id="experienceValidationMessage" class="validation-message text-danger"></small>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="form-actions">
                     <a href="staff" class="btn btn-cancel">Hủy</a>
                     <button type="submit" form="addStaffForm" class="btn btn-primary">Lưu thông tin</button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // --- User Selection ---
            const userSelect = document.getElementById('userSelect');
            const fullNameInput = document.getElementById('fullNameInput');

            userSelect.addEventListener('change', function() {
                const selectedOption = this.options[this.selectedIndex];
                const fullName = selectedOption.getAttribute('data-fullname');
                fullNameInput.value = fullName || 'Tên sẽ tự động điền...';
            });

            // --- Bio Validation ---
            const bioTextarea = document.getElementById('bio');
            const bioCharCount = document.getElementById('bioCharCount');
            const bioValidationMessage = document.getElementById('bioValidationMessage');
            const MIN_BIO_LENGTH = 20;
            const MAX_BIO_LENGTH = 500;

            const validateBio = () => {
                const length = bioTextarea.value.trim().length;
                bioCharCount.textContent = length;
                
                if (length > 0 && length < MIN_BIO_LENGTH) {
                    bioValidationMessage.textContent = `Cần ít nhất ${MIN_BIO_LENGTH} ký tự.`;
                    return false;
                } else {
                    bioValidationMessage.textContent = '';
                    return true;
                }
            };
            bioTextarea.addEventListener('input', validateBio);

            // --- Experience Validation ---
            const experienceInput = document.getElementById('yearsOfExperience');
            const experienceValidationMessage = document.getElementById('experienceValidationMessage');

            const validateExperience = () => {
                const value = parseInt(experienceInput.value, 10);
                if (isNaN(value) || value < 0 || value > 100) {
                    experienceValidationMessage.textContent = 'Kinh nghiệm phải là số từ 0 đến 100.';
                    return false;
                } else {
                    experienceValidationMessage.textContent = '';
                    return true;
                }
            };
            experienceInput.addEventListener('input', validateExperience);

            // --- Form Submission ---
            const form = document.getElementById('addStaffForm');
            form.addEventListener('submit', function(e) {
                const isBioValid = validateBio();
                const isExperienceValid = validateExperience();
                const isUserSelected = userSelect.value !== '';
                
                if (!isUserSelected) {
                     alert('Vui lòng chọn một người dùng.');
                     e.preventDefault();
                     return;
                }

                if (!isBioValid || !isExperienceValid) {
                    e.preventDefault(); // Stop form submission
                    alert('Vui lòng kiểm tra lại các thông tin đã nhập.');
                }
            });
        });
    </script>
</body>
</html>
