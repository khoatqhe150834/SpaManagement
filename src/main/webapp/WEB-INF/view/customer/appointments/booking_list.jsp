<%-- 
    Document   : booking_list
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
                            <h1 class="text-white">My Appointments</h1>
                            <!-- Breadcrumb row -->
                            <div class="breadcrumb-row">
                                <ul class="list-inline">
                                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                                    <li>My Appointments</li>
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

                        <!-- Error Message -->
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle"></i> ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Filters -->
                        <div class="card mb-4">
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/booking/list" method="GET" class="row g-3">
                                    <div class="col-md-4">
                                        <div class="input-group">
                                            <input type="text" class="form-control" name="search" 
                                                   placeholder="Search by service or therapist" 
                                                   value="${search != null ? search : ''}">
                                        </div>
                                    </div>                                   
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-primary w-60">Search</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Booking Groups List -->
                        <div class="card">
                            <div class="card-body">
                                <c:if test="${empty bookingGroups}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                        <h4 class="text-muted">No appointments found</h4>
                                        <p class="text-muted">You haven't made any appointments yet.</p>
                                        <a href="${pageContext.request.contextPath}/booking" class="btn btn-primary">Book Now</a>
                                    </div>
                                </c:if>
                                
                                <c:forEach var="bookingGroup" items="${bookingGroups}" varStatus="groupLoop">
                                    <div class="booking-group mb-4 border rounded p-3">
                                        <!-- Booking Group Header -->
                                        <div class="row align-items-center mb-3">
                                            <div class="col-md-3">
                                                <h6 class="mb-1">Booking #${bookingGroup.bookingGroupId}</h6>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${bookingGroup.bookingDate}" pattern="dd/MM/yyyy"/>
                                                </small>
                                            </div>
                                            <div class="col-md-3">
                                                <div>
                                                    <span class="fw-bold">Booking status:</span>
                                                    <span class="badge bg-${bookingGroup.bookingStatus == 'CONFIRMED' ? 'success' : 
                                                                              bookingGroup.bookingStatus == 'IN_PROGRESS' ? 'warning' : 
                                                                              bookingGroup.bookingStatus == 'COMPLETED' ? 'info' : 'danger'} text-white">
                                                        ${bookingGroup.bookingStatus}
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="mt-1">
                                                    <span class="fw-bold">Payment status:</span>
                                                    <span class="badge bg-${bookingGroup.paymentStatus == 'PAID' ? 'success' : 'warning'} text-white">
                                                        ${bookingGroup.paymentStatus}
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <strong>Total: <fmt:formatNumber value="${bookingGroup.totalAmount}" type="number" maxFractionDigits="0" />đ</strong>
                                            </div>
                                            <div class="col-md-3 text-end">
                                                <c:if test="${not empty bookingGroup.specialNotes}">
                                                    <small class="text-muted">
                                                       Special Note: ${bookingGroup.specialNotes}
                                                    </small>
                                                </c:if>
                                            </div>
                                        </div>
                                        
                                        <!-- Appointments in this group -->
                                        <div class="table-responsive">
                                            <table class="table table-sm table-hover">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>#</th>
                                                        <th>Service</th>
                                                        <th>Therapist</th>
                                                        <th>Date & Time</th>
                                                        <th>Duration</th>
                                                        <th>Price</th>
                                                        <th>Status</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="appointment" items="${bookingGroup.appointments}" varStatus="appointmentLoop">
                                                        <tr>
                                                            <td>${appointmentLoop.index + 1}</td>
                                                            <td>
                                                                <strong>${appointment.serviceName}</strong>
                                                                <c:if test="${not empty appointment.serviceNotes}">
                                                                    <br><small class="text-muted">${appointment.serviceNotes}</small>
                                                                </c:if>
                                                            </td>
                                                            <td>${appointment.therapistName}</td>
                                                            <td>
                                                                <fmt:formatDate value="${appointment.startTime}" pattern="dd/MM/yyyy"/>
                                                                <br>
                                                                <small class="text-muted">
                                                                    <fmt:formatDate value="${appointment.startTime}" pattern="HH:mm"/> - 
                                                                    <fmt:formatDate value="${appointment.endTime}" pattern="HH:mm"/>
                                                                </small>
                                                            </td>
                                                            <td>
                                                                <c:set var="startTime" value="${appointment.startTime}" />
                                                                <c:set var="endTime" value="${appointment.endTime}" />
                                                                <c:set var="durationMillis" value="${endTime.time - startTime.time}" />
                                                                <c:set var="durationMinutes" value="${durationMillis / (1000 * 60)}" />
                                                                ${durationMinutes.intValue()} min
                                                            </td>
                                                            <td><fmt:formatNumber value="${appointment.servicePrice}" type="number" maxFractionDigits="0" />đ</td>
                                                            <td>
                                                                <span class="badge bg-${appointment.status == 'SCHEDULED' ? 'primary' : 
                                                                                      appointment.status == 'IN_PROGRESS' ? 'warning' : 
                                                                                      appointment.status == 'COMPLETED' ? 'success' : 'danger'} text-white">
                                                                    ${appointment.status}
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <a href="${pageContext.request.contextPath}/booking/details/${appointment.appointmentId}" 
                                                                   class="btn btn-success w-30">
                                                                   Details
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </c:forEach>
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

