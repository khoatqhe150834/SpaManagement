<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.Customer" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Khách Hàng - <c:out value="${customer.fullName}"/> - Spa Management</title>

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
                <c:if test="${not empty customer}">
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
                        <div class="p-6 md:p-8">
                            <!-- Header -->
                            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
                                <div>
                                    <h1 class="text-3xl font-serif text-spa-dark font-bold">Chi Tiết Khách Hàng</h1>
                                    <p class="text-gray-600 mt-1">Thông tin chi tiết và lịch sử của <c:out value="${customer.fullName}"/>.</p>
                                </div>
                                <div class="flex-shrink-0 flex items-center gap-2">
                                    <a href="${pageContext.request.contextPath}/customer/list" class="inline-flex items-center gap-2 px-4 py-2 bg-gray-100 border border-gray-300 rounded-lg text-gray-800 hover:bg-gray-200 transition-colors text-sm font-semibold">
                                        <i data-lucide="arrow-left" class="w-4 h-4"></i>
                                        <span>Quay lại</span>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/customer/edit?id=${customer.customerId}" class="inline-flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors text-sm font-semibold">
                                        <i data-lucide="edit" class="w-4 h-4"></i>
                                        <span>Chỉnh sửa</span>
                                    </a>
                                </div>
                            </div>

                            <!-- Main Content Grid -->
                            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                                <!-- Left Column: Avatar & Basic Info -->
                                <div class="lg:col-span-1 text-center lg:text-left flex flex-col items-center lg:items-start">
                                    <img src="${not empty customer.avatarUrl ? pageContext.request.contextPath.concat(customer.avatarUrl) : 'https://ui-avatars.com/api/?name='.concat(fn:replace(customer.fullName, ' ', '+')).concat('&background=D4AF37&color=fff&size=128')}" 
                                         alt="Ảnh đại diện của ${customer.fullName}"
                                         class="w-32 h-32 rounded-full border-4 border-white shadow-lg mb-4 object-cover">
                                    
                                    <h2 class="text-2xl font-bold text-spa-dark"><c:out value="${customer.fullName}"/></h2>
                                    
                                    <div class="flex items-center gap-4 mt-3">
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 text-xs font-medium rounded-full ${customer.active ? 'bg-emerald-100 text-emerald-800' : 'bg-red-100 text-red-800'}">
                                            <span class="w-2 h-2 rounded-full ${customer.active ? 'bg-emerald-500' : 'bg-red-500'}"></span>
                                            ${customer.active ? 'Hoạt động' : 'Vô hiệu hóa'}
                                        </span>
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 text-xs font-medium rounded-full ${customer.verified ? 'bg-blue-100 text-blue-800' : 'bg-gray-100 text-gray-800'}">
                                            <i data-lucide="${customer.verified ? 'shield-check' : 'shield-off'}" class="w-3 h-3"></i>
                                            ${customer.verified ? 'Đã xác minh' : 'Chưa xác minh'}
                                        </span>
                                    </div>
                                    
                                    <div class="mt-6 border-t border-gray-200 pt-6 w-full space-y-4">
                                        <div class="flex items-start gap-3">
                                            <i data-lucide="mail" class="w-5 h-5 text-primary mt-1 flex-shrink-0"></i>
                                            <div>
                                                <h3 class="text-sm font-semibold text-gray-500">Email</h3>
                                                <p class="text-gray-800 break-all"><c:out value="${customer.email}"/></p>
                                            </div>
                                        </div>
                                        <div class="flex items-start gap-3">
                                            <i data-lucide="phone" class="w-5 h-5 text-primary mt-1 flex-shrink-0"></i>
                                            <div>
                                                <h3 class="text-sm font-semibold text-gray-500">Số điện thoại</h3>
                                                <p class="text-gray-800"><c:out value="${customer.phoneNumber}"/></p>
                                            </div>
                                        </div>
                                         <div class="flex items-start gap-3">
                                            <i data-lucide="map-pin" class="w-5 h-5 text-primary mt-1 flex-shrink-0"></i>
                                            <div>
                                                <h3 class="text-sm font-semibold text-gray-500">Địa chỉ</h3>
                                                <p class="text-gray-800"><c:out value="${customer.address}" default="Chưa cung cấp"/></p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Right Column: Detailed Info -->
                                <div class="lg:col-span-2 space-y-6">
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                                        <div class="bg-spa-cream/60 p-4 rounded-lg">
                                            <h3 class="text-sm font-semibold text-gray-500">Giới tính</h3>
                                            <p class="text-lg font-medium text-gray-800"><c:out value="${customer.gender}"/></p>
                                        </div>
                                         <div class="bg-spa-cream/60 p-4 rounded-lg">
                                            <h3 class="text-sm font-semibold text-gray-500">Ngày sinh</h3>
                                            <p class="text-lg font-medium text-gray-800">
                                                <c:choose>
                                                    <c:when test="${not empty customer.birthday}">
                                                        <%= new SimpleDateFormat("dd/MM/yyyy").format(((Customer)pageContext.findAttribute("customer")).getBirthday()) %>
                                                    </c:when>
                                                    <c:otherwise>
                                                        Chưa cung cấp
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                        <div class="bg-spa-cream/60 p-4 rounded-lg">
                                            <h3 class="text-sm font-semibold text-gray-500">Điểm thân thiết</h3>
                                            <p class="text-lg font-medium text-primary-dark">${customer.loyaltyPoints} điểm</p>
                                        </div>
                                        <div class="bg-spa-cream/60 p-4 rounded-lg">
                                            <h3 class="text-sm font-semibold text-gray-500">Ngày tham gia</h3>
                                            <p class="text-lg font-medium text-gray-800">
                                                <c:if test="${not empty customer.createdAt}">
                                                    <%= new SimpleDateFormat("dd/MM/yyyy").format(java.util.Date.from(((Customer)pageContext.findAttribute("customer")).getCreatedAt().atZone(java.time.ZoneId.systemDefault()).toInstant())) %>
                                                </c:if>
                                            </p>
                                        </div>
                                    </div>
                                    
                                    <div>
                                        <h3 class="text-md font-semibold text-spa-dark mb-2">Ghi chú</h3>
                                        <div class="bg-gray-50 p-4 rounded-lg border border-gray-200">
                                            <p class="text-gray-700 italic">
                                                <c:out value="${customer.notes}" default="Không có ghi chú."/>
                                            </p>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not customer.active}">
                                        <div class="mt-6">
                                            <a href="${pageContext.request.contextPath}/customer/activate?id=${customer.customerId}" class="w-full inline-flex items-center justify-center gap-2 px-4 py-3 bg-emerald-500 text-white rounded-lg hover:bg-emerald-600 transition-colors font-semibold">
                                                <i data-lucide="user-check" class="w-5 h-5"></i>
                                                Kích hoạt lại tài khoản này
                                            </a>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
                <c:if test="${empty customer}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4" role="alert">
                        <p class="font-bold">Lỗi!</p>
                        <p>Không tìm thấy khách hàng. Vui lòng quay lại danh sách và thử lại.</p>
                    </div>
                </c:if>
            </div>
        </main>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            if(window.lucide) {
                lucide.createIcons();
            }
        });
    </script>
</body>
</html>