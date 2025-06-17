<%-- 
    Document   : appointment_details.jsp
    Created on : Jun 3, 2025, 8:02:13 PM
    Author     : ADMIN
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Appointment List</title>
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    </head>

    <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <!-- Tạo URL phân trang, chỉ giữ action=list + search/status/paymentStatus -->
        <c:url value="/appointment" var="paginationUrl">
            <c:param name="action" value="list" />
            <c:if test="${not empty param.search}">
                <c:param name="search" value="${param.search}" />
            </c:if>
            <c:if test="${not empty param.status}">
                <c:param name="status" value="${param.status}" />
            </c:if>
            <c:if test="${not empty param.paymentStatus}">
                <c:param name="paymentStatus" value="${param.paymentStatus}" />
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
                            <input type="text" class="bg-base h-40-px w-auto" name="search" placeholder="Search by customer, therapist, group" value="${param.search != null ? param.search : ''}"/>
                            <iconify-icon icon="ion:search-outline" class="icon"></iconify-icon>
                        </div>

                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="status">
                            <option value="">All Status</option>
                            <option value="PENDING_CONFIRMATION" ${param.status == 'PENDING_CONFIRMATION' ? 'selected' : ''}>Pending</option>
                            <option value="CONFIRMED" ${param.status == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                            <option value="CANCELLED_BY_CUSTOMER" ${param.status == 'CANCELLED_BY_CUSTOMER' ? 'selected' : ''}>Cancelled by Customer</option>
                            <option value="CANCELLED_BY_SPA" ${param.status == 'CANCELLED_BY_SPA' ? 'selected' : ''}>Cancelled by SPA</option>
                            <option value="IN_PROGRESS" ${param.status == 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                            <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                            <option value="NO_SHOW" ${param.status == 'NO_SHOW' ? 'selected' : ''}>No-show</option>
                        </select>

                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="paymentStatus">
                            <option value="">All Payment</option>
                            <option value="UNPAID" ${param.paymentStatus == 'UNPAID' ? 'selected' : ''}>Unpaid</option>
                            <option value="PARTIALLY_PAID" ${param.paymentStatus == 'PARTIALLY_PAID' ? 'selected' : ''}>Partially Paid</option>
                            <option value="PAID" ${param.paymentStatus == 'PAID' ? 'selected' : ''}>Paid</option>
                            <option value="REFUNDED" ${param.paymentStatus == 'REFUNDED' ? 'selected' : ''}>Refunded</option>
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
                                    <th>Points</th>
                                    <th>Total</th>
                                    <th>Status</th>
                                    <th>Payment</th>
                                    <th>Cancel Reason</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="a" items="${appointments}" varStatus="loop">
                                    <tr>
                                        <!-- Tính STT chính xác theo phân trang -->
                                        <td>${(currentPage - 1) * 10 + loop.index + 1}</td>
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
                                        <!-- Cột Action: nút Save -->
                                        <td class="text-center">
                                           <button type="button" class="bg-success-focus text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle"
                                                    onclick="window.location.href = '${pageContext.request.contextPath}/appointment?action=details&id=${a.appointmentId}'"> 
                                                <iconify-icon icon="lucide:edit" class="menu-icon"></iconify-icon>
                                            </button>
                                        </td>
                                    </tr>
                              </c:forEach>
                                    
                                <c:if test="${empty appointments}">
                                    <tr>
                                        <td colspan="14" class="text-center">No appointments found.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Phân trang (pagination) -->
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
                                    <a 
                                        class="page-link ${currentPage == i ? 'bg-primary-600 text-white' : ''}"
                                        href="${paginationUrl}&page=${i}"
                                        >
                                        ${i}
                                    </a>
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

        <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    </body>
</html>
