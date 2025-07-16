<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Ảnh Dịch Vụ</title>
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
<div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
        <a href="${pageContext.request.contextPath}/manager/service" class="flex items-center gap-1 hover:text-primary">
            <i data-lucide="list" class="w-4 h-4"></i>
            Danh sách dịch vụ
        </a>
        <span>-</span>
        <span class="text-primary font-semibold">Quản lý ảnh dịch vụ</span>
    </div>
    <div class="bg-white rounded-2xl shadow-lg p-8">
        <h1 class="text-2xl font-serif font-bold text-spa-dark mb-6 flex items-center gap-2"><i data-lucide="gallery-horizontal" class="w-6 h-6"></i> Quản Lý Ảnh Dịch Vụ</h1>
        <!-- Filter section -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8 items-center">
            <div class="flex items-center gap-3">
                <label for="serviceFilter" class="font-medium text-gray-700">Lọc theo dịch vụ:</label>
                <select id="serviceFilter" class="border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary" onchange="filterByService()">
                    <option value="">Tất cả dịch vụ</option>
                    <c:forEach var="serviceItem" items="${services}">
                        <option value="${serviceItem.serviceId}" <c:if test="${service != null && service.serviceId == serviceItem.serviceId}">selected</c:if>>
                            ${serviceItem.name}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="flex justify-end gap-2">
                <a href="${pageContext.request.contextPath}/manager/service-images/single-upload?serviceId=${service != null ? service.serviceId : ''}" class="inline-flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition" <c:if test="${service == null}">onclick="return selectServiceFirst()"</c:if>>
                    <i data-lucide="upload" class="w-5 h-5"></i> Upload Ảnh
                </a>
                <a href="${pageContext.request.contextPath}/manager/service-images/batch-upload" class="inline-flex items-center gap-2 px-4 py-2 bg-purple-100 text-purple-800 rounded-lg hover:bg-purple-200 transition">
                    <i data-lucide="cloud-upload" class="w-5 h-5"></i> Batch Upload
                </a>
            </div>
        </div>
        <!-- Service Images Display -->
        <c:choose>
            <c:when test="${service != null}">
                <!-- Single Service View -->
                <div class="bg-gray-50 rounded-xl shadow p-6 mb-8">
                    <div class="flex flex-wrap items-center justify-between mb-4">
                        <div>
                            <h2 class="text-lg font-semibold text-spa-dark mb-1">${service.name}</h2>
                            <div class="flex gap-4 text-gray-500 text-sm">
                                <span><i data-lucide="gallery-horizontal" class="inline w-4 h-4 mr-1"></i>${images.size()} ảnh</span>
                                <c:set var="primaryCount" value="0"/>
                                <c:forEach var="img" items="${images}">
                                    <c:if test="${img.isPrimary}"><c:set var="primaryCount" value="${primaryCount + 1}"/></c:if>
                                </c:forEach>
                                <span><i data-lucide="star" class="inline w-4 h-4 mr-1 text-yellow-400"></i>${primaryCount} chính</span>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/manager/service-images/single-upload?serviceId=${service.serviceId}" class="inline-flex items-center gap-2 px-3 py-1 bg-primary text-white rounded hover:bg-primary-dark transition text-sm">
                            <i data-lucide="plus" class="w-4 h-4"></i> Thêm ảnh
                        </a>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${empty images}">
                                <div class="text-center py-8 text-gray-400">
                                    <i data-lucide="image-off" class="w-12 h-12 mx-auto mb-2"></i>
                                    <p>Chưa có ảnh nào cho dịch vụ này</p>
                                    <a href="${pageContext.request.contextPath}/manager/service-images/single-upload?serviceId=${service.serviceId}" class="inline-flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition mt-2">
                                        <i data-lucide="upload" class="w-5 h-5"></i> Upload Ảnh
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                                    <c:forEach var="image" items="${images}">
                                        <div class="relative group bg-white border rounded-lg overflow-hidden shadow">
                                            <c:if test="${image.isPrimary}">
                                                <div class="absolute top-2 left-2 bg-yellow-400 text-white text-xs font-bold px-2 py-1 rounded">Chính</div>
                                            </c:if>
                                            <a href="javascript:void(0);" onclick="viewImageFullSize('${pageContext.request.contextPath}/image?type=service&name=${fn:substringAfter(image.url, '/services/')}')">
                                                <img src="${pageContext.request.contextPath}/image?type=service&name=${fn:substringAfter(image.url, '/services/')}" alt="${image.altText}" class="w-full h-36 object-cover cursor-pointer hover:scale-105 transition-transform duration-200" />
                                            </a>
                                            <div class="absolute top-2 right-2 flex gap-1 opacity-0 group-hover:opacity-100 transition">
                                                <c:if test="${!image.isPrimary}">
                                                    <button type="button" class="bg-green-500 hover:bg-green-600 text-white rounded-full p-1" onclick="setPrimaryImage('${image.imageId}', '${service.serviceId}')" title="Đặt làm chính"><i data-lucide="star" class="w-4 h-4"></i></button>
                                                </c:if>
                                                <button type="button" class="bg-red-500 hover:bg-red-600 text-white rounded-full p-1" onclick="deleteImage('${image.imageId}')" title="Xóa ảnh"><i data-lucide="trash-2" class="w-4 h-4"></i></button>
                                            </div>
                                            <div class="px-2 py-1 text-xs text-gray-500 flex justify-between">
                                                <span><c:if test="${image.fileSize != null}"><fmt:formatNumber value="${image.fileSize / 1024}" maxFractionDigits="1" />KB</c:if></span>
                                                <span>Thứ tự: ${image.sortOrder}</span>
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
                        <div class="text-center py-8 text-gray-400">
                            <i data-lucide="image-off" class="w-12 h-12 mx-auto mb-2"></i>
                            <p>Không tìm thấy dịch vụ nào</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="grid grid-cols-1 gap-6">
                            <c:forEach var="serviceItem" items="${services}">
                                <c:set var="serviceImages" value="${serviceImageDAO.findByServiceId(serviceItem.serviceId)}"/>
                                <div class="bg-gray-50 rounded-xl shadow p-6">
                                    <div class="flex flex-wrap items-center justify-between mb-4">
                                        <div>
                                            <h2 class="text-lg font-semibold text-spa-dark mb-1">${serviceItem.name}</h2>
                                            <div class="flex gap-4 text-gray-500 text-sm">
                                                <span><i data-lucide="gallery-horizontal" class="inline w-4 h-4 mr-1"></i>${serviceImages.size()} ảnh</span>
                                            </div>
                                        </div>
                                        <div class="flex gap-2">
                                            <a href="${pageContext.request.contextPath}/manager/service-images/manage?serviceId=${serviceItem.serviceId}" class="inline-flex items-center gap-2 px-3 py-1 bg-blue-100 text-blue-800 rounded hover:bg-blue-200 transition text-sm"><i data-lucide="settings" class="w-4 h-4"></i> Quản lý</a>
                                            <a href="${pageContext.request.contextPath}/manager/service-images/single-upload?serviceId=${serviceItem.serviceId}" class="inline-flex items-center gap-2 px-3 py-1 bg-primary text-white rounded hover:bg-primary-dark transition text-sm"><i data-lucide="plus" class="w-4 h-4"></i> Thêm ảnh</a>
                                        </div>
                                    </div>
                                    <c:if test="${not empty serviceImages}">
                                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                                            <c:forEach var="image" items="${serviceImages}" end="5">
                                                <div class="relative group bg-white border rounded-lg overflow-hidden shadow">
                                                    <c:if test="${image.isPrimary}">
                                                        <div class="absolute top-2 left-2 bg-yellow-400 text-white text-xs font-bold px-2 py-1 rounded">Chính</div>
                                                    </c:if>
                                                    <a href="javascript:void(0);" onclick="viewImageFullSize('${pageContext.request.contextPath}/image?type=service&name=${fn:substringAfter(image.url, '/services/')}')">
                                                        <img src="${pageContext.request.contextPath}/image?type=service&name=${fn:substringAfter(image.url, '/services/')}" alt="${image.altText}" class="w-full h-36 object-cover cursor-pointer hover:scale-105 transition-transform duration-200" />
                                                    </a>
                                                    <div class="absolute top-2 right-2 flex gap-1 opacity-0 group-hover:opacity-100 transition">
                                                        <!-- Không có nút thao tác ở view tổng hợp -->
                                                    </div>
                                                </div>
                                            </c:forEach>
                                            <c:if test="${serviceImages.size() > 6}">
                                                <div class="flex items-center justify-center bg-gray-100 rounded-lg cursor-pointer" onclick="location.href='${pageContext.request.contextPath}/manager/service-images/manage?serviceId=${serviceItem.serviceId}'">
                                                    <div class="text-center">
                                                        <i data-lucide="gallery-horizontal" class="w-8 h-8 text-gray-400 mb-2"></i>
                                                        <div class="text-gray-500">+${serviceImages.size() - 6} ảnh nữa</div>
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
</div>
</main>
</div>
<jsp:include page="/WEB-INF/view/common/footer.jsp" />
<!-- Modal xem ảnh lớn -->
<div id="imageModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-70 hidden">
    <span class="absolute top-4 right-8 text-white text-3xl cursor-pointer" id="closeModal">&times;</span>
    <img id="modalImg" src="" class="max-h-[80vh] max-w-[90vw] rounded-xl shadow-2xl border-4 border-white" />
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
        if (!confirm('Bạn có chắc chắn muốn xóa ảnh này không?')) {
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
