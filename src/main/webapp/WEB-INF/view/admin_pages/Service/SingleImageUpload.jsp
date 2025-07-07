<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">

<head>
    <meta charset="UTF-8">
    <title>Upload Images - ${service.name}</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    <style>
        .image-upload-zone {
            border: 2px dashed #ddd;
            border-radius: 8px;
            padding: 40px;
            text-align: center;
            background: #fafafa;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .image-upload-zone:hover {
            border-color: #007bff;
            background: #f0f8ff;
        }
        
        .image-upload-zone.dragover {
            border-color: #007bff;
            background: #e3f2fd;
        }
        
        .image-preview-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        
        .image-preview-item {
            position: relative;
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
            background: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .image-preview-item img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }
        
        .image-preview-info {
            padding: 10px;
        }
        
        .image-preview-actions {
            position: absolute;
            top: 5px;
            right: 5px;
            display: flex;
            gap: 5px;
        }
        
        .btn-icon {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: none;
            color: white;
            font-size: 12px;
        }
        
        .primary-badge {
            position: absolute;
            top: 5px;
            left: 5px;
            background: #28a745;
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 10px;
            font-weight: bold;
        }
        
        .upload-progress {
            display: none;
            margin-top: 20px;
        }
        
        .progress-item {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .progress-bar {
            flex: 1;
            height: 6px;
            background: #f0f0f0;
            border-radius: 3px;
            overflow: hidden;
        }
        
        .progress-fill {
            height: 100%;
            background: #007bff;
            width: 0%;
            transition: width 0.3s ease;
        }
        
        .sortable-placeholder {
            background: #f0f0f0;
            border: 2px dashed #ccc;
            margin: 10px;
            height: 150px;
        }
    </style>
</head>

<body>
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Upload Images - ${service.name}</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/manager/service" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Service Management
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Upload Images</li>
            </ul>
        </div>

        <div class="row">
            <!-- Upload Section -->
            <div class="col-lg-6">
                <div class="card h-100 p-0 radius-12">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">Upload New Images</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="image-upload-zone" id="uploadZone">
                            <iconify-icon icon="solar:cloud-upload-outline" class="text-primary text-6xl mb-16"></iconify-icon>
                            <h6 class="text-md fw-semibold text-primary-light mb-8">Drag & Drop Images Here</h6>
                            <p class="text-sm text-secondary-light mb-16">or click to browse files</p>
                            <input type="file" id="imageInput" multiple accept="image/*" style="display: none;">
                            <button type="button" class="btn btn-primary btn-sm" onclick="document.getElementById('imageInput').click()">
                                Choose Files
                            </button>
                            <div class="mt-16">
                                <small class="text-muted">
                                    Supported formats: JPG, PNG, WebP<br>
                                    Maximum size: 2MB per file<br>
                                    Minimum dimensions: 150x150 pixels
                                </small>
                            </div>
                        </div>

                        <!-- Upload Progress -->
                        <div class="upload-progress" id="uploadProgress">
                            <h6 class="text-md fw-semibold mb-16">Upload Progress</h6>
                            <div id="progressContainer"></div>
                        </div>

                        <!-- Upload Results -->
                        <div id="uploadResults" class="mt-20" style="display: none;">
                            <div class="alert alert-success" id="successMessage" style="display: none;"></div>
                            <div class="alert alert-danger" id="errorMessage" style="display: none;"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Existing Images Section -->
            <div class="col-lg-6">
                <div class="card h-100 p-0 radius-12">
                    <div class="card-header border-bottom bg-base py-16 px-24 d-flex justify-content-between align-items-center">
                        <h6 class="text-lg fw-semibold mb-0">Existing Images (${existingImages.size()})</h6>
                        <button type="button" class="btn btn-outline-primary btn-sm" onclick="refreshImages()">
                            <iconify-icon icon="solar:refresh-outline" class="me-1"></iconify-icon>
                            Refresh
                        </button>
                    </div>
                    <div class="card-body p-24">
                        <c:if test="${empty existingImages}">
                            <div class="text-center py-40">
                                <iconify-icon icon="solar:gallery-outline" class="text-secondary-light text-6xl mb-16"></iconify-icon>
                                <p class="text-secondary-light">No images uploaded yet</p>
                            </div>
                        </c:if>
                        
                        <div class="image-preview-container" id="existingImagesContainer">
                            <c:forEach var="image" items="${existingImages}">
                                <div class="image-preview-item" data-image-id="${image.imageId}">
                                    <c:if test="${image.isPrimary}">
                                        <div class="primary-badge">Primary</div>
                                    </c:if>
                                    
                                    <div class="image-preview-actions">
                                        <c:if test="${!image.isPrimary}">
                                            <button type="button" class="btn-icon bg-success" 
                                                    onclick="setPrimaryImage(${image.imageId})"
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
                                         onerror="this.src='${pageContext.request.contextPath}/assets/images/no-image.png'">
                                    
                                    <div class="image-preview-info">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <small class="text-muted">
                                                <c:if test="${image.fileSize != null}">
                                                    <fmt:formatNumber value="${image.fileSize / 1024}" maxFractionDigits="1" />KB
                                                </c:if>
                                            </small>
                                            <small class="text-muted">Order: ${image.sortOrder}</small>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <c:if test="${not empty existingImages}">
                            <div class="mt-20">
                                <small class="text-muted">
                                    <iconify-icon icon="solar:info-circle-outline" class="me-1"></iconify-icon>
                                    Drag images to reorder them
                                </small>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    
    <!-- Include SortableJS for drag and drop reordering -->
    <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
    
    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const serviceId = ${service.serviceId};
        
        // Initialize drag and drop upload
        const uploadZone = document.getElementById('uploadZone');
        const imageInput = document.getElementById('imageInput');
        
        // Drag and drop events
        uploadZone.addEventListener('dragover', (e) => {
            e.preventDefault();
            uploadZone.classList.add('dragover');
        });
        
        uploadZone.addEventListener('dragleave', () => {
            uploadZone.classList.remove('dragover');
        });
        
        uploadZone.addEventListener('drop', (e) => {
            e.preventDefault();
            uploadZone.classList.remove('dragover');
            const files = Array.from(e.dataTransfer.files);
            handleFileUpload(files);
        });
        
        uploadZone.addEventListener('click', () => {
            imageInput.click();
        });
        
        imageInput.addEventListener('change', (e) => {
            const files = Array.from(e.target.files);
            handleFileUpload(files);
        });
        
        // Initialize sortable for existing images
        const existingImagesContainer = document.getElementById('existingImagesContainer');
        if (existingImagesContainer) {
            new Sortable(existingImagesContainer, {
                animation: 150,
                ghostClass: 'sortable-placeholder',
                onEnd: function(evt) {
                    updateImageOrder();
                }
            });
        }
        
        // Handle file upload
        function handleFileUpload(files) {
            if (files.length === 0) return;
            
            const progressContainer = document.getElementById('progressContainer');
            const uploadProgress = document.getElementById('uploadProgress');
            
            // Show progress section
            uploadProgress.style.display = 'block';
            progressContainer.innerHTML = '';
            
            // Create FormData
            const formData = new FormData();
            formData.append('serviceId', serviceId);
            
            files.forEach((file, index) => {
                formData.append('images', file);
                
                // Create progress item
                const progressItem = createProgressItem(file.name, index);
                progressContainer.appendChild(progressItem);
            });
            
            // Upload files
            fetch(contextPath + '/manager/service-images/upload-single', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                handleUploadResponse(data);
            })
            .catch(error => {
                console.error('Upload error:', error);
                showMessage('Upload failed: ' + error.message, 'error');
            });
        }
        
        // Create progress item
        function createProgressItem(fileName, index) {
            const item = document.createElement('div');
            item.className = 'progress-item';
            item.innerHTML = `
                <div style="min-width: 150px;">
                    <small class="fw-semibold">${fileName}</small>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" id="progress-${index}"></div>
                </div>
                <small class="text-muted" id="status-${index}">Uploading...</small>
            `;
            return item;
        }
        
        // Handle upload response
        function handleUploadResponse(data) {
            const uploadProgress = document.getElementById('uploadProgress');

            // Show overall message
            if (data.success) {
                showMessage(data.message || 'Images uploaded successfully!', 'success');
            } else if (data.successCount > 0) {
                showMessage(data.message || 'Some uploads failed', 'warning');
            } else {
                showMessage(data.message || 'Upload failed', 'error');
            }

            // Update individual progress items if results are available
            if (data.results && Array.isArray(data.results)) {
                data.results.forEach((result, index) => {
                    const progressFill = document.getElementById(`progress-${index}`);
                    const statusElement = document.getElementById(`status-${index}`);

                    if (progressFill && statusElement) {
                        if (result.success) {
                            progressFill.style.width = '100%';
                            statusElement.textContent = 'Complete';
                            statusElement.className = 'text-success';
                        } else {
                            progressFill.style.width = '100%';
                            progressFill.style.background = '#dc3545'; // Red for error
                            statusElement.textContent = result.error || 'Failed';
                            statusElement.className = 'text-danger';
                        }
                    }
                });
            } else {
                // Fallback: update all progress bars
                document.querySelectorAll('.progress-fill').forEach(bar => {
                    bar.style.width = '100%';
                    if (!data.success) {
                        bar.style.background = '#dc3545';
                    }
                });

                document.querySelectorAll('[id^="status-"]').forEach(status => {
                    if (data.success) {
                        status.textContent = 'Complete';
                        status.className = 'text-success';
                    } else {
                        status.textContent = 'Failed';
                        status.className = 'text-danger';
                    }
                });
            }

            // Refresh the page after a delay if any uploads succeeded
            if (data.successCount > 0) {
                setTimeout(() => {
                    refreshImages();
                    uploadProgress.style.display = 'none';
                }, 3000);
            } else {
                // Hide progress after a longer delay if all failed
                setTimeout(() => {
                    uploadProgress.style.display = 'none';
                }, 5000);
            }
        }
        
        // Set primary image
        function setPrimaryImage(imageId) {
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
                    showMessage('Primary image updated successfully!', 'success');
                    refreshImages();
                } else {
                    showMessage('Failed to set primary image: ' + data.error, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('Error setting primary image', 'error');
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
                    showMessage('Image deleted successfully!', 'success');
                    refreshImages();
                } else {
                    showMessage('Failed to delete image: ' + data.error, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('Error deleting image', 'error');
            });
        }
        
        // Update image order
        function updateImageOrder() {
            const imageItems = document.querySelectorAll('.image-preview-item');
            const imageIds = Array.from(imageItems).map(item => item.dataset.imageId);
            
            fetch(contextPath + '/manager/service-images/update-order', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `order=${imageIds.join(',')}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage('Image order updated successfully!', 'success');
                } else {
                    showMessage('Failed to update order: ' + data.error, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('Error updating image order', 'error');
            });
        }
        
        // Refresh images
        function refreshImages() {
            window.location.reload();
        }
        
        // Show message
        function showMessage(message, type) {
            const resultsDiv = document.getElementById('uploadResults');
            const successDiv = document.getElementById('successMessage');
            const errorDiv = document.getElementById('errorMessage');

            resultsDiv.style.display = 'block';

            if (type === 'success') {
                successDiv.textContent = message;
                successDiv.style.display = 'block';
                successDiv.className = 'alert alert-success';
                errorDiv.style.display = 'none';
            } else if (type === 'warning') {
                successDiv.textContent = message;
                successDiv.style.display = 'block';
                successDiv.className = 'alert alert-warning';
                errorDiv.style.display = 'none';
            } else {
                errorDiv.textContent = message;
                errorDiv.style.display = 'block';
                successDiv.style.display = 'none';
            }

            // Hide message after 7 seconds for warnings/errors, 5 for success
            const hideDelay = (type === 'success') ? 5000 : 7000;
            setTimeout(() => {
                resultsDiv.style.display = 'none';
            }, hideDelay);
        }
    </script>
</body>

</html>
