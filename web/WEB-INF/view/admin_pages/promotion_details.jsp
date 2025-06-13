<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Promotion Details</title>
    <%-- Bạn có thể cần thay đổi đường dẫn CSS cho phù hợp với dự án của mình --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .card-body p { margin-bottom: 0.75rem; }
        .card-body strong { min-width: 200px; display: inline-block; }
        .terms { white-space: pre-wrap; background-color: #f8f9fa; padding: 1rem; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="card">
            <div class="card-header">
                <h3>Promotion Details</h3>
            </div>
            <div class="card-body">
                <c:if test="${not empty promotion}">
                    <div class="row">
                        <%-- Cột thông tin chính --%>
                        <div class="col-md-6">
                            <p><strong>Title:</strong> <c:out value="${promotion.title}"/></p>
                            <p><strong>Promotion Code:</strong> <span class="badge bg-secondary"><c:out value="${promotion.promotionCode}"/></span></p>
                            <p><strong>Status:</strong>
                                <c:choose>
                                    <c:when test="${promotion.status eq 'Active'}"><span class="badge bg-success">Active</span></c:when>
                                    <c:when test="${promotion.status eq 'Scheduled'}"><span class="badge bg-primary">Scheduled</span></c:when>
                                    <c:when test="${promotion.status eq 'Inactive'}"><span class="badge bg-secondary">Inactive</span></c:when>
                                    <c:otherwise><span class="badge bg-dark"><c:out value="${promotion.status}"/></span></c:otherwise>
                                </c:choose>
                            </p>
                             <p><strong>Description:</strong> <c:out value="${promotion.description}"/></p>
                            <p><strong>Image URL:</strong> <a href="${promotion.imageUrl}" target="_blank"><c:out value="${promotion.imageUrl}"/></a></p>
                        </div>

                        <%-- Cột thông tin giảm giá --%>
                        <div class="col-md-6">
                            <p><strong>Discount Type:</strong> <c:out value="${promotion.discountType}"/></p>
                            <p>
                                <strong>Discount Value:</strong> 
                                <c:choose>
                                    <c:when test="${promotion.discountType eq 'Percentage'}">
                                        <fmt:formatNumber value="${promotion.discountValue}"/>%
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:setLocale value="vi_VN"/>
                                        <fmt:formatNumber value="${promotion.discountValue}"/>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <p>
                                <strong>Minimum Value:</strong> 
                                <fmt:setLocale value="vi_VN"/>
                                <fmt:formatNumber value="${promotion.minimumAppointmentValue}"/>
                            </p>
                             <p><strong>Auto Apply:</strong> 
                                <c:if test="${promotion.isAutoApply}"><span class="badge bg-info">Yes</span></c:if>
                                <c:if test="${not promotion.isAutoApply}"><span class="badge bg-secondary">No</span></c:if>
                            </p>
                        </div>
                    </div>
                    <hr>
                     <div class="row">
                        <%-- Cột thời gian và giới hạn --%>
                        <div class="col-md-6">
                             <p>
                                <strong>Start Date:</strong> 
                                <%-- Đã bỏ pattern, dùng định dạng mặc định --%>
                                <fmt:formatDate value="${promotion.startDate}"/>
                             </p>
                             <p>
                                <strong>End Date:</strong> 
                                <%-- Đã bỏ pattern, dùng định dạng mặc định --%>
                                <fmt:formatDate value="${promotion.endDate}"/>
                            </p>
                             <p><strong>Usage Limit/Customer:</strong> <c:out value="${promotion.usageLimitPerCustomer}"/></p>
                             <p><strong>Total Usage Limit:</strong> <c:out value="${promotion.totalUsageLimit}"/></p>
                             <p><strong>Current Usage:</strong> <c:out value="${promotion.currentUsageCount}"/></p>
                        </div>
                        <%-- Cột phạm vi áp dụng --%>
                         <div class="col-md-6">
                             <p><strong>Applicable Scope:</strong> <c:out value="${promotion.applicableScope}"/></p>
                             <p><strong>Applicable Service IDs:</strong> <c:out value="${promotion.applicableServiceIdsJson}"/></p>
                              <p><strong>Created At:</strong> <fmt:formatDate value="${promotion.createdAt}"/></p>
                              <p><strong>Last Updated:</strong> <fmt:formatDate value="${promotion.updatedAt}"/></p>
                         </div>
                    </div>
                    <hr>
                    <div class="row">
                        <div class="col-12">
                             <p><strong>Terms and Conditions:</strong></p>
                             <div class="terms"><c:out value="${promotion.termsAndConditions}"/></div>
                        </div>
                    </div>

                </c:if>
                <c:if test="${empty promotion}">
                    <div class="alert alert-warning" role="alert">
                        Promotion not found.
                    </div>
                </c:if>
            </div>
            <div class="card-footer text-end">
                <a href="${pageContext.request.contextPath}/promotion/list" class="btn btn-primary">Back to List</a>
            </div>
        </div>
    </div>
</body>
</html>
