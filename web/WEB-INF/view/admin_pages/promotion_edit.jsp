<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>
        <c:choose>
            <c:when test="${isEdit}">Chỉnh sửa Khuyến mãi</c:when>
            <c:otherwise>Thêm Khuyến mãi Mới</c:otherwise>
        </c:choose>
    </title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body { padding: 20px; background-color: #f8f9fa; }
        .form-container {
            max-width: 700px; margin: auto; padding: 30px;
            border: 1px solid #dee2e6; border-radius: 8px;
            background-color: #fff; box-shadow: 0 4px 8px rgba(0,0,0,0.05);
        }
        .form-container h2 { margin-bottom: 25px; }
    </style>
</head>
<body>
<div class="form-container">
    <h2 class="text-center">
        <c:choose>
            <c:when test="${isEdit}">Chỉnh sửa Khuyến mãi</c:when>
            <c:otherwise>Thêm Khuyến mãi Mới</c:otherwise>
        </c:choose>
    </h2>

    <c:if test="${not empty toastMessage}">
        <div class="alert alert-${toastType == 'error' ? 'danger' : 'success'}" role="alert">
            ${toastMessage}
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">
            ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/promotion" method="post">
        <input type="hidden" name="action" value="<c:out value='${isEdit ? "update" : "create"}'/>" />
        <c:if test="${isEdit}">
            <input type="hidden" name="id" value="${promotion.promotionId}" />
        </c:if>

        <div class="form-group">
            <label for="title"><strong>Tên Khuyến mãi</strong></label>
            <input type="text" class="form-control" id="title" name="title"
                   value="<c:out value='${promotion.title}'/>" required>
        </div>

        <div class="form-group">
            <label for="promotionCode"><strong>Mã Khuyến mãi</strong></label>
            <input type="text" class="form-control" id="promotionCode" name="promotionCode"
                   value="<c:out value='${promotion.promotionCode}'/>" required>
        </div>

        <div class="form-group">
            <label for="description"><strong>Mô tả</strong></label>
            <textarea class="form-control" id="description" name="description" rows="4" required><c:out value='${promotion.description}'/></textarea>
        </div>

        <div class="form-row">
            <div class="form-group col-md-6">
                <label for="discountType"><strong>Loại giảm giá</strong></label>
                <select class="form-control" id="discountType" name="discountType" required>
                    <option value="PERCENTAGE" <c:if test="${promotion.discountType eq 'PERCENTAGE'}">selected</c:if>>Phần trăm (%)</option>
                    <option value="FIXED" <c:if test="${promotion.discountType eq 'FIXED'}">selected</c:if>>Số tiền (VNĐ)</option>
                </select>
            </div>
            <div class="form-group col-md-6">
                <label for="discountValue"><strong>Giá trị Giảm giá</strong></label>
                <input type="number" class="form-control" id="discountValue" name="discountValue"
                       value="<c:out value='${promotion.discountValue}'/>" required min="0" step="0.01">
            </div>
        </div>

        <div class="form-row">
            <div class="form-group col-md-6">
                <label for="startDate"><strong>Ngày Bắt đầu</strong></label>
                <input type="date" class="form-control" id="startDate" name="startDate"
                       value="${not empty promotion.startDate ? promotion.startDate.toString().substring(0,10) : ''}" required>
            </div>
            <div class="form-group col-md-6">
                <label for="endDate"><strong>Ngày Kết thúc</strong></label>
                <input type="date" class="form-control" id="endDate" name="endDate"
                       value="${not empty promotion.endDate ? promotion.endDate.toString().substring(0,10) : ''}" required>
            </div>
        </div>

        <div class="form-group">
            <label for="status"><strong>Trạng thái</strong></label>
            <select class="form-control" id="status" name="status">
                <option value="SCHEDULED" <c:if test="${promotion.status eq 'SCHEDULED'}">selected</c:if>>Sắp diễn ra</option>
                <option value="ACTIVE" <c:if test="${promotion.status eq 'ACTIVE'}">selected</c:if>>Đang chạy</option>
                <option value="INACTIVE" <c:if test="${promotion.status eq 'INACTIVE'}">selected</c:if>>Ngừng áp dụng</option>
            </select>
        </div>

        <hr>
        <button type="submit" class="btn btn-primary btn-lg btn-block">
            <c:choose>
                <c:when test="${isEdit}">Cập nhật Khuyến mãi</c:when>
                <c:otherwise>Tạo Khuyến mãi</c:otherwise>
            </c:choose>
        </button>
        <a href="${pageContext.request.contextPath}/promotion/list" class="btn btn-secondary btn-lg btn-block mt-2">Hủy bỏ</a>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
