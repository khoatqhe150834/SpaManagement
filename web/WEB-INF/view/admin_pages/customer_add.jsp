<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Customer</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"/>
    <style>
        .container { max-width: 500px; margin-top: 40px; }
        .form-label { font-weight: 500; }
        
        /* CSS để hiển thị lỗi */
        .error-text { 
            width: 100%;
            margin-top: .25rem;
            font-size: 80%;
            color: #dc3545; /* Màu đỏ của Bootstrap */
        }
        /* Bootstrap class để thêm viền đỏ cho input lỗi */
        .is-invalid {
             border-color: #dc3545 !important;
        }
    </style>
</head>
<body>
<div class="container">
    <h3 class="mb-4 text-center text-primary">Add New Customer</h3>
    
    <%-- Hiển thị lỗi chung từ server nếu có --%>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <%-- Thêm 'novalidate' để tắt thông báo mặc định của trình duyệt --%>
    <form action="${pageContext.request.contextPath}/customer/create" method="post" novalidate>
        
        <!-- Full Name -->
        <div class="form-group">
            <label class="form-label" for="fullName">Full Name <span class="text-danger">*</span></label>
            <%-- Thêm class 'is-invalid' nếu có lỗi. Giữ lại giá trị đã nhập. --%>
            <input type="text" class="form-control ${not empty errors.fullName ? 'is-invalid' : ''}" 
                   id="fullName" name="fullName" required maxlength="100" 
                   value="${not empty customerInput.fullName ? customerInput.fullName : ''}">
            <%-- Hiển thị thông báo lỗi cụ thể cho trường này --%>
            <div class="error-text">${errors.fullName}</div>
        </div>
        
        <!-- Email -->
        <div class="form-group">
            <label class="form-label" for="email">Email <span class="text-danger">*</span></label>
            <input type="email" class="form-control ${not empty errors.email ? 'is-invalid' : ''}" 
                   id="email" name="email" required
                   value="${not empty customerInput.email ? customerInput.email : ''}">
             <div class="error-text">${errors.email}</div>
        </div>
        
        <!-- Password -->
        <div class="form-group">
            <label class="form-label" for="password">Password <span class="text-danger">*</span></label>
            <%-- Không điền lại mật khẩu vì lý do bảo mật --%>
            <input type="password" class="form-control ${not empty errors.password ? 'is-invalid' : ''}" 
                   id="password" name="password" required minlength="8">
             <div class="error-text">${errors.password}</div>
        </div>
        
        <!-- Phone Number -->
        <div class="form-group">
            <label class="form-label" for="phoneNumber">Phone Number</label>
            <input type="tel" class="form-control ${not empty errors.phoneNumber ? 'is-invalid' : ''}" 
                   id="phoneNumber" name="phoneNumber" pattern="^0\d{9}$"
                   title="Phone number must be 10 digits starting with 0."
                   value="${not empty customerInput.phoneNumber ? customerInput.phoneNumber : ''}">
             <div class="error-text">${errors.phoneNumber}</div>
        </div>
        
        <!-- Gender -->
        <div class="form-group">
            <label class="form-label">Gender</label>
            <select class="form-control" name="gender">
                <option value="">-- Select --</option>
                <option value="Male" ${customerInput.gender == 'Male' ? 'selected' : ''}>Male</option>
                <option value="Female" ${customerInput.gender == 'Female' ? 'selected' : ''}>Female</option>
                <option value="Other" ${customerInput.gender == 'Other' ? 'selected' : ''}>Other</option>
            </select>
        </div>
        
        <!-- Birthday -->
        <div class="form-group">
            <label class="form-label" for="birthday">Birthday</label>
            <input type="date" class="form-control ${not empty errors.birthday ? 'is-invalid' : ''}" 
                   id="birthday" name="birthday" 
                   value="${customerInput.birthday}">
             <div class="error-text">${errors.birthday}</div>
        </div>
        
        <!-- Address -->
        <div class="form-group">
            <label class="form-label" for="address">Address</label>
            <input type="text" class="form-control" id="address" name="address"
                   value="${not empty customerInput.address ? customerInput.address : ''}">
        </div>
        
        <button type="submit" class="btn btn-primary btn-block">Add Customer</button>
        <a href="${pageContext.request.contextPath}/customer/list" class="btn btn-secondary btn-block mt-2">Back to Customer List</a>
    </form>
</div>
</body>
</html>
