<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Batch Upload Ảnh Dịch Vụ - Spa Hương Sen</title>
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
<div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
    <!-- Breadcrumb Navigation -->
    <nav class="flex items-center space-x-2 text-sm text-gray-600 mb-8">
        <a href="${pageContext.request.contextPath}/manager/dashboard" class="hover:text-primary transition-colors">
            <i data-lucide="home" class="w-4 h-4 inline mr-1"></i>
            Dashboard
        </a>
        <i data-lucide="chevron-right" class="w-4 h-4"></i>
        <a href="${pageContext.request.contextPath}/manager/service" class="hover:text-primary transition-colors">
            <i data-lucide="list" class="w-4 h-4 inline mr-1"></i>
            Quản lý dịch vụ
        </a>
        <i data-lucide="chevron-right" class="w-4 h-4"></i>
        <a href="${pageContext.request.contextPath}/manager/service-images/manage" class="hover:text-primary transition-colors">
            <i data-lucide="gallery-horizontal" class="w-4 h-4 inline mr-1"></i>
            Quản lý ảnh
        </a>
        <i data-lucide="chevron-right" class="w-4 h-4"></i>
        <span class="text-primary font-semibold">Batch Upload</span>
    </nav>

    <!-- Header Section -->
    <div class="bg-white rounded-2xl shadow-lg p-8 mb-8">
        <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6">
            <div>
                <h1 class="text-3xl font-serif font-bold text-spa-dark mb-2 flex items-center gap-3">
                    <i data-lucide="cloud-upload" class="w-8 h-8 text-primary"></i>
                    Batch Upload Ảnh Dịch Vụ
                </h1>
                <p class="text-gray-600">Tải lên nhiều ảnh cùng lúc cho các dịch vụ khác nhau</p>
            </div>
            <div class="flex flex-wrap gap-3">
                <a href="${pageContext.request.contextPath}/manager/service-images/manage" class="inline-flex items-center gap-2 px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
                    <i data-lucide="arrow-left" class="w-4 h-4"></i>
                    Quay về
                </a>
                <a href="${pageContext.request.contextPath}/manager/service" class="inline-flex items-center gap-2 px-4 py-2 bg-blue-100 text-blue-800 rounded-lg hover:bg-blue-200 transition-colors">
                    <i data-lucide="list" class="w-4 h-4"></i>
                    Danh sách dịch vụ
                </a>
            </div>
        </div>
    </div>

    <div class="bg-white rounded-2xl shadow-lg p-8">
        <!-- Naming Convention Info -->
        <div class="bg-blue-50 border-l-4 border-blue-400 rounded-lg p-6 mb-8">
            <h2 class="font-semibold text-blue-700 mb-3 flex items-center gap-2">
                <i data-lucide="info" class="w-5 h-5"></i>
                Quy tắc đặt tên file (tùy chọn)
            </h2>
            <p class="mb-3 text-sm text-blue-700">Để tự động nhận diện dịch vụ, hãy đặt tên file như:</p>
            <ul class="list-disc pl-6 text-blue-700 text-sm space-y-1">
                <li><code class="bg-blue-100 px-2 py-1 rounded">service_1_image1.jpg</code> - Gán cho dịch vụ ID 1</li>
                <li><code class="bg-blue-100 px-2 py-1 rounded">massage_therapy_photo.png</code> - Thử khớp theo tên dịch vụ</li>
                <li><code class="bg-blue-100 px-2 py-1 rounded">facial_treatment_main.jpg</code> - Thử khớp theo tên dịch vụ</li>
            </ul>
        </div>

        <!-- Auto-detect Section -->
        <div class="bg-gray-50 rounded-lg p-6 mb-8 flex flex-wrap items-center justify-between gap-4">
            <div class="font-semibold text-gray-700 flex items-center gap-2">
                <i data-lucide="wand" class="w-5 h-5 text-primary"></i>
                Tự động nhận diện dịch vụ
            </div>
            <button type="button" class="inline-flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors shadow-sm" onclick="autoDetectServices()">
                <i data-lucide="wand" class="w-4 h-4"></i>
                Auto-detect
            </button>
        </div>

        <!-- Upload Zone -->
        <div class="border-2 border-dashed border-gray-300 rounded-xl bg-gray-50 p-12 text-center mb-8 cursor-pointer hover:border-primary hover:bg-gray-100 transition-all duration-300" id="batchUploadZone">
            <i data-lucide="cloud-upload" class="text-primary w-16 h-16 mx-auto mb-6"></i>
            <h2 class="text-xl font-semibold text-primary mb-3">Kéo & thả nhiều ảnh vào đây</h2>
            <p class="text-gray-600 mb-6">hoặc click để chọn file</p>
            <input type="file" id="batchImageInput" multiple accept="image/*" style="display: none;">
            <button type="button" class="inline-flex items-center gap-2 px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors shadow-sm" onclick="document.getElementById('batchImageInput').click()">
                <i data-lucide="file-plus" class="w-5 h-5"></i>
                Chọn file
            </button>
            <div class="mt-6 text-sm text-gray-500">
                <p>Định dạng: JPG, PNG, WebP</p>
                <p>Tối đa 2MB/file. Có thể chọn nhiều file cùng lúc.</p>
            </div>
        </div>

        <!-- File Mapping Section -->
        <div id="fileMappingSection" style="display: none;" class="mb-8">
            <div class="bg-gray-50 rounded-xl shadow p-6 mb-6">
                <div class="flex flex-wrap items-center justify-between mb-4">
                    <div class="font-semibold text-gray-700 text-lg">Gán file cho dịch vụ</div>
                    <div class="flex gap-3">
                        <button type="button" class="inline-flex items-center gap-2 px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition-colors" onclick="clearAllMappings()">
                            <i data-lucide="trash-2" class="w-4 h-4"></i>
                            Xóa tất cả
                        </button>
                        <button type="button" class="inline-flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors shadow-sm" onclick="startBatchUpload()" id="uploadButton" disabled>
                            <i data-lucide="upload" class="w-4 h-4"></i>
                            Upload tất cả
                        </button>
                    </div>
                </div>
                <div id="fileMappingContainer" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4"></div>
            </div>
        </div>

        <!-- Progress Section -->
        <div id="batchProgressSection" style="display: none;" class="mb-8">
            <div class="bg-gray-50 rounded-xl shadow p-6 mb-6">
                <div class="flex flex-wrap items-center justify-between mb-4">
                    <div class="font-semibold text-gray-700 text-lg">Tiến trình upload</div>
                    <div class="flex gap-4 text-sm">
                        <span class="text-green-600 font-semibold flex items-center gap-1">
                            <i data-lucide="check-circle" class="w-4 h-4"></i>
                            <span id="successCount">0</span> thành công
                        </span>
                        <span class="text-red-600 font-semibold flex items-center gap-1">
                            <i data-lucide="x-circle" class="w-4 h-4"></i>
                            <span id="errorCount">0</span> thất bại
                        </span>
                    </div>
                </div>
                <div id="progressSummary" class="mb-4 text-sm text-gray-600">
                    <span class="font-semibold">Trạng thái:</span> 
                    <span id="uploadStatus" class="text-primary">Đang chuẩn bị...</span>
                </div>
                <div id="progressDetails" class="space-y-3"></div>
            </div>
        </div>
    </div>
</div>
</main>
</div>
<jsp:include page="/WEB-INF/view/common/footer.jsp" />

<!-- Modal xem ảnh lớn -->
<div id="imageModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-80 hidden">
    <div class="relative max-w-[90vw] max-h-[90vh]">
        <button id="closeModal" class="absolute -top-12 right-0 text-white text-4xl hover:text-gray-300 transition-colors">
            <i data-lucide="x" class="w-8 h-8"></i>
        </button>
        <img id="modalImg" src="" class="max-h-[90vh] max-w-[90vw] rounded-xl shadow-2xl border-4 border-white object-contain" />
    </div>
</div>

<jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
<script>if (window.lucide) lucide.createIcons();</script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        window.showImageModal = function(src) {
            document.getElementById('modalImg').src = src;
            document.getElementById('imageModal').classList.remove('hidden');
        };
        
        document.getElementById('closeModal').onclick = function() {
            document.getElementById('imageModal').classList.add('hidden');
            document.getElementById('modalImg').src = '';
        };
        
        document.getElementById('imageModal').onclick = function(e) {
            if (e.target === this) {
                this.classList.add('hidden');
                document.getElementById('modalImg').src = '';
            }
        };
        
        // Close modal with Escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                document.getElementById('imageModal').classList.add('hidden');
                document.getElementById('modalImg').src = '';
            }
        });
        
        // Gắn sự kiện click cho ảnh preview nếu có
        document.querySelectorAll('.file-preview').forEach(function(img) {
            img.style.cursor = 'zoom-in';
            img.onclick = function() {
                window.showImageModal(img.src);
            };
        });
    });
</script>

<!-- Upload Scripts -->
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
        batchUploadZone.classList.add('border-primary', 'bg-gray-100');
    });
    
    batchUploadZone.addEventListener('dragleave', () => {
        batchUploadZone.classList.remove('border-primary', 'bg-gray-100');
    });
    
    batchUploadZone.addEventListener('drop', (e) => {
        e.preventDefault();
        batchUploadZone.classList.remove('border-primary', 'bg-gray-100');
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
            alert('Không có file ảnh hợp lệ nào được chọn. Vui lòng chọn file JPG, PNG, hoặc WebP dưới 2MB.');
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
        item.className = 'bg-white border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow duration-300';
        
        // Create preview
        const preview = document.createElement('img');
        preview.className = 'file-preview w-full h-32 object-cover rounded-lg mb-3 cursor-pointer hover:scale-105 transition-transform duration-300';
        preview.src = URL.createObjectURL(file);
        
        // Create file info
        const fileInfo = document.createElement('div');
        fileInfo.className = 'mb-3';
        fileInfo.innerHTML = `
            <div class="font-semibold text-gray-800 text-sm mb-1 truncate" title="${file.name}">${file.name}</div>
            <div class="text-xs text-gray-500">${(file.size / 1024).toFixed(1)} KB</div>
        `;
        
        // Create service select
        const serviceSelect = document.createElement('select');
        serviceSelect.className = 'w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-primary focus:border-primary transition-colors text-sm';
        serviceSelect.setAttribute('data-file-index', index);
        serviceSelect.addEventListener('change', updateUploadButton);
        
        // Add default option
        const defaultOption = document.createElement('option');
        defaultOption.value = '';
        defaultOption.textContent = 'Chọn dịch vụ...';
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
            alert(`Đã tự động nhận diện ${detectedCount} file. Vui lòng kiểm tra và điều chỉnh nếu cần.`);
        } else {
            alert('Không thể tự động nhận diện dịch vụ nào. Vui lòng chọn thủ công.');
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
            <i data-lucide="upload" class="w-4 h-4"></i>
            Upload ${mappedCount} Files
        `;
        
        if (window.lucide) lucide.createIcons();
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
            alert('Vui lòng chọn ít nhất một dịch vụ cho các file của bạn.');
            return;
        }
        
        // Show progress section
        document.getElementById('batchProgressSection').style.display = 'block';
        document.getElementById('uploadStatus').textContent = 'Đang upload...';
        
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
            document.getElementById('uploadStatus').textContent = 'Upload thất bại: ' + error.message;
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
                progressItem.className = 'flex items-center gap-3 p-3 bg-white rounded-lg border border-gray-200';
                progressItem.innerHTML = `
                    <div class="text-blue-500">
                        <i data-lucide="loader-2" class="w-5 h-5 animate-spin"></i>
                    </div>
                    <div class="flex-grow">
                        <div class="font-semibold text-sm">${file.name}</div>
                        <small class="text-gray-500">${service ? service.name : 'Dịch vụ không xác định'}</small>
                    </div>
                    <small class="text-gray-500">Đang xử lý...</small>
                `;
                progressDetails.appendChild(progressItem);
            }
        });
        
        if (window.lucide) lucide.createIcons();
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
            uploadStatus.textContent = 'Upload hoàn thành';
            uploadStatus.className = 'text-green-600';
            
            // Update individual progress items
            const progressItems = progressDetails.querySelectorAll('.flex');
            data.results.forEach((result, index) => {
                if (index < progressItems.length) {
                    const item = progressItems[index];
                    const statusIcon = item.querySelector('.text-blue-500');
                    const statusText = item.querySelector('small:last-child');
                    
                    if (result.success) {
                        statusIcon.innerHTML = '<i data-lucide="check-circle" class="w-5 h-5 text-green-500"></i>';
                        statusText.textContent = 'Thành công';
                        statusText.className = 'text-green-600';
                    } else {
                        statusIcon.innerHTML = '<i data-lucide="x-circle" class="w-5 h-5 text-red-500"></i>';
                        statusText.textContent = result.error || 'Thất bại';
                        statusText.className = 'text-red-600';
                    }
                }
            });
            
            if (window.lucide) lucide.createIcons();
            
            // Show completion message
            setTimeout(() => {
                if (data.successCount > 0) {
                    alert(`Batch upload hoàn thành!\n${data.successCount} file thành công, ${data.errorCount} thất bại.`);
                }
            }, 1000);
            
        } else {
            uploadStatus.textContent = 'Upload thất bại: ' + data.error;
            uploadStatus.className = 'text-red-600';
        }
    }
</script>
</body>
</html>

