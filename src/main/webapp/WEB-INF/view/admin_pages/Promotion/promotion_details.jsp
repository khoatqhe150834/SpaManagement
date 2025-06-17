<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Promotion, java.time.format.DateTimeFormatter, java.text.NumberFormat, java.util.Locale" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Promotion Details</title>

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            .card-body p {
                margin-bottom: 0.75rem;
            }
            .card-body strong {
                min-width: 200px;
                display: inline-block;
            }
            .terms {
                white-space: pre-wrap;
                background-color: #f8f9fa;
                padding: 1rem;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>
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
                                <p><strong>Title:</strong> <%= promo.getTitle() %></p>
                                <p><strong>Promotion Code:</strong> <span class="badge bg-secondary"><%= promo.getPromotionCode() %></span></p>
                                <p><strong>Status:</strong>
                                    <% if ("Active".equals(promo.getStatus())) { %>
                                        <span class="badge bg-success">Active</span>
                                    <% } else if ("Scheduled".equals(promo.getStatus())) { %>
                                        <span class="badge bg-primary">Scheduled</span>
                                    <% } else if ("Inactive".equals(promo.getStatus())) { %>
                                        <span class="badge bg-secondary">Inactive</span>
                                    <% } else { %>
                                        <span class="badge bg-dark"><%= promo.getStatus() %></span>
                                    <% } %>
                                </p>
                                <p><strong>Description:</strong> <%= promo.getDescription() %></p>
                                <p><strong>Image URL:</strong> <a href="<%= promo.getImageUrl() %>" target="_blank"><%= promo.getImageUrl() %></a></p>
                            </div>

                            <div class="col-md-6">
                                <p><strong>Discount Type:</strong> <%= promo.getDiscountType() %></p>
                                <p>
                                    <strong>Discount Value:</strong>
                                    <% if ("Percentage".equals(promo.getDiscountType())) { %>
                                        <%= promo.getDiscountValue() %>%
                                    <% } else { %>
                                        <%= currencyFormatter.format(promo.getDiscountValue()) %>
                                    <% } %>
                                </p>
                                <p>
                                    <strong>Minimum Value:</strong>
                                    <% if (promo.getMinimumAppointmentValue() != null) { %>
                                        <%= currencyFormatter.format(promo.getMinimumAppointmentValue()) %>
                                    <% } %>
                                </p>
                                <p><strong>Auto Apply:</strong>
                                    <% if (promo.getIsAutoApply() != null && promo.getIsAutoApply()) { %>
                                        <span class="badge bg-info">Yes</span>
                                    <% } else { %>
                                        <span class="badge bg-secondary">No</span>
                                    <% } %>
                                </p>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-md-6">
                                <p>
                                    <strong>Start Date:</strong>
                                    <%= promo.getStartDate() != null ? dtf.format(promo.getStartDate()) : "" %>
                                </p>
                                <p>
                                    <strong>End Date:</strong>
                                    <%= promo.getEndDate() != null ? dtf.format(promo.getEndDate()) : "" %>
                                </p>
                                <p><strong>Usage Limit/Customer:</strong> <%= promo.getUsageLimitPerCustomer() != null ? promo.getUsageLimitPerCustomer() : "N/A" %></p>
                                <p><strong>Total Usage Limit:</strong> <%= promo.getTotalUsageLimit() != null ? promo.getTotalUsageLimit() : "N/A" %></p>
                                <p><strong>Current Usage:</strong> <%= promo.getCurrentUsageCount() %></p>
                            </div>

                            <div class="col-md-6">
                                <p><strong>Applicable Scope:</strong> <%= promo.getApplicableScope() %></p>
                                <p><strong>Applicable Service IDs:</strong> <%= promo.getApplicableServiceIdsJson() %></p>
                                <p>
                                    <strong>Created At:</strong>
                                    <%= promo.getCreatedAt() != null ? dtf.format(promo.getCreatedAt()) : "" %>
                                </p>
                                <p>
                                    <strong>Last Updated:</strong>
                                    <%= promo.getUpdatedAt() != null ? dtf.format(promo.getUpdatedAt()) : "" %>
                                </p>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-12">
                                <p><strong>Terms and Conditions:</strong></p>
                                <div class="terms"><%= promo.getTermsAndConditions() %></div>
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
                 <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>
    </body>
</html>