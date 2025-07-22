<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Giường - Spa Hương Sen</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#D4AF37',
                        'primary-dark': '#B8941F',
                        'spa-cream': '#FAF7F0',
                        'spa-dark': '#2C3E50'
                    }
                }
            }
        }
    </script>
    
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
</head>
<body class="bg-spa-cream min-h-screen">
    <!-- Include Header -->
    <jsp:include page="../common/header.jsp" />
    
    <!-- Include Sidebar -->
    <jsp:include page="../common/sidebar.jsp" />
    
    <!-- Main Content -->
    <div class="ml-64 pt-16 p-6">
        <!-- Breadcrumb -->
        <nav class="flex mb-6" aria-label="Breadcrumb">
            <ol class="inline-flex items-center space-x-1 md:space-x-3">
                <li class="inline-flex items-center">
                    <a href="${pageContext.request.contextPath}/dashboard" class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-primary">
                        <i data-lucide="home" class="w-4 h-4 mr-2"></i>
                        Dashboard
                    </a>
                </li>
                <li>
                    <div class="flex items-center">
                        <i data-lucide="chevron-right" class="w-4 h-4 text-gray-400"></i>
                        <a href="${pageContext.request.contextPath}/manager/rooms-management" class="ml-1 text-sm font-medium text-gray-700 hover:text-primary md:ml-2">Quản Lý Phòng</a>
                    </div>
                </li>
                <li>
                    <div class="flex items-center">
                        <i data-lucide="chevron-right" class="w-4 h-4 text-gray-400"></i>
                        <a href="${pageContext.request.contextPath}/manager/room-details/${bed.roomId}" class="ml-1 text-sm font-medium text-gray-700 hover:text-primary md:ml-2">Chi Tiết Phòng</a>
                    </div>
                </li>
                <li aria-current="page">
                    <div class="flex items-center">
                        <i data-lucide="chevron-right" class="w-4 h-4 text-gray-400"></i>
                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Chỉnh Sửa Giường</span>
                    </div>
                </li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-spa-dark mb-2">Chỉnh Sửa Giường</h1>
            <p class="text-gray-600">Cập nhật thông tin giường: <span class="font-semibold text-primary">${bed.name}</span></p>
        </div>

        <!-- Edit Bed Form -->
        <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                    <i data-lucide="edit" class="h-6 w-6 text-primary"></i>
                    Thông Tin Giường
                </h2>
            </div>
            
            <div class="p-6">
                <form action="${pageContext.request.contextPath}/manager/bed/update" method="post" id="editBedForm">
                    <input type="hidden" name="bedId" value="${bed.bedId}">
                    <input type="hidden" name="roomId" value="${bed.roomId}">
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Bed Name -->
                        <div class="md:col-span-2">
                            <label for="name" class="block text-sm font-medium text-gray-700 mb-2">
                                Tên Giường <span class="text-red-500">*</span>
                            </label>
                            <input type="text" id="name" name="name" required value="${bed.name}"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                                   placeholder="Nhập tên giường...">
                            <div id="nameError" class="text-red-500 text-sm mt-1 hidden"></div>
                        </div>

                        <!-- Room Information (Read-only) -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                Phòng
                            </label>
                            <div class="w-full px-3 py-2 bg-gray-50 border border-gray-300 rounded-md text-gray-700">
                                <c:choose>
                                    <c:when test="${not empty room}">
                                        ${room.name}
                                    </c:when>
                                    <c:otherwise>
                                        Phòng ID: ${bed.roomId}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Current Status -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                Trạng Thái Hiện Tại
                            </label>
                            <div class="flex items-center">
                                <c:choose>
                                    <c:when test="${bed.isActive}">
                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800">
                                            <i data-lucide="check-circle" class="w-4 h-4 mr-1"></i>
                                            Hoạt động
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-red-100 text-red-800">
                                            <i data-lucide="x-circle" class="w-4 h-4 mr-1"></i>
                                            Bảo trì
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/manager/bed/toggle-status/${bed.bedId}"
                                   class="ml-3 text-sm text-primary hover:text-primary-dark"
                                   onclick="return confirm('Bạn có chắc chắn muốn thay đổi trạng thái giường này?')">
                                    <i data-lucide="refresh-cw" class="w-4 h-4 inline mr-1"></i>
                                    Thay đổi trạng thái
                                </a>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="md:col-span-2">
                            <label for="description" class="block text-sm font-medium text-gray-700 mb-2">
                                Mô Tả <span class="text-sm text-gray-500">(Tối đa 200 ký tự)</span>
                            </label>
                            <textarea id="description" name="description" rows="4" maxlength="200"
                                      class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                                      placeholder="Nhập mô tả giường...">${bed.description}</textarea>
                            <div class="flex justify-between mt-1">
                                <div id="descriptionError" class="text-red-500 text-sm hidden"></div>
                                <div id="charCount" class="text-sm text-gray-500">${fn:length(bed.description)}/200 ký tự</div>
                            </div>
                        </div>

                        <!-- Bed Info -->
                        <div class="md:col-span-2 bg-gray-50 p-4 rounded-lg">
                            <h3 class="text-sm font-medium text-gray-700 mb-3">Thông Tin Bổ Sung</h3>
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                                <div>
                                    <span class="text-gray-500">ID Giường:</span>
                                    <span class="font-medium">#${bed.bedId}</span>
                                </div>
                                <div>
                                    <span class="text-gray-500">Ngày tạo:</span>
                                    <span class="font-medium">${bed.createdAt}</span>
                                </div>
                                <div>
                                    <span class="text-gray-500">Cập nhật lần cuối:</span>
                                    <span class="font-medium">${bed.updatedAt}</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="flex items-center justify-end space-x-4 mt-8 pt-6 border-t border-gray-200">
                        <a href="${pageContext.request.contextPath}/manager/room-details/${bed.roomId}"
                           class="px-6 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                            <i data-lucide="x" class="w-4 h-4 inline mr-2"></i>
                            Hủy
                        </a>
                        <button type="submit"
                                class="px-6 py-2 bg-primary text-white rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-colors">
                            <i data-lucide="save" class="w-4 h-4 inline mr-2"></i>
                            Cập Nhật
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Include Footer -->
    <jsp:include page="../common/footer.jsp" />

    <!-- External JavaScript -->
    <script src="${pageContext.request.contextPath}/js/bed-edit.js"></script>
    
    <script>
        // Initialize Lucide icons
        lucide.createIcons();
    </script>
</body>
</html>
