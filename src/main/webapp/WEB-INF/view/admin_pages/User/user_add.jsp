<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm mới người dùng</title>
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
            <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-wrap items-center gap-2 mb-8 text-gray-500 text-sm">
                    <a href="${pageContext.request.contextPath}/admin/user/list" class="flex items-center gap-1 hover:text-primary">
                        <i data-lucide="home" class="w-4 h-4"></i>
                        Danh sách người dùng
                    </a>
                    <span>-</span>
                    <span class="text-primary font-semibold">Thêm mới người dùng</span>
                </div>
                <div class="bg-white rounded-2xl shadow-lg p-8">
                    <form action="${pageContext.request.contextPath}/admin/user/create" method="post" id="userForm">
                        <div class="mb-8">
                            <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2"><i data-lucide="key-round" class="w-5 h-5"></i> Thông tin tài khoản</h2>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label for="email" class="block font-medium text-gray-700 mb-1">Email <span class="text-red-600">*</span></label>
                                    <input type="email" name="email" id="email" maxlength="200" required placeholder="Nhập email" class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary" />
                        </div>
                                <!-- Bỏ trường nhập mật khẩu -->
                                 <div class="md:col-span-2">
                                    <label for="roleId" class="block font-medium text-gray-700 mb-1">Vai trò <span class="text-red-600">*</span></label>
                                    <select name="roleId" id="roleId" class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary" required>
                                        <option value="">Chọn vai trò</option>
                                        <c:forEach var="role" items="${roles}">
                                            <option value="${role.roleId}" ${user.roleId == role.roleId ? 'selected' : ''}>
                                                ${role.displayName != null ? role.displayName : role.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                    </div>
                </div>
                        </div>
                        <div class="mb-8">
                             <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2"><i data-lucide="user-circle" class="w-5 h-5"></i> Thông tin cá nhân</h2>
                             <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label for="fullName" class="block font-medium text-gray-700 mb-1">Họ tên <span class="text-red-600">*</span></label>
                                    <input type="text" name="fullName" id="fullName" maxlength="200" required placeholder="Nhập họ tên" class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary"
                                        pattern="^[A-Za-zÀ-ỹ]+( [A-Za-zÀ-ỹ]+)*$" title="Chỉ nhập chữ, mỗi từ cách nhau 1 khoảng trắng, không số, không ký tự đặc biệt, không khoảng trắng đầu/cuối hoặc liên tiếp" />
                    </div>
                                <div>
                                    <label for="phoneNumber" class="block font-medium text-gray-700 mb-1">Số điện thoại <span class="text-red-600">*</span></label>
                                    <input type="text" name="phoneNumber" id="phoneNumber" maxlength="10" required placeholder="Nhập số điện thoại" class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary"
                                        pattern="^0\d{9}$" title="Số điện thoại phải bắt đầu bằng 0, đủ 10 số, không ký tự đặc biệt" />
                        </div>
                                <div>
                                    <label for="birthday" class="block font-medium text-gray-700 mb-1">Ngày sinh</label>
                                    <input type="date" name="birthday" id="birthday" class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary" />
                    </div>
                                <div>
                                    <label for="gender" class="block font-medium text-gray-700 mb-1">Giới tính</label>
                                    <select name="gender" id="gender" class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary">
                                        <option value="">Chọn giới tính</option>
                                        <option value="Nam">Nam</option>
                                        <option value="Nữ">Nữ</option>
                                        <option value="Khác">Khác</option>
                            </select>
                        </div>
                                <div class="md:col-span-2">
                                    <label for="address" class="block font-medium text-gray-700 mb-1">Địa chỉ</label>
                                    <input type="text" name="address" id="address" maxlength="255" placeholder="Nhập địa chỉ" class="w-full border rounded-lg px-3 py-2 focus:ring-primary focus:border-primary" />
                        </div>
                    </div>
                </div>

                        <div class="mb-8">
                            <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2"><i data-lucide="settings" class="w-5 h-5"></i> Cài đặt</h2>
                            <div class="space-y-3">
                                <div class="flex items-center justify-between bg-gray-50 rounded-lg px-4 py-2">
                                    <div>
                                        <div class="font-semibold">Active</div>
                                        <div class="text-xs text-gray-400">Người dùng sẽ có thể đăng nhập và sử dụng hệ thống.</div>
                </div>
                                    <label class="inline-flex items-center cursor-pointer">
                                        <input type="checkbox" name="isActive" id="isActive" class="sr-only peer" checked>
                                        <div class="w-11 h-6 bg-gray-200 rounded-full peer peer-checked:bg-primary transition-all"></div>
                                        <div class="dot absolute left-1 top-1 bg-white w-4 h-4 rounded-full transition-all peer-checked:translate-x-5"></div>
                                    </label>
                        </div>
                    </div>
                </div>

                        <div class="flex justify-end gap-3 mt-8">
                            <a href="${pageContext.request.contextPath}/admin/user/list" class="inline-flex items-center gap-2 px-6 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition">
                                <i data-lucide="arrow-left" class="w-5 h-5"></i> Hủy
                            </a>
                            <button type="submit" class="inline-flex items-center gap-2 px-6 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition">
                                <i data-lucide="save" class="w-5 h-5"></i> Lưu
                    </button>
                </div>
            </form>
        </div>
    </div>
        </main>
</div>
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
     <script>
        if (window.lucide) lucide.createIcons();
    </script>
    <style>
        .is-valid {
            border: 2px solid #22c55e !important;
        }
        .is-invalid {
            border: 2px solid #f44336 !important;
        }
        .invalid-feedback {
            margin-top: 4px;
            font-size: 0.95em;
            min-height: 18px;
            color: red;
            display: block;
        }
        .is-valid ~ .invalid-feedback {
            color: #22c55e;
        }
    </style>
</body>
</html>