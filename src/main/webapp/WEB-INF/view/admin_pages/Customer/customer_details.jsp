<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Khách hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .customer-avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 4px solid #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            object-fit: cover;
        }
        .status-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.9rem;
        }
        .info-group {
            margin-bottom: 1rem;
        }
        .info-label {
            font-weight: 600;
            color: #6b7280;
            margin-bottom: 0.3rem;
        }
        .info-value {
            font-size: 1rem;
            color: #374151;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
    
    <div class="container mt-4">
        <div class="card shadow">
            <div class="card-header bg-white py-3">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Chi tiết Khách hàng</h5>
                    <a href="${pageContext.request.contextPath}/customer" class="btn btn-secondary btn-sm">
                        <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách
                    </a>
                </div>
            </div>
            
            <div class="card-body">
                <c:if test="${not empty customer}">
                    <div class="row">
                        <div class="col-md-4 text-center">
                            <img src="${not empty customer.avatarUrl ? customer.avatarUrl : 'https://placehold.co/150x150/7C3AED/FFFFFF?text='.concat(fn:substring(customer.fullName,0,2))}" 
                                 alt="Ảnh đại diện của ${customer.fullName}"
                                 class="customer-avatar mb-3">
                            
                            <h5 class="mb-2">${customer.fullName}</h5>
                            <span class="status-badge ${customer.isActive ? 'bg-success' : 'bg-danger'} text-white">
                                <i class="fas fa-${customer.isActive ? 'check' : 'times'}-circle"></i>
                                ${customer.isActive ? 'Hoạt động' : 'Không hoạt động'}
                            </span>
                        </div>
                        
                        <div class="col-md-8">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="info-group">
                                        <div class="info-label">Email</div>
                                        <div class="info-value">${customer.email}</div>
                                    </div>
                                    
                                    <div class="info-group">
                                        <div class="info-label">Số điện thoại</div>
                                        <div class="info-value">${customer.phoneNumber}</div>
                                    </div>
                                    
                                    <div class="info-group">
                                        <div class="info-label">Giới tính</div>
                                        <div class="info-value">${customer.gender}</div>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="info-group">
                                        <div class="info-label">Ngày sinh</div>
                                        <div class="info-value">
                                            <c:out value="${customer.birthday}" default="Chưa cung cấp"/>
                                        </div>
                                    </div>
                                    
                                    <div class="info-group">
                                        <div class="info-label">Điểm thân thiết</div>
                                        <div class="info-value">
                                            <span class="badge bg-warning text-dark">
                                                <i class="fas fa-star me-1"></i>${customer.loyaltyPoints} điểm
                                            </span>
                                        </div>
                                    </div>
                                    
                                    <div class="info-group">
                                        <div class="info-label">Trạng thái xác minh</div>
                                        <div class="info-value">
                                            <span class="badge ${customer.isVerified ? 'bg-success' : 'bg-secondary'}">
                                                <i class="fas fa-${customer.isVerified ? 'check' : 'times'} me-1"></i>
                                                ${customer.isVerified ? 'Đã xác minh' : 'Chưa xác minh'}
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-12 mt-3">
                                    <div class="info-group">
                                        <div class="info-label">Địa chỉ</div>
                                        <div class="info-value">
                                            <i class="fas fa-map-marker-alt me-1 text-danger"></i>
                                            <c:out value="${customer.address}" default="Chưa cung cấp địa chỉ"/>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-12 mt-3">
                                    <div class="info-group">
                                        <div class="info-label">Ghi chú</div>
                                        <div class="info-value">
                                            <c:out value="${customer.notes}" default="Không có ghi chú"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mt-4">
                                <a href="${pageContext.request.contextPath}/customer/edit?id=${customer.customerId}" 
                                   class="btn btn-primary">
                                    <i class="fas fa-edit me-1"></i> Chỉnh sửa khách hàng
                                </a>
                                <c:if test="${not customer.isActive}">
                                    <a href="${pageContext.request.contextPath}/customer/activate?id=${customer.customerId}" 
                                       class="btn btn-success ms-2">
                                        <i class="fas fa-user-check me-1"></i> Kích hoạt tài khoản
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html>