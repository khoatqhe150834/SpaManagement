<%-- 
    Document   : revenue.jsp
    Created on : Manager Dashboard Revenue Overview
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng Quan Doanh Thu - Manager Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/manager/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Tổng Quan Doanh Thu</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/manager-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Báo Cáo Doanh Thu</li>
                <li>-</li>
                <li class="fw-medium">Tổng Quan Doanh Thu</li>
            </ul>
        </div>

        <div class="card">
            <div class="card-body">
                <h4>Tổng Quan Doanh Thu</h4>
                <p>Trang tổng quan doanh thu theo thời gian</p>
                <p>TODO: Implement revenue overview dashboard</p>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 
