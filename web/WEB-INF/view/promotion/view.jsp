<%-- 
    Document   : view
    Created on : Dec 25, 2024
    Author     : Admin
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Promotion Details - Spa Management</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
    <style>
        .update-btn {
            position: relative;
            overflow: hidden;
        }
        .update-btn .spinner {
            display: none;
        }
        .update-btn.loading .spinner {
            display: inline-block;
        }
        .update-btn.loading .icon {
            display: none;
        }
        .data-field {
            transition: all 0.3s ease;
        }
        .data-field.updated {
            background: #d4edda;
            border-radius: 8px;
            padding: 8px;
            animation: highlight 1s ease;
        }
        @keyframes highlight {
            0% { background: #28a745; }
            100% { background: #d4edda; }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">🔍 Chi tiết khuyến mãi</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/promotion" class="d-flex align-items-center gap-1 hover-text-primary">
                        🎁 Khuyến mãi
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Chi tiết</li>
            </ul>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card h-100 p-0 radius-12">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">📋 Thông tin khuyến mãi</h6>
                    </div>

                    <div class="card-body p-24" id="promotionDataContainer">
                        <c:if test="${not empty promotion}">
                            <div class="row">
                                <!-- Promotion Icon & Basic Info -->
                                <div class="col-lg-4">
                                    <div class="text-center mb-24">
                                        <div style="width: 120px; height: 120px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px;">
                                            <span style="color: white; font-size: 48px;">🎁</span>
                                        </div>
                                        <h5 class="fw-semibold text-primary-light mb-8 data-field" data-field="title">
                                            <c:out value="${promotion.title}" default="Unknown"/>
                                        </h5>
                                        <span class="badge bg-${promotion.status == 'active' ? 'success-focus text-success-600' : 'neutral-200 text-neutral-600'} px-16 py-8 radius-8 fw-medium data-field" data-field="status">
                                            ${promotion.status == 'active' ? '✅ Đang hoạt động' : '❌ Ngưng hoạt động'}
                                        </span>
                                    </div>
                                </div>

                                <!-- Promotion Details -->
                                <div class="col-lg-8">
                                    <div class="row g-20">
                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">🆔 Mã khuyến mãi</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="promotionId">#<c:out value="${promotion.promotionId}" default="N/A"/></p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">🎫 Mã code</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="promotionCode">
                                                    <code class="bg-light px-2 py-1 rounded"><c:out value="${promotion.promotionCode}" default="N/A"/></code>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">💰 Loại giảm giá</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="discountType">
                                                    <c:choose>
                                                        <c:when test="${promotion.discountType == 'percentage'}">📊 Phần trăm (%)</c:when>
                                                        <c:when test="${promotion.discountType == 'fixed'}">💵 Số tiền cố định</c:when>
                                                        <c:otherwise><c:out value="${promotion.discountType}" default="N/A"/></c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">🏷️ Giá trị giảm</label>
                                                <p class="fw-medium text-warning-600 data-field" data-field="discountValue">
                                                    <c:choose>
                                                        <c:when test="${promotion.discountType == 'percentage'}">
                                                            🎯 <c:out value="${promotion.discountValue}" default="0"/>%
                                                        </c:when>
                                                        <c:otherwise>
                                                            💰 <fmt:formatNumber value="${promotion.discountValue}" pattern="#,##0"/> VND
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">📅 Ngày bắt đầu</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="startDate">
                                                    <c:choose>
                                                        <c:when test="${not empty promotion.startDate}">
                                                            <fmt:parseDate value="${promotion.startDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedStartDate" type="both"/>
                                                            <fmt:formatDate value="${parsedStartDate}" pattern="dd/MM/yyyy 'lúc' HH:mm"/>
                                                        </c:when>
                                                        <c:otherwise>Chưa xác định</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">📅 Ngày kết thúc</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="endDate">
                                                    <c:choose>
                                                        <c:when test="${not empty promotion.endDate}">
                                                            <fmt:parseDate value="${promotion.endDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedEndDate" type="both"/>
                                                            <fmt:formatDate value="${parsedEndDate}" pattern="dd/MM/yyyy 'lúc' HH:mm"/>
                                                        </c:when>
                                                        <c:otherwise>Chưa xác định</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">📊 Giới hạn sử dụng</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="totalUsageLimit">
                                                    <c:choose>
                                                        <c:when test="${not empty promotion.totalUsageLimit}">
                                                            🎯 <c:out value="${promotion.totalUsageLimit}" default="0"/> lần
                                                        </c:when>
                                                        <c:otherwise>♾️ Không giới hạn</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">📈 Đã sử dụng</label>
                                                <p class="fw-medium text-info-600 data-field" data-field="currentUsageCount">
                                                    📊 <c:out value="${promotion.currentUsageCount}" default="0"/> lần
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">💳 Giới hạn mỗi khách</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="usageLimitPerCustomer">
                                                    <c:choose>
                                                        <c:when test="${not empty promotion.usageLimitPerCustomer}">
                                                            👤 <c:out value="${promotion.usageLimitPerCustomer}" default="0"/> lần/khách
                                                        </c:when>
                                                        <c:otherwise>♾️ Không giới hạn</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">💰 Giá trị đơn tối thiểu</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="minimumAppointmentValue">
                                                    <c:choose>
                                                        <c:when test="${not empty promotion.minimumAppointmentValue}">
                                                            💵 <fmt:formatNumber value="${promotion.minimumAppointmentValue}" pattern="#,##0"/> VND
                                                        </c:when>
                                                        <c:otherwise>🆓 Không yêu cầu</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-12">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">📝 Mô tả</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="description">
                                                    <c:out value="${promotion.description}" default="Chưa có mô tả"/>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">📅 Ngày tạo</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="createdAt">
                                                    <c:choose>
                                                        <c:when test="${not empty promotion.createdAt}">
                                                            <fmt:parseDate value="${promotion.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedCreatedAt" type="both"/>
                                                            <fmt:formatDate value="${parsedCreatedAt}" pattern="dd/MM/yyyy 'lúc' HH:mm"/>
                                                        </c:when>
                                                        <c:otherwise>Chưa xác định</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="col-sm-6">
                                            <div class="mb-16">
                                                <label class="form-label fw-semibold text-primary-light text-sm mb-8">🔄 Cập nhật lần cuối</label>
                                                <p class="fw-medium text-secondary-light data-field" data-field="updatedAt">
                                                    <c:choose>
                                                        <c:when test="${not empty promotion.updatedAt}">
                                                            <fmt:parseDate value="${promotion.updatedAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedUpdatedAt" type="both"/>
                                                            <fmt:formatDate value="${parsedUpdatedAt}" pattern="dd/MM/yyyy 'lúc' HH:mm"/>
                                                        </c:when>
                                                        <c:otherwise>Chưa cập nhật</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="d-flex gap-16 justify-content-end mt-24 pt-24 border-top">
                                <a href="${pageContext.request.contextPath}/promotion" 
                                   class="btn btn-outline-primary btn-sm px-20 py-11 radius-8">
                                    ← Quay lại
                                </a>
                                <a href="${pageContext.request.contextPath}/promotion/edit?id=${promotion.promotionId}" 
                                   class="btn btn-primary btn-sm px-20 py-11 radius-8">
                                    ✏️ Chỉnh sửa
                                </a>
                            </div>

                        </c:if>

                        <c:if test="${empty promotion}">
                            <div class="text-center py-5">
                                <div style="font-size: 64px;">🎁</div>
                                <h6 class="mt-3">Không tìm thấy khuyến mãi</h6>
                                <p class="text-muted">Khuyến mãi này có thể đã bị xóa hoặc không tồn tại</p>
                                <a href="${pageContext.request.contextPath}/promotion" class="btn btn-primary">
                                    ← Quay lại danh sách
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>
</body>
</html> 