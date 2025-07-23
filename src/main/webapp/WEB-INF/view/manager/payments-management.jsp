<%-- 
    Document   : payments-management.jsp
    Created on : Payment Management for Managers
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="context-path" content="${pageContext.request.contextPath}" />
    <title>Quản Lý Thanh Toán - Spa Hương Sen</title>
    
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
              "spa-gray": "#F3F4F6",
            },
            fontFamily: {
              sans: ["Roboto", "sans-serif"],
            },
          },
        },
      };
    </script>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>

    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/select/1.7.0/css/select.dataTables.min.css">
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/select/1.7.0/js/dataTables.select.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>

    <!-- Date Range Picker -->
    <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />

    <style>
        /* Custom DataTables styling to match our theme */
        .dataTables_wrapper {
            font-family: 'Roboto', sans-serif;
        }
        
        .dataTables_filter input {
            border: 1px solid #d1d5db;
            border-radius: 8px;
            padding: 8px 12px;
            margin-left: 8px;
        }
        
        .dataTables_filter input:focus {
            outline: none;
            border-color: #D4AF37;
            box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
        }
        
        .dataTables_length select {
            border: 1px solid #d1d5db;
            border-radius: 8px;
            padding: 4px 8px;
            margin: 0 8px;
        }
        
        .dataTables_paginate .paginate_button {
            border: 1px solid #d1d5db;
            border-radius: 6px;
            padding: 8px 12px;
            margin: 0 2px;
            background: white;
            color: #374151;
        }
        
        .dataTables_paginate .paginate_button:hover {
            background: #FFF8F0;
            border-color: #D4AF37;
            color: #D4AF37;
        }
        
        .dataTables_paginate .paginate_button.current {
            background: #D4AF37;
            border-color: #D4AF37;
            color: white;
        }
        
        .dataTables_info {
            color: #6b7280;
            font-size: 0.875rem;
        }
        
        table.dataTable thead th {
            border-bottom: 2px solid #e5e7eb;
            font-weight: 600;
            color: #374151;
        }
        
        table.dataTable tbody tr:hover {
            background-color: rgba(255, 248, 240, 0.5);
        }
        
        /* Filter panel styling */
        .filter-panel {
            transition: max-height 0.3s ease-in-out, opacity 0.3s ease-in-out;
            max-height: 0;
            opacity: 0;
            overflow: hidden;
        }
        
        .filter-panel.show {
            max-height: 500px;
            opacity: 1;
        }
        
        /* Date range picker custom styling */
        .daterangepicker {
            font-family: 'Roboto', sans-serif;
            border-radius: 8px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        
        .daterangepicker .ranges li.active {
            background-color: #D4AF37;
        }
        
        .daterangepicker td.active, .daterangepicker td.active:hover {
            background-color: #D4AF37;
        }
        
        .daterangepicker .btn-primary {
            background-color: #D4AF37;
            border-color: #D4AF37;
        }
        
        /* Status badge styling */
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        /* Form validation styling */
        .field-error {
            animation: shake 0.3s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        /* Modal animation */
        .modal-enter {
            animation: modalFadeIn 0.3s ease-out;
        }

        @keyframes modalFadeIn {
            from {
                opacity: 0;
                transform: scale(0.95);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
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
<body class="bg-spa-cream font-sans text-spa-dark">
    
    <!-- Include Sidebar -->
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" /> 
   <main class="w-full md:w-[calc(100%-256px)] md:ml-64 bg-white min-h-screen transition-all main">
        <!-- Modern Navbar -->
        <div class="h-16 px-6 bg-spa-cream flex items-center shadow-sm border-b border-primary/10 sticky top-0 left-0 z-30">
            <button type="button" class="text-lg text-spa-dark font-semibold sidebar-toggle hover:text-primary transition-colors duration-200 hidden">
                <i class="ri-menu-line"></i>
            </button>

            <ul class="ml-auto flex items-center">
                <li class="dropdown ml-3">
                    <button type="button" class="dropdown-toggle flex items-center hover:bg-primary/10 rounded-lg p-2 transition-all duration-200">
                        <div class="flex-shrink-0 w-10 h-10 relative">
                            <div class="p-1 bg-white rounded-full focus:outline-none focus:ring-2 focus:ring-primary/20">
                                <img class="w-8 h-8 rounded-full object-cover" src="https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=100" alt="Manager Avatar"/>
                                <div class="top-0 left-7 absolute w-3 h-3 bg-green-400 border-2 border-white rounded-full animate-ping"></div>
                                <div class="top-0 left-7 absolute w-3 h-3 bg-green-500 border-2 border-white rounded-full"></div>
                            </div>
                        </div>
                        <div class="p-2 md:block text-left">
                            <h2 class="text-sm font-semibold text-spa-dark">${sessionScope.staff.fullName}</h2>
                            <p class="text-xs text-primary/70">Quản lý</p>
                        </div>                
                    </button>
                    <ul class="dropdown-menu shadow-lg shadow-black/10 z-30 hidden py-2 rounded-lg bg-white border border-primary/20 w-full max-w-[160px]">
                        <li>
                            <a href="${pageContext.request.contextPath}/staff/profile" class="flex items-center text-sm py-2 px-4 text-spa-dark hover:text-primary hover:bg-spa-cream transition-all duration-200">
                                <i data-lucide="user" class="h-4 w-4 mr-2"></i>
                                Hồ sơ
                            </a>
                        </li>
                        <li class="border-t border-primary/10 mt-1 pt-1">
                            <a href="${pageContext.request.contextPath}/logout" class="flex items-center text-sm py-2 px-4 text-red-600 hover:bg-red-50 cursor-pointer transition-all duration-200">
                                <i data-lucide="log-out" class="h-4 w-4 mr-2"></i>
                                Đăng xuất
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>

        <!-- Content -->
        <div class="p-6 bg-spa-cream min-h-screen">
            <!-- Dashboard Stats -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
                <!-- Total Payments -->
                <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-500 mb-1">Tổng thanh toán</p>
                            <h3 class="text-2xl font-bold text-spa-dark">
                                <fmt:formatNumber value="${totalPaymentsAmount}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                            </h3>
                        </div>
                        <div class="h-12 w-12 bg-primary/10 rounded-full flex items-center justify-center">
                            <i data-lucide="credit-card" class="h-6 w-6 text-primary"></i>
                        </div>
                    </div>
                    <div class="mt-4 flex items-center text-xs">
                        <span class="flex items-center text-green-600">
                            <i data-lucide="trending-up" class="h-3 w-3 mr-1"></i>
                            ${paymentGrowthRate}%
                        </span>
                        <span class="text-gray-500 ml-2">so với tháng trước</span>
                    </div>
                </div>

                <!-- Completed Payments -->
                <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-500 mb-1">Đã thanh toán</p>
                            <h3 class="text-2xl font-bold text-green-600">
                                <fmt:formatNumber value="${completedPaymentsAmount}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                            </h3>
                        </div>
                        <div class="h-12 w-12 bg-green-100 rounded-full flex items-center justify-center">
                            <i data-lucide="check-circle" class="h-6 w-6 text-green-600"></i>
                        </div>
                    </div>
                    <div class="mt-4 flex items-center text-xs">
                        <span class="text-gray-500">
                            ${completedPaymentsCount} giao dịch thành công
                        </span>
                    </div>
                </div>     
           <!-- Pending Payments -->
                <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-500 mb-1">Chờ xử lý</p>
                            <h3 class="text-2xl font-bold text-yellow-600">
                                <fmt:formatNumber value="${pendingPaymentsAmount}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                            </h3>
                        </div>
                        <div class="h-12 w-12 bg-yellow-100 rounded-full flex items-center justify-center">
                            <i data-lucide="clock" class="h-6 w-6 text-yellow-600"></i>
                        </div>
                    </div>
                    <div class="mt-4 flex items-center text-xs">
                        <span class="text-gray-500">
                            ${pendingPaymentsCount} giao dịch đang chờ
                        </span>
                    </div>
                </div>

                <!-- Failed/Refunded Payments -->
                <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-500 mb-1">Hoàn tiền/Thất bại</p>
                            <h3 class="text-2xl font-bold text-red-600">
                                <fmt:formatNumber value="${failedRefundedPaymentsAmount}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                            </h3>
                        </div>
                        <div class="h-12 w-12 bg-red-100 rounded-full flex items-center justify-center">
                            <i data-lucide="alert-circle" class="h-6 w-6 text-red-600"></i>
                        </div>
                    </div>
                    <div class="mt-4 flex items-center text-xs">
                        <span class="text-gray-500">
                            ${failedPaymentsCount} thất bại, ${refundedPaymentsCount} hoàn tiền
                        </span>
                    </div>
                </div>
            </div>



            <!-- Payments Management Section -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden mb-6">
                <div class="p-6 border-b border-gray-200 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                    <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                        <i data-lucide="credit-card" class="h-6 w-6 text-primary"></i>
                        Quản lý thanh toán
                    </h2>
                    
                    <div class="flex flex-wrap items-center gap-3">
                        <!-- Filter Toggle Button -->
                        <button id="toggleFilters" class="inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                            <i data-lucide="filter" class="h-4 w-4 mr-2"></i>
                            Bộ lọc
                        </button>
                        
                        <!-- Date Range Picker -->
                        <div class="relative">
                            <input type="text" id="dateRangePicker" class="px-4 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" placeholder="Chọn khoảng thời gian" readonly />
                        </div>
                        
                        <!-- Add Payment Button -->
                        <button id="addPaymentBtn" class="inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-primary rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary/20">
                            <i data-lucide="plus" class="h-4 w-4 mr-2"></i>
                            Thêm thanh toán
                        </button>
                    </div>
                </div>     
           <!-- Filter Panel -->
                <div id="filterPanel" class="filter-panel px-6 py-0 border-b border-gray-200 bg-spa-gray/30">
                    <div class="py-4 grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-4">
                        <!-- Customer Filter -->
                        <div>
                            <label for="customerFilter" class="block text-sm font-medium text-gray-700 mb-1">Khách hàng</label>
                            <select id="customerFilter" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                <option value="">Tất cả khách hàng</option>
                                <c:forEach var="customer" items="${customers}">
                                    <option value="${customer.id}">${customer.fullName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <!-- Payment Method Filter -->
                        <div>
                            <label for="methodFilter" class="block text-sm font-medium text-gray-700 mb-1">Phương thức</label>
                            <select id="methodFilter" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                <option value="">Tất cả phương thức</option>
                                <option value="BANK_TRANSFER">Chuyển khoản</option>
                                <option value="CREDIT_CARD">Thẻ tín dụng</option>
                                <option value="VNPAY">VNPay</option>
                                <option value="MOMO">MoMo</option>
                                <option value="ZALOPAY">ZaloPay</option>
                                <option value="CASH">Tiền mặt</option>
                            </select>
                        </div>
                        
                        <!-- Payment Status Filter -->
                        <div>
                            <label for="statusFilter" class="block text-sm font-medium text-gray-700 mb-1">Trạng thái</label>
                            <select id="statusFilter" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                <option value="">Tất cả trạng thái</option>
                                <option value="PAID">Đã thanh toán</option>
                                <option value="PENDING">Chờ xử lý</option>
                                <option value="FAILED">Thất bại</option>
                                <option value="REFUNDED">Đã hoàn tiền</option>
                            </select>
                        </div>
                        
                        <!-- Amount Range Filter -->
                        <div>
                            <label for="amountFilter" class="block text-sm font-medium text-gray-700 mb-1">Số tiền</label>
                            <div class="flex items-center gap-2">
                                <input type="number" id="minAmount" placeholder="Từ" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                <span>-</span>
                                <input type="number" id="maxAmount" placeholder="Đến" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>
                        </div>
                    </div>
                    
                    <!-- Filter Actions -->
                    <div class="flex justify-end py-3 gap-3 border-t border-gray-200">
                        <button id="resetFilters" class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                            Đặt lại
                        </button>
                        <button id="applyFilters" class="px-4 py-2 text-sm font-medium text-white bg-primary rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary/20">
                            Áp dụng
                        </button>
                    </div>
                </div>

                <!-- Payments Table -->
                <div class="p-6">
                    <c:choose>
                        <c:when test="${payments != null && not empty payments}">
                            <table id="paymentsTable" class="w-full display responsive nowrap" style="width:100%">
                                <thead>
                                    <tr>
                                        <th>Mã thanh toán</th>
                                        <th>Khách hàng</th>
                                        <th>Ngày thanh toán</th>
                                        <th>Phương thức</th>
                                        <th>Số tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Ghi chú</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="payment" items="${payments}">
                                        <tr>
                                            <td>#${payment.paymentId}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${payment.customer != null}">
                                                        <div class="flex items-center">
                                                            <div class="flex-shrink-0 h-8 w-8">
                                                                <img class="h-8 w-8 rounded-full object-cover"
                                                                     src="https://ui-avatars.com/api/?name=${payment.customer.fullName}&background=D4AF37&color=fff"
                                                                     alt="${payment.customer.fullName}">
                                                            </div>
                                                            <div class="ml-3">
                                                                <p class="text-sm font-medium text-gray-900">${payment.customer.fullName}</p>
                                                                <p class="text-xs text-gray-500">${payment.customer.phoneNumber}</p>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400">Khách hàng không xác định</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td data-order="<fmt:formatDate value="${payment.paymentDate}" pattern="yyyy-MM-dd HH:mm"/>">
                                                <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${payment.paymentMethod == 'BANK_TRANSFER'}">Chuyển khoản</c:when>
                                                    <c:when test="${payment.paymentMethod == 'CREDIT_CARD'}">Thẻ tín dụng</c:when>
                                                    <c:when test="${payment.paymentMethod == 'VNPAY'}">VNPay</c:when>
                                                    <c:when test="${payment.paymentMethod == 'MOMO'}">MoMo</c:when>
                                                    <c:when test="${payment.paymentMethod == 'ZALOPAY'}">ZaloPay</c:when>
                                                    <c:when test="${payment.paymentMethod == 'CASH'}">Tiền mặt</c:when>
                                                    <c:otherwise>${payment.paymentMethod}</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td data-order="${payment.totalAmount}">
                                                <span class="font-semibold text-primary">
                                                    <fmt:formatNumber value="${payment.totalAmount}" type="currency"
                                                                    currencySymbol="" pattern="#,##0"/> VNĐ
                                                </span>
                                                <span class="hidden">${payment.totalAmount}</span>
                                            </td>   
                                            <td>
                                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium
                                                    <c:choose>
                                                        <c:when test="${payment.paymentStatus == 'PAID'}">bg-green-100 text-green-800</c:when>
                                                        <c:when test="${payment.paymentStatus == 'PENDING'}">bg-yellow-100 text-yellow-800</c:when>
                                                        <c:when test="${payment.paymentStatus == 'FAILED'}">bg-red-100 text-red-800</c:when>
                                                        <c:when test="${payment.paymentStatus == 'REFUNDED'}">bg-blue-100 text-blue-800</c:when>
                                                        <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                                                    </c:choose>">
                                                    <c:choose>
                                                        <c:when test="${payment.paymentStatus == 'PAID'}">Đã thanh toán</c:when>
                                                        <c:when test="${payment.paymentStatus == 'PENDING'}">Chờ xử lý</c:when>
                                                        <c:when test="${payment.paymentStatus == 'FAILED'}">Thất bại</c:when>
                                                        <c:when test="${payment.paymentStatus == 'REFUNDED'}">Đã hoàn tiền</c:when>
                                                        <c:otherwise>${payment.paymentStatus}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty payment.notes}">
                                                        ${payment.notes}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-gray-400">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="flex items-center gap-2">
                                                    <!-- View Button -->
                                                    <button onclick="viewPayment(${payment.paymentId})" 
                                                            class="inline-flex items-center px-2 py-1 text-xs font-medium text-blue-600 bg-blue-50 rounded-md hover:bg-blue-100 transition-colors duration-200"
                                                            title="Xem chi tiết">
                                                        <i data-lucide="eye" class="h-3 w-3 mr-1"></i>
                                                        Xem
                                                    </button>
                                                    
                                                    <!-- Edit Button -->
                                                    <button onclick="editPayment(${payment.paymentId})" 
                                                            class="inline-flex items-center px-2 py-1 text-xs font-medium text-amber-600 bg-amber-50 rounded-md hover:bg-amber-100 transition-colors duration-200"
                                                            title="Chỉnh sửa">
                                                        <i data-lucide="edit" class="h-3 w-3 mr-1"></i>
                                                        Sửa
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <!-- Empty State -->
                            <div class="p-12 text-center">
                                <i data-lucide="receipt" class="h-16 w-16 text-gray-400 mx-auto mb-4"></i>
                                <h3 class="text-lg font-semibold text-spa-dark mb-2">Chưa có dữ liệu thanh toán</h3>
                                <p class="text-gray-600 mb-6">Hiện tại chưa có giao dịch thanh toán nào được ghi nhận trong hệ thống.</p>
                                <button id="emptyAddPaymentBtn" class="bg-primary hover:bg-primary-dark text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200 inline-flex items-center gap-2">
                                    <i data-lucide="plus-circle" class="h-5 w-5"></i>
                                    Thêm thanh toán mới
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div> 
           
            
        </div>
    </main>

    <!-- Add/Edit Payment Modal -->
    <div id="paymentModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center hidden">
        <div class="bg-white rounded-xl shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div class="p-6 border-b border-gray-200 flex items-center justify-between">
                <h3 class="text-lg font-semibold text-spa-dark" id="modalTitle">Thêm thanh toán mới</h3>
                <button id="closeModal" class="text-gray-400 hover:text-gray-500">
                    <i data-lucide="x" class="h-5 w-5"></i>
                </button>
            </div>
            
            <form id="paymentForm" class="p-6">
                <input type="hidden" id="paymentId" name="paymentId">
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <!-- Customer Selection -->
                    <div>
                        <label for="customerId" class="block text-sm font-medium text-gray-700 mb-1">Khách hàng <span class="text-red-500">*</span></label>
                        <select id="customerId" name="customerId" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" required>
                            <option value="">Chọn khách hàng</option>
                            <c:forEach var="customer" items="${customers}">
                                <option value="${customer.id}">${customer.fullName} - ${customer.phoneNumber}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <!-- Payment Date -->
                    <div>
                        <label for="paymentDate" class="block text-sm font-medium text-gray-700 mb-1">Ngày thanh toán <span class="text-red-500">*</span></label>
                        <input type="datetime-local" id="paymentDate" name="paymentDate" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" required>
                    </div>

                    <!-- Payment Method -->
                    <div>
                        <label for="paymentMethod" class="block text-sm font-medium text-gray-700 mb-1">Phương thức thanh toán <span class="text-red-500">*</span></label>
                        <select id="paymentMethod" name="paymentMethod" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" required>
                            <option value="">Chọn phương thức</option>
                            <option value="BANK_TRANSFER">Chuyển khoản</option>
                            <option value="CREDIT_CARD">Thẻ tín dụng</option>
                            <option value="VNPAY">VNPay</option>
                            <option value="MOMO">MoMo</option>
                            <option value="ZALOPAY">ZaloPay</option>
                            <option value="CASH">Tiền mặt</option>
                        </select>
                    </div>

                    <!-- Payment Status -->
                    <div>
                        <label for="paymentStatus" class="block text-sm font-medium text-gray-700 mb-1">Trạng thái <span class="text-red-500">*</span></label>
                        <select id="paymentStatus" name="paymentStatus" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" required>
                            <option value="PAID">Đã thanh toán</option>
                            <option value="PENDING">Chờ xử lý</option>
                            <option value="FAILED">Thất bại</option>
                            <option value="REFUNDED">Đã hoàn tiền</option>
                        </select>
                    </div>
                    
                    <!-- Total Amount -->
                    <div class="md:col-span-2">
                        <label for="totalAmount" class="block text-sm font-medium text-gray-700 mb-1">Số tiền <span class="text-red-500">*</span></label>
                        <div class="relative">
                            <input type="number" id="totalAmount" name="totalAmount" min="0" step="1000" class="w-full pl-3 pr-12 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" required>
                            <div class="absolute inset-y-0 right-0 flex items-center px-3 pointer-events-none text-gray-500">
                                VNĐ
                            </div>
                        </div>
                    </div>

                    <!-- Notes -->
                    <div class="md:col-span-2">
                        <label for="notes" class="block text-sm font-medium text-gray-700 mb-1">Ghi chú</label>
                        <textarea id="notes" name="notes" rows="3" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" placeholder="Nhập ghi chú về thanh toán (tùy chọn)"></textarea>
                    </div>
                </div>
                
                <div class="flex justify-end gap-3">
                    <button type="button" id="cancelPayment" class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                        Hủy
                    </button>
                    <button type="submit" class="px-4 py-2 text-sm font-medium text-white bg-primary rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary/20">
                        Lưu thanh toán
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <!-- External JavaScript -->
    <script src="${pageContext.request.contextPath}/js/payments-management.js?v=<%= System.currentTimeMillis() %>"></script>

    <!-- Initialize chart data for external JS -->
    <script>
        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
        
        // Make chart data available to external JS
        try {
            window.chartData = {
                cashPaymentsPercent: ${empty cashPaymentsPercent ? 20 : cashPaymentsPercent},
                bankTransferPaymentsPercent: ${empty bankTransferPaymentsPercent ? 30 : bankTransferPaymentsPercent},
                creditCardPaymentsPercent: ${empty creditCardPaymentsPercent ? 15 : creditCardPaymentsPercent},
                vnpayPaymentsPercent: ${empty vnpayPaymentsPercent ? 15 : vnpayPaymentsPercent},
                momoPaymentsPercent: ${empty momoPaymentsPercent ? 10 : momoPaymentsPercent},
                zalopayPaymentsPercent: ${empty zalopayPaymentsPercent ? 10 : zalopayPaymentsPercent},
                monthlyRevenueLabels: ${empty monthlyRevenueLabels ? "['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6']" : monthlyRevenueLabels},
                monthlyRevenueData: ${empty monthlyRevenueData ? "[0, 0, 0, 0, 0, 0]" : monthlyRevenueData}
            };
        } catch (e) {
            console.error('Error initializing chart data:', e);
            window.chartData = {
                cashPaymentsPercent: 20,
                bankTransferPaymentsPercent: 30,
                creditCardPaymentsPercent: 15,
                vnpayPaymentsPercent: 15,
                momoPaymentsPercent: 10,
                zalopayPaymentsPercent: 10,
                monthlyRevenueLabels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6'],
                monthlyRevenueData: [0, 0, 0, 0, 0, 0]
            };
        }
    </script>

</body>
</html>