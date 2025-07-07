<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">

<head>
    <meta charset="UTF-8">
    <title>Batch Image Upload</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    <style>
        .batch-upload-zone {
            border: 2px dashed #ddd;
            border-radius: 8px;
            padding: 40px;
            text-align: center;
            background: #fafafa;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .batch-upload-zone:hover {
            border-color: #007bff;
            background: #f0f8ff;
        }
        
        .batch-upload-zone.dragover {
            border-color: #007bff;
            background: #e3f2fd;
        }
        
        .file-mapping-container {
            max-height: 400px;
            overflow-y: auto;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            background: white;
        }
        
        .file-mapping-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 10px;
            border-bottom: 1px solid #eee;
            margin-bottom: 10px;
        }
        
        .file-mapping-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        
        .file-preview {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
            border: 1px solid #ddd;
        }
        
        .file-info {
            flex: 1;
            min-width: 0;
        }
        
        .file-name {
            font-weight: 500;
            margin-bottom: 4px;
            word-break: break-all;
        }
        
        .file-size {
            font-size: 12px;
            color: #666;
        }
        
        .service-select {
            min-width: 200px;
        }
        
        .batch-progress {
            display: none;
            margin-top: 20px;
        }
        
        .progress-summary {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 15px;
        }
        
        .progress-details {
            max-height: 300px;
            overflow-y: auto;
        }
        
        .progress-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 12px;
            border-bottom: 1px solid #eee;
        }
        
        .progress-item:last-child {
            border-bottom: none;
        }
        
        .status-icon {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: white;
        }
        
        .status-success { background: #28a745; }
        .status-error { background: #dc3545; }
        .status-processing { background: #007bff; }
        
        .auto-detect-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .naming-convention {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            margin-bottom: 20px;
        }
    </style>
</head>

<body>
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Batch Image Upload</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/manager/service" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Service Management
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Batch Upload</li>
            </ul>
        </div>

        <div class="row">
            <!-- Upload Section -->
            <div class="col-12">
                <div class="card p-0 radius-12 mb-24">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">Upload Multiple Images</h6>
                    </div>
                    <div class="card-body p-24">
                        <!-- Naming Convention Info -->
                        <div class="naming-convention">
                            <h6 class="fw-semibold mb-8">
                                <iconify-icon icon="solar:info-circle-outline" class="me-2"></iconify-icon>
                                File Naming Convention (Optional)
                            </h6>
                            <p class="mb-8">For automatic service detection, name your files like:</p>
                            <ul class="mb-0">
                                <li><code>service_1_image1.jpg</code> - Will be assigned to service with ID 1</li>
                                <li><code>massage_therapy_photo.png</code> - Will try to match service by name</li>
                                <li><code>facial_treatment_main.jpg</code> - Will try to match service by name</li>
                            </ul>
                        </div>

                        <!-- Auto-detect Section -->
                        <div class="auto-detect-section">
                            <div class="d-flex justify-content-between align-items-center mb-16">
                                <h6 class="fw-semibold mb-0">Auto-detect Services</h6>
                                <button type="button" class="btn btn-outline-primary btn-sm" onclick="autoDetectServices()">
                                    <iconify-icon icon="solar:magic-stick-3-outline" class="me-1"></iconify-icon>
                                    Auto-detect
                                </button>
                            </div>
                            <p class="text-sm text-muted mb-0">
                                Click "Auto-detect" after selecting files to automatically assign services based on file names.
                            </p>
                        </div>

                        <!-- Upload Zone -->
                        <div class="batch-upload-zone" id="batchUploadZone">
                            <iconify-icon icon="solar:cloud-upload-outline" class="text-primary text-6xl mb-16"></iconify-icon>
                            <h6 class="text-md fw-semibold text-primary-light mb-8">Drag & Drop Multiple Images Here</h6>
                            <p class="text-sm text-secondary-light mb-16">or click to browse files</p>
                            <input type="file" id="batchImageInput" multiple accept="image/*" style="display: none;">
                            <button type="button" class="btn btn-primary btn-sm" onclick="document.getElementById('batchImageInput').click()">
                                Choose Files
                            </button>
                            <div class="mt-16">
                                <small class="text-muted">
                                    Supported formats: JPG, PNG, WebP<br>
                                    Maximum size: 2MB per file<br>
                                    You can upload multiple files at once
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- File Mapping Section -->
            <div class="col-12" id="fileMappingSection" style="display: none;">
                <div class="card p-0 radius-12 mb-24">
                    <div class="card-header border-bottom bg-base py-16 px-24 d-flex justify-content-between align-items-center">
                        <h6 class="text-lg fw-semibold mb-0">Map Files to Services</h6>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="clearAllMappings()">
                                Clear All
                            </button>
                            <button type="button" class="btn btn-primary btn-sm" onclick="startBatchUpload()" id="uploadButton" disabled>
                                <iconify-icon icon="solar:upload-outline" class="me-1"></iconify-icon>
                                Upload All
                            </button>
                        </div>
                    </div>
                    <div class="card-body p-24">
                        <div class="file-mapping-container" id="fileMappingContainer">
                            <!-- File mapping items will be inserted here -->
                        </div>
                    </div>
                </div>
            </div>

            <!-- Progress Section -->
            <div class="col-12">
                <div class="card p-0 radius-12" id="batchProgressSection" style="display: none;">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">Upload Progress</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="progress-summary" id="progressSummary">
                            <div>
                                <span class="fw-semibold">Status: </span>
                                <span id="uploadStatus">Preparing...</span>
                            </div>
                            <div>
                                <span class="text-success fw-semibold" id="successCount">0</span> successful, 
                                <span class="text-danger fw-semibold" id="errorCount">0</span> failed
                            </div>
                        </div>
                        <div class="progress-details" id="progressDetails">
                            <!-- Progress items will be inserted here -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
    
    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const services = [
            <c:forEach var="service" items="${services}" varStatus="status">
                {
                    id: ${service.serviceId},
                    name: '${service.name}',
                    slug: '${service.name}'.toLowerCase().replace(/[^a-z0-9]+/g, '_').replace(/^_+|_+$/g, '')
                }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        let selectedFiles = [];
        
        // Initialize drag and drop
        const batchUploadZone = document.getElementById('batchUploadZone');
        const batchImageInput = document.getElementById('batchImageInput');
        
        // Drag and drop events
        batchUploadZone.addEventListener('dragover', (e) => {
            e.preventDefault();
            batchUploadZone.classList.add('dragover');
        });
        
        batchUploadZone.addEventListener('dragleave', () => {
            batchUploadZone.classList.remove('dragover');
        });
        
        batchUploadZone.addEventListener('drop', (e) => {
            e.preventDefault();
            batchUploadZone.classList.remove('dragover');
            const files = Array.from(e.dataTransfer.files);
            handleFileSelection(files);
        });
        
        batchUploadZone.addEventListener('click', () => {
            batchImageInput.click();
        });
        
        batchImageInput.addEventListener('change', (e) => {
            const files = Array.from(e.target.files);
            handleFileSelection(files);
        });
        
        // Handle file selection
        function handleFileSelection(files) {
            selectedFiles = files.filter(file => {
                const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
                return validTypes.includes(file.type) && file.size <= 2 * 1024 * 1024; // 2MB limit
            });
            
            if (selectedFiles.length === 0) {
                alert('No valid image files selected. Please select JPG, PNG, or WebP files under 2MB.');
                return;
            }
            
            displayFileMappings();
            document.getElementById('fileMappingSection').style.display = 'block';
        }
        
        // Display file mappings
        function displayFileMappings() {
            const container = document.getElementById('fileMappingContainer');
            container.innerHTML = '';
            
            selectedFiles.forEach((file, index) => {
                const item = createFileMappingItem(file, index);
                container.appendChild(item);
            });
            
            updateUploadButton();
        }
        
        // Create file mapping item
        function createFileMappingItem(file, index) {
            const item = document.createElement('div');
            item.className = 'file-mapping-item';
            
            // Create preview
            const preview = document.createElement('img');
            preview.className = 'file-preview';
            preview.src = URL.createObjectURL(file);
            
            // Create file info
            const fileInfo = document.createElement('div');
            fileInfo.className = 'file-info';
            fileInfo.innerHTML = `
                <div class="file-name">${file.name}</div>
                <div class="file-size">${(file.size / 1024).toFixed(1)} KB</div>
            `;
            
            // Create service select
            const serviceSelect = document.createElement('select');
            serviceSelect.className = 'form-select service-select';
            serviceSelect.setAttribute('data-file-index', index);
            serviceSelect.addEventListener('change', updateUploadButton);
            
            // Add default option
            const defaultOption = document.createElement('option');
            defaultOption.value = '';
            defaultOption.textContent = 'Select Service...';
            serviceSelect.appendChild(defaultOption);
            
            // Add service options
            services.forEach(service => {
                const option = document.createElement('option');
                option.value = service.id;
                option.textContent = service.name;
                serviceSelect.appendChild(option);
            });
            
            item.appendChild(preview);
            item.appendChild(fileInfo);
            item.appendChild(serviceSelect);
            
            return item;
        }
        
        // Auto-detect services based on file names
        function autoDetectServices() {
            const selects = document.querySelectorAll('.service-select');
            let detectedCount = 0;
            
            selects.forEach(select => {
                const fileIndex = parseInt(select.getAttribute('data-file-index'));
                const fileName = selectedFiles[fileIndex].name.toLowerCase();
                
                // Try to match by service ID pattern (service_1_image.jpg)
                const idMatch = fileName.match(/service_(\d+)_/);
                if (idMatch) {
                    const serviceId = parseInt(idMatch[1]);
                    const service = services.find(s => s.id === serviceId);
                    if (service) {
                        select.value = serviceId;
                        detectedCount++;
                        return;
                    }
                }
                
                // Try to match by service name/slug
                for (const service of services) {
                    if (fileName.includes(service.slug) || fileName.includes(service.name.toLowerCase())) {
                        select.value = service.id;
                        detectedCount++;
                        break;
                    }
                }
            });
            
            updateUploadButton();
            
            if (detectedCount > 0) {
                alert(`Auto-detected services for ${detectedCount} files. Please review and adjust as needed.`);
            } else {
                alert('No services could be auto-detected. Please select services manually.');
            }
        }
        
        // Clear all mappings
        function clearAllMappings() {
            document.querySelectorAll('.service-select').forEach(select => {
                select.value = '';
            });
            updateUploadButton();
        }
        
        // Update upload button state
        function updateUploadButton() {
            const selects = document.querySelectorAll('.service-select');
            const mappedCount = Array.from(selects).filter(select => select.value !== '').length;
            const uploadButton = document.getElementById('uploadButton');
            
            uploadButton.disabled = mappedCount === 0;
            uploadButton.innerHTML = `
                <iconify-icon icon="solar:upload-outline" class="me-1"></iconify-icon>
                Upload ${mappedCount} Files
            `;
        }
        
        // Start batch upload
        function startBatchUpload() {
            const formData = new FormData();
            const selects = document.querySelectorAll('.service-select');
            let hasValidMappings = false;
            
            // Add files and service mappings
            selects.forEach(select => {
                const fileIndex = parseInt(select.getAttribute('data-file-index'));
                const serviceId = select.value;
                
                if (serviceId) {
                    const file = selectedFiles[fileIndex];
                    formData.append('images', file);
                    formData.append(`service_${file.name}`, serviceId);
                    hasValidMappings = true;
                }
            });
            
            if (!hasValidMappings) {
                alert('Please select at least one service for your files.');
                return;
            }
            
            // Show progress section
            document.getElementById('batchProgressSection').style.display = 'block';
            document.getElementById('uploadStatus').textContent = 'Uploading...';
            
            // Initialize progress display
            initializeProgressDisplay();
            
            // Upload files
            fetch(contextPath + '/manager/service-images/upload-batch', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                handleBatchUploadResponse(data);
            })
            .catch(error => {
                console.error('Batch upload error:', error);
                document.getElementById('uploadStatus').textContent = 'Upload failed: ' + error.message;
            });
        }
        
        // Initialize progress display
        function initializeProgressDisplay() {
            const progressDetails = document.getElementById('progressDetails');
            progressDetails.innerHTML = '';
            
            const selects = document.querySelectorAll('.service-select');
            selects.forEach(select => {
                const fileIndex = parseInt(select.getAttribute('data-file-index'));
                const serviceId = select.value;
                
                if (serviceId) {
                    const file = selectedFiles[fileIndex];
                    const service = services.find(s => s.id == serviceId);
                    
                    const progressItem = document.createElement('div');
                    progressItem.className = 'progress-item';
                    progressItem.innerHTML = `
                        <div class="status-icon status-processing">
                            <iconify-icon icon="solar:refresh-outline"></iconify-icon>
                        </div>
                        <div class="flex-grow-1">
                            <div class="fw-semibold">${file.name}</div>
                            <small class="text-muted">${service ? service.name : 'Unknown Service'}</small>
                        </div>
                        <small class="text-muted">Processing...</small>
                    `;
                    progressDetails.appendChild(progressItem);
                }
            });
        }
        
        // Handle batch upload response
        function handleBatchUploadResponse(data) {
            const progressDetails = document.getElementById('progressDetails');
            const successCountEl = document.getElementById('successCount');
            const errorCountEl = document.getElementById('errorCount');
            const uploadStatus = document.getElementById('uploadStatus');
            
            if (data.success) {
                successCountEl.textContent = data.successCount || 0;
                errorCountEl.textContent = data.errorCount || 0;
                uploadStatus.textContent = 'Upload completed';
                
                // Update individual progress items
                const progressItems = progressDetails.querySelectorAll('.progress-item');
                data.results.forEach((result, index) => {
                    if (index < progressItems.length) {
                        const item = progressItems[index];
                        const statusIcon = item.querySelector('.status-icon');
                        const statusText = item.querySelector('small:last-child');
                        
                        if (result.success) {
                            statusIcon.className = 'status-icon status-success';
                            statusIcon.innerHTML = '<iconify-icon icon="solar:check-circle-outline"></iconify-icon>';
                            statusText.textContent = 'Success';
                            statusText.className = 'text-success';
                        } else {
                            statusIcon.className = 'status-icon status-error';
                            statusIcon.innerHTML = '<iconify-icon icon="solar:close-circle-outline"></iconify-icon>';
                            statusText.textContent = result.error || 'Failed';
                            statusText.className = 'text-danger';
                        }
                    }
                });
                
                // Show completion message
                setTimeout(() => {
                    if (data.successCount > 0) {
                        alert(`Batch upload completed successfully!\n${data.successCount} files uploaded, ${data.errorCount} failed.`);
                    }
                }, 1000);
                
            } else {
                uploadStatus.textContent = 'Upload failed: ' + data.error;
            }
        }
    </script>
</body>

</html>
