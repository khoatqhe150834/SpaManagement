<%-- Document : cart.jsp
    Created on : Cart Page
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Giỏ Hàng - BeautyZone Spa</title>
    
    <!-- Include Home Framework Styles -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp" />
    
    <style>
        /* Ensure page content is visible */
        .page-wraper {
            visibility: visible !important;
            opacity: 1 !important;
        }
        
        .page-content {
            visibility: visible !important;
            opacity: 1 !important;
        }
        
        #loading-area {
            display: none !important;
        }
        
        .cart-container {
            padding: 2rem 0;
            min-height: 400px;
        }
        .cart-item {
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .cart-item-image {
            width: 80px;
            height: 80px;
            background: #f0f0f0;
            border-radius: 8px;
            flex-shrink: 0;
        }
        .cart-item-details {
            flex-grow: 1;
        }
        .cart-item-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 0.5rem;
        }
        .cart-item-price {
            color: #586BB4;
            font-weight: 600;
            font-size: 1.1rem;
        }
        .cart-item-quantity {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin: 0.5rem 0;
        }
        .quantity-btn {
            background: #586BB4;
            color: white;
            border: none;
            width: 30px;
            height: 30px;
            border-radius: 4px;
            cursor: pointer;
        }
        .quantity-input {
            width: 60px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 0.25rem;
        }
        .remove-btn {
            background: #ff4757;
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            cursor: pointer;
        }
        .cart-summary {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            margin-top: 2rem;
        }
        .empty-cart {
            text-align: center;
            padding: 3rem;
            color: #666;
        }
        .continue-shopping {
            background: #586BB4;
            color: white;
            text-decoration: none;
            padding: 0.75rem 1.5rem;
            border-radius: 4px;
            display: inline-block;
            margin-top: 1rem;
        }
    </style>
</head>
<body id="bg">
    <div class="page-wraper">
        <div id="loading-area"></div>
        
        <!-- header -->
        <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>
        <!-- header END -->
        
        <!-- Content -->
        <div class="page-content bg-white">
            <!-- inner page banner -->
            <div class="dlab-bnr-inr overlay-primary bg-pt" style="background-image: url(${pageContext.request.contextPath}/assets/home/images/banner/bnr2.jpg);">
                <div class="container">
                    <div class="dlab-bnr-inr-entry">
                        <h1 class="text-white">Giỏ Hàng</h1>
                        <!-- Breadcrumb row -->
                        <div class="breadcrumb-row">
                            <ul class="list-inline">
                                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                <li>Giỏ Hàng</li>
                            </ul>
                        </div>
                        <!-- Breadcrumb row END -->
                    </div>
                </div>
            </div>
            <!-- inner page banner END -->
            
            <!-- Cart Content -->
            <section class="content-inner cart-container">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-8">
                            <h3>Giỏ Hàng Của Bạn</h3>
                            
                            <c:choose>
                                <c:when test="${not empty cartItems && not empty cart && cart.totalItemCount > 0}">
                                    <div class="cart-items">
                                        <c:forEach var="item" items="${cartItems}">
                                            <div class="cart-item" data-cart-item-id="${item.cartItemId}">
                                                <div class="cart-item-image">
                                                    <c:choose>
                                                        <c:when test="${not empty item.serviceImageUrl}">
                                                            <img src="${item.serviceImageUrl}" alt="${item.serviceName}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 8px;">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div style="width: 100%; height: 100%; background: #f0f0f0; display: flex; align-items: center; justify-content: center; border-radius: 8px;">
                                                                <i class="fa fa-spa" style="font-size: 2rem; color: #ccc;"></i>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="cart-item-details">
                                                    <div class="cart-item-title">${item.serviceName}</div>
                                                    <div class="cart-item-price">
                                                        <fmt:formatNumber value="${item.priceAtAddition}" type="currency" currencyCode="VND" />
                                                    </div>
                                                    <div class="cart-item-quantity">
                                                        <button type="button" class="quantity-btn" onclick="updateQuantity(${item.cartItemId}, ${item.quantity - 1})">-</button>
                                                        <input type="number" class="quantity-input" value="${item.quantity}" min="1" onchange="updateQuantity(${item.cartItemId}, this.value)">
                                                        <button type="button" class="quantity-btn" onclick="updateQuantity(${item.cartItemId}, ${item.quantity + 1})">+</button>
                                                    </div>
                                                    <c:if test="${not empty item.notes}">
                                                        <div class="cart-item-notes">
                                                            <small class="text-muted">Ghi chú: ${item.notes}</small>
                                                        </div>
                                                    </c:if>
                                                </div>
                                                <div class="cart-item-actions">
                                                    <button type="button" class="remove-btn" onclick="removeFromCart(${item.cartItemId})">
                                                        <i class="fa fa-trash"></i> Xóa
                                                    </button>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-cart">
                                        <i class="fa fa-shopping-cart" style="font-size: 4rem; color: #ddd; margin-bottom: 1rem;"></i>
                                        <h4>Giỏ hàng của bạn đang trống</h4>
                                        <p>Hãy khám phá các dịch vụ tuyệt vời của chúng tôi!</p>
                                        <a href="${pageContext.request.contextPath}/process-booking/services" class="continue-shopping">
                                            <i class="fa fa-spa"></i> Khám Phá Dịch Vụ
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div class="col-lg-4">
                            <c:if test="${not empty cartItems && not empty cart && cart.totalItemCount > 0}">
                                <div class="cart-summary">
                                    <h4>Tóm Tắt Đơn Hàng</h4>
                                    <div class="summary-row" style="display: flex; justify-content: space-between; margin: 1rem 0;">
                                        <span>Tổng số dịch vụ:</span>
                                        <span>${cart.totalItemCount}</span>
                                    </div>
                                    <hr>
                                    <div class="summary-actions">
                                        <a href="${pageContext.request.contextPath}/process-booking/services" class="continue-shopping" style="width: 100%; text-align: center; margin-bottom: 1rem;">
                                            Tiếp Tục Mua Sắm
                                        </a>
                                        <button type="button" class="site-button radius-no" style="width: 100%;" onclick="proceedToBooking()">
                                            Tiến Hành Đặt Lịch
                                        </button>
                                        <button type="button" class="remove-btn" style="width: 100%; margin-top: 1rem;" onclick="clearCart()">
                                            Xóa Toàn Bộ Giỏ Hàng
                                        </button>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </section>
            <!-- Cart Content END -->
        </div>
        
        <!-- footer -->
        <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
        <!-- footer END -->
    </div>
    
    <!-- JavaScript -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp" />
    
    <!-- Cart Specific JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/home/js/cart.js"></script>
    
    <script>
        // Set the cart API base URL for the cart.js file
        CART_API_BASE_URL = '${pageContext.request.contextPath}/api/cart';
    </script>
    
    <script>
        // All cart functionality is now handled by cart.js
        // Functions are available globally: updateQuantity, removeFromCart, clearCart, proceedToBooking
        
        // Ensure page content is visible and loading area is hidden
        document.addEventListener('DOMContentLoaded', function() {
            // Hide loading area
            const loadingArea = document.getElementById('loading-area');
            if (loadingArea) {
                loadingArea.style.display = 'none';
            }
            
            // Ensure page wrapper is visible
            const pageWrapper = document.querySelector('.page-wraper');
            if (pageWrapper) {
                pageWrapper.style.visibility = 'visible';
                pageWrapper.style.opacity = '1';
            }
            
            // Ensure page content is visible
            const pageContent = document.querySelector('.page-content');
            if (pageContent) {
                pageContent.style.visibility = 'visible';
                pageContent.style.opacity = '1';
            }
            
            console.log('Cart page loaded successfully');
        });
        
        // Fallback to ensure content shows even if DOMContentLoaded doesn't fire
        setTimeout(function() {
            const loadingArea = document.getElementById('loading-area');
            if (loadingArea) {
                loadingArea.style.display = 'none';
            }
            
            const pageWrapper = document.querySelector('.page-wraper');
            if (pageWrapper) {
                pageWrapper.style.visibility = 'visible';
                pageWrapper.style.opacity = '1';
            }
        }, 1000);
    </script>
</body>
</html> 