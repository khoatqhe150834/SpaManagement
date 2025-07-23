<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chi Tiết Thanh Toán - Spa Hương Sen</title>

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

    <!-- Customer Payment Details Filter JS -->
    <script src="${pageContext.request.contextPath}/js/customer-payment-details.js?v=<%= System.currentTimeMillis() %>"></script>

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

        .payment-items-table td:nth-child(1) { text-align: left; }    /* Dịch vụ */
        .payment-items-table td:nth-child(2) { text-align: center; }  /* Số lượng */
        .payment-items-table td:nth-child(3) { text-align: right; }   /* Đơn giá */
        .payment-items-table td:nth-child(4) { text-align: center; }  /* Thời gian */
        .payment-items-table td:nth-child(5) { text-align: right; }   /* Thành tiền */
        .payment-items-table td:nth-child(6) { text-align: center; }  /* Tình trạng sử dụng */

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

        /* Progress bar container improvements */
        .usage-progress {
            width: 120px;
            margin: 0 auto;
        }

        /* Filter panel styling */
        .customer-payment-details-filter-panel {
            transition: max-height 0.3s ease-in-out, opacity 0.3s ease-in-out;
            max-height: 0;
            opacity: 0;
            overflow: hidden;
        }

        .customer-payment-details-filter-panel.show {
            max-height: 500px;
            opacity: 1;
        }

        #toggleCustomerPaymentDetailsFilters i {
            transition: transform 0.3s ease;
        }

        #toggleCustomerPaymentDetailsFilters i.rotate-180 {
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
            <ul class="ml-auto flex items-center">
                <li class="dropdown ml-3">
                    <button type="button" class="dropdown-toggle flex items-center hover:bg-primary/10 rounded-lg p-2 transition-all duration-200">
                        <div class="flex-shrink-0 w-10 h-10 relative">
                            <div class="p-1 bg-white rounded-full focus:outline-none focus:ring-2 focus:ring-primary/20">
                                <img class="w-8 h-8 rounded-full object-cover" src="https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=100" alt="Customer Avatar"/>
                                <div class="top-0 left-7 absolute w-3 h-3 bg-green-400 border-2 border-white rounded-full animate-ping"></div>
                                <div class="top-0 left-7 absolute w-3 h-3 bg-green-500 border-2 border-white rounded-full"></div>
                            </div>
                        </div>
                        <div class="p-2 md:block text-left">
                            <h2 class="text-sm font-semibold text-spa-dark">${sessionScope.customer.fullName}</h2>
                            <p class="text-xs text-primary/70">Khách hàng</p>
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
            <!-- Page Header -->
            <div class="bg-gradient-to-r from-primary to-primary-dark text-white p-8 rounded-xl mb-8">
                <div class="flex items-center justify-between">
                    
                    <c:if test="${payment != null}">
                        <div class="text-right">
                            <div class="text-lg font-medium">#${payment.paymentId}</div>
                            <div class="text-white/80 text-sm">
                                <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <c:choose>
                <c:when test="${payment != null}">
                    

                    <!-- Payment Information -->
                    <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden mb-6">
                        <div class="p-6 border-b border-gray-200">
                            <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                                <i data-lucide="credit-card" class="h-6 w-6 text-primary"></i>
                                Thông Tin Thanh Toán
                            </h2>
                        </div>
                        <div class="p-6">
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                <div>
                                    <div class="text-sm text-gray-600 mb-1">Mã thanh toán</div>
                                    <div class="font-semibold text-lg text-spa-dark">#${payment.paymentId}</div>
                                </div>

                                <div>
                                    <div class="text-sm text-gray-600 mb-1">Mã tham chiếu</div>
                                    <div class="font-semibold text-lg text-spa-dark">
                                        ${not empty payment.referenceNumber ? payment.referenceNumber : 'N/A'}
                                    </div>
                                </div>

                                <div>
                                    <div class="text-sm text-gray-600 mb-1">Ngày giao dịch</div>
                                    <div class="font-semibold text-lg text-spa-dark">
                                        <c:choose>
                                            <c:when test="${payment.transactionDate != null}">
                                                <fmt:formatDate value="${payment.transactionDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div>
                                    <div class="text-sm text-gray-600 mb-1">Ngày thanh toán</div>
                                    <div class="font-semibold text-lg text-spa-dark">
                                        <c:choose>
                                            <c:when test="${payment.paymentDate != null}">
                                                <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </c:when>
                                            <c:otherwise>Chưa thanh toán</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div>
                                    <div class="text-sm text-gray-600 mb-1">Phương thức thanh toán</div>
                                    <div class="font-semibold text-lg text-spa-dark flex items-center gap-2">
                                        <c:choose>
                                            <c:when test="${payment.paymentMethod == 'BANK_TRANSFER'}">
                                                <i data-lucide="building" class="h-4 w-4 text-blue-600"></i>
                                                Chuyển khoản ngân hàng
                                            </c:when>
                                            <c:when test="${payment.paymentMethod == 'CREDIT_CARD'}">
                                                <i data-lucide="credit-card" class="h-4 w-4 text-purple-600"></i>
                                                Thẻ tín dụng
                                            </c:when>
                                            <c:when test="${payment.paymentMethod == 'VNPAY'}">
                                                <i data-lucide="smartphone" class="h-4 w-4 text-red-600"></i>
                                                VNPay
                                            </c:when>
                                            <c:when test="${payment.paymentMethod == 'MOMO'}">
                                                <i data-lucide="smartphone" class="h-4 w-4 text-pink-600"></i>
                                                MoMo
                                            </c:when>
                                            <c:when test="${payment.paymentMethod == 'ZALOPAY'}">
                                                <i data-lucide="smartphone" class="h-4 w-4 text-blue-600"></i>
                                                ZaloPay
                                            </c:when>
                                            <c:when test="${payment.paymentMethod == 'CASH'}">
                                                <i data-lucide="banknote" class="h-4 w-4 text-green-600"></i>
                                                Tiền mặt
                                            </c:when>
                                            <c:otherwise>
                                                <i data-lucide="help-circle" class="h-4 w-4 text-gray-600"></i>
                                                ${payment.paymentMethod}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div>
                                    <div class="text-sm text-gray-600 mb-1">Trạng thái</div>
                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium
                                        <c:choose>
                                            <c:when test="${payment.paymentStatus == 'PAID'}">bg-green-100 text-green-800</c:when>
                                            <c:when test="${payment.paymentStatus == 'PENDING'}">bg-yellow-100 text-yellow-800</c:when>
                                            <c:when test="${payment.paymentStatus == 'FAILED'}">bg-red-100 text-red-800</c:when>
                                            <c:when test="${payment.paymentStatus == 'REFUNDED'}">bg-blue-100 text-blue-800</c:when>
                                            <c:otherwise>bg-gray-100 text-gray-800</c:otherwise>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${payment.paymentStatus == 'PAID'}">
                                                <i data-lucide="check-circle" class="h-4 w-4 mr-1"></i>
                                                Đã thanh toán
                                            </c:when>
                                            <c:when test="${payment.paymentStatus == 'PENDING'}">
                                                <i data-lucide="clock" class="h-4 w-4 mr-1"></i>
                                                Chờ xử lý
                                            </c:when>
                                            <c:when test="${payment.paymentStatus == 'FAILED'}">
                                                <i data-lucide="x-circle" class="h-4 w-4 mr-1"></i>
                                                Thất bại
                                            </c:when>
                                            <c:when test="${payment.paymentStatus == 'REFUNDED'}">
                                                <i data-lucide="rotate-ccw" class="h-4 w-4 mr-1"></i>
                                                Đã hoàn tiền
                                            </c:when>
                                            <c:otherwise>
                                                <i data-lucide="help-circle" class="h-4 w-4 mr-1"></i>
                                                ${payment.paymentStatus}
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>

                            <!-- Payment Amount Breakdown -->
                            <div class="mt-8 pt-6 border-t border-gray-200">
                                <h3 class="text-lg font-semibold text-spa-dark mb-4">Chi tiết số tiền</h3>
                                <div class="bg-gray-50 rounded-lg p-4">
                                    <div class="space-y-3">
                                        <div class="flex justify-between items-center">
                                            <span class="text-gray-600">Tạm tính:</span>
                                            <span class="font-medium">
                                                <fmt:formatNumber value="${payment.subtotalAmount}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                                            </span>
                                        </div>
                                        <div class="flex justify-between items-center">
                                            <span class="text-gray-600">Thuế VAT:</span>
                                            <span class="font-medium">
                                                <fmt:formatNumber value="${payment.taxAmount}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                                            </span>
                                        </div>
                                        <div class="border-t pt-3">
                                            <div class="flex justify-between items-center">
                                                <span class="text-lg font-semibold text-spa-dark">Tổng cộng:</span>
                                                <span class="text-xl font-bold text-primary">
                                                    <fmt:formatNumber value="${payment.totalAmount}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <c:if test="${not empty payment.notes}">
                                <div class="mt-6 p-4 bg-yellow-50 border-l-4 border-yellow-400 rounded">
                                    <div class="flex items-start">
                                        <i data-lucide="info" class="h-5 w-5 text-yellow-600 mr-2 mt-0.5"></i>
                                        <div>
                                            <div class="font-medium text-yellow-800 mb-1">Ghi chú:</div>
                                            <div class="text-yellow-700">${payment.notes}</div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Payment Items -->
                    <c:choose>
                        <c:when test="${paymentItems != null && not empty paymentItems}">
                            <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden mb-6">
                                <div class="p-6 border-b border-gray-200">
                                    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                                        <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                                            <i data-lucide="shopping-bag" class="h-6 w-6 text-primary"></i>
                                            Dịch Vụ Đã Mua (${fn:length(paymentItems)} dịch vụ)
                                        </h2>

                                        <div class="flex flex-wrap items-center gap-3">
                                            <!-- Filter Toggle Button -->
                                            <button id="toggleCustomerPaymentDetailsFilters" class="inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                                                <i data-lucide="filter" class="h-4 w-4 mr-2"></i>
                                                Bộ lọc
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <!-- Filter Panel -->
                                <div id="customerPaymentDetailsFilterPanel" class="customer-payment-details-filter-panel px-6 py-0 border-b border-gray-200 bg-gray-50">
                                    <div class="p-6">
                                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                                            <!-- Service Name Filter -->
                                            <div>
                                                <label for="customerPaymentDetailsServiceFilter" class="block text-sm font-medium text-gray-700 mb-2">Tên dịch vụ</label>
                                                <select id="customerPaymentDetailsServiceFilter" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                                    <option value="">Tất cả dịch vụ</option>
                                                </select>
                                            </div>

                                            <!-- Quantity Filter -->
                                            <div>
                                                <label for="customerPaymentDetailsQuantityFilter" class="block text-sm font-medium text-gray-700 mb-2">Số lượng</label>
                                                <input type="number" id="customerPaymentDetailsQuantityFilter" placeholder="Nhập số lượng" min="1"
                                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                            </div>

                                            <!-- Amount Range -->
                                            <div>
                                                <label for="customerPaymentDetailsMinAmount" class="block text-sm font-medium text-gray-700 mb-2">Giá từ</label>
                                                <input type="number" id="customerPaymentDetailsMinAmount" placeholder="0" min="0" step="1000"
                                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                            </div>

                                            <div>
                                                <label for="customerPaymentDetailsMaxAmount" class="block text-sm font-medium text-gray-700 mb-2">Giá đến</label>
                                                <input type="number" id="customerPaymentDetailsMaxAmount" placeholder="10,000,000" min="0" step="1000"
                                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                            </div>
                                        </div>

                                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
                                            <!-- Duration Filter -->
                                            <div>
                                                <label for="customerPaymentDetailsDurationFilter" class="block text-sm font-medium text-gray-700 mb-2">Thời gian (phút)</label>
                                                <input type="number" id="customerPaymentDetailsDurationFilter" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" placeholder="Nhập thời gian" min="1" />
                                            </div>

                                            <!-- Usage Status Filter -->
                                            <div>
                                                <label for="customerPaymentDetailsUsageFilter" class="block text-sm font-medium text-gray-700 mb-2">Tình trạng sử dụng</label>
                                                <select id="customerPaymentDetailsUsageFilter" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                                    <option value="">Tất cả</option>
                                                    <option value="used">Đã sử dụng</option>
                                                    <option value="unused">Chưa sử dụng</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Filter Actions -->
                                    <div class="flex justify-end py-3 px-6 gap-3 border-t border-gray-200">
                                        <button id="resetCustomerPaymentDetailsFilters" class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                                            Đặt lại
                                        </button>
                                        <button id="applyCustomerPaymentDetailsFilters" class="px-4 py-2 text-sm font-medium text-white bg-primary rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary/20">
                                            Áp dụng
                                        </button>
                                    </div>
                                </div>
                                <div class="p-6">
                                    <table id="paymentItemsTable" class="w-full display responsive nowrap payment-items-table" style="width:100%">
                                        <thead>
                                            <tr>
                                                <th>Dịch vụ</th>
                                                <th>Số lượng</th>
                                                <th>Đơn giá</th>
                                                <th>Thời gian</th>
                                                <th>Thành tiền</th>
                                                <th>Tình trạng sử dụng</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${paymentItems}">
                                                <tr>
                                                    <td>
                                                        <div class="service-name">
                                                            ${item.service != null && item.service.name != null ? item.service.name : 'Dịch vụ không xác định'}
                                                        </div>
                                                        <c:if test="${item.service != null && not empty item.service.description}">
                                                            <div class="service-description">${item.service.description}</div>
                                                        </c:if>
                                                        <div class="text-xs text-gray-500 mt-1">ID: #${item.serviceId}</div>
                                                    </td>
                                                    <td class="font-semibold">${item.quantity}</td>
                                                    <td>
                                                        <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                                                    </td>
                                                    <td>
                                                        ${item.serviceDuration != null ? item.serviceDuration : 'N/A'} phút
                                                    </td>
                                                    <td class="font-semibold text-primary">
                                                        <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${item.usage != null}">
                                                                <div class="flex flex-col items-center">
                                                                    <div class="usage-progress mb-1">
                                                                        <div class="usage-progress-bar"
                                                                             data-booked="${item.usage.bookedQuantity}"
                                                                             data-total="${item.usage.totalQuantity}"></div>
                                                                    </div>
                                                                    <div class="usage-info text-center">
                                                                        ${item.usage.bookedQuantity}/${item.usage.totalQuantity} đã sử dụng
                                                                    </div>
                                                                    <div class="usage-info text-green-600 text-center">
                                                                        Còn lại: ${item.usage.remainingQuantity}
                                                                    </div>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-gray-500 text-sm">Chưa có thông tin</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- No Payment Items -->
                            <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden mb-6">
                                <div class="p-12 text-center">
                                    <i data-lucide="shopping-bag" class="h-16 w-16 text-gray-400 mx-auto mb-4"></i>
                                    <h3 class="text-xl font-semibold text-spa-dark mb-2">Không có dịch vụ nào</h3>
                                    <p class="text-gray-600">Thanh toán này không chứa dịch vụ nào.</p>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>
                    <!-- No Payment Found -->
                    <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden">
                        <div class="p-12 text-center">
                            <i data-lucide="alert-circle" class="h-16 w-16 text-gray-400 mx-auto mb-4"></i>
                            <h3 class="text-xl font-semibold text-spa-dark mb-2">Không tìm thấy thông tin thanh toán</h3>
                            <p class="text-gray-600 mb-6">Thanh toán này không tồn tại hoặc bạn không có quyền truy cập.</p>
                            <a href="${pageContext.request.contextPath}/customer/payment-history"
                               class="inline-flex items-center px-6 py-3 bg-primary hover:bg-primary-dark text-white rounded-lg font-medium transition-colors duration-200">
                                <i data-lucide="arrow-left" class="h-5 w-5 mr-2"></i>
                                Quay lại lịch sử thanh toán
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Action Buttons -->
            <c:if test="${payment != null}">
                <div class="mt-6 flex flex-wrap justify-center gap-4">
                    <a href="${pageContext.request.contextPath}/customer/payment-history"
                       class="inline-flex items-center px-6 py-3 bg-gray-500 hover:bg-gray-600 text-white rounded-lg font-medium transition-colors duration-200">
                        <i data-lucide="arrow-left" class="h-5 w-5 mr-2"></i>
                        Quay lại
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/contact"
                       class="inline-flex items-center px-6 py-3 bg-green-600 hover:bg-green-700 text-white rounded-lg font-medium transition-colors duration-200">
                        <i data-lucide="headphones" class="h-5 w-5 mr-2"></i>
                        Hỗ trợ
                    </a>
                </div>
            </c:if>
        </div>
    </main>

    <!-- JavaScript -->
    <script>
        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }

        // Dropdown functionality
        document.addEventListener('DOMContentLoaded', function() {
            // Toggle dropdowns
            document.querySelectorAll('.dropdown-toggle').forEach(function(item) {
                item.addEventListener('click', function(e) {
                    e.preventDefault();
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

            // Initialize progress bars
            initializeProgressBars();

            // Initialize filter functionality (handled by external JS)
            // Wait a bit to ensure all elements are rendered
            setTimeout(function() {
                if (typeof initializeCustomerPaymentDetailsFilters === 'function') {
                    initializeCustomerPaymentDetailsFilters();
                } else {
                    console.error('initializeCustomerPaymentDetailsFilters function not found');
                }
            }, 100);

            // Initialize DataTables
            if ($.fn.DataTable && document.getElementById('paymentItemsTable')) {
                $('#paymentItemsTable').DataTable({
                    responsive: true,
                    dom: 'Blfrtip',
                    processing: true,
                    stateSave: true,
                    stateDuration: 300, // 5 minutes state persistence
                    pageResize: true,
                    columnDefs: [
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
                        }
                    ],
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
                    buttons: [
                        {
                            extend: 'excel',
                            text: '<i data-lucide="file-spreadsheet" class="h-4 w-4 mr-1"></i> Xuất Excel',
                            className: 'bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors inline-flex items-center',
                            filename: 'Chi_tiet_thanh_toan_${payment.paymentId}_' + new Date().toISOString().slice(0,10),
                            title: 'Chi tiết thanh toán #${payment.paymentId}',
                            exportOptions: {
                                columns: [0, 1, 2, 3, 4, 5] // Include all columns (no action column to exclude)
                            }
                        },
                        {
                            extend: 'print',
                            text: '<i data-lucide="printer" class="h-4 w-4 mr-1"></i> In',
                            className: 'bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors inline-flex items-center',
                            title: 'Chi tiết thanh toán #${payment.paymentId}',
                            exportOptions: {
                                columns: [0, 1, 2, 3, 4, 5] // Include all columns (no action column to exclude)
                            }
                        }
                    ],
                    dom: '<"flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-4"<"flex items-center"l><"flex items-center"Bf>>rtip',





                    // Handle post-draw to restore appropriate page
                    drawCallback: function(settings) {
                        // Reinitialize progress bars after draw
                        setTimeout(initializeProgressBars, 50);

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
                        $('.dataTables_wrapper').addClass('px-6 pb-6');

                        // Initialize progress bars after DataTables is ready
                        setTimeout(initializeProgressBars, 100);

                        // Reinitialize Lucide icons for DataTables buttons
                        setTimeout(function() {
                            if (typeof lucide !== 'undefined') {
                                lucide.createIcons();
                            }
                        }, 200);

                        console.log('DataTables initialized successfully');
                    }
                });
            }
        });

        // Cleanup function for page navigation
        window.addEventListener('beforeunload', function() {
            // Clear payment items table state when leaving the page
            sessionStorage.removeItem('paymentItemsTableState');
        });

        // Progress bar initialization
        function initializeProgressBars() {
            document.querySelectorAll('.usage-progress-bar').forEach(function(bar) {
                const booked = parseInt(bar.getAttribute('data-booked')) || 0;
                const total = parseInt(bar.getAttribute('data-total')) || 1;
                const percentage = total > 0 ? (booked / total) * 100 : 0;

                // Animate progress bar
                setTimeout(function() {
                    bar.style.width = percentage + '%';
                }, 100);
            });
        }

        // Download receipt function
        function downloadReceipt() {
            // Create a printable version
            const printContent = document.querySelector('main').innerHTML;
            const originalContent = document.body.innerHTML;

            // Hide action buttons for printing
            const actionButtons = document.querySelector('.mt-6.flex.flex-wrap.justify-center.gap-4');
            if (actionButtons) {
                actionButtons.style.display = 'none';
            }

            // Print
            window.print();

            // Restore action buttons
            if (actionButtons) {
                actionButtons.style.display = 'flex';
            }
        }

        // Print styles for better receipt formatting
        const printStyles = `
            <style>
                @media print {
                    body { font-size: 12px; }
                    .no-print { display: none !important; }
                    .bg-primary { background-color: #D4AF37 !important; }
                    .text-primary { color: #D4AF37 !important; }
                    .shadow-md, .shadow-lg { box-shadow: none !important; }
                    .rounded-xl, .rounded-lg { border-radius: 8px !important; }
                    .p-6 { padding: 1rem !important; }
                    .mb-6 { margin-bottom: 1rem !important; }
                    .gap-6 { gap: 0.5rem !important; }
                    .text-3xl { font-size: 1.5rem !important; }
                    .text-2xl { font-size: 1.25rem !important; }
                    .text-xl { font-size: 1.125rem !important; }
                    .text-lg { font-size: 1rem !important; }
                }
            </style>
        `;

        // Add print styles to head
        document.head.insertAdjacentHTML('beforeend', printStyles);

        // Format currency for Vietnamese locale
        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(amount);
        }

        // Show toast notification
        function showToast(message, type = 'info') {
            // Create toast element
            const toast = document.createElement('div');
            toast.className = `fixed top-4 right-4 z-50 px-6 py-3 rounded-lg shadow-lg text-white transition-all duration-300 transform translate-x-full`;

            // Set background color based on type
            switch(type) {
                case 'success':
                    toast.classList.add('bg-green-600');
                    break;
                case 'error':
                    toast.classList.add('bg-red-600');
                    break;
                case 'warning':
                    toast.classList.add('bg-yellow-600');
                    break;
                default:
                    toast.classList.add('bg-blue-600');
            }

            toast.textContent = message;
            document.body.appendChild(toast);

            // Show toast
            setTimeout(() => {
                toast.classList.remove('translate-x-full');
            }, 100);

            // Hide toast after 3 seconds
            setTimeout(() => {
                toast.classList.add('translate-x-full');
                setTimeout(() => {
                    document.body.removeChild(toast);
                }, 300);
            }, 3000);
        }
    </script>
</body>
</html>