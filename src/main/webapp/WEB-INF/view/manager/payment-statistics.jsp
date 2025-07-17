<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'primary': '#D4AF37',
                        'spa-cream': '#FFF8F0',
                        'spa-dark': '#2C1810'
                    }
                }
            }
        }
    </script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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

    <!-- Date Range Picker -->
    <script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />

    <style>
        /* Custom styling for statistics dashboard */
        .stat-card {
            transition: all 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        
        .chart-container {
            position: relative;
            height: 400px;
            width: 100%;
        }
        
        .metric-icon {
            background: linear-gradient(135deg, #D4AF37 0%, #B8941F 100%);
        }
        
        /* DataTables styling */
        .dataTables_wrapper {
            font-family: 'Inter', sans-serif;
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
        
        /* Print styles */
        @media print {
            .no-print {
                display: none !important;
            }
            
            .print-only {
                display: block !important;
            }
            
            body {
                background: white !important;
            }
            
            .chart-container {
                height: 300px;
            }
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .chart-container {
                height: 300px;
            }
        }
    </style>
</head>

<body class="bg-spa-cream min-h-screen">
  
    
    <!-- Include Sidebar -->
    <jsp:include page="../common/sidebar.jsp" />
    
    <!-- Main Content -->
    <div class="ml-64 p-8">
        <div class="max-w-7xl mx-auto">
            <!-- Page Header -->
            <div class="mb-8">
                <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between">
                    <div>
                        <h1 class="text-3xl font-bold text-spa-dark mb-2">Thống Kê Thanh Toán</h1>
                        <p class="text-gray-600">Phân tích chi tiết doanh thu và xu hướng thanh toán</p>
                    </div>
                    <div class="mt-4 sm:mt-0 flex gap-3">
                        <button onclick="refreshData()" 
                                class="inline-flex items-center px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary/90 transition-colors">
                            <i data-lucide="refresh-cw" class="h-4 w-4 mr-2"></i>
                            Làm Mới
                        </button>
                        <button onclick="exportReport()" 
                                class="inline-flex items-center px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">
                            <i data-lucide="download" class="h-4 w-4 mr-2"></i>
                            Xuất Báo Cáo
                        </button>
                        <button onclick="printReport()" 
                                class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
                            <i data-lucide="printer" class="h-4 w-4 mr-2"></i>
                            In Báo Cáo
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- Date Range Filter -->
            <div class="bg-white rounded-xl shadow-md p-6 mb-6">
                <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                    <h2 class="text-lg font-semibold text-spa-dark">Bộ Lọc Thời Gian</h2>
                    <div class="flex flex-col sm:flex-row gap-3">
                        <input type="text" id="dateRangePicker" name="daterange" 
                               class="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary"
                               placeholder="Chọn khoảng thời gian" />
                        <button onclick="applyDateFilter()" 
                                class="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary/90 transition-colors">
                            <i data-lucide="filter" class="h-4 w-4 mr-2"></i>
                            Áp Dụng
                        </button>
                        <button onclick="clearDateFilter()" 
                                class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                            <i data-lucide="x" class="h-4 w-4 mr-2"></i>
                            Xóa Bộ Lọc
                        </button>
                    </div>
                </div>
            </div>
            
            <!-- Error/Success Messages -->
            <c:if test="${not empty errorMessage}">
                <div class="mb-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg">
                    <i data-lucide="alert-circle" class="h-5 w-5 inline mr-2"></i>
                    ${errorMessage}
                </div>
            </c:if>
            
            <!-- Overview Statistics Cards -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <!-- Total Revenue Card -->
                <div class="stat-card bg-white rounded-xl shadow-md p-6">
                    <div class="flex items-center">
                        <div class="metric-icon p-3 rounded-full text-white mr-4">
                            <i data-lucide="dollar-sign" class="h-6 w-6"></i>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-600">Tổng Doanh Thu</p>
                            <p class="text-2xl font-bold text-spa-dark">
                                <fmt:formatNumber value="${dateRangeStats.total_revenue}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                            </p>
                            <p class="text-xs text-green-600">
                                <i data-lucide="trending-up" class="h-3 w-3 inline mr-1"></i>
                                +12% so với tháng trước
                            </p>
                        </div>
                    </div>
                </div>
                
                <!-- Total Payments Card -->
                <div class="stat-card bg-white rounded-xl shadow-md p-6">
                    <div class="flex items-center">
                        <div class="metric-icon p-3 rounded-full text-white mr-4">
                            <i data-lucide="credit-card" class="h-6 w-6"></i>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-600">Tổng Giao Dịch</p>
                            <p class="text-2xl font-bold text-spa-dark">${dateRangeStats.total_payments}</p>
                            <p class="text-xs text-blue-600">
                                <i data-lucide="activity" class="h-3 w-3 inline mr-1"></i>
                                ${dateRangeStats.paid_count} thành công
                            </p>
                        </div>
                    </div>
                </div>
                
                <!-- Average Payment Card -->
                <div class="stat-card bg-white rounded-xl shadow-md p-6">
                    <div class="flex items-center">
                        <div class="metric-icon p-3 rounded-full text-white mr-4">
                            <i data-lucide="bar-chart-3" class="h-6 w-6"></i>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-600">Trung Bình/Giao Dịch</p>
                            <p class="text-2xl font-bold text-spa-dark">
                                <fmt:formatNumber value="${dateRangeStats.avg_payment_amount}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                            </p>
                            <p class="text-xs text-purple-600">
                                <i data-lucide="target" class="h-3 w-3 inline mr-1"></i>
                                Mục tiêu: 2M VNĐ
                            </p>
                        </div>
                    </div>
                </div>
                
                <!-- Unique Customers Card -->
                <div class="stat-card bg-white rounded-xl shadow-md p-6">
                    <div class="flex items-center">
                        <div class="metric-icon p-3 rounded-full text-white mr-4">
                            <i data-lucide="users" class="h-6 w-6"></i>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-600">Khách Hàng Duy Nhất</p>
                            <p class="text-2xl font-bold text-spa-dark">${customerStats.unique_customers}</p>
                            <p class="text-xs text-orange-600">
                                <i data-lucide="user-plus" class="h-3 w-3 inline mr-1"></i>
                                +5 khách mới
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Charts Section -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
                <!-- Revenue Trend Chart -->
                <div class="bg-white rounded-xl shadow-md p-6">
                    <h3 class="text-lg font-semibold text-spa-dark mb-4 flex items-center">
                        <i data-lucide="trending-up" class="h-5 w-5 text-primary mr-2"></i>
                        Xu Hướng Doanh Thu Theo Ngày
                    </h3>
                    <div class="chart-container">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
                
                <!-- Payment Methods Chart -->
                <div class="bg-white rounded-xl shadow-md p-6">
                    <h3 class="text-lg font-semibold text-spa-dark mb-4 flex items-center">
                        <i data-lucide="pie-chart" class="h-5 w-5 text-primary mr-2"></i>
                        Phân Bố Phương Thức Thanh Toán
                    </h3>
                    <div class="chart-container">
                        <canvas id="paymentMethodChart"></canvas>
                    </div>
                </div>
            </div>
            
            <!-- Service Revenue Table -->
            <div class="bg-white rounded-xl shadow-md p-6 mb-8">
                <h3 class="text-lg font-semibold text-spa-dark mb-4 flex items-center">
                    <i data-lucide="shopping-bag" class="h-5 w-5 text-primary mr-2"></i>
                    Top Dịch Vụ Theo Doanh Thu
                </h3>
                
                <c:choose>
                    <c:when test="${not empty serviceStats}">
                        <table id="serviceRevenueTable" class="w-full display responsive nowrap" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Dịch vụ</th>
                                    <th>Số lượng bán</th>
                                    <th>Tổng số lần</th>
                                    <th>Doanh thu</th>
                                    <th>% Tổng doanh thu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="service" items="${serviceStats}">
                                    <tr>
                                        <td>
                                            <div class="font-medium text-gray-900">${service.service_name}</div>
                                        </td>
                                        <td>
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                ${service.item_count}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="text-gray-900 font-medium">${service.total_quantity}</span>
                                        </td>
                                        <td>
                                            <span class="text-green-600 font-semibold">
                                                <fmt:formatNumber value="${service.total_revenue}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                                            </span>
                                        </td>
                                        <td>
                                            <div class="flex items-center">
                                                <div class="w-16 bg-gray-200 rounded-full h-2 mr-2">
                                                    <div class="bg-primary h-2 rounded-full" style="width: ${(service.total_revenue / dateRangeStats.total_revenue) * 100}%"></div>
                                                </div>
                                                <span class="text-sm text-gray-600">
                                                    <fmt:formatNumber value="${(service.total_revenue / dateRangeStats.total_revenue) * 100}" maxFractionDigits="1"/>%
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-8">
                            <i data-lucide="inbox" class="h-16 w-16 text-gray-400 mx-auto mb-4"></i>
                            <h3 class="text-lg font-medium text-gray-900 mb-2">Không có dữ liệu</h3>
                            <p class="text-gray-600">Không có dữ liệu doanh thu dịch vụ trong khoảng thời gian này.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    

    <script>
        $(document).ready(function() {
            // Initialize Lucide icons
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }

            // Initialize Date Range Picker
            $('#dateRangePicker').daterangepicker({
                startDate: moment().startOf('month'),
                endDate: moment().endOf('month'),
                locale: {
                    format: 'DD/MM/YYYY',
                    separator: ' - ',
                    applyLabel: 'Áp dụng',
                    cancelLabel: 'Hủy',
                    fromLabel: 'Từ',
                    toLabel: 'Đến',
                    customRangeLabel: 'Tùy chọn',
                    weekLabel: 'T',
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

            // Initialize DataTables
            if ($.fn.DataTable && document.getElementById('serviceRevenueTable')) {
                $('#serviceRevenueTable').DataTable({
                    responsive: true,
                    dom: 'Blfrtip',
                    processing: true,
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
                    order: [[3, 'desc']], // Sort by revenue (column 3) in descending order
                    columnDefs: [
                        {
                            responsivePriority: 1,
                            targets: [0, 3] // Service name and revenue are high priority
                        },
                        {
                            responsivePriority: 2,
                            targets: [1, 2] // Counts are medium priority
                        },
                        {
                            responsivePriority: 3,
                            targets: [4] // Percentage is low priority
                        }
                    ],
                    pageLength: 10,
                    lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "Tất cả"]],
                    buttons: [
                        {
                            extend: 'excelHtml5',
                            text: '<i data-lucide="file-spreadsheet" class="h-4 w-4 mr-1"></i> Xuất Excel',
                            className: 'bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded',
                            title: 'Thống kê doanh thu dịch vụ - BeautyZone Spa'
                        },
                        {
                            extend: 'print',
                            text: '<i data-lucide="printer" class="h-4 w-4 mr-1"></i> In báo cáo',
                            className: 'bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded ml-2',
                            title: 'Thống kê doanh thu dịch vụ - BeautyZone Spa'
                        }
                    ],
                    dom: '<"flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-4"<"flex items-center"l><"flex items-center"Bf>>rtip',

                    initComplete: function() {
                        // Apply custom styling after DataTables initialization
                        $('.dataTables_filter input').addClass('ml-2 px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary');
                        $('.dataTables_length select').addClass('mx-2 px-2 py-1 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary');
                        $('.dataTables_paginate .paginate_button').addClass('mx-1');

                        // Style the wrapper
                        $('.dataTables_wrapper').addClass('px-0 pb-0');

                        // Initialize Lucide icons in the table
                        lucide.createIcons();

                        console.log('Service revenue DataTable initialized successfully');
                    }
                });
            }

            // Initialize Charts
            initializeCharts();
        });

        // Chart initialization
        function initializeCharts() {
            // Revenue Trend Chart
            const revenueCtx = document.getElementById('revenueChart');
            if (revenueCtx) {
                const dailyData = [
                    <c:forEach var="day" items="${dailyStats}" varStatus="status">
                        {
                            date: '${day.date}',
                            revenue: ${day.revenue != null ? day.revenue : 0}
                        }<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ];

                new Chart(revenueCtx, {
                    type: 'line',
                    data: {
                        labels: dailyData.map(d => {
                            const date = new Date(d.date);
                            return date.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit' });
                        }),
                        datasets: [{
                            label: 'Doanh thu (VNĐ)',
                            data: dailyData.map(d => d.revenue),
                            borderColor: '#D4AF37',
                            backgroundColor: 'rgba(212, 175, 55, 0.1)',
                            borderWidth: 3,
                            fill: true,
                            tension: 0.4
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: false
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function(value) {
                                        return new Intl.NumberFormat('vi-VN').format(value) + ' VNĐ';
                                    }
                                }
                            }
                        },
                        elements: {
                            point: {
                                radius: 4,
                                hoverRadius: 6
                            }
                        }
                    }
                });
            }

            // Payment Methods Chart
            const methodCtx = document.getElementById('paymentMethodChart');
            if (methodCtx) {
                const methodData = [];
                const methodLabels = [];
                const methodColors = ['#D4AF37', '#B8941F', '#8B7355', '#6B5B73', '#4A5568', '#2D3748'];

                <c:forEach var="method" items="${methodStats}">
                    methodLabels.push('${method.key}');
                    methodData.push(${method.value.percentage != null ? method.value.percentage : 0});
                </c:forEach>

                new Chart(methodCtx, {
                    type: 'doughnut',
                    data: {
                        labels: methodLabels,
                        datasets: [{
                            data: methodData,
                            backgroundColor: methodColors,
                            borderWidth: 2,
                            borderColor: '#ffffff'
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {
                                    padding: 20,
                                    usePointStyle: true
                                }
                            }
                        }
                    }
                });
            }
        }

        // Filter Functions
        function applyDateFilter() {
            const dateRange = $('#dateRangePicker').val();
            if (dateRange) {
                const dates = dateRange.split(' - ');
                const startDate = moment(dates[0], 'DD/MM/YYYY').format('YYYY-MM-DD');
                const endDate = moment(dates[1], 'DD/MM/YYYY').format('YYYY-MM-DD');

                // Redirect with date parameters
                window.location.href = '${pageContext.request.contextPath}/manager/payment-statistics?startDate=' + startDate + '&endDate=' + endDate;
            }
        }

        function clearDateFilter() {
            // Redirect without date parameters
            window.location.href = '${pageContext.request.contextPath}/manager/payment-statistics';
        }

        function refreshData() {
            // Reload the current page
            window.location.reload();
        }

        function exportReport() {
            // Trigger Excel export for the service revenue table
            const table = $('#serviceRevenueTable').DataTable();
            table.button('.buttons-excel').trigger();
        }

        function printReport() {
            // Print the entire page
            window.print();
        }

        // Utility Functions
        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN').format(amount) + ' VNĐ';
        }

        function formatPercentage(value) {
            return parseFloat(value).toFixed(1) + '%';
        }

        // Auto-refresh data every 5 minutes (optional)
        setInterval(function() {
            // Only refresh if user is active (has interacted in last 5 minutes)
            const lastActivity = localStorage.getItem('lastActivity');
            const now = Date.now();

            if (!lastActivity || (now - parseInt(lastActivity)) < 300000) { // 5 minutes
                console.log('Auto-refreshing payment statistics...');
                refreshData();
            }
        }, 300000); // 5 minutes

        // Track user activity for auto-refresh
        $(document).on('click keypress scroll', function() {
            localStorage.setItem('lastActivity', Date.now());
        });
    </script>
</body>
</html>
