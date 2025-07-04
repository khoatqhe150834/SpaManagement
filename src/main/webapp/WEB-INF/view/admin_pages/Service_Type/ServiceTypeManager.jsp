<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Loại Dịch Vụ - Admin Dashboard</title>
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
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="flex-1 py-12 lg:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Page Header -->
                <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
                    <h1 class="text-3xl font-serif text-spa-dark font-bold">Danh Sách Loại Dịch Vụ</h1>
                    <a href="servicetype?service=pre-insert&page=${currentPage}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}"
                        class="inline-flex items-center gap-2 h-10 px-4 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">
                        <i data-lucide="plus" class="w-5 h-5"></i>
                        <span>Thêm Loại Dịch Vụ Mới</span>
                    </a>
                </div>
                <!-- Card -->
                <div class="bg-white rounded-2xl shadow-lg">
                    <!-- Card Header: Filters & Actions -->
                    <div class="p-6 border-b border-gray-200 flex flex-wrap items-center justify-between gap-4">
                        <form class="flex flex-wrap items-center gap-3" method="get" action="servicetype">
                            <select class="w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300" id="limitSelect" name="limit" onchange="this.form.submit()">
                                <c:forEach var="i" begin="1" end="10">
                                    <option value="${i}" ${limit == i ? 'selected' : ''}>${i}</option>
                                </c:forEach>
                            </select>
                            <input type="text" class="h-10 px-4 text-base placeholder-gray-600 border rounded-lg focus:shadow-outline" name="keyword" placeholder="Tìm kiếm" value="${keyword}">
                            <select class="w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300" name="status">
                                <option value="">Trạng thái</option>
                                <option value="active" ${status=='active' ? 'selected' : '' }>Active</option>
                                <option value="inactive" ${status=='inactive' ? 'selected' : '' }>Inactive</option>
                            </select>
                            <input type="hidden" name="service" value="searchByKeywordAndStatus">
                            <button type="submit" class="h-10 px-4 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">Tìm kiếm</button>
                        </form>
                    </div>
                    <!-- Table -->
                    <div class="p-6">
                        <div class="overflow-x-auto">
                            <table class="w-full text-sm text-left text-gray-500">
                                <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                                    <tr>
                                        <th scope="col" class="px-6 py-3">ID</th>
                                        <th scope="col" class="px-6 py-3 text-center">Hình Ảnh</th>
                                        <th scope="col" class="px-6 py-3">Tên Loại Dịch Vụ</th>
                                        <th scope="col" class="px-6 py-3">Mô Tả</th>
                                        <th scope="col" class="px-6 py-3 text-center">Trạng Thái</th>
                                        <th scope="col" class="px-6 py-3 text-center">Thao Tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="stype" items="${serviceTypes}" varStatus="loop">
                                        <tr class="bg-white border-b hover:bg-gray-50">
                                            <td class="px-6 py-4 font-medium text-gray-900">${stype.serviceTypeId}</td>
                                            <td class="px-6 py-4 text-center">
                                                <div class="flex justify-center items-center h-16">
                                                    <img src="${pageContext.request.contextPath}${stype.imageUrl}" alt="Hình ảnh loại dịch vụ" class="w-16 h-16 object-cover rounded-xl border bg-gray-50 shadow" style="cursor:pointer" onclick="showImagePreview('${pageContext.request.contextPath}${stype.imageUrl}')"/>
                                                </div>
                                            </td>
                                            <td class="px-6 py-4">${stype.name}</td>
                                            <td class="px-6 py-4 max-w-xs truncate" title="${stype.description}">${stype.description}</td>
                                            <td class="px-6 py-4 text-center">
                                                <c:choose>
                                                    <c:when test="${stype.active}">
                                                        <span class="bg-green-100 text-green-800 text-xs font-medium px-2.5 py-0.5 rounded-full">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bg-red-100 text-red-800 text-xs font-medium px-2.5 py-0.5 rounded-full">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 text-center">
                                                <div class="flex items-center justify-center gap-2">
                                                    <a href="servicetype?service=pre-update&id=${stype.serviceTypeId}&page=${currentPage}&limit=${limit}${searchParams}" class="p-2 text-gray-500 rounded-full hover:bg-gray-100 hover:text-green-600" title="Chỉnh sửa loại dịch vụ">
                                                        <i data-lucide="edit" class="w-5 h-5"></i>
                                                    </a>
                                                    <c:choose>
                                                        <c:when test="${stype.active}">
                                                            <a href="servicetype?service=deactiveById&id=${stype.serviceTypeId}&page=${currentPage}&limit=${limit}${searchParams}" class="p-2 text-gray-500 rounded-full hover:bg-gray-100 hover:text-orange-600" title="Vô hiệu hóa loại dịch vụ" onclick="return confirmAction('Bạn có chắc chắn muốn vô hiệu hóa loại dịch vụ này?')">
                                                                <i data-lucide="user-x" class="w-5 h-5"></i>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="servicetype?service=activateById&id=${stype.serviceTypeId}&page=${currentPage}&limit=${limit}${searchParams}" class="p-2 text-gray-500 rounded-full hover:bg-gray-100 hover:text-green-600" title="Kích hoạt lại loại dịch vụ" onclick="return confirmAction('Bạn có chắc chắn muốn kích hoạt lại loại dịch vụ này?')">
                                                                <i data-lucide="user-check" class="w-5 h-5"></i>
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!-- Pagination -->
                    <div class="flex items-center justify-between flex-wrap gap-2 p-6">
                        <span>
                            Hiển thị ${start} đến ${end} của ${totalEntries} mục
                        </span>
                        <ul class="inline-flex items-center -space-x-px text-sm">
                            <li>
                                <c:choose>
                                    <c:when test="${currentPage == 1}">
                                        <span class="px-3 py-2 ml-0 leading-tight text-gray-400 bg-white border border-gray-300 rounded-l-lg cursor-not-allowed">&lt;</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="px-3 py-2 ml-0 leading-tight text-gray-500 bg-white border border-gray-300 rounded-l-lg hover:bg-gray-100 hover:text-gray-700" href="servicetype?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${currentPage - 1}&limit=${limit}${searchParams}">&lt;</a>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li>
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <span class="px-3 py-2 leading-tight text-white bg-primary border border-gray-300">${i}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a class="px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700" href="servicetype?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${i}&limit=${limit}${searchParams}">${i}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </c:forEach>
                            <li>
                                <c:choose>
                                    <c:when test="${currentPage == totalPages}">
                                        <span class="px-3 py-2 leading-tight text-gray-400 bg-white border border-gray-300 rounded-r-lg cursor-not-allowed">&gt;</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 rounded-r-lg hover:bg-gray-100 hover:text-gray-700" href="servicetype?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${currentPage + 1}&limit=${limit}${searchParams}">&gt;</a>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    <!-- Modal preview ảnh -->
    <div id="imagePreviewModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100vw; height:100vh; background:rgba(0,0,0,0.7); align-items:center; justify-content:center;">
        <span style="position:absolute; top:30px; right:40px; font-size:40px; color:white; cursor:pointer;" onclick="closeImagePreview()">&times;</span>
        <img id="previewImg" src="" style="max-width:90vw; max-height:90vh; border-radius:12px; box-shadow:0 4px 32px #0008;">
    </div>
    <script>
        function showImagePreview(src) {
            document.getElementById('previewImg').src = src;
            document.getElementById('imagePreviewModal').style.display = 'flex';
        }
        function closeImagePreview() {
            document.getElementById('imagePreviewModal').style.display = 'none';
        }
        function confirmAction(message) {
            return confirm(message);
        }
    </script>
</body>
</html>