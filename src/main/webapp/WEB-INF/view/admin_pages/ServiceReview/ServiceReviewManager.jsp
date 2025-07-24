<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Đánh Giá Dịch Vụ - Admin Dashboard</title>
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
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>
<body class="bg-spa-cream font-sans">
<jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
<jsp:include page="/WEB-INF/view/admin_pages/Common/Header.jsp" />
<div class="flex">
    <main class="w-full md:w-[calc(100%-256px)] md:ml-64 bg-spa-cream min-h-screen transition-all main">
        <div class="w-full mx-auto px-4 sm:px-6 lg:px-8 mt-8">
            <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
                <h1 class="text-3xl font-serif text-spa-dark font-bold">Danh Sách Đánh Giá Dịch Vụ</h1>
            </div>
            <div class="bg-white rounded-2xl shadow-lg">
                <!-- Card Header: Filters & Actions -->
                <div class="p-6 border-b border-gray-200 flex flex-wrap items-center justify-between gap-4">
                    <form class="flex flex-wrap items-center gap-3" method="get" action="${pageContext.request.contextPath}/manager/service-review">
                        <select class="w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300" name="limit" onchange="this.form.submit()">
                            <c:forEach var="i" begin="1" end="10">
                                <option value="${i}" ${limit==i ? 'selected' : ''}>${i}</option>
                            </c:forEach>
                        </select>
                        <input type="text" class="h-10 px-4 text-base placeholder-gray-600 border rounded-lg focus:shadow-outline" name="keyword" placeholder="Tìm kiếm đánh giá, khách hàng, dịch vụ..." value="${keyword}">
                        <select name="serviceId" class="w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300" style="min-width:220px;">
                            <option value="">Tất cả dịch vụ</option>
                            <c:forEach var="svc" items="${services}">
                                <option value="${svc.serviceId}" <c:if test="${serviceId == svc.serviceId}">selected</c:if>>
                                    ${svc.name}
                                </option>
                            </c:forEach>
                        </select>
                        <select name="replyStatus" class="w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300">
                            <option value="" ${empty replyStatus ? 'selected' : ''}>Tất cả phản hồi</option>
                            <option value="unreplied" ${replyStatus == 'unreplied' ? 'selected' : ''}>Chưa phản hồi</option>
                            <option value="replied" ${replyStatus == 'replied' ? 'selected' : ''}>Đã phản hồi</option>
                        </select>
                        <input type="hidden" name="action" value="list">
                        <input type="hidden" name="page" value="${currentPage}">
                        <button type="submit" class="h-10 px-4 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">Tìm Kiếm</button>
                    </form>
                </div>
                <div class="p-6">
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm text-left text-gray-700 rounded-xl">
                            <thead class="text-xs text-gray-700 uppercase bg-gray-50 border-b-2 border-gray-200">
                                <tr>
                                    <th class="px-2 py-3 font-semibold">ID</th>
                                    <th class="px-2 py-3 font-semibold">Dịch vụ</th>
                                    <th class="px-2 py-3 font-semibold">Khách hàng</th>
                                    <th class="px-2 py-3 text-center font-semibold">Đánh giá</th>
                                    <th class="px-2 py-3 font-semibold">Tiêu đề</th>
                                    <th class="px-2 py-3 font-semibold">Nội dung</th>
                                    <th class="px-2 py-3 font-semibold">Ngày tạo</th>
                                    <th class="px-2 py-3 font-semibold">Phản hồi quản lý</th>
                                    <th class="px-2 py-3 text-center font-semibold">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty reviews}">
                                        <tr>
                                            <td colspan="9" class="text-center py-8 text-gray-400 font-semibold text-lg">
                                                Không có đánh giá nào.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="review" items="${reviews}">
                                            <tr class="bg-white border-b hover:bg-gray-50 transition-all">
                                                <td class="px-2 py-4 font-medium text-gray-900">${review.reviewId}</td>
                                                <td class="px-2 py-4">${review.serviceName}</td>
                                                <td class="px-2 py-4">${review.customerName}</td>
                                                <td class="px-2 py-4 text-center">
                                                    <span class="text-yellow-500 font-medium flex items-center justify-center gap-1">
                                                        <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20" class="w-4 h-4 inline"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.967a1 1 0 00.95.69h4.175c.969 0 1.371 1.24.588 1.81l-3.38 2.455a1 1 0 00-.364 1.118l1.287 3.966c.3.922-.755 1.688-1.54 1.118l-3.38-2.455a1 1 0 00-1.176 0l-3.38 2.455c-.784.57-1.838-.196-1.54-1.118l1.287-3.966a1 1 0 00-.364-1.118L2.05 9.394c-.783-.57-.38-1.81.588-1.81h4.175a1 1 0 00.95-.69l1.286-3.967z"/></svg>
                                                        ${review.rating}
                                                    </span>
                                                </td>
                                                <td class="px-2 py-4">${review.title}</td>
                                                <td class="px-2 py-4 max-w-xs truncate" title="${review.comment}">${review.comment}</td>
                                                <td class="px-2 py-4"><fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy"/></td>
                                                <td class="px-2 py-4 max-w-xs truncate" title="${review.managerReply}">
                                                    <c:choose>
                                                        <c:when test="${not empty review.managerReply}">
                                                            <span class="text-green-700 bg-green-50 rounded px-2 py-1 font-semibold">${review.managerReply}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-gray-400 italic bg-gray-50 rounded px-2 py-1 font-semibold">Chưa có phản hồi</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-2 py-4 text-center flex gap-2 justify-center">
                                                    <a href="${pageContext.request.contextPath}/manager/service-review?action=edit&rid=${review.reviewId}" class="inline-flex items-center justify-center p-2 bg-green-100 hover:bg-green-200 text-green-700 rounded-full" title="Sửa phản hồi">
                                                        <i data-lucide="edit" class="w-5 h-5"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/manager/service-review?action=delete&id=${review.reviewId}" class="inline-flex items-center justify-center p-2 bg-red-100 hover:bg-red-200 text-red-700 rounded-full" title="Xóa đánh giá" onclick="return confirm('Bạn có chắc chắn muốn xóa đánh giá này?')">
                                                        <i data-lucide="trash-2" class="w-5 h-5"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <!-- Pagination -->
                    <div class="flex items-center justify-between flex-wrap gap-2 p-6">
                        <span>
                            <c:choose>
                                <c:when test="${totalEntries == 0}">
                                    Hiển thị 0 mục
                                </c:when>
                                <c:otherwise>
                                    Hiển thị ${start} đến ${end} của ${totalEntries} mục
                                </c:otherwise>
                            </c:choose>
                        </span>
                        <ul class="inline-flex items-center -space-x-px text-sm">
                            <li>
                                <c:choose>
                                    <c:when test="${currentPage == 1}">
                                        <span class="px-3 py-2 ml-0 leading-tight text-gray-400 bg-white border border-gray-300 rounded-l-lg cursor-not-allowed">&lt;</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="px-3 py-2 ml-0 leading-tight text-gray-500 bg-white border border-gray-300 rounded-l-lg hover:bg-gray-100 hover:text-gray-700" href="${pageContext.request.contextPath}/manager/service-review?action=list&page=${currentPage - 1}&limit=${limit}&keyword=${keyword}&serviceId=${serviceId}">&lt;</a>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                            <c:set var="lastPage" value="0" />
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:choose>
                                    <c:when test="${i == 1 || i == 2 || i == totalPages || i == totalPages-1 || (i >= currentPage-1 && i <= currentPage+1)}">
                                        <c:if test="${lastPage + 1 != i}">
                                            <li><span class="px-3 py-2 leading-tight text-gray-400 bg-white border border-gray-300">...</span></li>
                                        </c:if>
                                        <li>
                                            <c:choose>
                                                <c:when test="${i == currentPage}">
                                                    <span class="px-3 py-2 leading-tight text-white bg-primary border border-gray-300">${i}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700" href="${pageContext.request.contextPath}/manager/service-review?action=list&page=${i}&limit=${limit}&keyword=${keyword}&serviceId=${serviceId}">${i}</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                        <c:set var="lastPage" value="${i}" />
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                            <li>
                                <c:choose>
                                    <c:when test="${currentPage == totalPages}">
                                        <span class="px-3 py-2 leading-tight text-gray-400 bg-white border border-gray-300 rounded-r-lg cursor-not-allowed">&gt;</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 rounded-r-lg hover:bg-gray-100 hover:text-gray-700" href="${pageContext.request.contextPath}/manager/service-review?action=list&page=${currentPage + 1}&limit=${limit}&keyword=${keyword}&serviceId=${serviceId}">&gt;</a>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
<jsp:include page="/WEB-INF/view/common/footer.jsp" />
<script>
    window.addEventListener('DOMContentLoaded', () => {
        if (window.lucide) window.lucide.createIcons();
    });
</script>
</body>
</html> 