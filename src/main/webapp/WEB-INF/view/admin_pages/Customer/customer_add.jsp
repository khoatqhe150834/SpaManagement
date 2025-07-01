<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Thêm khách hàng mới</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/remixicon.css"/>
    <style>
        .container { max-width: 600px; margin-top: 40px; }
        .card { border-radius: 16px; box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
        .card-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #fff; border-radius: 16px 16px 0 0; }
        .form-label { font-weight: 600; color: #495057; }
        .form-control:focus { border-color: #667eea; box-shadow: 0 0 0 0.2rem rgba(102,126,234,.15); }
        .required-field::after { content: " *"; color: #dc3545; }
        .error-text { width: 100%; margin-top: .25rem; font-size: 80%; color: #dc3545; }
        .is-invalid { border-color: #dc3545 !important; }
        .input-group-text { background: #f3f4f6; border: none; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; font-weight: 600; }
        .btn-primary:hover { background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%); }
        .btn-secondary { font-weight: 600; }
    </style>
</head>
<body>
     <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
     <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
<div class="container">
    <div class="card">
        <div class="card-header text-center py-4">
            <h4 class="mb-0"><i class="ri-user-add-line mr-2"></i>Thêm khách hàng mới</h4>
        </div>
        <div class="card-body p-4">
            <c:if test="${not empty error}">
                <div class="alert alert-danger mb-3">${error}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/customer/create" method="post" novalidate>
                <div class="form-group mb-3">
                    <label class="form-label required-field" for="fullName">Họ và tên</label>
                    <div class="input-group">
                        <div class="input-group-prepend"><span class="input-group-text"><i class="ri-user-line"></i></span></div>
                        <input type="text" class="form-control ${not empty errors.fullName ? 'is-invalid' : ''}" id="fullName" name="fullName" required maxlength="100" value="${not empty customerInput.fullName ? customerInput.fullName : ''}" placeholder="Nhập họ và tên">
                    </div>
                    <div class="error-text"></div>
                </div>
                <div class="form-group mb-3">
                    <label class="form-label required-field" for="email">Email</label>
                    <div class="input-group">
                        <div class="input-group-prepend"><span class="input-group-text"><i class="ri-mail-line"></i></span></div>
                        <input type="email" class="form-control ${not empty errors.email ? 'is-invalid' : ''}" id="email" name="email" required value="${not empty customerInput.email ? customerInput.email : ''}" placeholder="Nhập email">
                    </div>
                    <div class="error-text">${errors.email}</div>
                </div>
                <div class="form-group mb-3">
                    <label class="form-label required-field" for="password">Mật khẩu</label>
                    <div class="input-group">
                        <div class="input-group-prepend"><span class="input-group-text"><i class="ri-lock-password-line"></i></span></div>
                        <input type="password" class="form-control ${not empty errors.password ? 'is-invalid' : ''}" id="password" name="password" required minlength="7" placeholder="Nhập mật khẩu">
                    </div>
                    <div class="error-text"></div>
                </div>
                <div class="form-group mb-3">
                    <label class="form-label" for="phoneNumber">Số điện thoại</label>
                    <div class="input-group">
                        <div class="input-group-prepend"><span class="input-group-text"><i class="ri-phone-line"></i></span></div>
                        <input type="tel" class="form-control ${not empty errors.phoneNumber ? 'is-invalid' : ''}" id="phoneNumber" name="phoneNumber" pattern="^0\d{9}$" title="Số điện thoại phải gồm 10 số và bắt đầu bằng số 0." value="${not empty customerInput.phoneNumber ? customerInput.phoneNumber : ''}" placeholder="Nhập số điện thoại">
                    </div>
                    <div class="error-text">${errors.phoneNumber}</div>
                </div>
                <div class="form-group mb-3">
                    <label class="form-label" for="gender">Giới tính</label>
                    <select class="form-control" name="gender" id="gender">
                        <option value="">-- Chọn giới tính --</option>
                        <option value="Male" ${customerInput.gender == 'Male' ? 'selected' : ''}>Nam</option>
                        <option value="Female" ${customerInput.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                        <option value="Other" ${customerInput.gender == 'Other' ? 'selected' : ''}>Khác</option>
                    </select>
                </div>
                <div class="form-group mb-3">
                    <label class="form-label" for="birthday">Ngày sinh</label>
                    <div class="input-group">
                        <div class="input-group-prepend"><span class="input-group-text"><i class="ri-calendar-line"></i></span></div>
                        <input type="date" class="form-control ${not empty errors.birthday ? 'is-invalid' : ''}" id="birthday" name="birthday" value="${customerInput.birthday}">
                    </div>
                    <div class="error-text"></div>
                </div>
                <div class="form-group mb-4">
                    <label class="form-label" for="address">Địa chỉ</label>
                    <div class="input-group">
                        <div class="input-group-prepend"><span class="input-group-text"><i class="ri-map-pin-line"></i></span></div>
                        <input type="text" class="form-control" id="address" name="address" value="${not empty customerInput.address ? customerInput.address : ''}" placeholder="Nhập địa chỉ">
                    </div>
                </div>
                <div class="form-group mb-3">
                    <label class="form-label" for="notes">Ghi chú</label>
                    <textarea class="form-control" id="notes" name="notes" rows="3" maxlength="500">${not empty customerInput.notes ? customerInput.notes : ''}</textarea>
                    <div class="error-text"></div>
                </div>
                <div class="d-flex gap-2 justify-content-end">
                    <a href="${pageContext.request.contextPath}/customer/list" class="btn btn-secondary">
                        <i class="ri-arrow-left-line"></i> Quay lại danh sách
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="ri-user-add-line"></i> Thêm khách hàng
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
     <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
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
        const namePattern = /^[\p{L}\s]+$/u;
        if (!fullName) {
            showError($('#fullName'), 'Tên là bắt buộc.');
            valid = false;
        } else if (fullName.length < 2 || fullName.length > 100) {
            showError($('#fullName'), 'Tên phải có độ dài từ 2 đến 100 ký tự.');
            valid = false;
        } else if (fullName.includes('  ')) {
            showError($('#fullName'), 'Tên không được có nhiều khoảng trắng liền kề.');
            valid = false;
        } else if (!fullName.includes(' ')) {
            showError($('#fullName'), 'Tên đầy đủ cần có ít nhất hai từ (ví dụ: An Nguyen).');
            valid = false;
        } else if (!namePattern.test(fullName)) {
            showError($('#fullName'), 'Tên chỉ được chứa chữ cái và khoảng trắng, không được chứa số hoặc ký tự đặc biệt.');
            valid = false;
        } else {
            clearError($('#fullName'));
        }
        // Validate Email
        const email = $('#email').val().trim();
        // Regex: phải có @, phải có dấu chấm sau @, không có ký tự không hợp lệ
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
        // Validate Password
        const password = $('#password').val();
        if (!password) {
            showError($('#password'), 'Password is required.');
            valid = false;
        } else if (password.length < 7) {
            showError($('#password'), 'Password must be at least 7 characters.');
            valid = false;
        } else {
            clearError($('#password'));
        }
        // Validate Phone Number (optional)
        const phone = $('#phoneNumber').val().trim();
        if (phone && !/^0\d{9}$/.test(phone)) {
            showError($('#phoneNumber'), 'Phone number must be 10 digits starting with 0.');
            valid = false;
        } else if (!phoneUnique) {
            showError($('#phoneNumber'), 'Số điện thoại đã tồn tại.');
            valid = false;
        } else {
            clearError($('#phoneNumber'));
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
        // Validate Notes (optional, max 500 chars)
        const notes = $('#notes').val();
        if (notes && notes.length > 500) {
            showError($('#notes'), 'Ghi chú tối đa 500 ký tự.');
            valid = false;
        } else {
            clearError($('#notes'));
        }
        if (!valid) e.preventDefault();
    });
});
</script>
</body>
</html>
