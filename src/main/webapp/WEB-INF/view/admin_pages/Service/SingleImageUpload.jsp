<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Ảnh Dịch Vụ - ${service.name} - Spa Hương Sen</title>
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
    <style>
        .image-upload-zone {
            border: 2px dashed #ddd;
            border-radius: 12px;
            padding: 40px;
            text-align: center;
            background: #fafafa;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .image-upload-zone:hover {
            border-color: #D4AF37;
            background: #fff8f0;
        }
        .image-upload-zone.dragover {
            border-color: #D4AF37;
            background: #fff3e0;
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
            border-radius: 12px;
            overflow: hidden;
            background: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        .image-preview-item:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            transform: translateY(-2px);
        }
        .image-preview-item img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }
        .image-preview-info {
            padding: 12px;
        }
        .image-preview-actions {
            position: absolute;
            top: 8px;
            right: 8px;
            display: flex;
            gap: 4px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .image-preview-item:hover .image-preview-actions {
            opacity: 1;
        }
        .upload-progress {
            display: none;
            margin-top: 20px;
        }
        .progress-item {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 12px;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background: white;
        }
        .sortable-placeholder {
            background: #f0f0f0;
            border: 2px dashed #ccc;
            margin: 10px;
            height: 150px;
            border-radius: 12px;
        }
    </style>
</head>
<body class="bg-spa-cream font-sans min-h-screen">
<jsp:include page="/WEB-INF/view/common/header.jsp" />
<div class="flex">
<jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
<main class="flex-1 py-12 lg:py-20 ml-64">
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
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
        <span class="text-primary font-semibold">Upload ảnh - ${service.name}</span>
    </nav>

    <!-- Header Section -->
    <div class="bg-white rounded-2xl shadow-lg p-8 mb-8">
        <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6">
            <div>
                <h1 class="text-3xl font-serif font-bold text-spa-dark mb-2 flex items-center gap-3">
                    <i data-lucide="upload" class="w-8 h-8 text-primary"></i>
                    Upload Ảnh Dịch Vụ
                </h1>
                <p class="text-gray-600">Tải lên ảnh cho dịch vụ: <span class="font-semibold text-primary">${service.name}</span></p>
            </div>
            <div class="flex flex-wrap gap-3">
                <a href="${pageContext.request.contextPath}/manager/service-images/manage?serviceId=${service.serviceId}" class="inline-flex items-center gap-2 px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
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

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <!-- Upload Section -->
        <div>
            <div class="bg-white rounded-2xl shadow-lg p-8">
                <div class="flex items-center justify-between mb-6">
                    <h3 class="text-xl font-serif font-bold text-spa-dark flex items-center gap-2">
                        <i data-lucide="cloud-upload" class="w-6 h-6 text-primary"></i>
                        Upload Ảnh Mới
                    </h3>
                </div>
                <div class="image-upload-zone" id="uploadZone">
                    <i data-lucide="cloud-upload" class="text-primary w-16 h-16 mx-auto mb-4"></i>
                    <h4 class="text-lg font-semibold text-primary mb-2">Kéo & thả ảnh vào đây</h4>
                    <p class="text-gray-600 mb-6">hoặc click để chọn file</p>
                    <input type="file" id="imageInput" multiple accept="image/*" style="display: none;">
                    <button id="chooseFilesBtn" type="button" class="inline-flex items-center gap-2 px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors shadow-sm">
                        <i data-lucide="file-plus" class="w-5 h-5"></i>
                        Chọn file
                    </button>
                    <div class="mt-6 text-sm text-gray-500">
                        <p>Định dạng: JPG, PNG, WebP</p>
                        <p>Tối đa 2MB/file. Kích thước tối thiểu: 150x150 pixels</p>
                    </div>
                </div>

                <!-- Upload Progress -->
                <div class="upload-progress" id="uploadProgress">
                    <h4 class="text-lg font-semibold mb-4 flex items-center gap-2">
                        <i data-lucide="loader-2" class="w-5 h-5 text-primary animate-spin"></i>
                        Tiến trình Upload
                    </h4>
                    <div id="progressContainer" class="space-y-3"></div>
                </div>

                <!-- Upload Results -->
                <div id="uploadResults" class="mt-6" style="display: none;">
                    <div class="alert alert-success" id="successMessage" style="display: none;"></div>
                    <div class="alert alert-danger" id="errorMessage" style="display: none;"></div>
                </div>
            </div>
        </div>

        <!-- Existing Images Section -->
        <div>
            <div class="bg-white rounded-2xl shadow-lg p-8">
                <div class="flex items-center justify-between mb-6">
                    <h3 class="text-xl font-serif font-bold text-spa-dark flex items-center gap-2">
                        <i data-lucide="gallery-horizontal" class="w-6 h-6 text-primary"></i>
                        Ảnh Hiện Tại (${existingImages.size()})
                    </h3>
                    <button type="button" class="inline-flex items-center gap-2 px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors" onclick="refreshImages()">
                        <i data-lucide="refresh-ccw" class="w-4 h-4"></i>
                        Làm mới
                    </button>
                </div>
                
                <c:if test="${empty existingImages}">
                    <div class="text-center py-16 text-gray-400">
                        <i data-lucide="image-off" class="w-16 h-16 mx-auto mb-4 text-gray-300"></i>
                        <h4 class="text-lg font-semibold mb-2">Chưa có ảnh nào</h4>
                        <p class="mb-6">Dịch vụ này chưa có ảnh nào được tải lên</p>
                    </div>
                </c:if>
                
                <div class="image-preview-container" id="existingImagesContainer">
                    <c:forEach var="image" items="${existingImages}">
                        <div class="image-preview-item" data-image-id="${image.imageId}">
                            <c:if test="${image.isPrimary}">
                                <div class="absolute top-3 left-3 bg-yellow-400 text-white text-xs font-bold px-2 py-1 rounded-full z-10 flex items-center gap-1">
                                    <i data-lucide="star" class="w-3 h-3"></i>
                                    Chính
                                </div>
                            </c:if>
                            <div class="image-preview-actions">
                                <c:if test="${!image.isPrimary}">
                                    <button type="button" class="bg-green-500 hover:bg-green-600 text-white rounded-full p-2 shadow-lg transition-colors" 
                                            onclick="setPrimaryImage(${image.imageId})" 
                                            title="Đặt làm ảnh chính">
                                        <i data-lucide="star" class="w-4 h-4"></i>
                                    </button>
                                </c:if>
                                <button type="button" class="bg-red-500 hover:bg-red-600 text-white rounded-full p-2 shadow-lg transition-colors" 
                                        onclick="deleteImage(${image.imageId})" 
                                        title="Xóa ảnh">
                                    <i data-lucide="trash-2" class="w-4 h-4"></i>
                                </button>
                            </div>
                            <a href="javascript:void(0);" onclick="showImageModal('${pageContext.request.contextPath}/image?type=service&name=${fn:substringAfter(image.url, '/services/')}')" 
                               class="block relative overflow-hidden">
                                <img src="${pageContext.request.contextPath}/image?type=service&name=${fn:substringAfter(image.url, '/services/')}" 
                                     alt="${image.altText}" 
                                     onerror="this.src='${pageContext.request.contextPath}/assets/images/no-image.png'" 
                                     class="w-full h-48 object-cover cursor-pointer hover:scale-105 transition-transform duration-300" />
                                <div class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-20 transition-all duration-300 flex items-center justify-center">
                                    <i data-lucide="zoom-in" class="w-8 h-8 text-white opacity-0 group-hover:opacity-100 transition-opacity duration-300"></i>
                                </div>
                            </a>
                            <div class="image-preview-info">
                                <div class="flex justify-between items-center text-xs text-gray-500">
                                    <span>
                                        <c:if test="${image.fileSize != null}">
                                            <fmt:formatNumber value="${image.fileSize / 1024}" maxFractionDigits="1" />KB
                                        </c:if>
                                    </span>
                                    <span class="flex items-center gap-1">
                                        <i data-lucide="hash" class="w-3 h-3"></i>
                                        ${image.sortOrder}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <c:if test="${not empty existingImages}">
                    <div class="mt-6 p-4 bg-blue-50 rounded-lg">
                        <div class="flex items-center gap-2 text-blue-700 text-sm">
                            <i data-lucide="info" class="w-4 h-4"></i>
                            <span>Kéo ảnh để sắp xếp lại thứ tự hiển thị</span>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>
</main>
</div>

<!-- Modal xem ảnh lớn -->
<div id="imageModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-80 hidden">
    <div class="relative max-w-[90vw] max-h-[90vh]">
        <button id="closeModal" class="absolute -top-12 right-0 text-white text-4xl hover:text-gray-300 transition-colors">
            <i data-lucide="x" class="w-8 h-8"></i>
        </button>
        <img id="modalImg" src="" class="max-h-[90vh] max-w-[90vw] rounded-xl shadow-2xl border-4 border-white object-contain" />
    </div>
</div>

<!-- Provide page-specific variables and load external JS -->
<script>
    window.contextPath = '${pageContext.request.contextPath}';
    window.serviceId = ${service.serviceId};
</script>
<script src="<c:url value='/js/single-image-upload.js'/>"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        if (window.lucide) lucide.createIcons();
        
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
    });
</script>

</body>
</html>
