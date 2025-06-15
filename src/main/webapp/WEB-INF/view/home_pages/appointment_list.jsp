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
                            <h1 class="text-white">Appointments</h1>
                            <!-- Breadcrumb row -->
                            <div class="breadcrumb-row">
                                <ul class="list-inline">
                                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                                    <li>Appointments</li>
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
                    <div class="container-fluid py-5">
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
                                        </div>
                                    </div>                                   
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-primary w-100">Search</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Appointments List -->
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive w-80">
                                    <table class="table table-hover w-80">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Booking Group</th>
                                                <th>Therapist</th>
                                                <th>Start Time</th>
                                                <th>End Time</th>
                                                <th>Original Price</th>
                                                <th>Discount</th>
                                                <th>Redeemed</th>
                                                <th>Final Price</th>
                                                <th>Details</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="a" items="${appointments}" varStatus="loop">
                                                <tr>
                                                    <td>${loop.index +1}</td>
                                                    <td>${a.bookingGroupName}</td>
                                                    <td>${a.therapistName}</td>
                                                    <td>${a.startTime}</td>
                                                    <td>${a.endTime}</td>
                                                    <td><fmt:formatNumber value="${a.totalOriginalPrice}" type="number" maxFractionDigits="0" />đ</td>
                                                    <td><fmt:formatNumber value="${a.totalDiscountAmount}" type="number" maxFractionDigits="0" />đ</td>
                                                    <td><fmt:formatNumber value="${a.pointsRedeemedValue}" type="number" maxFractionDigits="0" />đ</td>
                                                    <td><fmt:formatNumber value="${a.totalFinalPrice}" type="number" maxFractionDigits="0" />đ</td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/appointment?action=details&id=${a.appointmentId}" 
                                                           class="btn btn-sm btn-outline-primary">
                                                            Details
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

