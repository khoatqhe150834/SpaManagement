<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="context-path" content="${pageContext.request.contextPath}" />
    <title>Chỉnh Sửa Thanh Toán - Spa Hương Sen</title>
    
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
    
    <style>
        /* Form validation styling */
        .field-error {
            animation: shake 0.3s ease-in-out;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
        
        /* Loading spinner */
        .animate-spin {
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body class="bg-spa-cream min-h-screen">
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
                        <a href="${pageContext.request.contextPath}/manager/payments-management" class="ml-1 text-sm font-medium text-gray-700 hover:text-primary md:ml-2">Quản Lý Thanh Toán</a>
                    </div>
                </li>
                <li aria-current="page">
                    <div class="flex items-center">
                        <i data-lucide="chevron-right" class="w-4 h-4 text-gray-400"></i>
                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Chỉnh Sửa Thanh Toán</span>
                    </div>
                </li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-spa-dark mb-2">Chỉnh Sửa Thanh Toán</h1>
            <p class="text-gray-600">Cập nhật thông tin thanh toán: <span class="font-semibold text-primary">#${payment.paymentId}</span></p>
        </div>

        <!-- Edit Payment Form -->
        <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                    <i data-lucide="edit" class="h-6 w-6 text-primary"></i>
                    Thông Tin Thanh Toán
                </h2>
            </div>
            
            <div class="p-6">
                <form id="editPaymentForm">
                    <input type="hidden" id="paymentId" name="paymentId" value="${payment.paymentId}">
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Customer Selection (Read-only for edit) -->
                        <div>
                            <label for="customerId" class="block text-sm font-medium text-gray-700 mb-2">
                                Khách hàng <span class="text-red-500">*</span>
                            </label>
                            <select id="customerId" name="customerId" required disabled
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm bg-gray-100 text-gray-600 cursor-not-allowed">
                                <option value="${payment.customerId}" selected>${customerName} - ${customerPhone}</option>
                            </select>
                            <p class="text-xs text-gray-500 mt-1">Không thể thay đổi khách hàng khi chỉnh sửa</p>
                        </div>
                        
                        <!-- Payment Date -->
                        <div>
                            <label for="paymentDate" class="block text-sm font-medium text-gray-700 mb-2">
                                Ngày thanh toán <span class="text-red-500">*</span>
                            </label>
                            <input type="datetime-local" id="paymentDate" name="paymentDate" required
                                   value="<fmt:formatDate value='${payment.paymentDate}' pattern='yyyy-MM-dd\'T\'HH:mm' />"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                            <div id="paymentDateError" class="text-red-500 text-sm mt-1 hidden"></div>
                        </div>
                        
                        <!-- Payment Method (Read-only for edit) -->
                        <div>
                            <label for="paymentMethod" class="block text-sm font-medium text-gray-700 mb-2">
                                Phương thức thanh toán <span class="text-red-500">*</span>
                            </label>
                            <select id="paymentMethod" name="paymentMethod" required disabled
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm bg-gray-100 text-gray-600 cursor-not-allowed">
                                <option value="${payment.paymentMethod}" selected>
                                    <c:choose>
                                        <c:when test="${payment.paymentMethod == 'BANK_TRANSFER'}">Chuyển khoản</c:when>
                                        <c:when test="${payment.paymentMethod == 'CREDIT_CARD'}">Thẻ tín dụng</c:when>
                                        <c:when test="${payment.paymentMethod == 'VNPAY'}">VNPay</c:when>
                                        <c:when test="${payment.paymentMethod == 'MOMO'}">MoMo</c:when>
                                        <c:when test="${payment.paymentMethod == 'ZALOPAY'}">ZaloPay</c:when>
                                        <c:when test="${payment.paymentMethod == 'CASH'}">Tiền mặt</c:when>
                                        <c:otherwise>${payment.paymentMethod}</c:otherwise>
                                    </c:choose>
                                </option>
                            </select>
                            <p class="text-xs text-gray-500 mt-1">Không thể thay đổi phương thức thanh toán</p>
                        </div>
                        
                        <!-- Payment Status -->
                        <div>
                            <label for="paymentStatus" class="block text-sm font-medium text-gray-700 mb-2">
                                Trạng thái <span class="text-red-500">*</span>
                            </label>
                            <select id="paymentStatus" name="paymentStatus" required
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                                <option value="PAID" ${payment.paymentStatus == 'PAID' ? 'selected' : ''}>Đã thanh toán</option>
                                <option value="PENDING" ${payment.paymentStatus == 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                                <option value="FAILED" ${payment.paymentStatus == 'FAILED' ? 'selected' : ''}>Thất bại</option>
                                <option value="REFUNDED" ${payment.paymentStatus == 'REFUNDED' ? 'selected' : ''}>Đã hoàn tiền</option>
                            </select>
                            <div id="paymentStatusError" class="text-red-500 text-sm mt-1 hidden"></div>
                        </div>
                        
                        <!-- Total Amount (Read-only for edit) -->
                        <div class="md:col-span-2">
                            <label for="totalAmount" class="block text-sm font-medium text-gray-700 mb-2">
                                Số tiền <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <input type="number" id="totalAmount" name="totalAmount" min="0" step="1000" required readonly
                                       value="${payment.totalAmount}"
                                       class="w-full pl-3 pr-12 py-2 border border-gray-300 rounded-md shadow-sm bg-gray-100 text-gray-600 cursor-not-allowed">
                                <div class="absolute inset-y-0 right-0 flex items-center px-3 pointer-events-none text-gray-500">
                                    VNĐ
                                </div>
                            </div>
                            <p class="text-xs text-gray-500 mt-1">Không thể thay đổi số tiền thanh toán</p>
                        </div>
                        
                        <!-- Notes -->
                        <div class="md:col-span-2">
                            <label for="notes" class="block text-sm font-medium text-gray-700 mb-2">
                                Ghi chú
                            </label>
                            <textarea id="notes" name="notes" rows="3"
                                      class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors"
                                      placeholder="Nhập ghi chú về thanh toán (tùy chọn)">${payment.notes}</textarea>
                            <div id="notesError" class="text-red-500 text-sm mt-1 hidden"></div>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="flex items-center justify-end space-x-4 mt-8 pt-6 border-t border-gray-200">
                        <a href="${pageContext.request.contextPath}/manager/payments-management"
                           class="px-6 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                            <i data-lucide="x" class="w-4 h-4 inline mr-2"></i>
                            Hủy
                        </a>
                        <button type="button" id="deleteBtn"
                                class="px-6 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 transition-colors">
                            <i data-lucide="trash-2" class="w-4 h-4 inline mr-2"></i>
                            Xóa
                        </button>
                        <button type="submit" id="submitBtn"
                                class="px-6 py-2 bg-primary text-white rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-colors">
                            <i data-lucide="save" class="w-4 h-4 inline mr-2"></i>
                            Cập Nhật
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- External JavaScript -->
    <script src="${pageContext.request.contextPath}/js/payment-form.js"></script>

    <script>
        // Initialize Lucide icons
        lucide.createIcons();

        // Set edit mode flag
        window.isEditMode = true;
        window.currentPaymentId = ${payment.paymentId};

        // Delete confirmation
        document.getElementById('deleteBtn').addEventListener('click', function() {
            if (confirm('Bạn có chắc chắn muốn xóa thanh toán này? Hành động này không thể hoàn tác.')) {
                // Implement delete functionality
                window.location.href = '${pageContext.request.contextPath}/manager/payment/delete?id=${payment.paymentId}';
            }
        });
    </script>
</body>
</html>
