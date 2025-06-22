<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add New User - Admin Dashboard</title>
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
    </style>
</head>
<body>
     <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
     <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-primary mb-0">Add New User</h3>
        <a href="${pageContext.request.contextPath}/user/list" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back to User List
        </a>
    </div>

    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-user-plus me-2"></i>
                User Information
            </h5>
        </div>
        <div class="card-body p-4">
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/user/create" method="post" novalidate id="userForm">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label required-field" for="fullName">Full Name</label>
                            <input type="text" class="form-control ${not empty errors.fullName ? 'is-invalid' : ''}" 
                                   id="fullName" name="fullName" required maxlength="100" 
                                   value="${not empty userInput.fullName ? userInput.fullName : ''}"
                                   placeholder="Enter full name">
                            <div class="error-text">${errors.fullName}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label required-field" for="email">Email Address</label>
                            <input type="email" class="form-control ${not empty errors.email ? 'is-invalid' : ''}" 
                                   id="email" name="email" required 
                                   value="${not empty userInput.email ? userInput.email : ''}"
                                   placeholder="Enter email address">
                            <div class="error-text">${errors.email}</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label required-field" for="password">Password</label>
                            <input type="password" class="form-control ${not empty errors.password ? 'is-invalid' : ''}" 
                                   id="password" name="password" required minlength="6"
                                   placeholder="Enter password (min 6 characters)">
                            <div class="error-text">${errors.password}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="phoneNumber">Phone Number</label>
                            <input type="tel" class="form-control ${not empty errors.phoneNumber ? 'is-invalid' : ''}" 
                                   id="phoneNumber" name="phoneNumber" pattern="^0\d{9}$" 
                                   title="Phone number must be 10 digits starting with 0." 
                                   value="${not empty userInput.phoneNumber ? userInput.phoneNumber : ''}"
                                   placeholder="Enter phone number">
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
                                <option value="Male" ${userInput.gender == 'Male' ? 'selected' : ''}>Male</option>
                                <option value="Female" ${userInput.gender == 'Female' ? 'selected' : ''}>Female</option>
                                <option value="Other" ${userInput.gender == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="birthday">Birthday</label>
                            <input type="date" class="form-control ${not empty errors.birthday ? 'is-invalid' : ''}" 
                                   id="birthday" name="birthday" value="${userInput.birthday}">
                            <div class="error-text">${errors.birthday}</div>
                        </div>
                    </div>
                </div>

                <div class="form-group mb-3">
                    <label class="form-label" for="address">Address</label>
                    <textarea class="form-control" id="address" name="address" rows="3" 
                              placeholder="Enter address">${not empty userInput.address ? userInput.address : ''}</textarea>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label required-field" for="roleId">Role</label>
                            <select class="form-control ${not empty errors.roleId ? 'is-invalid' : ''}" 
                                    id="roleId" name="roleId" required>
                                <option value="">-- Select Role --</option>
                                <option value="1" ${userInput.roleId == 1 ? 'selected' : ''}>Admin</option>
                                <option value="2" ${userInput.roleId == 2 ? 'selected' : ''}>Manager</option>
                                <option value="3" ${userInput.roleId == 3 ? 'selected' : ''}>Therapist</option>
                                <option value="4" ${userInput.roleId == 4 ? 'selected' : ''}>Receptionist</option>
                            </select>
                            <div class="error-text">${errors.roleId}</div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group mb-3">
                            <label class="form-label" for="avatarUrl">Avatar URL</label>
                            <input type="url" class="form-control" id="avatarUrl" name="avatarUrl" 
                                   value="${not empty userInput.avatarUrl ? userInput.avatarUrl : ''}"
                                   placeholder="Enter avatar URL">
                        </div>
                    </div>
                </div>

                <div class="form-group mb-4">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="isActive" name="isActive" 
                               ${userInput.isActive ? 'checked' : ''}>
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
                        <i class="fas fa-save me-1"></i> Create User
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
            $('#userForm').on('submit', function(e) {
                e.preventDefault();
                
                // Basic validation
                let isValid = true;
                const requiredFields = ['fullName', 'email', 'password', 'roleId'];
                
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
                
                // Password validation
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
                    title: '🔄 Creating User...',
                    text: 'Please wait while we create the user account.',
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