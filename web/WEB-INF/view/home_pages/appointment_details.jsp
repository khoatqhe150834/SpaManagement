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

    <div class="container py-5">
        <div class="row mb-4">
            <div class="col">
                <a href="${pageContext.request.contextPath}/appointment" class="btn btn-outline-primary">
                    <i class="bi bi-arrow-left"></i> Back to Appointments
                </a>
            </div>
        </div>

        <div class="row">
            <!-- Appointment Summary -->
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Appointment Summary</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <div>
                                <span class="badge bg-${appointment.status == 'COMPLETED' ? 'success' : 
                                                  appointment.status == 'IN_PROGRESS' ? 'primary' : 
                                                  appointment.status == 'CONFIRMED' ? 'info' : 
                                                  appointment.status == 'PENDING_CONFIRMATION' ? 'warning' : 
                                                  'danger'}">
                                    ${appointment.status}
                                </span>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Payment Status</label>
                            <div>
                                <span class="badge bg-${appointment.paymentStatus == 'PAID' ? 'success' : 
                                                  appointment.paymentStatus == 'PARTIALLY_PAID' ? 'warning' : 
                                                  appointment.paymentStatus == 'REFUNDED' ? 'info' : 
                                                  'danger'}">
                                    ${appointment.paymentStatus}
                                </span>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Date & Time</label>
                            <div>
                                <fmt:formatDate value="${appointment.startTime}" pattern="dd/MM/yyyy HH:mm" />
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Therapist</label>
                            <div>${appointment.therapistName}</div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Booking Group</label>
                            <div>${appointment.bookingGroupName}</div>
                        </div>
                    </div>
                </div>

                <!-- Payment Summary -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Payment Summary</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-2">
                            <span>Original Price:</span>
                            <span><fmt:formatNumber value="${appointment.totalOriginalPrice}" type="number" maxFractionDigits="0" />đ</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Discount:</span>
                            <span>-<fmt:formatNumber value="${appointment.totalDiscount}" type="number" maxFractionDigits="0" />đ</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Points Used:</span>
                            <span>-<fmt:formatNumber value="${appointment.pointsUsed}" type="number" maxFractionDigits="0" />đ</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between fw-bold">
                            <span>Final Price:</span>
                            <span><fmt:formatNumber value="${appointment.totalFinalPrice}" type="number" maxFractionDigits="0" />đ</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Services List -->
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Services</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Service</th>
                                        <th>Original Price</th>
                                        <th>Discount</th>
                                        <th>Final Price</th>
                                        <th>Notes</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="service" items="${appointment.services}">
                                        <tr>
                                            <td>${service.serviceName}</td>
                                            <td><fmt:formatNumber value="${service.originalPrice}" type="number" maxFractionDigits="0" />đ</td>
                                            <td><fmt:formatNumber value="${service.discount}" type="number" maxFractionDigits="0" />đ</td>
                                            <td><fmt:formatNumber value="${service.finalPrice}" type="number" maxFractionDigits="0" />đ</td>
                                            <td>
                                                <c:if test="${not empty service.customerNote}">
                                                    <div class="text-muted small">Customer: ${service.customerNote}</div>
                                                </c:if>
                                                <c:if test="${not empty service.staffNote}">
                                                    <div class="text-muted small">Staff: ${service.staffNote}</div>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
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