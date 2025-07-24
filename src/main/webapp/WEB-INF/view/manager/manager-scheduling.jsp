<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Lịch Hẹn - Spa Hương Sen</title>

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

    <!-- Date Range Picker -->
    <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />

    <style>
        /* Loading animation */
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .animate-spin {
            animation: spin 1s linear infinite;
        }

        /* Custom DataTables styling */
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

        /* Priority badge styling */
        .priority-high {
            background-color: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        .priority-medium {
            background-color: #fffbeb;
            color: #d97706;
            border: 1px solid #fed7aa;
        }

        .priority-low {
            background-color: #f0fdf4;
            color: #16a34a;
            border: 1px solid #bbf7d0;
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
        <div class="p-6">
            <!-- Statistics Row -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
                <div>
                    <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6 hover:shadow-lg transition-shadow duration-200">
                        <div class="flex items-center justify-between">
                            <div>
                                <div class="text-2xl font-bold text-primary" id="totalServicesRemaining">
                                    <c:out value="${statistics.totalServicesRemaining}" default="0"/>
                                </div>
                                <div class="text-sm text-gray-600 font-medium">Dịch vụ chưa đặt lịch</div>
                            </div>
                            <div class="w-12 h-12 bg-primary/10 rounded-lg flex items-center justify-center">
                                <i data-lucide="calendar-clock" class="h-6 w-6 text-primary"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6 hover:shadow-lg transition-shadow duration-200">
                        <div class="flex items-center justify-between">
                            <div>
                                <div class="text-2xl font-bold text-primary" id="totalCustomersWithUnscheduled">
                                    <c:out value="${statistics.totalCustomersWithUnscheduled}" default="0"/>
                                </div>
                                <div class="text-sm text-gray-600 font-medium">Khách hàng cần đặt lịch</div>
                            </div>
                            <div class="w-12 h-12 bg-primary/10 rounded-lg flex items-center justify-center">
                                <i data-lucide="users" class="h-6 w-6 text-primary"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6 hover:shadow-lg transition-shadow duration-200">
                        <div class="flex items-center justify-between">
                            <div>
                                <div class="text-2xl font-bold text-primary" id="totalPaidPayments">
                                    <c:out value="${statistics.totalPaidPayments}" default="0"/>
                                </div>
                                <div class="text-sm text-gray-600 font-medium">Thanh toán đã xác nhận</div>
                            </div>
                            <div class="w-12 h-12 bg-primary/10 rounded-lg flex items-center justify-center">
                                <i data-lucide="credit-card" class="h-6 w-6 text-primary"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6 hover:shadow-lg transition-shadow duration-200">
                        <div class="flex items-center justify-between">
                            <div>
                                <div class="text-2xl font-bold text-primary" id="itemsWithRemaining">
                                    <c:out value="${statistics.itemsWithRemaining}" default="0"/>
                                </div>
                                <div class="text-sm text-gray-600 font-medium">Mục cần xử lý</div>
                            </div>
                            <div class="w-12 h-12 bg-primary/10 rounded-lg flex items-center justify-center">
                                <i data-lucide="list-checks" class="h-6 w-6 text-primary"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Schedulable Items Table -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden">
                <div class="p-6 border-b border-gray-200 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                    <div>
                        <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                            <i data-lucide="calendar-plus" class="h-6 w-6 text-primary"></i>
                            Quản lý lịch hẹn dịch vụ
                        </h2>
                        <p class="text-gray-600 mt-2">Đặt lịch cho các dịch vụ đã thanh toán</p>
                    </div>
                    
                    <div class="flex flex-wrap items-center gap-3">
                        <!-- Filter Toggle Button -->
                        <button id="toggleSchedulingFilters" class="inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                            <i data-lucide="filter" class="h-4 w-4 mr-2"></i>
                            Bộ lọc
                        </button>
                        
                        <!-- Date Range Picker -->
                        <div class="relative">
                            <input type="text" id="schedulingDateRangePicker" class="px-4 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" placeholder="Chọn khoảng thời gian" readonly />
                        </div>
                        
                        <!-- Refresh Button -->
                        <button id="refreshSchedulingData" class="inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-primary rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary/20">
                            <i data-lucide="refresh-cw" class="h-4 w-4 mr-2"></i>
                            Làm mới
                        </button>
                    </div>
                </div>

                <!-- Filter Panel -->
                <div id="schedulingFilterPanel" class="filter-panel px-6 py-0 border-b border-gray-200 bg-spa-gray/30">
                    <div class="py-4 grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-4">
                        <!-- Customer Filter -->
                        <div>
                            <label for="schedulingCustomerFilter" class="block text-sm font-medium text-gray-700 mb-1">Khách hàng</label>
                            <select id="schedulingCustomerFilter" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                <option value="">Tất cả khách hàng</option>
                                <c:forEach var="customer" items="${customers}">
                                    <option value="${customer.fullName}">${customer.fullName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <!-- Service Filter -->
                        <div>
                            <label for="schedulingServiceFilter" class="block text-sm font-medium text-gray-700 mb-1">Dịch vụ</label>
                            <select id="schedulingServiceFilter" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                <option value="">Tất cả dịch vụ</option>
                                <c:forEach var="service" items="${services}">
                                    <option value="${service.serviceName}">${service.serviceName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <!-- Priority Filter -->
                        <div>
                            <label for="schedulingPriorityFilter" class="block text-sm font-medium text-gray-700 mb-1">Ưu tiên</label>
                            <select id="schedulingPriorityFilter" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                <option value="">Tất cả mức độ</option>
                                <option value="HIGH">Cao</option>
                                <option value="MEDIUM">Trung bình</option>
                                <option value="LOW">Thấp</option>
                            </select>
                        </div>
                        
                        <!-- Status Filter -->
                        <div>
                            <label for="schedulingStatusFilter" class="block text-sm font-medium text-gray-700 mb-1">Trạng thái</label>
                            <select id="schedulingStatusFilter" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                <option value="">Tất cả trạng thái</option>
                                <option value="PENDING">Chờ đặt lịch</option>
                                <option value="SCHEDULED">Đã đặt lịch</option>
                                <option value="COMPLETED">Hoàn thành</option>
                                <option value="CANCELLED">Đã hủy</option>
                            </select>
                        </div>
                        
                        <!-- Remaining Quantity Filter -->
                        <div>
                            <label for="schedulingQuantityFilter" class="block text-sm font-medium text-gray-700 mb-1">Số lượng còn lại</label>
                            <div class="flex items-center gap-2">
                                <input type="number" id="minQuantity" placeholder="Từ" min="0" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                <span>-</span>
                                <input type="number" id="maxQuantity" placeholder="Đến" min="0" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>
                        </div>
                        
                        <!-- Payment Date Filter -->
                        <div>
                            <label for="schedulingPaymentDateFilter" class="block text-sm font-medium text-gray-700 mb-1">Ngày thanh toán</label>
                            <select id="schedulingPaymentDateFilter" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                <option value="">Tất cả thời gian</option>
                                <option value="today">Hôm nay</option>
                                <option value="yesterday">Hôm qua</option>
                                <option value="this_week">Tuần này</option>
                                <option value="last_week">Tuần trước</option>
                                <option value="this_month">Tháng này</option>
                                <option value="last_month">Tháng trước</option>
                            </select>
                        </div>
                        
                        <!-- Urgency Filter -->
                        <div>
                            <label for="schedulingUrgencyFilter" class="block text-sm font-medium text-gray-700 mb-1">Độ khẩn cấp</label>
                            <select id="schedulingUrgencyFilter" class="w-full px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                <option value="">Tất cả</option>
                                <option value="urgent">Khẩn cấp (>7 ngày)</option>
                                <option value="normal">Bình thường (3-7 ngày)</option>
                                <option value="low">Không khẩn cấp (<3 ngày)</option>
                            </select>
                        </div>
                    </div>
                    
                    <!-- Filter Actions -->
                    <div class="flex justify-end py-3 gap-3 border-t border-gray-200">
                        <button id="resetSchedulingFilters" class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                            Đặt lại
                        </button>
                        <button id="applySchedulingFilters" class="px-4 py-2 text-sm font-medium text-white bg-primary rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary/20">
                            Áp dụng
                        </button>
                    </div>
                </div>

                <div class="p-6">
                    <table id="schedulingTable" class="w-full display responsive nowrap" style="width:100%">
                        <thead>
                            <tr>
                                <th>Khách hàng</th>
                                <th>Dịch vụ</th>
                                <th>Số lượng còn lại</th>
                                <th>Ngày thanh toán</th>
                                <th>Ưu tiên</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody id="schedulingTableBody">
                            <!-- Data will be loaded dynamically -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>


    </main>

    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>

    <!-- JavaScript -->
    <script>
        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }

        // Global variables
        let currentCalendarDate = new Date();
        let selectedDate = null;
        let currentBookingData = null;

        // Dropdown functionality
        document.addEventListener('DOMContentLoaded', function() {
            // Toggle dropdowns
            document.querySelectorAll('.dropdown-toggle').forEach(function(item) {
                item.addEventListener('click', function(e) {
                    e.preventDefault();
                    const dropdown = item.closest('.dropdown');
                    const menu = dropdown.querySelector('.dropdown-menu');
                    document.querySelectorAll('.dropdown-menu').forEach(function(otherMenu) {
                        if (otherMenu !== menu) {
                            otherMenu.classList.add('hidden');
                        }
                    });
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

            // Initialize filter functionality
            initializeSchedulingFilters();

            // Note: Filter toggle, apply, and reset functionality is handled by manager-scheduling.js
            // to avoid conflicts and ensure proper integration with the ManagerSchedulingSystem class
        });

        // Initialize scheduling filters
        function initializeSchedulingFilters() {
            const dateRangePicker = document.getElementById('schedulingDateRangePicker');
            if (dateRangePicker && typeof $ !== 'undefined' && $.fn.daterangepicker) {
                $(dateRangePicker).daterangepicker({
                    autoUpdateInput: false,
                    locale: {
                        cancelLabel: 'Xóa',
                        applyLabel: 'Áp dụng',
                        format: 'DD/MM/YYYY',
                        separator: ' - ',
                        customRangeLabel: 'Tùy chọn',
                        daysOfWeek: ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'],
                        monthNames: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
                                   'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'],
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

                $(dateRangePicker).on('apply.daterangepicker', function(ev, picker) {
                    $(this).val(picker.startDate.format('DD/MM/YYYY') + ' - ' + picker.endDate.format('DD/MM/YYYY'));
                });

                $(dateRangePicker).on('cancel.daterangepicker', function(ev, picker) {
                    $(this).val('');
                });
            }

            // Refresh data button
            const refreshButton = document.getElementById('refreshSchedulingData');
            if (refreshButton) {
                refreshButton.addEventListener('click', refreshSchedulingData);
            }
        }

        // Filter functions are now handled by manager-scheduling.js
        // This prevents conflicts and ensures proper integration

        // Simple filter toggle function - standalone implementation
        function toggleFilterPanel() {
            const filterPanel = document.getElementById('schedulingFilterPanel');
            const toggleButton = document.getElementById('toggleSchedulingFilters');
            
            if (filterPanel && toggleButton) {
                console.log('Toggling filter panel');
                filterPanel.classList.toggle('show');
                
                // Update button appearance
                const icon = toggleButton.querySelector('i[data-lucide="filter"]');
                
                if (filterPanel.classList.contains('show')) {
                    console.log('Showing filter panel');
                    toggleButton.classList.add('bg-primary', 'text-white');
                    toggleButton.classList.remove('bg-white', 'text-gray-700', 'border-gray-300');
                } else {
                    console.log('Hiding filter panel');
                    toggleButton.classList.remove('bg-primary', 'text-white');
                    toggleButton.classList.add('bg-white', 'text-gray-700', 'border-gray-300');
                }
                
                // Recreate lucide icons
                if (typeof lucide !== 'undefined') {
                    lucide.createIcons();
                }
            }
        }

        // Simple filter functions
        function applyFilters() {
            console.log('Applying filters...');
            // Add your filter logic here
            showSimpleNotification('Đã áp dụng bộ lọc', 'success');
        }

        function resetFilters() {
            console.log('Resetting filters...');
            
            // Reset all filter inputs
            const filterInputs = [
                'schedulingCustomerFilter',
                'schedulingServiceFilter', 
                'schedulingPriorityFilter',
                'schedulingStatusFilter',
                'minQuantity',
                'maxQuantity',
                'schedulingPaymentDateFilter',
                'schedulingUrgencyFilter',
                'schedulingDateRangePicker'
            ];

            filterInputs.forEach(id => {
                const element = document.getElementById(id);
                if (element) {
                    element.value = '';
                }
            });

            showSimpleNotification('Đã đặt lại bộ lọc', 'info');
        }

        function refreshData() {
            console.log('Refreshing data...');
            const refreshButton = document.getElementById('refreshSchedulingData');
            
            if (refreshButton) {
                const originalText = refreshButton.innerHTML;
                refreshButton.innerHTML = '<i data-lucide="loader-2" class="h-4 w-4 mr-2 animate-spin"></i>Đang tải...';
                refreshButton.disabled = true;

                // Simulate refresh
                setTimeout(() => {
                    refreshButton.innerHTML = originalText;
                    refreshButton.disabled = false;
                    if (typeof lucide !== 'undefined') {
                        lucide.createIcons();
                    }
                    showSimpleNotification('Đã làm mới dữ liệu', 'success');
                }, 1000);
            }
        }

        // Simple notification function
        function showSimpleNotification(message, type = 'info') {
            const notification = document.createElement('div');
            notification.className = `fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg max-w-sm transition-all duration-300`;
            
            const colors = {
                success: 'bg-green-500 text-white',
                error: 'bg-red-500 text-white',
                warning: 'bg-yellow-500 text-white',
                info: 'bg-blue-500 text-white'
            };
            
            notification.className += ' ' + (colors[type] || colors.info);
            notification.innerHTML = `
                <div class="flex items-center gap-2">
                    <span>${message}</span>
                </div>
            `;
            
            document.body.appendChild(notification);
            
            // Auto remove after 3 seconds
            setTimeout(() => {
                notification.remove();
            }, 3000);
        }

        // Initialize when DOM is ready
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded, setting up filter functionality');
            
            // Setup filter toggle button
            const toggleButton = document.getElementById('toggleSchedulingFilters');
            if (toggleButton) {
                console.log('Found toggle button, adding event listener');
                toggleButton.addEventListener('click', function(e) {
                    e.preventDefault();
                    toggleFilterPanel();
                });
            } else {
                console.error('Toggle button not found!');
            }

            // Setup apply filter button
            const applyButton = document.getElementById('applySchedulingFilters');
            if (applyButton) {
                applyButton.addEventListener('click', function(e) {
                    e.preventDefault();
                    applyFilters();
                });
            }

            // Setup reset filter button
            const resetButton = document.getElementById('resetSchedulingFilters');
            if (resetButton) {
                resetButton.addEventListener('click', function(e) {
                    e.preventDefault();
                    resetFilters();
                });
            }

            // Setup refresh button
            const refreshButton = document.getElementById('refreshSchedulingData');
            if (refreshButton) {
                refreshButton.addEventListener('click', function(e) {
                    e.preventDefault();
                    refreshData();
                });
            }

            // Initialize Lucide icons
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        });

        // Set context path for JavaScript
        window.contextPath = '${pageContext.request.contextPath}';
        console.log('[DEBUG] Context path set to:', window.contextPath);

        // Define openSchedulingModal function immediately to prevent ReferenceError
        function openSchedulingModal(paymentItemId) {
            console.log('openSchedulingModal called with paymentItemId:', paymentItemId);
            const contextPath = '${pageContext.request.contextPath}';
            const url = contextPath + '/manager/schedule-booking?paymentItemId=' + paymentItemId;
            console.log('Redirecting to:', url);
            window.location.href = url;
        }

        // Also define other functions that might be called from onclick handlers
        function refreshSchedulableItems() {
            if (window.managerSchedulingSystem) {
                window.managerSchedulingSystem.refreshSchedulableItems();
            }
        }
    </script>

    <!-- Manager Scheduling JavaScript -->
    <script src="${pageContext.request.contextPath}/js/manager-scheduling.js"></script>
</body>
</html>