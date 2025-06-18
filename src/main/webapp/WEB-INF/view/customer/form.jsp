<%-- 
    Document   : form
    Created on : Jun 4, 2025
    Author     : Admin
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty customer ? 'Add New' : 'Edit'} Customer - Spa Management</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>

    <div class="container-fluid py-4">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4">
            <h4 class="fw-bold mb-0">${empty customer ? 'Add New' : 'Edit'} Customer</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/" class="text-decoration-none">
                            <i class="fas fa-home me-1"></i>
                            Home
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/customer" class="text-decoration-none">Customers</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">${empty customer ? 'Add New' : 'Edit'}</li>
                </ol>
            </nav>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow">
                    <div class="card-header bg-white border-bottom">
                        <h5 class="card-title mb-0">${empty customer ? 'Customer Information' : 'Edit Customer Information'}</h5>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mx-3 mt-3">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            ${error}
                        </div>
                    </c:if>

                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/customer" method="post" novalidate>
                            <input type="hidden" name="action" value="${empty customer ? 'create' : 'update'}">
                            <c:if test="${not empty customer}">
                                <input type="hidden" name="id" value="${customer.customerId}">
                            </c:if>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="name" class="form-label">Full Name <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="name" name="name" 
                                               value="<c:out value='${customer.fullName}'/>" required>
                                        <div class="invalid-feedback">
                                            Please provide a valid full name.
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email Address <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               value="<c:out value='${customer.email}'/>" required>
                                        <div class="invalid-feedback">
                                            Please provide a valid email address.
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="phone" class="form-label">Phone Number</label>
                                        <input type="tel" class="form-control" id="phone" name="phone" 
                                               value="<c:out value='${customer.phoneNumber}'/>" pattern="[0-9]{10,11}">
                                        <div class="invalid-feedback">
                                            Please provide a valid phone number (10-11 digits).
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="gender" class="form-label">Gender</label>
                                        <select class="form-select" id="gender" name="gender">
                                            <option value="">Select Gender</option>
                                            <option value="Male" ${customer.gender == 'Male' ? 'selected' : ''}>Male</option>
                                            <option value="Female" ${customer.gender == 'Female' ? 'selected' : ''}>Female</option>
                                            <option value="Other" ${customer.gender == 'Other' ? 'selected' : ''}>Other</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="birthday" class="form-label">Birthday</label>
                                        <input type="date" class="form-control" id="birthday" name="birthday" 
                                               value="<fmt:formatDate value='${customer.birthday}' pattern='yyyy-MM-dd'/>">
                                    </div>
                                </div>

                                <c:if test="${not empty customer}">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="loyaltyPoints" class="form-label">Loyalty Points</label>
                                            <input type="number" class="form-control" id="loyaltyPoints" name="loyaltyPoints" 
                                                   value="${customer.loyaltyPoints}" min="0">
                                        </div>
                                    </div>
                                </c:if>
                            </div>

                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3"><c:out value='${customer.address}'/></textarea>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="avatar" class="form-label">Profile Picture</label>
                                        <input type="file" class="form-control" id="avatar" name="avatar" accept="image/*">
                                        <c:if test="${not empty customer.avatarUrl}">
                                            <div class="mt-2">
                                                <img src="${customer.avatarUrl}" alt="Current Avatar" class="rounded-circle" width="100" height="100">
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="password" class="form-label">
                                            Password ${empty customer ? '<span class="text-danger">*</span>' : '(leave blank to keep current)'}
                                        </label>
                                        <input type="password" class="form-control" id="password" name="password" 
                                               ${empty customer ? 'required' : ''} minlength="6">
                                        <div class="invalid-feedback">
                                            Password must be at least 6 characters long.
                                        </div>
                                        <div class="form-text">
                                            <c:if test="${not empty customer}">
                                                Leave blank to keep the current password.
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <div class="form-check form-switch mt-4">
                                            <input class="form-check-input" type="checkbox" id="isActive" name="isActive" 
                                                   ${customer.isActive || empty customer ? 'checked' : ''}>
                                            <label class="form-check-label" for="isActive">
                                                Active Customer
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex gap-16 justify-content-end mt-24">
                                <a href="${pageContext.request.contextPath}/customer" class="btn btn-outline-primary btn-sm px-20 py-11 radius-8">
                                    <iconify-icon icon="solar:arrow-left-linear" class="icon text-lg me-8"></iconify-icon>
                                    Go Back
                                </a>
                                <button type="submit" class="btn btn-primary btn-sm px-20 py-11 radius-8">
                                    <iconify-icon icon="solar:check-circle-bold" class="icon text-lg me-8"></iconify-icon>
                                    ${empty customer ? 'Submit' : 'Submit'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        $(document).ready(function() {
            // Form validation
            const form = $('form');
            
            form.on('submit', function(e) {
                if (!this.checkValidity()) {
                    e.preventDefault();
                    e.stopPropagation();
                    $(this).addClass('was-validated');
                    return;
                }
                
                e.preventDefault(); // Prevent normal form submission
                
                // Show loading
                Swal.fire({
                    title: '🔄 Processing...',
                    text: 'Please wait a moment',
                    icon: 'info',
                    allowOutsideClick: false,
                    showConfirmButton: false,
                    willOpen: () => {
                        Swal.showLoading();
                    }
                });
                
                // Submit form via AJAX
                $.ajax({
                    url: $(this).attr('action'),
                    type: 'POST',
                    data: $(this).serialize(),
                                                     success: function(response) {
                        const isEdit = '${not empty customer}' === 'true';
                        const successTitle = isEdit ? '🎉 Edit Successful!' : '🎉 Customer Added Successfully!';
                        const successText = isEdit ? 'Customer information has been updated.' : 'New customer has been added to the system.';
                        
                        Swal.fire({
                            title: successTitle,
                            text: successText,
                            icon: 'success',
                            timer: 2500,
                            showConfirmButton: false
                        }).then(() => {
                            // Redirect to customer list
                            window.location.href = '${pageContext.request.contextPath}/customer';
                        });
                    },
                    error: function(xhr, status, error) {
                        Swal.fire({
                            title: '❌ Error!',
                            text: 'An error occurred. Please try again.',
                            icon: 'error',
                            confirmButtonText: 'OK'
                        });
                    }
                });
            });

            // Phone number input validation
            $('#phone').on('input', function() {
                let value = $(this).val().replace(/\D/g, '');
                $(this).val(value);
            });

            // Email validation
            $('#email').on('blur', function() {
                const email = $(this).val();
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                
                if (email && !emailRegex.test(email)) {
                    $(this).addClass('is-invalid');
                } else {
                    $(this).removeClass('is-invalid');
                }
            });
        });
    </script>
</body>
</html> 