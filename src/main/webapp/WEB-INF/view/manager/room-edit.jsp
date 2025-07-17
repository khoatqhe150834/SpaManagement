<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Phòng - Spa Hương Sen</title>
    
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
                <li aria-current="page">
                    <div class="flex items-center">
                        <i data-lucide="chevron-right" class="w-4 h-4 text-gray-400"></i>
                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Chỉnh Sửa Phòng</span>
                    </div>
                </li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-spa-dark mb-2">Chỉnh Sửa Phòng</h1>
            <p class="text-gray-600">Cập nhật thông tin phòng: <span class="font-semibold text-primary">${room.name}</span></p>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6" role="alert">
                <span class="block sm:inline">${sessionScope.successMessage}</span>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6" role="alert">
                <span class="block sm:inline">${sessionScope.errorMessage}</span>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <!-- Edit Room Form -->
        <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                    <i data-lucide="edit" class="h-6 w-6 text-primary"></i>
                    Thông Tin Phòng
                </h2>
            </div>
            
            <div class="p-6">
                <form action="${pageContext.request.contextPath}/manager/room/update" method="post" id="editRoomForm">
                    <input type="hidden" name="roomId" value="${room.roomId}">
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Room Name -->
                        <div class="md:col-span-2">
                            <label for="name" class="block text-sm font-medium text-gray-700 mb-2">
                                Tên Phòng <span class="text-red-500">*</span>
                            </label>
                            <input type="text" id="name" name="name" required value="${room.name}"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                                   placeholder="Nhập tên phòng...">
                            <div id="nameError" class="text-red-500 text-sm mt-1 hidden"></div>
                        </div>

                        <!-- Capacity -->
                        <div>
                            <label for="capacity" class="block text-sm font-medium text-gray-700 mb-2">
                                Sức Chứa <span class="text-red-500">*</span>
                            </label>
                            <input type="number" id="capacity" name="capacity" required min="1" max="20" value="${room.capacity}"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                                   placeholder="Nhập sức chứa...">
                            <div id="capacityError" class="text-red-500 text-sm mt-1 hidden"></div>
                        </div>

                        <!-- Current Status -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                Trạng Thái Hiện Tại
                            </label>
                            <div class="flex items-center">
                                <c:choose>
                                    <c:when test="${room.isActive}">
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
                                <a href="${pageContext.request.contextPath}/manager/room/toggle-status/${room.roomId}"
                                   class="ml-3 text-sm text-primary hover:text-primary-dark"
                                   onclick="return confirm('Bạn có chắc chắn muốn thay đổi trạng thái phòng này?')">
                                    <i data-lucide="refresh-cw" class="w-4 h-4 inline mr-1"></i>
                                    Thay đổi trạng thái
                                </a>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="md:col-span-2">
                            <label for="description" class="block text-sm font-medium text-gray-700 mb-2">
                                Mô Tả
                            </label>
                            <textarea id="description" name="description" rows="4"
                                      class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                                      placeholder="Nhập mô tả phòng...">${room.description}</textarea>
                        </div>

                        <!-- Room Info -->
                        <div class="md:col-span-2 bg-gray-50 p-4 rounded-lg">
                            <h3 class="text-sm font-medium text-gray-700 mb-3">Thông Tin Bổ Sung</h3>
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                                <div>
                                    <span class="text-gray-500">ID Phòng:</span>
                                    <span class="font-medium">#${room.roomId}</span>
                                </div>
                                <div>
                                    <span class="text-gray-500">Ngày tạo:</span>
                                    <span class="font-medium">${room.createdAt}</span>
                                </div>
                                <div>
                                    <span class="text-gray-500">Cập nhật lần cuối:</span>
                                    <span class="font-medium">${room.updatedAt}</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="flex items-center justify-end space-x-4 mt-8 pt-6 border-t border-gray-200">
                        <a href="${pageContext.request.contextPath}/manager/rooms-management"
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

    <script>
        // Initialize Lucide icons
        lucide.createIcons();

        // Form validation
        document.getElementById('editRoomForm').addEventListener('submit', function(e) {
            let isValid = true;

            // Validate room name
            const name = document.getElementById('name').value.trim();
            const nameError = document.getElementById('nameError');
            if (!name) {
                nameError.textContent = 'Tên phòng không được để trống.';
                nameError.classList.remove('hidden');
                isValid = false;
            } else {
                nameError.classList.add('hidden');
            }

            // Validate capacity
            const capacity = parseInt(document.getElementById('capacity').value);
            const capacityError = document.getElementById('capacityError');
            if (!capacity || capacity < 1 || capacity > 20) {
                capacityError.textContent = 'Sức chứa phải từ 1 đến 20 người.';
                capacityError.classList.remove('hidden');
                isValid = false;
            } else {
                capacityError.classList.add('hidden');
            }

            if (!isValid) {
                e.preventDefault();
            }
        });

        // Real-time validation
        document.getElementById('name').addEventListener('input', function() {
            const nameError = document.getElementById('nameError');
            if (this.value.trim()) {
                nameError.classList.add('hidden');
            }
        });

        document.getElementById('capacity').addEventListener('input', function() {
            const capacityError = document.getElementById('capacityError');
            const capacity = parseInt(this.value);
            if (capacity >= 1 && capacity <= 20) {
                capacityError.classList.add('hidden');
            }
        });
    </script>
</body>
</html>
