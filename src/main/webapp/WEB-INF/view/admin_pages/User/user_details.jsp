<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Details</title>
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
        <h3 class="text-primary mb-0">User Details</h3>
        <div>
            <a href="${pageContext.request.contextPath}/user/list" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to List
            </a>
            <a href="${pageContext.request.contextPath}/user/edit?id=${user.userId}" class="btn btn-primary ml-2">
                <i class="fas fa-edit"></i> Edit User
            </a>
        </div>
    </div>

    <!-- Success/Error Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>
            ${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("successMessage"); %>
    </c:if>
    
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i>
            ${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("errorMessage"); %>
    </c:if>

    <div class="row">
        <!-- Avatar and Basic Info -->
        <div class="col-md-4">
            <div class="info-section text-center">
                <div class="section-title">Profile Picture</div>
                <img src="${not empty user.avatarUrl ? user.avatarUrl : 'https://placehold.co/120x120/7C3AED/FFFFFF?text=USER'}" 
                     alt="User Avatar" class="avatar-img mb-3">
                <h5 class="mb-2">${user.fullName}</h5>
                <span id="statusBadge" class="badge status-badge ${user.isActive ? 'badge-success' : 'badge-secondary'}">
                    ${user.isActive ? 'Active' : 'Inactive'}
                </span>
            </div>
        </div>

        <!-- User Information -->
        <div class="col-md-8">
            <div class="info-section">
                <div class="section-title">Basic Information</div>
                <div class="row mb-3">
                    <div class="col-sm-4 detail-label">User ID:</div>
                    <div class="col-sm-8 detail-value">${user.userId}</div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-4 detail-label">Full Name:</div>
                    <div class="col-sm-8 detail-value">${user.fullName}</div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-4 detail-label">Email:</div>
                    <div class="col-sm-8 detail-value">${user.email}</div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-4 detail-label">Phone Number:</div>
                    <div class="col-sm-8 detail-value">${not empty user.phoneNumber ? user.phoneNumber : 'Not provided'}</div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-4 detail-label">Gender:</div>
                    <div class="col-sm-8 detail-value">${not empty user.gender ? user.gender : 'Not specified'}</div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-4 detail-label">Birthday:</div>
                    <div class="col-sm-8 detail-value">
                        <c:choose>
                            <c:when test="${not empty user.birthday}">
                                <fmt:formatDate value="${user.birthday}" pattern="dd/MM/yyyy"/>
                            </c:when>
                            <c:otherwise>Not provided</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-4 detail-label">Address:</div>
                    <div class="col-sm-8 detail-value">${not empty user.address ? user.address : 'Not provided'}</div>
                </div>
            </div>

            <div class="info-section">
                <div class="section-title">Account Information</div>
                <div class="row mb-3">
                    <div class="col-sm-4 detail-label">Role:</div>
                    <div class="col-sm-8 detail-value">
                        <c:choose>
                            <c:when test="${user.roleId == 1}">
                                <span class="badge badge-primary">Admin</span>
                            </c:when>
                            <c:when test="${user.roleId == 2}">
                                <span class="badge badge-info">Manager</span>
                            </c:when>
                            <c:when test="${user.roleId == 3}">
                                <span class="badge badge-success">Therapist</span>
                            </c:when>
                            <c:when test="${user.roleId == 4}">
                                <span class="badge badge-warning">Receptionist</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-secondary">Unknown (ID: ${user.roleId})</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-4 detail-label">Status:</div>
                    <div class="col-sm-8 detail-value">
                        <span id="statusValue" class="badge ${user.isActive ? 'badge-success' : 'badge-secondary'}">
                            ${user.isActive ? 'Active' : 'Inactive'}
                        </span>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-4 detail-label">Last Login:</div>
                    <div class="col-sm-8 detail-value">
                        <c:choose>
                            <c:when test="${not empty user.lastLoginAt}">
                                <fmt:formatDate value="${user.lastLoginAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </c:when>
                            <c:otherwise>Never logged in</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="info-section">
                <div class="section-title">System Information</div>
                <div class="row mb-3">
                    <div class="col-sm-4 detail-label">Created At:</div>
                    <div class="col-sm-8 detail-value">
                        <c:choose>
                            <c:when test="${not empty user.createdAt}">
                                <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </c:when>
                            <c:otherwise>Not available</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-4 detail-label">Updated At:</div>
                    <div class="col-sm-8 detail-value">
                        <c:choose>
                            <c:when test="${not empty user.updatedAt}">
                                <fmt:formatDate value="${user.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </c:when>
                            <c:otherwise>Not available</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-4 detail-label">Avatar URL:</div>
                    <div class="col-sm-8 detail-value">
                        <c:choose>
                            <c:when test="${not empty user.avatarUrl}">
                                <a href="${user.avatarUrl}" target="_blank" class="text-primary">${user.avatarUrl}</a>
                            </c:when>
                            <c:otherwise>Default avatar</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Action Buttons -->
    <div class="text-center mt-4 action-buttons" id="actionButtons">
        <a href="${pageContext.request.contextPath}/user/list" class="btn btn-secondary">
            <i class="fas fa-list"></i> Back to User List
        </a>
        <a href="${pageContext.request.contextPath}/user/edit?id=${user.userId}" class="btn btn-primary ml-2">
            <i class="fas fa-edit"></i> Edit User
        </a>
        <c:if test="${user.isActive}">
            <button type="button" class="btn btn-warning ml-2" onclick="toggleUserStatus(${user.userId}, false)">
                <i class="fas fa-user-slash"></i> Deactivate
            </button>
        </c:if>
        <c:if test="${not user.isActive}">
            <button type="button" class="btn btn-success ml-2" onclick="toggleUserStatus(${user.userId}, true)">
                <i class="fas fa-user-check"></i> Activate
            </button>
        </c:if>
    </div>
</div>
     <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
     <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
     
     <script>
        function toggleUserStatus(userId, activate) {
            const action = activate ? 'activate' : 'deactivate';
            const actionText = activate ? 'activate' : 'deactivate';
            const confirmText = activate ? 'activate this user' : 'deactivate this user';
            
            Swal.fire({
                title: 'Are you sure?',
                text: 'Do you want to ' + confirmText + '?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: activate ? '#28a745' : '#ffc107',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, ' + actionText + '!',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    // Show loading
                    Swal.fire({
                        title: '🔄 Processing...',
                        text: 'Please wait while we ' + actionText + ' the user',
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
                                title: '🎉 Success!',
                                text: 'User has been ' + actionText + 'd successfully!',
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
                            title: '❌ Error!',
                            text: 'Failed to ' + actionText + ' user. Please try again.',
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
            const actionButtons = document.getElementById('actionButtons');
            const userId = getUserIdFromUrl();
            
            if (isActive) {
                // User is now active
                statusBadge.className = 'badge status-badge badge-success';
                statusBadge.textContent = 'Active';
                statusValue.className = 'badge badge-success';
                statusValue.textContent = 'Active';
                
                // Update action button
                actionButtons.innerHTML = 
                    '<a href="' + window.location.origin + window.location.pathname.replace('/view', '/list') + '" class="btn btn-secondary">' +
                        '<i class="fas fa-list"></i> Back to User List' +
                    '</a>' +
                    '<a href="' + window.location.origin + window.location.pathname.replace('/view', '/edit') + '?id=' + userId + '" class="btn btn-primary ml-2">' +
                        '<i class="fas fa-edit"></i> Edit User' +
                    '</a>' +
                    '<button type="button" class="btn btn-warning ml-2" onclick="toggleUserStatus(' + userId + ', false)">' +
                        '<i class="fas fa-user-slash"></i> Deactivate' +
                    '</button>';
            } else {
                // User is now inactive
                statusBadge.className = 'badge status-badge badge-secondary';
                statusBadge.textContent = 'Inactive';
                statusValue.className = 'badge badge-secondary';
                statusValue.textContent = 'Inactive';
                
                // Update action button
                actionButtons.innerHTML = 
                    '<a href="' + window.location.origin + window.location.pathname.replace('/view', '/list') + '" class="btn btn-secondary">' +
                        '<i class="fas fa-list"></i> Back to User List' +
                    '</a>' +
                    '<a href="' + window.location.origin + window.location.pathname.replace('/view', '/edit') + '?id=' + userId + '" class="btn btn-primary ml-2">' +
                        '<i class="fas fa-edit"></i> Edit User' +
                    '</a>' +
                    '<button type="button" class="btn btn-success ml-2" onclick="toggleUserStatus(' + userId + ', true)">' +
                        '<i class="fas fa-user-check"></i> Activate' +
                    '</button>';
            }
        }
        
        function getUserIdFromUrl() {
            const urlParams = new URLSearchParams(window.location.search);
            return urlParams.get('id');
        }
     </script>
</body>
</html> 