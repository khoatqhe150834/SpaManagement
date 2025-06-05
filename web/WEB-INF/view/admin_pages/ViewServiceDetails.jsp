<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
    <head>
        <meta charset="UTF-8">
        <title>Service Type Details</title>
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    </head>
    <body>

        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h3 class="fw-bold mb-0">Service Type Details</h3>
                <ul class="d-flex align-items-center gap-2">
                    <li><a href="servicetype" class="text-primary">Back to List</a></li>
                    <li>-</li>
                    <li>Service Type Details</li>
                </ul>
            </div>

            <!-- Service Type Card -->
            <div class="card p-24 radius-16 mb-24 shadow d-flex align-items-center justify-content-between">
                <div>
                    <h4 class="fw-bold text-primary mb-12">Service Type: ${stype.name}</h4>
                    <p class="mb-2">${stype.description}</p>
                    <p>Status:
                        <span class="badge ${stype.active ? 'bg-success' : 'bg-secondary'}">
                            ${stype.active ? 'Active' : 'Inactive'}
                        </span>
                    </p>
                </div>
                <a href="service?service=pre-insert&stypeId=${stype.serviceTypeId}" 
                   class="btn btn-sm btn-primary px-3 py-2 mt-2 mt-md-0">
                    <i class="bi bi-plus-circle me-1"></i> Add Service
                </a>
            </div>

            <!-- Services in This Type -->
            <div class="card p-24 radius-16 shadow">
                <h4 class="mb-16">Services in This Type</h4>

                <c:if test="${not empty services}">
                    <c:forEach var="s" items="${services}">
                        <div class="card mb-16 p-16 radius-12 shadow-sm">
                            <div class="row">
                                <!-- Info -->
                                <div class="col-md-9 col-12">
                                    <h5 class="fw-semibold text-dark mb-12">Service ID: ${s.serviceId} - ${s.name}</h5>
                                    <ul class="mb-2">
                                        <li><strong>Description:</strong> ${s.description}</li>
                                        <li><strong>Price:</strong> $<fmt:formatNumber value="${s.price}" type="number" minFractionDigits="2"/></li>
                                        <li><strong>Duration:</strong> ${s.durationMinutes} mins</li>
                                        <li><strong>Buffer Time:</strong> ${s.bufferTimeAfterMinutes} mins</li>
                                        <li><strong>Status:</strong> 
                                            <span class="badge ${s.isActive ? 'bg-success' : 'bg-secondary'}">
                                                ${s.isActive ? 'Active' : 'Inactive'}
                                            </span>
                                        </li>
                                        <li><strong>Online Booking:</strong> ${s.bookableOnline ? 'Yes' : 'No'}</li>
                                        <li><strong>Consultation:</strong> ${s.requiresConsultation ? 'Yes' : 'No'}</li>
                                        <li><strong>Rating:</strong> ${s.averageRating}</li>
                                        <li><strong>Created:</strong> <fmt:formatDate value="${s.createdAt}" pattern="dd MMM yyyy HH:mm"/></li>
                                        <li><strong>Updated:</strong> <fmt:formatDate value="${s.updatedAt}" pattern="dd MMM yyyy HH:mm"/></li>
                                    </ul>
                                </div>

                                <!-- Image & buttons under image -->
                                <div class="col-md-3 col-12 d-flex flex-column align-items-center">
                                    <img src="${s.imageUrl}" alt="Service Image" class="img-thumbnail mb-3" style="max-width: 100%; height: auto;" />

                                    <!-- Buttons block at the bottom -->
                                    <div class="d-flex justify-content-center gap-2 w-100 mt-auto">
                                        <a href="service?service=pre-update&id=${s.serviceId}" class="btn btn-outline-primary btn-sm w-50">Update</a>
                                        <a href="service?service=deactivate&id=${s.serviceId}"
                                           class="btn btn-outline-danger btn-sm w-50"
                                           onclick="return confirm('Are you sure you want to deactivate this service?');">
                                            Deactivate
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                </c:if>

                <c:if test="${empty services}">
                    <p class="text-muted">No services found in this type.</p>
                </c:if>
            </div>
        </div>

        <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    </body>
</html>
