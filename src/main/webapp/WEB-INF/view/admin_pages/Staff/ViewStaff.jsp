<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ nhân viên</title>
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
<body class="bg-spa-cream font-sans">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
                <h1 class="text-3xl font-serif text-spa-dark font-bold mb-8">Hồ Sơ Nhân Viên</h1>
                <div class="bg-white rounded-2xl shadow-lg p-8">
                    <!-- Thông tin cá nhân -->
                    <div class="flex flex-col items-center mb-8">
                        <img src="${not empty staff.user.avatarUrl ? staff.user.avatarUrl : pageContext.request.contextPath.concat('/assets/images/user-grid/user-grid-img14.png')}" alt="Avatar" class="w-32 h-32 rounded-full border-4 border-primary mb-4 object-cover">
                        <h2 class="text-2xl font-bold text-spa-dark">${staff.user.fullName}</h2>
                        <p class="text-gray-500">${staff.user.email}</p>
                    </div>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <div class="mb-2"><span class="font-semibold">Mã nhân viên:</span> ${staff.user.userId}</div>
                            <div class="mb-2"><span class="font-semibold">Số năm kinh nghiệm:</span> ${staff.yearsOfExperience}</div>
                            <div class="mb-2"><span class="font-semibold">Trạng thái:</span>
                                <c:choose>
                                    <c:when test="${staff.availabilityStatus == 'AVAILABLE'}">
                                        <span class="bg-green-100 text-green-800 text-xs font-medium px-2.5 py-0.5 rounded-full">Available</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="bg-gray-200 text-gray-600 text-xs font-medium px-2.5 py-0.5 rounded-full">${staff.availabilityStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="mb-2"><span class="font-semibold">Loại dịch vụ:</span> ${staff.serviceType.name}</div>
                        </div>
                        <div>
                            <div class="mb-2"><span class="font-semibold">Số điện thoại:</span> ${staff.user.phoneNumber}</div>
                            <div class="mb-2"><span class="font-semibold">Địa chỉ:</span> ${staff.user.address}</div>
                            <div class="mb-2"><span class="font-semibold">Ngày sinh:</span> <fmt:formatDate value="${staff.user.birthday}" pattern="dd/MM/yyyy"/></div>
                        </div>
                    </div>
                    <div class="mt-8">
                        <h3 class="font-semibold text-lg mb-2">Tiểu sử</h3>
                        <div class="bg-gray-50 rounded-lg p-4 text-gray-700 whitespace-pre-line">${staff.bio}</div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
</body>
</html>