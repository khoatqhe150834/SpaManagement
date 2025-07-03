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
  </head>
  <body class="bg-spa-cream flex items-center justify-center h-screen">
    <div class="text-center">
      <h1 class="text-9xl font-bold text-primary">404</h1>
      <h2 class="text-4xl font-serif text-spa-dark mt-4">
        Không tìm thấy trang
      </h2>
      <p class="text-gray-600 mt-2">
        Rất tiếc, trang bạn đang tìm kiếm không tồn tại.
      </p>
      <a
        href="${pageContext.request.contextPath}/"
        class="mt-6 inline-block bg-primary text-white px-6 py-3 rounded-full hover:bg-primary-dark transition-colors"
      >
        Quay về trang chủ
      </a>
    </div>
  </body>
</html>
