<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    <meta charset="UTF-8">
    <title>Cập Nhật Đánh Giá Dịch Vụ</title>
</head>
<body>
<jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
<jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
<div class="dashboard-main-body">
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
        <h6 class="fw-semibold mb-0">Cập Nhật Đánh Giá Dịch Vụ</h6>
        <a href="/admin/review" class="btn btn-outline-danger border border-danger-600 px-40 py-11 radius-8">Quay lại</a>
    </div>
    <div class="card h-100 p-0 radius-12">
        <div class="card-body p-24">
            <form action="/admin/review" method="post" class="border p-24 radius-12">
                <input type="hidden" name="action" value="edit" />
                <input type="hidden" name="review_id" value="${review.reviewId}" />
                <div class="mb-20">
                    <label class="form-label fw-semibold text-primary-light text-sm mb-8">Dịch vụ</label>
                    <select name="service_id" class="form-control radius-8" required>
                        <c:forEach var="s" items="${services}">
                            <option value="${s.serviceId}" ${s.serviceId == review.serviceId.serviceId ? 'selected' : ''}>${s.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-20">
                    <label class="form-label fw-semibold text-primary-light text-sm mb-8">Khách hàng</label>
                    <select name="customer_id" class="form-control radius-8" required>
                        <c:forEach var="c" items="${customers}">
                            <option value="${c.customerId}" ${c.customerId == review.customerId.customerId ? 'selected' : ''}>${c.fullName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-20">
                    <label class="form-label fw-semibold text-primary-light text-sm mb-8">Lịch hẹn</label>
                    <select name="appointment_id" class="form-control radius-8" required>
                        <c:forEach var="a" items="${appointments}">
                            <option value="${a.appointmentId}" ${a.appointmentId == review.appointmentId.appointmentId ? 'selected' : ''}>#${a.appointmentId} - ${a.startTime}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-20">
                    <label class="form-label fw-semibold text-primary-light text-sm mb-8">Rating</label>
                    <input type="number" name="rating" class="form-control radius-8" min="1" max="5" value="${review.rating}" required />
                </div>
                <div class="mb-20">
                    <label class="form-label fw-semibold text-primary-light text-sm mb-8">Tiêu đề</label>
                    <input type="text" name="title" class="form-control radius-8" maxlength="100" value="${review.title}" required />
                </div>
                <div class="mb-20">
                    <label class="form-label fw-semibold text-primary-light text-sm mb-8">Nội dung</label>
                    <textarea name="comment" class="form-control radius-8" rows="4" maxlength="500" required>${review.comment}</textarea>
                </div>
                <div class="d-flex align-items-center justify-content-end gap-3">
                    <a href="/admin/review" class="btn btn-outline-danger border border-danger-600 px-40 py-11 radius-8">Hủy</a>
                    <button type="submit" class="btn btn-primary border border-primary-600 text-md px-40 py-12 radius-8">Lưu</button>
                </div>
            </form>
        </div>
    </div>
</div>
<jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 