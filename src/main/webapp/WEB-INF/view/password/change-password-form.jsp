<%-- 
    Document   : change-profile-password
    Created on : Jun 4, 2025, 8:35:44 AM
    Author     : quang
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Đổi Mật Khẩu - BeautyZone Spa</title>

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

        <!-- Font Awesome for existing icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    </head>

    <body class="bg-spa-cream">
        <!-- Header -->
        <jsp:include page="/WEB-INF/view/common/header.jsp" />

        <!-- Main Content -->
        <div class="min-h-screen py-16">
            <!-- Page Title Section -->
            <div class="bg-primary/10 py-12 mb-12">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <h1 class="text-4xl md:text-5xl font-serif text-spa-dark text-center mb-4">
                        Đổi Mật Khẩu
                    </h1>
                    
                </div>
            </div>

            <!-- Form Section -->
            <div class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="bg-white rounded-xl shadow-lg p-8">
                    <!-- Header -->
                    <div class="text-center mb-8">
                        <div class="bg-primary/10 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i data-lucide="key" class="h-8 w-8 text-primary"></i>
                        </div>
                        <h2 class="text-2xl font-serif text-spa-dark mb-2">Cập Nhật Mật Khẩu</h2>
                        <p class="text-gray-600">Cập nhật mật khẩu mới cho tài khoản của bạn</p>
                    </div>

                    <!-- Messages -->
                    <c:if test="${not empty success}">
                        <div class="bg-green-50 border-l-4 border-green-500 p-4 mb-6">
                            <div class="flex items-center">
                                <i data-lucide="check-circle" class="h-5 w-5 text-green-500 mr-2"></i>
                                <span class="text-green-700"><strong>Thành công!</strong> ${success}</span>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6">
                            <div class="flex items-center">
                                <i data-lucide="alert-triangle" class="h-5 w-5 text-red-500 mr-2"></i>
                                <span class="text-red-700"><strong>Lỗi!</strong> ${error}</span>
                            </div>
                        </div>
                    </c:if>

                    <!-- Form -->
                    <form id="passwordChangeForm" method="post" action="${pageContext.request.contextPath}/password/change" class="space-y-6">
                        <!-- Current Password -->
                        <div>
                            <label class="block text-gray-700 font-medium mb-2" for="currentPassword">
                                Mật khẩu hiện tại
                            </label>
                            <div class="relative">
                                <input
                                    type="password"
                                    id="currentPassword"
                                    name="currentPassword"
                                    required
                                    class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
                                    placeholder="Nhập mật khẩu hiện tại"
                                    value="${attemptedCurrentPassword != null ? attemptedCurrentPassword : ''}"
                                />
                                
                                <p class="mt-1 text-sm text-red-600 hidden" id="currentPasswordMessage"></p>
                            </div>
                        </div>

                        <!-- New Password -->
                        <div>
                            <label class="block text-gray-700 font-medium mb-2" for="newPassword">
                                Mật khẩu mới
                            </label>
                            <div class="relative">
                                <input
                                    type="password"
                                    id="newPassword"
                                    name="newPassword"
                                    required
                                    minlength="6"
                                    class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
                                    placeholder="Nhập mật khẩu mới"
                                    value="${attemptedNewPassword != null ? attemptedNewPassword : ''}"
                                />
                                
                                <p class="mt-1 text-sm text-red-600 hidden" id="newPasswordMessage"></p>
                            </div>
                        </div>

                        <!-- Confirm Password -->
                        <div>
                            <label class="block text-gray-700 font-medium mb-2" for="confirmPassword">
                                Xác nhận mật khẩu mới
                            </label>
                            <div class="relative">
                                <input
                                    type="password"
                                    id="confirmPassword"
                                    name="confirmPassword"
                                    required
                                    minlength="6"
                                    class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
                                    placeholder="Nhập lại mật khẩu mới"
                                    value="${attemptedConfirmPassword != null ? attemptedConfirmPassword : ''}"
                                />
                                
                                <p class="mt-1 text-sm text-red-600 hidden" id="confirmPasswordMessage"></p>
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <div class="pt-4">
                            <button type="submit" class="w-full bg-primary text-white py-3 px-6 rounded-lg hover:bg-primary-dark transition-colors duration-300 flex items-center justify-center gap-2 font-medium">
                               
                                Cập Nhật Mật Khẩu
                            </button>
                        </div>

                        <!-- Back Link -->
                        <div class="text-center pt-4">
                            <a href="${pageContext.request.contextPath}/" class="text-gray-600 hover:text-primary inline-flex items-center gap-2">
                                <i data-lucide="arrow-left" class="h-4 w-4"></i>
                                Quay lại trang chủ
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/view/common/footer.jsp" />

        <!-- Initialize Lucide Icons -->
        <script>
            lucide.createIcons();
        </script>

        <!-- Password Change Validation Script -->
        <script src="${pageContext.request.contextPath}/assets/home/js/password/change-password-validation.js"></script>
    </body>
</html>
