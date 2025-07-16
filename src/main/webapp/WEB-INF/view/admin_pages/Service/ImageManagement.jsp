<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Ảnh Dịch Vụ - Spa Hương Sen</title>
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
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
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
        <span class="text-primary font-semibold">Quản lý ảnh dịch vụ</span>
    </nav>

    <!-- Header Section -->
    <div class="bg-white rounded-2xl shadow-lg p-8 mb-8">
        <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6">
            <div>
                <h1 class="text-3xl font-serif font-bold text-spa-dark mb-2 flex items-center gap-3">
                    <i data-lucide="gallery-horizontal" class="w-8 h-8 text-primary"></i>
                    Quản Lý Ảnh Dịch Vụ
                </h1>
                <p class="text-gray-600">Quản lý và tổ chức ảnh cho các dịch vụ spa</p>
            </div>
            <div class="flex flex-wrap gap-3">
                <a href="${pageContext.request.contextPath}/manager/service" class="inline-flex items-center gap-2 px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
                    <i data-lucide="arrow-left" class="w-4 h-4"></i>
                    Quay về
                </a>
                <a href="${pageContext.request.contextPath}/manager/service-images/batch-upload" class="inline-flex items-center gap-2 px-4 py-2 bg-purple-100 text-purple-800 rounded-lg hover:bg-purple-200 transition-colors">
                    <i data-lucide="cloud-upload" class="w-5 h-5"></i>
                    Batch Upload
                </a>
            </div>
        </div>
    </div>

    <!-- Filter and Actions Section -->
    <div class="bg-white rounded-2xl shadow-lg p-8 mb-8">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 items-center">
            <div class="flex flex-col sm:flex-row items-start sm:items-center gap-4">
                <label for="serviceFilter" class="font-medium text-gray-700 whitespace-nowrap">Lọc theo dịch vụ:</label>
                <select id="serviceFilter" class="flex-1 border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-primary focus:border-primary transition-colors" onchange="filterByService()">
                    <option value="">Tất cả dịch vụ</option>
                    <c:forEach var="serviceItem" items="${services}">
                        <option value="${serviceItem.serviceId}" <c:if test="${service != null && service.serviceId == serviceItem.serviceId}">selected</c:if>>
                            ${serviceItem.name}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="flex flex-wrap gap-3 justify-end">
                <a href="${pageContext.request.contextPath}/manager/service-images/single-upload?serviceId=${service != null ? service.serviceId : ''}" 
                   class="inline-flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors shadow-sm" 
                   <c:if test="${service == null}">onclick="return selectServiceFirst()"</c:if>>
                    <i data-lucide="upload" class="w-5 h-5"></i>
                    Upload Ảnh
                </a>
            </div>
        </div>
    </div>

    <!-- Service Images Display -->
    <c:choose>
        <c:when test="${service != null}">
            <!-- Single Service View -->
            <div class="bg-white rounded-2xl shadow-lg p-8 mb-8">
                <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4 mb-6">
                    <div>
                        <h2 class="text-2xl font-serif font-bold text-spa-dark mb-2">${service.name}</h2>
                        <div class="flex flex-wrap gap-6 text-gray-600">
                            <span class="flex items-center gap-2">
                                <i data-lucide="gallery-horizontal" class="w-4 h-4"></i>
                                ${images.size()} ảnh
                            </span>
                            <c:set var="primaryCount" value="0"/>
                            <c:forEach var="img" items="${images}">
                                <c:if test="${img.isPrimary}"><c:set var="primaryCount" value="${primaryCount + 1}"/></c:if>
                            </c:forEach>
                            <span class="flex items-center gap-2">
                                <i data-lucide="star" class="w-4 h-4 text-yellow-400"></i>
                                ${primaryCount} ảnh chính
                            </span>
                        </div>
                    </div>
                    <div class="flex flex-wrap gap-3">
                        <a href="${pageContext.request.contextPath}/manager/service-images/single-upload?serviceId=${service.serviceId}" 
                           class="inline-flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors">
                            <i data-lucide="plus" class="w-4 h-4"></i>
                            Thêm ảnh
                        </a>
                        <button onclick="history.back()" class="inline-flex items-center gap-2 px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
                            <i data-lucide="arrow-left" class="w-4 h-4"></i>
                            Quay lại
                        </button>
                    </div>
                </div>
                
                <div>
                    <c:choose>
                        <c:when test="${empty images}">
                            <div class="text-center py-16 text-gray-400">
                                <i data-lucide="image-off" class="w-16 h-16 mx-auto mb-4 text-gray-300"></i>
                                <h3 class="text-lg font-semibold mb-2">Chưa có ảnh nào</h3>
                                <p class="mb-6">Dịch vụ này chưa có ảnh nào được tải lên</p>
                                <a href="${pageContext.request.contextPath}/manager/service-images/single-upload?serviceId=${service.serviceId}" 
                                   class="inline-flex items-center gap-2 px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors">
                                    <i data-lucide="upload" class="w-5 h-5"></i>
                                    Upload Ảnh Đầu Tiên
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-6">
                                <c:forEach var="image" items="${images}">
                                    <div class="relative group bg-white border border-gray-200 rounded-xl overflow-hidden shadow-sm hover:shadow-lg transition-all duration-300">
                                        <c:if test="${image.isPrimary}">
                                            <div class="absolute top-3 left-3 bg-yellow-400 text-white text-xs font-bold px-2 py-1 rounded-full z-10">
                                                <i data-lucide="star" class="w-3 h-3 inline mr-1"></i>
                                                Chính
                                            </div>
                                        </c:if>
                                        <a href="javascript:void(0);" onclick="viewImageFullSize('${pageContext.request.contextPath}/image?type=service&name=${fn:substringAfter(image.url, '/services/')}')" 
                                           class="block relative overflow-hidden">
                                            <img src="${pageContext.request.contextPath}/image?type=service&name=${fn:substringAfter(image.url, '/services/')}" 
                                                 alt="${image.altText}" 
                                                 class="w-full h-48 object-cover cursor-pointer hover:scale-105 transition-transform duration-300" />
                                            <div class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-20 transition-all duration-300 flex items-center justify-center">
                                                <i data-lucide="zoom-in" class="w-8 h-8 text-white opacity-0 group-hover:opacity-100 transition-opacity duration-300"></i>
                                            </div>
                                        </a>
                                        <div class="absolute top-3 right-3 flex gap-2 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                                            <c:if test="${!image.isPrimary}">
                                                <button type="button" class="bg-green-500 hover:bg-green-600 text-white rounded-full p-2 shadow-lg" 
                                                        onclick="setPrimaryImage('${image.imageId}', '${service.serviceId}')" 
                                                        title="Đặt làm ảnh chính">
                                                    <i data-lucide="star" class="w-4 h-4"></i>
                                                </button>
                                            </c:if>
                                            <button type="button" class="bg-red-500 hover:bg-red-600 text-white rounded-full p-2 shadow-lg" 
                                                    onclick="deleteImage('${image.imageId}')" 
                                                    title="Xóa ảnh">
                                                <i data-lucide="trash-2" class="w-4 h-4"></i>
                                            </button>
                                        </div>
                                        <div class="p-3">
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
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <!-- All Services View -->
            <c:choose>
                <c:when test="${empty services}">
                    <div class="bg-white rounded-2xl shadow-lg p-16 text-center">
                        <i data-lucide="image-off" class="w-16 h-16 mx-auto mb-4 text-gray-300"></i>
                        <h3 class="text-lg font-semibold mb-2">Không tìm thấy dịch vụ nào</h3>
                        <p class="text-gray-600 mb-6">Vui lòng tạo dịch vụ trước khi quản lý ảnh</p>
                        <a href="${pageContext.request.contextPath}/manager/service" 
                           class="inline-flex items-center gap-2 px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors">
                            <i data-lucide="plus" class="w-5 h-5"></i>
                            Tạo Dịch Vụ Mới
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="grid grid-cols-1 gap-8">
                        <c:forEach var="serviceItem" items="${services}">
                            <c:set var="serviceImages" value="${serviceImageDAO.findByServiceId(serviceItem.serviceId)}"/>
                            <div class="bg-white rounded-2xl shadow-lg p-8">
                                <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4 mb-6">
                                    <div>
                                        <h2 class="text-xl font-serif font-bold text-spa-dark mb-2">${serviceItem.name}</h2>
                                        <div class="flex flex-wrap gap-4 text-gray-600">
                                            <span class="flex items-center gap-2">
                                                <i data-lucide="gallery-horizontal" class="w-4 h-4"></i>
                                                ${serviceImages.size()} ảnh
                                            </span>
                                        </div>
                                    </div>
                                    <div class="flex flex-wrap gap-3">
                                        <a href="${pageContext.request.contextPath}/manager/service-images/manage?serviceId=${serviceItem.serviceId}" 
                                           class="inline-flex items-center gap-2 px-4 py-2 bg-blue-100 text-blue-800 rounded-lg hover:bg-blue-200 transition-colors">
                                            <i data-lucide="settings" class="w-4 h-4"></i>
                                            Quản lý
                                        </a>
                                        <a href="${pageContext.request.contextPath}/manager/service-images/single-upload?serviceId=${serviceItem.serviceId}" 
                                           class="inline-flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors">
                                            <i data-lucide="plus" class="w-4 h-4"></i>
                                            Thêm ảnh
                                        </a>
                                    </div>
                                </div>
                                <c:if test="${not empty serviceImages}">
                                    <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                                        <c:forEach var="image" items="${serviceImages}" end="5">
                                            <div class="relative group bg-white border border-gray-200 rounded-lg overflow-hidden shadow-sm hover:shadow-md transition-all duration-300">
                                                <c:if test="${image.isPrimary}">
                                                    <div class="absolute top-2 left-2 bg-yellow-400 text-white text-xs font-bold px-2 py-1 rounded-full z-10">
                                                        <i data-lucide="star" class="w-3 h-3"></i>
                                                    </div>
                                                </c:if>
                                                <a href="javascript:void(0);" onclick="viewImageFullSize('${pageContext.request.contextPath}/image?type=service&name=${fn:substringAfter(image.url, '/services/')}')" 
                                                   class="block relative overflow-hidden">
                                                    <img src="${pageContext.request.contextPath}/image?type=service&name=${fn:substringAfter(image.url, '/services/')}" 
                                                         alt="${image.altText}" 
                                                         class="w-full h-32 object-cover cursor-pointer hover:scale-105 transition-transform duration-300" />
                                                    <div class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-20 transition-all duration-300 flex items-center justify-center">
                                                        <i data-lucide="zoom-in" class="w-6 h-6 text-white opacity-0 group-hover:opacity-100 transition-opacity duration-300"></i>
                                                    </div>
                                                </a>
                                            </div>
                                        </c:forEach>
                                        <c:if test="${serviceImages.size() > 6}">
                                            <div class="flex items-center justify-center bg-gray-50 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer hover:bg-gray-100 transition-colors" 
                                                 onclick="location.href='${pageContext.request.contextPath}/manager/service-images/manage?serviceId=${serviceItem.serviceId}'">
                                                <div class="text-center p-4">
                                                    <i data-lucide="gallery-horizontal" class="w-8 h-8 text-gray-400 mb-2 mx-auto"></i>
                                                    <div class="text-gray-500 text-sm">+${serviceImages.size() - 6} ảnh nữa</div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:otherwise>
    </c:choose>
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
<script>
    if (window.lucide) lucide.createIcons();
    
    // Filter by service
    function filterByService() {
        const serviceId = document.getElementById('serviceFilter').value;
        if (serviceId) {
            window.location.href = '${pageContext.request.contextPath}/manager/service-images/manage?serviceId=' + serviceId;
        } else {
            window.location.href = '${pageContext.request.contextPath}/manager/service-images/manage';
        }
    }
    
    // Select service first alert
    function selectServiceFirst() {
        alert('Vui lòng chọn một dịch vụ từ danh sách lọc trước khi tải lên ảnh.');
        return false;
    }
    
    // Set primary image
    function setPrimaryImage(imageId, serviceId) {
        if (!confirm('Bạn có chắc chắn muốn đặt ảnh này làm ảnh chính không?')) {
            return;
        }
        
        fetch('${pageContext.request.contextPath}/manager/service-images/set-primary', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `imageId=${encodeURIComponent(imageId)}&serviceId=${encodeURIComponent(serviceId)}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                location.reload();
            } else {
                alert('Thất bại đặt ảnh chính: ' + data.error);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Lỗi khi đặt ảnh chính');
        });
    }
    
    // Delete image
    function deleteImage(imageId) {
        if (!confirm('Bạn có chắc chắn muốn xóa ảnh này không? Hành động này không thể hoàn tác.')) {
            return;
        }
        
        fetch('${pageContext.request.contextPath}/manager/service-images/delete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `imageId=${encodeURIComponent(imageId)}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                location.reload();
            } else {
                alert('Thất bại xóa ảnh: ' + data.error);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Lỗi khi xóa ảnh');
        });
    }
    
    document.addEventListener('DOMContentLoaded', function() {
        window.viewImageFullSize = function(src) {
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
        
        // Gán lại sự kiện click cho tất cả thẻ <a> có onclick gọi viewImageFullSize
        document.querySelectorAll('a[onclick^="viewImageFullSize"]').forEach(function(a) {
            a.addEventListener('click', function(e) {
                e.preventDefault();
                var src = this.getAttribute('onclick').match(/viewImageFullSize\('([^']+)'\)/);
                if (src && src[1]) window.viewImageFullSize(src[1]);
                return false;
            });
        });
    });
</script>
</body>
</html>
