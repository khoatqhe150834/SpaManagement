<%-- 
    Document   : appointment_list
    Created on : Jun 4, 2025, 9:43:50 PM
    Author     : ADMIN
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">

    <!-- Mirrored from www.beautyzone.dexignzone.com/xhtml/shop-cart.html by HTTrack Website Copier/3.x [XR&CO'2014], Sat, 24 May 2025 16:40:41 GMT -->
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Appointments</title>
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp" />
    </head>
    <body id="bg">
        <div class="page-wraper">
            <div id="loading-area"></div>
            <!-- header -->
            <jsp:include page="/WEB-INF/view/common/home/header.jsp" />
            <!-- header END -->
            <!-- Content -->
            <div class="page-content bg-white">
                <!-- inner page banner -->
                <div class="dlab-bnr-inr overlay-primary bg-pt" style="background-image:url(images/banner/bnr1.jpg);">
                    <div class="container">
                        <div class="dlab-bnr-inr-entry">
                            <h1 class="text-white">Cart</h1>
                            <!-- Breadcrumb row -->
                            <div class="breadcrumb-row">
                                <ul class="list-inline">
                                    <li><a href="index.html">Home</a></li>
                                    <li>Shop Cart</li>
                                </ul>
                            </div>
                            <!-- Breadcrumb row END -->
                        </div>
                    </div>
                </div>
                <!-- inner page banner END -->
                <!-- contact area -->
                <div class="section-full content-inner">
                    <!-- Product -->
                    <div class="container py-5">
                        <div class="row mb-4">
                            <div class="col">
                                <h2 class="mb-0">My Appointments</h2>
                            </div>
                        </div>

                        <!-- Filters -->
                        <div class="card mb-4">
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/appointment" method="GET" class="row g-3">
                                    <div class="col-md-4">
                                        <div class="input-group">
                                            <input type="text" class="form-control" name="search" 
                                                   placeholder="Search by group or therapist" 
                                                   value="${param.search != null ? param.search : ''}">
                                            <button class="btn btn-primary" type="submit">
                                                <i class="bi bi-search"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select" name="status">
                                            <option value="">All Status</option>
                                            <option value="PENDING_CONFIRMATION" ${param.status == 'PENDING_CONFIRMATION' ? 'selected' : ''}>Pending</option>
                                            <option value="CONFIRMED" ${param.status == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                                            <option value="IN_PROGRESS" ${param.status == 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                                            <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                            <option value="CANCELLED_BY_CUSTOMER" ${param.status == 'CANCELLED_BY_CUSTOMER' ? 'selected' : ''}>Cancelled by You</option>
                                            <option value="CANCELLED_BY_SPA" ${param.status == 'CANCELLED_BY_SPA' ? 'selected' : ''}>Cancelled by SPA</option>
                                            <option value="NO_SHOW" ${param.status == 'NO_SHOW' ? 'selected' : ''}>No-show</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select" name="paymentStatus">
                                            <option value="">All Payment Status</option>
                                            <option value="UNPAID" ${param.paymentStatus == 'UNPAID' ? 'selected' : ''}>Unpaid</option>
                                            <option value="PARTIALLY_PAID" ${param.paymentStatus == 'PARTIALLY_PAID' ? 'selected' : ''}>Partially Paid</option>
                                            <option value="PAID" ${param.paymentStatus == 'PAID' ? 'selected' : ''}>Paid</option>
                                            <option value="REFUNDED" ${param.paymentStatus == 'REFUNDED' ? 'selected' : ''}>Refunded</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-primary w-100">Filter</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Appointments List -->
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Booking Group</th>
                                                <th>Therapist</th>
                                                <th>Date & Time</th>
                                                <th>Total</th>
                                                <th>Status</th>
                                                <th>Payment</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="a" items="${appointments}" varStatus="loop">
                                                <tr>
                                                    <td>${(currentPage - 1) * 10 + loop.index + 1}</td>
                                                    <td>${a.bookingGroupName}</td>
                                                    <td>${a.therapistName}</td>
                                                    <td>
                                                        <fmt:formatDate value="${a.startTime}" pattern="dd/MM/yyyy HH:mm" />
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${a.totalFinalPrice}" type="number" maxFractionDigits="0" />đ
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-${a.status == 'COMPLETED' ? 'success' : 
                                                                  a.status == 'IN_PROGRESS' ? 'primary' : 
                                                                  a.status == 'CONFIRMED' ? 'info' : 
                                                                  a.status == 'PENDING_CONFIRMATION' ? 'warning' : 
                                                                  'danger'}">
                                                            ${a.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-${a.paymentStatus == 'PAID' ? 'success' : 
                                                                  a.paymentStatus == 'PARTIALLY_PAID' ? 'warning' : 
                                                                  a.paymentStatus == 'REFUNDED' ? 'info' : 
                                                                  'danger'}">
                                                            ${a.paymentStatus}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/appointment?action=details&id=${a.appointmentId}" 
                                                           class="btn btn-sm btn-outline-primary">
                                                            View Details
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty appointments}">
                                                <tr>
                                                    <td colspan="8" class="text-center">No appointments found.</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination -->
                                <c:if test="${totalpages > 1}">
                                    <nav class="mt-4">
                                        <ul class="pagination justify-content-center">
                                            <c:if test="${currentPage > 1}">
                                                <li class="page-item">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/appointment?page=${currentPage - 1}${param.status != null ? '&status=' + param.status : ''}${param.paymentStatus != null ? '&paymentStatus=' + param.paymentStatus : ''}${param.search != null ? '&search=' + param.search : ''}">
                                                        Previous
                                                    </a>
                                                </li>
                                            </c:if>
                                            
                                            <c:forEach begin="1" end="${totalpages}" var="i">
                                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/appointment?page=${i}${param.status != null ? '&status=' + param.status : ''}${param.paymentStatus != null ? '&paymentStatus=' + param.paymentStatus : ''}${param.search != null ? '&search=' + param.search : ''}">
                                                        ${i}
                                                    </a>
                                                </li>
                                            </c:forEach>
                                            
                                            <c:if test="${currentPage < totalpages}">
                                                <li class="page-item">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/appointment?page=${currentPage + 1}${param.status != null ? '&status=' + param.status : ''}${param.paymentStatus != null ? '&paymentStatus=' + param.paymentStatus : ''}${param.search != null ? '&search=' + param.search : ''}">
                                                        Next
                                                    </a>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </nav>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    <!-- Product END -->
                </div>

                <!-- contact area  END -->
            </div>
            <!-- Content END-->
            <!-- Footer -->
            <jsp:include page="/WEB-INF/view/common/home/footer.jsp" />
            <!-- Footer END -->
            <button class="scroltop fa fa-chevron-up" ></button>
        </div>
        <!-- JAVASCRIPT FILES ========================================= -->
        <jsp:include page="/WEB-INF/view/common/home/js.jsp" />
    </body>

    <!-- Mirrored from www.beautyzone.dexignzone.com/xhtml/shop-cart.html by HTTrack Website Copier/3.x [XR&CO'2014], Sat, 24 May 2025 16:40:42 GMT -->
</html>

