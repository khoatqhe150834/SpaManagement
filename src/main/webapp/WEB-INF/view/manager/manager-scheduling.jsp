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
            <!-- Statistics Row -->
            <div class="row mb-4">
                <div class="col-lg-3 col-md-6">
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
                <div class="col-lg-3 col-md-6">
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
                <div class="col-lg-3 col-md-6">
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
                <div class="col-lg-3 col-md-6">
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
            <!-- Schedulable Items Table -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 overflow-hidden">
                <div class="p-6 border-b border-gray-200">
                    <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                        <i data-lucide="calendar-plus" class="h-6 w-6 text-primary"></i>
                        Quản lý lịch hẹn dịch vụ
                    </h2>
                    <p class="text-gray-600 mt-2">Đặt lịch cho các dịch vụ đã thanh toán</p>
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
    <!-- Scheduling Modal -->
    <div class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden" id="schedulingModal">
        <div class="flex items-center justify-center min-h-screen p-4">
            <div class="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
                <div class="p-6 border-b border-gray-200">
                    <div class="flex items-center justify-between">
                        <h3 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                            <i data-lucide="calendar-plus" class="h-6 w-6 text-primary"></i>
                            Đặt lịch dịch vụ
                        </h3>
                        <button onclick="closeSchedulingModal()" class="text-gray-400 hover:text-gray-600 transition-colors">
                            <i data-lucide="x" class="h-6 w-6"></i>
                        </button>
                    </div>
                </div>

                <div class="p-6">
                    <form id="schedulingForm">
                        <input type="hidden" id="paymentItemId" name="paymentItemId">

                        <!-- Customer and Service Info -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Khách hàng</label>
                                <div class="flex items-center gap-3 p-3 bg-gray-50 rounded-lg">
                                    <div class="w-10 h-10 bg-primary rounded-full flex items-center justify-center text-white font-semibold" id="customerAvatar">K</div>
                                    <div>
                                        <div class="font-semibold text-spa-dark" id="customerName">Tên khách hàng</div>
                                        <div class="text-sm text-gray-600" id="customerPhone">Số điện thoại</div>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Dịch vụ</label>
                                <div class="p-3 bg-gray-50 rounded-lg">
                                    <div class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800" id="serviceName">Tên dịch vụ</div>
                                    <div class="text-sm text-gray-600 mt-1">Thời gian: <span id="serviceDuration">60 phút</span></div>
                                </div>
                            </div>
                        </div>

                        <!-- Appointment Date and Time -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                            <div>
                                <label for="appointmentDate" class="block text-sm font-medium text-gray-700 mb-2">Ngày hẹn</label>
                                <input type="date" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" id="appointmentDate" name="appointmentDate" required>
                            </div>
                            <div>
                                <label for="appointmentTime" class="block text-sm font-medium text-gray-700 mb-2">Giờ hẹn</label>
                                <input type="time" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" id="appointmentTime" name="appointmentTime" required>
                            </div>
                        </div>

                        <!-- Therapist Selection -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                            <div>
                                <label for="therapistId" class="block text-sm font-medium text-gray-700 mb-2">Kỹ thuật viên</label>
                                <select class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" id="therapistId" name="therapistId" required>
                                    <option value="">Chọn kỹ thuật viên</option>
                                </select>
                            </div>
                            <div>
                                <label for="roomId" class="block text-sm font-medium text-gray-700 mb-2">Phòng</label>
                                <select class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" id="roomId" name="roomId" required>
                                    <option value="">Chọn phòng</option>
                                    <option value="1">Phòng 1</option>
                                    <option value="2">Phòng 2</option>
                                    <option value="3">Phòng 3</option>
                                </select>
                            </div>
                        </div>

                        <!-- Notes -->
                        <div class="mb-6">
                            <label for="bookingNotes" class="block text-sm font-medium text-gray-700 mb-2">Ghi chú</label>
                            <textarea class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary" id="bookingNotes" name="notes" rows="3" placeholder="Ghi chú thêm cho lịch hẹn..."></textarea>
                        </div>

                        <!-- Availability Status -->
                        <div class="hidden p-4 rounded-lg mb-6" id="availabilityStatus">
                            <!-- Availability status will be shown here -->
                        </div>
                    </form>
                </div>

                <div class="p-6 border-t border-gray-200 flex justify-end gap-3">
                    <button type="button" onclick="closeSchedulingModal()" class="px-4 py-2 text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg font-medium transition-colors">
                        Hủy
                    </button>
                    <button type="button" onclick="checkAvailability()" class="px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white rounded-lg font-medium transition-colors flex items-center gap-2">
                        <i data-lucide="search" class="h-4 w-4"></i>
                        Kiểm tra lịch trống
                    </button>
                    <button type="button" onclick="createBooking()" id="createBookingBtn" disabled class="px-4 py-2 bg-green-500 hover:bg-green-600 text-white rounded-lg font-medium transition-colors flex items-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed">
                        <i data-lucide="check" class="h-4 w-4"></i>
                        Đặt lịch
                    </button>
                </div>
            </div>
        </div>
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

            // DataTables will be initialized by manager-scheduling.js
        });

        // Modal functions
        function openSchedulingModal(paymentItemId) {
            document.getElementById('schedulingModal').classList.remove('hidden');
            document.getElementById('paymentItemId').value = paymentItemId;
            // Load item details and populate modal
            loadSchedulingItemDetails(paymentItemId);
        }

        function closeSchedulingModal() {
            document.getElementById('schedulingModal').classList.add('hidden');
            document.getElementById('schedulingForm').reset();
            document.getElementById('availabilityStatus').classList.add('hidden');
            document.getElementById('createBookingBtn').disabled = true;
        }

        function checkAvailability() {
            // Implementation for checking availability
            console.log('Checking availability...');
        }

        function createBooking() {
            // Implementation for creating booking
            console.log('Creating booking...');
        }

        function loadSchedulingItemDetails(paymentItemId) {
            // Implementation for loading item details
            console.log('Loading item details for:', paymentItemId);
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

        console.log('Manager Scheduling Page Loaded Successfully');
    </script>

    <!-- Manager Scheduling JavaScript -->
    <script src="${pageContext.request.contextPath}/js/manager-scheduling.js"></script>
</body>
</html>
