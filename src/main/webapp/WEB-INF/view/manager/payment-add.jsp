<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="context-path" content="${pageContext.request.contextPath}" />
    <title>Thêm Thanh Toán Mới - Spa Hương Sen</title>
    
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
                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Thêm Thanh Toán Mới</span>
                    </div>
                </li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-spa-dark mb-2">Thêm Thanh Toán Mới</h1>
            <p class="text-gray-600">Tạo giao dịch thanh toán mới cho khách hàng</p>
        </div>

        <!-- Add Payment Form -->
        <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                    <i data-lucide="plus-circle" class="h-6 w-6 text-primary"></i>
                    Thông Tin Thanh Toán
                </h2>
            </div>
            
            <div class="p-6">
                <form id="addPaymentForm">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Customer Selection -->
                        <div>
                            <label for="customerId" class="block text-sm font-medium text-gray-700 mb-2">
                                Khách hàng <span class="text-red-500">*</span>
                            </label>
                            <select id="customerId" name="customerId" required
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                                <option value="">Chọn khách hàng</option>
                                <c:forEach var="customer" items="${customers}">
                                    <option value="${customer.id}">${customer.fullName} - ${customer.phoneNumber}</option>
                                </c:forEach>
                            </select>
                            <div id="customerIdError" class="text-red-500 text-sm mt-1 hidden"></div>
                        </div>
                        
                        <!-- Payment Date -->
                        <div>
                            <label for="paymentDate" class="block text-sm font-medium text-gray-700 mb-2">
                                Ngày thanh toán <span class="text-red-500">*</span>
                            </label>
                            <input type="datetime-local" id="paymentDate" name="paymentDate" required
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                            <div id="paymentDateError" class="text-red-500 text-sm mt-1 hidden"></div>
                        </div>
                        
                        <!-- Payment Method -->
                        <div>
                            <label for="paymentMethod" class="block text-sm font-medium text-gray-700 mb-2">
                                Phương thức thanh toán <span class="text-red-500">*</span>
                            </label>
                            <select id="paymentMethod" name="paymentMethod" required
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                                <option value="">Chọn phương thức</option>
                                <option value="BANK_TRANSFER">Chuyển khoản</option>
                                <option value="CREDIT_CARD">Thẻ tín dụng</option>
                                <option value="VNPAY">VNPay</option>
                                <option value="MOMO">MoMo</option>
                                <option value="ZALOPAY">ZaloPay</option>
                                <option value="CASH">Tiền mặt</option>
                            </select>
                            <div id="paymentMethodError" class="text-red-500 text-sm mt-1 hidden"></div>
                        </div>
                        
                        <!-- Payment Status -->
                        <div>
                            <label for="paymentStatus" class="block text-sm font-medium text-gray-700 mb-2">
                                Trạng thái <span class="text-red-500">*</span>
                            </label>
                            <select id="paymentStatus" name="paymentStatus" required
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                                <option value="PAID">Đã thanh toán</option>
                                <option value="PENDING">Chờ xử lý</option>
                                <option value="FAILED">Thất bại</option>
                                <option value="REFUNDED">Đã hoàn tiền</option>
                            </select>
                            <div id="paymentStatusError" class="text-red-500 text-sm mt-1 hidden"></div>
                        </div>
                        
                        <!-- Total Amount -->
                        <div class="md:col-span-2">
                            <label for="totalAmount" class="block text-sm font-medium text-gray-700 mb-2">
                                Số tiền <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <input type="text" id="totalAmount" name="totalAmount" required
                                       class="w-full pl-3 pr-12 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors"
                                       placeholder="Nhập số tiền..."
                                       inputmode="numeric">
                                <div class="absolute inset-y-0 right-0 flex items-center px-3 pointer-events-none text-gray-500">
                                    VNĐ
                                </div>
                            </div>
                            <div id="totalAmountError" class="text-red-500 text-sm mt-1 hidden"></div>
                        </div>
                        
                        <!-- Notes -->
                        <div class="md:col-span-2">
                            <label for="notes" class="block text-sm font-medium text-gray-700 mb-2">
                                Ghi chú
                            </label>
                            <textarea id="notes" name="notes" rows="3"
                                      class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors"
                                      placeholder="Nhập ghi chú về thanh toán (tùy chọn)"></textarea>
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
                        <button type="submit" id="submitBtn"
                                class="px-6 py-2 bg-primary text-white rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-colors">
                            <i data-lucide="save" class="w-4 h-4 inline mr-2"></i>
                            Thêm Thanh Toán
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

        // Set default payment date to current time
        document.addEventListener('DOMContentLoaded', function() {
            const paymentDate = document.getElementById('paymentDate');
            if (paymentDate) {
                const now = new Date();
                const localDateTime = new Date(now.getTime() - now.getTimezoneOffset() * 60000)
                    .toISOString().slice(0, 16);
                paymentDate.value = localDateTime;
            }
        });
    </script>
</body>
</html>
