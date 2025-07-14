<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết người dùng - ${user.fullName}</title>
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
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>
<body class="bg-spa-cream font-sans min-h-screen">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
     <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
                    <a href="${pageContext.request.contextPath}/user/list" class="flex items-center gap-1 hover:text-primary">
                        <i data-lucide="home" class="w-4 h-4"></i>
                        Danh sách người dùng
                    </a>
                    <span>-</span>
                    <span class="text-primary font-semibold">Chi tiết người dùng</span>
                </div>
                <div class="bg-white rounded-2xl shadow-lg p-8">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <div>
                            <div class="flex flex-wrap items-start justify-between gap-2 mb-4">
                                <div>
                                    <h1 class="text-2xl md:text-3xl font-serif font-bold text-spa-dark mb-2">${user.fullName}</h1>
                                    <div class="text-gray-500 text-sm mb-1">Vai trò: 
                                        <span class="text-primary font-semibold">${roleDisplayName}</span>
                                    </div>
                                </div>
                                <c:choose>
                                    <c:when test="${user.isActive}">
                                        <span class="inline-block bg-green-100 text-green-800 text-xs font-medium px-3 py-1 rounded-full">Active</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="inline-block bg-red-100 text-red-800 text-xs font-medium px-3 py-1 rounded-full">Inactive</span>
                                    </c:otherwise>
                                </c:choose>
    </div>

                            <hr class="my-4">

                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-6">
                                <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                    <i data-lucide="mail" class="w-6 h-6 text-primary"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Email</div>
                                        <div class="font-semibold text-gray-800">${user.email}</div>
        </div>
        </div>
                                <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                    <i data-lucide="phone" class="w-6 h-6 text-primary"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Số điện thoại</div>
                                        <div class="font-semibold text-gray-800">${not empty user.phoneNumber ? user.phoneNumber : 'Chưa cập nhật'}</div>
            </div>
        </div>
                                <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                    <i data-lucide="calendar" class="w-6 h-6 text-primary"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Ngày sinh</div>
                                        <div class="font-semibold text-gray-800">
                    <c:choose>
                                                <c:when test="${not empty user.birthday}">
                                                    <fmt:formatDate value="${user.birthday}" pattern="dd/MM/yyyy" />
                                                </c:when>
                                                <c:otherwise>Chưa cập nhật</c:otherwise>
                    </c:choose>
                                        </div>
                                    </div>
                                </div>
                                <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                    <i data-lucide="users" class="w-6 h-6 text-primary"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Giới tính</div>
                                        <div class="font-semibold text-gray-800">${not empty user.gender ? user.gender : 'Chưa cập nhật'}</div>
                                    </div>
                                </div>
                                <div class="sm:col-span-2 flex items-start gap-3 bg-gray-50 rounded-lg p-4">
                                    <i data-lucide="map-pin" class="w-6 h-6 text-primary mt-1 flex-shrink-0"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Địa chỉ</div>
                                        <div class="font-semibold text-gray-800">${not empty user.address ? user.address : 'Chưa cập nhật'}</div>
                                    </div>
                                </div>
                                <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                    <i data-lucide="clock" class="w-6 h-6 text-primary"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Lần đăng nhập cuối</div>
                                        <div class="font-semibold text-gray-800">
                    <c:choose>
                                                <c:when test="${not empty user.lastLoginAt}">
                                                    <fmt:formatDate value="${user.lastLoginAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                                </c:when>
                        <c:otherwise>Chưa đăng nhập</c:otherwise>
                    </c:choose>
                                        </div>
                                    </div>
                                </div>
                                <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                    <i data-lucide="calendar-plus" class="w-6 h-6 text-primary"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Ngày tạo tài khoản</div>
                                        <div class="font-semibold text-gray-800">
                                            <c:choose>
                                                <c:when test="${not empty user.createdAt}">
                                                    <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                                </c:when>
                                                <c:otherwise>Chưa cập nhật</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                                <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                    <i data-lucide="refresh-ccw" class="w-6 h-6 text-primary"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Cập nhật lần cuối</div>
                                        <div class="font-semibold text-gray-800">
                    <c:choose>
                                                <c:when test="${not empty user.updatedAt}">
                                                    <fmt:formatDate value="${user.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                                </c:when>
                                                <c:otherwise>Chưa cập nhật</c:otherwise>
                    </c:choose>
                                        </div>
                                    </div>
                                </div>
                                <div class="flex items-center gap-3 bg-gray-50 rounded-lg p-4">
                                    <i data-lucide="key" class="w-6 h-6 text-primary"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Mật khẩu</div>
                                        <div class="font-semibold text-gray-800">
                    <c:choose>
                                                <c:when test="${not empty user.hashPassword}">
                                                    Đã có mật khẩu
                                                    <div class="text-xs text-gray-500 break-all">Hash: ${user.hashPassword}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-red-500">Chưa có mật khẩu</span>
                                                </c:otherwise>
                    </c:choose>
                                        </div>
                                    </div>
            </div>
        </div>
    </div>

                        <div>
                             <h2 class="font-semibold text-gray-700 mb-2">Ảnh đại diện</h2>
                            <c:choose>
                                <c:when test="${not empty user.avatarUrl}">
                                    <img src="<c:url value='${user.avatarUrl}'/>" alt="Avatar" class="w-full h-72 object-cover rounded-xl shadow">
                                </c:when>
                                <c:otherwise>
                                    <div class="flex flex-col items-center justify-center h-72 border rounded-xl bg-gray-50">
                                        <i data-lucide="image-off" class="w-16 h-16 text-gray-300 mb-2"></i>
                                        <span class="text-gray-400">Chưa có ảnh đại diện</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="flex flex-wrap justify-end gap-3 mt-8">
                        <a href="${pageContext.request.contextPath}/user/list" class="inline-flex items-center gap-2 px-6 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition">
                            <i data-lucide="arrow-left" class="w-5 h-5"></i> Quay lại
        </a>
                        <a href="${pageContext.request.contextPath}/user/edit?id=${user.userId}" class="inline-flex items-center gap-2 px-6 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition">
                            <i data-lucide="edit" class="w-5 h-5"></i> Chỉnh sửa
        </a>
    </div>
</div>
            </div>
        </main>
    </div>
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
     <script>
        window.addEventListener('DOMContentLoaded', () => {
            if (window.lucide) {
                lucide.createIcons();
                        }
        });
     </script>
</body>
</html>