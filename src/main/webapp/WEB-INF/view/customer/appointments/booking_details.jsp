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
                            <li><a href="${pageContext.request.contextPath}/booking/list">My Appointments</a></li>
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
                        <a href="${pageContext.request.contextPath}/booking/list" class="btn btn-outline-primary mb-4">
                            <i class="bi bi-arrow-left"></i> Back to Appointments
                        </a>
                    </div>
                </div>

                <!-- Error Message -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty appointmentDetails}">
                    <c:set var="appointment" value="${appointmentDetails.appointment}" />
                    <c:set var="service" value="${appointmentDetails.service}" />
                    <c:set var="therapist" value="${appointmentDetails.therapist}" />
                    <c:set var="bookingGroup" value="${appointmentDetails.bookingGroup}" />

                    <div class="row">
                        <!-- Appointment Information -->
                        <div class="col-md-8">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-calendar-check"></i> Appointment Information
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label fw-bold">Appointment ID:</label>
                                                <p class="mb-0">#${appointment.appointmentId}</p>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label fw-bold">Service:</label>
                                                <p class="mb-0">${service.serviceName}</p>
                                                <small class="text-muted">${service.serviceDescription}</small>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label fw-bold">Therapist:</label>
                                                <p class="mb-0">${therapist.therapistName}</p>
                                                <small class="text-muted">Phone: ${therapist.therapistPhone}</small>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label fw-bold">Date:</label>
                                                <p class="mb-0">
                                                    <fmt:formatDate value="${appointmentDetails.startTimeDate}" pattern="EEEE, dd MMMM yyyy"/>
                                                </p>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label fw-bold">Time:</label>
                                                <p class="mb-0">
                                                    <fmt:formatDate value="${appointmentDetails.startTimeDate}" pattern="HH:mm"/> - 
                                                    <fmt:formatDate value="${appointmentDetails.endTimeDate}" pattern="HH:mm"/>
                                                </p>
                                                <c:set var="startTime" value="${appointmentDetails.startTimeDate}" />
                                                <c:set var="endTime" value="${appointmentDetails.endTimeDate}" />
                                                <c:set var="durationMillis" value="${endTime.time - startTime.time}" />
                                                <c:set var="durationMinutes" value="${durationMillis / (1000 * 60)}" />
                                                <small class="text-muted">Duration: ${durationMinutes.intValue()} minutes</small>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label fw-bold">Status:</label>
                                                <p class="mb-0">
                                                    <span class="badge bg-${appointment.status == 'SCHEDULED' ? 'primary' : 
                                                                          appointment.status == 'IN_PROGRESS' ? 'warning' : 
                                                                          appointment.status == 'COMPLETED' ? 'success' : 'danger'} text-white">
                                                        ${appointment.status}
                                                    </span>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty appointment.serviceNotes}">
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Notes:</label>
                                            <p class="mb-0">${appointment.serviceNotes}</p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Booking Group Information -->
                        <div class="col-md-4">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-receipt"></i> Booking Information
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Booking Group:</label>
                                        <p class="mb-0">#${bookingGroup.bookingGroupId}</p>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Booking Date:</label>
                                        <p class="mb-0">
                                            <fmt:formatDate value="${bookingGroup.bookingDate}" pattern="dd/MM/yyyy"/>
                                        </p>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Total Amount:</label>
                                        <p class="mb-0 text-primary fw-bold">
                                            <fmt:formatNumber value="${bookingGroup.totalAmount}" type="number" maxFractionDigits="0" />đ
                                        </p>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Service Price:</label>
                                        <p class="mb-0">
                                            <fmt:formatNumber value="${appointment.servicePrice}" type="number" maxFractionDigits="0" />đ
                                        </p>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Payment Status:</label>
                                        <p class="mb-0">
                                            <span class="badge bg-${bookingGroup.paymentStatus == 'PAID' ? 'success' : 'warning'} text-white">
                                                ${bookingGroup.paymentStatus}
                                            </span>
                                        </p>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">Booking Status:</label>
                                        <p class="mb-0">
                                            <span class="badge bg-${bookingGroup.bookingStatus == 'CONFIRMED' ? 'success' : 
                                                                  bookingGroup.bookingStatus == 'IN_PROGRESS' ? 'warning' : 
                                                                  bookingGroup.bookingStatus == 'COMPLETED' ? 'info' : 'danger'} text-white">
                                                ${bookingGroup.bookingStatus}
                                            </span>
                                        </p>
                                    </div>
                                    <c:if test="${not empty bookingGroup.specialNotes}">
                                        <div class="mb-3">
                                            <label class="form-label fw-bold">Special Notes:</label>
                                            <p class="mb-0">${bookingGroup.specialNotes}</p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="card">
                                <div class="card-body">
                                    <h6 class="card-title">Actions</h6>
                                    <div class="d-grid gap-2">
                                        <c:if test="${appointment.status == 'SCHEDULED'}">
                                            <button class="btn btn-warning btn-sm" onclick="rescheduleAppointment(${appointment.appointmentId})">
                                                <i class="fas fa-calendar-alt"></i> Reschedule
                                            </button>
                                            <button class="btn btn-danger btn-sm" onclick="cancelAppointment(${appointment.appointmentId})">
                                                <i class="fas fa-times"></i> Cancel
                                            </button>
                                        </c:if>
                                        <c:if test="${appointment.status == 'COMPLETED'}">
                                            <button class="btn btn-success btn-sm" onclick="bookAgain(${service.serviceId})">
                                                <i class="fas fa-plus"></i> Book Again
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <jsp:include page="/WEB-INF/view/common/home/footer.jsp" />
        <jsp:include page="/WEB-INF/view/common/home/js.jsp" />
        
        <script>
            function rescheduleAppointment(appointmentId) {
                if (confirm('Are you sure you want to reschedule this appointment?')) {
                    // TODO: Implement reschedule functionality
                    alert('Reschedule functionality will be implemented soon.');
                }
            }
            
            function cancelAppointment(appointmentId) {
                if (confirm('Are you sure you want to cancel this appointment? This action cannot be undone.')) {
                    // TODO: Implement cancel functionality
                    alert('Cancel functionality will be implemented soon.');
                }
            }
            
            function bookAgain(serviceId) {
                window.location.href = '${pageContext.request.contextPath}/booking?serviceId=' + serviceId;
            }
        </script>
    </body>
</html>
