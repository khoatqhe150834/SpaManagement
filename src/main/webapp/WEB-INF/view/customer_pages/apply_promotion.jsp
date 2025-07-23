<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Áp Dụng Mã Khuyến Mãi - Spa Hương Sen</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        .promotion-form {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .discount-summary {
            background: #e7f3ff;
            border: 1px solid #b3d7ff;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }
        .code-input {
            font-family: monospace;
            font-size: 16px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .price-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .final-price {
            font-size: 18px;
            font-weight: bold;
            color: #28a745;
        }
        .original-price {
            text-decoration: line-through;
            color: #6c757d;
        }
        .promotion-info {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 15px;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <script>
    // Tự động điền mã khuyến mãi từ URL hoặc localStorage nếu có, chỉ khi input đang rỗng
    window.addEventListener('DOMContentLoaded', function() {
        var input = document.getElementById('promotionCode');
        if (!input) return;
        // Nếu input đã có value (do server render mã đã áp dụng), không làm gì cả
        if (input.value && input.value.trim().length > 0) return;
        // Ưu tiên lấy từ URL
        var urlParams = new URLSearchParams(window.location.search);
        var promoCode = urlParams.get('promotionCode');
        if (promoCode) {
            input.value = promoCode;
            input.focus();
            return;
        }
        // Nếu không có trên URL, thử lấy từ localStorage
        var pending = localStorage.getItem('pendingPromotionCode');
        if (pending) {
            input.value = pending;
            input.focus();
            localStorage.removeItem('pendingPromotionCode');
        }
    });
    </script>

    <div class="container mt-4">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/booking">Đặt dịch vụ</a></li>
                <li class="breadcrumb-item active">Áp dụng khuyến mãi</li>
            </ol>
        </nav>

        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="promotion-form">
                    <div class="text-center mb-4">
                        <i class="fas fa-percentage fa-3x text-primary mb-3"></i>
                        <h3>Áp Dụng Mã Khuyến Mãi</h3>
                        <p class="text-muted">Nhập mã khuyến mãi để được giảm giá</p>
                    </div>

                    <!-- Thông báo -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle"></i> ${errorMessage}
                        </div>
                    </c:if>

                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i> ${successMessage}
                        </div>
                    </c:if>

                    <!-- Form áp dụng mã -->
                    <form action="${pageContext.request.contextPath}/apply-promotion" method="POST" id="promotionForm">
                        <div class="mb-3">
                            <label for="promotionCode" class="form-label">
                                <strong>Mã khuyến mãi</strong>
                            </label>
                            <div class="input-group">
                                <input type="text" 
                                       class="form-control code-input" 
                                       id="promotionCode" 
                                       name="promotionCode" 
                                       placeholder="VD: SUMMER2024"
                                       value="${appliedPromotion != null ? appliedPromotion.promotionCode : ''}"
                                       maxlength="50"
                                       required>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-check"></i> Áp dụng
                                </button>
                            </div>
                            <div class="form-text">
                                <i class="fas fa-info-circle"></i> 
                                Nhập mã khuyến mãi (không phân biệt hoa thường)
                            </div>
                        </div>

                        <!-- Gợi ý mã khuyến mãi còn hiệu lực -->
                        <c:if test="${not empty availablePromotions}">
                            <div class="mb-3">
                                <label class="form-label"><strong>Chọn nhanh mã khuyến mãi khả dụng:</strong></label>
                                <div class="d-flex flex-wrap gap-2">
                                    <c:forEach var="promo" items="${availablePromotions}">
                                        <button type="button" class="btn btn-outline-success btn-sm" onclick="document.getElementById('promotionCode').value='${promo.promotionCode}';">
                                            ${promo.promotionCode} - <c:out value="${promo.title}"/>
                                        </button>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>

                        <!-- Thông tin đơn hàng hiện tại -->
                        <c:if test="${not empty bookingInfo}">
                            <div class="card mt-3">
                                <div class="card-header bg-light">
                                    <h6 class="mb-0"><i class="fas fa-shopping-cart"></i> Thông tin đơn hàng</h6>
                                </div>
                                <div class="card-body">
                                    <c:forEach var="service" items="${bookingInfo.services}">
                                        <div class="price-row">
                                            <span>${service.name}</span>
                                            <span><fmt:formatNumber value="${service.price}" type="currency" currencySymbol=""/>đ</span>
                                        </div>
                                    </c:forEach>
                                    <hr>
                                    <div class="price-row">
                                        <strong>Tổng tiền:</strong>
                                        <strong><fmt:formatNumber value="${bookingInfo.totalAmount}" type="currency" currencySymbol=""/>đ</strong>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <!-- Hidden fields -->
                        <input type="hidden" name="bookingId" value="${bookingInfo.bookingId}">
                        <input type="hidden" name="totalAmount" value="${bookingInfo.totalAmount}">
                    </form>

                    <!-- Hiển thị thông tin khuyến mãi đã áp dụng -->
                    <c:if test="${not empty appliedPromotion}">
                        <div class="promotion-info">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="mb-1">
                                        <i class="fas fa-tags text-warning"></i> 
                                        ${appliedPromotion.title}
                                    </h6>
                                    <small class="text-muted">Mã: ${appliedPromotion.promotionCode}</small>
                                </div>
                                <form action="${pageContext.request.contextPath}/remove-promotion" method="POST" style="display: inline;">
                                    <input type="hidden" name="bookingId" value="${bookingInfo.bookingId}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                        <i class="fas fa-times"></i> Bỏ
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- Tóm tắt giảm giá -->
                        <div class="discount-summary">
                            <h6><i class="fas fa-calculator"></i> Tóm tắt thanh toán</h6>
                            <div class="price-row">
                                <span>Tổng tiền dịch vụ:</span>
                                <span><fmt:formatNumber value="${bookingInfo.totalAmount}" type="currency" currencySymbol=""/>đ</span>
                            </div>
                            <div class="price-row text-success">
                                <span>Giảm giá (${appliedPromotion.promotionCode}):</span>
                                <span>-<fmt:formatNumber value="${discountAmount}" type="currency" currencySymbol=""/>đ</span>
                            </div>
                            <hr>
                            <div class="price-row final-price">
                                <span>Số tiền phải trả:</span>
                                <span><fmt:formatNumber value="${finalAmount}" type="currency" currencySymbol=""/>đ</span>
                            </div>
                            <c:if test="${discountAmount > 0}">
                                <div class="text-center mt-2">
                                    <small class="text-success">
                                        <i class="fas fa-star"></i> 
                                        Bạn đã tiết kiệm được <fmt:formatNumber value="${discountAmount}" type="currency" currencySymbol=""/>đ!
                                    </small>
                                </div>
                            </c:if>
                        </div>
                    </c:if>

                    <!-- Nút hành động -->
                    <div class="d-grid gap-2 mt-4">
                        <c:choose>
                            <c:when test="${not empty appliedPromotion}">
                                <a href="${pageContext.request.contextPath}/checkout" class="btn btn-success btn-lg">
                                    <i class="fas fa-credit-card"></i> Tiếp tục thanh toán
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/checkout" class="btn btn-secondary btn-lg">
                                    <i class="fas fa-arrow-right"></i> Thanh toán không khuyến mãi
                                </a>
                            </c:otherwise>
                        </c:choose>
                        
                        <a href="${pageContext.request.contextPath}/promotions/available" class="btn btn-outline-primary">
                            <i class="fas fa-eye"></i> Xem khuyến mãi có sẵn
                        </a>
                    </div>

                    <!-- Lưu ý -->
                    <div class="alert alert-info mt-4">
                        <h6><i class="fas fa-lightbulb"></i> Lưu ý quan trọng:</h6>
                        <ul class="mb-0">
                            <li>Mỗi đơn hàng chỉ được áp dụng 1 mã khuyến mãi</li>
                            <li>Mã khuyến mãi không thể hoàn lại sau khi sử dụng</li>
                            <li>Kiểm tra điều kiện áp dụng trước khi sử dụng</li>
                            <li>Một số mã có giới hạn số lần sử dụng</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto uppercase promotion code
        document.getElementById('promotionCode').addEventListener('input', function() {
            this.value = this.value.toUpperCase();
        });

        // Form validation
        document.getElementById('promotionForm').addEventListener('submit', function(e) {
            const code = document.getElementById('promotionCode').value.trim();
            if (code.length < 3) {
                e.preventDefault();
                alert('Mã khuyến mãi phải có ít nhất 3 ký tự');
                return false;
            }
        });
    </script>
</body>
</html> 
 
 