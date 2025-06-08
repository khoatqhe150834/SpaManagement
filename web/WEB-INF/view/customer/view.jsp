<%-- 
    Document   : view
    Created on : Dec 25, 2024
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
    <title>Customer Details - Spa Management</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
    <style>
        .update-btn {
            position: relative;
            overflow: hidden;
        }
        .update-btn .spinner {
            display: none;
        }
        .update-btn.loading .spinner {
            display: inline-block;
        }
        .update-btn.loading .icon {
            display: none;
        }
        .data-field {
            transition: all 0.3s ease;
        }
        .data-field.updated {
            background: #d4edda;
            border-radius: 8px;
            padding: 8px;
            animation: highlight 1s ease;
        }
        @keyframes highlight {
            0% { background: #28a745; }
            100% { background: #d4edda; }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">🔍 Chi tiết khách hàng</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/customer" class="d-flex align-items-center gap-1 hover-text-primary">
                        👥 Khách hàng
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Chi tiết</li>
            </ul>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card h-100 p-0 radius-12">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">📋 Thông tin khách hàng</h6>
                    </div>

                    <div class="card-body p-24" id="customerDataContainer">
                        <c:if test="${not empty customer}">
                            <div class="row">
                                <!-- Customer Avatar & Basic Info -->
                                <div class="col-lg-4">
                                    <div class="text-center mb-24">
                                        <img src="${pageContext.request.contextPath}/assets/images/avatar.png" 
                                             alt="Customer Avatar" 
                                             class="w-120-px h-120-px rounded-circle mb-16">
                                        <h5 class="fw-semibold text-primary-light mb-8 data-field" data-field="fullName">
                                            <c:out value="${customer.fullName}" default="Unknown"/>
                                        </h5>
                                        <span class="badge bg-${customer.isActive ? 'success-focus text-success-600' : 'neutral-200 text-neutral-600'} px-16 py-8 radius-8 fw-medium data-field" data-field="isActive">
                                            ${customer.isActive ? '✅ Hoạt động' : '❌ Ngưng hoạt động'}
                                        </span>
                                    </div>
                                </div>

                                <!-- Customer Details -->
                                <div class="col-lg-8">
                                    <div class="row g-20">
                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">🆔 Mã khách hàng</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="customerId">#<c:out value="${customer.customerId}" default="N/A"/></p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">📧 Địa chỉ Email</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="email">
                                                    <c:out value="${customer.email}" default="N/A"/>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">📱 Số điện thoại</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="phoneNumber">
                                                    <c:out value="${customer.phoneNumber}" default="N/A"/>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">👤 Giới tính</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="gender">
                                                    <c:choose>
                                                        <c:when test="${customer.gender == 'MALE'}">👨 Nam</c:when>
                                                        <c:when test="${customer.gender == 'FEMALE'}">👩 Nữ</c:when>
                                                        <c:when test="${customer.gender == 'OTHER'}">⚧ Khác</c:when>
                                                        <c:otherwise>❓ Chưa xác định</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">🎂 Ngày sinh</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="birthday">
                                                    <c:choose>
                                                        <c:when test="${not empty customer.birthday}">
                                                            <fmt:formatDate value="${customer.birthday}" pattern="dd/MM/yyyy"/>
                                                        </c:when>
                                                        <c:otherwise>Chưa cập nhật</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">⭐ Điểm tích lũy</label>
                                                <p class="fw-medium text-warning-600 data-field" data-field="loyaltyPoints">
                                                    🏆 <c:out value="${customer.loyaltyPoints}" default="0"/> điểm
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-12">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">🏠 Địa chỉ</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="address">
                                                    <c:out value="${customer.address}" default="Chưa cập nhật"/>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">📅 Ngày tham gia</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="createdAt">
                                                    <c:choose>
                                                        <c:when test="${not empty customer.createdAt}">
                                                            <fmt:parseDate value="${customer.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedCreatedAt" type="both"/>
                                                            <fmt:formatDate value="${parsedCreatedAt}" pattern="dd/MM/yyyy 'lúc' HH:mm"/>
                                                        </c:when>
                                                        <c:otherwise>Chưa xác định</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">🔄 Cập nhật lần cuối</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="updatedAt">
                                                    <c:choose>
                                                        <c:when test="${not empty customer.updatedAt}">
                                                            <fmt:parseDate value="${customer.updatedAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedUpdatedAt" type="both"/>
                                                            <fmt:formatDate value="${parsedUpdatedAt}" pattern="dd/MM/yyyy 'lúc' HH:mm"/>
                                                        </c:when>
                                                        <c:otherwise>Chưa cập nhật</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="d-flex gap-16 justify-content-end mt-24 pt-24 border-top">
                                <a href="${pageContext.request.contextPath}/customer" 
                                   class="btn btn-outline-primary btn-sm px-20 py-11 radius-8">
                                    ← Quay lại
                                </a>
                                <button onclick="updateCustomerData()" id="updateBtn" class="btn btn-success btn-sm px-20 py-11 radius-8 update-btn">
                                    <span class="icon">🔄</span>
                                    <span class="spinner">
                                        <div class="spinner-border spinner-border-sm" role="status"></div>
                                    </span>
                                    Update
                                </button>
                            </div>

                        </c:if>

                        <c:if test="${empty customer}">
                            <div class="text-center py-48">
                                <div style="font-size: 64px;">👤❌</div>
                                <h6 class="text-neutral-600 mb-8 mt-3">Không tìm thấy khách hàng</h6>
                                <p class="text-neutral-400 text-sm mb-24">Khách hàng bạn tìm kiếm không tồn tại hoặc đã bị xóa.</p>
                                <a href="${pageContext.request.contextPath}/customer" 
                                   class="btn btn-primary btn-sm px-20 py-11 radius-8">
                                    ← Quay lại danh sách
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <script>
        const customerId = ${customer.customerId};
        
        function updateCustomerData() {
            const updateBtn = document.getElementById('updateBtn');
            
            // Show loading state
            updateBtn.classList.add('loading');
            updateBtn.disabled = true;
            
            fetch('${pageContext.request.contextPath}/customer/api/refresh?id=' + customerId, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    refreshCustomerDisplay(data.customer);
                    
                    Swal.fire({
                        title: '✅ Update thành công!',
                        text: 'Thông tin khách hàng đã được cập nhật',
                        icon: 'success',
                        timer: 2000,
                        showConfirmButton: false
                    });
                } else {
                    throw new Error(data.message || 'Update failed');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire({
                    title: '❌ Lỗi update',
                    text: 'Không thể cập nhật thông tin. Vui lòng thử lại.',
                    icon: 'error',
                    timer: 3000,
                    showConfirmButton: false
                });
            })
            .finally(() => {
                // Hide loading state
                updateBtn.classList.remove('loading');
                updateBtn.disabled = false;
            });
        }
        
        function refreshCustomerDisplay(customer) {
            const fields = {
                'fullName': customer.fullName,
                'email': customer.email,
                'phoneNumber': customer.phoneNumber,
                'gender': getGenderDisplay(customer.gender),
                'birthday': formatDate(customer.birthday),
                'loyaltyPoints': '🏆 ' + (customer.loyaltyPoints || 0) + ' điểm',
                'address': customer.address || 'Chưa cập nhật',
                'isActive': customer.isActive ? '✅ Hoạt động' : '❌ Ngưng hoạt động',
                'updatedAt': formatDateTime(customer.updatedAt)
            };
            
            // Update each field and highlight changes
            Object.keys(fields).forEach(fieldName => {
                const element = document.querySelector(`[data-field="${fieldName}"]`);
                if (element) {
                    const oldValue = element.textContent.trim();
                    const newValue = fields[fieldName];
                    
                    if (oldValue !== newValue) {
                        element.textContent = newValue;
                        element.classList.add('updated');
                        setTimeout(() => {
                            element.classList.remove('updated');
                        }, 1000);
                    }
                }
            });
            
            // Update status badge
            const statusBadge = document.querySelector('[data-field="isActive"]');
            if (statusBadge) {
                statusBadge.className = customer.isActive ? 
                    'badge bg-success-focus text-success-600 px-16 py-8 radius-8 fw-medium data-field' :
                    'badge bg-neutral-200 text-neutral-600 px-16 py-8 radius-8 fw-medium data-field';
            }
        }
        
        function getGenderDisplay(gender) {
            switch(gender) {
                case 'MALE': return '👨 Nam';
                case 'FEMALE': return '👩 Nữ';
                case 'OTHER': return '⚧ Khác';
                default: return '❓ Chưa xác định';
            }
        }
        
        function formatDate(dateString) {
            if (!dateString) return 'Chưa cập nhật';
            const date = new Date(dateString);
            return date.toLocaleDateString('vi-VN');
        }
        
        function formatDateTime(dateString) {
            if (!dateString) return 'Chưa cập nhật';
            const date = new Date(dateString);
            return date.toLocaleDateString('vi-VN') + ' lúc ' + date.toLocaleTimeString('vi-VN', {hour: '2-digit', minute: '2-digit'});
        }
    </script>
</body>
</html> 