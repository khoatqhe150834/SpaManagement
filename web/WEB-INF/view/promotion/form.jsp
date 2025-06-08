<%-- 
    Document   : form
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
    <title>${empty promotion ? 'Add New Promotion' : 'Edit Promotion'} - Spa Management</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
    <style>
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .required {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">${empty promotion ? '➕ Thêm khuyến mãi mới' : '✏️ Chỉnh sửa khuyến mãi'}</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/promotion" class="d-flex align-items-center gap-1 hover-text-primary text-decoration-none">
                        🎁 Khuyến mãi
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium text-muted">${empty promotion ? 'Thêm mới' : 'Chỉnh sửa'}</li>
            </ul>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow">
                    <div class="card-header bg-white border-bottom">
                        <h5 class="card-title mb-0">${empty promotion ? 'Thông tin khuyến mãi mới' : 'Chỉnh sửa thông tin khuyến mãi'}</h5>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mx-3 mt-3">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            ${error}
                        </div>
                    </c:if>

                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/promotion" method="post" novalidate>
                            <input type="hidden" name="action" value="${empty promotion ? 'create' : 'update'}">
                            <c:if test="${not empty promotion}">
                                <input type="hidden" name="id" value="${promotion.promotionId}">
                            </c:if>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="title" class="form-label">🎁 Tiêu đề <span class="required">*</span></label>
                                        <input type="text" class="form-control" id="title" name="title" 
                                               value="<c:out value='${promotion.title}'/>" required>
                                        <div class="invalid-feedback">
                                            Vui lòng nhập tiêu đề khuyến mãi.
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="promotionCode" class="form-label">🎫 Mã khuyến mãi <span class="required">*</span></label>
                                        <input type="text" class="form-control" id="promotionCode" name="promotionCode" 
                                               value="<c:out value='${promotion.promotionCode}'/>" required style="text-transform: uppercase;">
                                        <div class="invalid-feedback">
                                            Vui lòng nhập mã khuyến mãi.
                                        </div>
                                        <small class="form-text text-muted">Mã sẽ tự động chuyển thành chữ hoa</small>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="discountType" class="form-label">💰 Loại giảm giá <span class="required">*</span></label>
                                        <select class="form-select" id="discountType" name="discountType" required>
                                            <option value="">Chọn loại giảm giá</option>
                                            <option value="percentage" ${promotion.discountType == 'percentage' ? 'selected' : ''}>📊 Phần trăm (%)</option>
                                            <option value="fixed" ${promotion.discountType == 'fixed' ? 'selected' : ''}>💵 Số tiền cố định</option>
                                        </select>
                                        <div class="invalid-feedback">
                                            Vui lòng chọn loại giảm giá.
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="discountValue" class="form-label">🏷️ Giá trị giảm <span class="required">*</span></label>
                                        <input type="number" class="form-control" id="discountValue" name="discountValue" 
                                               value="<c:out value='${promotion.discountValue}'/>" step="0.01" min="0" required>
                                        <div class="invalid-feedback">
                                            Vui lòng nhập giá trị giảm.
                                        </div>
                                        <small class="form-text text-muted" id="discountHelp">Nhập số từ 0-100 cho phần trăm</small>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="status" class="form-label">📊 Trạng thái <span class="required">*</span></label>
                                        <select class="form-select" id="status" name="status" required>
                                            <option value="">Chọn trạng thái</option>
                                            <option value="active" ${promotion.status == 'active' ? 'selected' : ''}>✅ Hoạt động</option>
                                            <option value="inactive" ${promotion.status == 'inactive' ? 'selected' : ''}>❌ Ngưng hoạt động</option>
                                        </select>
                                        <div class="invalid-feedback">
                                            Vui lòng chọn trạng thái.
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="startDate" class="form-label">📅 Ngày bắt đầu</label>
                                        <input type="datetime-local" class="form-control" id="startDate" name="startDate" 
                                               value="<fmt:formatDate value='${promotion.startDate}' pattern='yyyy-MM-dd HH:mm'/>">
                                        <small class="form-text text-muted">Để trống sẽ bắt đầu ngay</small>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="endDate" class="form-label">📅 Ngày kết thúc</label>
                                        <input type="datetime-local" class="form-control" id="endDate" name="endDate" 
                                               value="<fmt:formatDate value='${promotion.endDate}' pattern='yyyy-MM-dd HH:mm'/>">
                                        <small class="form-text text-muted">Để trống sẽ không có ngày hết hạn</small>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="totalUsageLimit" class="form-label">📊 Giới hạn tổng</label>
                                        <input type="number" class="form-control" id="totalUsageLimit" name="totalUsageLimit" 
                                               value="<c:out value='${promotion.totalUsageLimit}'/>" min="1">
                                        <small class="form-text text-muted">Để trống = không giới hạn</small>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="usageLimitPerCustomer" class="form-label">👤 Giới hạn mỗi khách</label>
                                        <input type="number" class="form-control" id="usageLimitPerCustomer" name="usageLimitPerCustomer" 
                                               value="<c:out value='${promotion.usageLimitPerCustomer}'/>" min="1">
                                        <small class="form-text text-muted">Để trống = không giới hạn</small>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="minimumAppointmentValue" class="form-label">💰 Giá trị đơn tối thiểu</label>
                                        <input type="number" class="form-control" id="minimumAppointmentValue" name="minimumAppointmentValue" 
                                               value="<c:out value='${promotion.minimumAppointmentValue}'/>" step="1000" min="0">
                                        <small class="form-text text-muted">VND - Để trống = không yêu cầu</small>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">📝 Mô tả</label>
                                <textarea class="form-control" id="description" name="description" rows="4" 
                                          placeholder="Nhập mô tả chi tiết về khuyến mãi..."><c:out value='${promotion.description}'/></textarea>
                                <small class="form-text text-muted">Mô tả sẽ hiển thị cho khách hàng</small>
                            </div>

                            <div class="mb-3">
                                <label for="termsAndConditions" class="form-label">📋 Điều khoản và điều kiện</label>
                                <textarea class="form-control" id="termsAndConditions" name="termsAndConditions" rows="3" 
                                          placeholder="Nhập các điều khoản và điều kiện áp dụng..."><c:out value='${promotion.termsAndConditions}'/></textarea>
                                <small class="form-text text-muted">Các quy định khi sử dụng khuyến mãi</small>
                            </div>

                            <div class="mb-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="isAutoApply" name="isAutoApply" 
                                           ${promotion.isAutoApply ? 'checked' : ''}>
                                    <label class="form-check-label" for="isAutoApply">
                                        🤖 Tự động áp dụng khuyến mãi
                                    </label>
                                    <small class="form-text text-muted d-block">Khuyến mãi sẽ tự động được áp dụng khi đủ điều kiện</small>
                                </div>
                            </div>

                            <!-- Form Actions -->
                            <div class="d-flex gap-3 justify-content-end mt-4 pt-3 border-top">
                                <a href="${pageContext.request.contextPath}/promotion" class="btn btn-outline-secondary btn-lg px-4">
                                    ← Quay lại
                                </a>
                                <button type="submit" class="btn btn-primary btn-lg px-4">
                                    ${empty promotion ? '✅ Tạo khuyến mãi' : '💾 Cập nhật khuyến mãi'}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>
    
    <script>
        // Auto uppercase promotion code
        document.getElementById('promotionCode').addEventListener('input', function() {
            this.value = this.value.toUpperCase();
        });

        // Update discount help text based on type
        document.getElementById('discountType').addEventListener('change', function() {
            const helpText = document.getElementById('discountHelp');
            const discountInput = document.getElementById('discountValue');
            
            if (this.value === 'percentage') {
                helpText.textContent = 'Nhập số từ 0-100 cho phần trăm';
                discountInput.setAttribute('max', '100');
                discountInput.setAttribute('step', '0.01');
            } else if (this.value === 'fixed') {
                helpText.textContent = 'Nhập số tiền giảm (VND)';
                discountInput.removeAttribute('max');
                discountInput.setAttribute('step', '1000');
            } else {
                helpText.textContent = 'Chọn loại giảm giá trước';
                discountInput.removeAttribute('max');
            }
        });

        // Trigger change event on page load to set correct help text
        document.getElementById('discountType').dispatchEvent(new Event('change'));

        // Form validation
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByTagName('form');
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();
    </script>
</body>
</html> 