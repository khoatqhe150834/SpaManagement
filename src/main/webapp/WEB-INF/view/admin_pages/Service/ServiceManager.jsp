<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Dịch Vụ - Admin Dashboard</title>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/admin/css/lib/dataTables.min.css">
    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <style>
/* Đồng bộ giao diện Select2 với input, select thường */
.select2-container--default .select2-selection--single {
  height: 40px !important;
  border-radius: 0.5rem !important;
  border: 1px solid #d1d5db !important; /* Tailwind border-gray-300 */
  padding: 6px 12px !important;
  font-size: 1rem;
  background-color: #fff;
  transition: border-color 0.2s;
  min-width: 220px;
  box-shadow: none;
}
.select2-container--default .select2-selection--single:focus,
.select2-container--default .select2-selection--single.select2-selection--focus {
  border-color: #D4AF37 !important; /* vàng chủ đạo */
  outline: none;
}
.select2-container--default .select2-selection--single .select2-selection__rendered {
  line-height: 26px !important;
  color: #374151; /* Tailwind text-gray-700 */
}
.select2-container--default .select2-selection--single .select2-selection__arrow {
  height: 38px !important;
  right: 8px;
}
.select2-container--default .select2-selection--single:hover {
  border-color: #D4AF37 !important;
}
.select2-container--default .select2-dropdown {
  border-radius: 0.5rem !important;
  border: 1px solid #d1d5db !important;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}
.select2-container--default .select2-results__option--highlighted[aria-selected] {
  background-color: #FDE68A !important; /* vàng nhạt */
  color: #333;
}
.select2-container--default .select2-results__option[aria-selected=true] {
  background-color: #D4AF37 !important;
  color: #fff;
}
.select2-container--default .select2-selection--single .select2-selection__placeholder {
  color: #9ca3af !important; /* Tailwind text-gray-400 */
}
.select2-container {
  width: auto !important;
  min-width: 220px;
  vertical-align: middle;
}
.max-w-xs {
  max-width: 220px;
}
.max-w-\[160px\] {
  max-width: 160px;
}
.truncate {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
</head>
<body class="bg-spa-cream font-sans">
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="w-full md:w-[calc(100%-256px)] md:ml-64 bg-spa-cream min-h-screen transition-all main">
            <jsp:include page="/WEB-INF/view/admin_pages/Common/AdminHeader.jsp" />
                <div class="w-full mx-auto px-4 sm:px-6 lg:px-8 mt-8">
                <!-- Page Header -->
                <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
                    <h1 class="text-3xl font-serif text-spa-dark font-bold">Danh Sách Dịch Vụ</h1>
                    <div class="flex gap-2">
                        <a href="${pageContext.request.contextPath}/manager/service-images/manage" class="inline-flex items-center gap-2 h-10 px-4 bg-blue-100 text-blue-800 font-semibold rounded-lg hover:bg-blue-200 transition-colors" title="Quản Lý Ảnh Dịch Vụ">
                            <i data-lucide="gallery-horizontal" class="w-5 h-5"></i>
                            <span class="hidden sm:inline">Quản Lý Ảnh</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/manager/service-images/batch-upload" class="inline-flex items-center gap-2 h-10 px-4 bg-purple-100 text-purple-800 font-semibold rounded-lg hover:bg-purple-200 transition-colors" title="Batch Upload Ảnh">
                            <i data-lucide="cloud-upload" class="w-5 h-5"></i>
                            <span class="hidden sm:inline">Batch Upload Ảnh</span>
                        </a>
                        <a href="service?service=pre-insert&page=${currentPage}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}"
                            class="inline-flex items-center gap-2 h-10 px-4 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">
                            <i data-lucide="plus" class="w-5 h-5"></i>
                            <span>Thêm Dịch Vụ Mới</span>
                        </a>
                    </div>
                </div>
                <!-- Card -->
                <div class="bg-white rounded-2xl shadow-lg">
                    <!-- Card Header: Filters & Actions -->
                    <div class="p-6 border-b border-gray-200 flex flex-wrap items-center justify-between gap-4">
                        <form class="flex flex-wrap items-center gap-3" method="get" action="service">
                            <select class="w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300" id="limitSelect" name="limit" onchange="this.form.submit()">
                                <c:forEach var="i" begin="1" end="10">
                                    <option value="${i}" ${limit==i ? 'selected' : '' }>${i}</option>
                                </c:forEach>
                            </select>
                            <input type="text" class="h-10 px-4 text-base placeholder-gray-600 border rounded-lg focus:shadow-outline" name="keyword" placeholder="Tìm kiếm" value="${keyword}">
                            <select name="serviceTypeId" class="service-type-select w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300" style="min-width:220px;">
                                <option value="">Tất cả loại dịch vụ</option>
                                <c:forEach var="stype" items="${serviceTypes}">
                                    <option value="${stype.serviceTypeId}" <c:if test="${param.serviceTypeId == stype.serviceTypeId}">selected</c:if>>
                                        ${stype.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <select class="w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300" name="status">
                                <option value="">Tất cả trạng Thái</option>
                                <option value="active" ${status=='active' ? 'selected' : '' }>Active</option>
                                <option value="inactive" ${status=='inactive' ? 'selected' : '' }>Inactive</option>
                            </select>
                            <input type="hidden" name="service" value="search">
                            <input type="hidden" name="page" value="${currentPage}">
                            <button type="submit" class="h-10 px-4 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">Tìm Kiếm</button>
                        </form>
                    </div>
                    <!-- Table -->
                    <div class="p-6">
                        <div class="overflow-x-auto">
                            <table id="serviceTable" class="w-full text-sm text-left text-gray-500">
                                <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                                    <tr>
                                        <th scope="col" class="px-2 py-3" style="width:4%">ID</th>
                                        <th scope="col" class="px-2 py-3 text-center" style="width:8%">Hình Ảnh</th>
                                        <th scope="col" class="px-2 py-3" style="width:16%">Tên Dịch Vụ</th>
                                        <th scope="col" class="px-2 py-3" style="width:12%">Loại Dịch Vụ</th>
                                        <th scope="col" class="px-2 py-3 text-center" style="width:8%">Thời Gian</th>
                                        <th scope="col" class="px-2 py-3 text-center" style="width:8%">Đánh Giá</th>
                                        <th scope="col" class="px-2 py-3 text-center" style="width:12%">Giá</th>
                                        <th scope="col" class="px-2 py-3 text-center" style="width:8%">Trạng Thái</th>
                                        <th scope="col" class="px-2 py-3 text-center" style="width:12%">Thao Tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty services}">
                                            <tr>
                                                <td colspan="9" class="text-center py-8 text-gray-400 font-semibold text-lg">
                                                    Không tìm thấy dịch vụ nào phù hợp với tiêu chí lọc.
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="service" items="${services}">
                                                <tr class="bg-white border-b hover:bg-gray-50">
                                                    <td class="px-2 py-4 font-medium text-gray-900">${service.serviceId}</td>
                                                    <td class="px-2 py-4 text-center">
                                                        <div class="flex justify-center items-center h-16">
                                                            <c:set var="imgUrl" value="${serviceThumbnails[service.serviceId]}" />
                                                            <c:choose>
                                                                <c:when test="${not empty imgUrl}">
                                                                    <img src="${pageContext.request.contextPath}/image?type=service&name=${fn:substringAfter(imgUrl, '/services/')}" alt="Service Image" class="w-16 h-16 object-cover rounded shadow mx-auto hover:scale-105 transition-transform duration-200" style="cursor: zoom-in;" onclick="showImageModal(this.src)" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="${pageContext.request.contextPath}/assets/images/no-image.png" alt="No image" class="w-16 h-16 object-cover rounded-xl border bg-gray-50 shadow" />
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </td>
                                                    <td class="px-2 py-4">
                                                        <div class="truncate w-full max-w-[220px]" title="${service.name}">${service.name}</div>
                                                    </td>
                                                    <td class="px-2 py-4">
                                                        <div class="truncate w-full max-w-[160px]" title="${service.serviceTypeId.name}">${service.serviceTypeId.name}</div>
                                                    </td>
                                                    <td class="px-2 py-4 text-center">${service.durationMinutes} phút</td>
                                                    <td class="px-2 py-4 text-center">
                                                        <span class="text-yellow-500 font-medium">(${service.averageRating})</span>
                                                    </td>
                                                    <td class="px-2 py-4 text-center align-middle">
                                                        <span class="font-semibold text-[#15803d] text-lg">
                                                            <fmt:formatNumber value="${service.price}" type="number" maxFractionDigits="0" />
                                                        </span>
                                                        <span class="text-xs text-gray-400 ml-1">VND</span>
                                                    </td>
                                                    <td class="px-2 py-4 text-center align-middle">
                                                        <c:choose>
                                                            <c:when test="${service.isActive}">
                                                                <span class="inline-block rounded-full bg-green-100 text-green-700 px-4 py-1 font-semibold text-base">Active</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="inline-block rounded-full bg-red-100 text-red-700 px-4 py-1 font-semibold text-base">Inactive</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="px-2 py-4 text-center">
                                                        <div class="flex items-center justify-center gap-2">
                                                            <!-- Nút xem chi tiết -->
                                                            <a href="service?service=view-detail&id=${service.serviceId}&page=${currentPage}&limit=${limit}" class="p-2 bg-blue-100 hover:bg-blue-200 text-blue-700 rounded-full" title="Xem chi tiết dịch vụ">
                                                                <i data-lucide="eye" class="w-5 h-5"></i>
                                                            </a>
                                                            <!-- Nút chỉnh sửa dịch vụ -->
                                                            <a href="service?service=pre-update&id=${service.serviceId}&page=${currentPage}&limit=${limit}" class="p-2 bg-green-100 hover:bg-green-200 text-green-700 rounded-full" title="Chỉnh sửa dịch vụ">
                                                                <i data-lucide="edit" class="w-5 h-5"></i>
                                                            </a>
                                                            <!-- Nút quản lý hình ảnh -->
                                                            <a href="${pageContext.request.contextPath}/manager/service-images/single-upload?serviceId=${service.serviceId}" class="p-2 bg-yellow-100 hover:bg-yellow-200 text-yellow-700 rounded-full" title="Quản lý hình ảnh">
                                                                <i data-lucide="image" class="w-5 h-5"></i>
                                                            </a>
                                                            <c:choose>
                                                                <c:when test="${service.isActive}">
                                                                    <a href="service?service=deactivate&id=${service.serviceId}&page=${currentPage}&limit=${limit}" class="p-2 bg-red-100 hover:bg-red-200 text-red-700 rounded-full" title="Vô hiệu hóa dịch vụ" onclick="return confirmAction('Bạn có chắc chắn muốn vô hiệu hóa dịch vụ này?')">
                                                                        <i data-lucide="ban" class="w-5 h-5"></i>
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a href="service?service=activate&id=${service.serviceId}&page=${currentPage}&limit=${limit}" class="p-2 bg-green-100 hover:bg-green-200 text-green-700 rounded-full hover:text-green-800 transition-colors" title="Kích hoạt lại dịch vụ" onclick="return confirmAction('Bạn có chắc chắn muốn kích hoạt lại dịch vụ này?')">
                                                                        <i data-lucide="refresh-ccw" class="w-5 h-5"></i>
                                                                    </a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
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
                                        <a class="px-3 py-2 ml-0 leading-tight text-gray-500 bg-white border border-gray-300 rounded-l-lg hover:bg-gray-100 hover:text-gray-700" href="service?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${currentPage - 1}&limit=${limit}">&lt;</a>
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
                                                    <a class="px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700" href="service?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${i}&limit=${limit}">${i}</a>
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
                                        <a class="px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 rounded-r-lg hover:bg-gray-100 hover:text-gray-700" href="service?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${currentPage + 1}&limit=${limit}">&gt;</a>
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
    <script src="${pageContext.request.contextPath}/assets/admin/js/lib/dataTables.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            new DataTable('#serviceTable', {
                searching: false,
                paging: false,
                info: false,
                lengthChange: false,
                ordering: true
            });
        });
        function confirmAction(message) {
            return confirm(message);
        }
    </script>
    <!-- jQuery (nếu chưa có) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Select2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script>
        $(document).ready(function() {
            $('.service-type-select').select2({
                placeholder: "Tất cả loại dịch vụ",
                allowClear: true,
                width: 'resolve',
                dropdownAutoWidth: true,
                language: {
                    noResults: function() {
                        return "Không tìm thấy loại dịch vụ nào";
                    }
                }
            });
            // Khi thay đổi bất kỳ filter nào, reset page về 1
            $('.service-type-select, [name="status"], [name="keyword"], [name="limit"]').on('change input', function() {
                $('[name="page"]').val(1);
            });
        });
    </script>
    <!-- Modal xem ảnh lớn -->
    <div id="imageModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-70 hidden">
        <span class="absolute top-4 right-8 text-white text-3xl cursor-pointer" id="closeModal">&times;</span>
        <img id="modalImg" src="" class="max-h-[80vh] max-w-[90vw] rounded-xl shadow-2xl border-4 border-white" />
    </div>
    <script>
        function showImageModal(src) {
            document.getElementById('modalImg').src = src;
            document.getElementById('imageModal').classList.remove('hidden');
        }
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