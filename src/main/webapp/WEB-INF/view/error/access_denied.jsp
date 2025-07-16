<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Không có quyền truy cập</title>
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
<body class="bg-spa-cream font-sans min-h-screen flex items-center justify-center">
    <div class="max-w-md w-full bg-white rounded-2xl shadow-lg p-8 text-center">
        <div class="mb-6">
            <i data-lucide="shield-x" class="w-20 h-20 text-red-500 mx-auto mb-4"></i>
            <h1 class="text-2xl font-bold text-spa-dark mb-2">Không có quyền truy cập</h1>
            <p class="text-gray-600">
                ${not empty errorMessage ? errorMessage : 'Bạn không có quyền truy cập vào trang này.'}
            </p>
        </div>
        
        <div class="space-y-3">
            <a href="javascript:history.back()" 
               class="w-full inline-flex items-center justify-center gap-2 px-6 py-3 bg-gray-500 text-white rounded-lg hover:bg-gray-600 transition-colors">
                <i data-lucide="arrow-left" class="w-4 h-4"></i>
                Quay lại
            </a>
            
            <a href="${pageContext.request.contextPath}/dashboard" 
               class="w-full inline-flex items-center justify-center gap-2 px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors">
                <i data-lucide="home" class="w-4 h-4"></i>
                Về trang chủ
            </a>
        </div>
        
        <div class="mt-6 text-sm text-gray-500">
            <p>Nếu bạn cần truy cập, vui lòng liên hệ với quản trị viên hệ thống.</p>
        </div>
    </div>
    
    <script>
        if (window.lucide) lucide.createIcons();
    </script>
</body>
</html> 
 
 