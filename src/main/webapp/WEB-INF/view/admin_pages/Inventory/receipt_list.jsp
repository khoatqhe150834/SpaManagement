<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách phiếu nhập</title>
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
<body class="bg-spa-cream font-sans">
<jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

<main class="w-full md:w-[calc(100%-256px)] md:ml-64 min-h-screen transition-all">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 lg:py-20">
        <!-- Page Header -->
        <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
            <div>
                <h1 class="text-3xl font-serif text-spa-dark font-bold">Danh sách phiếu nhập</h1>
                <nav class="text-sm text-gray-500 flex items-center space-x-2 mt-1">
                    <a href="${pageContext.request.contextPath}/dashboard" class="hover:text-primary">Dashboard</a>
                    <span>/</span>
                    <span>Phiếu nhập</span>
                </nav>
            </div>
            <a href="receipt/create" class="inline-flex items-center gap-2 h-10 px-4 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">
                <i data-lucide="plus" class="h-5 w-5"></i>
                <span>Tạo phiếu nhập mới</span>
            </a>
        </div>

        <!-- Card -->
        <div class="bg-white rounded-2xl shadow-lg">
            <!-- Card Header: Filters & Actions -->
            <div class="p-6 border-b border-gray-200 flex flex-wrap items-center justify-between gap-4">
                <form class="flex flex-wrap items-center gap-3" method="get" action="">
                    <select name="pageSize" class="w-auto h-10 pl-3 pr-8 text-base border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300" onchange="this.form.submit()">
                        <c:forEach var="i" begin="1" end="10">
                            <option value="${i}" <c:if test="${pageSize == i}">selected</c:if>>${i}</option>
                        </c:forEach>
                    </select>
                    <input type="text" name="search" value="${param.search}" placeholder="Tìm kiếm phiếu nhập..." class="h-10 px-4 text-base placeholder-gray-600 border rounded-lg focus:shadow-outline w-64" />
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
                            <th scope="col" class="px-6 py-3">Ngày nhập</th>
                            <th scope="col" class="px-6 py-3">Nhà cung cấp</th>
                            <th scope="col" class="px-6 py-3">Người tạo</th>
                            <th scope="col" class="px-6 py-3">Ghi chú</th>
                            <th scope="col" class="px-6 py-3">Ngày tạo</th>
                            <th scope="col" class="px-6 py-3 text-center">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="receipt" items="${receipts}">
                            <tr class="bg-white border-b hover:bg-gray-50">
                                <td class="px-6 py-4 font-medium text-gray-900">${receipt.inventoryReceiptId}</td>
                                <td class="px-6 py-4">
                                    <fmt:formatDate value="${receipt.receiptDate}" pattern="dd/MM/yyyy" />
                                </td>
                                <td class="px-6 py-4">
                                            <span class="inline-flex items-center gap-1">
                                                <i data-lucide="truck" class="w-4 h-4 text-gray-400"></i>
                                                    ${receipt.supplier.name}
                                            </span>
                                </td>
                                <td class="px-6 py-4">
                                            <span class="inline-flex items-center gap-1">
                                                <i data-lucide="user" class="w-4 h-4 text-gray-400"></i>
                                                ${receipt.user.fullName}
                                            </span>
                                </td>
                                <td class="px-6 py-4 max-w-xs truncate" title="${receipt.note}">
                                    <c:choose>
                                        <c:when test="${not empty receipt.note}">
                                            ${receipt.note}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-gray-400 italic">Không có ghi chú</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-6 py-4">
                                    <fmt:formatDate value="${receipt.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </td>
                                <td class="px-6 py-4 text-center">
                                    <div class="flex items-center justify-center gap-2">
                                        <a href="receipt/view?id=${receipt.inventoryReceiptId}" class="p-2 bg-blue-100 hover:bg-blue-200 text-blue-700 rounded-full" title="Xem chi tiết phiếu nhập">
                                            <i data-lucide="eye" class="w-5 h-5"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Pagination & Info -->
            <div class="flex items-center justify-between flex-wrap gap-2 p-6">
                    <span>
                        <c:choose>
                            <c:when test="${total == 0}">
                                Hiển thị 0 mục
                            </c:when>
                            <c:otherwise>
                                <c:set var="start" value="${(currentPage - 1) * pageSize + 1}" />
                                <c:set var="end" value="${currentPage * pageSize > total ? total : currentPage * pageSize}" />
                                Hiển thị ${start} đến ${end} của ${total} mục
                            </c:otherwise>
                        </c:choose>
                    </span>
                <ul class="inline-flex items-center -space-x-px text-sm">
                    <c:set var="totalPages" value="${(total + pageSize - 1) / pageSize}" />
                    <li>
                        <c:choose>
                            <c:when test="${currentPage == 1}">
                                <span class="px-3 py-2 ml-0 leading-tight text-gray-400 bg-white border border-gray-300 rounded-l-lg cursor-not-allowed">&lt;</span>
                            </c:when>
                            <c:otherwise>
                                <a class="px-3 py-2 ml-0 leading-tight text-gray-500 bg-white border border-gray-300 rounded-l-lg hover:bg-gray-100 hover:text-gray-700"
                                   href="?page=${currentPage - 1}&pageSize=${pageSize}
                                       <c:if test='${not empty param.search}'>&amp;search=${fn:escapeXml(param.search)}</c:if>">&lt;</a>
                            </c:otherwise>
                        </c:choose>
                    </li>
                    <c:set var="lastPage" value="0" />
                    <c:forEach var="i" begin="1" end="${totalPages < 1 ? 1 : totalPages}">
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
                                               href="?page=${i}&pageSize=${pageSize}
                                                   <c:if test='${not empty param.search}'>&amp;search=${fn:escapeXml(param.search)}</c:if>">${i}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                                <c:set var="lastPage" value="${i}" />
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    <li>
                        <c:choose>
                            <c:when test="${currentPage == totalPages || totalPages == 0}">
                                <span class="px-3 py-2 leading-tight text-gray-400 bg-white border border-gray-300 rounded-r-lg cursor-not-allowed">&gt;</span>
                            </c:when>
                            <c:otherwise>
                                <a class="px-3 py-2 leading-tight text-gray-500 bg-white border border-gray-300 rounded-r-lg hover:bg-gray-100 hover:text-gray-700"
                                   href="?page=${currentPage + 1}&pageSize=${pageSize}
                                       <c:if test='${not empty param.search}'>&amp;search=${fn:escapeXml(param.search)}</c:if>">&gt;</a>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</main>

<script>
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
</script>
</body>
</html>