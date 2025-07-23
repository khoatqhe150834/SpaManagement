<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="context-path" content="${pageContext.request.contextPath}" />
    <title>Chỉnh Sửa Thanh Toán #${payment.paymentId} - Spa Hương Sen</title>
    
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
        
        /* Read-only field styling */
        .readonly-field {
            background-color: #f9fafb;
            color: #6b7280;
            cursor: not-allowed;
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
                <li>
                    <div class="flex items-center">
                        <i data-lucide="chevron-right" class="w-4 h-4 text-gray-400"></i>
                        <a href="${pageContext.request.contextPath}/manager/payment-details?id=${payment.paymentId}" class="ml-1 text-sm font-medium text-gray-700 hover:text-primary md:ml-2">Chi Tiết #${payment.paymentId}</a>
                    </div>
                </li>
                <li aria-current="page">
                    <div class="flex items-center">
                        <i data-lucide="chevron-right" class="w-4 h-4 text-gray-400"></i>
                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Chỉnh Sửa</span>
                    </div>
                </li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-spa-dark mb-2">Chỉnh Sửa Thanh Toán #${payment.paymentId}</h1>
            <p class="text-gray-600">Cập nhật thông tin giao dịch thanh toán</p>
        </div>

        <!-- Warning Notice -->
        <div class="mb-6 bg-yellow-50 border-l-4 border-yellow-400 p-4 rounded-md">
            <div class="flex">
                <div class="flex-shrink-0">
                    <i data-lucide="alert-triangle" class="h-5 w-5 text-yellow-400"></i>
                </div>
                <div class="ml-3">
                    <p class="text-sm text-yellow-700">
                        <strong>Lưu ý:</strong> Việc chỉnh sửa thanh toán sẽ được ghi lại trong hệ thống để đảm bảo tính minh bạch và kiểm toán.
                        Chỉ chỉnh sửa khi thực sự cần thiết.
                    </p>
                </div>
            </div>
        </div>

        <!-- Debug Information (Remove in production) -->
        <c:if test="${param.debug == 'true'}">
            <div class="mb-6 bg-blue-50 border-l-4 border-blue-400 p-4 rounded-md">
                <div class="text-sm text-blue-700">
                    <p><strong>Debug Info:</strong></p>
                    <p>Payment Items: ${not empty payment.paymentItems ? payment.paymentItems.size() : 0}</p>
                    <p>Available Services: ${not empty services ? services.size() : 0}</p>
                    <c:if test="${not empty payment.paymentItems}">
                        <p>First Item Service: ${payment.paymentItems[0].service.name} (Price: ${payment.paymentItems[0].service.price})</p>
                    </c:if>
                </div>
            </div>
        </c:if>

        <!-- Payment Edit Form -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200">
            <div class="p-6">
                <form id="editPaymentForm" class="space-y-6">
                    <!-- Hidden fields -->
                    <input type="hidden" id="paymentId" name="paymentId" value="${payment.paymentId}">
                    
                    <!-- Payment Reference (Read-only) -->
                    <div>
                        <label for="referenceNumber" class="block text-sm font-medium text-gray-700 mb-2">
                            Mã tham chiếu
                        </label>
                        <input type="text" id="referenceNumber" name="referenceNumber" 
                               value="${payment.referenceNumber}" readonly
                               class="w-full px-3 py-2 border border-gray-300 rounded-md readonly-field">
                    </div>

                    <!-- Customer Information (Read-only) -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="customerName" class="block text-sm font-medium text-gray-700 mb-2">
                                Tên khách hàng
                            </label>
                            <input type="text" id="customerName" name="customerName" 
                                   value="${customerName}" readonly
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md readonly-field">
                        </div>
                        <div>
                            <label for="customerPhone" class="block text-sm font-medium text-gray-700 mb-2">
                                Số điện thoại
                            </label>
                            <input type="text" id="customerPhone" name="customerPhone" 
                                   value="${customerPhone}" readonly
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md readonly-field">
                        </div>
                    </div>

                    <!-- Payment Date -->
                    <div>
                        <label for="paymentDate" class="block text-sm font-medium text-gray-700 mb-2">
                            Ngày thanh toán <span class="text-red-500">*</span>
                        </label>
                        <input type="datetime-local" id="paymentDate" name="paymentDate" required
                               value="<fmt:formatDate value='${payment.paymentDate}' pattern='yyyy-MM-dd\'T\'HH:mm'/>"
                               class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                    </div>

                    <!-- Payment Method -->
                    <div>
                        <label for="paymentMethod" class="block text-sm font-medium text-gray-700 mb-2">
                            Phương thức thanh toán <span class="text-red-500">*</span>
                        </label>
                        <select id="paymentMethod" name="paymentMethod" required
                                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                            <option value="">Chọn phương thức thanh toán</option>
                            <option value="CASH" ${payment.paymentMethod == 'CASH' ? 'selected' : ''}>Tiền mặt</option>
                            <option value="BANK_TRANSFER" ${payment.paymentMethod == 'BANK_TRANSFER' ? 'selected' : ''}>Chuyển khoản ngân hàng</option>
                            <option value="CREDIT_CARD" ${payment.paymentMethod == 'CREDIT_CARD' ? 'selected' : ''}>Thẻ tín dụng</option>
                            <option value="VNPAY" ${payment.paymentMethod == 'VNPAY' ? 'selected' : ''}>VNPay</option>
                            <option value="MOMO" ${payment.paymentMethod == 'MOMO' ? 'selected' : ''}>MoMo</option>
                            <option value="ZALOPAY" ${payment.paymentMethod == 'ZALOPAY' ? 'selected' : ''}>ZaloPay</option>
                        </select>
                    </div>

                    <!-- Payment Status -->
                    <div>
                        <label for="paymentStatus" class="block text-sm font-medium text-gray-700 mb-2">
                            Trạng thái thanh toán <span class="text-red-500">*</span>
                        </label>
                        <select id="paymentStatus" name="paymentStatus" required
                                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                            <option value="">Chọn trạng thái</option>
                            <option value="PAID" ${payment.paymentStatus == 'PAID' ? 'selected' : ''}>Đã thanh toán</option>
                            <option value="PENDING" ${payment.paymentStatus == 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                            <option value="FAILED" ${payment.paymentStatus == 'FAILED' ? 'selected' : ''}>Thất bại</option>
                            <option value="REFUNDED" ${payment.paymentStatus == 'REFUNDED' ? 'selected' : ''}>Đã hoàn tiền</option>
                        </select>
                    </div>

                    <!-- Notes -->
                    <div>
                        <label for="notes" class="block text-sm font-medium text-gray-700 mb-2">
                            Ghi chú
                        </label>
                        <textarea id="notes" name="notes" rows="3"
                                  class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors"
                                  placeholder="Nhập ghi chú về thanh toán...">${payment.notes}</textarea>
                    </div>

                    <!-- Service Items Section -->
                    <div class="border-t border-gray-200 pt-6">
                        <div class="flex items-center justify-between mb-4">
                            <h3 class="text-lg font-medium text-spa-dark">Dịch vụ đã thanh toán</h3>
                            <button type="button" id="addServiceBtn"
                                    class="px-4 py-2 bg-primary text-white rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2 transition-colors">
                                <i data-lucide="plus" class="w-4 h-4 inline mr-2"></i>
                                Thêm dịch vụ
                            </button>
                        </div>

                        <!-- Service Items Container -->
                        <div id="serviceItemsContainer" class="space-y-4">
                            <c:forEach var="item" items="${payment.paymentItems}" varStatus="status">
                                <div class="service-item bg-gray-50 p-4 rounded-lg border border-gray-200" data-item-id="${item.paymentItemId}">
                                    <div class="flex items-center justify-between mb-3">
                                        <h4 class="font-medium text-gray-900">
                                            Dịch vụ #${status.index + 1}
                                            <c:if test="${not empty item.service}">
                                                - ${item.service.name}
                                            </c:if>
                                        </h4>
                                        <button type="button" class="remove-service-btn text-red-600 hover:text-red-800 focus:outline-none">
                                            <i data-lucide="trash-2" class="w-4 h-4"></i>
                                        </button>
                                    </div>

                                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-1">
                                                Dịch vụ <span class="text-red-500">*</span>
                                            </label>
                                            <select name="serviceId" required
                                                    class="service-select w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                                                <option value="">Chọn dịch vụ</option>
                                                <c:forEach var="service" items="${services}">
                                                    <option value="${service.serviceId}"
                                                            data-price="${service.price}"
                                                            ${item.serviceId == service.serviceId ? 'selected' : ''}>
                                                        ${service.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-1">
                                                Số lượng <span class="text-red-500">*</span>
                                            </label>
                                            <input type="number" name="quantity" min="1" required
                                                   value="${item.quantity}"
                                                   class="quantity-input w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                                        </div>

                                        <div>
                                            <label class="block text-sm font-medium text-gray-700 mb-1">
                                                Đơn giá
                                            </label>
                                            <input type="text" name="unitPrice" readonly
                                                   value="<fmt:formatNumber value='${item.unitPrice}' type='currency' currencySymbol='₫' groupingUsed='true'/>"
                                                   class="unit-price w-full px-3 py-2 border border-gray-300 rounded-md readonly-field">
                                        </div>
                                    </div>

                                    <div class="mt-3">
                                        <label class="block text-sm font-medium text-gray-700 mb-1">
                                            Thành tiền
                                        </label>
                                        <input type="text" name="totalPrice" readonly
                                               value="<fmt:formatNumber value='${item.totalPrice}' type='currency' currencySymbol='₫' groupingUsed='true'/>"
                                               class="total-price w-full px-3 py-2 border border-gray-300 rounded-md readonly-field font-medium">
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Empty State -->
                        <div id="emptyServiceState" class="text-center py-8 text-gray-500 ${not empty payment.paymentItems ? 'hidden' : ''}">
                            <i data-lucide="package" class="w-12 h-12 mx-auto mb-4 text-gray-400"></i>
                            <p class="text-lg font-medium mb-2">Chưa có dịch vụ nào</p>
                            <p class="text-sm">Nhấn "Thêm dịch vụ" để bắt đầu</p>
                        </div>
                    </div>

                    <!-- Payment Summary -->
                    <div class="border-t border-gray-200 pt-6">
                        <h3 class="text-lg font-medium text-spa-dark mb-4">Tổng kết thanh toán</h3>

                        <div class="bg-gray-50 p-4 rounded-lg space-y-3">
                            <div class="flex justify-between items-center">
                                <span class="text-gray-600">Tạm tính:</span>
                                <span id="subtotalAmount" class="font-medium">
                                    <fmt:formatNumber value="${payment.subtotalAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                </span>
                            </div>

                            <div class="flex justify-between items-center">
                                <span class="text-gray-600">Thuế VAT (10%):</span>
                                <span id="taxAmount" class="font-medium">
                                    <fmt:formatNumber value="${payment.taxAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                </span>
                            </div>

                            <div class="border-t border-gray-300 pt-3">
                                <div class="flex justify-between items-center">
                                    <span class="text-lg font-semibold text-spa-dark">Tổng cộng:</span>
                                    <span id="totalAmount" class="text-xl font-bold text-primary">
                                        <fmt:formatNumber value="${payment.totalAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="flex items-center justify-end space-x-4 mt-8 pt-6 border-t border-gray-200">
                        <a href="${pageContext.request.contextPath}/manager/payment-details?id=${payment.paymentId}"
                           class="px-6 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                            <i data-lucide="x" class="w-4 h-4 inline mr-2"></i>
                            Hủy
                        </a>
                        <button type="submit" id="submitBtn"
                                class="px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors">
                            <i data-lucide="save" class="w-4 h-4 inline mr-2"></i>
                            Cập nhật thanh toán
                        </button>
                    </div>
                </form>
            </div>
        </div>
        </div>
    </main>

    <!-- Service Selection Template (Hidden) -->
    <div id="serviceSelectionTemplate" class="hidden">
        <div class="service-item bg-gray-50 p-4 rounded-lg border border-gray-200">
            <div class="flex items-center justify-between mb-3">
                <h4 class="font-medium text-gray-900">Dịch vụ mới</h4>
                <button type="button" class="remove-service-btn text-red-600 hover:text-red-800 focus:outline-none">
                    <i data-lucide="trash-2" class="w-4 h-4"></i>
                </button>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                        Dịch vụ <span class="text-red-500">*</span>
                    </label>
                    <select name="serviceId" required
                            class="service-select w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                        <option value="">Chọn dịch vụ</option>
                        <c:forEach var="service" items="${services}">
                            <option value="${service.serviceId}" data-price="${service.price}">
                                ${service.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                        Số lượng <span class="text-red-500">*</span>
                    </label>
                    <input type="number" name="quantity" min="1" value="1" required
                           class="quantity-input w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-colors">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">
                        Đơn giá
                    </label>
                    <input type="text" name="unitPrice" readonly
                           class="unit-price w-full px-3 py-2 border border-gray-300 rounded-md readonly-field">
                </div>
            </div>

            <div class="mt-3">
                <label class="block text-sm font-medium text-gray-700 mb-1">
                    Thành tiền
                </label>
                <input type="text" name="totalPrice" readonly
                       class="total-price w-full px-3 py-2 border border-gray-300 rounded-md readonly-field font-medium">
            </div>
        </div>
    </div>

    <!-- Global variables for JavaScript -->
    <script>
        window.isEditMode = true;
        window.currentPaymentId = '${payment.paymentId}';
    </script>

    <!-- External JavaScript -->
    <script src="${pageContext.request.contextPath}/js/payment-edit.js"></script>

    <script>
        // Initialize Lucide icons
        lucide.createIcons();
    </script>
</body>
</html>
