<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EDIT CUSTOMER</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
     <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
    <div class="container mt-5">
        <div class="card">
            <div class="card-header">
                <h3>Chỉnh sửa Thông tin Khách hàng</h3>
            </div>
            <div class="card-body">
                <c:if test="${not empty customer}">
                    <form action="${pageContext.request.contextPath}/customer/update" method="POST">
                        <!-- Trường ẩn để gửi ID khách hàng -->
                        <input type="hidden" name="customerId" value="${customer.customerId}">
                        <input type="hidden" name="page" value="${param.page}" />
                        <input type="hidden" name="pageSize" value="${param.pageSize}" />
                        <input type="hidden" name="searchValue" value="${param.searchValue}" />
                        <input type="hidden" name="status" value="${param.status}" />

                        <div class="row">
                            <!-- Cột trái -->
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="fullName" class="form-label">Họ và Tên</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" value="<c:out value="${customer.fullName}"/>" required>
                                    <div class="error-text"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Địa chỉ Email</label>
                                    <input type="email" class="form-control" id="email" name="email" value="<c:out value="${customer.email}"/>" required>
                                    <div class="error-text"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="phoneNumber" class="form-label">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="<c:out value="${customer.phoneNumber}"/>">
                                    <div class="error-text"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="gender" class="form-label">Giới tính</label>
                                    <select class="form-select" id="gender" name="gender">
                                        <option value="MALE" ${customer.gender == 'MALE' ? 'selected' : ''}>Nam</option>
                                        <option value="FEMALE" ${customer.gender == 'FEMALE' ? 'selected' : ''}>Nữ</option>
                                        <option value="OTHER" ${customer.gender == 'OTHER' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>
                                 <div class="mb-3">
                                    <label for="address" class="form-label">Địa chỉ</label>
                                    <textarea class="form-control" id="address" name="address" rows="3"><c:out value="${customer.address}"/></textarea>
                                </div>
                            </div>

                            <!-- Cột phải -->
                            <div class="col-md-6">
                               <div class="mb-3">
                                    <label for="birthday" class="form-label">Ngày sinh</label>
                                    <input type="date" class="form-control" id="birthday" name="birthday" value="<fmt:formatDate value="${customer.birthday}" pattern="yyyy-MM-dd" />">
                                    <div class="error-text"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="loyaltyPoints" class="form-label">Điểm thân thiết</label>
                                    <input type="number" class="form-control" id="loyaltyPoints" name="loyaltyPoints" value="${customer.loyaltyPoints}" min="0">
                                </div>
                                <div class="mb-3 form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="isActive" name="active" ${customer.active ? 'checked' : ''}>
                                    <label class="form-check-label" for="isActive">Tài khoản đang hoạt động</label>
                                </div>
                                <div class="mb-3 form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="isVerified" name="verified" ${customer.verified ? 'checked' : ''}>
                                    <label class="form-check-label" for="isVerified">Tài khoản đã xác minh</label>
                                </div>
                            </div>
                        </div>

                        <div class="card-footer text-end">
                            <a href="${pageContext.request.contextPath}/customer/list" class="btn btn-secondary">Hủy</a>
                            <button type="submit" class="btn btn-primary">Cập nhật Khách hàng</button>
                        </div>
                    </form>
                </c:if>

                <c:if test="${empty customer}">
                    <div class="alert alert-danger" role="alert">
                      Không tìm thấy khách hàng để chỉnh sửa. Vui lòng quay lại danh sách.
                    </div>
                </c:if>
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
        input.closest('.mb-3').find('.error-text').text(message);
    }
    function clearError(input) {
        input.removeClass('is-invalid');
        input.closest('.mb-3').find('.error-text').text('');
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
        if (!valid) e.preventDefault();
    });
});
</script>
</body>
</html>
