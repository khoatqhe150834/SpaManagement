<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết người dùng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/remixicon.css"/>
    <style>
        .container { max-width: 800px; margin-top: 40px; }
        .detail-label { font-weight: 600; color: #495057; }
        .detail-value { color: #212529; }
        .avatar-img { width: 120px; height: 120px; object-fit: cover; border-radius: 50%; border: 3px solid #dee2e6; }
        .info-section { background-color: #f8f9fa; border-radius: 8px; padding: 20px; margin-bottom: 20px; }
        .section-title { color: #495057; font-weight: 600; margin-bottom: 15px; border-bottom: 2px solid #dee2e6; padding-bottom: 8px; }
        .status-badge { transition: all 0.3s ease; }
        .action-buttons { transition: all 0.3s ease; }
    </style>
</head>
<body>
     <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
     <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-primary mb-0">Chi tiết người dùng</h3>
    </div>

    <!-- Success/Error Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>
            ${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
        </div>
        <% session.removeAttribute("successMessage"); %>
    </c:if>
    
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i>
            ${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
        </div>
        <% session.removeAttribute("errorMessage"); %>
    </c:if>

    <div class="row">
        <!-- Avatar and Basic Info -->
        <div class="col-md-4">
            <div class="info-section text-center">
                <div class="section-title">Ảnh đại diện</div>
                <img src="${not empty user.avatarUrl ? user.avatarUrl : 'https://placehold.co/120x120/7C3AED/FFFFFF?text=USER'}" 
                     alt="Ảnh đại diện" class="avatar-img mb-3">
                <h5 class="mb-2">${user.fullName}</h5>
                <span id="statusBadge" class="badge status-badge ${user.isActive ? 'badge-success' : 'badge-secondary'}">
                    ${user.isActive ? 'Đang hoạt động' : 'Ngưng hoạt động'}
                </span>
            </div>
        </div>

        <!-- User Information -->
        <div class="col-md-8">
            <div class="info-section">
                <div class="section-title">Thông tin chi tiết người dùng</div>
                <div class="row mb-3"><div class="col-sm-4 detail-label">Mã ND:</div><div class="col-sm-8 detail-value">${user.userId}</div></div>
                <div class="row mb-3"><div class="col-sm-4 detail-label">Ảnh đại diện:</div><div class="col-sm-8 detail-value">
                    <img src="${not empty user.avatarUrl ? user.avatarUrl : 'https://placehold.co/120x120/7C3AED/FFFFFF?text=USER'}" alt="Avatar" class="avatar-img mb-2">
                    <div><c:choose><c:when test="${not empty user.avatarUrl}"><a href="${user.avatarUrl}" target="_blank">${user.avatarUrl}</a></c:when><c:otherwise>Ảnh mặc định</c:otherwise></c:choose></div>
                </div></div>
                <div class="row mb-3"><div class="col-sm-4 detail-label">Họ và tên:</div><div class="col-sm-8 detail-value">${not empty user.fullName ? user.fullName : 'Chưa cung cấp'}</div></div>
                <div class="row mb-3"><div class="col-sm-4 detail-label">Email:</div><div class="col-sm-8 detail-value">${not empty user.email ? user.email : 'Chưa cung cấp'}</div></div>
                <div class="row mb-3"><div class="col-sm-4 detail-label">Số điện thoại:</div><div class="col-sm-8 detail-value">${not empty user.phoneNumber ? user.phoneNumber : 'Chưa cung cấp'}</div></div>
                <div class="row mb-3"><div class="col-sm-4 detail-label">Trạng thái:</div><div class="col-sm-8 detail-value">
                    <span class="badge ${user.isActive ? 'bg-success' : 'bg-secondary'}">${user.isActive ? 'Đang hoạt động' : 'Ngưng hoạt động'}</span>
                </div></div>
                <div class="row mb-3"><div class="col-sm-4 detail-label">Giới tính:</div><div class="col-sm-8 detail-value">${not empty user.gender ? user.gender : 'Chưa xác định'}</div></div>
                <div class="row mb-3"><div class="col-sm-4 detail-label">Ngày sinh:</div><div class="col-sm-8 detail-value">
                    <c:choose>
                        <c:when test="${not empty user.birthday}"><fmt:formatDate value="${user.birthday}" pattern="dd/MM/yyyy"/></c:when>
                        <c:otherwise>Chưa cung cấp</c:otherwise>
                    </c:choose>
                </div></div>
                <div class="row mb-3"><div class="col-sm-4 detail-label">Địa chỉ:</div><div class="col-sm-8 detail-value">${not empty user.address ? user.address : 'Chưa cung cấp'}</div></div>
                <div class="row mb-3"><div class="col-sm-4 detail-label">Đăng nhập gần nhất:</div><div class="col-sm-8 detail-value">
                    <c:choose>
                        <c:when test="${not empty user.lastLoginAt}"><fmt:formatDate value="${user.lastLoginAt}" pattern="dd/MM/yyyy HH:mm:ss"/></c:when>
                        <c:otherwise>Chưa đăng nhập</c:otherwise>
                    </c:choose>
                </div></div>
                <div class="row mb-3"><div class="col-sm-4 detail-label">Ngày tạo:</div><div class="col-sm-8 detail-value">
                    <c:choose>
                        <c:when test="${not empty user.createdAt}"><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></c:when>
                        <c:otherwise>Không có dữ liệu</c:otherwise>
                    </c:choose>
                </div></div>
                <div class="row mb-3"><div class="col-sm-4 detail-label">Ngày cập nhật:</div><div class="col-sm-8 detail-value">
                    <c:choose>
                        <c:when test="${not empty user.updatedAt}"><fmt:formatDate value="${user.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss"/></c:when>
                        <c:otherwise>Không có dữ liệu</c:otherwise>
                    </c:choose>
                </div></div>
            </div>
        </div>
    </div>

    <!-- Action Buttons -->
    <div class="text-center mt-4 action-buttons" id="actionButtons">
        <a href="${pageContext.request.contextPath}/user/list" class="btn btn-secondary">
            <i class="fas fa-list"></i> Quay lại danh sách
        </a>
        <a href="${pageContext.request.contextPath}/user/edit?id=${user.userId}" class="btn btn-primary ml-2">
            <i class="fas fa-edit"></i> Chỉnh sửa
        </a>
    </div>
</div>
     <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
     <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
     
     <script>
        function toggleUserStatus(userId, activate) {
            const action = activate ? 'activate' : 'deactivate';
            const actionText = activate ? 'kích hoạt' : 'ngưng hoạt động';
            const confirmText = activate ? 'kích hoạt người dùng này' : 'ngưng hoạt động người dùng này';
            
            Swal.fire({
                title: 'Bạn chắc chắn?',
                text: 'Bạn muốn ' + confirmText + '?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: activate ? '#28a745' : '#ffc107',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Đồng ý',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Show loading
                    Swal.fire({
                        title: '🔄 Đang xử lý...',
                        text: 'Vui lòng chờ trong giây lát',
                        icon: 'info',
                        allowOutsideClick: false,
                        showConfirmButton: false,
                        willOpen: () => {
                            Swal.showLoading();
                        }
                    });
                    
                    // Make AJAX request
                    fetch(window.location.origin + window.location.pathname.replace('/view', '/' + action) + '?id=' + userId + '&fromDetails=true', {
                        method: 'GET',
                        headers: {
                            'Content-Type': 'application/json',
                        }
                    })
                    .then(response => {
                        if (response.ok) {
                            // Update UI immediately
                            updateUserStatus(activate);
                            
                            // Show success message
                            Swal.fire({
                                title: '🎉 Thành công!',
                                text: 'Tài khoản đã được ' + actionText + ' thành công!',
                                icon: 'success',
                                timer: 2000,
                                showConfirmButton: false
                            });
                        } else {
                            throw new Error('Network response was not ok');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        Swal.fire({
                            title: '❌ Lỗi!',
                            text: 'Không thể ' + actionText + '. Vui lòng thử lại.',
                            icon: 'error',
                            confirmButtonText: 'OK'
                        });
                    });
                }
            });
        }
        
        function updateUserStatus(isActive) {
            // Update status badges
            const statusBadge = document.getElementById('statusBadge');
            const statusValue = document.getElementById('statusValue');
            
            if (isActive) {
                // User is now active
                statusBadge.className = 'badge status-badge badge-success';
                statusBadge.textContent = 'Đang hoạt động';
                statusValue.className = 'badge badge-success';
                statusValue.textContent = 'Đang hoạt động';
            } else {
                // User is now inactive
                statusBadge.className = 'badge status-badge badge-secondary';
                statusBadge.textContent = 'Ngưng hoạt động';
                statusValue.className = 'badge badge-secondary';
                statusValue.textContent = 'Ngưng hoạt động';
            }
        }
     </script>
</body>
</html>
