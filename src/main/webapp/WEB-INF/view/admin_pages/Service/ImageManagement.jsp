<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">

<head>
    <meta charset="UTF-8">
    <title>Image Management</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    <style>
        .service-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 20px;
            background: white;
        }
        
        .service-header {
            background: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #ddd;
            display: flex;
            justify-content: between;
            align-items: center;
        }
        
        .service-images {
            padding: 20px;
        }
        
        .image-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .image-item {
            position: relative;
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
            background: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .image-item img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }
        
        .image-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.7);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .image-item:hover .image-overlay {
            opacity: 1;
        }
        
        .image-actions {
            position: absolute;
            top: 8px;
            right: 8px;
            display: flex;
            gap: 5px;
        }
        
        .btn-icon {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: none;
            color: white;
            font-size: 14px;
        }
        
        .primary-badge {
            position: absolute;
            top: 8px;
            left: 8px;
            background: #28a745;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 10px;
            font-weight: bold;
        }
        
        .image-info {
            padding: 10px;
            font-size: 12px;
            color: #666;
        }
        
        .no-images {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        .service-stats {
            display: flex;
            gap: 20px;
            font-size: 14px;
            color: #666;
        }
        
        .quick-actions {
            display: flex;
            gap: 10px;
        }
        
        .filter-section {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
        }
    </style>
</head>

<body>
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Image Management</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/manager/service" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Service Management
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Image Management</li>
            </ul>
        </div>

        <!-- Filter and Actions Section -->
        <div class="filter-section">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <div class="d-flex align-items-center gap-3">
                        <label for="serviceFilter" class="form-label mb-0">Filter by Service:</label>
                        <select id="serviceFilter" class="form-select" style="width: auto;" onchange="filterByService()">
                            <option value="">All Services</option>
                            <c:forEach var="serviceItem" items="${services}">
                                <option value="${serviceItem.serviceId}" 
                                        <c:if test="${service != null && service.serviceId == serviceItem.serviceId}">selected</c:if>>
                                    ${serviceItem.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="col-md-6 text-end">
                    <div class="quick-actions">
                        <a href="${pageContext.request.contextPath}/manager/service-images/single-upload?serviceId=${service != null ? service.serviceId : ''}" 
                           class="btn btn-primary btn-sm" 
                           <c:if test="${service == null}">onclick="return selectServiceFirst()"</c:if>>
                            <iconify-icon icon="solar:upload-outline" class="me-1"></iconify-icon>
                            Single Upload
                        </a>
                        <a href="${pageContext.request.contextPath}/manager/service-images/batch-upload" 
                           class="btn btn-outline-primary btn-sm">
                            <iconify-icon icon="solar:cloud-upload-outline" class="me-1"></iconify-icon>
                            Batch Upload
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Service Images Display -->
        <c:choose>
            <c:when test="${service != null}">
                <!-- Single Service View -->
                <div class="service-card">
                    <div class="service-header">
                        <div>
                            <h6 class="fw-semibold mb-1">${service.name}</h6>
                            <div class="service-stats">
                                <span><iconify-icon icon="solar:gallery-outline" class="me-1"></iconify-icon>${images.size()} Images</span>
                                <c:set var="primaryCount" value="0"/>
                                <c:forEach var="img" items="${images}">
                                    <c:if test="${img.isPrimary}">
                                        <c:set var="primaryCount" value="${primaryCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                <span><iconify-icon icon="solar:star-outline" class="me-1"></iconify-icon>${primaryCount} Primary</span>
                            </div>
                        </div>
                        <div class="quick-actions">
                            <a href="${pageContext.request.contextPath}/manager/service-images/single-upload?serviceId=${service.serviceId}" 
                               class="btn btn-primary btn-sm">
                                <iconify-icon icon="solar:plus-outline" class="me-1"></iconify-icon>
                                Add Images
                            </a>
                        </div>
                    </div>
                    <div class="service-images">
                        <c:choose>
                            <c:when test="${empty images}">
                                <div class="no-images">
                                    <iconify-icon icon="solar:gallery-outline" class="text-6xl text-muted mb-3"></iconify-icon>
                                    <p class="text-muted">No images uploaded for this service</p>
                                    <a href="${pageContext.request.contextPath}/manager/service-images/single-upload?serviceId=${service.serviceId}" 
                                       class="btn btn-primary">
                                        Upload Images
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="image-grid">
                                    <c:forEach var="image" items="${images}">
                                        <div class="image-item" data-image-id="${image.imageId}">
                                            <c:if test="${image.isPrimary}">
                                                <div class="primary-badge">Primary</div>
                                            </c:if>
                                            
                                            <div class="image-actions">
                                                <c:if test="${!image.isPrimary}">
                                                    <button type="button" class="btn-icon bg-success" 
                                                            onclick="setPrimaryImage(${image.imageId}, ${service.serviceId})"
                                                            title="Set as Primary">
                                                        <iconify-icon icon="solar:star-outline"></iconify-icon>
                                                    </button>
                                                </c:if>
                                                <button type="button" class="btn-icon bg-danger" 
                                                        onclick="deleteImage(${image.imageId})"
                                                        title="Delete Image">
                                                    <iconify-icon icon="solar:trash-bin-minimalistic-outline"></iconify-icon>
                                                </button>
                                            </div>
                                            
                                            <img src="${pageContext.request.contextPath}${image.url}" 
                                                 alt="${image.altText}" 
                                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/no-image.png'"
                                                 onclick="viewImageFullSize('${pageContext.request.contextPath}${image.url}')">
                                            
                                            <div class="image-overlay">
                                                <button type="button" class="btn btn-light btn-sm" 
                                                        onclick="viewImageFullSize('${pageContext.request.contextPath}${image.url}')">
                                                    <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                                </button>
                                            </div>
                                            
                                            <div class="image-info">
                                                <div class="d-flex justify-content-between">
                                                    <small>
                                                        <c:if test="${image.fileSize != null}">
                                                            <fmt:formatNumber value="${image.fileSize / 1024}" maxFractionDigits="1" />KB
                                                        </c:if>
                                                    </small>
                                                    <small>Order: ${image.sortOrder}</small>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- All Services View -->
                <c:choose>
                    <c:when test="${empty services}">
                        <div class="text-center py-5">
                            <iconify-icon icon="solar:service-outline" class="text-6xl text-muted mb-3"></iconify-icon>
                            <p class="text-muted">No services found</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="serviceItem" items="${services}">
                            <c:set var="serviceImages" value="${serviceImageDAO.findByServiceId(serviceItem.serviceId)}"/>
                            <div class="service-card">
                                <div class="service-header">
                                    <div>
                                        <h6 class="fw-semibold mb-1">${serviceItem.name}</h6>
                                        <div class="service-stats">
                                            <span><iconify-icon icon="solar:gallery-outline" class="me-1"></iconify-icon>
                                                ${serviceImages.size()} Images</span>
                                        </div>
                                    </div>
                                    <div class="quick-actions">
                                        <a href="${pageContext.request.contextPath}/manager/service-images/manage?serviceId=${serviceItem.serviceId}" 
                                           class="btn btn-outline-primary btn-sm">
                                            <iconify-icon icon="solar:settings-outline" class="me-1"></iconify-icon>
                                            Manage
                                        </a>
                                        <a href="${pageContext.request.contextPath}/manager/service-images/single-upload?serviceId=${serviceItem.serviceId}" 
                                           class="btn btn-primary btn-sm">
                                            <iconify-icon icon="solar:plus-outline" class="me-1"></iconify-icon>
                                            Add Images
                                        </a>
                                    </div>
                                </div>
                                <c:if test="${not empty serviceImages}">
                                    <div class="service-images">
                                        <div class="image-grid">
                                            <c:forEach var="image" items="${serviceImages}" end="5">
                                                <div class="image-item">
                                                    <c:if test="${image.isPrimary}">
                                                        <div class="primary-badge">Primary</div>
                                                    </c:if>
                                                    
                                                    <img src="${pageContext.request.contextPath}${image.url}" 
                                                         alt="${image.altText}" 
                                                         onerror="this.src='${pageContext.request.contextPath}/assets/images/no-image.png'"
                                                         onclick="viewImageFullSize('${pageContext.request.contextPath}${image.url}')">
                                                    
                                                    <div class="image-overlay">
                                                        <button type="button" class="btn btn-light btn-sm" 
                                                                onclick="viewImageFullSize('${pageContext.request.contextPath}${image.url}')">
                                                            <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                                        </button>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                            <c:if test="${serviceImages.size() > 6}">
                                                <div class="image-item d-flex align-items-center justify-content-center" 
                                                     style="background: #f8f9fa; cursor: pointer;"
                                                     onclick="location.href='${pageContext.request.contextPath}/manager/service-images/manage?serviceId=${serviceItem.serviceId}'">
                                                    <div class="text-center">
                                                        <iconify-icon icon="solar:gallery-outline" class="text-3xl text-muted mb-2"></iconify-icon>
                                                        <div class="text-muted">+${serviceImages.size() - 6} more</div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Image Modal -->
    <div class="modal fade" id="imageModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Image Preview</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center">
                    <img id="modalImage" src="" alt="" class="img-fluid">
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    
    <script>
        const contextPath = '${pageContext.request.contextPath}';
        
        // Filter by service
        function filterByService() {
            const serviceId = document.getElementById('serviceFilter').value;
            if (serviceId) {
                window.location.href = contextPath + '/manager/service-images/manage?serviceId=' + serviceId;
            } else {
                window.location.href = contextPath + '/manager/service-images/manage';
            }
        }
        
        // Select service first alert
        function selectServiceFirst() {
            alert('Please select a service first from the filter dropdown.');
            return false;
        }
        
        // Set primary image
        function setPrimaryImage(imageId, serviceId) {
            fetch(contextPath + '/manager/service-images/set-primary', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `imageId=${imageId}&serviceId=${serviceId}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert('Failed to set primary image: ' + data.error);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error setting primary image');
            });
        }
        
        // Delete image
        function deleteImage(imageId) {
            if (!confirm('Are you sure you want to delete this image?')) {
                return;
            }
            
            fetch(contextPath + '/manager/service-images/delete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `imageId=${imageId}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    alert('Failed to delete image: ' + data.error);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error deleting image');
            });
        }
        
        // View image full size
        function viewImageFullSize(imageUrl) {
            document.getElementById('modalImage').src = imageUrl;
            new bootstrap.Modal(document.getElementById('imageModal')).show();
        }
    </script>
</body>

</html>
