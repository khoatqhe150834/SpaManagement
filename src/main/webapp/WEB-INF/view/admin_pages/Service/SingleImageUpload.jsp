<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">

<head>
    <meta charset="UTF-8">
    <title>Upload Images - ${service.name}</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              primary: "#D4AF37",
              "primary-dark": "#B8941F",
              secondary: "#FADADD",
              cream: "#FFF8F0",
              dark: "#333333"
            },
            fontFamily: {
              serif: ["Playfair Display", "serif"],
              sans: ["Roboto", "sans-serif"]
            }
          }
        }
      }
    </script>

    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <!-- Iconify Icons -->
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>

    <!-- Site-wide custom CSS -->
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />

    <!-- Add Google Fonts to match public site -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        /* Utility replacements for bootstrap-like classes used in markup */
        .card { @apply bg-white rounded-lg shadow-md; }
        .card-header { @apply border-b border-gray-200 mb-4 pb-2 flex justify-between items-center; }
        .card-body { @apply p-4; }
        .btn { @apply inline-flex items-center justify-center font-semibold rounded transition-all duration-200; }
        .btn-primary { @apply bg-primary text-white hover:bg-primary-dark; padding:0.5rem 1rem; }
        .btn-outline-primary { @apply border border-primary text-primary hover:bg-primary hover:text-white; padding:0.5rem 1rem; }
        .btn-icon { @apply w-8 h-8 rounded-full flex items-center justify-center text-white; }
        .bg-success { background-color: theme('colors.primary'); }
        .bg-danger { background-color: #dc3545; }
        .alert { @apply rounded p-3 text-sm mt-2; }
        .alert-success { @apply bg-green-100 text-green-700; }
        .alert-danger  { @apply bg-red-100 text-red-700; }
        .alert-warning { @apply bg-yellow-100 text-yellow-700; }
        .fw-semibold { font-weight: 600; }

        /* Consistent color scheme with public site */
        :root {
            --primary-color: #D4AF37; /* Gold tone used in index.jsp */
            --primary-dark: #B8941F;
        }

        body {
            font-family: 'Roboto', sans-serif;
        }
        h1, h2, h3, h4, h5, h6 {
            font-family: 'Playfair Display', serif;
        }

        /* Override component colors to use primary palette */
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
            border-color: var(--primary-color);
            background: #fff8f0; /* light cream */
        }
        .image-upload-zone.dragover {
            border-color: var(--primary-color);
            background: #fff3e0;
        }

        /* Progress bar */
        .progress-fill {
            background: var(--primary-color);
        }

        /* Primary badge on selected image */
        .primary-badge {
            background: var(--primary-color);
        }

        /* Success icon buttons -> use primary palette */
        .btn-icon.bg-success {
            background: var(--primary-color) !important;
        }

        /* Hover state for the success button */
        .btn-icon.bg-success:hover {
            background: var(--primary-dark) !important;
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
        
        .sortable-placeholder {
            background: #f0f0f0;
            border: 2px dashed #ccc;
            margin: 10px;
            height: 150px;
        }
    </style>
</head>

<body class="bg-cream min-h-screen">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <div class="max-w-7xl mx-auto px-4 mb-8">
        <div class="flex flex-wrap items-center justify-between gap-3">
            <h2 class="text-3xl font-serif">Upload Images - ${service.name}</h2>
            <a href="${pageContext.request.contextPath}/manager/service" class="text-primary hover:text-primary-dark flex items-center font-semibold">
                <i data-lucide="home" class="w-5 h-5 mr-1"></i>
                Service Management
            </a>
        </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 grid grid-cols-1 lg:grid-cols-2 gap-8">
        <!-- Upload Section -->
        <div>
            <div class="card">
                <div class="card-header">
                    <h3 class="text-xl font-semibold">Upload New Images</h3>
                </div>
                <div class="card-body">
                    <div class="image-upload-zone" id="uploadZone">
                        <iconify-icon icon="solar:cloud-upload-outline" class="text-primary text-6xl mb-16"></iconify-icon>
                        <h6 class="text-md fw-semibold text-primary-light mb-8">Drag & Drop Images Here</h6>
                        <p class="text-sm text-secondary-light mb-16">or click to browse files</p>
                        <input type="file" id="imageInput" multiple accept="image/*" style="display: none;">
                        <button id="chooseFilesBtn" type="button" class="btn btn-primary btn-sm">
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
        <div>
            <div class="card">
                <div class="card-header">
                    <h3 class="text-xl font-semibold">Existing Images (${existingImages.size()})</h3>
                    <button type="button" class="btn btn-outline-primary ml-auto" onclick="refreshImages()">
                        <i data-lucide="refresh-ccw" class="w-4 h-4 mr-1"></i>
                        Refresh
                    </button>
                </div>
                <div class="card-body">
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

    <!-- Provide page-specific variables and load external JS -->
    <script>
        window.contextPath = '${pageContext.request.contextPath}';
        window.serviceId = ${service.serviceId};
    </script>
    <script src="<c:url value='/js/single-image-upload.js'/>"></script>

</body>

</html>
