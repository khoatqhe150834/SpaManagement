<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="light">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Appointment List</title>
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
        </head>

        <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>

        <c:url value="/appointment" var="paginationUrl">
            <c:param name="action" value="list" />
            <c:if test="${not empty param.status}">
                <c:param name="status" value="${param.status}" />
            </c:if>
            <c:if test="${not empty param.paymentStatus}">
                <c:param name="paymentStatus" value="${param.paymentStatus}" />
            </c:if>
            <c:if test="${not empty param.search}">
                <c:param name="search" value="${param.search}" />
            </c:if>
        </c:url>

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Appointment List</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Appointments</li>
                </ul>
            </div>

            <div class="card h-100 p-0 radius-12">
                <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center flex-wrap gap-3 justify-content-between">
                    <form action="${pageContext.request.contextPath}/appointment" method="GET" class="d-flex align-items-center gap-3">
                        <input type="hidden" name="action" value="list" />

                        <div class="navbar-search">
                            <input type="text" class="bg-base h-40-px w-auto" name="search" placeholder="Search by customer, therapist, group"
                                   value="${param.search}">
                            <iconify-icon icon="ion:search-outline" class="icon"></iconify-icon>
                        </div>

                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="status">
                            <option value="">All Status</option>
                            <option value="PENDING_CONFIRMATION" ${param.status == 'PENDING_CONFIRMATION' ? 'selected' : ''}>Pending</option>
                            <option value="CONFIRMED" ${param.status == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                            <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                        </select>

                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="paymentStatus">
                            <option value="">All Payment</option>
                            <option value="UNPAID" ${param.paymentStatus == 'UNPAID' ? 'selected' : ''}>Unpaid</option>
                            <option value="PAID" ${param.paymentStatus == 'PAID' ? 'selected' : ''}>Paid</option>
                        </select>

                        <button type="submit" class="btn btn-primary h-40-px radius-12">Search</button>
                    </form>
                </div>

                <div class="card-body p-24">
                    <div class="table-responsive scroll-sm">
                        <table class="table bordered-table sm-table mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Customer</th>
                                    <th>Booking Group</th>
                                    <th>Therapist</th>
                                    <th>Start</th>
                                    <th>End</th>
                                    <th>Original Price</th>
                                    <th>Discount</th>
                                    <th>Redeemed Points</th>
                                    <th>Total</th>
                                    <th>Status</th>
                                    <th>Payment</th>
                                    <th>Cancel Reason</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="a" items="${appointments}" varStatus="loop">
                                    <tr>
                                        <td>${loop.index + 1}</td>
                                        <td>${a.customerName}</td>
                                        <td>${a.bookingGroupName}</td>
                                        <td>${a.therapistName}</td>
                                        <td>${a.startTime}</td>
                                        <td>${a.endTime}</td>
                                        <td><fmt:formatNumber value="${a.totalOriginalPrice}" type="number" maxFractionDigits="0" />đ</td>
                                        <td><fmt:formatNumber value="${a.totalDiscountAmount}" type="number" maxFractionDigits="0" />đ</td>
                                        <td><fmt:formatNumber value="${a.pointsRedeemedValue}" type="number" maxFractionDigits="0" />đ</td>
                                        <td><fmt:formatNumber value="${a.totalFinalPrice}" type="number" maxFractionDigits="0" />đ</td>                                      
                                        <td>${a.status}</td>
                                        <td>${a.paymentStatus}</td>
                                        <td>${a.cancelReason}</td>
                                        <td class="text-center"> 
                                            <div class="d-flex align-items-center gap-10 justify-content-center">
                                                <button type="button" class="bg-success-focus text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle"
                                                        onclick="window.location.href = '${pageContext.request.contextPath}/appointment?action=details&id=${appointment.appointmentId}'"> 
                                                    <iconify-icon icon="lucide:edit" class="menu-icon"></iconify-icon>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty appointments}">
                                    <tr><td colspan="18" class="text-center">No appointments found.</td></tr>
                                </c:if>
                            </tbody>
                        </table>

                    </div>

                    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24">
                        <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}">
                                        <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach begin="1" end="${totalpages}" var="i">
                                <li class="page-item">
                                    <a class="page-link ${currentPage == i ? 'bg-primary-600 text-white' : ''}" href="${paginationUrl}&page=${i}">${i}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${currentPage < totalpages}">
                                <li class="page-item">
                                    <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}">
                                        <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>
    </body>

</html>
