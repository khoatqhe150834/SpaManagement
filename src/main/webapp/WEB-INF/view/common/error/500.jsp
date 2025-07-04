<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.StringWriter" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>500 - Lỗi Máy Chủ Nội Bộ</title>
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
    <style>
      pre {
        max-height: 400px;
        overflow-y: auto;
      }
    </style>
  </head>
  <body class="bg-spa-cream font-sans">
    <div class="container mx-auto p-4 md:p-8">
      <div class="bg-white rounded-lg shadow-lg p-8 max-w-4xl mx-auto">
        <h1 class="text-5xl font-serif text-primary">500</h1>
        <h2 class="text-3xl font-serif text-spa-dark mt-2">
          Lỗi Máy Chủ Nội Bộ
        </h2>
        <p class="text-gray-600 mt-4">
          Rất tiếc, máy chủ đã gặp phải một lỗi không mong muốn. Chúng tôi đang
          kiểm tra và sẽ sớm khắc phục.
        </p>
        <a
          href="${pageContext.request.contextPath}/home"
          class="mt-6 inline-block bg-primary text-white px-6 py-3 rounded-full hover:bg-primary-dark transition-colors"
        >
          Quay về trang chủ
        </a>

        <div class="mt-8 border-t pt-6">
          <div
            class="bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-4"
            role="alert"
          >
            <p class="font-bold">Thông tin cho nhà phát triển</p>
            <p>Chi tiết lỗi sau đây chỉ dành cho mục đích gỡ lỗi.</p>
          </div>

          <h3 class="text-xl font-serif text-spa-dark mt-6">
            Thông báo lỗi (Error Message):
          </h3>
          <pre
            class="bg-gray-800 text-white p-4 rounded mt-2 font-mono text-sm"
          ><c:out value="${requestScope.exception.message}" default="Không có thông báo lỗi."/></pre>

          <h3 class="text-xl font-serif text-spa-dark mt-6">
            Nguồn gốc lỗi (Stack Trace):
          </h3>
          <pre
            class="bg-gray-800 text-white p-4 rounded mt-2 font-mono text-sm"
          ><c:out value="${requestScope.stackTrace}" default="Không có thông tin stack trace."/></pre>
        </div>
      </div>
    </div>
  </body>
</html> 