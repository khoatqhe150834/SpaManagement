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

            <div class="card p-24 radius-16 mb-24">
                <h4>Service Type: ${stype.name}</h4>
                <p>${stype.description}</p>
                <p>
                    Status:
                    <c:choose>
                        <c:when test="${stype.active}">
                            <span class="text-success">Active</span>
                        </c:when>
                        <c:otherwise>
                            <span class="text-danger">Inactive</span>
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>

            <div class="card p-24 radius-16">
                <h4 class="mb-16">Services in This Type</h4>
                <c:if test="${not empty services}">
                    <c:forEach var="s" items="${services}">
                        <div class="border-bottom pb-16 mb-16">
                            <h5>Service ID: ${s.serviceId}</h5>
                            <ul>
                                <li><strong>Name:</strong> ${s.name}</li>
                                <li><strong>Description:</strong> ${s.description}</li>
                                <li><strong>Price:</strong> $<fmt:formatNumber value="${s.price}" type="number" minFractionDigits="2"/></li>
                                <li><strong>Duration:</strong> ${s.durationMinutes} mins</li>
                                <li><strong>Buffer Time:</strong> ${s.bufferTimeAfterMinutes} mins</li>
                                <li><strong>Status:</strong> 
                                    <c:choose>
                                        <c:when test="${s.isActive}">Active</c:when>
                                        <c:otherwise>Inactive</c:otherwise>
                                    </c:choose>
                                </li>
                                <li><strong>Online Booking:</strong> 
                                    <c:choose>
                                        <c:when test="${s.bookableOnline}">Yes</c:when>
                                        <c:otherwise>No</c:otherwise>
                                    </c:choose>
                                </li>
                                <li><strong>Consultation:</strong> 
                                    <c:choose>
                                        <c:when test="${s.requiresConsultation}">Yes</c:when>
                                        <c:otherwise>No</c:otherwise>
                                    </c:choose>
                                </li>
                                <li><strong>Rating:</strong> ${s.averageRating}</li>
                                <li><strong>Created:</strong> <fmt:formatDate value="${s.createdAt}" pattern="dd MMM yyyy HH:mm"/></li>
                                <li><strong>Updated:</strong> <fmt:formatDate value="${s.updatedAt}" pattern="dd MMM yyyy HH:mm"/></li>
                            </ul>
                        </div>
                    </c:forEach>
                </c:if>

                <c:if test="${empty services}">
                    <p class="text-muted">No services available for this type.</p>
                </c:if>
            </div>
        </div>

        <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    </body>
</html>
