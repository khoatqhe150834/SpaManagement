<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Promotion, java.time.format.DateTimeFormatter, java.text.NumberFormat, java.util.Locale" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Promotion Details</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
        
        <div class="container mt-5">
            <div class="card">
                <div class="card-header">
                    <h3>Promotion Details</h3>
                </div>
                <div class="card-body">
                    <c:if test="${not empty promotion}">
                        <%-- Khởi tạo các đối tượng định dạng một lần để tái sử dụng --%>
                        <%
                            Promotion promo = (Promotion) request.getAttribute("promotion");
                            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy");
                            NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                        %>

                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Title:</strong> <c:out value="${promotion.title}"/></p>
                                <p><strong>Promotion Code:</strong> <span class="badge bg-secondary"><c:out value="${promotion.promotionCode}"/></span></p>
                                <p><strong>Status:</strong>
                                    <c:choose>
                                        <c:when test="${promotion.status eq 'ACTIVE'}">
                                            <span class="badge bg-success">Active</span>
                                        </c:when>
                                        <c:when test="${promotion.status eq 'SCHEDULED'}">
                                            <span class="badge bg-primary">Scheduled</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">Inactive</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <p><strong>Description:</strong> <c:out value="${promotion.description}"/></p>
                                <p><strong>Image URL:</strong> <c:choose><c:when test="${empty promotion.imageUrl}">N/A</c:when><c:otherwise><a href="${promotion.imageUrl}" target="_blank"><c:out value="${promotion.imageUrl}"/></a></c:otherwise></c:choose></p>
                            </div>

                            <div class="col-md-6">
                                <p><strong>Discount Type:</strong> <c:out value="${promotion.discountType}"/></p>
                                <p><strong>Discount Value:</strong> <c:out value="${promotion.discountValue}"/></p>
                                <p><strong>Minimum Value:</strong> <c:out value="${promotion.minimumAppointmentValue}"/></p>
                                <p><strong>Auto Apply:</strong>
                                    <c:choose>
                                        <c:when test="${promotion.isAutoApply}"><span class="badge bg-info">Yes</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">No</span></c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Start Date:</strong> <c:out value="${promotion.startDate}"/></p>
                                <p><strong>End Date:</strong> <c:out value="${promotion.endDate}"/></p>
                                <p><strong>Usage Limit/Customer:</strong> <c:out value="${promotion.usageLimitPerCustomer}"/></p>
                                <p><strong>Total Usage Limit:</strong> <c:out value="${promotion.totalUsageLimit}"/></p>
                                <p><strong>Current Usage:</strong> <c:out value="${promotion.currentUsageCount}"/></p>
                            </div>

                            <div class="col-md-6">
                                <p><strong>Applicable Scope:</strong> <c:out value="${promotion.applicableScope}"/></p>
                                <p><strong>Applicable Service IDs:</strong> <c:out value="${promotion.applicableServiceIdsJson}"/></p>
                                <p><strong>Created At:</strong> <c:out value="${promotion.createdAt}"/></p>
                                <p><strong>Last Updated:</strong> <c:out value="${promotion.updatedAt}"/></p>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-12">
                                <p><strong>Terms and Conditions:</strong></p>
                                <div class="bg-light p-2 rounded"><c:out value="${promotion.termsAndConditions}"/></div>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${empty promotion}">
                        <div class="alert alert-warning" role="alert">
                            Promotion not found.
                        </div>
                    </c:if>
                </div>
                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/promotion/list" class="btn btn-primary">Back to List</a>
                </div>
            </div>
        </div>
                
        <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    </body>
</html>