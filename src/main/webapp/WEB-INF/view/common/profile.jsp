<%-- 
    Document   : profile
    Created on : Jun 4, 2025, 10:16:41 AM
    Author     : quang
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <title>BeautyZone : Hồ Sơ Cá Nhân</title>
        
        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            primary: "#D4AF37",
                            "primary-dark": "#B8941F",
                            secondary: "#FADADD",
                            "spa-cream": "#FFF8F0",
                            "spa-dark": "#333333",
                            "spa-gray": "#F3F4F6",
                        },
                        fontFamily: {
                            sans: ["Roboto", "sans-serif"],
                        },
                    },
                },
            };
        </script>

        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

        <!-- Lucide Icons -->
        <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>

        <!-- Custom CSS -->
        <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
    </head>

    <body>
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/header.jsp" />
            
        <div class="dashboard-main-body ml-64">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Thông Tin Cá Nhân</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Trang chủ
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Hồ sơ cá nhân</li>
                </ul>
            </div>

            <div class="row gy-4">
                <div class="col-lg-8">
                    <!-- Personal Information Card -->
                    <div class="card h-100">
                        <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center justify-content-between">
                            <h6 class="text-lg fw-semibold mb-0 d-flex align-items-center">
                                <iconify-icon icon="solar:user-outline" class="icon text-xl me-8"></iconify-icon>
                                Thông tin cá nhân
                            </h6>
                            <a href="${pageContext.request.contextPath}/profile/edit" 
                               class="btn btn-primary btn-sm d-flex align-items-center gap-2">
                                <iconify-icon icon="solar:pen-outline" class="icon text-sm"></iconify-icon>
                                Chỉnh sửa
                            </a>
                        </div>
                        <div class="card-body p-24">
                            <div class="row gy-4">
                                <div class="col-md-6">
                                    <div class="border radius-8 p-16 bg-neutral-50">
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <iconify-icon icon="solar:user-outline" class="text-primary-600 text-lg"></iconify-icon>
                                            <span class="text-secondary-light text-sm fw-medium">Họ và tên</span>
                                        </div>
                                        <h6 class="text-md fw-semibold text-primary-light mb-0">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user}">
                                                    ${sessionScope.user.fullName}
                                                </c:when>
                                                <c:otherwise>
                                                    ${sessionScope.customer.fullName}
                                                </c:otherwise>
                                            </c:choose>
                                        </h6>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="border radius-8 p-16 bg-neutral-50">
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <iconify-icon icon="solar:letter-outline" class="text-success-main text-lg"></iconify-icon>
                                            <span class="text-secondary-light text-sm fw-medium">Email</span>
                                        </div>
                                        <h6 class="text-md fw-semibold text-primary-light mb-0">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user}">
                                                    ${sessionScope.user.email}
                                                </c:when>
                                                <c:otherwise>
                                                    ${sessionScope.customer.email}
                                                </c:otherwise>
                                            </c:choose>
                                        </h6>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="border radius-8 p-16 bg-neutral-50">
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <iconify-icon icon="solar:phone-outline" class="text-info-main text-lg"></iconify-icon>
                                            <span class="text-secondary-light text-sm fw-medium">Số điện thoại</span>
                                        </div>
                                        <h6 class="text-md fw-semibold text-primary-light mb-0">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user}">
                                                    ${sessionScope.user.phoneNumber}
                                                </c:when>
                                                <c:otherwise>
                                                    ${sessionScope.customer.phoneNumber}
                                                </c:otherwise>
                                            </c:choose>
                                        </h6>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="border radius-8 p-16 bg-neutral-50">
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <iconify-icon icon="solar:users-group-rounded-outline" class="text-warning-main text-lg"></iconify-icon>
                                            <span class="text-secondary-light text-sm fw-medium">Giới tính</span>
                                        </div>
                                        <h6 class="text-md fw-semibold text-primary-light mb-0">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user}">
                                                    <c:choose>
                                                        <c:when test="${sessionScope.user.gender == 'MALE'}">Nam</c:when>
                                                        <c:when test="${sessionScope.user.gender == 'FEMALE'}">Nữ</c:when>
                                                        <c:when test="${sessionScope.user.gender == 'OTHER'}">Khác</c:when>
                                                        <c:when test="${sessionScope.user.gender == 'UNKNOWN'}">Chưa cập nhật</c:when>
                                                        <c:when test="${empty sessionScope.user.gender}">Chưa cập nhật</c:when>
                                                        <c:otherwise>Khác</c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <c:when test="${sessionScope.customer.gender == 'MALE'}">Nam</c:when>
                                                        <c:when test="${sessionScope.customer.gender == 'FEMALE'}">Nữ</c:when>
                                                        <c:when test="${sessionScope.customer.gender == 'OTHER'}">Khác</c:when>
                                                        <c:when test="${sessionScope.customer.gender == 'UNKNOWN'}">Chưa cập nhật</c:when>
                                                        <c:when test="${empty sessionScope.customer.gender}">Chưa cập nhật</c:when>
                                                        <c:otherwise>Khác</c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </h6>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="border radius-8 p-16 bg-neutral-50">
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <iconify-icon icon="solar:calendar-date-outline" class="text-purple-600 text-lg"></iconify-icon>
                                            <span class="text-secondary-light text-sm fw-medium">Ngày sinh</span>
                                        </div>
                                        <h6 class="text-md fw-semibold text-primary-light mb-0">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user}">
                                                    <c:choose>
                                                        <c:when test="${not empty sessionScope.user.birthday}">
                                                            ${sessionScope.user.birthday}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Chưa cập nhật
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <c:when test="${not empty sessionScope.customer.birthday}">
                                                            ${sessionScope.customer.birthday}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Chưa cập nhật
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </h6>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="border radius-8 p-16 bg-neutral-50">
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <iconify-icon icon="solar:shield-check-outline" class="text-success-main text-lg"></iconify-icon>
                                            <span class="text-secondary-light text-sm fw-medium">Trạng thái tài khoản</span>
                                        </div>
                                        <h6 class="text-md fw-semibold text-primary-light mb-0">
                                            Đang hoạt động
                                        </h6>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-4">
                    <!-- Quick Stats for Customers -->
                    <c:if test="${not empty sessionScope.customer}">
                        <div class="row gy-4 mb-24">
                            <div class="col-6">
                                <div class="card text-center">
                                    <div class="card-body p-16">
                                        <iconify-icon icon="solar:calendar-outline" class="text-primary-600 text-2xl mb-2"></iconify-icon>
                                        <h4 class="text-primary-600 fw-bold mb-1">0</h4>
                                        <span class="text-secondary-light text-sm">Lịch hẹn</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="card text-center">
                                    <div class="card-body p-16">
                                        <iconify-icon icon="solar:star-outline" class="text-warning-main text-2xl mb-2"></iconify-icon>
                                        <h4 class="text-warning-main fw-bold mb-1">0</h4>
                                        <span class="text-secondary-light text-sm">Điểm tích lũy</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <!-- Action Buttons -->
                    <div class="card">
                        <div class="card-header border-bottom bg-base py-16 px-24">
                            <h6 class="text-lg fw-semibold mb-0 d-flex align-items-center">
                                <iconify-icon icon="solar:settings-outline" class="icon text-xl me-8"></iconify-icon>
                                Hành động
                            </h6>
                        </div>
                        <div class="card-body p-24">
                            <a href="${pageContext.request.contextPath}/profile/change-password" 
                               class="btn btn-primary d-flex align-items-center gap-2 mb-12 w-100">
                                <iconify-icon icon="solar:lock-outline" class="icon text-lg"></iconify-icon>
                                Đổi mật khẩu
                            </a>
                            
                            <c:if test="${not empty sessionScope.customer}">
                                <a href="${pageContext.request.contextPath}/appointment" 
                                   class="btn btn-outline-success d-flex align-items-center gap-2 mb-12 w-100">
                                    <iconify-icon icon="solar:calendar-outline" class="icon text-lg"></iconify-icon>
                                    Đặt lịch hẹn
                                </a>
                            </c:if>
                            
                            <a href="${pageContext.request.contextPath}/" 
                               class="btn btn-outline-info d-flex align-items-center gap-2 w-100">
                                <iconify-icon icon="solar:home-outline" class="icon text-lg"></iconify-icon>
                                Trang chủ
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Initialize Lucide icons -->
        <script>
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        </script>
    </body>
</html>
