<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Appointment Details</title>
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp" />
    </head>

    <body>
        <jsp:include page="/WEB-INF/view/common/home/header.jsp" />

        <!-- inner page banner -->
        <div class="dlab-bnr-inr overlay-primary bg-pt" style="background-image:url(images/banner/bnr1.jpg);">
            <div class="container">
                <div class="dlab-bnr-inr-entry">
                    <h1 class="text-white">Appointment Details</h1>
                    <!-- Breadcrumb row -->
                    <div class="breadcrumb-row">
                        <ul class="list-inline">
                            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                            <li><a href="${pageContext.request.contextPath}/appointment">Appointments</a></li>
                            <li>Details</li>
                        </ul>
                    </div>
                    <!-- Breadcrumb row END -->
                </div>
            </div>
        </div>
        <!-- inner page banner END -->

        <div class="section-full content-inner">
            <div class="container-fluid py-5">
                <div class="row mb-4">
                    <div class="col">
                        <h2 class="mb-3">Appointment Details</h2>
                        <a href="${pageContext.request.contextPath}/appointment" class="btn btn-outline-primary mb-4">
                            <i class="bi bi-arrow-left"></i> Back to Appointments
                        </a>
                    </div>
                </div>

                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Services</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive w-100">
                                    <table class="table table-hover w-100">
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
                                                    <td><fmt:formatNumber value="${d.originalServicePrice}" type="number" maxFractionDigits="0" />đ</td>
                                                    <td><fmt:formatNumber value="${d.discountAmountApplied}" type="number" maxFractionDigits="0" />đ</td>
                                                    <td><fmt:formatNumber value="${d.finalPriceAfterDiscount}" type="number" maxFractionDigits="0" />đ</td>
                                                    <td><c:out value="${d.notesByCustomer}" default="-" /></td>
                                                    <td><c:out value="${d.notesByStaff}" default="-" /></td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty details}">
                                                <tr>
                                                    <td colspan="7" class="text-center">No services found for this appointment.</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/view/common/home/footer.jsp" />
        <jsp:include page="/WEB-INF/view/common/home/js.jsp" />
    </body>
</html>
