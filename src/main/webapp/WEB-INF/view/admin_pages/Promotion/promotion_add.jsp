<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Promotion - Admin Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
    <style>
        .form-label { font-weight: 500; }
        .error-text { width: 100%; margin-top: .25rem; font-size: 80%; color: #dc3545; }
        .is-invalid { border-color: #dc3545 !important; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
    
    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h4 class="fw-bold mb-0">Add New Promotion</h4>
            <a href="${pageContext.request.contextPath}/promotion/list" class="btn btn-outline-primary">
                <iconify-icon icon="solar:arrow-left-linear" class="icon text-lg me-8"></iconify-icon>
                Back to List
            </a>
        </div>
        
        <div class="card h-100 p-0 radius-12">
            <div class="card-header border-bottom bg-base py-16 px-24">
                <h5 class="card-title mb-0">Promotion Information</h5>
            </div>
            
            <div class="card-body p-24">
    <c:if test="${not empty error}">
                    <div class="alert alert-danger mb-24">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${error}
                    </div>
    </c:if>
                
    <form action="${pageContext.request.contextPath}/promotion" method="post" enctype="multipart/form-data" novalidate>
        <input type="hidden" name="action" value="create" />
                    
                    <div class="row">
                        <div class="col-md-6 mb-4">
            <label class="form-label" for="title">Promotion Title <span class="text-danger">*</span></label>
            <input type="text" class="form-control ${not empty errors.title ? 'is-invalid' : ''}" 
                   id="title" name="title" required maxlength="100" 
                   value="${not empty promotionInput.title ? promotionInput.title : ''}">
            <div class="error-text">${errors.title}</div>
        </div>
                        
                        <div class="col-md-6 mb-4">
            <label class="form-label" for="promotionCode">Promotion Code <span class="text-danger">*</span></label>
            <input type="text" class="form-control ${not empty errors.promotionCode ? 'is-invalid' : ''}" 
                   id="promotionCode" name="promotionCode" required maxlength="10" 
                   value="${not empty promotionInput.promotionCode ? promotionInput.promotionCode : ''}">
            <div class="error-text">${errors.promotionCode}</div>
        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <label class="form-label" for="discountType">Discount Type <span class="text-danger">*</span></label>
                            <select class="form-select ${not empty errors.discountType ? 'is-invalid' : ''}" id="discountType" name="discountType" required>
                                <option value="">-- Select --</option>
                                <option value="PERCENTAGE" ${promotionInput.discountType == 'PERCENTAGE' ? 'selected' : ''}>Percentage (%)</option>
                                <option value="FIXED" ${promotionInput.discountType == 'FIXED' ? 'selected' : ''}>Fixed Amount (VND)</option>
                            </select>
                            <div class="error-text">${errors.discountType}</div>
                        </div>
                        
                        <div class="col-md-6 mb-4">
                            <label class="form-label" for="discountValue">Discount Value <span class="text-danger">*</span></label>
                            <input type="number" class="form-control ${not empty errors.discountValue ? 'is-invalid' : ''}" 
                                   id="discountValue" name="discountValue" required min="1" step="0.01"
                                   value="${not empty promotionInput.discountValue ? promotionInput.discountValue : ''}">
                            <div class="error-text">${errors.discountValue}</div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <label class="form-label" for="startDate">Start Date <span class="text-danger">*</span></label>
                            <input type="date" class="form-control ${not empty errors.startDate ? 'is-invalid' : ''}" 
                                   id="startDate" name="startDate" required
                                   value="${promotionInput.startDate}">
                            <div class="error-text">${errors.startDate}</div>
                        </div>
                        
                        <div class="col-md-6 mb-4">
                            <label class="form-label" for="endDate">End Date <span class="text-danger">*</span></label>
                            <input type="date" class="form-control ${not empty errors.endDate ? 'is-invalid' : ''}" 
                                   id="endDate" name="endDate" required
                                   value="${promotionInput.endDate}">
                            <div class="error-text">${errors.endDate}</div>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label" for="status">Status</label>
                        <select class="form-select" id="status" name="status">
                            <option value="SCHEDULED" ${promotionInput.status == 'SCHEDULED' ? 'selected' : ''}>Scheduled</option>
                            <option value="ACTIVE" ${promotionInput.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                            <option value="INACTIVE" ${promotionInput.status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>
                    
                    <div class="mb-4">
            <label class="form-label" for="imageUrl">Promotion Image</label>
            <input type="file" class="form-control ${not empty errors.imageUrl ? 'is-invalid' : ''}" 
                   id="imageUrl" name="imageUrl" accept="image/*">
            <small class="form-text text-muted">Select an image for the promotion (optional)</small>
            <div class="error-text">${errors.imageUrl}</div>
            <c:if test="${not empty promotionInput.imageUrl}">
                <div class="mt-2">
                    <img src="${promotionInput.imageUrl}" alt="Current Promotion Image" 
                         class="img-thumbnail" style="max-width: 200px;">
                </div>
            </c:if>
        </div>
                    
                    <div class="mb-4">
            <label class="form-label" for="description">Description <span class="text-danger">*</span></label>
            <textarea class="form-control ${not empty errors.description ? 'is-invalid' : ''}" 
                      id="description" name="description" rows="3" required>${promotionInput.description}</textarea>
            <div class="error-text">${errors.description}</div>
        </div>
                    
                    <div class="d-flex gap-16 justify-content-end mt-24">
                        <button type="submit" class="btn btn-primary btn-sm px-20 py-11 radius-8">
                            <iconify-icon icon="solar:check-circle-bold" class="icon text-lg me-8"></iconify-icon>
                            Add Promotion
                        </button>
        </div>
                </form>
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
                alert('Please select a valid image file');
                this.value = '';
                return;
            }
            
            // Validate file size (max 10MB)
            if (file.size > 10 * 1024 * 1024) {
                alert('File size must be less than 10MB');
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
