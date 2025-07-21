<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${formAction eq 'edit'}">Sửa loại vật tư</c:when>
            <c:otherwise>Thêm loại vật tư mới</c:otherwise>
        </c:choose>
    </title>
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
</head>
<body class="bg-spa-cream font-sans">
<jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

<main class="w-full md:w-[calc(100%-256px)] md:ml-64 min-h-screen transition-all">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12 lg:py-20">
        <!-- Header -->
        <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
            <div>
                <h2 class="text-3xl font-serif text-spa-dark font-bold">
                    <c:choose>
                        <c:when test="${formAction eq 'edit'}">Sửa loại vật tư</c:when>
                        <c:otherwise>Thêm loại vật tư mới</c:otherwise>
                    </c:choose>
                </h2>
                <nav class="text-sm text-gray-500 flex items-center space-x-2 mt-1">
                    <a href="${pageContext.request.contextPath}/dashboard" class="hover:text-primary">Dashboard</a>
                    <span>/</span>
                    <a href="../category" class="hover:text-primary">Loại vật tư</a>
                    <span>/</span>
                    <span>
                            <c:choose>
                                <c:when test="${formAction eq 'edit'}">Chỉnh sửa</c:when>
                                <c:otherwise>Thêm mới</c:otherwise>
                            </c:choose>
                        </span>
                </nav>
            </div>
            <a href="../category" class="inline-flex items-center gap-2 h-10 px-4 bg-gray-500 text-white font-semibold rounded-lg hover:bg-gray-600 transition-colors">
                <i data-lucide="arrow-left" class="h-5 w-5"></i>
                <span>Quay lại</span>
            </a>
        </div>

        <!-- Form Card -->
        <div class="bg-white rounded-2xl shadow-lg">
            <div class="p-6 border-b border-gray-200">
                <h3 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                    <i data-lucide="folder-plus" class="h-6 w-6 text-primary"></i>
                    Thông tin loại vật tư
                </h3>
                <p class="text-gray-600 mt-1">Vui lòng điền đầy đủ thông tin bên dưới</p>
            </div>

            <div class="p-6">
                <form method="post" action="<c:choose><c:when test='${formAction eq "edit"}'>edit?id=${category.inventoryCategoryId}</c:when><c:otherwise>create</c:otherwise></c:choose>" class="space-y-6">

                    <!-- Category Name -->
                    <div class="space-y-2">
                        <label for="name" class="block text-sm font-medium text-spa-dark">
                            Tên loại vật tư <span class="text-red-500">*</span>
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i data-lucide="tag" class="h-5 w-5 text-gray-400"></i>
                            </div>
                            <input
                                    type="text"
                                    id="name"
                                    name="name"
                                    value="${category.name}"
                                    required
                                    class="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-colors"
                                    placeholder="Nhập tên loại vật tư..."
                            />
                        </div>
                        <p class="text-xs text-gray-500">Tên loại vật tư phải là duy nhất và không được để trống</p>
                    </div>

                    <!-- Description -->
                    <div class="space-y-2">
                        <label for="description" class="block text-sm font-medium text-spa-dark">
                            Mô tả
                        </label>
                        <div class="relative">
                            <div class="absolute top-3 left-3 pointer-events-none">
                                <i data-lucide="file-text" class="h-5 w-5 text-gray-400"></i>
                            </div>
                            <textarea
                                    id="description"
                                    name="description"
                                    rows="4"
                                    class="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-colors resize-none"
                                    placeholder="Nhập mô tả cho loại vật tư..."
                            >${category.description}</textarea>
                        </div>
                        <p class="text-xs text-gray-500">Mô tả chi tiết về loại vật tư này (tùy chọn)</p>
                    </div>

                    <!-- Form Actions -->
                    <div class="flex flex-col sm:flex-row gap-3 pt-6 border-t border-gray-200">
                        <button
                                type="submit"
                                class="inline-flex items-center justify-center gap-2 px-6 py-3 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-colors"
                        >
                            <i data-lucide="save" class="h-5 w-5"></i>
                            <span>Lưu</span>
                        </button>

                        <a
                                href="../category"
                                class="inline-flex items-center justify-center gap-2 px-6 py-3 bg-gray-100 text-gray-700 font-semibold rounded-lg hover:bg-gray-200 focus:ring-2 focus:ring-gray-300 focus:ring-offset-2 transition-colors"
                        >
                            <i data-lucide="x" class="h-5 w-5"></i>
                            <span>Quay lại</span>
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Additional Info Card -->
        <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 mt-6">
            <div class="flex items-start">
                <i data-lucide="info" class="h-5 w-5 text-blue-500 mr-3 mt-0.5 flex-shrink-0"></i>
                <div>
                    <h3 class="text-sm font-medium text-blue-800">Lưu ý quan trọng</h3>
                    <div class="text-sm text-blue-700 mt-1 space-y-1">
                        <p>• Tên loại vật tư phải là duy nhất trong hệ thống</p>
                        <p>• Vui lòng kiểm tra kỹ thông tin trước khi lưu</p>
                        <p>• Mô tả giúp người dùng hiểu rõ hơn về loại vật tư</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    // Initialize Lucide icons
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }

    // Form validation
    document.querySelector('form').addEventListener('submit', function(e) {
        const name = document.querySelector('input[name="name"]').value.trim();

        if (!name) {
            e.preventDefault();
            alert('Vui lòng nhập tên loại vật tư!');
            document.querySelector('input[name="name"]').focus();
            return false;
        }

        if (name.length < 2) {
            e.preventDefault();
            alert('Tên loại vật tư phải có ít nhất 2 ký tự!');
            document.querySelector('input[name="name"]').focus();
            return false;
        }
    });
</script>
</body>
</html>
