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
     <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
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
                    <label class="form-label required-field" for="phoneNumber">Số điện thoại</label>
                    <div class="input-group">
                        <div class="input-group-prepend"><span class="input-group-text"><i class="ri-phone-line"></i></span></div>
                        <input type="tel" class="form-control ${not empty errors.phoneNumber ? 'is-invalid' : ''}" id="phoneNumber" name="phoneNumber" required pattern="^0\d{9}$" title="Số điện thoại phải gồm 10 số và bắt đầu bằng số 0." value="${not empty customerInput.phoneNumber ? customerInput.phoneNumber : ''}" placeholder="Nhập số điện thoại">
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
                    <label class="form-label required-field" for="birthday">Ngày sinh</label>
                    <div class="input-group">
                        <div class="input-group-prepend"><span class="input-group-text"><i class="ri-calendar-line"></i></span></div>
                        <input type="date" class="form-control ${not empty errors.birthday ? 'is-invalid' : ''}" id="birthday" name="birthday" required value="${customerInput.birthday}">
                    </div>
                    <div class="error-text">${errors.birthday}</div>
                </div>
                <div class="form-group mb-4">
                    <label class="form-label required-field" for="address">Địa chỉ</label>
                    <div class="input-group">
                        <div class="input-group-prepend"><span class="input-group-text"><i class="ri-map-pin-line"></i></span></div>
                        <input type="text" class="form-control ${not empty errors.address ? 'is-invalid' : ''}" id="address" name="address" required value="${not empty customerInput.address ? customerInput.address : ''}" placeholder="Nhập địa chỉ">
                    </div>
                    <div class="error-text">${errors.address}</div>
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
            emailErrors.push('Email là bắt buộc.');
        }
        if (email && !emailRegex.test(email)) {
            emailErrors.push('Email không đúng định dạng.');
        }
        if (!emailUnique) {
            emailErrors.push('Email đã tồn tại.');
        }
        if (emailErrors.length > 0) {
            showError($('#email'), emailErrors.join('<br>'));
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
        // Validate Phone Number (required)
        const phone = $('#phoneNumber').val().trim();
        let phoneErrors = [];
        if (!phone) {
            phoneErrors.push('Số điện thoại là bắt buộc.');
        }
        if (phone && !/^0\d{9}$/.test(phone)) {
            phoneErrors.push('Số điện thoại phải gồm 10 số, bắt đầu bằng số 0 và không chứa ký tự đặc biệt.');
        }
        if (phone && /[^0-9]/.test(phone)) {
            phoneErrors.push('Số điện thoại chỉ được chứa số, không được chứa ký tự đặc biệt.');
        }
        if (!phoneUnique) {
            phoneErrors.push('Số điện thoại đã tồn tại.');
        }
        if (phoneErrors.length > 0) {
            showError($('#phoneNumber'), phoneErrors.join('<br>'));
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
        // Validate Address (required)
        const address = $('#address').val().trim();
        if (!address) {
            showError($('#address'), 'Địa chỉ là bắt buộc.');
            valid = false;
        } else {
            clearError($('#address'));
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
