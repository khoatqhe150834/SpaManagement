<%-- src/main/webapp/reschedule.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thay Đổi Lịch Hẹn - Spa Hương Sen</title>

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

    <!-- Flatpickr CSS -->
    <link href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css" rel="stylesheet">

    <style>
        /* Same styles as booking.jsp */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .fade-in {
            animation: fadeIn 0.5s ease-out;
        }

        .slide-in {
            animation: slideIn 0.3s ease-out;
        }

        .step-indicator {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 0.5rem;
        }

        .step {
            display: flex;
            align-items: center;
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            font-weight: 500;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            position: relative;
        }

        .step.active {
            background: linear-gradient(135deg, #D4AF37, #B8941F);
            color: white;
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
        }

        .step.completed {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
        }

        .step.inactive {
            background-color: #f3f4f6;
            color: #6b7280;
        }

        .step.completed::after {
            content: '✓';
            position: absolute;
            right: 0.5rem;
            font-weight: bold;
        }

        .time-slot {
            padding: 0.75rem 1rem;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            background: white;
        }

        .time-slot:hover {
            border-color: #D4AF37;
            background: #FFF8F0;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(212, 175, 55, 0.2);
        }

        .time-slot.selected {
            background: linear-gradient(135deg, #D4AF37, #B8941F);
            color: white;
            border-color: #D4AF37;
            box-shadow: 0 6px 20px rgba(212, 175, 55, 0.4);
        }

        .time-slot.original {
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            color: white;
            border-color: #6366f1;
        }

        .time-slot.original:hover {
            background: linear-gradient(135deg, #4f46e5, #3730a3);
        }

        .resource-option {
            padding: 1rem;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
            margin-bottom: 0.75rem;
        }

        .resource-option:hover {
            border-color: #D4AF37;
            background: #FFF8F0;
            transform: translateY(-1px);
        }

        .resource-option.selected {
            background: linear-gradient(135deg, #D4AF37, #B8941F);
            color: white;
            border-color: #D4AF37;
        }

        .resource-option.original {
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            color: white;
            border-color: #6366f1;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .animate-spin {
            animation: spin 1s linear infinite;
        }

        .custom-scrollbar::-webkit-scrollbar {
            width: 6px;
        }

        .custom-scrollbar::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: #D4AF37;
            border-radius: 10px;
        }

        .custom-scrollbar::-webkit-scrollbar-thumb:hover {
            background: #B8941F;
        }

        .flatpickr-calendar {
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            border: 1px solid #e5e7eb;
        }

        .flatpickr-day.selected {
            background: #D4AF37;
            border-color: #D4AF37;
        }

        .flatpickr-day:hover {
            background: #FFF8F0;
            border-color: #D4AF37;
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
                                <img class="w-8 h-8 rounded-full object-cover" src="https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=100" alt="User Avatar"/>
                                <div class="top-0 left-7 absolute w-3 h-3 bg-green-400 border-2 border-white rounded-full animate-ping"></div>
                                <div class="top-0 left-7 absolute w-3 h-3 bg-green-500 border-2 border-white rounded-full"></div>
                            </div>
                        </div>
                        <div class="p-2 md:block text-left">
                            <h2 class="text-sm font-semibold text-spa-dark">${sessionScope.user.fullName}</h2>
                            <p class="text-xs text-primary/70">
                                <c:choose>
                                    <c:when test="${isManagerAccess}">Quản lý</c:when>
                                    <c:otherwise>Khách hàng</c:otherwise>
                                </c:choose>
                            </p>
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
            <!-- Page Header -->
            <div class="mb-8">
                <div class="flex items-center gap-3 mb-2">
                    <div class="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center">
                        <i data-lucide="calendar-days" class="h-6 w-6 text-orange-600"></i>
                    </div>
                    <div>
                        <h1 class="text-2xl font-bold text-spa-dark">🔄 Thay Đổi Lịch Hẹn</h1>
                        <p class="text-gray-600">Chọn ngày và thời gian mới cho lịch hẹn của bạn</p>
                    </div>
                </div>
                
                <!-- Back button -->
                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/customer/show-bookings" 
                       class="inline-flex items-center gap-2 px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-all duration-200">
                        <i data-lucide="arrow-left" class="h-4 w-4"></i>
                        Quay lại danh sách lịch hẹn
                    </a>
                </div>
            </div>

            <!-- Current Booking Information -->
            <div class="bg-white rounded-xl shadow-lg border border-primary/10 overflow-hidden mb-6">
                <div class="bg-gradient-to-r from-blue-50 to-indigo-50 p-6 border-b border-blue-200">
                    <h3 class="text-lg font-semibold text-blue-800 mb-4 flex items-center gap-2">
                        <i data-lucide="info" class="h-5 w-5"></i>
                        Thông tin lịch hẹn hiện tại
                    </h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 text-sm">
                        <div class="bg-white rounded-lg p-3 border border-blue-200">
                            <span class="text-blue-600 font-medium">Dịch vụ:</span>
                            <p class="text-blue-800 font-semibold">${booking.service.serviceName}</p>
                        </div>
                        <div class="bg-white rounded-lg p-3 border border-blue-200">
                            <span class="text-blue-600 font-medium">Ngày hiện tại:</span>
                            <p class="text-blue-800 font-semibold">
                                <fmt:formatDate value="${booking.appointmentDate}" pattern="dd/MM/yyyy" />
                            </p>
                        </div>
                        <div class="bg-white rounded-lg p-3 border border-blue-200">
                            <span class="text-blue-600 font-medium">Giờ hiện tại:</span>
                            <p class="text-blue-800 font-semibold">
                                <fmt:formatDate value="${booking.appointmentTime}" pattern="HH:mm" />
                            </p>
                        </div>
                        <div class="bg-white rounded-lg p-3 border border-blue-200">
                            <span class="text-blue-600 font-medium">Thời gian:</span>
                            <p class="text-blue-800 font-semibold">${booking.durationMinutes} phút</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Reschedule Form -->
            <div class="bg-white rounded-xl shadow-lg border border-primary/10 overflow-hidden">
                <!-- Step Indicator -->
                <div class="bg-gradient-to-r from-spa-cream to-white p-6 border-b border-primary/10">
                    <div class="step-indicator">
                        <span class="step active" id="step1">
                            <i data-lucide="calendar" class="h-4 w-4 mr-2"></i>
                            Chọn ngày mới
                        </span>
                        <span class="step inactive" id="step2">
                            <i data-lucide="clock" class="h-4 w-4 mr-2"></i>
                            Chọn giờ mới
                        </span>
                        <span class="step inactive" id="step3">
                            <i data-lucide="users" class="h-4 w-4 mr-2"></i>
                            Chọn tài nguyên mới
                        </span>
                        <span class="step inactive" id="step4">
                            <i data-lucide="check-circle" class="h-4 w-4 mr-2"></i>
                            Xác nhận thay đổi
                        </span>
                    </div>
                </div>

                <div class="p-6">
                    <!-- Step 1: Date Selection -->
                    <div id="dateSelection" class="step-content fade-in">
                        <div class="mb-6">
                            <h3 class="text-xl font-semibold text-spa-dark mb-2 flex items-center gap-2">
                                <i data-lucide="calendar" class="h-5 w-5 text-primary"></i>
                                Bước 1: Chọn ngày mới
                            </h3>
                            <p class="text-gray-600">Chọn ngày bạn muốn thay đổi lịch hẹn</p>
                        </div>

                        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                            <div>
                                <label for="appointmentDate" class="block text-sm font-medium text-gray-700 mb-2">Chọn ngày mới:</label>
                                <input type="text" id="appointmentDate" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all duration-200" 
                                       placeholder="Nhấp để chọn ngày" readonly>
                            </div>
                        </div>

                        <div class="flex flex-wrap gap-3 mt-6">
                            <button type="button" class="px-6 py-3 bg-gradient-to-r from-primary to-primary-dark text-white rounded-lg hover:shadow-lg transition-all duration-200 font-medium disabled:opacity-50 disabled:cursor-not-allowed" id="continueToTime" onclick="loadAvailableSlotsForReschedule()" disabled>
                                <i data-lucide="clock" class="h-4 w-4 mr-2 inline"></i>
                                Tải thời gian khả dụng
                            </button>
                        </div>
                    </div>

                    <!-- Step 2: Time Selection -->
                    <div id="timeSelection" class="step-content fade-in" style="display: none;">
                        <div class="mb-6">
                            <h3 class="text-xl font-semibold text-spa-dark mb-2 flex items-center gap-2">
                                <i data-lucide="clock" class="h-5 w-5 text-primary"></i>
                                Bước 2: Chọn giờ mới
                            </h3>
                            <p class="text-gray-600">Chọn khung giờ mới cho lịch hẹn của bạn</p>
                        </div>

                        <div id="loadingSlots" class="text-center py-12" style="display: none;">
                            <div class="inline-flex items-center gap-3 text-primary">
                                <div class="w-8 h-8 border-2 border-primary border-t-transparent rounded-full animate-spin"></div>
                                <span class="text-lg font-medium">Đang tải thời gian khả dụng...</span>
                            </div>
                        </div>

                        <div id="availableSlots" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3 mb-6"></div>

                        <div class="flex flex-wrap gap-3">
                            <button type="button" class="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-all duration-200 font-medium" onclick="previousStep(1)">
                                <i data-lucide="arrow-left" class="h-4 w-4 mr-2 inline"></i>
                                Quay lại
                            </button>
                            <button type="button" class="px-6 py-3 bg-gradient-to-r from-primary to-primary-dark text-white rounded-lg hover:shadow-lg transition-all duration-200 font-medium disabled:opacity-50 disabled:cursor-not-allowed" id="continueToResources" onclick="loadAvailableResourcesForReschedule()" disabled>
                                <i data-lucide="users" class="h-4 w-4 mr-2 inline"></i>
                                Chọn tài nguyên
                            </button>
                        </div>
                    </div>

                    <!-- Step 3: Resource Selection -->
                    <div id="resourceSelection" class="step-content fade-in" style="display: none;">
                        <div class="mb-6">
                            <h3 class="text-xl font-semibold text-spa-dark mb-2 flex items-center gap-2">
                                <i data-lucide="users" class="h-5 w-5 text-primary"></i>
                                Bước 3: Chọn nhân viên và phòng mới
                            </h3>
                            <p class="text-gray-600">Chọn nhân viên massage, phòng và giường mới</p>
                        </div>

                        <div id="selectedTimeInfo" class="bg-gradient-to-r from-green-50 to-emerald-50 border border-green-200 rounded-xl p-4 mb-6"></div>

                        <div id="loadingResources" class="text-center py-12" style="display: none;">
                            <div class="inline-flex items-center gap-3 text-primary">
                                <div class="w-8 h-8 border-2 border-primary border-t-transparent rounded-full animate-spin"></div>
                                <span class="text-lg font-medium">Đang tải tài nguyên khả dụng...</span>
                            </div>
                        </div>

                        <div id="availableResources" class="space-y-4 mb-6"></div>

                        <div class="flex flex-wrap gap-3">
                            <button type="button" class="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-all duration-200 font-medium" onclick="previousStep(2)">
                                <i data-lucide="arrow-left" class="h-4 w-4 mr-2 inline"></i>
                                Quay lại
                            </button>
                            <button type="button" class="px-6 py-3 bg-gradient-to-r from-orange-500 to-amber-600 text-white rounded-lg hover:shadow-lg transition-all duration-200 font-medium disabled:opacity-50 disabled:cursor-not-allowed" id="continueToConfirm" onclick="nextStepToConfirmation(4)" disabled>
                                <i data-lucide="check-circle" class="h-4 w-4 mr-2 inline"></i>
                                Xem lại thay đổi
                            </button>
                        </div>
                    </div>

                    <!-- Step 4: Confirmation -->
                    <div id="confirmation" class="step-content fade-in" style="display: none;">
                        <div class="mb-6">
                            <h3 class="text-xl font-semibold text-spa-dark mb-2 flex items-center gap-2">
                                <i data-lucide="check-circle" class="h-5 w-5 text-primary"></i>
                                Bước 4: Xác nhận thay đổi lịch hẹn
                            </h3>
                            <p class="text-gray-600">Kiểm tra lại thông tin và xác nhận thay đổi</p>
                        </div>

                        <!-- Comparison View -->
                        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
                            <!-- Original Booking -->
                            <div class="bg-gradient-to-br from-blue-50 to-indigo-50 rounded-xl border border-blue-200 p-6">
                                <h4 class="text-lg font-semibold text-blue-800 mb-4 flex items-center gap-2">
                                    <i data-lucide="calendar-x" class="h-5 w-5"></i>
                                    Lịch hẹn hiện tại
                                </h4>
                                <div id="originalBookingInfo" class="space-y-3 text-sm"></div>
                            </div>

                            <!-- New Booking -->
                            <div class="bg-gradient-to-br from-green-50 to-emerald-50 rounded-xl border border-green-200 p-6">
                                <h4 class="text-lg font-semibold text-green-800 mb-4 flex items-center gap-2">
                                    <i data-lucide="calendar-check" class="h-5 w-5"></i>
                                    Lịch hẹn mới
                                </h4>
                                <div id="newBookingInfo" class="space-y-3 text-sm"></div>
                            </div>
                        </div>

                        <!-- Reason Input -->
                        <div class="mb-6">
                            <label for="rescheduleReason" class="block text-sm font-medium text-gray-700 mb-2">
                                Lý do thay đổi (tùy chọn):
                            </label>
                            <textarea id="rescheduleReason" rows="3" 
                                      class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all duration-200" 
                                      placeholder="Nhập lý do thay đổi lịch hẹn..."></textarea>
                        </div>
                        
                        <div class="flex flex-wrap gap-3 pt-6 border-t border-primary/10">
                            <button type="button" class="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-all duration-200 font-medium" onclick="previousStep(3)">
                                <i data-lucide="arrow-left" class="h-4 w-4 mr-2 inline"></i>
                                Quay lại
                            </button>
                            <button type="button" class="px-8 py-3 bg-gradient-to-r from-orange-500 to-amber-600 text-white rounded-lg hover:shadow-lg transition-all duration-200 font-medium text-lg" onclick="confirmReschedule()">
                                <span id="rescheduleButtonText" class="flex items-center gap-2">
                                    <i data-lucide="calendar-check" class="h-5 w-5"></i>
                                    Xác nhận thay đổi lịch hẹn
                                </span>
                                <span id="rescheduleSpinner" class="hidden">
                                    <div class="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin inline-block mr-2"></div>
                                    Đang xử lý...
                                </span>
                            </button>
                        </div>
                    </div>

                    <!-- Success Message -->
                    <div id="successMessage" class="step-content fade-in" style="display: none;">
                        <div class="text-center py-12">
                            <div class="w-20 h-20 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-6">
                                <i data-lucide="check" class="h-10 w-10 text-white"></i>
                            </div>
                            <h3 class="text-2xl font-bold text-green-800 mb-4">🎉 Thay đổi lịch hẹn thành công!</h3>
                            <div id="successDetails" class="bg-green-50 border border-green-200 rounded-xl p-6 mb-6 text-left max-w-2xl mx-auto"></div>
                            <div class="flex flex-wrap justify-center gap-3">
                                <a href="${pageContext.request.contextPath}/customer/show-bookings" 
                                   class="px-6 py-3 bg-gradient-to-r from-primary to-primary-dark text-white rounded-lg hover:shadow-lg transition-all duration-200 font-medium">
                                    <i data-lucide="list" class="h-4 w-4 mr-2 inline"></i>
                                    Xem danh sách lịch hẹn
                                </a>
                                <button type="button" class="px-6 py-3 border