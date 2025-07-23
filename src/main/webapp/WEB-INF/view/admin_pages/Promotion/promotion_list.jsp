<%--
    Document   : promotion_list
    Created on : Jun 11, 2025
    Author     : Admin
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách khuyến mãi</title>
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
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        /* Thêm style để con trỏ chuột biến thành hình bàn tay khi di chuột qua tiêu đề bảng */
        .sortable-header {
            cursor: pointer;
        }
        .sortable-header:hover {
            color: #B8941F; /* primary-dark */
        }
    </style>
</head>
<body class="bg-spa-cream font-sans">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
                    <h1 class="text-3xl font-serif text-spa-dark font-bold">Danh sách khuyến mãi</h1>
                    <div class="flex gap-2">
                        <a href="${pageContext.request.contextPath}/promotion/create" 
                           class="flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors">
                            <i data-lucide="plus" class="w-4 h-4"></i>
                            Thêm khuyến mãi
                        </a>
                    </div>
                </div>

                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg">
                        <div class="flex items-center">
                            <i data-lucide="check-circle" class="w-5 h-5 text-green-600 mr-2"></i>
                            <span class="text-green-700">${sessionScope.successMessage}</span>
                        </div>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
                        <div class="flex items-center">
                            <i data-lucide="alert-circle" class="w-5 h-5 text-red-600 mr-2"></i>
                            <span class="text-red-700">${sessionScope.errorMessage}</span>
                        </div>
                    </div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <div class="bg-white rounded-lg shadow-md p-6 mb-8">
                    <form method="GET" action="${pageContext.request.contextPath}/promotion/list" class="space-y-4">
                        <div class="flex flex-wrap gap-4">
                            <div class="flex-1 min-w-64">
                                <label for="searchValue" class="block text-sm font-medium text-gray-700 mb-2">Tìm kiếm khuyến mãi</label>
                                <input type="text" id="searchValue" name="searchValue" value="${searchValue}" placeholder="Tên khuyến mãi, mã khuyến mãi..."
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary">
                            </div>
                            <div class="min-w-48">
                                <label for="status" class="block text-sm font-medium text-gray-700 mb-2">Trạng thái</label>
                                <select name="status" id="status" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Đang áp dụng</option>
                                    <option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>Ngừng áp dụng</option>
                                    <option value="SCHEDULED" ${status == 'SCHEDULED' ? 'selected' : ''}>Lên lịch</option>
                                </select>
                            </div>
                            <div class="min-w-32">
                                <label for="sortBy" class="block text-sm font-medium text-gray-700 mb-2">Sắp xếp theo</label>
                                <select name="sortBy" id="sortBy" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary" onchange="this.form.submit()">
                                    <option value="id" ${sortBy == 'id' ? 'selected' : ''}>ID</option>
                                    <option value="title" ${sortBy == 'title' ? 'selected' : ''}>Tên khuyến mãi</option>
                                    <option value="code" ${sortBy == 'code' ? 'selected' : ''}>Mã</option>
                                    <option value="discount_value" ${sortBy == 'discount_value' ? 'selected' : ''}>Giảm giá</option>
                                    <option value="status" ${sortBy == 'status' ? 'selected' : ''}>Trạng thái</option>
                                </select>
                            </div>
                            <div class="min-w-24">
                                <label for="sortOrder" class="block text-sm font-medium text-gray-700 mb-2">Chiều</label>
                                <select name="sortOrder" id="sortOrder" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary" onchange="this.form.submit()">
                                    <option value="asc" ${sortOrder == 'asc' ? 'selected' : ''}>Tăng dần</option>
                                    <option value="desc" ${sortOrder == 'desc' ? 'selected' : ''}>Giảm dần</option>
                                </select>
                            </div>
                            <div class="min-w-24">
                                <label for="pageSize" class="block text-sm font-medium text-gray-700 mb-2">Hiển thị</label>
                                <select name="pageSize" id="pageSize" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary">
                                    <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                    <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                </select>
                            </div>
                            <div class="flex items-end">
                                <button type="submit" class="px-6 py-2 bg-primary text-white rounded-md hover:bg-primary-dark transition-colors">
                                    <i data-lucide="search" class="w-4 h-4 inline mr-2"></i>Tìm kiếm
                                </button>
                            </div>
                            <div class="flex items-end">
                                <a href="${pageContext.request.contextPath}/promotion/list" class="px-6 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-600 transition-colors">
                                    <i data-lucide="refresh-cw" class="w-4 h-4 inline mr-2"></i>Làm mới
                                </a>
                            </div>
                        </div>
                        <input type="hidden" name="page" value="1">
                    </form>
                </div>

                <div class="bg-white rounded-lg shadow-md overflow-hidden">
                    <c:choose>
                        <c:when test="${not empty listPromotion}">
                            <div class="px-6 py-4 border-b border-gray-200">
                                <h3 class="text-lg font-semibold text-gray-900">
                                    Danh sách khuyến mãi
                                    <span class="text-sm font-normal text-gray-500 ml-2">(${fn:length(listPromotion)} khuyến mãi trên trang ${currentPage}/${totalPages})</span>
                                </h3>
                            </div>
                            <div class="overflow-x-auto">
                                <table class="w-full">
                                    <thead class="bg-gray-50">
                                        <tr>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider sortable-header">Khuyến mãi</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider sortable-header">Mã</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider sortable-header">Giảm giá</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider sortable-header">Trạng thái</th>
                                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody class="bg-white divide-y divide-gray-200">
                                        <c:forEach var="promotion" items="${listPromotion}">
                                            <tr class="hover:bg-gray-50">
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <div class="flex items-center">
                                                        <c:choose>
                                                          <c:when test="${not empty promotion.imageUrl}">
                                                            <div class="h-10 w-10 flex-shrink-0">
                                                              <img class="h-10 w-10 rounded-lg object-cover" src="${pageContext.request.contextPath}${promotion.imageUrl}" alt="${promotion.title}">
                                                            </div>
                                                          </c:when>
                                                          <c:otherwise>
                                                            <div class="h-10 w-10 flex-shrink-0 bg-gray-200 rounded-lg flex items-center justify-center">
                                                              <i data-lucide="gift" class="w-5 h-5 text-gray-400"></i>
                                                            </div>
                                                          </c:otherwise>
                                                        </c:choose>
                                                        <div class="ml-4">
                                                            <div class="text-sm font-medium text-gray-900">${promotion.title}</div>
                                                            <div class="text-sm text-gray-500">
                                                                <c:if test="${not empty promotion.description}">
                                                                    ${fn:length(promotion.description) > 50 ? fn:substring(promotion.description, 0, 50) : promotion.description}
                                                                    <c:if test="${fn:length(promotion.description) > 50}">...</c:if>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">${promotion.promotionCode}</span>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                                    <c:choose>
                                                        <c:when test="${promotion.discountType == 'PERCENTAGE'}">${promotion.discountValue}%</c:when>
                                                        <c:otherwise><fmt:formatNumber value="${promotion.discountValue}" type="currency" currencySymbol="₫"/></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap">
                                                    <c:choose>
                                                        <c:when test="${promotion.status == 'ACTIVE'}">
                                                          <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">Đang áp dụng</span>
                                                        </c:when>
                                                        <c:when test="${promotion.status == 'SCHEDULED'}">
                                                          <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">Lên lịch</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                          <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">Không hoạt động</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                                    <div class="flex items-center justify-center gap-2">
                                                        <a href="${pageContext.request.contextPath}/promotion/view?id=${promotion.promotionId}" class="p-2 bg-blue-100 hover:bg-blue-200 text-blue-700 rounded-full transition-colors" title="Xem chi tiết">
                                                            <i data-lucide="eye" class="w-5 h-5"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/promotion/edit?id=${promotion.promotionId}" class="p-2 bg-green-100 hover:bg-green-200 text-green-700 rounded-full transition-colors" title="Chỉnh sửa">
                                                            <i data-lucide="edit" class="w-5 h-5"></i>
                                                        </a>
                                                        <c:choose>
                                                            <c:when test="${promotion.status == 'ACTIVE'}">
                                                                <c:url var="deactivateUrl" value="/promotion/deactivate">
                                                                     <c:param name="id" value="${promotion.promotionId}" /><c:param name="page" value="${currentPage}" /><c:param name="searchValue" value="${searchValue}" /><c:param name="status" value="${status}" />
                                                                </c:url>
                                                                <a href="${deactivateUrl}" onclick="confirmAction(event, this.href, 'Bạn muốn tắt khuyến mãi này?')" class="p-2 bg-red-100 hover:bg-red-200 text-red-700 rounded-full transition-colors" title="Tắt">
                                                                     <i data-lucide="ban" class="w-5 h-5"></i>
                                                                </a>
                                                            </c:when>
                                                            <c:when test="${promotion.status == 'INACTIVE' || promotion.status == 'SCHEDULED'}">
                                                                <c:url var="activateUrl" value="/promotion/activate">
                                                                     <c:param name="id" value="${promotion.promotionId}" /><c:param name="page" value="${currentPage}" /><c:param name="searchValue" value="${searchValue}" /><c:param name="status" value="${status}" />
                                                                </c:url>
                                                                <a href="${activateUrl}" onclick="confirmAction(event, this.href, 'Bạn muốn kích hoạt khuyến mãi này?')" class="p-2 bg-green-100 hover:bg-green-200 text-green-700 rounded-full transition-colors" title="Kích hoạt">
                                                                     <i data-lucide="refresh-ccw" class="w-5 h-5"></i>
                                                                </a>
                                                            </c:when>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                    
                                    <div class="flex justify-end mb-2">
                                <c:if test="${totalPages > 1}">
                                    <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
                                        <c:if test="${currentPage > 1}">
                                            <c:url var="pageUrl" value="/promotion/list"><c:param name="page" value="${currentPage - 1}"/><c:param name="searchValue" value="${searchValue}"/><c:param name="status" value="${status}"/><c:param name="pageSize" value="${pageSize}"/><c:param name="sortBy" value="${sortBy}"/><c:param name="sortOrder" value="${sortOrder}"/></c:url>
                                            <a href="${pageUrl}" class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                                <i data-lucide="chevron-left" class="w-5 h-5"></i>
                                            </a>
                                        </c:if>
                                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                            <c:choose>
                                                <c:when test="${pageNum == currentPage}">
                                                    <span class="relative inline-flex items-center px-4 py-2 border border-primary bg-primary text-sm font-medium text-white">${pageNum}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:url var="pageUrl" value="/promotion/list"><c:param name="page" value="${pageNum}"/><c:param name="searchValue" value="${searchValue}"/><c:param name="status" value="${status}"/><c:param name="pageSize" value="${pageSize}"/><c:param name="sortBy" value="${sortBy}"/><c:param name="sortOrder" value="${sortOrder}"/></c:url>
                                                    <a href="${pageUrl}" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">${pageNum}</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <c:if test="${currentPage < totalPages}">
                                            <c:url var="pageUrl" value="/promotion/list"><c:param name="page" value="${currentPage + 1}"/><c:param name="searchValue" value="${searchValue}"/><c:param name="status" value="${status}"/><c:param name="pageSize" value="${pageSize}"/><c:param name="sortBy" value="${sortBy}"/><c:param name="sortOrder" value="${sortOrder}"/></c:url>
                                            <a href="${pageUrl}" class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                                <i data-lucide="chevron-right" class="w-5 h-5"></i>
                                            </a>
                                        </c:if>
                                    </nav>
                                </c:if>
                            </div>
                                </table>
                            </div>

                         
                        </c:when>
                        <c:otherwise>
                            <div class="p-8 text-center">
                                <i data-lucide="gift" class="w-16 h-16 text-gray-400 mx-auto mb-4"></i>
                                <h3 class="text-lg font-medium text-gray-900 mb-2">Không có khuyến mãi</h3>
                                <p class="text-gray-500">Hiện tại không có khuyến mãi nào phù hợp với bộ lọc.</p>
                                <div class="mt-4">
                                    <a href="${pageContext.request.contextPath}/promotion/create" class="inline-flex items-center px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors">
                                        <i data-lucide="plus" class="w-4 h-4 mr-2"></i>Tạo khuyến mãi đầu tiên
                                    </a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    
    <script>
        if (window.lucide) lucide.createIcons();

        function confirmAction(event, url, message) {
            event.preventDefault();
            Swal.fire({
                title: 'Bạn có chắc chắn?',
                text: message,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#D4AF37',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Đồng ý',
                cancelButtonText: 'Hủy bỏ'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = url;
                }
            });
        }

        document.getElementById('pageSize').addEventListener('change', function() {
            this.form.submit();
        });
    </script>
</body>
</html>