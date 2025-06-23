<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User - Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/remixicon.css"/>
    <style>
        .container { max-width: 800px; margin-top: 40px; }
        .form-label { font-weight: 600; color: #495057; }
        .error-text { width: 100%; margin-top: .25rem; font-size: 80%; color: #dc3545; }
        .is-invalid { border-color: #dc3545 !important; }
        .card { border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
        .card-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 12px 12px 0 0 !important; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; }
        .btn-primary:hover { background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%); }
        .form-control:focus { border-color: #667eea; box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25); }
        .required-field::after { content: " *"; color: #dc3545; }
        .user-avatar { width: 80px; height: 80px; object-fit: cover; border-radius: 50%; border: 3px solid #dee2e6; }
        .current-info { background-color: #f8f9fa; border-radius: 8px; padding: 15px; margin-bottom: 20px; }
    </style>
</head>
<body>
     <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
     <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-primary mb-0">Edit User</h3>
        <a href="${pageContext.request.contextPath}/user/list" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back to User List
        </a>
    </div>

    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-user-edit me-2"></i>
                Edit User Information
            </h5>
        </div>
        <div class="card-body p-4">
            <!-- Current User Info -->
            <div class="current-info">
                <div class="row align-items-center">
                    <div class="col-md-2 text-center">
                        <img src="${not empty user.avatarUrl ? user.avatarUrl : 'https://placehold.co/80x80/7C3AED/FFFFFF?text=USER'}" 
                             alt="User Avatar" class="user-avatar">
                    </div>
                    <div class="col-md-10">
                        <h6 class="mb-1">${user.fullName}</h6>
                        <p class="text-muted mb-1">
                            <i class="fas fa-envelope me-1"></i>${user.email}
                        </p>
                        <p class="text-muted mb-0">
                            <i class="fas fa-id-card me-1"></i>User ID: #${user.userId}
                            <span class="badge ${user.isActive ? 'bg-success' : 'bg-secondary'} ms-2">
                                ${user.isActive ? 'Active' : 'Inactive'}
                            </span>
                        </p>
                    </div>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/user/update" method="post" novalidate id="userEditForm">
                <input type="hidden" name="userId" value="${user.userId}" />
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label required-field" for="fullName">Full Name</label>
                            <input type="text" class="form-control ${not empty errors.fullName ? 'is-invalid' : ''}" 
                                   id="fullName" name="fullName" required maxlength="100" 
                                   value="${user.fullName}" placeholder="Enter full name">
                            <div class="error-text">${errors.fullName}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label required-field" for="email">Email Address</label>
                            <input type="email" class="form-control ${not empty errors.email ? 'is-invalid' : ''}" 
                                   id="email" name="email" required value="${user.email}"
                                   placeholder="Enter email address">
                            <div class="error-text">${errors.email}</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="password">Password</label>
                            <input type="password" class="form-control ${not empty errors.password ? 'is-invalid' : ''}" 
                                   id="password" name="password" minlength="6"
                                   placeholder="Leave blank to keep current password">
                            <div class="error-text">${errors.password}</div>
                            <small class="form-text text-muted">
                                <i class="fas fa-info-circle me-1"></i>
                                Leave blank to keep the current password
                            </small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="phoneNumber">Phone Number</label>
                            <input type="tel" class="form-control ${not empty errors.phoneNumber ? 'is-invalid' : ''}" 
                                   id="phoneNumber" name="phoneNumber" pattern="^0\d{9}$" 
                                   title="Phone number must be 10 digits starting with 0." 
                                   value="${user.phoneNumber}" placeholder="Enter phone number">
                            <div class="error-text">${errors.phoneNumber}</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="gender">Gender</label>
                            <select class="form-control" name="gender">
                                <option value="">-- Select Gender --</option>
                                <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Male</option>
                                <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Female</option>
                                <option value="Other" ${user.gender == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="birthday">Birthday</label>
                            <input type="date" class="form-control ${not empty errors.birthday ? 'is-invalid' : ''}" 
                                   id="birthday" name="birthday" 
                                   value="<fmt:formatDate value='${user.birthday}' pattern='yyyy-MM-dd'/>">
                            <div class="error-text">${errors.birthday}</div>
                        </div>
                    </div>
                </div>

                <div class="form-group mb-3">
                    <label class="form-label" for="address">Address</label>
                    <textarea class="form-control" id="address" name="address" rows="3" 
                              placeholder="Enter address">${user.address}</textarea>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label required-field" for="roleId">Role</label>
                            <select class="form-control ${not empty errors.roleId ? 'is-invalid' : ''}" 
                                    id="roleId" name="roleId" required>
                                <option value="">-- Select Role --</option>
                                <option value="1" ${user.roleId == 1 ? 'selected' : ''}>Admin</option>
                                <option value="2" ${user.roleId == 2 ? 'selected' : ''}>Manager</option>
                                <option value="3" ${user.roleId == 3 ? 'selected' : ''}>Therapist</option>
                                <option value="4" ${user.roleId == 4 ? 'selected' : ''}>Receptionist</option>
                            </select>
                            <div class="error-text">${errors.roleId}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="avatarUrl">Avatar URL</label>
                            <input type="url" class="form-control" id="avatarUrl" name="avatarUrl" 
                                   value="${user.avatarUrl}" placeholder="Enter avatar URL">
                        </div>
                    </div>
                </div>

                <div class="form-group mb-4">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="isActive" name="isActive" 
                               ${user.isActive ? 'checked' : ''}>
                        <label class="form-check-label" for="isActive">
                            <i class="fas fa-check-circle me-1"></i>
                            Active User Account
                        </label>
                    </div>
                </div>

                <div class="d-flex gap-2 justify-content-end">
                    <a href="${pageContext.request.contextPath}/user/list" class="btn btn-secondary">
                        <i class="fas fa-times me-1"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Update User
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

     <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
     <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
     
     <script>
        $(document).ready(function() {
            // Form validation and submission
            $('#userEditForm').on('submit', function(e) {
                e.preventDefault();
                
                // Basic validation
                let isValid = true;
                const requiredFields = ['fullName', 'email', 'roleId'];
                
                requiredFields.forEach(field => {
                    const value = $(`#${field}`).val().trim();
                    if (!value) {
                        $(`#${field}`).addClass('is-invalid');
                        isValid = false;
                    } else {
                        $(`#${field}`).removeClass('is-invalid');
                    }
                });
                
                // Email validation
                const email = $('#email').val().trim();
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (email && !emailRegex.test(email)) {
                    $('#email').addClass('is-invalid');
                    isValid = false;
                }
                
                // Password validation (if provided)
                const password = $('#password').val();
                if (password && password.length < 6) {
                    $('#password').addClass('is-invalid');
                    isValid = false;
                }
                
                if (!isValid) {
                    Swal.fire({
                        title: '❌ Validation Error',
                        text: 'Please fill in all required fields correctly.',
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                    return;
                }
                
                // Show loading
                Swal.fire({
                    title: '🔄 Updating User...',
                    text: 'Please wait while we update the user information.',
                    icon: 'info',
                    allowOutsideClick: false,
                    showConfirmButton: false,
                    willOpen: () => {
                        Swal.showLoading();
                    }
                });
                
                // Submit form
                this.submit();
            });
            
            // Real-time validation
            $('input, select').on('blur', function() {
                const field = $(this);
                const value = field.val().trim();
                
                if (field.attr('required') && !value) {
                    field.addClass('is-invalid');
                } else {
                    field.removeClass('is-invalid');
                }
                
                // Email validation
                if (field.attr('type') === 'email' && value) {
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailRegex.test(value)) {
                        field.addClass('is-invalid');
                    } else {
                        field.removeClass('is-invalid');
                    }
                }
            });
        });
     </script>
</body>
</html> 