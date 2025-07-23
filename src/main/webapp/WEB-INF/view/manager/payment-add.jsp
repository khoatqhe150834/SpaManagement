<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="context-path" content="${pageContext.request.contextPath}" />
    <title>Thanh Toán Tiền Mặt - Spa Hương Sen</title>
    
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

    <!-- Font Awesome for money icon -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
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
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
    
    <!-- Main Content -->
    <main class="w-full md:w-[calc(100%-256px)] md:ml-64 bg-spa-cream min-h-screen transition-all main">
        <div class="p-6">
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
                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Thanh Toán Tiền Mặt</span>
                    </div>
                </li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-spa-dark mb-2">Thanh Toán Tiền Mặt</h1>
            <p class="text-gray-600">Tạo giao dịch thanh toán bằng tiền mặt cho khách hàng</p>
        </div>

        <!-- Add Payment Form -->
        <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                    <i data-lucide="dollar-sign" class="h-6 w-6 text-green-600"></i>
                    Thông Tin Thanh Toán Tiền Mặt
                </h2>
            </div>
            
            <div class="p-6">
                <form id="addPaymentForm">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Customer Selection with Search -->
                        <div>
                            <label for="customerId" class="block text-sm font-medium text-gray-700 mb-2">
                                Khách hàng <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <input type="text" id="customerSearch"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors"
                                       placeholder="Tìm kiếm khách hàng theo tên hoặc số điện thoại...">
                                <select id="customerId" name="customerId" required
                                        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors mt-2">
                                    <option value="">Chọn khách hàng</option>
                                    <c:forEach var="customer" items="${customers}">
                                        <option value="${customer.customerId}"
                                                data-name="${customer.fullName}"
                                                data-phone="${customer.phoneNumber}"
                                                data-email="${customer.email}">
                                            ${customer.fullName} - ${customer.phoneNumber}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div id="selectedCustomerInfo" class="mt-2 p-2 bg-gray-50 rounded-md hidden">
                                    <p class="text-sm text-gray-600">
                                        <strong>Khách hàng:</strong> <span id="customerName"></span><br>
                                        <strong>SĐT:</strong> <span id="customerPhone"></span><br>
                                        <strong>Email:</strong> <span id="customerEmail"></span>
                                    </p>
                                </div>
                            </div>
                            <div id="customerIdError" class="text-red-500 text-sm mt-1 hidden"></div>
                        </div>
                        
                        <!-- Payment Method -->
                        <div>
                            <label for="paymentMethod" class="block text-sm font-medium text-gray-700 mb-2">
                                Phương thức thanh toán <span class="text-red-500">*</span>
                            </label>
                            <select id="paymentMethod" name="paymentMethod" required
                                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                                <option value="">Chọn phương thức thanh toán</option>
                                <option value="CASH">💵 Tiền mặt</option>
                                <option value="BANK_TRANSFER">🏦 Chuyển khoản ngân hàng</option>
                                <option value="CREDIT_CARD">💳 Thẻ tín dụng</option>
                                <option value="VNPAY">📱 VNPay</option>
                                <option value="MOMO">📱 MoMo</option>
                                <option value="ZALOPAY">📱 ZaloPay</option>
                            </select>
                            <div id="paymentMethodError" class="text-red-500 text-sm mt-1 hidden"></div>
                        </div>
                        
                        <!-- Payment Status and Reference Number are auto-generated -->
                        
                        <!-- Amount Section -->
                        <div class="md:col-span-2">
                            <h3 class="text-lg font-medium text-gray-900 mb-4">Thông tin thanh toán</h3>
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                <!-- Subtotal Amount -->
                                <div>
                                    <label for="subtotalAmount" class="block text-sm font-medium text-gray-700 mb-2">
                                        Tiền dịch vụ <span class="text-red-500">*</span>
                                    </label>
                                    <div class="relative">
                                        <input type="text" id="subtotalAmount" name="subtotalAmount" required readonly
                                               class="w-full pl-3 pr-12 py-2 border border-gray-300 rounded-md shadow-sm bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors"
                                               placeholder="Tự động tính từ dịch vụ">
                                        <div class="absolute inset-y-0 right-0 flex items-center px-3 pointer-events-none text-gray-500">
                                            VNĐ
                                        </div>
                                    </div>
                                    <div id="subtotalAmountError" class="text-red-500 text-sm mt-1 hidden"></div>
                                    <p class="text-xs text-gray-500 mt-1">Tự động tính từ các dịch vụ đã chọn</p>
                                </div>

                                <!-- Tax Amount -->
                                <div>
                                    <label for="taxAmount" class="block text-sm font-medium text-gray-700 mb-2">
                                        Thuế VAT (10%)
                                    </label>
                                    <div class="relative">
                                        <input type="text" id="taxAmount" name="taxAmount" readonly
                                               class="w-full pl-3 pr-12 py-2 border border-gray-300 rounded-md shadow-sm bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors"
                                               placeholder="Tự động tính 10%">
                                        <div class="absolute inset-y-0 right-0 flex items-center px-3 pointer-events-none text-gray-500">
                                            VNĐ
                                        </div>
                                    </div>
                                    <div id="taxAmountError" class="text-red-500 text-sm mt-1 hidden"></div>
                                    <p class="text-xs text-gray-500 mt-1">Tự động tính 10% VAT từ tiền dịch vụ</p>
                                </div>

                                <!-- Total Amount -->
                                <div>
                                    <label for="totalAmount" class="block text-sm font-medium text-gray-700 mb-2">
                                        Tổng tiền <span class="text-red-500">*</span>
                                    </label>
                                    <div class="relative">
                                        <input type="text" id="totalAmount" name="totalAmount" required readonly
                                               class="w-full pl-3 pr-12 py-2 border border-gray-300 rounded-md shadow-sm bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors"
                                               placeholder="Tự động tính">
                                        <div class="absolute inset-y-0 right-0 flex items-center px-3 pointer-events-none text-gray-500">
                                            VNĐ
                                        </div>
                                    </div>
                                    <div id="totalAmountError" class="text-red-500 text-sm mt-1 hidden"></div>
                                    <p class="text-xs text-gray-500 mt-1">Tổng tiền khách hàng cần thanh toán</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Service Items Selection -->
                        <div class="md:col-span-2">
                            <h3 class="text-lg font-medium text-gray-900 mb-4">Dịch vụ thanh toán</h3>
                            <div class="border border-gray-200 rounded-lg p-4">
                                <div class="flex items-center justify-between mb-4">
                                    <label class="block text-sm font-medium text-gray-700">
                                        Chọn dịch vụ
                                    </label>
                                    <button type="button" id="addServiceBtn"
                                            class="px-3 py-1 text-sm bg-primary text-white rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary transition-colors">
                                        <i data-lucide="plus" class="w-4 h-4 inline mr-1"></i>
                                        Thêm dịch vụ
                                    </button>
                                </div>

                                <div id="serviceItemsContainer">
                                    <!-- Service items will be added here dynamically -->
                                    <div class="text-center py-8 text-gray-500">
                                        <i data-lucide="package" class="w-12 h-12 mx-auto mb-2 text-gray-400"></i>
                                        <p>Chưa có dịch vụ nào được chọn</p>
                                        <p class="text-sm">Nhấn "Thêm dịch vụ" để bắt đầu</p>
                                    </div>
                                </div>

                                <!-- Service Selection Modal Template (Hidden) -->
                                <div id="serviceSelectionTemplate" class="hidden">
                                    <div class="service-item border border-gray-200 rounded-md p-4 mb-3">
                                        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                                            <div>
                                                <label class="block text-sm font-medium text-gray-700 mb-1">Dịch vụ</label>
                                                <select class="service-select w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                                                    <option value="">Chọn dịch vụ</option>
                                                    <c:forEach var="service" items="${services}">
                                                        <option value="${service.serviceId}"
                                                                data-price="${service.price}"
                                                                data-duration="${service.durationMinutes}">
                                                            ${service.name} - <fmt:formatNumber value="${service.price}" pattern="#,###"/> VNĐ
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="block text-sm font-medium text-gray-700 mb-1">Số lượng</label>
                                                <input type="number" class="quantity-input w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors"
                                                       value="1" min="1" max="10">
                                            </div>
                                            <div>
                                                <label class="block text-sm font-medium text-gray-700 mb-1">Đơn giá</label>
                                                <input type="text" class="unit-price w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm bg-gray-50"
                                                       readonly placeholder="0 VNĐ">
                                            </div>
                                            <div class="flex items-end">
                                                <button type="button" class="remove-service-btn w-full px-3 py-2 text-sm bg-red-500 text-white rounded-md hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-red-500 transition-colors">
                                                    <i data-lucide="trash-2" class="w-4 h-4 inline mr-1"></i>
                                                    Xóa
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
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
                                class="px-6 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 transition-colors">
                            <i data-lucide="dollar-sign" class="w-4 h-4 inline mr-2"></i>
                            Thanh Toán Tiền Mặt
                        </button>
                    </div>
                </form>
            </div>
        </div>
        </div>
    </main>

    <!-- External JavaScript -->
    <script src="${pageContext.request.contextPath}/js/payment-form.js"></script>

    <script>
        // Initialize Lucide icons
        lucide.createIcons();

        // Set default payment date to current time
        document.addEventListener('DOMContentLoaded', function() {
            var paymentDate = document.getElementById('paymentDate');
            if (paymentDate) {
                var now = new Date();
                var localDateTime = new Date(now.getTime() - now.getTimezoneOffset() * 60000)
                    .toISOString().slice(0, 16);
                paymentDate.value = localDateTime;
            }
        });
    </script>
</body>
</html>
