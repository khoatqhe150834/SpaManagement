<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${pageTitle} - Spa Hương Sen</title>

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
              serif: ["Playfair Display", "serif"],
              sans: ["Roboto", "sans-serif"],
            },
          },
        },
      };
    </script>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />

    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>

    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.dataTables.min.css">

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="/spa/css/style.css" />

    <style>
        /* Custom DataTables styling */
        .dataTables_wrapper {
            font-family: 'Roboto', sans-serif;
        }
        
        .dataTables_length select,
        .dataTables_filter input {
            border: 1px solid #d1d5db;
            border-radius: 8px;
            padding: 8px 12px;
            margin: 0 8px;
        }
        
        .dataTables_filter input:focus {
            outline: none;
            border-color: #D4AF37;
            box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.1);
        }
        
        table.dataTable thead th {
            border-bottom: 2px solid #e5e7eb;
            font-weight: 600;
            color: #374151;
            background-color: #f9fafb;
        }
        
        table.dataTable tbody tr:hover {
            background-color: rgba(255, 248, 240, 0.5);
        }
        
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .status-scheduled { background-color: #dbeafe; color: #1e40af; }
        .status-confirmed { background-color: #dcfce7; color: #166534; }
        .status-completed { background-color: #f3f4f6; color: #374151; }
        .status-cancelled { background-color: #fee2e2; color: #dc2626; }
        .status-in-progress { background-color: #fef3c7; color: #d97706; }
    </style>
</head>

<body class="bg-spa-cream">
    <!-- Include Header -->
    <jsp:include page="../common/header.jsp" />

    <main class="container mx-auto px-4 py-8 mt-20">
        <!-- Page Header -->
        <div class="mb-8">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between">
                <div>
                    <h1 class="text-3xl font-bold text-spa-dark mb-2 flex items-center gap-3">
                        <i data-lucide="calendar-check" class="h-8 w-8 text-primary"></i>
                        Dịch vụ đã đặt lịch
                    </h1>
                    <p class="text-gray-600">Quản lý và theo dõi tất cả các dịch vụ bạn đã đặt lịch</p>
                </div>
                <div class="mt-4 sm:mt-0 flex gap-3">
                    <a href="${pageContext.request.contextPath}/services" 
                       class="inline-flex items-center px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors">
                        <i data-lucide="plus" class="h-4 w-4 mr-2"></i>
                        Đặt dịch vụ mới
                    </a>
                    <a href="${pageContext.request.contextPath}/customer-dashboard" 
                       class="inline-flex items-center px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
                        <i data-lucide="arrow-left" class="h-4 w-4 mr-2"></i>
                        Về Dashboard
                    </a>
                </div>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <div class="bg-white p-6 rounded-xl shadow-md border border-gray-200">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-500 mb-1">Tổng số lịch hẹn</p>
                        <p class="text-2xl font-bold text-spa-dark">${dashboardStats.totalBookings}</p>
                    </div>
                    <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                        <i data-lucide="calendar" class="h-6 w-6 text-blue-600"></i>
                    </div>
                </div>
            </div>
            
            <div class="bg-white p-6 rounded-xl shadow-md border border-gray-200">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-500 mb-1">Sắp tới</p>
                        <p class="text-2xl font-bold text-spa-dark">${dashboardStats.upcomingBookings}</p>
                    </div>
                    <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                        <i data-lucide="clock" class="h-6 w-6 text-green-600"></i>
                    </div>
                </div>
            </div>
            
            <div class="bg-white p-6 rounded-xl shadow-md border border-gray-200">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-500 mb-1">Đã hoàn thành</p>
                        <p class="text-2xl font-bold text-spa-dark">${dashboardStats.completedBookings}</p>
                    </div>
                    <div class="w-12 h-12 bg-primary/20 rounded-lg flex items-center justify-center">
                        <i data-lucide="check-circle" class="h-6 w-6 text-primary"></i>
                    </div>
                </div>
            </div>
            
            <div class="bg-white p-6 rounded-xl shadow-md border border-gray-200">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-500 mb-1">Đã hủy</p>
                        <p class="text-2xl font-bold text-spa-dark">${dashboardStats.cancelledBookings}</p>
                    </div>
                    <div class="w-12 h-12 bg-red-100 rounded-lg flex items-center justify-center">
                        <i data-lucide="x-circle" class="h-6 w-6 text-red-600"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bookings Table -->
        <div class="bg-white rounded-xl shadow-md border border-gray-200 overflow-hidden">
            <div class="p-6 border-b border-gray-200">
                <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                    <h2 class="text-xl font-semibold text-spa-dark">Danh sách lịch hẹn</h2>
                    
                    <!-- Filter Controls -->
                    <div class="flex flex-wrap gap-3">
                        <select id="statusFilter" class="px-3 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                            <option value="">Tất cả trạng thái</option>
                            <option value="SCHEDULED" ${statusFilter == 'SCHEDULED' ? 'selected' : ''}>Đã lên lịch</option>
                            <option value="CONFIRMED" ${statusFilter == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                            <option value="IN_PROGRESS" ${statusFilter == 'IN_PROGRESS' ? 'selected' : ''}>Đang thực hiện</option>
                            <option value="COMPLETED" ${statusFilter == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                            <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                        
                        <button id="refreshBtn" class="inline-flex items-center px-3 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200 transition-colors">
                            <i data-lucide="refresh-cw" class="h-4 w-4 mr-2"></i>
                            Làm mới
                        </button>
                    </div>
                </div>
            </div>

            <div class="p-6">
                <table id="bookingsTable" class="w-full display responsive nowrap" style="width:100%">
                    <thead>
                        <tr>
                            <th>Mã đặt lịch</th>
                            <th>Dịch vụ</th>
                            <th>Ngày hẹn</th>
                            <th>Giờ hẹn</th>
                            <th>Nhân viên</th>
                            <th>Thời gian</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="booking" items="${bookings}">
                            <tr>
                                <td>
                                    <span class="font-mono text-sm font-medium text-primary">
                                        #${booking.bookingId}
                                    </span>
                                </td>
                                <td>
                                    <div class="flex items-center gap-2">
                                        <i data-lucide="scissors" class="h-4 w-4 text-primary"></i>
                                        <span class="font-medium">
                                            ${booking.serviceName != null ? booking.serviceName : 'Dịch vụ không xác định'}
                                        </span>
                                    </div>
                                </td>
                                <td data-order="<fmt:formatDate value='${booking.appointmentDate}' pattern='yyyy-MM-dd'/>">
                                    <fmt:formatDate value="${booking.appointmentDate}" pattern="dd/MM/yyyy"/>
                                </td>
                                <td data-order="<fmt:formatDate value='${booking.appointmentTime}' pattern='HH:mm'/>">
                                    <fmt:formatDate value="${booking.appointmentTime}" pattern="HH:mm"/>
                                </td>
                                <td>
                                    <div class="flex items-center gap-2">
                                        <i data-lucide="user" class="h-4 w-4 text-gray-400"></i>
                                        <span>
                                            ${booking.therapistName != null ? booking.therapistName : 'Chưa phân công'}
                                        </span>
                                    </div>
                                </td>
                                <td>
                                    <span class="text-sm text-gray-600">
                                        ${booking.durationMinutes != null ? booking.durationMinutes : 0} phút
                                    </span>
                                </td>
                                <td>
                                    <span class="status-badge status-${booking.bookingStatus.toString().toLowerCase().replace('_', '-')}">
                                        <c:choose>
                                            <c:when test="${booking.bookingStatus == 'SCHEDULED'}">Đã lên lịch</c:when>
                                            <c:when test="${booking.bookingStatus == 'CONFIRMED'}">Đã xác nhận</c:when>
                                            <c:when test="${booking.bookingStatus == 'IN_PROGRESS'}">Đang thực hiện</c:when>
                                            <c:when test="${booking.bookingStatus == 'COMPLETED'}">Hoàn thành</c:when>
                                            <c:when test="${booking.bookingStatus == 'CANCELLED'}">Đã hủy</c:when>
                                            <c:otherwise>${booking.bookingStatus}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <div class="flex items-center gap-2">
                                        <a href="${pageContext.request.contextPath}/customer/bookings/details?id=${booking.bookingId}" 
                                           class="inline-flex items-center px-2 py-1 text-xs font-medium text-blue-600 bg-blue-50 rounded hover:bg-blue-100 transition-colors"
                                           title="Xem chi tiết">
                                            <i data-lucide="eye" class="h-3 w-3 mr-1"></i>
                                            Chi tiết
                                        </a>
                                        
                                        <c:if test="${booking.bookingStatus == 'SCHEDULED' || booking.bookingStatus == 'CONFIRMED'}">
                                            <button onclick="cancelBooking(${booking.bookingId})" 
                                                    class="inline-flex items-center px-2 py-1 text-xs font-medium text-red-600 bg-red-50 rounded hover:bg-red-100 transition-colors"
                                                    title="Hủy lịch hẹn">
                                                <i data-lucide="x" class="h-3 w-3 mr-1"></i>
                                                Hủy
                                            </button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Include Footer -->
    <jsp:include page="../common/footer.jsp" />

    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>

    <!-- External JavaScript -->
    <script src="${pageContext.request.contextPath}/js/customer-bookings.js"></script>

    <script>
        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    </script>
</body>
</html>
