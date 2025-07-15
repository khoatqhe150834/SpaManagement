<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    if (session.getAttribute("toastMessage") != null) {
        request.setAttribute("toastMessage", session.getAttribute("toastMessage"));
        session.removeAttribute("toastMessage");
    }
    if (session.getAttribute("toastType") != null) {
        request.setAttribute("toastType", session.getAttribute("toastType"));
        session.removeAttribute("toastType");
    }
%>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff - Admin Dashboard</title>
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
    <!-- Custom CSS nếu có -->
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>
<body class="bg-spa-cream font-sans">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Page Header -->
                <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
                    <h1 class="text-3xl font-serif text-spa-dark font-bold">Danh Sách Nhân Viên</h1>
                    <a href="staff?service=pre-insert" class="inline-flex items-center gap-2 h-10 px-4 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">
                        <i data-lucide="plus" class="w-5 h-5"></i>
                        <span>Thêm Nhân Viên</span>
                    </a>
                </div>
                <!-- Card -->
                <div class="bg-white rounded-2xl shadow-lg">
                    <!-- Card Header: Filters & Actions -->
                    <div class="p-6 border-b border-gray-200 flex flex-wrap items-center justify-between gap-4">
                        <form class="flex flex-wrap items-center gap-3" method="get" action="staff">
                            <select class="w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300" id="limitSelect" name="limit" onchange="this.form.submit()">
                                <c:forEach var="i" begin="1" end="10">
                                    <option value="${i}" ${limit==i ? 'selected' : '' }>${i}</option>
                                </c:forEach>
                            </select>
                            <input type="text" class="h-10 px-4 text-base placeholder-gray-600 border rounded-lg focus:shadow-outline" name="keyword" placeholder="Tìm kiếm" value="${keyword}">
                            <select name="serviceTypeId" class="w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300">
                                <option value="">Tất cả loại dịch vụ</option>
                                <c:forEach var="stype" items="${serviceTypes}">
                                    <option value="${stype.serviceTypeId}" <c:if test="${serviceTypeId == stype.serviceTypeId}">selected</c:if>>
                                        ${stype.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <select name="status" class="w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300">
                                <option value="">Trạng thái</option>
                                <c:forEach var="s" items="${statusList}">
                                    <option value="${s}" <c:if test="${status == s}">selected</c:if>>
                                        <c:choose>
                                            <c:when test="${s == 'AVAILABLE'}">Available</c:when>
                                            <c:when test="${s == 'BUSY'}">Busy</c:when>
                                            <c:when test="${s == 'OFFLINE'}">Offline</c:when>
                                            <c:when test="${s == 'ON_LEAVE'}">On Leave</c:when>
                                            <c:otherwise>${s}</c:otherwise>
                                        </c:choose>
                                    </option>
                                </c:forEach>
                            </select>
                            <input type="hidden" name="service" value="search">
                            <input type="hidden" name="limit" value="${limit}" />
                            <button type="submit" class="h-10 px-4 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">Tìm Kiếm</button>
                        </form>
                    </div>
                    <!-- Table -->
                    <div class="p-6">
                        <div class="overflow-x-auto">
                            <table class="w-full text-sm text-left text-gray-500">
                                <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                                    <tr>
                                        <th class="px-6 py-3">STT</th>
                                        <th class="px-6 py-3 text-center">Tên</th>
                                        <th class="px-6 py-3 text-center">Loại Dịch Vụ</th>
                                        <th class="px-6 py-3 text-center">Tiểu Sử</th>
                                        <th class="px-6 py-3 text-center">Trạng Thái</th>
                                        <th class="px-6 py-3 text-center">EXP (Năm)</th>
                                        <th class="px-6 py-3 text-center">Hành Động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="therapist" items="${staffList}" varStatus="status">
                                        <tr class="bg-white border-b hover:bg-gray-50">
                                            <td class="px-6 py-4 text-center">${status.index + 1}</td>
                                            <td class="px-6 py-4 text-center">${therapist.user.fullName}</td>
                                            <td class="px-6 py-4 text-center">
                                                <c:if test="${not empty therapist.serviceType}">
                                                    ${therapist.serviceType.name}
                                                </c:if>
                                            </td>
                                            <td class="px-6 py-4 text-center max-w-xs truncate" title="${therapist.bio}">
                                                ${therapist.bio}
                                            </td>
                                            <td class="px-6 py-4 text-center">
                                                <c:choose>
                                                    <c:when test="${therapist.availabilityStatus == 'AVAILABLE'}">
                                                        <span class="bg-green-100 text-green-800 text-xs font-medium px-2.5 py-0.5 rounded-full">Available</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bg-gray-200 text-gray-600 text-xs font-medium px-2.5 py-0.5 rounded-full">${therapist.availabilityStatus}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 text-center">${therapist.yearsOfExperience}</td>
                                            <td class="px-6 py-4 text-center">
                                                <div class="flex items-center justify-center gap-2">
                                                    <a href="staff?service=viewById&id=${therapist.user.userId}" class="p-2 bg-blue-100 hover:bg-blue-200 text-blue-700 rounded-full" title="Xem chi tiết">
                                                        <i data-lucide="eye" class="w-5 h-5"></i>
                                                    </a>
                                                    <a href="staff?service=pre-update&id=${therapist.user.userId}" class="p-2 bg-green-100 hover:bg-green-200 text-green-700 rounded-full" title="Chỉnh sửa">
                                                        <i data-lucide="edit" class="w-5 h-5"></i>
                                                    </a>
                                                    <a href="staff?service=deactiveById&id=${therapist.user.userId}" class="p-2 bg-yellow-100 hover:bg-yellow-200 text-yellow-700 rounded-full" title="Vô hiệu hóa" onclick="return confirm('Bạn có chắc chắn muốn vô hiệu hóa nhân viên này?');">
                                                        <i data-lucide="ban" class="w-5 h-5"></i>
                                                    </a>
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
                    <a class="px-3 py-2 ml-0 leading-tight text-gray-500 bg-white border border-gray-300 rounded-l-lg hover:bg-gray-100 hover:text-gray-700"
                       href="staff?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${currentPage - 1}&limit=${limit}
                       ${not empty keyword ? '&keyword='.concat(keyword) : ''}
                       ${not empty status ? '&status='.concat(status) : ''}
                       ${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}">&lt;</a>
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
                                <a class="px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700"
                                   href="staff?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${i}&limit=${limit}
                                   ${not empty keyword ? '&keyword='.concat(keyword) : ''}
                                   ${not empty status ? '&status='.concat(status) : ''}
                                   ${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}">${i}</a>
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
                    <a class="px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 rounded-r-lg hover:bg-gray-100 hover:text-gray-700"
                       href="staff?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${currentPage + 1}&limit=${limit}
                       ${not empty keyword ? '&keyword='.concat(keyword) : ''}
                       ${not empty status ? '&status='.concat(status) : ''}
                       ${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}">&gt;</a>
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
    <!-- Script riêng nếu có -->
    <script>
        // ... script toast, phân trang, ... chuyển sang class Tailwind nếu cần ...
    </script>
</body>
</html>
