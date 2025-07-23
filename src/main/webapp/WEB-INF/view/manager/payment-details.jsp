<%-- 
    Document   : payment-details
    Created on : Dec 17, 2024
    Author     : G1_SpaManagement Team
    Description: Manager payment details page
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%-- Authorization Check: Only Manager and Admin can access this page --%>
<%
    String userType = (String) session.getAttribute("userType");
    if (userType == null || (!userType.equals("MANAGER") && !userType.equals("ADMIN"))) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Manager or Admin privileges required.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chi Tiết Thanh Toán #${payment.paymentId} - Spa Hương Sen</title>

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

    <!-- Font Awesome for DataTables buttons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.dataTables.min.css">

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>

    <!-- Manager Payment Details Filter JS -->
    <script src="${pageContext.request.contextPath}/js/manager-payment-details.js?v=<%= System.currentTimeMillis() %>"></script>

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

        /* Custom styles for payment items table */
        .payment-items-table .service-name {
            font-weight: 600;
            color: #374151;
        }

        .payment-items-table .service-description {
            font-size: 0.875rem;
            color: #6b7280;
            margin-top: 2px;
        }

        .usage-progress {
            width: 100px;
            height: 8px;
            background-color: #e5e7eb;
            border-radius: 4px;
            overflow: hidden;
        }

        .usage-progress-bar {
            height: 100%;
            background-color: #D4AF37;
            transition: width 0.3s ease;
        }

        .usage-info {
            font-size: 0.75rem;
            color: #6b7280;
            margin-top: 2px;
        }

        /* Column alignment styles */
        .payment-items-table th:nth-child(1) { text-align: left; }    /* Dịch vụ */
        .payment-items-table th:nth-child(2) { text-align: center; }  /* Số lượng */
        .payment-items-table th:nth-child(3) { text-align: right; }   /* Đơn giá */
        .payment-items-table th:nth-child(4) { text-align: center; }  /* Thời gian */
        .payment-items-table th:nth-child(5) { text-align: right; }   /* Thành tiền */
        .payment-items-table th:nth-child(6) { text-align: center; }  /* Tình trạng sử dụng */
        .payment-items-table th:nth-child(7) { text-align: center; }  /* Thao tác */

        .payment-items-table td:nth-child(1) { text-align: left; }    /* Dịch vụ */
        .payment-items-table td:nth-child(2) { text-align: center; }  /* Số lượng */
        .payment-items-table td:nth-child(3) { text-align: right; }   /* Đơn giá */
        .payment-items-table td:nth-child(4) { text-align: center; }  /* Thời gian */
        .payment-items-table td:nth-child(5) { text-align: right; }   /* Thành tiền */
        .payment-items-table td:nth-child(6) { text-align: center; }  /* Tình trạng sử dụng */
        .payment-items-table td:nth-child(7) { text-align: center; }  /* Thao tác */

        /* Vertical alignment for all cells */
        .payment-items-table th,
        .payment-items-table td {
            vertical-align: middle;
            padding: 12px 8px;
        }

        /* Service column specific styling */
        .payment-items-table td:nth-child(1) {
            vertical-align: top;
            padding-top: 16px;
        }

        /* Improve table readability */
        .payment-items-table tbody tr {
            border-bottom: 1px solid #f3f4f6;
        }

        .payment-items-table tbody tr:hover {
            background-color: rgba(255, 248, 240, 0.3);
        }

        /* Consistent width for numeric columns */
        .payment-items-table th:nth-child(2),
        .payment-items-table td:nth-child(2) { width: 80px; }   /* Số lượng */

        .payment-items-table th:nth-child(3),
        .payment-items-table td:nth-child(3) { width: 120px; }  /* Đơn giá */

        .payment-items-table th:nth-child(4),
        .payment-items-table td:nth-child(4) { width: 100px; }  /* Thời gian */

        .payment-items-table th:nth-child(5),
        .payment-items-table td:nth-child(5) { width: 130px; }  /* Thành tiền */

        .payment-items-table th:nth-child(6),
        .payment-items-table td:nth-child(6) { width: 150px; }  /* Tình trạng sử dụng */

        .payment-items-table th:nth-child(7),
        .payment-items-table td:nth-child(7) { width: 100px; }  /* Thao tác */

        /* Progress bar container improvements */
        .usage-progress {
            width: 120px;
            margin: 0 auto;
        }
        .payment-header {
            background: linear-gradient(135deg, #D4AF37 0%, #B8941F 100%);
            color: white;
            border-radius: 8px;
            padding: 2rem;
            margin-bottom: 2rem;
        }
        
        .status-badge {
            font-size: 0.875rem;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 600;
        }
        
        .status-paid { background-color: #dcfce7; color: #166534; }
        .status-pending { background-color: #fef3c7; color: #92400e; }
        .status-failed { background-color: #fee2e2; color: #dc2626; }
        .status-refunded { background-color: #e0e7ff; color: #3730a3; }
        
        .info-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            margin-bottom: 1.5rem;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #374151;
        }
        
        .info-value {
            color: #6b7280;
        }
        
        .amount-highlight {
            font-size: 1.25rem;
            font-weight: 700;
            color: #059669;
        }
        
        .service-item {
            background: #f9fafb;
            border-radius: 6px;
            padding: 1rem;
            margin-bottom: 0.75rem;
            border-left: 4px solid #D4AF37;
        }

        /* Filter panel styling */
        .manager-payment-details-filter-panel {
            transition: max-height 0.3s ease-in-out, opacity 0.3s ease-in-out;
            max-height: 0;
            opacity: 0;
            overflow: hidden;
        }

        .manager-payment-details-filter-panel.show {
            max-height: 500px;
            opacity: 1;
        }

        #togglePaymentDetailsFilters i {
            transition: transform 0.3s ease;
        }

        #togglePaymentDetailsFilters i.rotate-180 {
            transform: rotate(180deg);
        }

        /* Responsive adjustments for filters */
        @media (max-width: 768px) {
            .grid-cols-1.md\\:grid-cols-2.lg\\:grid-cols-4 {
                grid-template-columns: repeat(1, minmax(0, 1fr));
            }
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
                            <h2 class="text-sm font-semibold text-spa-dark">${sessionScope.user.fullName}</h2>
                            <p class="text-xs text-primary/70">Quản lý</p>
                        </div>
                    </button>
                    <ul class="dropdown-menu shadow-lg shadow-black/10 z-30 hidden py-2 rounded-lg bg-white border border-primary/20 w-full max-w-[160px]">
                        <li>
                            <a href="${pageContext.request.contextPath}/profile" class="flex items-center text-sm py-2 px-4 text-spa-dark hover:text-primary hover:bg-spa-cream transition-all duration-200">
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

            <!-- Breadcrumb -->
            <div class="mb-6">
                <nav class="flex" aria-label="Breadcrumb">
                    <ol class="inline-flex items-center space-x-1 md:space-x-3">
                        <li class="inline-flex items-center">
                            <a href="${pageContext.request.contextPath}/dashboard" class="inline-flex items-center text-sm font-medium text-spa-dark hover:text-primary">
                                <i data-lucide="home" class="h-4 w-4 mr-2"></i>
                                Dashboard
                            </a>
                        </li>
                        <li>
                            <div class="flex items-center">
                                <i data-lucide="chevron-right" class="h-4 w-4 text-gray-400"></i>
                                <a href="${pageContext.request.contextPath}/manager/payments-management" class="ml-1 text-sm font-medium text-spa-dark hover:text-primary md:ml-2">
                                    Quản Lý Thanh Toán
                                </a>
                            </div>
                        </li>
                        <li aria-current="page">
                            <div class="flex items-center">
                                <i data-lucide="chevron-right" class="h-4 w-4 text-gray-400"></i>
                                <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Chi Tiết #${payment.paymentId}</span>
                            </div>
                        </li>
                    </ol>
                </nav>
            </div>

            <!-- Payment Header -->
            <div class="payment-header">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h3 class="mb-2">Thanh Toán #${payment.paymentId}</h3>
                        <p class="mb-0 opacity-75">
                            <c:if test="${not empty payment.referenceNumber}">
                                Mã tham chiếu: ${payment.referenceNumber}
                            </c:if>
                        </p>
                    </div>
                    <div class="col-md-4 text-end">
                        <span class="status-badge 
                            <c:choose>
                                <c:when test="${payment.paymentStatus == 'PAID'}">status-paid</c:when>
                                <c:when test="${payment.paymentStatus == 'PENDING'}">status-pending</c:when>
                                <c:when test="${payment.paymentStatus == 'FAILED'}">status-failed</c:when>
                                <c:when test="${payment.paymentStatus == 'REFUNDED'}">status-refunded</c:when>
                                <c:otherwise>status-pending</c:otherwise>
                            </c:choose>">
                            <c:choose>
                                <c:when test="${payment.paymentStatus == 'PAID'}">Đã thanh toán</c:when>
                                <c:when test="${payment.paymentStatus == 'PENDING'}">Chờ thanh toán</c:when>
                                <c:when test="${payment.paymentStatus == 'FAILED'}">Thất bại</c:when>
                                <c:when test="${payment.paymentStatus == 'REFUNDED'}">Đã hoàn tiền</c:when>
                                <c:otherwise>${payment.paymentStatus}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </div>

            <div class="row">
                <!-- Customer Information -->
                <div class="col-md-6">
                    <div class="info-card">
                        <h5 class="mb-3">
                            <iconify-icon icon="solar:user-outline" class="me-2"></iconify-icon>
                            Thông Tin Khách Hàng
                        </h5>
                        <div class="info-row">
                            <span class="info-label">Họ tên:</span>
                            <span class="info-value">${payment.customer.fullName}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Email:</span>
                            <span class="info-value">${payment.customer.email}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Số điện thoại:</span>
                            <span class="info-value">${payment.customer.phoneNumber}</span>
                        </div>
                    </div>
                </div>

                <!-- Payment Information -->
                <div class="col-md-6">
                    <div class="info-card">
                        <h5 class="mb-3">
                            <iconify-icon icon="solar:credit-card-outline" class="me-2"></iconify-icon>
                            Thông Tin Thanh Toán
                        </h5>
                        <div class="info-row">
                            <span class="info-label">Ngày thanh toán:</span>
                            <span class="info-value">
                                ${payment.paymentDate}
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Phương thức:</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${payment.paymentMethod == 'BANK_TRANSFER'}">Chuyển khoản</c:when>
                                    <c:when test="${payment.paymentMethod == 'CREDIT_CARD'}">Thẻ tín dụng</c:when>
                                    <c:when test="${payment.paymentMethod == 'VNPAY'}">VNPay</c:when>
                                    <c:when test="${payment.paymentMethod == 'MOMO'}">MoMo</c:when>
                                    <c:when test="${payment.paymentMethod == 'ZALOPAY'}">ZaloPay</c:when>
                                    <c:when test="${payment.paymentMethod == 'CASH'}">Tiền mặt</c:when>
                                    <c:otherwise>${payment.paymentMethod}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Ngày giao dịch:</span>
                            <span class="info-value">
                                ${payment.transactionDate}
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Payment Amount Details -->
            <div class="info-card">
                <h5 class="mb-3">
                    <iconify-icon icon="solar:calculator-outline" class="me-2"></iconify-icon>
                    Chi Tiết Số Tiền
                </h5>
                <div class="row">
                    <div class="col-md-4">
                        <div class="info-row">
                            <span class="info-label">Tạm tính:</span>
                            <span class="info-value">
                                <fmt:formatNumber value="${payment.subtotalAmount}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                            </span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="info-row">
                            <span class="info-label">Thuế:</span>
                            <span class="info-value">
                                <fmt:formatNumber value="${payment.taxAmount}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                            </span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="info-row">
                            <span class="info-label">Tổng cộng:</span>
                            <span class="info-value amount-highlight">
                                <fmt:formatNumber value="${payment.totalAmount}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Payment Items -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden mb-6">
                <div class="p-6 border-b border-gray-200">
                    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                        <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                            <i data-lucide="shopping-bag" class="h-6 w-6 text-primary"></i>
                            Dịch Vụ Đã Mua (${fn:length(paymentItems)} dịch vụ)
                        </h2>

                        <div class="flex flex-wrap items-center gap-3">
                            <!-- Filter Toggle Button -->
                            <button id="togglePaymentDetailsFilters" class="inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                                <i data-lucide="filter" class="h-4 w-4 mr-2"></i>
                                Bộ lọc
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Filter Panel -->
                <div id="paymentDetailsFilterPanel" class="manager-payment-details-filter-panel px-6 py-0 border-b border-gray-200 bg-gray-50">
                    <div class="p-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                            <!-- Service Name Filter -->
                            <div>
                                <label for="paymentDetailsServiceFilter" class="block text-sm font-medium text-gray-700 mb-2">Tên dịch vụ</label>
                                <select id="paymentDetailsServiceFilter" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                    <option value="">Tất cả dịch vụ</option>
                                </select>
                            </div>

                            <!-- Quantity Filter -->
                            <div>
                                <label for="paymentDetailsQuantityFilter" class="block text-sm font-medium text-gray-700 mb-2">Số lượng</label>
                                <input type="number" id="paymentDetailsQuantityFilter" placeholder="Nhập số lượng" min="1"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>

                            <!-- Amount Range -->
                            <div>
                                <label for="paymentDetailsMinAmount" class="block text-sm font-medium text-gray-700 mb-2">Giá từ</label>
                                <input type="number" id="paymentDetailsMinAmount" placeholder="0" min="0" step="1000"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>

                            <div>
                                <label for="paymentDetailsMaxAmount" class="block text-sm font-medium text-gray-700 mb-2">Giá đến</label>
                                <input type="number" id="paymentDetailsMaxAmount" placeholder="10,000,000" min="0" step="1000"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>
                        </div>

                        <!-- Duration Filter -->
                        <div class="mt-4">
                            <label for="paymentDetailsDurationFilter" class="block text-sm font-medium text-gray-700 mb-2">Thời gian (phút)</label>
                            <input type="number" id="paymentDetailsDurationFilter" class="px-4 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" placeholder="Nhập thời gian" min="1" />
                        </div>
                    </div>

                    <!-- Filter Actions -->
                    <div class="flex justify-end py-3 px-6 gap-3 border-t border-gray-200">
                        <button id="resetPaymentDetailsFilters" class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                            Đặt lại
                        </button>
                        <button id="applyPaymentDetailsFilters" class="px-4 py-2 text-sm font-medium text-white bg-primary rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary/20">
                            Áp dụng
                        </button>
                    </div>
                </div>
                <div class="p-6">
                    <c:choose>
                        <c:when test="${paymentItems != null && not empty paymentItems}">
                            <table id="paymentItemsTable" class="w-full display responsive nowrap payment-items-table" style="width:100%">
                                <thead>
                                    <tr>
                                        <th>Dịch vụ</th>
                                        <th>Số lượng</th>
                                        <th>Đơn giá</th>
                                        <th>Thời gian</th>
                                        <th>Thành tiền</th>
                                        <th>Tình trạng sử dụng</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${paymentItems}">
                                        <tr>
                                            <td>
                                                <div class="service-name">
                                                    ${item.service != null && item.service.name != null ? item.service.name : 'Dịch vụ không xác định'}
                                                </div>
                                                <div class="service-description">
                                                    <c:if test="${not empty item.service.description}">
                                                        ${item.service.description}
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                    ${item.quantity}
                                                </span>
                                            </td>
                                            <td class="text-right">
                                                <span class="font-semibold text-gray-900">
                                                    <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                    ${item.serviceDuration} phút
                                                </span>
                                            </td>
                                            <td class="text-right">
                                                <span class="font-bold text-primary">
                                                    <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty item.usage}">
                                                        <div class="flex flex-col gap-1">
                                                            <div class="flex items-center gap-2">
                                                                <div class="w-full bg-gray-200 rounded-full h-2">
                                                                    <c:choose>
                                                                        <c:when test="${item.usage.totalQuantity > 0}">
                                                                            <c:set var="usagePercentage" value="${(item.usage.bookedQuantity * 100) / item.usage.totalQuantity}" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <c:set var="usagePercentage" value="0" />
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    <div class="bg-primary h-2 rounded-full" style="width: ${usagePercentage}%"></div>
                                                                </div>
                                                                <span class="text-xs text-gray-600 whitespace-nowrap">
                                                                    ${item.usage.bookedQuantity}/${item.usage.totalQuantity}
                                                                </span>
                                                            </div>
                                                            <div class="text-xs text-gray-500">
                                                                Còn lại: ${item.usage.remainingQuantity}
                                                            </div>
                                                            <c:if test="${not empty item.usage.lastUpdated}">
                                                                <div class="text-xs text-gray-500">
                                                                    Cập nhật: ${item.usage.lastUpdated}
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                            Chưa sử dụng
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <div class="flex justify-center gap-1">
                                                    <button onclick="viewServiceDetails('${item.service.serviceId}')"
                                                            class="inline-flex items-center px-2 py-1 bg-blue-100 hover:bg-blue-200 text-blue-700 rounded text-xs font-medium transition-colors"
                                                            title="Xem chi tiết dịch vụ">
                                                        <i data-lucide="eye" class="h-3 w-3"></i>
                                                    </button>
                                                    
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-8 text-gray-500">
                                <i data-lucide="inbox" class="h-12 w-12 mx-auto mb-4 text-gray-400"></i>
                                <p class="text-lg font-medium">Không có dịch vụ nào</p>
                                <p class="text-sm">Thanh toán này chưa có dịch vụ được mua.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Notes -->
            <c:if test="${not empty payment.notes}">
                <div class="info-card">
                    <h5 class="mb-3">
                        <iconify-icon icon="solar:note-outline" class="me-2"></iconify-icon>
                        Ghi Chú
                    </h5>
                    <p class="mb-0">${payment.notes}</p>
                </div>
            </c:if>


        </div>
    </main>

    <script>
        $(document).ready(function() {
            // Initialize Lucide icons
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }

            // Initialize DataTables
            if ($.fn.DataTable && document.getElementById('paymentItemsTable')) {
                console.log('Initializing DataTables for paymentItemsTable...');

                // Check if DataTable already exists and destroy it
                if ($.fn.DataTable.isDataTable('#paymentItemsTable')) {
                    $('#paymentItemsTable').DataTable().destroy();
                }

                try {
                    $('#paymentItemsTable').DataTable({
                    responsive: true,
                    dom: 'Blfrtip',
                    processing: true,
                    stateSave: true,
                    stateDuration: 300, // 5 minutes state persistence
                    pageResize: true,
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
                    order: [[0, 'asc']], // Sort by service name by default
                    columnDefs: [
                        {
                            responsivePriority: 1,
                            targets: [0, 1, 4, 6] // Service name, quantity, total price, actions are high priority
                        },
                        {
                            responsivePriority: 2,
                            targets: [2, 3] // Unit price and duration are medium priority
                        },
                        {
                            responsivePriority: 3,
                            targets: [5] // Usage status is low priority
                        },
                        // Đơn giá column (index 2) - numeric sorting
                        {
                            targets: 2,
                            type: 'num',
                            render: function(data, type, row) {
                                if (type === 'sort' || type === 'type') {
                                    // Extract numeric value from formatted currency
                                    return parseFloat(data.replace(/[^\d.,]/g, '').replace(/\./g, '').replace(',', '.')) || 0;
                                }
                                return data;
                            }
                        },
                        // Thời gian column (index 3) - numeric sorting
                        {
                            targets: 3,
                            type: 'num',
                            render: function(data, type, row) {
                                if (type === 'sort' || type === 'type') {
                                    // Extract numeric value from "X phút" format
                                    var match = data.match(/(\d+)/);
                                    return match ? parseInt(match[1]) : 0;
                                }
                                return data;
                            }
                        },
                        // Thành tiền column (index 4) - numeric sorting
                        {
                            targets: 4,
                            type: 'num',
                            render: function(data, type, row) {
                                if (type === 'sort' || type === 'type') {
                                    // Extract numeric value from formatted currency
                                    return parseFloat(data.replace(/[^\d.,]/g, '').replace(/\./g, '').replace(',', '.')) || 0;
                                }
                                return data;
                            }
                        },
                        // Make action column non-sortable
                        {
                            targets: 6,
                            orderable: false,
                            searchable: false
                        }
                    ],
                    pageLength: 10,
                    lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "Tất cả"]],
                    buttons: [
                        {
                            extend: 'excelHtml5',
                            text: '<i class="fas fa-file-excel mr-1"></i> Xuất Excel',
                            className: 'bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded',
                            exportOptions: {
                                columns: [0, 1, 2, 3] // Export only service info, quantity, prices
                            }
                        },
                        {
                            extend: 'print',
                            text: '<i class="fas fa-print mr-1"></i> In',
                            className: 'bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded',
                            exportOptions: {
                                columns: [0, 1, 2, 3] // Print only service info, quantity, prices
                            }
                        }
                    ],
                    dom: '<"flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-4"<"flex items-center"l><"flex items-center"Bf>>rtip',

                    // Custom state saving callback to preserve pagination during sorting
                    stateSaveCallback: function(settings, data) {
                        // Store the current page info before any operations
                        data.paymentItemsCurrentPage = this.api().page.info().page;
                        data.paymentItemsPageLength = this.api().page.len();

                        // Store in sessionStorage for this specific table
                        sessionStorage.setItem('paymentItemsTableState', JSON.stringify(data));
                    },

                    stateLoadCallback: function(settings) {
                        // Load state from sessionStorage
                        var state = sessionStorage.getItem('paymentItemsTableState');
                        return state ? JSON.parse(state) : null;
                    },

                    // Handle pre-sort to preserve current page context
                    preDrawCallback: function(settings) {
                        // Store current page before any redraw
                        var api = this.api();
                        var currentPage = api.page.info().page;
                        var pageLength = api.page.len();

                        // Store in data attribute for later use
                        $(this).data('currentPage', currentPage);
                        $(this).data('pageLength', pageLength);
                    },

                    // Handle post-draw to restore appropriate page
                    drawCallback: function(settings) {
                        var api = this.api();
                        var storedPage = $(this).data('currentPage');
                        var currentInfo = api.page.info();

                        // If we have a stored page and it's different from current
                        if (storedPage !== undefined && storedPage !== currentInfo.page) {
                            // Check if the stored page is still valid
                            var maxPage = Math.ceil(currentInfo.recordsDisplay / currentInfo.length) - 1;

                            if (storedPage <= maxPage && storedPage >= 0) {
                                // Restore the previous page if it's still valid
                                api.page(storedPage).draw(false);
                            } else if (storedPage > maxPage) {
                                // If stored page is beyond available pages, go to last page
                                api.page(maxPage).draw(false);
                            }
                        }

                        // Reinitialize Lucide icons
                        setTimeout(function() {
                            if (typeof lucide !== 'undefined') {
                                lucide.createIcons();
                            }
                        }, 100);
                    },

                    initComplete: function() {
                        // Apply custom styling after DataTables initialization
                        $('.dataTables_filter input').addClass('ml-2 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary');
                        $('.dataTables_length select').addClass('mx-2 px-2 py-1 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary');
                        $('.dataTables_paginate .paginate_button').addClass('mx-1');

                        // Style the wrapper
                        $('.dataTables_wrapper').addClass('px-0 pb-0');

                        // Reinitialize Lucide icons for DataTables buttons
                        setTimeout(function() {
                            if (typeof lucide !== 'undefined') {
                                lucide.createIcons();
                            }
                        }, 200);

                        console.log('DataTables initialized successfully for manager payment details');
                    }
                });
                } catch (error) {
                    console.error('Error initializing DataTables:', error);
                    alert('Có lỗi xảy ra khi khởi tạo bảng dữ liệu. Vui lòng tải lại trang.');
                }
            } else {
                console.log('DataTables not available or table not found');
            }
        });

        function editPayment(paymentId) {
            if (confirm('Bạn có chắc chắn muốn chỉnh sửa thanh toán #' + paymentId + '?')) {
                // TODO: Implement edit functionality
                alert('Chức năng chỉnh sửa thanh toán đang được phát triển.');
            }
        }

        function refundPayment(paymentId) {
            if (confirm('Bạn có chắc chắn muốn hoàn tiền cho thanh toán #' + paymentId + '? Hành động này không thể hoàn tác.')) {
                // TODO: Implement refund functionality
                alert('Chức năng hoàn tiền đang được phát triển.');
            }
        }

        function printReceipt(paymentId) {
            // TODO: Implement print receipt functionality
            alert('Chức năng in hóa đơn đang được phát triển.');
        }

        function viewServiceDetails(serviceId) {
            // Open service details in a new window or modal
            window.open('${pageContext.request.contextPath}/service-details?id=' + serviceId, '_blank');
        }

        function scheduleService(paymentItemId) {
            // TODO: Implement schedule service functionality for managers
            if (confirm('Bạn có muốn đặt lịch dịch vụ này cho khách hàng?')) {
                alert('Chức năng đặt lịch đang được phát triển.');
            }
        }

        // Initialize payment details filters when DOM is ready
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize Lucide icons
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }

            // Initialize payment details filters
            if (typeof initializePaymentDetailsFilters === 'function') {
                initializePaymentDetailsFilters();
            }
        });
    </script>
</body>
</html>
