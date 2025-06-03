<%-- 
    Document   : appointment_details.jsp
    Created on : Jun 3, 2025, 8:02:13 PM
    Author     : ADMIN
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="light">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Appointment Details</title>
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <!-- Gọi CSS chung -->
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
    </head>

    <body>
        <!-- Sidebar + Header -->
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>

        <div class="dashboard-main-body">
            <!-- Tiêu đề và nút quay lại -->
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <div>
                    <h6 class="fw-semibold mb-0">Appointment Details (ID = ${appointmentId})</h6>
                    <ul class="d-flex align-items-center gap-2">
                        <li class="fw-medium">
                            <a href="${pageContext.request.contextPath}/appointment?action=list" class="d-flex align-items-center gap-1 hover-text-primary">
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
                                        <td>
                                            <fmt:formatNumber value="${d.originalServicePrice}"
                                                              type="number" maxFractionDigits="0" />đ
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${d.discountAmountApplied}"
                                                              type="number" maxFractionDigits="0" />đ
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${d.finalPriceAfterDiscount}"
                                                              type="number" maxFractionDigits="0" />đ
                                        </td>
                                        <td>
                                            <c:out value="${d.notesByCustomer}" default="-" />
                                        </td>
                                        <td>
                                            <c:out value="${d.notesByStaff}" default="-" />
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty details}">
                                    <tr>
                                        <td colspan="7" class="text-center">No service details found for this appointment.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Gọi JS chung -->
        <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>
    </body>
</html>
