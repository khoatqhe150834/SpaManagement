<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>404 - Không tìm thấy trang</title>
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
    <link
      href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap"
      rel="stylesheet"
    />
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
  </head>
  <body class="bg-spa-cream flex items-center justify-center min-h-screen p-4">
    <div class="text-center max-w-2xl mx-auto">
      <div class="flex justify-center mb-6">
        <i data-lucide="alert-circle" class="w-24 h-24 text-primary"></i>
      </div>
      <h1 class="text-9xl font-bold text-primary mb-4">404</h1>
      <h2 class="text-4xl font-serif text-spa-dark">
        Không tìm thấy trang
      </h2>
      <div class="mt-6 p-4 bg-white rounded-lg shadow-sm border border-gray-100">
        <p class="text-gray-600 mb-2">
          Rất tiếc, trang bạn đang tìm kiếm không tồn tại.
        </p>
        <div class="text-left mt-4 bg-gray-50 p-3 rounded-md">
          <p class="text-sm text-gray-500 mb-1">Chi tiết lỗi:</p>
          <p class="font-mono text-sm break-all bg-gray-100 p-2 rounded">
            URL: ${pageContext.errorData.requestURI}
          </p>
          <p class="text-xs text-gray-500 mt-2">
            Nếu bạn tin rằng đây là lỗi, vui lòng liên hệ với quản trị viên.
          </p>
        </div>
      </div>
      <div class="mt-8 space-x-4">
        <a
          href="javascript:history.back()"
          class="inline-flex items-center px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors"
        >
          <i data-lucide="arrow-left" class="w-4 h-4 mr-2"></i>
          Quay lại
        </a>
        <a
          href="${pageContext.request.contextPath}/"
          class="inline-flex items-center px-6 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors"
        >
          <i data-lucide="home" class="w-4 h-4 mr-2"></i>
          Về trang chủ
        </a>
      </div>
    </div>

    <script>
      // Initialize Lucide icons
      document.addEventListener('DOMContentLoaded', () => {
        if (window.lucide) {
          lucide.createIcons();
        }
      });
    </script>
  </body>
</html>
