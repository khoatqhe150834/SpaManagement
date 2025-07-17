<%-- 
    Document   : payment-history.jsp
    Created on : Payment History for Customer
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lịch Sử Thanh Toán - Spa Hương Sen</title>
    
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
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>

    <style>
        /* Custom DataTables styling to match our theme */
        .dataTables_wrapper {
            font-family: 'Roboto', sans-serif;
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

        /* Enhanced search input styling */
        .dataTables_filter {
            position: relative;
        }

        .dataTables_filter input {
            transition: all 0.3s ease;
            min-width: 250px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            padding: 8px 12px;
            margin-left: 8px;
        }

        .dataTables_filter input:focus {
            outline: none;
            border-color: #D4AF37;
            box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
            transform: scale(1.02);
            box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1), 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .search-clear {
            transition: all 0.2s ease;
        }

        .search-clear:hover {
            background-color: rgba(212, 175, 55, 0.1);
        }

        /* Search results highlighting */
        .dataTables_info {
            font-weight: 500;
        }

        /* Responsive search input */
        @media (max-width: 640px) {
            .dataTables_filter input {
                min-width: 200px;
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
            <!-- Payment History Table -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden">
                <div class="p-6 border-b border-gray-200">
                    <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                        <i data-lucide="credit-card" class="h-6 w-6 text-primary"></i>
                        Lịch sử thanh toán
                    </h2>
                </div>

                <c:choose>
                    <c:when test="${payments != null && not empty payments}">
                        <div class="p-6">
                            <div class="dataTables_filter mb-4">
                                <label>
                                    <input type="search" id="customSearch" class="ml-2 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" placeholder="Tìm kiếm thanh toán...">
                                    <button type="button" class="search-clear ml-2 px-2 py-1 text-gray-500 hover:text-gray-700 rounded" title="Xóa tìm kiếm">
                                        <i data-lucide="x" class="h-4 w-4"></i>
                                    </button>
                                </label>
                            </div>
                            <table id="paymentsTable" class="w-full display responsive nowrap" style="width:100%">
                                <thead>
                                    <tr>
                                        <th>Mã thanh toán</th>
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
                                                            class="inline-flex items-center px-3 py-1 text-xs font-medium text-blue-600 bg-blue-50 rounded-md hover:bg-blue-100 transition-colors duration-200"
                                                            title="Xem chi tiết">
                                                        <i data-lucide="eye" class="h-3 w-3 mr-1"></i>
                                                        Xem
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Empty State -->
                        <div class="p-12 text-center">
                            <i data-lucide="receipt" class="h-16 w-16 text-gray-400 mx-auto mb-4"></i>
                            <h3 class="text-lg font-semibold text-spa-dark mb-2">Chưa có lịch sử thanh toán</h3>
                            <p class="text-gray-600 mb-6">Bạn chưa thực hiện thanh toán nào. Hãy đặt dịch vụ để bắt đầu trải nghiệm spa!</p>
                            <a href="${pageContext.request.contextPath}/" class="bg-primary hover:bg-primary-dark text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200 inline-flex items-center gap-2">
                                <i data-lucide="sparkles" class="h-5 w-5"></i>
                                Khám phá dịch vụ
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
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
            
            // Initialize DataTables
            if ($.fn.DataTable && document.getElementById('paymentsTable')) {
                var table = $('#paymentsTable').DataTable({
                    responsive: true,
                    dom: 'Blfrtip', // Add 'B' for buttons to the dom string
                    processing: true,
                    searching: false, // Disable DataTables' default search
                    searchDelay: 300, // Built-in search delay
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
                    order: [[1, 'desc']], // Sort by payment date (column 1) in descending order
                    columnDefs: [
                        { 
                            responsivePriority: 1, 
                            targets: [0, 1, 3, 4, 6] // Payment ID, Date, Amount, Status, Actions are high priority
                        },
                        { 
                            responsivePriority: 2, 
                            targets: [2] // Method is medium priority
                        },
                        { 
                            responsivePriority: 3, 
                            targets: [5] // Notes are low priority
                        },
                        {
                            targets: 0, // Payment ID column
                            type: 'num',
                            render: function(data, type, row) {
                                if (type === 'sort' || type === 'type') {
                                    var numericValue = data.replace(/[^\d]/g, '');
                                    return parseInt(numericValue) || 0;
                                }
                                return data;
                            }
                        },
                        {
                            targets: 3, // Amount column
                            type: 'num',
                            render: function(data, type, row) {
                                if (type === 'display' || type === 'type') {
                                    return data;
                                }
                                var numericValue = $(data).find('.hidden').text();
                                if (numericValue) {
                                    return parseFloat(numericValue);
                                }
                                var match = data.match(/data-order="([^"]+)"/);
                                if (match) {
                                    return parseFloat(match[1]);
                                }
                                var textMatch = data.replace(/[^\d]/g, '');
                                return textMatch ? parseFloat(textMatch) : 0;
                            }
                        },
                        {
                            targets: 6, // Actions column
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
                            }
                        }
                    ],
                    dom: '<"flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-4"<"flex items-center"l><"flex items-center gap-2"B>>rtip',

                    initComplete: function() {
                        var table = this.api();

                        $('.dataTables_length select').addClass('mx-2 px-2 py-1 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary');
                        $('.dataTables_paginate .paginate_button').addClass('mx-1');
                        $('.dataTables_wrapper').addClass('px-6 pb-6');

                        // Enhanced real-time search functionality
                        var searchInput = $('#customSearch');

                        // Add debounce function
                        var searchTimeout;
                        searchInput.on('input keyup', function() {
                            clearTimeout(searchTimeout);
                            searchTimeout = setTimeout(function() {
                                table.search(searchInput.val()).draw();
                                var info = table.page.info();
                                if (searchInput.val() && info.recordsDisplay !== info.recordsTotal) {
                                    console.log('Search results: ' + info.recordsDisplay + ' of ' + info.recordsTotal + ' records');
                                }
                            }, 300);
                        });

                        // Clear search functionality
                        searchInput.on('search', function() {
                            if (this.value === '') {
                                table.search('').draw();
                            }
                        });

                        // Add clear button functionality
                        $('.search-clear').on('click', function() {
                            searchInput.val('').trigger('input').focus();
                        });

                        if (typeof lucide !== 'undefined') {
                            lucide.createIcons();
                        }
                    }
                });
            }
        });

        // CRUD Functions for Payment Actions
        function viewPayment(paymentId) {
            window.location.href = '${pageContext.request.contextPath}/customer/payment-details?id=' + paymentId;
        }

        function editPayment(paymentId) {
            if (confirm('Bạn có chắc chắn muốn chỉnh sửa thanh toán #' + paymentId + '?')) {
                window.location.href = '${pageContext.request.contextPath}/customer/payment/edit/' + paymentId;
            }
        }

        function deletePayment(paymentId) {
            if (confirm('Bạn có chắc chắn muốn xóa thanh toán #' + paymentId + '? Hành động này không thể hoàn tác.')) {
                const button = event.target.closest('button');
                const originalContent = button.innerHTML;
                button.innerHTML = '<i data-lucide="loader-2" class="h-3 w-3 animate-spin"></i>';
                button.disabled = true;

                fetch('${pageContext.request.contextPath}/customer/payment/delete/' + paymentId, {
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(response => {
                    if (response.ok) return response.json();
                    throw new Error('Network response was not ok');
                })
                .then(data => {
                    if (data.success) {
                        showNotification('Xóa thanh toán thành công!', 'success');
                        setTimeout(() => {
                            location.reload();
                        }, 1500);
                    } else {
                        throw new Error(data.message || 'Có lỗi xảy ra');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showNotification('Có lỗi xảy ra khi xóa thanh toán: ' + error.message, 'error');
                    button.innerHTML = originalContent;
                    button.disabled = false;
                    lucide.createIcons();
                });
            }
        }

        function printReceipt(paymentId) {
            const receiptWindow = window.open(
                '${pageContext.request.contextPath}/customer/payment/receipt/' + paymentId,
                'receipt',
                'width=800,height=600,scrollbars=yes,resizable=yes'
            );
            if (receiptWindow) {
                receiptWindow.focus();
                receiptWindow.onload = function() {
                    receiptWindow.print();
                };
            } else {
                showNotification('Không thể mở cửa sổ in hóa đơn. Vui lòng kiểm tra trình duyệt.', 'error');
            }
        }

        // Notification function
        function showNotification(message, type = 'info') {
            const notification = document.createElement('div');
            notification.className = `fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg max-w-sm transition-all duration-300 transform translate-x-full`;
            
            const colors = {
                success: 'bg-green-500 text-white',
                error: 'bg-red-500 text-white',
                warning: 'bg-yellow-500 text-white',
                info: 'bg-blue-500 text-white'
            };
            notification.className += ' ' + (colors[type] || colors.info);
            
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
            
            setTimeout(() => {
                notification.classList.remove('translate-x-full');
            }, 100);
            
            setTimeout(() => {
                notification.classList.add('translate-x-full');
                setTimeout(() => {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 300);
            }, 5000);
        }

        console.log('Payment History Page Loaded Successfully');
    </script>

</body>
</html>