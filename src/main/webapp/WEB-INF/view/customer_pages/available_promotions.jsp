<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khuyến Mãi Dành Cho Bạn - Spa Hương Sen</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        .promotion-card {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            background: white;
            margin-bottom: 20px;
            overflow: hidden;
            transition: box-shadow 0.3s ease;
        }
        .promotion-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .promotion-header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 15px;
        }
        .promotion-code {
            background: #fff;
            color: #007bff;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
            display: inline-block;
            margin-top: 10px;
        }
        .promotion-body {
            padding: 20px;
        }
        .discount-badge {
            background: #28a745;
            color: white;
            padding: 8px 15px;
            border-radius: 25px;
            font-weight: bold;
            font-size: 16px;
        }
        .condition-text {
            color: #6c757d;
            font-size: 14px;
            margin-top: 10px;
        }
        .copy-code-btn {
            background: #17a2b8;
            border: none;
            color: white;
            padding: 8px 16px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }
        .copy-code-btn:hover {
            background: #138496;
        }
        .status-badge {
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-active { background: #d4edda; color: #155724; }
        .status-scheduled { background: #cce5ff; color: #004085; }
        .breadcrumb {
            background: transparent;
            padding: 10px 0;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <div class="container mt-4">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                <li class="breadcrumb-item active">Khuyến mãi của tôi</li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div class="row mb-4">
            <div class="col-12">
                <h2><i class="fas fa-tags text-primary"></i> Khuyến Mãi Dành Cho Bạn</h2>
                <p class="text-muted">Các mã giảm giá bạn có thể sử dụng khi đặt dịch vụ spa</p>
            </div>
        </div>

        <!-- Thông báo -->
        <c:if test="${not empty message}">
            <div class="alert alert-info alert-dismissible fade show">
                <i class="fas fa-info-circle"></i> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Danh sách khuyến mãi -->
        <div class="row">
            <c:choose>
                <c:when test="${not empty availablePromotions}">
                    <c:forEach var="promotion" items="${availablePromotions}">
                        <div class="col-md-6 col-lg-4">
                            <div class="promotion-card">
                                <div class="promotion-header text-center">
                                    <h5 class="mb-0">${promotion.title}</h5>
                                    <div class="promotion-code">${promotion.promotionCode}</div>
                                </div>
                                
                                <div class="promotion-body">
                                    <div class="text-center mb-3">
                                        <span class="discount-badge">
                                            <c:choose>
                                                <c:when test="${promotion.discountType == 'PERCENTAGE'}">
                                                    Giảm ${promotion.discountValue}%
                                                </c:when>
                                                <c:otherwise>
                                                    Giảm <fmt:formatNumber value="${promotion.discountValue}" type="currency" currencySymbol=""/>đ
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>

                                    <p class="text-center mb-3">${promotion.description}</p>

                                    <!-- Điều kiện áp dụng -->
                                    <div class="condition-text">
                                        <div><strong>Điều kiện:</strong></div>
                                        <ul class="list-unstyled ps-3">
                                            <c:if test="${promotion.minimumAppointmentValue != null && promotion.minimumAppointmentValue > 0}">
                                                <li><i class="fas fa-check text-success"></i> Đơn hàng tối thiểu: <fmt:formatNumber value="${promotion.minimumAppointmentValue}" type="currency" currencySymbol=""/>đ</li>
                                            </c:if>
                                            <li><i class="fas fa-users text-info"></i> 
                                                <c:choose>
                                                    <c:when test="${promotion.customerCondition eq 'INDIVIDUAL'}">Khách hàng cá nhân</c:when>
                                                    <c:when test="${promotion.customerCondition eq 'COUPLE'}">Khách hàng đi cặp</c:when>
                                                    <c:when test="${promotion.customerCondition eq 'GROUP'}">Khách hàng đi nhóm (3+ người)</c:when>
                                                    <c:otherwise>Tất cả khách hàng</c:otherwise>
                                                </c:choose>
                                            </li>
                                            <li><i class="fas fa-calendar text-warning"></i> 
                                                Từ ${promotion.startDate.toString().substring(0,10)} 
                                                đến ${promotion.endDate.toString().substring(0,10)}
                                            </li>
                                            <c:if test="${promotion.usageLimitPerCustomer != null}">
                                                <li><i class="fas fa-limit text-danger"></i> Tối đa ${promotion.usageLimitPerCustomer} lần/khách hàng</li>
                                            </c:if>
                                        </ul>
                                    </div>

                                    <!-- Trạng thái và nút hành động -->
                                    <div class="d-flex justify-content-between align-items-center mt-3">
                                        <span class="status-badge ${promotion.status == 'ACTIVE' ? 'status-active' : 'status-scheduled'}">
                                            <c:choose>
                                                <c:when test="${promotion.status == 'ACTIVE'}">Có thể sử dụng</c:when>
                                                <c:otherwise>Sắp áp dụng</c:otherwise>
                                            </c:choose>
                                        </span>
                                        
                                        <c:if test="${promotion.status == 'ACTIVE'}">
                                            <button class="copy-code-btn" onclick="copyCode('${promotion.promotionCode}')">
                                                <i class="fas fa-copy"></i> Sao chép mã
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="text-center py-5">
                            <i class="fas fa-tags fa-3x text-muted mb-3"></i>
                            <h4 class="text-muted">Chưa có khuyến mãi nào</h4>
                            <p class="text-muted">Hiện tại không có khuyến mãi nào phù hợp với bạn. Hãy quay lại sau nhé!</p>
                            <a href="${pageContext.request.contextPath}/services" class="btn btn-primary">
                                <i class="fas fa-search"></i> Xem dịch vụ
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Hướng dẫn sử dụng -->
        <div class="row mt-5">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-light">
                        <h5><i class="fas fa-question-circle text-info"></i> Cách sử dụng mã khuyến mãi</h5>
                    </div>
                    <div class="card-body">
                        <ol class="list-group list-group-numbered list-group-flush">
                            <li class="list-group-item d-flex align-items-start">
                                <div class="ms-2 me-auto">
                                    <div class="fw-bold">Chọn dịch vụ spa</div>
                                    Chọn các dịch vụ spa bạn muốn sử dụng và thêm vào giỏ hàng
                                </div>
                            </li>
                            <li class="list-group-item d-flex align-items-start">
                                <div class="ms-2 me-auto">
                                    <div class="fw-bold">Nhập mã khuyến mãi</div>
                                    Tại trang thanh toán, nhập mã khuyến mãi vào ô "Mã giảm giá"
                                </div>
                            </li>
                            <li class="list-group-item d-flex align-items-start">
                                <div class="ms-2 me-auto">
                                    <div class="fw-bold">Áp dụng và thanh toán</div>
                                    Nhấn "Áp dụng" để sử dụng mã giảm giá và hoàn tất thanh toán
                                </div>
                            </li>
                        </ol>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function copyCode(code) {
            navigator.clipboard.writeText(code).then(function() {
                // Hiển thị thông báo copy thành công
                const toast = document.createElement('div');
                toast.className = 'toast align-items-center text-white bg-success border-0 position-fixed top-0 end-0 m-3';
                toast.style.zIndex = '1050';
                toast.innerHTML = `
                    <div class="d-flex">
                        <div class="toast-body">
                            <i class="fas fa-check"></i> Đã sao chép mã: ${code}
                        </div>
                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                    </div>
                `;
                document.body.appendChild(toast);
                const bsToast = new bootstrap.Toast(toast);
                bsToast.show();
                
                // Auto remove after hide
                toast.addEventListener('hidden.bs.toast', function() {
                    document.body.removeChild(toast);
                });
            }).catch(function() {
                alert('Mã khuyến mãi: ' + code);
            });
        }
    </script>
</body>
</html> 
 