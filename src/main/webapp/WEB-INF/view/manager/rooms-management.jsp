<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Phòng - Spa Hương Sen</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#D4AF37',
                        'primary-dark': '#B8941F',
                        'spa-cream': '#FFF8F0'
                    }
                }
            }
        }
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

    <!-- Manager Rooms Management Filter JS -->
    <script src="${pageContext.request.contextPath}/js/manager-rooms-management.js?v=<%= System.currentTimeMillis() %>"></script>

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
        .manager-rooms-filter-panel {
            transition: max-height 0.3s ease-in-out, opacity 0.3s ease-in-out;
            max-height: 0;
            opacity: 0;
            overflow: hidden;
        }

        .manager-rooms-filter-panel.show {
            max-height: 500px;
            opacity: 1;
        }

        #toggleManagerRoomsFilters i {
            transition: transform 0.3s ease;
        }

        #toggleManagerRoomsFilters i.rotate-180 {
            transform: rotate(180deg);
        }

        .status-active {
            background-color: #dcfce7;
            color: #166534;
        }

        .status-inactive {
            background-color: #fef2f2;
            color: #dc2626;
        }

        /* Responsive adjustments for filters */
        @media (max-width: 768px) {
            .grid-cols-1.md\\:grid-cols-2.lg\\:grid-cols-4 {
                grid-template-columns: repeat(1, minmax(0, 1fr));
            }
        }
    </style>
</head>
<body class="bg-gray-50">
    <!-- Include Header -->
    
    
    <div class="flex min-h-screen">
        <!-- Include Sidebar -->
        <jsp:include page="../common/sidebar.jsp" />
        
        <!-- Main Content -->
        <div class="flex-1 ml-64">
            <div class="p-8">
                

                <!-- Page Header -->
                <div class="mb-8">
                    <div class="flex items-center justify-between">
                        <div>
                            <h1 class="text-3xl font-bold text-gray-900">Quản Lý Phòng</h1>
                            <p class="text-gray-600 mt-2">Quản lý thông tin phòng và giường trong spa</p>
                        </div>
                        <div class="flex items-center space-x-4">
                            <a href="${pageContext.request.contextPath}/manager/room/add" class="bg-primary hover:bg-primary-dark text-white px-4 py-2 rounded-lg transition-colors duration-200 flex items-center">
                                <i data-lucide="plus" class="h-4 w-4 mr-2"></i>
                                Thêm Phòng Mới
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                    <div class="bg-white rounded-lg shadow-sm p-6">
                        <div class="flex items-center">
                            <div class="p-2 bg-blue-100 rounded-lg">
                                <i data-lucide="home" class="h-6 w-6 text-blue-600"></i>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-600">Tổng Phòng</p>
                                <p class="text-2xl font-bold text-gray-900" id="totalRooms">0</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white rounded-lg shadow-sm p-6">
                        <div class="flex items-center">
                            <div class="p-2 bg-green-100 rounded-lg">
                                <i data-lucide="check-circle" class="h-6 w-6 text-green-600"></i>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-600">Phòng Hoạt Động</p>
                                <p class="text-2xl font-bold text-gray-900" id="activeRooms">0</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white rounded-lg shadow-sm p-6">
                        <div class="flex items-center">
                            <div class="p-2 bg-red-100 rounded-lg">
                                <i data-lucide="x-circle" class="h-6 w-6 text-red-600"></i>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-600">Phòng Bảo Trì</p>
                                <p class="text-2xl font-bold text-gray-900" id="inactiveRooms">0</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white rounded-lg shadow-sm p-6">
                        <div class="flex items-center">
                            <div class="p-2 bg-yellow-100 rounded-lg">
                                <i data-lucide="bed" class="h-6 w-6 text-yellow-600"></i>
                            </div>
                            <div class="ml-4">
                                <p class="text-sm font-medium text-gray-600">Tổng Giường</p>
                                <p class="text-2xl font-bold text-gray-900" id="totalBeds">0</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Rooms Table -->
                <div class="bg-white rounded-lg shadow-sm">
                    <div class="p-6 border-b border-gray-200">
                        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                            <h2 class="text-xl font-semibold text-gray-900">Danh Sách Phòng</h2>

                            <div class="flex flex-wrap items-center gap-3">
                                <!-- Filter Toggle Button -->
                                <button id="toggleManagerRoomsFilters" class="inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                                    <i data-lucide="filter" class="h-4 w-4 mr-2"></i>
                                    Bộ lọc
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Filter Panel -->
                    <div id="managerRoomsFilterPanel" class="manager-rooms-filter-panel px-6 py-0 border-b border-gray-200 bg-gray-50">
                        <div class="p-6">
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                                <!-- Room Name Filter -->
                                <div>
                                    <label for="managerRoomsNameFilter" class="block text-sm font-medium text-gray-700 mb-2">Tên phòng</label>
                                    <input type="text" id="managerRoomsNameFilter" placeholder="Nhập tên phòng"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                </div>

                                <!-- Status Filter -->
                                <div>
                                    <label for="managerRoomsStatusFilter" class="block text-sm font-medium text-gray-700 mb-2">Trạng thái</label>
                                    <select id="managerRoomsStatusFilter" class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="active">Hoạt động</option>
                                        <option value="inactive">Bảo trì</option>
                                    </select>
                                </div>

                                <!-- Capacity Range -->
                                <div>
                                    <label for="managerRoomsMinCapacity" class="block text-sm font-medium text-gray-700 mb-2">Sức chứa từ</label>
                                    <input type="number" id="managerRoomsMinCapacity" placeholder="0" min="0"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                </div>

                                <div>
                                    <label for="managerRoomsMaxCapacity" class="block text-sm font-medium text-gray-700 mb-2">Sức chứa đến</label>
                                    <input type="number" id="managerRoomsMaxCapacity" placeholder="100" min="0"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                </div>
                            </div>

                            <!-- Date Range -->
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
                                <div>
                                    <label for="managerRoomsDateFrom" class="block text-sm font-medium text-gray-700 mb-2">Từ ngày</label>
                                    <input type="date" id="managerRoomsDateFrom"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                </div>

                                <div>
                                    <label for="managerRoomsDateTo" class="block text-sm font-medium text-gray-700 mb-2">Đến ngày</label>
                                    <input type="date" id="managerRoomsDateTo"
                                           class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                </div>
                            </div>
                        </div>

                        <!-- Filter Actions -->
                        <div class="flex justify-end py-3 px-6 gap-3 border-t border-gray-200">
                            <button id="resetManagerRoomsFilters" class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-primary/20">
                                Đặt lại
                            </button>
                            <button id="applyManagerRoomsFilters" class="px-4 py-2 text-sm font-medium text-white bg-primary rounded-md hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-primary/20">
                                Áp dụng
                            </button>
                        </div>
                    </div>
                    
                    <div class="p-6">
                        <table id="roomsTable" class="w-full display responsive nowrap" style="width:100%">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tên Phòng</th>
                                    <th>Mô Tả</th>
                                    <th>Sức Chứa</th>
                                    <th>Trạng Thái</th>
                                    <th>Ngày Tạo</th>
                                    <th>Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="room" items="${rooms}">
                                    <tr>
                                        <td>${room.roomId}</td>
                                        <td>${room.name}</td>
                                        <td>${room.description}</td>
                                        <td>${room.capacity}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${room.isActive}">
                                                    <span class="px-2 py-1 text-xs font-medium rounded-full status-active">Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="px-2 py-1 text-xs font-medium rounded-full status-inactive">Bảo trì</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${room.createdAt}</td>
                                        <td>
                                            <div class="flex items-center gap-2">
                                                <a href="${pageContext.request.contextPath}/manager/room-details/${room.roomId}"
                                                   class="inline-flex items-center px-3 py-1 text-xs font-medium text-blue-600 bg-blue-50 rounded-md hover:bg-blue-100 transition-colors duration-200"
                                                   title="Xem chi tiết">
                                                    <i data-lucide="eye" class="h-3 w-3 mr-1"></i>
                                                    Chi tiết
                                                </a>
                                                <a href="${pageContext.request.contextPath}/manager/room/edit/${room.roomId}"
                                                   class="inline-flex items-center px-3 py-1 text-xs font-medium text-yellow-600 bg-yellow-50 rounded-md hover:bg-yellow-100 transition-colors duration-200"
                                                   title="Chỉnh sửa">
                                                    <i data-lucide="edit" class="h-3 w-3 mr-1"></i>
                                                    Sửa
                                                </a>
                                                <a href="${pageContext.request.contextPath}/manager/room/toggle-status/${room.roomId}"
                                                   class="inline-flex items-center px-3 py-1 text-xs font-medium text-purple-600 bg-purple-50 rounded-md hover:bg-purple-100 transition-colors duration-200"
                                                   title="Thay đổi trạng thái"
                                                   onclick="return confirm('Bạn có chắc chắn muốn thay đổi trạng thái phòng này?')">
                                                    <i data-lucide="refresh-cw" class="h-3 w-3 mr-1"></i>
                                                    <c:choose>
                                                        <c:when test="${room.isActive}">Tắt</c:when>
                                                        <c:otherwise>Bật</c:otherwise>
                                                    </c:choose>
                                                </a>
                                                <!-- <a href="${pageContext.request.contextPath}/manager/room/delete/${room.roomId}"
                                                   class="inline-flex items-center px-3 py-1 text-xs font-medium text-red-600 bg-red-50 rounded-md hover:bg-red-100 transition-colors duration-200"
                                                   title="Xóa phòng"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa phòng này? Hành động này không thể hoàn tác.')">
                                                    <i data-lucide="trash-2" class="h-3 w-3 mr-1"></i>
                                                    Xóa
                                                </a> -->
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Include Footer -->
    

    <script>
        $(document).ready(function() {
            // Initialize filter functionality (handled by external JS)
            // Wait a bit to ensure all elements are rendered
            setTimeout(function() {
                if (typeof initializeManagerRoomsFilters === 'function') {
                    initializeManagerRoomsFilters();
                } else {
                    console.error('initializeManagerRoomsFilters function not found');
                }
            }, 100);

            // Initialize DataTables
            if ($.fn.DataTable && document.getElementById('roomsTable')) {
                var table = $('#roomsTable').DataTable({
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
                    columnDefs: [
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
                            extend: 'excel',
                            text: '<i data-lucide="download" class="h-4 w-4 mr-2"></i>Xuất Excel',
                            className: 'bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg transition-colors duration-200 flex items-center',
                            exportOptions: {
                                columns: [0, 1, 2, 3, 4, 5] // Exclude actions column
                            }
                        },
                        {
                            extend: 'print',
                            text: '<i data-lucide="printer" class="h-4 w-4 mr-2"></i>In',
                            className: 'bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition-colors duration-200 flex items-center',
                            exportOptions: {
                                columns: [0, 1, 2, 3, 4, 5] // Exclude actions column
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

                        // Update statistics
                        updateStatistics();
                    }
                });
            }

            // Update statistics
            function updateStatistics() {
                var totalRooms = $('#roomsTable tbody tr').length;
                var activeRooms = $('#roomsTable tbody tr').filter(function() {
                    return $(this).find('.status-active').length > 0;
                }).length;
                var inactiveRooms = totalRooms - activeRooms;
                var totalBeds = 0;

                // Calculate total beds (sum of capacity)
                $('#roomsTable tbody tr').each(function() {
                    var capacity = parseInt($(this).find('td:eq(3)').text()) || 0;
                    totalBeds += capacity;
                });

                $('#totalRooms').text(totalRooms);
                $('#activeRooms').text(activeRooms);
                $('#inactiveRooms').text(inactiveRooms);
                $('#totalBeds').text(totalBeds);
            }

            // Initialize Lucide icons
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }
        });

        // Room management functions are now handled by direct links
    </script>
