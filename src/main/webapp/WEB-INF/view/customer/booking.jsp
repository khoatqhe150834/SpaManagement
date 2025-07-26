<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lịch hẹn của tôi - Spa Hương Sen</title>

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

    <!-- Customer Booking JS -->
    <script src="${pageContext.request.contextPath}/js/customer-booking.js?v=<%= System.currentTimeMillis() %>"></script>

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

        /* Filter panel styling */
        .customer-booking-filter-panel {
            transition: max-height 0.3s ease-in-out, opacity 0.3s ease-in-out;
            max-height: 0;
            opacity: 0;
            overflow: hidden;
        }

        .customer-booking-filter-panel.show {
            max-height: 500px;
            opacity: 1;
        }

        #toggleCustomerBookingFilters i {
            transition: transform 0.3s ease;
        }

        #toggleCustomerBookingFilters i.rotate-180 {
            transform: rotate(180deg);
        }

        /* Responsive adjustments for filters */
        @media (max-width: 768px) {
            .grid-cols-1.md\\:grid-cols-2.lg\\:grid-cols-4 {
                grid-template-columns: repeat(1, minmax(0, 1fr));
            }
        }

        /* Status and payment badge styles */
        .status-badge {
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: uppercase;
        }

        .status-scheduled { background-color: #fef3c7; color: #92400e; }
        .status-confirmed { background-color: #dbeafe; color: #1e40af; }
        .status-in_progress { background-color: #fed7d7; color: #c53030; }
        .status-completed { background-color: #d1fae5; color: #065f46; }
        .status-cancelled { background-color: #fee2e2; color: #dc2626; }

        .payment-badge {
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .payment-paid { background-color: #d1fae5; color: #065f46; }
        .payment-pending { background-color: #fef3c7; color: #92400e; }
        .payment-failed { background-color: #fee2e2; color: #dc2626; }
    </style>
</head>
<body class="bg-spa-cream font-sans text-spa-dark">

    <!-- Include Sidebar -->
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

    <main class="w-full md:w-[calc(100%-256px)] md:ml-64 bg-white min-h-screen transition-all main">
        <!-- Modern Navbar -->
        <div class="h-16 px-6 bg-spa-cream flex items-center shadow-sm border-b border-primary/10 sticky top-0 left-0 z-30">
            <button type="button" class="text-lg text-spa-dark font-semibold sidebar-toggle hover:text-primary transition-colors duration-200 hidden">
                <i data-lucide="menu"></i>
            </button>

            <ul class="ml-auto flex items-center">
                <li class="mr-1 dropdown">
                    <button type="button" class="dropdown-toggle text-primary/60 hover:text-primary mr-4 w-8 h-8 rounded-lg flex items-center justify-center hover:bg-primary/10 transition-all duration-200">
                        <i data-lucide="search" class="h-5 w-5"></i>
                    </button>
                </li>

                <!-- User Profile Dropdown -->
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
                </li>
            </ul>
        </div>
        <!-- end navbar -->

        <!-- Content -->
        <div class="p-6 bg-spa-cream min-h-screen">
            <!-- Booking Table -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden">
                <div class="p-6 border-b border-gray-200">
                    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                        <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                            <i data-lucide="calendar-check" class="h-6 w-6 text-primary"></i>
                            Lịch hẹn của tôi
                        </h2>

                        <div class="flex flex-wrap items-center gap-3">
                            <!-- Filter Toggle Button -->
                            <button id="toggleCustomerBookingFilters" class="inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                                <i data-lucide="filter" class="h-4 w-4 mr-2"></i>
                                Bộ lọc
                            </button>
                        </div>
                    </div>
                </div>
                <!-- Filter Panel -->
                <div id="customerBookingFilterPanel" class="customer-booking-filter-panel px-6 py-0 border-b border-gray-200 bg-gray-50">
                    <div class="p-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                            <!-- Booking ID Filter -->
                            <div>
                                <label for="customerBookingIdFilter" class="block text-sm font-medium text-gray-700 mb-2">Mã đặt lịch</label>
                                <input type="text" id="customerBookingIdFilter" placeholder="Nhập mã đặt lịch"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>

                            <!-- Service Filter -->
                            <div>
                                <label for="customerBookingServiceFilter" class="block text-sm font-medium text-gray-700 mb-2">Dịch vụ</label>
                                <input type="text" id="customerBookingServiceFilter" placeholder="Tên dịch vụ"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>

                            <!-- Status Filter -->
                            <div>
                                <label for="customerBookingStatusFilter" class="block text-sm font-medium text-gray-700 mb-2">Trạng thái</label>
                                <select id="customerBookingStatusFilter" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="SCHEDULED">Đã lên lịch</option>
                                    <option value="CONFIRMED">Đã xác nhận</option>
                                    <option value="IN_PROGRESS">Đang thực hiện</option>
                                    <option value="COMPLETED">Hoàn thành</option>
                                    <option value="CANCELLED">Đã hủy</option>
                                </select>
                            </div>

                            <!-- Payment Status Filter -->
                            <div>
                                <label for="customerBookingPaymentFilter" class="block text-sm font-medium text-gray-700 mb-2">Thanh toán</label>
                                <select id="customerBookingPaymentFilter" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                    <option value="">Tất cả</option>
                                    <option value="PAID">Đã thanh toán</option>
                                    <option value="PENDING">Chờ thanh toán</option>
                                    <option value="FAILED">Thất bại</option>
                                </select>
                            </div>
                        </div>

                        <!-- Second Row -->
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mt-4">
                            <!-- Date From -->
                            <div>
                                <label for="customerBookingDateFrom" class="block text-sm font-medium text-gray-700 mb-2">Từ ngày</label>
                                <input type="date" id="customerBookingDateFrom"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>

                            <!-- Date To -->
                            <div>
                                <label for="customerBookingDateTo" class="block text-sm font-medium text-gray-700 mb-2">Đến ngày</label>
                                <input type="date" id="customerBookingDateTo"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>

                            <!-- Therapist Filter -->
                            <div>
                                <label for="customerBookingTherapistFilter" class="block text-sm font-medium text-gray-700 mb-2">Nhân viên</label>
                                <input type="text" id="customerBookingTherapistFilter" placeholder="Tên nhân viên"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>
                        </div>
                    </div>

                    <!-- Filter Actions -->
                    <div class="flex justify-end py-3 px-6 gap-3 border-t border-gray-200">
                        <button id="resetCustomerBookingFilters" class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                            Đặt lại
                        </button>
                        <button id="applyCustomerBookingFilters" class="px-4 py-2 text-sm font-medium text-white bg-primary rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary/20">
                            Áp dụng
                        </button>
                    </div>
                </div>
                <div class="p-6">
                    <table id="bookingsTable" class="w-full display responsive nowrap" style="width:100%">
                        <thead>
                            <tr>
                                <th>Mã đặt lịch</th>
                                <th>Dịch vụ</th>
                                <th>Ngày & Giờ</th>
                                <th>Nhân viên</th>
                                <th>Phòng</th>
                                <th>Trạng thái</th>
                                <th>Thanh toán</th>
                                <th>Số tiền</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Data will be loaded via AJAX -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <!-- JavaScript -->
    <script>
        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }

        // Global variables
        var customerBookingTable;

        // Update summary statistics function
        function updateSummaryStats() {
            try {
                if (!customerBookingTable) return;
                
                var data = customerBookingTable.data();
                if (!data || data.length === 0) {
                    // Set zero values if no data
                    $('#upcomingCount').text('0');
                    $('#completedCount').text('0');
                    $('#pendingCount').text('0');
                    $('#cancelledCount').text('0');
                    return;
                }

                var stats = {
                    upcoming: 0,
                    completed: 0,
                    pending: 0,
                    cancelled: 0
                };

                data.each(function(booking) {
                    if (booking.bookingStatus === 'SCHEDULED' || booking.bookingStatus === 'CONFIRMED') {
                        stats.upcoming++;
                    } else if (booking.bookingStatus === 'COMPLETED') {
                        stats.completed++;
                    } else if (booking.bookingStatus === 'CANCELLED') {
                        stats.cancelled++;
                    }

                    if (booking.paymentStatus === 'PENDING') {
                        stats.pending++;
                    }
                });

                $('#upcomingCount').text(stats.upcoming);
                $('#completedCount').text(stats.completed);
                $('#pendingCount').text(stats.pending);
                $('#cancelledCount').text(stats.cancelled);
            } catch (error) {
                console.log('Error updating summary stats:', error);
                // Set default values if there's an error
                $('#upcomingCount').text('0');
                $('#completedCount').text('0');
                $('#pendingCount').text('0');
                $('#cancelledCount').text('0');
            }
        }

        // Dropdown functionality
        document.addEventListener('DOMContentLoaded', function() {
            // Toggle dropdowns
            document.querySelectorAll('.dropdown-toggle').forEach(function(item) {
                item.addEventListener('click', function(e) {
                    e.preventDefault();
                    var dropdown = item.closest('.dropdown');
                    var menu = dropdown.querySelector('.dropdown-menu');

                    if (menu) {
                        // Close other dropdowns
                        document.querySelectorAll('.dropdown-menu').forEach(function(otherMenu) {
                            if (otherMenu !== menu) {
                                otherMenu.classList.add('hidden');
                            }
                        });

                        // Toggle current dropdown
                        menu.classList.toggle('hidden');
                    }
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

            // Initialize filter functionality (handled by external JS)
            // Wait a bit to ensure all elements are rendered
            setTimeout(function() {
                if (typeof initializeCustomerBookingFilters === 'function') {
                    initializeCustomerBookingFilters();
                } else {
                    console.error('initializeCustomerBookingFilters function not found');
                }
            }, 100);

            // Initialize DataTables
            if ($.fn.DataTable && document.getElementById('bookingsTable')) {
                customerBookingTable = $('#bookingsTable').DataTable({
                    responsive: true,
                    dom: 'Blfrtip', // Add 'B' for buttons to the dom string
                    processing: true,
                    searching: true, // Enable DataTables' default search
                    searchDelay: 300, // Built-in search delay
                    ajax: {
                        url: '${pageContext.request.contextPath}/customer/show-bookings?action=data',
                        type: 'GET',
                        dataSrc: function(json) {
                            console.log('Received booking data:', json);
                            return json.data;
                        },
                        error: function(xhr, error, thrown) {
                            console.error('DataTables AJAX error:', error, thrown);
                            console.error('Response text:', xhr.responseText);
                            alert('Lỗi khi tải dữ liệu lịch hẹn. Vui lòng làm mới trang.');
                        }
                    },
                    columns: [
                        { 
                            data: 'bookingId',
                            render: function(data) {
                                return '#BK' + data.toString().padStart(3, '0');
                            }
                        },
                        { data: 'serviceName' },
                        { 
                            data: null,
                            render: function(data) {
                                var date = new Date(data.appointmentDate);
                                var time = data.appointmentTime;
                                return date.toLocaleDateString() + '<br><small>' + time + '</small>';
                            }
                        },
                        { data: 'therapistName' },
                        { data: 'roomName' },
                        { 
                            data: 'bookingStatus',
                            render: function(data) {
                                return '<span class="status-badge status-' + data.toLowerCase() + '">' + 
                                       data.replace('_', ' ') + '</span>';
                            }
                        },
                        { 
                            data: 'paymentStatus',
                            render: function(data) {
                                return '<span class="payment-badge payment-' + data.toLowerCase() + '">' + 
                                       data + '</span>';
                            }
                        },
                        { 
                            data: 'totalAmount',
                            render: function(data) {
                                return new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND'
                                }).format(data);
                            }
                        },
                        { 
                            data: null,
                            orderable: false,
                            render: function(data, type, row) {
                                var actions = '<button class="px-3 py-1 bg-blue-500 hover:bg-blue-600 text-white rounded-lg text-xs transition-colors mr-1" onclick="viewDetails(' +
                                             row.bookingId + ')" title="Xem chi tiết">' +
                                             '<i data-lucide="eye" class="h-3 w-3 inline"></i></button>';

                                if (row.bookingStatus === 'SCHEDULED' || row.bookingStatus === 'CONFIRMED') {
                                    actions += '<button class="px-3 py-1 bg-yellow-500 hover:bg-yellow-600 text-white rounded-lg text-xs transition-colors mr-1" onclick="reschedule(' +
                                              row.bookingId + ')" title="Đổi lịch">' +
                                              '<i data-lucide="calendar" class="h-3 w-3 inline"></i></button>';
                                    actions += '<button class="px-3 py-1 bg-red-500 hover:bg-red-600 text-white rounded-lg text-xs transition-colors mr-1" onclick="cancelBooking(' +
                                              row.bookingId + ')" title="Hủy lịch">' +
                                              '<i data-lucide="x" class="h-3 w-3 inline"></i></button>';
                                }

                                if (row.paymentStatus === 'PENDING') {
                                    actions += '<button class="px-3 py-1 bg-green-500 hover:bg-green-600 text-white rounded-lg text-xs transition-colors mr-1" onclick="payNow(' +
                                              row.bookingId + ')" title="Thanh toán ngay">' +
                                              '<i data-lucide="credit-card" class="h-3 w-3 inline"></i></button>';
                                }

                                return actions;
                            }
                        }
                    ],
                    language: {
                        "sProcessing": "Đang xử lý...",
                        "sLengthMenu": "Hiển thị _MENU_ mục",
                        "sZeroRecords": "Không tìm thấy lịch hẹn nào phù hợp",
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
                    order: [[2, 'desc']], // Sort by date (column 2) in descending order
                    columnDefs: [
                        {
                            responsivePriority: 1,
                            targets: [0, 1, 2, 5, 6, 8] // Booking ID, Service, Date, Status, Payment, Actions are high priority
                        },
                        {
                            responsivePriority: 2,
                            targets: [3, 4] // Therapist and Room are medium priority
                        },
                        {
                            responsivePriority: 3,
                            targets: [7] // Amount is low priority
                        },
                        {
                            targets: 0, // Booking ID column
                            type: 'num',
                            render: function(data, type, row) {
                                if (type === 'sort' || type === 'type') {
                                    return parseInt(data) || 0;
                                }
                                return '#BK' + data.toString().padStart(3, '0');
                            }
                        },
                        {
                            targets: 7, // Amount column
                            type: 'num',
                            render: function(data, type, row) {
                                if (type === 'sort' || type === 'type') {
                                    return parseFloat(data) || 0;
                                }
                                return '<span class="font-semibold text-primary">' +
                                       new Intl.NumberFormat('vi-VN').format(data) + ' VNĐ</span>';
                            }
                        },
                        {
                            targets: 8, // Actions column
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
                    dom: '<"flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-4"<"flex items-center"l><"flex items-center gap-2"Bf>>rtip',
                    initComplete: function() {
                        var table = this.api();

                        // Apply custom styling after DataTables initialization
                        $('.dataTables_filter input').addClass('ml-2 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary');
                        $('.dataTables_length select').addClass('mx-2 px-2 py-1 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary');
                        $('.dataTables_paginate .paginate_button').addClass('mx-1');

                        // Style the wrapper
                        $('.dataTables_wrapper').addClass('px-0 pb-0');

                        // Initialize Lucide icons in the table
                        if (typeof lucide !== 'undefined') {
                            lucide.createIcons();
                        }

                        // Update summary statistics after data is loaded
                        updateSummaryStats();
                    }
                });

                // Store table reference globally for filter functions
                window.customerBookingTable = customerBookingTable;
            }
        });

        // CRUD Functions for Booking Actions
        function viewDetails(bookingId) {
            window.location.href = '${pageContext.request.contextPath}/customer/booking-details?id=' + bookingId;
        }

        function reschedule(bookingId) {
            if (confirm('Bạn có chắc chắn muốn đổi lịch hẹn #' + bookingId + '?')) {
                window.location.href = '${pageContext.request.contextPath}/customer/reschedule/' + bookingId;
            }
        }

        function cancelBooking(bookingId) {
            if (confirm('Bạn có chắc chắn muốn hủy lịch hẹn #' + bookingId + '? Hành động này không thể hoàn tác.')) {
                var button = event.target.closest('button');
                var originalContent = button.innerHTML;
                button.innerHTML = '<i data-lucide="loader-2" class="h-3 w-3 animate-spin"></i>';
                button.disabled = true;

                const cancelUrl = '${pageContext.request.contextPath}/customer/cancel-booking/' + bookingId;
                console.log('Sending cancel request to:', cancelUrl);

                fetch(cancelUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                .then(function(response) {
                    console.log('Response status:', response.status);
                    console.log('Response headers:', response.headers);
                    if (response.ok) {
                        return response.json();
                    } else {
                        // Try to get error details from response
                        return response.text().then(text => {
                            console.log('Error response body:', text);
                            throw new Error(`HTTP ${response.status}: ${text}`);
                        });
                    }
                })
                .then(function(data) {
                    if (data.success) {
                        if (typeof showBookingNotification === 'function') {
                            showBookingNotification('Hủy lịch hẹn thành công!', 'success');
                        }
                        setTimeout(function() {
                            location.reload();
                        }, 1500);
                    } else {
                        throw new Error(data.message || 'Có lỗi xảy ra');
                    }
                })
                .catch(function(error) {
                    console.error('Error:', error);
                    if (typeof showBookingNotification === 'function') {
                        showBookingNotification('Có lỗi xảy ra khi hủy lịch hẹn: ' + error.message, 'error');
                    }
                    button.innerHTML = originalContent;
                    button.disabled = false;
                    if (typeof lucide !== 'undefined') {
                        lucide.createIcons();
                    }
                });
            }
        }

        function payNow(bookingId) {
            window.location.href = '${pageContext.request.contextPath}/customer/payment?bookingId=' + bookingId;
        }

        console.log('Customer Booking Page Loaded Successfully');
    </script>
</body>
</html>