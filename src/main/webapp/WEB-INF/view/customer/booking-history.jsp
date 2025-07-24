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

    <style>
        /* Custom styling for booking history */
        .booking-card {
            transition: all 0.3s ease;
        }
        
        .booking-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        
        .status-badge {
            transition: all 0.3s ease;
        }
        
        .status-scheduled {
            background-color: #3B82F6;
            color: white;
        }
        
        .status-completed {
            background-color: #10B981;
            color: white;
        }
        
        .status-cancelled {
            background-color: #EF4444;
            color: white;
        }
        
        .status-no_show {
            background-color: #F59E0B;
            color: white;
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
        
        /* Filter form styling */
        .filter-form {
            background: linear-gradient(135deg, #FFF8F0 0%, #F7F3E9 100%);
        }
        
        /* Statistics cards */
        .stat-card {
            transition: all 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        
        .stat-icon {
            background: linear-gradient(135deg, #D4AF37 0%, #B8941F 100%);
        }
    </style>
</head>

<body class="bg-spa-cream min-h-screen">
    <!-- Include Header -->
    <jsp:include page="../common/header.jsp" />
    
    <!-- Include Sidebar -->
    <jsp:include page="../common/sidebar.jsp" />
    
    <!-- Main Content -->
    <div class="ml-64 p-8">
        <div class="max-w-7xl mx-auto">
            <!-- Page Header -->
            <div class="mb-8">
                <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between">
                    <div>
                        <h1 class="text-3xl font-bold text-spa-dark mb-2">Lịch Sử Đặt Lịch</h1>
                        <p class="text-gray-600">Xem và quản lý tất cả các cuộc hẹn của bạn</p>
                    </div>
                    <div class="mt-4 sm:mt-0">
                        <a href="${pageContext.request.contextPath}/customer/booking" 
                           class="inline-flex items-center px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary/90 transition-colors">
                            <i data-lucide="calendar-plus" class="h-4 w-4 mr-2"></i>
                            Đặt Lịch Mới
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Statistics Cards -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <!-- Total Bookings -->
                <div class="stat-card bg-white rounded-xl shadow-md p-6">
                    <div class="flex items-center">
                        <div class="stat-icon p-3 rounded-full text-white mr-4">
                            <i data-lucide="calendar" class="h-6 w-6"></i>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-600">Tổng Lịch Hẹn</p>
                            <p class="text-2xl font-bold text-spa-dark">${bookingStats.total_bookings}</p>
                        </div>
                    </div>
                </div>
                
                <!-- Completed Bookings -->
                <div class="stat-card bg-white rounded-xl shadow-md p-6">
                    <div class="flex items-center">
                        <div class="stat-icon p-3 rounded-full text-white mr-4">
                            <i data-lucide="check-circle" class="h-6 w-6"></i>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-600">Đã Hoàn Thành</p>
                            <p class="text-2xl font-bold text-green-600">${bookingStats.completed_count}</p>
                        </div>
                    </div>
                </div>
                
                <!-- Scheduled Bookings -->
                <div class="stat-card bg-white rounded-xl shadow-md p-6">
                    <div class="flex items-center">
                        <div class="stat-icon p-3 rounded-full text-white mr-4">
                            <i data-lucide="clock" class="h-6 w-6"></i>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-600">Đã Lên Lịch</p>
                            <p class="text-2xl font-bold text-blue-600">${bookingStats.scheduled_count}</p>
                        </div>
                    </div>
                </div>
                
                <!-- Cancelled Bookings -->
                <div class="stat-card bg-white rounded-xl shadow-md p-6">
                    <div class="flex items-center">
                        <div class="stat-icon p-3 rounded-full text-white mr-4">
                            <i data-lucide="x-circle" class="h-6 w-6"></i>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-600">Đã Hủy</p>
                            <p class="text-2xl font-bold text-red-600">${bookingStats.cancelled_count}</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Filter Section -->
            <div class="filter-form rounded-xl shadow-md p-6 mb-6">
                <h2 class="text-lg font-semibold text-spa-dark mb-4 flex items-center">
                    <i data-lucide="filter" class="h-5 w-5 text-primary mr-2"></i>
                    Bộ Lọc Tìm Kiếm
                </h2>
                
                <form method="get" action="${pageContext.request.contextPath}/customer/booking-history" class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <!-- Status Filter -->
                    <div>
                        <label for="status" class="block text-sm font-medium text-gray-700 mb-2">Trạng thái:</label>
                        <select id="status" name="status" 
                                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            <option value="">Tất cả trạng thái</option>
                            <option value="SCHEDULED" ${statusFilter == 'SCHEDULED' ? 'selected' : ''}>Đã lên lịch</option>
                            <option value="COMPLETED" ${statusFilter == 'COMPLETED' ? 'selected' : ''}>Đã hoàn thành</option>
                            <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                            <option value="NO_SHOW" ${statusFilter == 'NO_SHOW' ? 'selected' : ''}>Không đến</option>
                        </select>
                    </div>
                    
                    <!-- Date From -->
                    <div>
                        <label for="dateFrom" class="block text-sm font-medium text-gray-700 mb-2">Từ ngày:</label>
                        <input type="date" id="dateFrom" name="dateFrom" value="${dateFrom}"
                               class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                    </div>
                    
                    <!-- Date To -->
                    <div>
                        <label for="dateTo" class="block text-sm font-medium text-gray-700 mb-2">Đến ngày:</label>
                        <input type="date" id="dateTo" name="dateTo" value="${dateTo}"
                               class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                    </div>
                    
                    <!-- Filter Buttons -->
                    <div class="flex items-end gap-2">
                        <button type="submit" 
                                class="flex-1 px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary/90 transition-colors">
                            <i data-lucide="search" class="h-4 w-4 mr-2 inline"></i>
                            Lọc
                        </button>
                        <a href="${pageContext.request.contextPath}/customer/booking-history" 
                           class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                            <i data-lucide="x" class="h-4 w-4"></i>
                        </a>
                    </div>
                </form>
            </div>
            
            <!-- Error/Success Messages -->
            <c:if test="${not empty errorMessage}">
                <div class="mb-6 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg">
                    <i data-lucide="alert-circle" class="h-5 w-5 inline mr-2"></i>
                    ${errorMessage}
                </div>
            </c:if>
            
            <!-- Bookings Table -->
            <div class="bg-white rounded-xl shadow-md p-6">
                <h2 class="text-lg font-semibold text-spa-dark mb-4 flex items-center">
                    <i data-lucide="list" class="h-5 w-5 text-primary mr-2"></i>
                    Danh Sách Lịch Hẹn
                    <span class="ml-2 text-sm font-normal text-gray-500">(${totalBookings} lịch hẹn)</span>
                </h2>
                
                <c:choose>
                    <c:when test="${not empty bookings}">
                        <table id="bookingsTable" class="w-full display responsive nowrap" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Mã đặt lịch</th>
                                    <th>Dịch vụ</th>
                                    <th>Ngày hẹn</th>
                                    <th>Giờ hẹn</th>
                                    <th>Kỹ thuật viên</th>
                                    <th>Thời gian</th>
                                    <th>Trạng thái</th>
                                    <th>Ghi chú</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="booking" items="${bookings}">
                                    <tr>
                                        <td>
                                            <span class="font-medium text-primary">#${booking.bookingId}</span>
                                        </td>
                                        <td>
                                            <div class="font-medium text-gray-900">
                                                <c:choose>
                                                    <c:when test="${not empty booking.service}">
                                                        ${booking.service.name}
                                                    </c:when>
                                                    <c:otherwise>
                                                        (Không xác định)
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${booking.appointmentDate}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>
                                            <fmt:formatDate value="${booking.appointmentTime}" pattern="HH:mm"/>
                                        </td>
                                        <td>
                                            <div class="font-medium text-gray-900">
                                                <c:choose>
                                                    <c:when test="${not empty booking.therapist}">
                                                        ${booking.therapist.fullName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        (Không xác định)
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="text-gray-600">${booking.durationMinutes} phút</span>
                                        </td>
                                        <td>
                                            <span class="status-badge px-2 py-1 rounded-full text-xs font-medium status-${fn:toLowerCase(booking.bookingStatus)}">
                                                <c:choose>
                                                    <c:when test="${booking.bookingStatus == 'SCHEDULED'}">Đã lên lịch</c:when>
                                                    <c:when test="${booking.bookingStatus == 'COMPLETED'}">Đã hoàn thành</c:when>
                                                    <c:when test="${booking.bookingStatus == 'CANCELLED'}">Đã hủy</c:when>
                                                    <c:when test="${booking.bookingStatus == 'NO_SHOW'}">Không đến</c:when>
                                                    <c:otherwise>${booking.bookingStatus}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="text-gray-600 text-sm">
                                                <c:choose>
                                                    <c:when test="${not empty booking.bookingNotes}">
                                                        ${fn:substring(booking.bookingNotes, 0, 50)}
                                                        <c:if test="${fn:length(booking.bookingNotes) > 50}">...</c:if>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="flex gap-2">
                                                <button onclick="viewBookingDetails(${booking.bookingId})" 
                                                        class="px-3 py-1 bg-blue-500 text-white text-xs rounded hover:bg-blue-600 transition-colors"
                                                        title="Xem chi tiết">
                                                    <i data-lucide="eye" class="h-3 w-3"></i>
                                                </button>
                                                <c:if test="${booking.bookingStatus == 'SCHEDULED'}">
                                                    <button onclick="cancelBooking(${booking.bookingId})" 
                                                            class="px-3 py-1 bg-red-500 text-white text-xs rounded hover:bg-red-600 transition-colors"
                                                            title="Hủy lịch hẹn">
                                                        <i data-lucide="x" class="h-3 w-3"></i>
                                                    </button>
                                                </c:if>
                                                <c:if test="${booking.bookingStatus == 'COMPLETED'}">
                                                    <a href="${pageContext.request.contextPath}/customer/service-review/add?bookingId=${booking.bookingId}" 
                                                       class="px-3 py-1 bg-yellow-500 text-white text-xs rounded hover:bg-yellow-600 transition-colors flex items-center gap-1"
                                                       title="Đánh giá dịch vụ">
                                                        <i data-lucide="star" class="h-3 w-3"></i> Đánh giá
                                                    </a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-8">
                            <i data-lucide="calendar-x" class="h-16 w-16 text-gray-400 mx-auto mb-4"></i>
                            <h3 class="text-lg font-medium text-gray-900 mb-2">Không có lịch hẹn nào</h3>
                            <p class="text-gray-600 mb-4">Bạn chưa có lịch hẹn nào hoặc không có lịch hẹn nào phù hợp với bộ lọc.</p>
                            <a href="${pageContext.request.contextPath}/customer/booking" 
                               class="inline-flex items-center px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary/90 transition-colors">
                                <i data-lucide="calendar-plus" class="h-4 w-4 mr-2"></i>
                                Đặt Lịch Ngay
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <!-- Include Footer -->
    <jsp:include page="../common/footer.jsp" />

    <script>
        $(document).ready(function() {
            // Initialize Lucide icons
            if (typeof lucide !== 'undefined') {
                lucide.createIcons();
            }

            // Initialize DataTables
            if ($.fn.DataTable && document.getElementById('bookingsTable')) {
                $('#bookingsTable').DataTable({
                    responsive: true,
                    dom: 'Blfrtip',
                    processing: true,
                    language: {
                        "sProcessing": "Đang xử lý...",
                        "sLengthMenu": "Hiển thị _MENU_ mục",
                        "sZeroRecords": "Không tìm thấy lịch hẹn nào phù hợp",
                        "sInfo": "Đang hiển thị _START_ đến _END_ trong tổng số _TOTAL_ lịch hẹn",
                        "sInfoEmpty": "Đang hiển thị 0 đến 0 trong tổng số 0 lịch hẹn",
                        "sInfoFiltered": "(được lọc từ _MAX_ lịch hẹn)",
                        "sSearch": "Tìm kiếm:",
                        "oPaginate": {
                            "sFirst": "Đầu",
                            "sPrevious": "Trước",
                            "sNext": "Tiếp",
                            "sLast": "Cuối"
                        }
                    },
                    order: [[2, 'desc'], [3, 'desc']], // Sort by appointment date and time (newest first)
                    columnDefs: [
                        {
                            responsivePriority: 1,
                            targets: [0, 1, 2, 6] // Booking ID, Service, Date, Status are high priority
                        },
                        {
                            responsivePriority: 2,
                            targets: [3, 4] // Time and Therapist are medium priority
                        },
                        {
                            responsivePriority: 3,
                            targets: [5, 7, 8] // Duration, Notes, Actions are low priority
                        }
                    ],
                    pageLength: 10,
                    lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "Tất cả"]],
                    buttons: [
                        {
                            extend: 'excelHtml5',
                            text: '<i data-lucide="file-spreadsheet" class="h-4 w-4 mr-1"></i> Xuất Excel',
                            className: 'bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded',
                            title: 'Lịch sử đặt lịch - BeautyZone Spa'
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

                        console.log('Booking history DataTable initialized successfully');
                    }
                });
            }
        });

        // Booking action functions
        function viewBookingDetails(bookingId) {
            // Create a modal or redirect to booking details page
            alert('Xem chi tiết lịch hẹn #' + bookingId + '\n\nTính năng này sẽ được phát triển trong phiên bản tiếp theo.');
        }

        function cancelBooking(bookingId) {
            if (confirm('Bạn có chắc chắn muốn hủy lịch hẹn #' + bookingId + '?\n\nLưu ý: Việc hủy lịch hẹn có thể áp dụng phí hủy theo chính sách của spa.')) {
                // Show loading state
                const cancelButton = $('button[onclick="cancelBooking(' + bookingId + ')"]');
                const originalText = cancelButton.html();
                cancelButton.prop('disabled', true).html('<i data-lucide="loader-2" class="h-3 w-3 animate-spin"></i>');

                // Send AJAX request to cancel booking
                $.ajax({
                    url: '${pageContext.request.contextPath}/customer/booking-history',
                    type: 'POST',
                    data: {
                        action: 'cancel',
                        bookingId: bookingId
                    },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            alert('Lịch hẹn #' + bookingId + ' đã được hủy thành công.');
                            location.reload(); // Reload page to show updated status
                        } else {
                            alert('Lỗi: ' + response.message);
                            cancelButton.prop('disabled', false).html(originalText);
                        }
                    },
                    error: function(xhr, status, error) {
                        let errorMessage = 'Có lỗi xảy ra khi hủy lịch hẹn. Vui lòng thử lại sau.';

                        if (xhr.responseJSON && xhr.responseJSON.message) {
                            errorMessage = xhr.responseJSON.message;
                        } else if (xhr.status === 401) {
                            errorMessage = 'Bạn cần đăng nhập để thực hiện thao tác này.';
                        } else if (xhr.status === 403) {
                            errorMessage = 'Bạn không có quyền hủy lịch hẹn này.';
                        } else if (xhr.status === 404) {
                            errorMessage = 'Không tìm thấy lịch hẹn.';
                        }

                        alert('Lỗi: ' + errorMessage);
                        cancelButton.prop('disabled', false).html(originalText);
                        console.error('Error cancelling booking:', error);
                    }
                });
            }
        }

        // Utility functions
        function formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString('vi-VN');
        }

        function formatTime(timeString) {
            const time = new Date('1970-01-01T' + timeString);
            return time.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
        }

        // Auto-refresh page every 5 minutes to show updated booking statuses
        setInterval(function() {
            // Only refresh if user is active (has interacted in last 5 minutes)
            const lastActivity = localStorage.getItem('lastActivity');
            const now = Date.now();

            if (!lastActivity || (now - parseInt(lastActivity)) < 300000) { // 5 minutes
                console.log('Auto-refreshing booking history...');
                location.reload();
            }
        }, 300000); // 5 minutes

        // Track user activity for auto-refresh
        $(document).on('click keypress scroll', function() {
            localStorage.setItem('lastActivity', Date.now());
        });
    </script>
    <% String pointMessage = (String) session.getAttribute("pointMessage");
       if (pointMessage != null) { %>
    <script>
        alert("<%= pointMessage.replace("\"", "\\\"") %>");
    </script>
    <% session.removeAttribute("pointMessage"); } %>
</body>
</html>
