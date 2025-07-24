<%-- src/main/webapp/booking.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lịch Hẹn - Spa Hương Sen</title>

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
        /* Custom animations */
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

        /* Step indicator styles */
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

        /* Time slot styles */
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

        /* Resource option styles */
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

        /* Loading animation */
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .animate-spin {
            animation: spin 1s linear infinite;
        }

        /* Custom scrollbar */
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

        /* Flatpickr custom styling */
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
                            <p class="text-xs text-primary/70">Khách hàng</p>
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
                    <div class="w-12 h-12 bg-primary/10 rounded-xl flex items-center justify-center">
                        <i data-lucide="calendar-plus" class="h-6 w-6 text-primary"></i>
                    </div>
                    <div>
                        <h1 class="text-2xl font-bold text-spa-dark">🌺 Đặt Lịch Hẹn Spa</h1>
                        <p class="text-gray-600">Chọn dịch vụ và thời gian phù hợp với bạn</p>
                    </div>
                </div>
            </div>

            <!-- Booking Container -->
            <div class="bg-white rounded-xl shadow-lg border border-primary/10 overflow-hidden">
                <!-- Step Indicator -->
                <div class="bg-gradient-to-r from-spa-cream to-white p-6 border-b border-primary/10">
                    <div class="step-indicator">
                        <span class="step <c:choose><c:when test='${not empty selectedPaymentItem}'>completed</c:when><c:otherwise>active</c:otherwise></c:choose>" id="step1">
                            <i data-lucide="<c:choose><c:when test='${not empty selectedPaymentItem}'>check</c:when><c:otherwise>shopping-bag</c:otherwise></c:choose>" class="h-4 w-4 mr-2"></i>
                            <c:choose>
                                <c:when test="${not empty selectedPaymentItem}">Đã chọn dịch vụ</c:when>
                                <c:otherwise>Chọn dịch vụ</c:otherwise>
                            </c:choose>
                        </span>
                        <span class="step <c:choose><c:when test='${not empty selectedPaymentItem}'>active</c:when><c:otherwise>inactive</c:otherwise></c:choose>" id="step2">
                            <i data-lucide="calendar" class="h-4 w-4 mr-2"></i>
                            Chọn ngày
                        </span>
                        <span class="step inactive" id="step3">
                            <i data-lucide="clock" class="h-4 w-4 mr-2"></i>
                            Chọn giờ
                        </span>
                        <span class="step inactive" id="step4">
                            <i data-lucide="users" class="h-4 w-4 mr-2"></i>
                            Chọn tài nguyên
                        </span>
                        <span class="step inactive" id="step5">
                            <i data-lucide="check-circle" class="h-4 w-4 mr-2"></i>
                            Xác nhận
                        </span>
                    </div>
                </div>

                <div class="p-6">
                    <!-- Step 1: Service Selection -->
                    <div id="serviceSelection" class="step-content fade-in" <c:if test="${not empty selectedPaymentItem}">style="display: none;"</c:if>>
                        <div class="mb-6">
                            <h3 class="text-xl font-semibold text-spa-dark mb-2 flex items-center gap-2">
                                <i data-lucide="shopping-bag" class="h-5 w-5 text-primary"></i>
                                Bước 1: Chọn dịch vụ
                            </h3>
                            <p class="text-gray-600">Chọn từ các dịch vụ đã thanh toán của bạn</p>
                        </div>

                        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                            <div class="lg:col-span-2">
                                <c:choose>
                                    <c:when test="${not empty selectedPaymentItem}">
                                        <!-- Display selected service information -->
                                        <div class="bg-gradient-to-r from-green-50 to-emerald-50 border border-green-200 rounded-xl p-6">
                                            <div class="flex items-start gap-4">
                                                <div class="w-12 h-12 bg-green-500 rounded-xl flex items-center justify-center">
                                                    <i data-lucide="check" class="h-6 w-6 text-white"></i>
                                                </div>
                                                <div class="flex-1">
                                                    <h5 class="text-lg font-semibold text-green-800 mb-2">🌺 Dịch vụ đã chọn</h5>
                                                    <div class="space-y-2 text-sm">
                                                        <p><strong class="text-green-700">Dịch vụ:</strong> <span class="text-green-600">${selectedPaymentItem.serviceName}</span></p>
                                                        <p><strong class="text-green-700">Số buổi còn lại:</strong> <span class="text-green-600">${selectedPaymentItem.remainingQuantity}/${selectedPaymentItem.quantity}</span></p>
                                                        <p><strong class="text-green-700">Thời gian:</strong> <span class="text-green-600">${selectedPaymentItem.serviceDuration} phút</span></p>
                                                        <p><strong class="text-green-700">Giá:</strong> <span class="text-green-600"><fmt:formatNumber value='${selectedPaymentItem.unitPrice}' type='currency' currencySymbol='₫'/></span></p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${not empty paymentItems}">
                                        <div class="space-y-4">
                                            <label for="paymentItemSelect" class="block text-sm font-medium text-gray-700">Chọn dịch vụ:</label>
                                            <select id="paymentItemSelect" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all duration-200" onchange="selectPaymentItem()">
                                                <option value="">-- Chọn một dịch vụ --</option>
                                                <c:forEach var="item" items="${paymentItems}">
                                                    <option value="${item.paymentItemId}"
                                                            data-service-name="${item.serviceName}"
                                                            data-quantity="${item.quantity}"
                                                            data-booked="${item.bookedQuantity}"
                                                            data-remaining="${item.remainingQuantity}"
                                                            data-duration="${item.serviceDuration}"
                                                            data-buffer="${item.bufferTime}"
                                                            data-price="<fmt:formatNumber value='${item.unitPrice}' type='currency' currencySymbol='₫'/>">
                                                        ${item.serviceName} (${item.remainingQuantity}/${item.quantity} còn lại)
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="bg-gradient-to-r from-yellow-50 to-amber-50 border border-yellow-200 rounded-xl p-6">
                                            <div class="flex items-start gap-4">
                                                <div class="w-12 h-12 bg-yellow-500 rounded-xl flex items-center justify-center">
                                                    <i data-lucide="alert-triangle" class="h-6 w-6 text-white"></i>
                                                </div>
                                                <div>
                                                    <h5 class="text-lg font-semibold text-yellow-800 mb-2">Không có dịch vụ khả dụng</h5>
                                                    <p class="text-yellow-700">Bạn chưa có dịch vụ nào đã thanh toán. Vui lòng thanh toán trước khi đặt lịch.</p>
                                                </div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Service Information Panel -->
                            <div class="lg:col-span-1">
                                <div id="serviceInfo" class="bg-gradient-to-br from-spa-cream to-white rounded-xl p-6 border border-primary/20" style="display: none;">
                                    <h4 class="text-lg font-semibold text-spa-dark mb-4 flex items-center gap-2">
                                        <i data-lucide="info" class="h-5 w-5 text-primary"></i>
                                        Thông tin dịch vụ
                                    </h4>
                                    <div class="space-y-3 text-sm">
                                        <div class="flex justify-between">
                                            <span class="text-gray-600">Dịch vụ:</span>
                                            <span class="font-medium" id="infoServiceName">-</span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span class="text-gray-600">Thời gian:</span>
                                            <span class="font-medium" id="infoDuration">-</span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span class="text-gray-600">Thời gian nghỉ:</span>
                                            <span class="font-medium" id="infoBuffer">-</span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span class="text-gray-600">Giá:</span>
                                            <span class="font-medium text-primary" id="infoPrice">-</span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span class="text-gray-600">Số buổi còn lại:</span>
                                            <span class="font-medium text-green-600" id="infoRemaining">-</span>
                                        </div>
                                        <div class="flex justify-between">
                                            <span class="text-gray-600">Tổng thời gian:</span>
                                            <span class="font-medium" id="infoTotalTime">-</span>
                                        </div>
                                    </div>
                                    <button type="button" class="w-full mt-6 bg-gradient-to-r from-primary to-primary-dark text-white py-3 px-4 rounded-lg hover:shadow-lg transition-all duration-200 font-medium" onclick="nextStep(2)">
                                        <i data-lucide="arrow-right" class="h-4 w-4 mr-2 inline"></i>
                                        Tiếp tục chọn ngày
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Step 2: Date Selection -->
                    <div id="dateSelection" class="step-content fade-in" <c:choose><c:when test="${not empty selectedPaymentItem}">style="display: block;"</c:when><c:otherwise>style="display: none;"</c:otherwise></c:choose>>
                        <div class="mb-6">
                            <h3 class="text-xl font-semibold text-spa-dark mb-2 flex items-center gap-2">
                                <i data-lucide="calendar" class="h-5 w-5 text-primary"></i>
                                Bước 2: Chọn ngày hẹn
                            </h3>
                            <p class="text-gray-600">Chọn ngày bạn muốn đến spa</p>
                        </div>

                        <!-- Show selected service summary when pre-selected -->
                        <c:if test="${not empty selectedPaymentItem}">
                            <div class="bg-gradient-to-r from-blue-50 to-indigo-50 border border-blue-200 rounded-xl p-4 mb-6">
                                <div class="flex items-center gap-3">
                                    <div class="w-8 h-8 bg-blue-500 rounded-lg flex items-center justify-center">
                                        <i data-lucide="check" class="h-4 w-4 text-white"></i>
                                    </div>
                                    <div>
                                        <h6 class="font-semibold text-blue-800">✅ Dịch vụ đã chọn: <strong>${selectedPaymentItem.serviceName}</strong></h6>
                                        <p class="text-sm text-blue-600">Thời gian: ${selectedPaymentItem.serviceDuration} phút | Còn lại: ${selectedPaymentItem.remainingQuantity}/${selectedPaymentItem.quantity} buổi</p>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                            <div>
                                <label for="appointmentDate" class="block text-sm font-medium text-gray-700 mb-2">Chọn ngày:</label>
                                <input type="text" id="appointmentDate" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all duration-200" 
                                       placeholder="Nhấp để chọn ngày" readonly>
                            </div>
                        </div>

                        <div class="flex flex-wrap gap-3 mt-6">
                            <button type="button" class="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-all duration-200 font-medium" onclick="previousStep(1)">
                                <i data-lucide="arrow-left" class="h-4 w-4 mr-2 inline"></i>
                                Quay lại
                            </button>
                            <button type="button" class="px-6 py-3 bg-gradient-to-r from-primary to-primary-dark text-white rounded-lg hover:shadow-lg transition-all duration-200 font-medium disabled:opacity-50 disabled:cursor-not-allowed" id="continueToTime" onclick="loadAvailableSlots()" disabled>
                                <i data-lucide="clock" class="h-4 w-4 mr-2 inline"></i>
                                Tải thời gian khả dụng
                            </button>
                        </div>
                    </div>

                    <!-- Step 3: Time Selection -->
                    <div id="timeSelection" class="step-content fade-in" style="display: none;">
                        <div class="mb-6">
                            <h3 class="text-xl font-semibold text-spa-dark mb-2 flex items-center gap-2">
                                <i data-lucide="clock" class="h-5 w-5 text-primary"></i>
                                Bước 3: Chọn giờ hẹn
                            </h3>
                            <p class="text-gray-600">Chọn khung giờ phù hợp với lịch trình của bạn</p>
                        </div>

                        <div id="loadingSlots" class="text-center py-12" style="display: none;">
                            <div class="inline-flex items-center gap-3 text-primary">
                                <div class="w-8 h-8 border-2 border-primary border-t-transparent rounded-full animate-spin"></div>
                                <span class="text-lg font-medium">Đang tải thời gian khả dụng...</span>
                            </div>
                        </div>

                        <div id="availableSlots" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3 mb-6"></div>

                        <div class="flex flex-wrap gap-3">
                            <button type="button" class="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-all duration-200 font-medium" onclick="previousStep(2)">
                                <i data-lucide="arrow-left" class="h-4 w-4 mr-2 inline"></i>
                                Quay lại
                            </button>
                            <button type="button" class="px-6 py-3 bg-gradient-to-r from-primary to-primary-dark text-white rounded-lg hover:shadow-lg transition-all duration-200 font-medium disabled:opacity-50 disabled:cursor-not-allowed" id="continueToResources" onclick="loadAvailableResources()" disabled>
                                <i data-lucide="users" class="h-4 w-4 mr-2 inline"></i>
                                Chọn tài nguyên
                            </button>
                        </div>
                    </div>

                    <!-- Step 4: Resource Selection -->
                    <div id="resourceSelection" class="step-content fade-in" style="display: none;">
                        <div class="mb-6">
                            <h3 class="text-xl font-semibold text-spa-dark mb-2 flex items-center gap-2">
                                <i data-lucide="users" class="h-5 w-5 text-primary"></i>
                                Bước 4: Chọn nhân viên và phòng
                            </h3>
                            <p class="text-gray-600">Chọn nhân viên massage, phòng và giường phù hợp</p>
                        </div>

                        <div id="selectedTimeInfo" class="bg-gradient-to-r from-blue-50 to-indigo-50 border border-blue-200 rounded-xl p-4 mb-6"></div>

                        <div id="loadingResources" class="text-center py-12" style="display: none;">
                            <div class="inline-flex items-center gap-3 text-primary">
                                <div class="w-8 h-8 border-2 border-primary border-t-transparent rounded-full animate-spin"></div>
                                <span class="text-lg font-medium">Đang tải tài nguyên khả dụng...</span>
                            </div>
                        </div>

                        <div id="availableResources" class="space-y-4 mb-6"></div>

                        <div class="flex flex-wrap gap-3">
                            <button type="button" class="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-all duration-200 font-medium" onclick="previousStep(3)">
                                <i data-lucide="arrow-left" class="h-4 w-4 mr-2 inline"></i>
                                Quay lại
                            </button>
                            <button type="button" class="px-6 py-3 bg-gradient-to-r from-green-500 to-emerald-600 text-white rounded-lg hover:shadow-lg transition-all duration-200 font-medium disabled:opacity-50 disabled:cursor-not-allowed" id="continueToConfirm" onclick="nextStepToConfirmation(5)" disabled>
                                <i data-lucide="check-circle" class="h-4 w-4 mr-2 inline"></i>
                                Xem lại đặt lịch
                            </button>
                        </div>
                    </div>

                    <!-- Step 5: Confirmation -->
                    <div id="confirmation" class="step-content fade-in" style="display: none;">
                        <div class="mb-6">
                            <h3 class="text-xl font-semibold text-spa-dark mb-2 flex items-center gap-2">
                                <i data-lucide="check-circle" class="h-5 w-5 text-primary"></i>
                                Bước 5: Xác nhận đặt lịch
                            </h3>
                            <p class="text-gray-600">Kiểm tra lại thông tin và xác nhận đặt lịch</p>
                        </div>

                        <div class="bg-gradient-to-br from-spa-cream to-white rounded-xl border border-primary/20 p-6">
                            <h4 class="text-lg font-semibold text-spa-dark mb-4 flex items-center gap-2">
                                <i data-lucide="file-text" class="h-5 w-5 text-primary"></i>
                                Tóm tắt đặt lịch
                            </h4>
                            <div id="bookingSummary" class="space-y-4"></div>
                            
                            <div class="flex flex-wrap gap-3 mt-6 pt-6 border-t border-primary/10">
                                <button type="button" class="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-all duration-200 font-medium" onclick="previousStep(4)">
                                    <i data-lucide="arrow-left" class="h-4 w-4 mr-2 inline"></i>
                                    Quay lại
                                </button>
                                <button type="button" class="px-8 py-3 bg-gradient-to-r from-green-500 to-emerald-600 text-white rounded-lg hover:shadow-lg transition-all duration-200 font-medium text-lg" onclick="confirmBooking()">
                                    <span id="bookingButtonText" class="flex items-center gap-2">
                                        <i data-lucide="check" class="h-5 w-5"></i>
                                        Xác nhận đặt lịch
                                    </span>
                                    <span id="bookingSpinner" class="hidden">
                                        <div class="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin inline-block mr-2"></div>
                                        Đang xử lý...
                                    </span>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Success Message -->
                    <div id="successMessage" class="step-content fade-in" style="display: none;">
                        <div class="text-center py-12">
                            <div class="w-20 h-20 bg-green-500 rounded-full flex items-center justify-center mx-auto mb-6">
                                <i data-lucide="check" class="h-10 w-10 text-white"></i>
                            </div>
                            <h3 class="text-2xl font-bold text-green-800 mb-4">🎉 Đặt lịch thành công!</h3>
                            <div id="successDetails" class="bg-green-50 border border-green-200 rounded-xl p-6 mb-6 text-left max-w-2xl mx-auto"></div>
                            <div class="flex flex-wrap justify-center gap-3">
                                <button type="button" class="px-6 py-3 bg-gradient-to-r from-primary to-primary-dark text-white rounded-lg hover:shadow-lg transition-all duration-200 font-medium" onclick="bookAnother()">
                                    <i data-lucide="plus" class="h-4 w-4 mr-2 inline"></i>
                                    Đặt thêm buổi khác
                                </button>
                                <button type="button" class="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-all duration-200 font-medium" onclick="location.reload()">
                                    <i data-lucide="refresh-cw" class="h-4 w-4 mr-2 inline"></i>
                                    Bắt đầu lại
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Hidden data for pre-selected service -->
    <c:if test="${not empty selectedPaymentItem}">
        <div id="preSelectedServiceData" style="display: none;"
             data-id="${selectedPaymentItem.paymentItemId}"
             data-service-name="${selectedPaymentItem.serviceName}"
             data-quantity="${selectedPaymentItem.quantity}"
             data-booked="${selectedPaymentItem.bookedQuantity}"
             data-remaining="${selectedPaymentItem.remainingQuantity}"
             data-duration="${selectedPaymentItem.serviceDuration}"
             data-buffer="${selectedPaymentItem.bufferTime}"
             data-price="<fmt:formatNumber value='${selectedPaymentItem.unitPrice}' type='currency' currencySymbol='₫'/>">
        </div>
    </c:if>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="<c:url value='/js/booking-page.js'/>"></script>
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
        });

        // Initialize page - check if service is pre-selected
        function initializePage() {
            const preSelectedData = document.getElementById('preSelectedServiceData');
            if (preSelectedData) {
                // Pre-populate selectedPaymentItem from server data
                const paymentItemData = {
                    id: parseInt(preSelectedData.dataset.id),
                    serviceName: preSelectedData.dataset.serviceName,
                    quantity: parseInt(preSelectedData.dataset.quantity),
                    booked: parseInt(preSelectedData.dataset.booked),
                    remaining: parseInt(preSelectedData.dataset.remaining),
                    duration: parseInt(preSelectedData.dataset.duration),
                    buffer: parseInt(preSelectedData.dataset.buffer),
                    price: preSelectedData.dataset.price
                };

                // Check if function is available and initialize
                if (typeof initializePreSelectedService === 'function') {
                    initializePreSelectedService(paymentItemData);
                }
            }
        }

        // Multiple initialization attempts to ensure reliability
        document.addEventListener('DOMContentLoaded', function() {
            // Wait for external script to load
            let attempts = 0;
            const maxAttempts = 10;

            function tryInitialize() {
                attempts++;
                if (typeof initializePreSelectedService !== 'undefined') {
                    initializePage();
                } else if (attempts < maxAttempts) {
                    setTimeout(tryInitialize, 50);
                } else {
                    console.error('Failed to load booking-page.js functions after', maxAttempts, 'attempts');
                }
            }

            tryInitialize();
        });
    </script>
</body>
</html>