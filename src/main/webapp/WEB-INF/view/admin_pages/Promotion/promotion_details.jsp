<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Promotion, java.time.format.DateTimeFormatter, java.text.NumberFormat, java.util.Locale" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết khuyến mãi</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
        
        <div class="container mt-5">
            <div class="card">
                <div class="card-header">
                    <h3>Chi tiết khuyến mãi</h3>
                </div>
                <div class="card-body">
                    <c:if test="${not empty promotion}">
                        <%-- Khởi tạo các đối tượng định dạng một lần để tái sử dụng --%>
                        <%
                            Promotion promo = (Promotion) request.getAttribute("promotion");
                            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy");
                            NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                        %>

                        <div class="row mb-4">
                            <div class="col-md-4 text-center">
                                <img src="${not empty promotion.imageUrl ? promotion.imageUrl : 'https://placehold.co/300x300/7C3AED/FFFFFF?text=PROMO'}" 
                                     alt="${promotion.title}"
                                     class="img-fluid rounded shadow-sm"
                                     style="max-width: 300px; height: auto;">
                            </div>
                            <div class="col-md-8">
                                <h4 class="mb-3">${promotion.title}</h4>
                                <p><strong>Mã khuyến mãi:</strong> <span class="badge bg-secondary">${promotion.promotionCode}</span></p>
                                <p><strong>Trạng thái:</strong>
                                    <c:choose>
                                        <c:when test="${promotion.status eq 'ACTIVE'}">
                                            <span class="badge bg-success">Đang áp dụng</span>
                                        </c:when>
                                        <c:when test="${promotion.status eq 'SCHEDULED'}">
                                            <span class="badge bg-primary">Sắp diễn ra</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">Không hoạt động</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <p><strong>Mô tả:</strong> ${promotion.description}</p>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Loại giảm giá:</strong> <c:out value="${promotion.discountType}"/></p>
                                <p><strong>Giá trị giảm:</strong> <c:out value="${promotion.discountValue}"/></p>
                                <p><strong>Giá trị đơn tối thiểu:</strong> <c:out value="${promotion.minimumAppointmentValue}"/></p>
                                <p><strong>Tự động áp dụng:</strong>
                                    <c:choose>
                                        <c:when test="${promotion.isAutoApply}"><span class="badge bg-info">Có</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">Không</span></c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Ngày bắt đầu:</strong> <c:out value="${promotion.startDate}"/></p>
                                <p><strong>Ngày kết thúc:</strong> <c:out value="${promotion.endDate}"/></p>
                                <p><strong>Số lần sử dụng/khách:</strong> <c:out value="${promotion.usageLimitPerCustomer}"/></p>
                                <p><strong>Tổng số lượt sử dụng:</strong> <c:out value="${promotion.totalUsageLimit}"/></p>
                                <p><strong>Lượt sử dụng hiện tại:</strong> <c:out value="${promotion.currentUsageCount}"/></p>
                            </div>

                            <div class="col-md-6">
                                <p><strong>Phạm vi áp dụng:</strong> <c:out value="${promotion.applicableScope}"/></p>
                                <p><strong>Dịch vụ áp dụng (ID):</strong> <c:out value="${promotion.applicableServiceIdsJson}"/></p>
                                <p><strong>Ngày tạo:</strong> <c:out value="${promotion.createdAt}"/></p>
                                <p><strong>Ngày cập nhật:</strong> <c:out value="${promotion.updatedAt}"/></p>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-12">
                                <p><strong>Điều kiện và điều khoản:</strong></p>
                                <div class="bg-light p-2 rounded"><c:out value="${promotion.termsAndConditions}"/></div>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${empty promotion}">
                        <div class="alert alert-warning" role="alert">
                            Không tìm thấy thông tin khuyến mãi.
                        </div>
                    </c:if>
                </div>
                <div class="card-footer">
                    <a href="${pageContext.request.contextPath}/promotion/list" class="btn btn-primary">Quay lại danh sách</a>
                </div>
            </div>
        </div>
                
        <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    </body>
</html>
