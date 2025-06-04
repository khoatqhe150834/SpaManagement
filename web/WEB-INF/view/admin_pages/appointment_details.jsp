<%-- 
    Document   : appointment_details.jsp
    Created on : Jun 3, 2025
    Author     : ADMIN
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="light">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Details</title>
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>

<body>
    <!-- Sidebar + Header -->
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <!-- Tiêu đề và nút quay lại -->
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <div>
                <h6 class="fw-semibold mb-0">Appointment Details (ID = ${appointmentId})</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/appointment?action=list"
                           class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Back to Appointment List
                        </a>
                    </li>
                </ul>
            </div>
            <!-- Form tìm kiếm theo Service Name -->
            <form action="${pageContext.request.contextPath}/appointment" method="GET" class="d-flex align-items-center gap-2">
                <input type="hidden" name="action" value="details" />
                <input type="hidden" name="id" value="${appointmentId}" />

                <div class="navbar-search">
                    <input type="text" class="bg-base h-40-px w-auto" name="serviceSearch"
                           placeholder="Search by service name"
                           value="${serviceSearch}" />
                    <iconify-icon icon="ion:search-outline" class="icon"></iconify-icon>
                </div>
                <button type="submit" class="btn btn-primary h-40-px radius-12">Search</button>
            </form>
        </div>

        <!-- Form cập nhật Status và Payment Status -->
        <div class="card mb-24 p-0 radius-12">
            <div class="card-body p-24">
                <h6 class="fw-semibold mb-16">Update Appointment Status</h6>
                <form action="${pageContext.request.contextPath}/appointment" method="POST"
                      class="d-flex align-items-end gap-3">
                    <input type="hidden" name="action" value="update" />
                    <input type="hidden" name="appointmentId" value="${appointmentId}" />

                    <div class="flex-grow-1">
                        <label class="form-label fw-semibold text-primary-light text-sm mb-8">Status</label>
                        <select name="status" class="form-select form-control h-40-px radius-8" required>
                            <option value="">Select Status</option>
                            <option value="PENDING_CONFIRMATION" ${currentStatus == 'PENDING_CONFIRMATION' ? 'selected' : ''}>PENDING_CONFIRMATION</option>
                            <option value="CONFIRMED" ${currentStatus == 'CONFIRMED' ? 'selected' : ''}>CONFIRMED</option>
                            <option value="IN_PROGRESS" ${currentStatus == 'IN_PROGRESS' ? 'selected' : ''}>IN_PROGRESS</option>
                            <option value="COMPLETED" ${currentStatus == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                            <option value="CANCELLED_BY_CUSTOMER" ${currentStatus == 'CANCELLED_BY_CUSTOMER' ? 'selected' : ''}>CANCELLED_BY_CUSTOMER</option>
                            <option value="CANCELLED_BY_SPA" ${currentStatus == 'CANCELLED_BY_SPA' ? 'selected' : ''}>CANCELLED_BY_SPA</option>
                            <option value="NO_SHOW" ${currentStatus == 'NO_SHOW' ? 'selected' : ''}>NO_SHOW</option>
                        </select>
                    </div>

                    <div class="flex-grow-1">
                        <label class="form-label fw-semibold text-primary-light text-sm mb-8">Payment Status</label>
                        <select name="paymentStatus" class="form-select form-control h-40-px radius-8" required>
                            <option value="">Select Payment Status</option>
                            <option value="UNPAID" ${currentPaymentStatus == 'UNPAID' ? 'selected' : ''}>UNPAID</option>
                            <option value="PARTIALLY_PAID" ${currentPaymentStatus == 'PARTIALLY_PAID' ? 'selected' : ''}>PARTIALLY_PAID</option>
                            <option value="PAID" ${currentPaymentStatus == 'PAID' ? 'selected' : ''}>PAID</option>
                            <option value="REFUNDED" ${currentPaymentStatus == 'REFUNDED' ? 'selected' : ''}>REFUNDED</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-success h-40-px px-20 radius-8">
                        Update Status
                    </button>
                </form>
            </div>
        </div>

        <!-- Bảng chi tiết services -->
        <div class="card h-100 p-0 radius-12">
            <div class="card-body p-24">
                <div class="table-responsive scroll-sm">
                    <table class="table bordered-table sm-table mb-0">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Service Name</th>
                                <th>Original Price</th>
                                <th>Discount</th>
                                <th>Final Price</th>
                                <th>Notes (Customer)</th>
                                <th>Notes (Staff)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="d" items="${details}" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td>${d.serviceName}</td>
                                    <td> <fmt:formatNumber value="${d.originalServicePrice}" type="number" maxFractionDigits="0" />đ</td>
                                    <td> <fmt:formatNumber value="${d.discountAmountApplied}" type="number" maxFractionDigits="0" />đ</td>
                                    <td> <fmt:formatNumber value="${d.finalPriceAfterDiscount}" type="number" maxFractionDigits="0" />đ</td>
                                    <td>${d.notesByCustomer}</td>
                                    <td>${d.notesByStaff}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty details}">
                                <tr>
                                    <td colspan="7" class="text-center">
                                        No service details found for this appointment.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Gọi JS chung -->
    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html>
