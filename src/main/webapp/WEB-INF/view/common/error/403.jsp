<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>403 - Truy cập bị cấm</title>
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
  <body class="bg-spa-cream min-h-screen flex flex-col">
    <!-- Include Header -->
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <!-- Main Content -->
    <main class="flex-grow flex items-center justify-center">
      <div class="text-center">
        <h1 class="text-9xl font-bold text-primary">403</h1>
        <h2 class="text-4xl font-serif text-spa-dark mt-4">
          Truy cập bị cấm
        </h2>
        <p class="text-gray-600 mt-2">
          Rất tiếc, bạn không có quyền truy cập vào trang này.
        </p>
        <a
          href="${pageContext.request.contextPath}/"
          class="mt-6 inline-block bg-primary text-white px-6 py-3 rounded-full hover:bg-primary-dark transition-colors"
        >
          Quay về trang chủ
        </a>
      </div>
    </main>

    <!-- Include Footer -->
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
  </body>
</html> 