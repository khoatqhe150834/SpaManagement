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
                                                    
                                                    <!-- Status Update Dropdown -->
                                                    <div class="dropdown relative">
                                                        <button class="dropdown-toggle inline-flex items-center px-2 py-1 text-xs font-medium text-gray-600 bg-gray-50 rounded-md hover:bg-gray-100 transition-colors duration-200"
                                                                title="Cập nhật trạng thái">
                                                            <i data-lucide="chevron-down" class="h-3 w-3 mr-1"></i>
                                                            Trạng thái
                                                        </button>
                                                        <ul class="dropdown-menu absolute right-0 mt-1 hidden py-1 w-40 rounded-md bg-white shadow-lg z-10 border border-gray-200">
                                                            <li>
                                                                <button onclick="updatePaymentStatus(${payment.paymentId}, 'PAID')" 
                                                                        class="w-full text-left px-4 py-2 text-xs text-green-600 hover:bg-green-50 flex items-center">
                                                                    <i data-lucide="check-circle" class="h-3 w-3 mr-2"></i>
                                                                    Đã thanh toán
                                                                </button>
                                                            </li>
                                                            <li>
                                                                <button onclick="updatePaymentStatus(${payment.paymentId}, 'PENDING')" 
                                                                        class="w-full text-left px-4 py-2 text-xs text-yellow-600 hover:bg-yellow-50 flex items-center">
                                                                    <i data-lucide="clock" class="h-3 w-3 mr-2"></i>
                                                                    Chờ xử lý
                                                                </button>
                                                            </li>
                                                            <li>
                                                                <button onclick="updatePaymentStatus(${payment.paymentId}, 'FAILED')" 
                                                                        class="w-full text-left px-4 py-2 text-xs text-red-600 hover:bg-red-50 flex items-center">
                                                                    <i data-lucide="x-circle" class="h-3 w-3 mr-2"></i>
                                                                    Thất bại
                                                                </button>
                                                            </li>
                                                            <li>
                                                                <button onclick="updatePaymentStatus(${payment.paymentId}, 'REFUNDED')" 
                                                                        class="w-full text-left px-4 py-2 text-xs text-blue-600 hover:bg-blue-50 flex items-center">
                                                                    <i data-lucide="rotate-ccw" class="h-3 w-3 mr-2"></i>
                                                                    Đã hoàn tiền
                                                                </button>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                    
                                                    <!-- Print Receipt Button -->
                                                    <button onclick="printReceipt(${payment.paymentId})" 
                                                            class="inline-flex items-center px-2 py-1 text-xs font-medium text-purple-600 bg-purple-50 rounded-md hover:bg-purple-100 transition-colors duration-200"
                                                            title="In hóa đơn">
                                                        <i data-lucide="printer" class="h-3 w-3 mr-1"></i>
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
           <!-- Payment Analytics -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <!-- Payment Methods Chart -->
                <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden">
                    <div class="p-6 border-b border-gray-200">
                        <h2 class="text-lg font-semibold text-spa-dark flex items-center gap-2">
                            <i data-lucide="pie-chart" class="h-5 w-5 text-primary"></i>
                            Phân bố phương thức thanh toán
                        </h2>
                    </div>
                    <div class="p-6">
                        <canvas id="paymentMethodsChart" height="300"></canvas>
                    </div>
                </div>
                
                <!-- Monthly Revenue Chart -->
                <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden">
                    <div class="p-6 border-b border-gray-200">
                        <h2 class="text-lg font-semibold text-spa-dark flex items-center gap-2">
                            <i data-lucide="bar-chart-2" class="h-5 w-5 text-primary"></i>
                            Doanh thu theo tháng
                        </h2>
                    </div>
                    <div class="p-6">
                        <canvas id="monthlyRevenueChart" height="300"></canvas>
                    </div>
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
                        <select id="customerId" name="customerId" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" required>
                            <option value="">Chọn khách hàng</option>
                            <c:forEach var="customer" items="${customers}">
                                <option value="${customer.id}">${customer.fullName} - ${customer.phone}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <!-- Payment Date -->
                    <div>
                        <label for="paymentDate" class="block text-sm font-medium text-gray-700 mb-1">Ngày thanh toán <span class="text-red-500">*</span></label>
                        <input type="datetime-local" id="paymentDate" name="paymentDate" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" required>
                    </div>
                    
                    <!-- Payment Method -->
                    <div>
                        <label for="paymentMethod" class="block text-sm font-medium text-gray-700 mb-1">Phương thức thanh toán <span class="text-red-500">*</span></label>
                        <select id="paymentMethod" name="paymentMethod" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" required>
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
                        <select id="paymentStatus" name="paymentStatus" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" required>
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
                            <input type="number" id="totalAmount" name="totalAmount" min="0" step="1000" class="w-full pl-3 pr-12 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" required>
                            <div class="absolute inset-y-0 right-0 flex items-center px-3 pointer-events-none text-gray-500">
                                VNĐ
                            </div>
                        </div>
                    </div>
                    
                    <!-- Notes -->
                    <div class="md:col-span-2">
                        <label for="notes" class="block text-sm font-medium text-gray-700 mb-1">Ghi chú</label>
                        <textarea id="notes" name="notes" rows="3" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary"></textarea>
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
    </div>    <!-- Ch
art.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <!-- JavaScript -->
    <script>
        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }

        document.addEventListener('DOMContentLoaded', function() {
            // Toggle dropdowns
            document.querySelectorAll('.dropdown-toggle').forEach(function(item) {
                item.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    const dropdown = item.closest('.dropdown');
                    const menu = dropdown.querySelector('.dropdown-menu');
                    
                    // Close other dropdowns
                    document.querySelectorAll('.dropdown-menu').forEach(function(otherMenu) {
                        if (otherMenu !== menu) {
                            otherMenu.classList.add('hidden');
                        }
                    });
                    
                    // Toggle current dropdown
                    menu.classList.toggle('hidden');
                });
            });
            
            // Close dropdowns when clicking outside
            document.addEventListener('click', function(e) {
                if (!e.target.closest('.dropdown')) {
                    document.querySelectorAll('.dropdown-menu').forEach(function(menu) {
                        menu.classList.add('hidden');
                    });
                }
            });
            
            // Toggle filter panel
            const filterPanel = document.getElementById('filterPanel');
            const toggleFiltersBtn = document.getElementById('toggleFilters');
            
            if (filterPanel && toggleFiltersBtn) {
                toggleFiltersBtn.addEventListener('click', function() {
                    filterPanel.classList.toggle('show');
                });
            }
            
            // Initialize Date Range Picker
            if ($.fn.daterangepicker && document.getElementById('dateRangePicker')) {
                $('#dateRangePicker').daterangepicker({
                    opens: 'left',
                    autoUpdateInput: false,
                    locale: {
                        format: 'DD/MM/YYYY',
                        applyLabel: 'Áp dụng',
                        cancelLabel: 'Hủy',
                        fromLabel: 'Từ',
                        toLabel: 'Đến',
                        customRangeLabel: 'Tùy chỉnh',
                        daysOfWeek: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'],
                        monthNames: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'],
                        firstDay: 1
                    },
                    ranges: {
                        'Hôm nay': [moment(), moment()],
                        'Hôm qua': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                        '7 ngày qua': [moment().subtract(6, 'days'), moment()],
                        '30 ngày qua': [moment().subtract(29, 'days'), moment()],
                        'Tháng này': [moment().startOf('month'), moment().endOf('month')],
                        'Tháng trước': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
                    }
                });
                
                $('#dateRangePicker').on('apply.daterangepicker', function(ev, picker) {
                    $(this).val(picker.startDate.format('DD/MM/YYYY') + ' - ' + picker.endDate.format('DD/MM/YYYY'));
                    // Apply date filter to table
                    applyDateFilter(picker.startDate, picker.endDate);
                });

                $('#dateRangePicker').on('cancel.daterangepicker', function(ev, picker) {
                    $(this).val('');
                    // Clear date filter
                    clearDateFilter();
                });
            }
            
            // Initialize DataTables
            let paymentsTable;
            if ($.fn.DataTable && document.getElementById('paymentsTable') && !$.fn.DataTable.isDataTable('#paymentsTable')) {
                paymentsTable = $('#paymentsTable').DataTable({
                    responsive: true,
                    dom: 'Blfrtip',
                    processing: true,
                    stateSave: true,
                    stateDuration: 300, // 5 minutes state persistence
                    language: {
                        "sProcessing": "Đang xử lý...",
                        "sLengthMenu": "Hiển thị _MENU_ mục",
                        "sZeroRecords": "Không tìm thấy dòng nào phù hợp",
                        "sInfo": "Đang hiển thị _START_ đến _END_ trong tổng số _TOTAL_ mục",
                        "sInfoEmpty": "Đang hiển thị 0 đến 0 trong tổng số 0 mục",
                        "sInfoFiltered": "(được lọc từ _MAX_ mục)",
                        "sSearch": "Tìm kiếm:",
                        "oPaginate": {
                            "sFirst": "Đầu",
                            "sPrevious": "Trước",
                            "sNext": "Tiếp",
                            "sLast": "Cuối"
                        }
                    },
                    order: [[2, 'desc']], // Sort by payment date (column 2) in descending order
                    columnDefs: [
                        { 
                            responsivePriority: 1, 
                            targets: [0, 1, 2, 4, 5, 7] // High priority columns
                        },
                        { 
                            responsivePriority: 2, 
                            targets: [3] // Medium priority columns
                        },
                        { 
                            responsivePriority: 3, 
                            targets: [6] // Low priority columns
                        },
                        {
                            targets: 0, // Payment ID column
                            type: 'num',
                            render: function(data, type, row) {
                                if (type === 'sort' || type === 'type') {
                                    // Extract numeric value from "#123" format
                                    var numericValue = data.replace(/[^\d]/g, '');
                                    return parseInt(numericValue) || 0;
                                }
                                return data;
                            }
                        },
                        {
                            targets: 7, // Actions column
                            orderable: false,
                            searchable: false
                        }
                    ],
                    pageLength: 10,
                    lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "Tất cả"]],
                    buttons: [
                        {
                            extend: 'excelHtml5',
                            text: '<i data-lucide="file-spreadsheet" class="h-4 w-4 mr-1"></i> Xuất Excel',
                            className: 'bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded',
                            exportOptions: {
                                columns: ':not(:last-child)' // Exclude the last column (actions)
                            },
                            title: 'Báo cáo thanh toán - Spa Hương Sen'
                        },
                        {
                            extend: 'print',
                            text: '<i data-lucide="printer" class="h-4 w-4 mr-1"></i> In báo cáo',
                            className: 'bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded ml-2',
                            exportOptions: {
                                columns: ':not(:last-child)' // Exclude the last column (actions)
                            },
                            title: 'Báo cáo thanh toán - Spa Hương Sen'
                        }
                    ],
                    dom: '<"flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-4"<"flex items-center"l><"flex items-center"Bf>>rtip',

                    initComplete: function() {
                        var table = this.api();

                        // Apply custom styling after DataTables initialization
                        $('.dataTables_filter input').addClass('ml-2 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary');
                        $('.dataTables_length select').addClass('mx-2 px-2 py-1 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary');
                        $('.dataTables_paginate .paginate_button').addClass('mx-1');

                        // Style the wrapper
                        $('.dataTables_wrapper').addClass('px-0 pb-0');

                        // Initialize Lucide icons in the table
                        lucide.createIcons();

                        // Add event handlers to preserve pagination during sorting
                        var isRestoringPage = false; // Flag to prevent infinite recursion

                        $('#paymentsTable thead').on('click', 'th', function() {
                            // Only store page if we're not currently restoring
                            if (!isRestoringPage) {
                                var currentPage = table.page.info().page;
                                sessionStorage.setItem('paymentsTableCurrentPage', currentPage);
                            }
                        });

                        // Handle order event (when sorting actually happens)
                        table.on('order.dt', function() {
                            // Prevent recursion
                            if (isRestoringPage) {
                                return;
                            }

                            // Restore the page after sorting
                            var storedPage = sessionStorage.getItem('paymentsTableCurrentPage');
                            if (storedPage !== null) {
                                var pageNum = parseInt(storedPage);
                                var pageInfo = table.page.info();
                                var maxPage = Math.ceil(pageInfo.recordsDisplay / pageInfo.length) - 1;

                                // Ensure the page number is valid
                                if (pageNum <= maxPage && pageNum !== pageInfo.page) {
                                    isRestoringPage = true; // Set flag before calling draw
                                    table.page(pageNum).draw(false);

                                    // Use setTimeout to reset flag after draw completes
                                    setTimeout(function() {
                                        isRestoringPage = false;
                                    }, 100);
                                }

                                // Clear the stored page
                                sessionStorage.removeItem('paymentsTableCurrentPage');
                            }
                        });

                        console.log('DataTables with pagination preservation initialized successfully');
                    }
                });
            }     
       
            // Filter functionality
            $('#applyFilters').on('click', function() {
                applyFilters(true); // Show notification for manual filter application
            });
            
            $('#resetFilters').on('click', function() {
                resetFilters();
            });

            // Setup real-time filtering
            setupRealTimeFilters();

            // Modal functionality
            const paymentModal = document.getElementById('paymentModal');
            const closeModal = document.getElementById('closeModal');
            const cancelPayment = document.getElementById('cancelPayment');
            const addPaymentBtn = document.getElementById('addPaymentBtn');
            const emptyAddPaymentBtn = document.getElementById('emptyAddPaymentBtn');
            const paymentForm = document.getElementById('paymentForm');
            const modalTitle = document.getElementById('modalTitle');
            
            if (addPaymentBtn) {
                addPaymentBtn.addEventListener('click', function() {
                    openAddPaymentModal();
                });
            }
            
            if (emptyAddPaymentBtn) {
                emptyAddPaymentBtn.addEventListener('click', function() {
                    openAddPaymentModal();
                });
            }
            
            if (closeModal) {
                closeModal.addEventListener('click', function() {
                    closePaymentModal();
                });
            }
            
            if (cancelPayment) {
                cancelPayment.addEventListener('click', function() {
                    closePaymentModal();
                });
            }
            
            if (paymentForm) {
                paymentForm.addEventListener('submit', function(e) {
                    e.preventDefault();
                    savePayment();
                });
            }
            
            // Initialize Charts if data is available
            initializeCharts();
        });

        // Setup real-time filtering for all filter inputs
        function setupRealTimeFilters() {
            let filterTimeout;

            // Debounced filter function
            function debouncedFilter() {
                clearTimeout(filterTimeout);
                filterTimeout = setTimeout(function() {
                    applyFilters();
                    updateFilterStatus();
                }, 300);
            }

            // Bind events to filter inputs for real-time filtering
            $('#customerFilter').on('change', debouncedFilter);
            $('#methodFilter').on('change', debouncedFilter);
            $('#statusFilter').on('change', debouncedFilter);
            $('#minAmount').on('input', debouncedFilter);
            $('#maxAmount').on('input', debouncedFilter);

            // Date range picker event (if implemented)
            $('#dateRangePicker').on('change', function() {
                const dateRange = $(this).val();
                if (dateRange) {
                    const dates = dateRange.split(' - ');
                    if (dates.length === 2) {
                        applyDateFilter(dates[0], dates[1]);
                    }
                } else {
                    // Clear date filter
                    clearDateFilter();
                }
            });

            console.log('Real-time filtering setup completed');
        }

        // Filter Functions
        function applyFilters(showNotification = false) {
            const table = $('#paymentsTable').DataTable();

            // Get filter values
            const customerFilter = $('#customerFilter').val();
            const methodFilter = $('#methodFilter').val();
            const statusFilter = $('#statusFilter').val();
            const minAmount = $('#minAmount').val();
            const maxAmount = $('#maxAmount').val();

            // Clear existing custom search functions
            $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(function(fn) {
                return fn.name !== 'amountRangeFilter';
            });

            // Clear existing column searches
            table.columns().search('');

            // Apply customer filter (column 1)
            if (customerFilter) {
                table.column(1).search(customerFilter, false, false);
            }

            // Apply method filter (column 3)
            if (methodFilter) {
                table.column(3).search(methodFilter, false, false);
            }

            // Apply status filter (column 5)
            if (statusFilter) {
                table.column(5).search(statusFilter, false, false);
            }

            // Apply amount filter (column 4) using custom search
            if (minAmount || maxAmount) {
                const amountRangeFilter = function(settings, data, dataIndex) {
                    const amount = parseFloat(data[4].replace(/[^\d.,]/g, '').replace(',', '')) || 0;
                    const min = parseFloat(minAmount) || 0;
                    const max = parseFloat(maxAmount) || Infinity;

                    return (amount >= min && amount <= max);
                };
                amountRangeFilter.name = 'amountRangeFilter';
                $.fn.dataTable.ext.search.push(amountRangeFilter);
            }

            // Apply all filters with a single draw
            table.draw();

            // Show success notification only when manually triggered
            if (showNotification) {
                showNotification('Đã áp dụng bộ lọc thành công', 'success');
            }
        }
        
        function resetFilters() {
            // Reset all filter inputs
            $('#customerFilter').val('');
            $('#methodFilter').val('');
            $('#statusFilter').val('');
            $('#minAmount').val('');
            $('#maxAmount').val('');
            $('#dateRangePicker').val('');
            
            // Reset DataTable filters
            const table = $('#paymentsTable').DataTable();
            table.search('').columns().search('').draw(false);

            // Clear custom search functions
            $.fn.dataTable.ext.search = [];

            // Update filter status
            updateFilterStatus();

            // Show notification
            showNotification('Đã đặt lại bộ lọc', 'info');
        }

        function clearDateFilter() {
            // Clear any date-based filtering
            const table = $('#paymentsTable').DataTable();

            // Remove date filter from custom search functions
            $.fn.dataTable.ext.search = $.fn.dataTable.ext.search.filter(function(fn) {
                return fn.name !== 'dateRangeFilter';
            });

            table.draw();
        }

        function updateFilterStatus() {
            // Check if any filters are active
            const customerFilter = $('#customerFilter').val();
            const methodFilter = $('#methodFilter').val();
            const statusFilter = $('#statusFilter').val();
            const minAmount = $('#minAmount').val();
            const maxAmount = $('#maxAmount').val();
            const dateRange = $('#dateRangePicker').val();

            const hasActiveFilters = customerFilter || methodFilter || statusFilter || minAmount || maxAmount || dateRange;

            // Update filter button appearance
            const filterButton = $('#toggleFilters');
            if (hasActiveFilters) {
                filterButton.addClass('bg-primary text-white').removeClass('bg-gray-100 text-gray-700');
                filterButton.find('i').addClass('text-white');
            } else {
                filterButton.removeClass('bg-primary text-white').addClass('bg-gray-100 text-gray-700');
                filterButton.find('i').removeClass('text-white');
            }
        }
        
        function applyDateFilter(startDate, endDate) {
            const table = $('#paymentsTable').DataTable();
            
            $.fn.dataTable.ext.search.push(
                function(settings, data, dataIndex) {
                    // Parse date from the 3rd column (index 2)
                    const dateStr = data[2];
                    const dateParts = dateStr.split('/');
                    if (dateParts.length !== 3) return true; // If date format is unexpected, include the row
                    
                    const day = parseInt(dateParts[0]);
                    const month = parseInt(dateParts[1]) - 1; // Month is 0-indexed in JS Date
                    const yearTimeParts = dateParts[2].split(' ');
                    const year = parseInt(yearTimeParts[0]);
                    
                    const rowDate = new Date(year, month, day);
                    
                    return (rowDate >= startDate && rowDate <= endDate);
                }
            );
            
            table.draw(false);
            
            // Remove the custom filter after drawing
            $.fn.dataTable.ext.search.pop();
            
            // Show notification
            showNotification('Đã lọc theo khoảng thời gian', 'success');
        }
        
        function clearDateFilter() {
            const table = $('#paymentsTable').DataTable();
            table.draw(false);
            showNotification('Đã xóa bộ lọc thời gian', 'info');
        }

        // Modal Functions
        function openAddPaymentModal() {
            // Reset form
            document.getElementById('paymentForm').reset();
            document.getElementById('paymentId').value = '';
            document.getElementById('modalTitle').textContent = 'Thêm thanh toán mới';
            
            // Set default date to current date and time
            const now = new Date();
            const year = now.getFullYear();
            const month = String(now.getMonth() + 1).padStart(2, '0');
            const day = String(now.getDate()).padStart(2, '0');
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            
            document.getElementById('paymentDate').value = `${year}-${month}-${day}T${hours}:${minutes}`;
            
            // Show modal
            document.getElementById('paymentModal').classList.remove('hidden');
        }
        
        function openEditPaymentModal(paymentId, customerId, paymentDate, paymentMethod, paymentStatus, totalAmount, notes) {
            // Set form values
            document.getElementById('paymentId').value = paymentId;
            document.getElementById('customerId').value = customerId;
            document.getElementById('paymentDate').value = paymentDate;
            document.getElementById('paymentMethod').value = paymentMethod;
            document.getElementById('paymentStatus').value = paymentStatus;
            document.getElementById('totalAmount').value = totalAmount;
            document.getElementById('notes').value = notes || '';
            
            // Set modal title
            document.getElementById('modalTitle').textContent = 'Chỉnh sửa thanh toán #' + paymentId;
            
            // Show modal
            document.getElementById('paymentModal').classList.remove('hidden');
        }
        
        function closePaymentModal() {
            document.getElementById('paymentModal').classList.add('hidden');
        }
        
        function savePayment() {
            // Get form data
            const paymentId = document.getElementById('paymentId').value;
            const customerId = document.getElementById('customerId').value;
            const paymentDate = document.getElementById('paymentDate').value;
            const paymentMethod = document.getElementById('paymentMethod').value;
            const paymentStatus = document.getElementById('paymentStatus').value;
            const totalAmount = document.getElementById('totalAmount').value;
            const notes = document.getElementById('notes').value;
            
            // Validate required fields
            if (!customerId || !paymentDate || !paymentMethod || !paymentStatus || !totalAmount) {
                showNotification('Vui lòng điền đầy đủ thông tin bắt buộc', 'error');
                return;
            }
            
            // Prepare data for API call
            const paymentData = {
                paymentId: paymentId || null,
                customerId: customerId,
                paymentDate: paymentDate,
                paymentMethod: paymentMethod,
                paymentStatus: paymentStatus,
                totalAmount: totalAmount,
                notes: notes
            };
            
            // Show loading state
            const submitButton = document.querySelector('#paymentForm button[type="submit"]');
            const originalButtonText = submitButton.innerHTML;
            submitButton.innerHTML = '<i data-lucide="loader-2" class="h-4 w-4 animate-spin mr-2"></i> Đang lưu...';
            submitButton.disabled = true;
            
            // Determine if this is an add or edit operation
            const isEdit = !!paymentId;
            const url = isEdit 
                ? '${pageContext.request.contextPath}/manager/payments/update'
                : '${pageContext.request.contextPath}/manager/payments/add';
            
            // Send API request
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify(paymentData)
            })
            .then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error('Network response was not ok');
            })
            .then(data => {
                if (data.success) {
                    // Show success message
                    showNotification(isEdit ? 'Cập nhật thanh toán thành công!' : 'Thêm thanh toán thành công!', 'success');
                    
                    // Close modal
                    closePaymentModal();
                    
                    // Reload the page to reflect changes
                    setTimeout(() => {
                        location.reload();
                    }, 1500);
                } else {
                    throw new Error(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra: ' + error.message, 'error');
                
                // Restore button state
                submitButton.innerHTML = originalButtonText;
                submitButton.disabled = false;
                lucide.createIcons();
            });
        }

        // CRUD Functions for Payment Actions (Manager Version)
        function viewPayment(paymentId) {
            // Open manager payment details view
            window.location.href = '${pageContext.request.contextPath}/manager/payment-details?id=' + paymentId;
        }

        function editPayment(paymentId) {
            // Show loading state
            const button = event.target.closest('button');
            const originalContent = button.innerHTML;
            button.innerHTML = '<i data-lucide="loader-2" class="h-3 w-3 animate-spin"></i>';
            button.disabled = true;
            
            // Fetch payment details
            fetch('${pageContext.request.contextPath}/manager/payments/get/' + paymentId, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                if (response.ok) {
                    return response.json();
                }
                throw new Error('Network response was not ok');
            })
            .then(data => {
                if (data.success) {
                    // Format date for datetime-local input
                    const paymentDate = new Date(data.payment.paymentDate);
                    const formattedDate = paymentDate.toISOString().slice(0, 16); // Format: YYYY-MM-DDTHH:MM
                    
                    // Open edit modal with payment data
                    openEditPaymentModal(
                        data.payment.paymentId,
                        data.payment.customerId,
                        formattedDate,
                        data.payment.paymentMethod,
                        data.payment.paymentStatus,
                        data.payment.totalAmount,
                        data.payment.notes
                    );
                } else {
                    throw new Error(data.message || 'Không thể tải thông tin thanh toán');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Có lỗi xảy ra: ' + error.message, 'error');
            })
            .finally(() => {
                // Restore button state
                button.innerHTML = originalContent;
                button.disabled = false;
                lucide.createIcons();
            });
        }

        function updatePaymentStatus(paymentId, newStatus) {
            // Confirm status update
            const statusLabels = {
                'PAID': 'Đã thanh toán',
                'PENDING': 'Chờ xử lý',
                'FAILED': 'Thất bại',
                'REFUNDED': 'Đã hoàn tiền'
            };
            
            if (confirm(`Bạn có chắc chắn muốn cập nhật trạng thái thanh toán #${paymentId} thành "${statusLabels[newStatus]}"?`)) {
                // Show loading state
                const button = event.target;
                const originalContent = button.innerHTML;
                button.innerHTML = '<i data-lucide="loader-2" class="h-3 w-3 animate-spin mr-1"></i> Đang cập nhật...';
                button.disabled = true;
                
                // Send API request
                fetch('${pageContext.request.contextPath}/manager/payments/update-status', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: JSON.stringify({
                        paymentId: paymentId,
                        paymentStatus: newStatus
                    })
                })
                .then(response => {
                    if (response.ok) {
                        return response.json();
                    }
                    throw new Error('Network response was not ok');
                })
                .then(data => {
                    if (data.success) {
                        // Show success message
                        showNotification('Cập nhật trạng thái thanh toán thành công!', 'success');
                        
                        // Reload the page to reflect changes
                        setTimeout(() => {
                            location.reload();
                        }, 1500);
                    } else {
                        throw new Error(data.message || 'Có lỗi xảy ra');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Có lỗi xảy ra: ' + error.message, 'error');
                    
                    // Restore button state
                    button.innerHTML = originalContent;
                    button.disabled = false;
                    lucide.createIcons();
                });
            }
        }

        function printReceipt(paymentId) {
            // Open receipt in new window for printing
            const receiptWindow = window.open(
                '${pageContext.request.contextPath}/manager/payment/receipt/' + paymentId,
                'receipt',
                'width=800,height=600,scrollbars=yes,resizable=yes'
            );
            
            if (receiptWindow) {
                receiptWindow.focus();
                // Auto print when loaded
                receiptWindow.onload = function() {
                    receiptWindow.print();
                };
            } else {
                showNotification('Không thể mở cửa sổ in hóa đơn. Vui lòng kiểm tra trình duyệt.', 'error');
            }
        }

        function refundPayment(paymentId) {
            // Confirm refund
            if (confirm('Bạn có chắc chắn muốn hoàn tiền cho thanh toán #' + paymentId + '? Hành động này không thể hoàn tác.')) {
                // Show loading state
                const button = event.target.closest('button');
                const originalContent = button.innerHTML;
                button.innerHTML = '<i data-lucide="loader-2" class="h-3 w-3 animate-spin mr-1"></i>';
                button.disabled = true;

                // Send AJAX request
                fetch('${pageContext.request.contextPath}/manager/payments/refund', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: JSON.stringify({
                        paymentId: paymentId
                    })
                })
                .then(response => {
                    if (response.ok) {
                        return response.json();
                    }
                    throw new Error('Network response was not ok');
                })
                .then(data => {
                    if (data.success) {
                        // Show success message
                        showNotification('Hoàn tiền thành công!', 'success');
                        // Reload the page to reflect changes
                        setTimeout(() => {
                            location.reload();
                        }, 1500);
                    } else {
                        throw new Error(data.message || 'Có lỗi xảy ra');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Có lỗi xảy ra khi hoàn tiền: ' + error.message, 'error');
                    // Restore button state
                    button.innerHTML = originalContent;
                    button.disabled = false;
                    lucide.createIcons();
                });
            }
        }

        // Initialize Charts
        function initializeCharts() {
            // Payment Methods Chart
            const paymentMethodsCtx = document.getElementById('paymentMethodsChart');
            if (paymentMethodsCtx) {
                // Sample data - replace with actual data from backend
                const paymentMethodsData = {
                    labels: ['Tiền mặt', 'Chuyển khoản', 'Thẻ tín dụng', 'VNPay', 'MoMo', 'ZaloPay'],
                    datasets: [{
                        data: [
                            ${cashPaymentsPercent != null ? cashPaymentsPercent : 20}, 
                            ${bankTransferPaymentsPercent != null ? bankTransferPaymentsPercent : 30}, 
                            ${creditCardPaymentsPercent != null ? creditCardPaymentsPercent : 15}, 
                            ${vnpayPaymentsPercent != null ? vnpayPaymentsPercent : 15}, 
                            ${momoPaymentsPercent != null ? momoPaymentsPercent : 10}, 
                            ${zalopayPaymentsPercent != null ? zalopayPaymentsPercent : 10}
                        ],
                        backgroundColor: [
                            '#10B981', // Green
                            '#3B82F6', // Blue
                            '#F59E0B', // Amber
                            '#0068FF', // VNPay Blue
                            '#A50064', // MoMo Purple
                            '#0068FF'  // ZaloPay Blue
                        ],
                        borderWidth: 1
                    }]
                };
                
                new Chart(paymentMethodsCtx, {
                    type: 'pie',
                    data: paymentMethodsData,
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'right',
                                labels: {
                                    font: {
                                        family: 'Roboto'
                                    }
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const label = context.label || '';
                                        const value = context.raw || 0;
                                        return `${label}: ${value}%`;
                                    }
                                }
                            }
                        }
                    }
                });
            }
            
            // Monthly Revenue Chart
            const monthlyRevenueCtx = document.getElementById('monthlyRevenueChart');
            if (monthlyRevenueCtx) {
                // Sample data - replace with actual data from backend
                const monthlyRevenueData = {
                    labels: ${monthlyRevenueLabels != null ? monthlyRevenueLabels : "['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6']"},
                    datasets: [{
                        label: 'Doanh thu (VNĐ)',
                        data: ${monthlyRevenueData != null ? monthlyRevenueData : "[0, 0, 0, 0, 0, 0]"},
                        backgroundColor: '#D4AF37',
                        borderColor: '#B8941F',
                        borderWidth: 1
                    }]
                };
                
                new Chart(monthlyRevenueCtx, {
                    type: 'bar',
                    data: monthlyRevenueData,
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function(value) {
                                        // Format number manually instead of using Intl.NumberFormat
                                        return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + ' VNĐ';
                                    }
                                }
                            }
                        },
                        plugins: {
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const label = context.dataset.label || '';
                                        const value = context.raw || 0;
                                        // Format number manually
                                        const formattedValue = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                                        return `${label}: ${formattedValue} VNĐ`;
                                    }
                                }
                            }
                        }
                    }
                });
            }
        }

        // Notification function
        function showNotification(message, type = 'info') {
            // Create notification element
            const notification = document.createElement('div');
            notification.className = `fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg max-w-sm transition-all duration-300 transform translate-x-full`;
            
            // Set colors based on type
            const colors = {
                success: 'bg-green-500 text-white',
                error: 'bg-red-500 text-white',
                warning: 'bg-yellow-500 text-white',
                info: 'bg-blue-500 text-white'
            };
            
            notification.className += ' ' + (colors[type] || colors.info);
            // Determine icon based on type
            let iconName = 'info';
            if (type === 'success') iconName = 'check-circle';
            else if (type === 'error') iconName = 'x-circle';
            else if (type === 'warning') iconName = 'alert-triangle';
            
            notification.innerHTML = 
                '<div class="flex items-center gap-2">' +
                    '<i data-lucide="' + iconName + '" class="h-5 w-5"></i>' +
                    '<span>' + message + '</span>' +
                '</div>';
            
            document.body.appendChild(notification);
            lucide.createIcons();
            
            // Animate in
            setTimeout(() => {
                notification.classList.remove('translate-x-full');
            }, 100);
            
            // Auto remove after 5 seconds
            setTimeout(() => {
                notification.classList.add('translate-x-full');
                setTimeout(() => {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 300);
            }, 5000);
        }



        console.log('Payments Management Page Loaded Successfully');
    </script>

</body>
</html>