<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${isEdit}">Chỉnh sửa Khuyến mãi</c:when><c:otherwise>Thêm Khuyến mãi Mới</c:otherwise></c:choose></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
    <div class="container mt-5">
        <div class="card">
            <div class="card-header">
                <h3><c:choose><c:when test="${isEdit}">Chỉnh sửa Khuyến mãi</c:when><c:otherwise>Thêm Khuyến mãi Mới</c:otherwise></c:choose></h3>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty promotion}">
                        <div class="alert alert-danger text-center mb-3">Không tìm thấy khuyến mãi hoặc dữ liệu không hợp lệ.</div>
                        <a href="${pageContext.request.contextPath}/promotion/list" class="btn btn-secondary">Quay lại danh sách</a>
                    </c:when>
                    <c:otherwise>
                        <form action="${pageContext.request.contextPath}/promotion" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="<c:out value='${isEdit ? "update" : "create"}'/>" />
                            <c:if test="${isEdit}">
                                <input type="hidden" name="id" value="${promotion.promotionId}" />
                            </c:if>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="title" class="form-label">Tên Khuyến mãi</label>
                                        <input type="text" class="form-control" id="title" name="title" value="<c:out value='${promotion.title}'/>" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="promotionCode" class="form-label">Mã Khuyến mãi</label>
                                        <input type="text" class="form-control" id="promotionCode" name="promotionCode" value="<c:out value='${promotion.promotionCode}'/>" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="description" class="form-label">Mô tả</label>
                                        <textarea class="form-control" id="description" name="description" rows="3" required><c:out value='${promotion.description}'/></textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label for="discountType" class="form-label">Loại giảm giá</label>
                                        <select class="form-select" id="discountType" name="discountType" required>
                                            <option value="PERCENTAGE" <c:if test="${promotion.discountType eq 'PERCENTAGE'}">selected</c:if>>Phần trăm (%)</option>
                                            <option value="FIXED" <c:if test="${promotion.discountType eq 'FIXED'}">selected</c:if>>Số tiền (VNĐ)</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label for="discountValue" class="form-label">Giá trị Giảm giá</label>
                                        <input type="number" class="form-control" id="discountValue" name="discountValue" value="<c:out value='${promotion.discountValue}'/>" required min="0" step="0.01">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="startDate" class="form-label">Ngày Bắt đầu</label>
                                        <input type="date" class="form-control" id="startDate" name="startDate" value="${not empty promotion.startDate ? promotion.startDate.toString().substring(0,10) : ''}" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="endDate" class="form-label">Ngày Kết thúc</label>
                                        <input type="date" class="form-control" id="endDate" name="endDate" value="${not empty promotion.endDate ? promotion.endDate.toString().substring(0,10) : ''}" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="status" class="form-label">Trạng thái</label>
                                        <select class="form-select" id="status" name="status">
                                            <option value="SCHEDULED" <c:if test="${promotion.status eq 'SCHEDULED'}">selected</c:if>>Sắp diễn ra</option>
                                            <option value="ACTIVE" <c:if test="${promotion.status eq 'ACTIVE'}">selected</c:if>>Đang chạy</option>
                                            <option value="INACTIVE" <c:if test="${promotion.status eq 'INACTIVE'}">selected</c:if>>Ngừng áp dụng</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label for="minimumAppointmentValue" class="form-label">Giá trị đơn hàng tối thiểu</label>
                                        <input type="number" class="form-control" id="minimumAppointmentValue" name="minimumAppointmentValue" value="<c:out value='${promotion.minimumAppointmentValue}'/>" min="0" step="0.01">
                                    </div>
                                    <div class="mb-3">
                                        <label for="applicableScope" class="form-label">Phạm vi áp dụng</label>
                                        <input type="text" class="form-control" id="applicableScope" name="applicableScope" value="<c:out value='${promotion.applicableScope}'/>">
                                    </div>
                                    <div class="mb-3">
                                        <label for="applicableServiceIdsJson" class="form-label">Dịch vụ áp dụng (IDs, JSON)</label>
                                        <input type="text" class="form-control" id="applicableServiceIdsJson" name="applicableServiceIdsJson" value="<c:out value='${promotion.applicableServiceIdsJson}'/>">
                                    </div>
                                    <div class="mb-3">
                                        <label for="imageUrl" class="form-label">Ảnh Khuyến mãi</label>
                                        <input type="file" class="form-control" id="imageUrl" name="imageUrl" accept="image/*">
                                        <small class="form-text text-muted">Chọn ảnh cho khuyến mãi (tùy chọn)</small>
                                        <c:if test="${not empty promotion.imageUrl}">
                                            <div class="mt-2">
                                                <img src="${promotion.imageUrl}" alt="Ảnh Khuyến mãi hiện tại" 
                                                     class="img-thumbnail" style="max-width: 200px;">
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer text-end">
                                <a href="${pageContext.request.contextPath}/promotion/list" class="btn btn-secondary">Hủy</a>
                                <button type="submit" class="btn btn-primary">
                                    <c:choose>
                                        <c:when test="${isEdit}">Cập nhật Khuyến mãi</c:when>
                                        <c:otherwise>Tạo Khuyến mãi</c:otherwise>
                                    </c:choose>
                                </button>
                            </div>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    <script>
        // Image preview functionality
        document.getElementById('imageUrl').addEventListener('change', function(e) {
            const file = e.target.files[0];
            const previewContainer = document.getElementById('imagePreview');
            
            if (file) {
                // Validate file type
                if (!file.type.startsWith('image/')) {
                    alert('Vui lòng chọn file ảnh hợp lệ');
                    this.value = '';
                    return;
                }
                
                // Validate file size (max 10MB)
                if (file.size > 10 * 1024 * 1024) {
                    alert('Kích thước file phải nhỏ hơn 10MB');
                    this.value = '';
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(e) {
                    if (!previewContainer) {
                        // Create preview container if it doesn't exist
                        const container = document.createElement('div');
                        container.id = 'imagePreview';
                        container.className = 'mt-2';
                        container.innerHTML = '<img src="' + e.target.result + '" alt="Preview" class="img-thumbnail" style="max-width: 200px;">';
                        document.getElementById('imageUrl').parentNode.appendChild(container);
                    } else {
                        // Update existing preview
                        previewContainer.innerHTML = '<img src="' + e.target.result + '" alt="Preview" class="img-thumbnail" style="max-width: 200px;">';
                    }
                };
                reader.readAsDataURL(file);
            } else {
                // Remove preview if no file selected
                if (previewContainer) {
                    previewContainer.remove();
                }
            }
        });
    </script>
</body>
</html>
