<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Batch Upload Ảnh Dịch Vụ</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              primary: "#D4AF37",
              "primary-dark": "#B8941F",
              secondary: "#FADADD",
              "spa-cream": "#FFF8F0",
              "spa-dark": "#333333"
            },
            fontFamily: {
              serif: ["Playfair Display", "serif"],
              sans: ["Roboto", "sans-serif"]
            }
          }
        }
      };
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>
<body class="bg-spa-cream font-sans min-h-screen">
<jsp:include page="/WEB-INF/view/common/header.jsp" />
<div class="flex">
<jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
<main class="flex-1 py-12 lg:py-20 ml-64">
<div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
        <a href="${pageContext.request.contextPath}/manager/service-images/manage" class="flex items-center gap-1 hover:text-primary">
            <i data-lucide="gallery-horizontal" class="w-4 h-4"></i>
            Quản lý ảnh dịch vụ
        </a>
        <span>-</span>
        <span class="text-primary font-semibold">Batch Upload Ảnh</span>
    </div>
    <div class="bg-white rounded-2xl shadow-lg p-8">
        <h1 class="text-2xl font-serif font-bold text-spa-dark mb-6 flex items-center gap-2"><i data-lucide="cloud-upload" class="w-6 h-6"></i> Batch Upload Ảnh Dịch Vụ</h1>
        <!-- Naming Convention Info -->
        <div class="bg-blue-50 border-l-4 border-blue-400 rounded-lg p-4 mb-6">
            <h2 class="font-semibold text-blue-700 mb-2 flex items-center gap-2"><i data-lucide="info" class="w-5 h-5"></i> Quy tắc đặt tên file (tùy chọn)</h2>
            <p class="mb-2 text-sm text-blue-700">Để tự động nhận diện dịch vụ, hãy đặt tên file như:</p>
            <ul class="list-disc pl-6 text-blue-700 text-sm">
                <li><code>service_1_image1.jpg</code> - Gán cho dịch vụ ID 1</li>
                <li><code>massage_therapy_photo.png</code> - Thử khớp theo tên dịch vụ</li>
                <li><code>facial_treatment_main.jpg</code> - Thử khớp theo tên dịch vụ</li>
            </ul>
        </div>
        <!-- Auto-detect Section -->
        <div class="bg-gray-50 rounded-lg p-4 mb-6 flex flex-wrap items-center justify-between gap-2">
            <div class="font-semibold text-gray-700 flex items-center gap-2"><i data-lucide="wand" class="w-5 h-5"></i> Tự động nhận diện dịch vụ</div>
            <button type="button" class="inline-flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition text-sm" onclick="autoDetectServices()">
                <i data-lucide="wand" class="w-4 h-4"></i> Auto-detect
            </button>
        </div>
        <!-- Upload Zone -->
        <div class="border-2 border-dashed border-gray-300 rounded-lg bg-gray-50 p-8 text-center mb-6 cursor-pointer" id="batchUploadZone">
            <i data-lucide="cloud-upload" class="text-primary w-12 h-12 mx-auto mb-4"></i>
            <h2 class="text-lg font-semibold text-primary mb-2">Kéo & thả nhiều ảnh vào đây</h2>
            <p class="text-sm text-gray-500 mb-4">hoặc click để chọn file</p>
            <input type="file" id="batchImageInput" multiple accept="image/*" style="display: none;">
            <button type="button" class="inline-flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition text-sm" onclick="document.getElementById('batchImageInput').click()">
                <i data-lucide="file-plus" class="w-4 h-4"></i> Chọn file
            </button>
            <div class="mt-4 text-xs text-gray-400">
                Định dạng: JPG, PNG, WebP. Tối đa 2MB/file. Có thể chọn nhiều file cùng lúc.
            </div>
        </div>
        <!-- File Mapping Section -->
        <div id="fileMappingSection" style="display: none;" class="mb-6">
            <div class="bg-gray-50 rounded-lg shadow p-4 mb-4">
                <div class="flex flex-wrap items-center justify-between mb-2">
                    <div class="font-semibold text-gray-700">Gán file cho dịch vụ</div>
                    <div class="flex gap-2">
                        <button type="button" class="inline-flex items-center gap-2 px-3 py-1 bg-gray-200 text-gray-700 rounded hover:bg-gray-300 transition text-sm" onclick="clearAllMappings()">
                            Xóa tất cả
                        </button>
                        <button type="button" class="inline-flex items-center gap-2 px-3 py-1 bg-primary text-white rounded hover:bg-primary-dark transition text-sm" onclick="startBatchUpload()" id="uploadButton" disabled>
                            <i data-lucide="upload" class="w-4 h-4"></i> Upload tất cả
                        </button>
                    </div>
                </div>
                <div id="fileMappingContainer" class="divide-y divide-gray-200"></div>
            </div>
        </div>
        <!-- Progress Section -->
        <div id="batchProgressSection" style="display: none;" class="mb-6">
            <div class="bg-gray-50 rounded-lg shadow p-4 mb-4">
                <div class="flex flex-wrap items-center justify-between mb-2">
                    <div class="font-semibold text-gray-700">Tiến trình upload</div>
                    <div class="flex gap-2 text-sm">
                        <span class="text-green-600 font-semibold" id="successCount">0</span> thành công,
                        <span class="text-red-600 font-semibold" id="errorCount">0</span> thất bại
                    </div>
                </div>
                <div id="progressSummary" class="mb-2 text-sm text-gray-500"><span class="font-semibold">Trạng thái:</span> <span id="uploadStatus">Đang chuẩn bị...</span></div>
                <div id="progressDetails"></div>
            </div>
        </div>
    </div>
</div>
</main>
</div>
<jsp:include page="/WEB-INF/view/common/footer.jsp" />
<jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
<script>if (window.lucide) lucide.createIcons();</script>
<!-- Giữ lại toàn bộ script upload, mapping, progress như cũ -->
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
