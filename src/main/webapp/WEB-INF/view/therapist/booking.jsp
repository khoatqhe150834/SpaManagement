<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lịch làm việc của tôi - Spa Hương Sen</title>

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

    <!-- Therapist Booking JS -->
    <script src="${pageContext.request.contextPath}/js/therapist-booking.js?v=<%= System.currentTimeMillis() %>"></script>
<    <style>
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
        .therapist-booking-filter-panel {
            transition: max-height 0.3s ease-in-out, opacity 0.3s ease-in-out;
            max-height: 0;
            opacity: 0;
            overflow: hidden;
        }

        .therapist-booking-filter-panel.show {
            max-height: 500px;
            opacity: 1;
        }

        #toggleTherapistBookingFilters i {
            transition: transform 0.3s ease;
        }

        #toggleTherapistBookingFilters i.rotate-180 {
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
                                <img class="w-8 h-8 rounded-full object-cover" src="https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=100" alt="Therapist Avatar"/>
                                <div class="top-0 left-7 absolute w-3 h-3 bg-green-400 border-2 border-white rounded-full animate-ping"></div>
                                <div class="top-0 left-7 absolute w-3 h-3 bg-green-500 border-2 border-white rounded-full"></div>
                            </div>
                        </div>
                        <div class="p-2 md:block text-left">
                            <h2 class="text-sm font-semibold text-spa-dark">${sessionScope.user.fullName}</h2>
                            <p class="text-xs text-primary/70">Nhân viên trị liệu</p>
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
                            Lịch làm việc của tôi
                        </h2>

                        <div class="flex flex-wrap items-center gap-3">
                            <!-- Filter Toggle Button -->
                            <button id="toggleTherapistBookingFilters" class="inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                                <i data-lucide="filter" class="h-4 w-4 mr-2"></i>
                                Bộ lọc
                            </button>
                        </div>
                    </div>
                </div>
                <!-- Filter Panel -->
                <div id="therapistBookingFilterPanel" class="therapist-booking-filter-panel px-6 py-0 border-b border-gray-200 bg-gray-50">
                    <div class="p-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                            <!-- Date Filter -->
                            <div>
                                <label for="therapistBookingDateFilter" class="block text-sm font-medium text-gray-700 mb-2">Ngày làm việc</label>
                                <input type="date" id="therapistBookingDateFilter"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>

                            <!-- Customer Filter -->
                            <div>
                                <label for="therapistBookingCustomerFilter" class="block text-sm font-medium text-gray-700 mb-2">Khách hàng</label>
                                <input type="text" id="therapistBookingCustomerFilter" placeholder="Tên khách hàng"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>

                            <!-- Service Filter -->
                            <div>
                                <label for="therapistBookingServiceFilter" class="block text-sm font-medium text-gray-700 mb-2">Dịch vụ</label>
                                <input type="text" id="therapistBookingServiceFilter" placeholder="Tên dịch vụ"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>

                            <!-- Status Filter -->
                            <div>
                                <label for="therapistBookingStatusFilter" class="block text-sm font-medium text-gray-700 mb-2">Trạng thái</label>
                                <select id="therapistBookingStatusFilter" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
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
                            <!-- Time From -->
                            <div>
                                <label for="therapistBookingTimeFrom" class="block text-sm font-medium text-gray-700 mb-2">Từ giờ</label>
                                <input type="time" id="therapistBookingTimeFrom"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>

                            <!-- Time To -->
                            <div>
                                <label for="therapistBookingTimeTo" class="block text-sm font-medium text-gray-700 mb-2">Đến giờ</label>
                                <input type="time" id="therapistBookingTimeTo"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>

                            <!-- Room Filter -->
                            <div>
                                <label for="therapistBookingRoomFilter" class="block text-sm font-medium text-gray-700 mb-2">Phòng</label>
                                <input type="text" id="therapistBookingRoomFilter" placeholder="Tên phòng"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            </div>
                        </div>
                    </div>

                    <!-- Filter Actions -->
                    <div class="flex justify-end py-3 px-6 gap-3 border-t border-gray-200">
                        <button id="resetTherapistBookingFilters" class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                            Đặt lại
                        </button>
                        <button id="applyTherapistBookingFilters" class="px-4 py-2 text-sm font-medium text-white bg-primary rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary/20">
                            Áp dụng
                        </button>
                        <button id="todayTherapistBookingFilter" class="px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue/20">
                            Hôm nay
                        </button>
                    </div>
                </div>

                <div class="p-6">
                    <table id="therapistBookingsTable" class="w-full display responsive nowrap" style="width:100%">
                        <thead>
                            <tr>
                                <th>Giờ hẹn</th>
                                <th>Khách hàng</th>
                                <th>Dịch vụ</th>
                                <th>Thời gian</th>
                                <th>Phòng</th>
                                <th>Trạng thái</th>
                                <th>Liên hệ</th>
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
                if (typeof initializeTherapistBookingFilters === 'function') {
                    initializeTherapistBookingFilters();
                } else {
                    console.error('initializeTherapistBookingFilters function not found');
                }
            }, 100);

            // Initialize DataTables
            if ($.fn.DataTable && document.getElementById('therapistBookingsTable')) {
                var table = $('#therapistBookingsTable').DataTable({
                    responsive: true,
                    dom: 'Blfrtip',
                    processing: true,
                    searching: true,
                    searchDelay: 300,
                    ajax: {
                        url: '${pageContext.request.contextPath}/therapist/show-bookings?action=data',
                        type: 'GET',
                        data: function(d) {
                            // Send current date filter only if specified
                            const dateFilter = $('#therapistBookingDateFilter').val();
                            if (dateFilter) {
                                d.date = dateFilter;
                            }
                        },
                        dataSrc: function(json) {
                            console.log('Received therapist booking data:', json);
                            return json.data;
                        },
                        error: function(xhr, error, thrown) {
                            console.error('DataTables AJAX error:', error, thrown);
                            console.error('Response text:', xhr.responseText);
                            alert('Lỗi khi tải dữ liệu lịch làm việc. Vui lòng làm mới trang.');
                        }
                    },
                    columns: [
                        {
                            data: 'appointmentTime',
                            title: 'Giờ hẹn',
                            render: function(data, type, row) {
                                if (type === 'sort' || type === 'type') {
                                    return data;
                                }
                                return '<span class="font-semibold text-primary text-lg">' + data + '</span>';
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
                                       '<div class="text-sm text-gray-500">' + (row.customerEmail || '') + '</div>';
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
                            data: 'durationMinutes',
                            title: 'Thời gian',
                            render: function(data, type, row) {
                                if (type === 'sort' || type === 'type') {
                                    return parseInt(data);
                                }
                                return '<span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">' +
                                       data + ' phút</span>';
                            }
                        },
                        {
                            data: null,
                            title: 'Phòng',
                            render: function(data, type, row) {
                                if (type === 'sort' || type === 'type') {
                                    return row.roomName;
                                }
                                return '<div class="font-medium text-spa-dark">' + row.roomName + '</div>' +
                                       (row.bedName ? '<div class="text-sm text-gray-500">' + row.bedName + '</div>' : '');
                            }
                        },
                        {
                            data: 'bookingStatus',
                            title: 'Trạng thái',
                            render: function(data, type, row) {
                                if (type === 'sort' || type === 'type') {
                                    return data;
                                }

                                var statusText = data;
                                var statusClass = '';

                                switch(data) {
                                    case 'SCHEDULED':
                                        statusText = 'Đã lên lịch';
                                        statusClass = 'bg-blue-100 text-blue-800';
                                        break;
                                    case 'CONFIRMED':
                                        statusText = 'Đã xác nhận';
                                        statusClass = 'bg-green-100 text-green-800';
                                        break;
                                    case 'IN_PROGRESS':
                                        statusText = 'Đang thực hiện';
                                        statusClass = 'bg-yellow-100 text-yellow-800';
                                        break;
                                    case 'COMPLETED':
                                        statusText = 'Hoàn thành';
                                        statusClass = 'bg-purple-100 text-purple-800';
                                        break;
                                    case 'CANCELLED':
                                        statusText = 'Đã hủy';
                                        statusClass = 'bg-red-100 text-red-800';
                                        break;
                                    case 'NO_SHOW':
                                        statusText = 'Không đến';
                                        statusClass = 'bg-gray-100 text-gray-800';
                                        break;
                                }

                                return '<span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ' + statusClass + '" data-status="' + data + '">' + statusText + '</span>';
                            }
                        },
                        {
                            data: 'customerPhone',
                            title: 'Liên hệ',
                            render: function(data, type, row) {
                                if (type === 'sort' || type === 'type') {
                                    return data;
                                }
                                return '<a href="tel:' + data + '" class="inline-flex items-center px-3 py-1 text-xs font-medium text-blue-600 bg-blue-50 rounded-md hover:bg-blue-100 transition-colors duration-200" title="Gọi điện">' +
                                       '<i data-lucide="phone" class="h-3 w-3 mr-1"></i>' + data + '</a>';
                            }
                        },
                        {
                            data: null,
                            title: 'Thao tác',
                            orderable: false,
                            searchable: false,
                            render: function(data, type, row) {
                                var actions = '<div class="flex items-center gap-2">';

                                // View Details Button
                                actions += '<button onclick="viewTherapistBookingDetails(' + row.bookingId + ')" ' +
                                          'class="inline-flex items-center px-3 py-1 text-xs font-medium text-blue-600 bg-blue-50 rounded-md hover:bg-blue-100 transition-colors duration-200" ' +
                                          'title="Xem chi tiết">' +
                                          '<i data-lucide="eye" class="h-3 w-3 mr-1"></i>Xem</button>';

                                // Status-specific action buttons
                                if (row.bookingStatus === 'CONFIRMED') {
                                    actions += '<button onclick="startTherapistSession(' + row.bookingId + ')" ' +
                                              'class="inline-flex items-center px-3 py-1 text-xs font-medium text-green-600 bg-green-50 rounded-md hover:bg-green-100 transition-colors duration-200" ' +
                                              'title="Bắt đầu phiên trị liệu">' +
                                              '<i data-lucide="play" class="h-3 w-3 mr-1"></i>Bắt đầu</button>';
                                } else if (row.bookingStatus === 'IN_PROGRESS') {
                                    actions += '<button onclick="completeTherapistSession(' + row.bookingId + ')" ' +
                                              'class="inline-flex items-center px-3 py-1 text-xs font-medium text-purple-600 bg-purple-50 rounded-md hover:bg-purple-100 transition-colors duration-200" ' +
                                              'title="Hoàn thành phiên trị liệu">' +
                                              '<i data-lucide="check" class="h-3 w-3 mr-1"></i>Hoàn thành</button>';
                                }

                                // Notes Button
                                actions += '<button onclick="addTherapistNotes(' + row.bookingId + ')" ' +
                                          'class="inline-flex items-center px-3 py-1 text-xs font-medium text-gray-600 bg-gray-50 rounded-md hover:bg-gray-100 transition-colors duration-200" ' +
                                          'title="Thêm ghi chú">' +
                                          '<i data-lucide="sticky-note" class="h-3 w-3 mr-1"></i>Ghi chú</button>';

                                actions += '</div>';
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
                    order: [[0, 'asc']], // Sort by appointment time
                    columnDefs: [
                        {
                            responsivePriority: 1,
                            targets: [0, 1, 2, 5, 7] // Time, Customer, Service, Status, Actions are high priority
                        },
                        {
                            responsivePriority: 2,
                            targets: [3, 4, 6] // Duration, Room, Contact are medium priority
                        },
                        {
                            targets: 0, // Time column
                            type: 'string'
                        },
                        {
                            targets: 7, // Actions column
                            orderable: false,
                            searchable: false
                        }
                    ],
                    pageLength: 25,
                    lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "Tất cả"]],
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
                    }
                });

                // Store table reference globally for filter functions
                window.therapistBookingTable = table;
            }
        });
        // Action Functions for Therapist Booking Management
        function viewTherapistBookingDetails(bookingId) {
            window.location.href = '${pageContext.request.contextPath}/therapist/booking-details?id=' + bookingId;
        }

        function startTherapistSession(bookingId) {
            if (confirm('Bạn có chắc chắn muốn bắt đầu phiên trị liệu #' + bookingId + '?')) {
                updateTherapistBookingStatus(bookingId, 'IN_PROGRESS');
            }
        }

        function completeTherapistSession(bookingId) {
            if (confirm('Bạn có chắc chắn muốn hoàn thành phiên trị liệu #' + bookingId + '?')) {
                updateTherapistBookingStatus(bookingId, 'COMPLETED');
            }
        }

        function updateTherapistBookingStatus(bookingId, status) {
            const button = event.target.closest('button');
            const originalContent = button.innerHTML;
            button.innerHTML = '<i data-lucide="loader-2" class="h-3 w-3 animate-spin"></i>';
            button.disabled = true;

            fetch('${pageContext.request.contextPath}/therapist/show-bookings', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: 'action=updateStatus&bookingId=' + bookingId + '&status=' + status
            })
            .then(response => {
                if (response.ok) return response.json();
                throw new Error('Network response was not ok');
            })
            .then(data => {
                if (data.success) {
                    if (typeof showTherapistBookingNotification === 'function') {
                        showTherapistBookingNotification('Cập nhật trạng thái thành công!', 'success');
                    }
                    setTimeout(() => {
                        location.reload();
                    }, 1500);
                } else {
                    throw new Error(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                if (typeof showTherapistBookingNotification === 'function') {
                    showTherapistBookingNotification('Có lỗi xảy ra khi cập nhật trạng thái: ' + error.message, 'error');
                }
                button.innerHTML = originalContent;
                button.disabled = false;
                lucide.createIcons();
            });
        }

        function addTherapistNotes(bookingId) {
            const notes = prompt('Thêm ghi chú cho lịch hẹn #' + bookingId + ':');
            if (notes !== null && notes.trim() !== '') {
                // Implementation for adding notes - could be expanded later
                if (typeof showTherapistBookingNotification === 'function') {
                    showTherapistBookingNotification('Ghi chú đã được lưu!', 'success');
                }
            }
        }

        console.log('Therapist Booking Page Loaded Successfully');
    </script>
</body>
</html>