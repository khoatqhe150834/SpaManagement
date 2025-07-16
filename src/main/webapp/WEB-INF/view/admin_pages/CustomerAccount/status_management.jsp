<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Trạng Thái Tài Khoản - Admin Dashboard</title>

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
</head>

<body class="bg-spa-cream font-sans min-h-screen">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                
                <!-- Breadcrumb -->
                <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
                    <a href="${pageContext.request.contextPath}/dashboard" class="flex items-center gap-1 hover:text-primary">
                        <i data-lucide="home" class="w-4 h-4"></i>
                        Dashboard
                    </a>
                    <span>-</span>
                    <a href="${pageContext.request.contextPath}/admin/customer-account/list" class="hover:text-primary">
                        Quản lý tài khoản
                    </a>
                    <span>-</span>
                    <span class="text-primary font-semibold">Trạng thái tài khoản</span>
                </div>

                <!-- Page Header -->
                <div class="bg-white rounded-2xl shadow-lg p-8 mb-8">
                    <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                        <div>
                            <h1 class="text-3xl font-bold text-spa-dark mb-2">Quản Lý Trạng Thái Tài Khoản</h1>
                            <p class="text-gray-600">Theo dõi và quản lý trạng thái hoạt động của tài khoản khách hàng</p>
                        </div>
                        <div class="flex gap-3">
                            <a href="${pageContext.request.contextPath}/admin/customer-account/list" 
                               class="inline-flex items-center gap-2 px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition">
                                <i data-lucide="list" class="w-5 h-5"></i>
                                Danh sách tài khoản
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/customer-account/verification" 
                               class="inline-flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition">
                                <i data-lucide="mail-check" class="w-5 h-5"></i>
                                Xác thực email
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Success/Error Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded-lg" role="alert">
                        <p>${sessionScope.successMessage}</p>
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-lg" role="alert">
                        <p>${sessionScope.errorMessage}</p>
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <!-- Statistics Cards -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <div class="bg-white rounded-2xl shadow-lg p-6">
                        <div class="flex items-center justify-between">
                            <div>
                                <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wider">Tài khoản hoạt động</h3>
                                <p class="text-3xl font-bold text-green-600 mt-2">${activeAccounts}</p>
                            </div>
                            <div class="bg-green-100 p-3 rounded-full">
                                <i data-lucide="check-circle" class="w-8 h-8 text-green-600"></i>
                            </div>
                        </div>
                        <div class="mt-4">
                            <div class="flex items-center text-sm">
                                <span class="text-gray-500">Tài khoản có thể đăng nhập</span>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl shadow-lg p-6">
                        <div class="flex items-center justify-between">
                            <div>
                                <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wider">Tài khoản bị khóa</h3>
                                <p class="text-3xl font-bold text-red-600 mt-2">${inactiveAccounts}</p>
                            </div>
                            <div class="bg-red-100 p-3 rounded-full">
                                <i data-lucide="x-circle" class="w-8 h-8 text-red-600"></i>
                            </div>
                        </div>
                        <div class="mt-4">
                            <div class="flex items-center text-sm">
                                <span class="text-gray-500">Tài khoản không thể đăng nhập</span>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl shadow-lg p-6">
                        <div class="flex items-center justify-between">
                            <div>
                                <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wider">Email đã xác thực</h3>
                                <p class="text-3xl font-bold text-blue-600 mt-2">${verifiedAccounts}</p>
                            </div>
                            <div class="bg-blue-100 p-3 rounded-full">
                                <i data-lucide="mail-check" class="w-8 h-8 text-blue-600"></i>
                            </div>
                        </div>
                        <div class="mt-4">
                            <div class="flex items-center text-sm">
                                <span class="text-gray-500">Email đã được xác nhận</span>
                            </div>
                        </div>
                    </div>

                    <div class="bg-white rounded-2xl shadow-lg p-6">
                        <div class="flex items-center justify-between">
                            <div>
                                <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wider">Email chưa xác thực</h3>
                                <p class="text-3xl font-bold text-yellow-600 mt-2">${unverifiedAccounts}</p>
                            </div>
                            <div class="bg-yellow-100 p-3 rounded-full">
                                <i data-lucide="mail" class="w-8 h-8 text-yellow-600"></i>
                            </div>
                        </div>
                        <div class="mt-4">
                            <div class="flex items-center text-sm">
                                <span class="text-gray-500">Cần xác thực email</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Account Status Charts -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
                    <!-- Status Distribution -->
                    <div class="bg-white rounded-2xl shadow-lg p-6">
                        <h3 class="text-xl font-semibold text-spa-dark mb-6">Phân Bố Trạng Thái Tài Khoản</h3>
                        <div class="space-y-4">
                            <c:set var="totalAccounts" value="${activeAccounts + inactiveAccounts}" />
                            
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <div class="w-4 h-4 bg-green-500 rounded"></div>
                                    <span class="text-gray-700">Hoạt động</span>
                                </div>
                                <div class="text-right">
                                    <span class="text-lg font-semibold">${activeAccounts}</span>
                                    <c:if test="${totalAccounts > 0}">
                                        <span class="text-sm text-gray-500 ml-2">
                                            (<fmt:formatNumber value="${(activeAccounts * 100) / totalAccounts}" maxFractionDigits="1"/>%)
                                        </span>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="w-full bg-gray-200 rounded-full h-2">
                                <c:if test="${totalAccounts > 0}">
                                    <div class="bg-green-500 h-2 rounded-full" 
                                         style="width: ${(activeAccounts * 100) / totalAccounts}%"></div>
                                </c:if>
                            </div>

                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <div class="w-4 h-4 bg-red-500 rounded"></div>
                                    <span class="text-gray-700">Bị khóa</span>
                                </div>
                                <div class="text-right">
                                    <span class="text-lg font-semibold">${inactiveAccounts}</span>
                                    <c:if test="${totalAccounts > 0}">
                                        <span class="text-sm text-gray-500 ml-2">
                                            (<fmt:formatNumber value="${(inactiveAccounts * 100) / totalAccounts}" maxFractionDigits="1"/>%)
                                        </span>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="w-full bg-gray-200 rounded-full h-2">
                                <c:if test="${totalAccounts > 0}">
                                    <div class="bg-red-500 h-2 rounded-full" 
                                         style="width: ${(inactiveAccounts * 100) / totalAccounts}%"></div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Email Verification Status -->
                    <div class="bg-white rounded-2xl shadow-lg p-6">
                        <h3 class="text-xl font-semibold text-spa-dark mb-6">Tình Trạng Xác Thực Email</h3>
                        <div class="space-y-4">
                            <c:set var="totalEmailAccounts" value="${verifiedAccounts + unverifiedAccounts}" />
                            
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <div class="w-4 h-4 bg-blue-500 rounded"></div>
                                    <span class="text-gray-700">Đã xác thực</span>
                                </div>
                                <div class="text-right">
                                    <span class="text-lg font-semibold">${verifiedAccounts}</span>
                                    <c:if test="${totalEmailAccounts > 0}">
                                        <span class="text-sm text-gray-500 ml-2">
                                            (<fmt:formatNumber value="${(verifiedAccounts * 100) / totalEmailAccounts}" maxFractionDigits="1"/>%)
                                        </span>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="w-full bg-gray-200 rounded-full h-2">
                                <c:if test="${totalEmailAccounts > 0}">
                                    <div class="bg-blue-500 h-2 rounded-full" 
                                         style="width: ${(verifiedAccounts * 100) / totalEmailAccounts}%"></div>
                                </c:if>
                            </div>

                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-3">
                                    <div class="w-4 h-4 bg-yellow-500 rounded"></div>
                                    <span class="text-gray-700">Chưa xác thực</span>
                                </div>
                                <div class="text-right">
                                    <span class="text-lg font-semibold">${unverifiedAccounts}</span>
                                    <c:if test="${totalEmailAccounts > 0}">
                                        <span class="text-sm text-gray-500 ml-2">
                                            (<fmt:formatNumber value="${(unverifiedAccounts * 100) / totalEmailAccounts}" maxFractionDigits="1"/>%)
                                        </span>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="w-full bg-gray-200 rounded-full h-2">
                                <c:if test="${totalEmailAccounts > 0}">
                                    <div class="bg-yellow-500 h-2 rounded-full" 
                                         style="width: ${(unverifiedAccounts * 100) / totalEmailAccounts}%"></div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="bg-white rounded-2xl shadow-lg p-6">
                    <h3 class="text-xl font-semibold text-spa-dark mb-6">Thao Tác Nhanh</h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                        <a href="${pageContext.request.contextPath}/admin/customer-account/list?status=active" 
                           class="flex items-center gap-3 p-4 border border-green-200 rounded-lg hover:bg-green-50 transition">
                            <i data-lucide="check-circle" class="w-6 h-6 text-green-600"></i>
                            <div>
                                <p class="font-medium text-gray-900">Tài khoản hoạt động</p>
                                <p class="text-sm text-gray-500">Xem tất cả tài khoản hoạt động</p>
                            </div>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/customer-account/list?status=inactive" 
                           class="flex items-center gap-3 p-4 border border-red-200 rounded-lg hover:bg-red-50 transition">
                            <i data-lucide="x-circle" class="w-6 h-6 text-red-600"></i>
                            <div>
                                <p class="font-medium text-gray-900">Tài khoản bị khóa</p>
                                <p class="text-sm text-gray-500">Xem tài khoản bị khóa</p>
                            </div>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/customer-account/list?verification=verified" 
                           class="flex items-center gap-3 p-4 border border-blue-200 rounded-lg hover:bg-blue-50 transition">
                            <i data-lucide="mail-check" class="w-6 h-6 text-blue-600"></i>
                            <div>
                                <p class="font-medium text-gray-900">Email đã xác thực</p>
                                <p class="text-sm text-gray-500">Xem email đã xác thực</p>
                            </div>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/customer-account/list?verification=unverified" 
                           class="flex items-center gap-3 p-4 border border-yellow-200 rounded-lg hover:bg-yellow-50 transition">
                            <i data-lucide="mail" class="w-6 h-6 text-yellow-600"></i>
                            <div>
                                <p class="font-medium text-gray-900">Email chưa xác thực</p>
                                <p class="text-sm text-gray-500">Cần xác thực email</p>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    
    <script>
        if (window.lucide) {
            lucide.createIcons();
        }
    </script>
</body>
</html> 