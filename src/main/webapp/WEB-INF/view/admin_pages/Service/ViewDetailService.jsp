<%-- 
    Document   : ViewDetailService
    Created on : Jun 20, 2025, 11:24:09 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết dịch vụ - ${service.name}</title>
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
              "spa-cream": "#FFF8F0",
              "spa-dark": "#333333",
            },
            fontFamily: {
              serif: ["Playfair Display", "serif"],
              sans: ["Roboto", "sans-serif"],
            },
          },
        },
      };
    </script>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>
<body class="bg-spa-cream font-sans min-h-screen">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Heading -->
                <h1 class="text-4xl font-serif font-bold text-spa-dark mb-8">Chi tiết dịch vụ</h1>
                <!-- Card -->
                <div class="bg-white rounded-2xl shadow-lg p-8">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <!-- Left: Thông tin dịch vụ -->
                        <div>
                            <h1 class="text-3xl font-serif font-bold text-spa-dark mb-1">${service.name}</h1>
                            <c:choose>
                                <c:when test="${service.isActive}">
                                    <span class="inline-block bg-green-100 text-green-800 text-xs font-medium px-3 py-1 rounded-full mb-2">Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="inline-block bg-red-100 text-red-800 text-xs font-medium px-3 py-1 rounded-full mb-2">Inactive</span>
                                </c:otherwise>
                            </c:choose>
                            <div class="text-gray-500 text-sm mb-4">Loại dịch vụ: <span class="text-primary font-semibold">${service.serviceTypeId.name}</span></div>
                            <div class="mb-6">
                                <h2 class="font-semibold text-gray-700 mb-2">Mô tả</h2>
                                <p class="text-gray-600 whitespace-pre-line break-words word-break break-all max-w-full overflow-x-auto">${service.description}</p>
                            </div>
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-6">
                                <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                    <i data-lucide="tag" class="w-6 h-6 text-primary"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Giá dịch vụ</div>
                                        <div class="font-semibold text-gray-800"><fmt:formatNumber value="${service.price}" type="number" maxFractionDigits="0" /> VND</div>
                                    </div>
                                </div>
                                <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                    <i data-lucide="clock" class="w-6 h-6 text-primary"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Thời lượng</div>
                                        <div class="font-semibold text-gray-800">${service.durationMinutes} phút</div>
                                    </div>
                                </div>
                                <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                    <i data-lucide="history" class="w-6 h-6 text-primary"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Thời gian chờ</div>
                                        <div class="font-semibold text-gray-800">${service.bufferTimeAfterMinutes} phút</div>
                                    </div>
                                </div>
                                <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                    <i data-lucide="star" class="w-6 h-6 text-yellow-400"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Đánh giá</div>
                                        <div class="flex items-center gap-1 font-semibold text-gray-800">
                                            <c:set var="fullStars" value="${service.averageRating.intValue()}" />
                                            <c:forEach begin="1" end="${fullStars}">
                                                <i data-lucide="star" class="w-4 h-4 text-yellow-400 fill-yellow-400"></i>
                                            </c:forEach>
                                            <c:forEach begin="${fullStars + 1}" end="5">
                                                <i data-lucide="star" class="w-4 h-4 text-gray-300"></i>
                                            </c:forEach>
                                            <span class="ml-2 text-xs text-gray-500">(${service.averageRating})</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Right: Hình ảnh dịch vụ -->
                        <div>
                            <c:choose>
                                <c:when test="${not empty serviceImages}">
                                    <c:choose>
                                        <c:when test="${not empty serviceImages[0].url && fn:startsWith(serviceImages[0].url, 'http')}">
                                            <img src="${serviceImages[0].url}" alt="Service Image" class="w-full h-72 object-cover rounded-xl shadow mb-4 hover:scale-105 transition-transform duration-200" id="mainImage" style="cursor: zoom-in;" />
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/image?type=service&name=${fn:substringAfter(serviceImages[0].url, '/services/')}" alt="Service Image" class="w-full h-72 object-cover rounded-xl shadow mb-4 hover:scale-105 transition-transform duration-200" id="mainImage" style="cursor: zoom-in;" />
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="grid grid-cols-4 gap-2">
                                        <c:forEach var="img" items="${serviceImages}" varStatus="loop">
                                            <div class="relative">
                                                <c:choose>
                                                    <c:when test="${not empty img.url && fn:startsWith(img.url, 'http')}">
                                                        <img src="${img.url}" alt="Thumbnail" class="w-full h-16 object-cover rounded shadow cursor-pointer hover:scale-105 transition-transform duration-200 border-2 border-transparent" onclick="changeImage(this.src, this)" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/image?type=service&name=${fn:substringAfter(img.url, '/services/')}" alt="Thumbnail" class="w-full h-16 object-cover rounded shadow cursor-pointer hover:scale-105 transition-transform duration-200 border-2 border-transparent" onclick="changeImage(this.src, this)" />
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:if test="${img.isPrimary}">
                                                    <div class="absolute top-1 left-1 bg-yellow-400 text-white text-xs font-bold px-2 py-1 rounded-full z-10 flex items-center gap-1" title="Ảnh chính">
                                                        <i data-lucide="star" class="w-3 h-3"></i>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="flex items-center justify-center h-72 border rounded-xl bg-gray-50">
                                        <span class="text-gray-400">Chưa có hình ảnh</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <!-- Footer buttons -->
                    <div class="flex flex-col sm:flex-row justify-between items-center gap-3 mt-8">
                        <a href="service?service=list-all&page=${param.page}&limit=${param.limit}${not empty param.keyword ? '&keyword='.concat(param.keyword) : ''}${not empty param.status ? '&status='.concat(param.status) : ''}${not empty param.serviceTypeId ? '&serviceTypeId='.concat(param.serviceTypeId) : ''}" class="inline-flex items-center gap-2 px-6 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition">
                            <i data-lucide="arrow-left" class="w-5 h-5"></i> Quay lại
                        </a>
                        <a href="service?service=pre-update&id=${service.serviceId}&page=${page}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}" class="inline-flex items-center gap-2 px-6 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition">
                            <i data-lucide="edit" class="w-5 h-5"></i> Chỉnh sửa dịch vụ
                        </a>
                    </div>
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
    <script>
        function changeImage(src, thumbElement) {
            const mainImg = document.getElementById('mainImage');
            mainImg.src = src;
            // Highlight selected thumbnail
            document.querySelectorAll('.grid img').forEach(thumb => thumb.classList.remove('border-primary'));
            thumbElement.classList.add('border-primary');
        }
        function showImageModal(src) {
            document.getElementById('modalImg').src = src;
            document.getElementById('imageModal').classList.remove('hidden');
        }
        // Chỉ mở modal khi click vào ảnh lớn
        document.addEventListener('DOMContentLoaded', function() {
            if (window.lucide) lucide.createIcons();
            const mainImg = document.getElementById('mainImage');
            if (mainImg) {
                mainImg.onclick = function() {
                    showImageModal(this.src);
                };
            }
            // Mặc định chọn thumbnail đầu tiên
            const thumbs = document.querySelectorAll('.grid img');
            if (thumbs.length > 0) thumbs[0].classList.add('border-primary');
        });
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
    </script>
</body>
</html>
