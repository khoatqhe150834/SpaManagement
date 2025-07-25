<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý đặt lịch - Spa Hương Sen</title>

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

    <!-- Manager Booking JS -->
    <script src="${pageContext.request.contextPath}/js/manager-booking.js?v=<%= System.currentTimeMillis() %>"></script>
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
        .manager-booking-filter-panel {
            transition: max-height 0.3s ease-in-out, opacity 0.3s ease-in-out;
            max-height: 0;
            opacity: 0;
            overflow: hidden;
        }

        .manager-booking-filter-panel.show {
            max-height: 500px;
            opacity: 1;
        }

        #toggleManagerBookingFilters i {
            transition: transform 0.3s ease;
        }

        #toggleManagerBookingFilters i.rotate-180 {
            transform: rotate(180deg);
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
                            Quản lý đặt lịch
                        </h2>

                        <div class="flex flex-wrap items-center gap-3">
                            <!-- Filter Toggle Button -->
                            <button id="toggleManagerBookingFilters" class="inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                                <i data-lucide="filter" class="h-4 w-4 mr-2"></i>
                                Bộ lọc
                            </button>
                        </div>
                    </div>
                </div>
                <!-- Filter Panel -->
                <div id="managerBookingFilterPanel" class="manager-booking-filter-panel px-6 py-0 border-b border-gray-200 bg-gray-50">
                    <div class="p-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                            <!-- Date From -->
                            <div>
                                <label for="startDateFilter" class="block text-sm font-medium text-gray-700 mb-2">Từ ngày</label>
                                <input type="date" id="startDateFilter"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>

                            <!-- Date To -->
                            <div>
                                <label for="endDateFilter" class="block text-sm font-medium text-gray-700 mb-2">Đến ngày</label>
                                <input type="date" id="endDateFilter"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>

                            <!-- Therapist Filter -->
                            <div>
                                <label for="therapistFilter" class="block text-sm font-medium text-gray-700 mb-2">Nhân viên</label>
                                <select id="therapistFilter" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                    <option value="">Tất cả nhân viên</option>
                                    <c:forEach items="${therapists}" var="therapist">
                                        <option value="${therapist.userId}">${therapist.fullName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Status Filter -->
                            <div>
                                <label for="statusFilterMgr" class="block text-sm font-medium text-gray-700 mb-2">Trạng thái</label>
                                <select id="statusFilterMgr" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="SCHEDULED">Đã lên lịch</option>
                                    <option value="CONFIRMED">Đã xác nhận</option>
                                    <option value="IN_PROGRESS">Đang thực hiện</option>
                                    <option value="COMPLETED">Hoàn thành</option>
                                    <option value="CANCELLED">Đã hủy</option>
                                    <option value="NO_SHOW">Không đến</option>
                                </select>
                            </div>
                        </div>

                        <!-- Second Row -->
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mt-4">
                            <!-- Service Type Filter -->
                            <div>
                                <label for="serviceTypeFilter" class="block text-sm font-medium text-gray-700 mb-2">Loại dịch vụ</label>
                                <select id="serviceTypeFilter" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                    <option value="">Tất cả loại dịch vụ</option>
                                    <c:forEach items="${serviceTypes}" var="serviceType">
                                        <option value="${serviceType.serviceTypeId}">${serviceType.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Customer Search -->
                            <div>
                                <label for="customerFilter" class="block text-sm font-medium text-gray-700 mb-2">Khách hàng</label>
                                <input type="text" id="customerFilter" placeholder="Tên khách hàng"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>

                            <!-- Booking ID Search -->
                            <div>
                                <label for="bookingIdFilter" class="block text-sm font-medium text-gray-700 mb-2">Mã đặt lịch</label>
                                <input type="text" id="bookingIdFilter" placeholder="Nhập mã đặt lịch"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>
                        </div>
                    </div>

                    <!-- Filter Actions -->
                    <div class="flex justify-end py-3 px-6 gap-3 border-t border-gray-200">
                        <button id="resetFilters" class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                            Đặt lại
                        </button>
                        <button id="applyFilters" class="px-4 py-2 text-sm font-medium text-white bg-primary rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary/20">
                            Áp dụng
                        </button>
                    </div>
                </div>

                <div class="p-6">
                    <table id="managerBookingsTable" class="w-full display responsive nowrap" style="width:100%">
                        <thead>
                            <tr>
                                <th>Mã đặt lịch</th>
                                <th>Khách hàng</th>
                                <th>Nhân viên</th>
                                <th>Dịch vụ</th>
                                <th>Ngày & Giờ</th>
                                <th>Phòng</th>
                                <th>Doanh thu</th>
                                <th>Thanh toán</th>
                                <th>Trạng thái</th>
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

            // Initialize filter functionality
            setTimeout(function() {
                if (typeof initializeManagerBookingFilters === 'function') {
                    initializeManagerBookingFilters();
                } else {
                    console.error('initializeManagerBookingFilters function not found');
                }
            }, 100);
        });
    </script>

    <script>
        $(document).ready(function() {
            // Initialize Manager Booking DataTable
            if ($.fn.DataTable && document.getElementById('managerBookingsTable')) {
                var table = $('#managerBookingsTable').DataTable({
                    responsive: true,
                    dom: 'Blfrtip',
                    processing: true,
                    serverSide: true,
                    searching: false,
                    ajax: {
                        url: '${pageContext.request.contextPath}/manager/show-bookings?action=data',
                        type: 'GET',
                        data: function(d) {
                            // Add custom filter parameters
                            d.startDate = $('#startDateFilter').val() || '';
                            d.endDate = $('#endDateFilter').val() || '';
                            d.therapistId = $('#therapistFilter').val() || '';
                            d.status = $('#statusFilterMgr').val() || '';
                            d.serviceTypeId = $('#serviceTypeFilter').val() || '';
                            d.customerFilter = $('#customerFilter').val() || '';
                            d.bookingIdFilter = $('#bookingIdFilter').val() || '';

                            console.log('Sending DataTable parameters:', d);
                        },
                        dataSrc: function(json) {
                            console.log('Received manager booking data:', json);
                            return json.data;
                        },
                        error: function(xhr, error, code) {
                            console.log('Manager Booking DataTables AJAX error:', error);
                            console.log('Response text:', xhr.responseText);
                        }
                    },
                columns: [
                    {
                        data: 'bookingId',
                        title: 'Mã đặt lịch',
                        render: function(data, type, row) {
                            if (type === 'sort' || type === 'type') {
                                return data;
                            }
                            return '<span class="font-semibold text-primary">#BK' + data.toString().padStart(3, '0') + '</span>';
                        }
                    },
                    {
                        data: 'customerName',
                        title: 'Khách hàng',
                        render: function(data, type, row) {
                            if (type === 'sort' || type === 'type') {
                                return data;
                            }
                            return '<div class="font-medium text-spa-dark">' + data + '</div>' +
                                   '<div class="text-sm text-gray-500">' + (row.customerPhone || '') + '</div>';
                        }
                    },
                    {
                        data: 'therapistName',
                        title: 'Nhân viên',
                        render: function(data, type, row) {
                            if (type === 'sort' || type === 'type') {
                                return data;
                            }
                            return '<span class="font-medium text-spa-dark">' + data + '</span>';
                        }
                    },
                    {
                        data: 'serviceName',
                        title: 'Dịch vụ',
                        render: function(data, type, row) {
                            if (type === 'sort' || type === 'type') {
                                return data;
                            }
                            return '<span class="font-medium text-spa-dark">' + data + '</span>';
                        }
                    },
                    {
                        data: null,
                        title: 'Ngày & Giờ',
                        render: function(data, type, row) {
                            if (type === 'sort' || type === 'type') {
                                return row.appointmentDate + ' ' + row.appointmentTime;
                            }
                            var date = new Date(row.appointmentDate);
                            return '<div class="font-medium text-spa-dark">' + date.toLocaleDateString('vi-VN') + '</div>' +
                                   '<div class="text-sm text-gray-500">' + row.appointmentTime + '</div>';
                        }
                    },
                    {
                        data: 'roomName',
                        title: 'Phòng',
                        render: function(data, type, row) {
                            if (type === 'sort' || type === 'type') {
                                return data;
                            }
                            return '<span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">' + data + '</span>';
                        }
                    },
                    {
                        data: 'totalAmount',
                        title: 'Doanh thu',
                        render: function(data, type, row) {
                            if (type === 'sort' || type === 'type') {
                                return parseFloat(data);
                            }
                            return '<span class="font-semibold text-green-600">' +
                                   new Intl.NumberFormat('vi-VN', {
                                       style: 'currency',
                                       currency: 'VND'
                                   }).format(data) + '</span>';
                        }
                    },
                    {
                        data: 'paymentStatus',
                        title: 'Thanh toán',
                        render: function(data, type, row) {
                            if (type === 'sort' || type === 'type') {
                                return data;
                            }
                            var statusClass = '';
                            var statusText = '';

                            switch(data) {
                                case 'PAID':
                                    statusClass = 'bg-green-100 text-green-800';
                                    statusText = 'Đã thanh toán';
                                    break;
                                case 'PENDING':
                                    statusClass = 'bg-yellow-100 text-yellow-800';
                                    statusText = 'Chờ thanh toán';
                                    break;
                                case 'FAILED':
                                    statusClass = 'bg-red-100 text-red-800';
                                    statusText = 'Thất bại';
                                    break;
                                default:
                                    statusClass = 'bg-gray-100 text-gray-800';
                                    statusText = data;
                            }

                            return '<span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ' + statusClass + '">' + statusText + '</span>';
                        }
                    },
                    {
                        data: 'bookingStatus',
                        title: 'Trạng thái',
                        render: function(data, type, row) {
                            if (type === 'sort' || type === 'type') {
                                return data;
                            }
                            var statusClass = '';
                            var statusText = '';

                            switch(data) {
                                case 'SCHEDULED':
                                    statusClass = 'bg-blue-100 text-blue-800';
                                    statusText = 'Đã lên lịch';
                                    break;
                                case 'CONFIRMED':
                                    statusClass = 'bg-green-100 text-green-800';
                                    statusText = 'Đã xác nhận';
                                    break;
                                case 'IN_PROGRESS':
                                    statusClass = 'bg-yellow-100 text-yellow-800';
                                    statusText = 'Đang thực hiện';
                                    break;
                                case 'COMPLETED':
                                    statusClass = 'bg-emerald-100 text-emerald-800';
                                    statusText = 'Hoàn thành';
                                    break;
                                case 'CANCELLED':
                                    statusClass = 'bg-red-100 text-red-800';
                                    statusText = 'Đã hủy';
                                    break;
                                case 'NO_SHOW':
                                    statusClass = 'bg-gray-100 text-gray-800';
                                    statusText = 'Không đến';
                                    break;
                                default:
                                    statusClass = 'bg-gray-100 text-gray-800';
                                    statusText = data;
                            }

                            return '<span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ' + statusClass + '" data-status="' + data + '">' + statusText + '</span>';
                        }
                    },
                    {
                        data: null,
                        title: 'Thao tác',
                        orderable: false,
                        render: function(data, type, row) {
                            if (type === 'sort' || type === 'type') {
                                return '';
                            }
                            return '<div class="flex items-center gap-2">' +
                                   '<button onclick="viewManagerBookingDetails(' + row.bookingId + ')" class="inline-flex items-center px-2 py-1 text-xs font-medium text-blue-600 bg-blue-50 rounded-md hover:bg-blue-100 transition-colors duration-200" title="Xem chi tiết">' +
                                   '<i data-lucide="eye" class="h-3 w-3 mr-1"></i>Xem</button>' +
                                   '<button onclick="reassignManagerBooking(' + row.bookingId + ')" class="inline-flex items-center px-2 py-1 text-xs font-medium text-orange-600 bg-orange-50 rounded-md hover:bg-orange-100 transition-colors duration-200" title="Phân công lại">' +
                                   '<i data-lucide="user-check" class="h-3 w-3 mr-1"></i>Phân công</button>' +
                                   '<button onclick="editManagerBooking(' + row.bookingId + ')" class="inline-flex items-center px-2 py-1 text-xs font-medium text-gray-600 bg-gray-50 rounded-md hover:bg-gray-100 transition-colors duration-200" title="Chỉnh sửa">' +
                                   '<i data-lucide="edit" class="h-3 w-3 mr-1"></i>Sửa</button>' +
                                   '</div>';
                        }
                    }
                ],
                order: [[4, 'desc']],
                pageLength: 25,
                buttons: [
                    {
                        extend: 'excel',
                        text: '<i data-lucide="download" class="h-4 w-4 mr-2"></i>Xuất Excel',
                        className: 'bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-md text-sm font-medium'
                    }
                ],
                language: {
                    processing: "Đang tải dữ liệu...",
                    emptyTable: "Không có dữ liệu đặt lịch",
                    info: "Hiển thị _START_ đến _END_ của _TOTAL_ đặt lịch",
                    infoEmpty: "Hiển thị 0 đến 0 của 0 đặt lịch",
                    infoFiltered: "(lọc từ _MAX_ tổng số đặt lịch)",
                    search: "Tìm kiếm:",
                    lengthMenu: "Hiển thị _MENU_ mục",
                    paginate: {
                        first: "Đầu",
                        last: "Cuối",
                        next: "Tiếp",
                        previous: "Trước"
                    }
                },
                initComplete: function() {
                    // Re-initialize Lucide icons after DataTable renders
                    if (typeof lucide !== 'undefined') {
                        lucide.createIcons();
                    }
                }
            });

            // Store table reference globally for filter functions
            window.managerBookingTable = table;

            // Filter toggle functionality
            $('#toggleManagerBookingFilters').on('click', function() {
                const panel = $('#managerBookingFilterPanel');
                const icon = $(this).find('i');

                panel.toggleClass('show');
                icon.toggleClass('rotate-180');
            });

            // Filter functionality
            $('#applyFilters').on('click', function() {
                table.draw();
            });

            $('#resetFilters').on('click', function() {
                $('#startDateFilter, #endDateFilter, #customerFilter, #bookingIdFilter').val('');
                $('#therapistFilter, #statusFilterMgr, #serviceTypeFilter').val('');
                table.draw();
            });
            }
        });

        // Action Functions for Manager Booking Management
        function viewManagerBookingDetails(bookingId) {
            window.location.href = '${pageContext.request.contextPath}/manager/booking-details?id=' + bookingId;
        }

        function reassignManagerBooking(bookingId) {
            if (confirm('Bạn có chắc chắn muốn phân công lại đặt lịch #' + bookingId + '?')) {
                // Implementation for reassigning therapist
                console.log('Reassigning booking:', bookingId);
            }
        }

        function editManagerBooking(bookingId) {
            window.location.href = '${pageContext.request.contextPath}/manager/booking-edit?id=' + bookingId;
        }

        console.log('Manager Booking Page Loaded Successfully');
    </script>
</body>
</html>