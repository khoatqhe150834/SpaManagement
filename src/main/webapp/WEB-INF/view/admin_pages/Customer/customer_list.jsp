<%--
    Document   : customer_list
    Created on : Jun 4, 2025
    Author     : Admin
    Refactored to align with the main site's modern Tailwind CSS design system.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Khách hàng - Admin Dashboard</title>

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
    <style>
        /* Minimal custom styles for toast notifications if not covered by app.css */
        .toast-message {
            position: fixed;
            top: 5rem;
            left: 50%;
            transform: translateX(-50%);
            z-index: 9999;
        }
        
        /* 
         * The Centering Trick:
         * 1. The sidebar has a fixed width of 20rem (w-80 in Tailwind).
         * 2. This pushes the main content area off-center relative to the viewport.
         * 3. This style shifts the main content to the left by *half* the sidebar's width.
         * 4. This counteracts the push, placing the content in the true visual center of the page.
        */
        .content-centered-with-sidebar {
            transform: translateX(calc(-20rem / 2));
        }
    </style>
</head>

<body class="bg-spa-cream font-sans">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <main class="flex-1 py-12 lg:py-20">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 content-centered-with-sidebar">
                <!-- Page Header -->
                <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
                    <h1 class="text-3xl font-serif text-spa-dark font-bold">Danh sách khách hàng</h1>
                   
                </div>

                <!-- Toast Notifications -->
                <c:if test="${not empty sessionScope.successMessage || not empty sessionScope.errorMessage}">
                    <div id="toast-message" class="toast-message max-w-sm w-full bg-white shadow-lg rounded-lg pointer-events-auto ring-1 ring-black ring-opacity-5 overflow-hidden">
                        <div class="p-4">
                            <div class="flex items-start">
                                <div class="flex-shrink-0">
                                    <c:if test="${not empty sessionScope.successMessage}">
                                        <i data-lucide="check-circle" class="h-6 w-6 text-green-500"></i>
                                    </c:if>
                                    <c:if test="${not empty sessionScope.errorMessage}">
                                        <i data-lucide="x-circle" class="h-6 w-6 text-red-500"></i>
                                    </c:if>
                                </div>
                                <div class="ml-3 w-0 flex-1 pt-0.5">
                                    <p class="text-sm font-medium text-gray-900">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.successMessage}">Thành công!</c:when>
                                            <c:otherwise>Thất bại!</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <p class="mt-1 text-sm text-gray-500">
                                        ${sessionScope.successMessage} ${sessionScope.errorMessage}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>
                
                <!-- Main Content Card -->
                <div class="bg-white rounded-2xl shadow-lg">
                    <!-- Card Header: Filters & Actions -->
                    <div class="p-6 border-b border-gray-200 flex flex-wrap items-center justify-between gap-4">
                        <form class="flex flex-wrap items-center gap-3" method="get" action="${pageContext.request.contextPath}/customer/list">
                            <select name="pageSize" onchange="this.form.submit()" class="w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300">
                                <option value="5" ${pageSize == 5 ? 'selected' : ''}>5 / trang</option>
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 / trang</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20 / trang</option>
                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50 / trang</option>
                                <option value="9999" ${pageSize == 9999 ? 'selected' : ''}>Tất cả</option>
                            </select>
                            <input type="text" name="searchValue" placeholder="Tìm theo tên, email..." value="${searchValue}" class="h-10 px-4 text-base placeholder-gray-600 border rounded-lg focus:shadow-outline">
                            <select name="status" class="w-auto h-10 pl-3 pr-8 text-base placeholder-gray-600 border rounded-lg appearance-none focus:shadow-outline-blue focus:border-blue-300">
                                <option value="">Tất cả trạng thái</option>
                                <option value="active" ${status == 'active' ? 'selected' : ''}>Đang hoạt động</option>
                                <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Ngừng hoạt động</option>
                            </select>
                            <button type="submit" class="h-10 px-4 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">Tìm kiếm</button>
                            <input type="hidden" name="page" value="1">
                        </form>
                        <a href="${pageContext.request.contextPath}/customer/create" class="inline-flex items-center gap-2 h-10 px-4 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">
                            <i data-lucide="plus" class="w-5 h-5"></i>
                            <span>Thêm khách hàng</span>
                        </a>
                    </div>

                    <!-- Customer Table -->
                    <div class="p-6">
                        <div class="overflow-x-auto">
                            <table class="w-full text-sm text-left text-gray-500">
                                <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                                    <tr>
                                        <th scope="col" class="px-6 py-3">Mã KH</th>
                                        <th scope="col" class="px-6 py-3">Họ và tên</th>
                                        <th scope="col" class="px-6 py-3">Email</th>
                                        <th scope="col" class="px-6 py-3 text-center">Trạng thái</th>
                                        <th scope="col" class="px-6 py-3 text-center">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="customer" items="${customers}">
                                        <tr class="bg-white border-b hover:bg-gray-50">
                                            <td class="px-6 py-4 font-medium text-gray-900">${customer.customerId}</td>
                                            <td class="px-6 py-4">${customer.fullName}</td>
                                            <td class="px-6 py-4">${customer.email}</td>
                                            <td class="px-6 py-4 text-center">
                                                <c:choose>
                                                    <c:when test="${customer.getIsActive()}">
                                                        <span class="bg-green-100 text-green-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded-full">Đang hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bg-red-100 text-red-800 text-xs font-medium me-2 px-2.5 py-0.5 rounded-full">Ngừng hoạt động</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4">
                                                <div class="flex items-center justify-center gap-2">
                                                    <a href="${pageContext.request.contextPath}/customer/view?id=${customer.customerId}" class="p-2 text-gray-500 rounded-full hover:bg-gray-100 hover:text-blue-600" title="Xem">
                                                        <i data-lucide="eye" class="w-5 h-5"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/customer/edit?id=${customer.customerId}&page=${currentPage}&pageSize=${pageSize}&searchValue=${searchValue}&status=${status}" class="p-2 text-gray-500 rounded-full hover:bg-gray-100 hover:text-green-600" title="Sửa">
                                                        <i data-lucide="edit" class="w-5 h-5"></i>
                                                    </a>
                                                    <c:if test="${customer.getIsActive()}">
                                                        <c:url var="deactivateUrl" value="/customer/deactivate">
                                                          <c:param name="id" value="${customer.customerId}" /><c:param name="page" value="${currentPage}" /><c:param name="pageSize" value="${pageSize}" /><c:param name="searchValue" value="${searchValue}" /><c:param name="status" value="${status}" />
                                                        </c:url>
                                                        <a href="#" onclick="return confirmAction('${deactivateUrl}', 'Bạn có chắc chắn muốn vô hiệu hóa khách hàng này?');" class="p-2 text-gray-500 rounded-full hover:bg-gray-100 hover:text-orange-600" title="Vô hiệu hóa">
                                                          <i data-lucide="user-x" class="w-5 h-5"></i>
                                                        </a>
                                                    </c:if>
                                                    <c:if test="${not customer.getIsActive()}">
                                                        <c:url var="activateUrl" value="/customer/activate">
                                                            <c:param name="id" value="${customer.customerId}" /><c:param name="page" value="${currentPage}" /><c:param name="pageSize" value="${pageSize}" /><c:param name="searchValue" value="${searchValue}" /><c:param name="status" value="${status}" />
                                                        </c:url>
                                                        <a href="#" onclick="return confirmAction('${activateUrl}', 'Bạn có chắc chắn muốn kích hoạt khách hàng này?');" class="p-2 text-gray-500 rounded-full hover:bg-gray-100 hover:text-green-600" title="Kích hoạt">
                                                          <i data-lucide="user-check" class="w-5 h-5"></i>
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${not empty customers}">
                        <div class="mt-8 flex items-center justify-between p-6">
                            <c:set var="start" value="${(currentPage - 1) * pageSize + 1}" />
                            <c:set var="end" value="${start + fn:length(customers) - 1}" />
                            <span class="text-sm text-gray-700">
                                Hiển thị <span class="font-semibold text-gray-900">${start}</span> đến <span class="font-semibold text-gray-900">${end}</span> của <span class="font-semibold text-gray-900">${totalCustomers}</span> mục
                            </span>
                            <nav>
                                <ul class="inline-flex -space-x-px text-sm">
                                    <li>
                                        <c:url var="prevUrl" value="/customer/list"><c:param name="page" value="${currentPage - 1}"/><c:param name="pageSize" value="${pageSize}"/><c:param name="searchValue" value="${searchValue}"/><c:param name="status" value="${status}"/></c:url>
                                        <a href="${currentPage > 1 ? prevUrl : '#'}" class="flex items-center justify-center px-3 h-8 ms-0 leading-tight text-gray-500 bg-white border border-e-0 border-gray-300 rounded-s-lg hover:bg-gray-100 hover:text-gray-700 ${currentPage == 1 ? 'pointer-events-none opacity-50' : ''}">Previous</a>
                                    </li>
                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <c:url var="pageUrl" value="/customer/list"><c:param name="page" value="${i}"/><c:param name="pageSize" value="${pageSize}"/><c:param name="searchValue" value="${searchValue}"/><c:param name="status" value="${status}"/></c:url>
                                        <li>
                                            <a href="${pageUrl}" class="flex items-center justify-center px-3 h-8 leading-tight ${i == currentPage ? 'text-blue-600 border border-blue-300 bg-blue-50 hover:bg-blue-100 hover:text-blue-700' : 'text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700'}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <li>
                                        <c:url var="nextUrl" value="/customer/list"><c:param name="page" value="${currentPage + 1}"/><c:param name="pageSize" value="${pageSize}"/><c:param name="searchValue" value="${searchValue}"/><c:param name="status" value="${status}"/></c:url>
                                        <a href="${currentPage < totalPages ? nextUrl : '#'}" class="flex items-center justify-center px-3 h-8 leading-tight text-gray-500 bg-white border border-gray-300 rounded-e-lg hover:bg-gray-100 hover:text-gray-700 ${currentPage == totalPages ? 'pointer-events-none opacity-50' : ''}">Next</a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </c:if>
                    
                    <c:if test="${empty customers}">
                        <div class="p-12 text-center text-gray-500">
                            <p>Không tìm thấy khách hàng nào.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>

    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <!-- JavaScript -->
    <script src="<c:url value='/js/app.js'/>"></script>
    <script>
        lucide.createIcons();

        function confirmAction(url, message) {
            if (confirm(message)) {
                window.location.href = url;
            }
            return false;
        }

        document.addEventListener("DOMContentLoaded", function () {
            const toast = document.getElementById("toast-message");
            if (toast) {
                setTimeout(() => {
                    toast.style.opacity = '0';
                    setTimeout(() => toast.remove(), 500);
                }, 3000);
            }
        });
    </script>
</body>
</html>