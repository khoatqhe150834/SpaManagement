<%-- 
    Document   : history.jsp
    Created on : Treatment History
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Lịch Sử Liệu Pháp - BeautyZone Spa</title>
    
    <!-- Include Admin Framework Styles -->
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/customer/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
    
    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Lịch Sử Liệu Pháp</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/dashboard/customer" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Bảng Điều Khiển
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Lịch Sử Liệu Pháp</li>
            </ul>
        </div>
        
        <div class="card h-100 p-0 radius-12">
            <div class="card-body p-24">
                <h5 class="card-title mb-20">Lịch Sử Liệu Pháp</h5>
                <div class="text-center py-48">
                    <iconify-icon icon="solar:file-text-outline" class="text-primary-600" style="font-size: 64px;"></iconify-icon>
                    <h6 class="text-neutral-600 mb-8 mt-3">Lịch Sử Liệu Pháp</h6>
                    <p class="text-neutral-400 text-sm mb-24">Xem lại tất cả các liệu pháp bạn đã trải nghiệm tại spa.</p>
                    <div class="row justify-content-center">
                        <div class="col-md-6">
                            <a href="${pageContext.request.contextPath}/dashboard/customer/appointments/booking" class="btn btn-primary btn-sm px-20 py-11 radius-8 w-100 mb-12">
                                <iconify-icon icon="solar:calendar-add-outline" class="icon text-lg me-8"></iconify-icon>
                                Đặt Lịch Hẹn Mới
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Include Admin Framework JavaScript -->
    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 