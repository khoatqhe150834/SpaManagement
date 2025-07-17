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
        /* Custom styling for booking page */
        .booking-step {
            transition: all 0.3s ease;
        }
        
        .booking-step.active {
            border-color: #D4AF37;
            background-color: rgba(212, 175, 55, 0.1);
        }
        
        .service-card {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .service-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        
        .service-card.selected {
            border-color: #D4AF37;
            background-color: rgba(212, 175, 55, 0.1);
        }
        
        .therapist-card {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .therapist-card:hover {
            transform: translateY(-2px);
        }
        
        .therapist-card.selected {
            border-color: #D4AF37;
            background-color: rgba(212, 175, 55, 0.1);
        }
        
        .time-slot {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .time-slot:hover {
            background-color: rgba(212, 175, 55, 0.1);
        }
        
        .time-slot.selected {
            background-color: #D4AF37;
            color: white;
        }
        
        .time-slot.unavailable {
            background-color: #f3f4f6;
            color: #9ca3af;
            cursor: not-allowed;
        }
        
        /* Calendar styling */
        .calendar-day {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .calendar-day:hover {
            background-color: rgba(212, 175, 55, 0.1);
        }
        
        .calendar-day.selected {
            background-color: #D4AF37;
            color: white;
        }
        
        .calendar-day.disabled {
            background-color: #f9fafb;
            color: #d1d5db;
            cursor: not-allowed;
        }
        
        /* Progress bar styling */
        .progress-bar {
            background: linear-gradient(90deg, #D4AF37 0%, #B8941F 100%);
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
        <div class="max-w-6xl mx-auto">
            <!-- Page Header -->
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-spa-dark mb-2">Đặt Lịch Dịch Vụ</h1>
                <p class="text-gray-600">Chọn dịch vụ đã thanh toán và đặt lịch hẹn với kỹ thuật viên</p>
            </div>
            
            <!-- Progress Steps -->
            <div class="mb-8">
                <div class="flex items-center justify-between">
                    <div class="booking-step active flex items-center p-4 rounded-lg border-2 border-gray-200" id="step1">
                        <div class="w-8 h-8 bg-primary text-white rounded-full flex items-center justify-center mr-3">1</div>
                        <span class="font-medium">Chọn Dịch Vụ</span>
                    </div>
                    <div class="flex-1 h-1 bg-gray-200 mx-4">
                        <div class="h-full progress-bar" style="width: 0%" id="progressBar"></div>
                    </div>
                    <div class="booking-step flex items-center p-4 rounded-lg border-2 border-gray-200" id="step2">
                        <div class="w-8 h-8 bg-gray-300 text-gray-600 rounded-full flex items-center justify-center mr-3">2</div>
                        <span class="font-medium">Chọn Ngày</span>
                    </div>
                    <div class="flex-1 h-1 bg-gray-200 mx-4">
                        <div class="h-full progress-bar" style="width: 0%"></div>
                    </div>
                    <div class="booking-step flex items-center p-4 rounded-lg border-2 border-gray-200" id="step3">
                        <div class="w-8 h-8 bg-gray-300 text-gray-600 rounded-full flex items-center justify-center mr-3">3</div>
                        <span class="font-medium">Chọn KTV</span>
                    </div>
                    <div class="flex-1 h-1 bg-gray-200 mx-4">
                        <div class="h-full progress-bar" style="width: 0%"></div>
                    </div>
                    <div class="booking-step flex items-center p-4 rounded-lg border-2 border-gray-200" id="step4">
                        <div class="w-8 h-8 bg-gray-300 text-gray-600 rounded-full flex items-center justify-center mr-3">4</div>
                        <span class="font-medium">Chọn Giờ</span>
                    </div>
                    <div class="flex-1 h-1 bg-gray-200 mx-4">
                        <div class="h-full progress-bar" style="width: 0%"></div>
                    </div>
                    <div class="booking-step flex items-center p-4 rounded-lg border-2 border-gray-200" id="step5">
                        <div class="w-8 h-8 bg-gray-300 text-gray-600 rounded-full flex items-center justify-center mr-3">5</div>
                        <span class="font-medium">Xác Nhận</span>
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
            
            <c:if test="${not empty successMessage}">
                <div class="mb-6 p-4 bg-green-100 border border-green-400 text-green-700 rounded-lg">
                    <i data-lucide="check-circle" class="h-5 w-5 inline mr-2"></i>
                    ${successMessage}
                </div>
            </c:if>
            
            <!-- Booking Form -->
            <form id="bookingForm" method="post" action="${pageContext.request.contextPath}/customer/booking">
                <!-- Step 1: Service Selection -->
                <div class="booking-content bg-white rounded-xl shadow-md p-6 mb-6" id="serviceSelection">
                    <h2 class="text-xl font-semibold text-spa-dark mb-4 flex items-center">
                        <i data-lucide="shopping-bag" class="h-6 w-6 text-primary mr-2"></i>
                        Chọn Dịch Vụ Đã Thanh Toán
                    </h2>
                    
                    <c:choose>
                        <c:when test="${not empty availableServices}">
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                                <c:forEach var="service" items="${availableServices}">
                                    <div class="service-card border-2 border-gray-200 rounded-lg p-4" 
                                         data-service-id="${service.paymentItemId}"
                                         data-service-name="${service.service.serviceName}"
                                         data-service-duration="${service.serviceDuration}">
                                        <div class="flex items-start justify-between mb-3">
                                            <h3 class="font-semibold text-gray-900">${service.service.serviceName}</h3>
                                            <span class="bg-primary text-white text-xs px-2 py-1 rounded-full">
                                                ${service.quantity} lần
                                            </span>
                                        </div>
                                        <p class="text-gray-600 text-sm mb-3">${service.service.description}</p>
                                        <div class="flex items-center justify-between text-sm">
                                            <span class="text-gray-500">
                                                <i data-lucide="clock" class="h-4 w-4 inline mr-1"></i>
                                                ${service.serviceDuration} phút
                                            </span>
                                            <span class="font-semibold text-primary">
                                                <fmt:formatNumber value="${service.unitPrice}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                                            </span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-8">
                                <i data-lucide="inbox" class="h-16 w-16 text-gray-400 mx-auto mb-4"></i>
                                <h3 class="text-lg font-medium text-gray-900 mb-2">Không có dịch vụ khả dụng</h3>
                                <p class="text-gray-600 mb-4">Bạn chưa có dịch vụ nào đã thanh toán hoặc tất cả đã được sử dụng hết.</p>
                                <a href="${pageContext.request.contextPath}/services" 
                                   class="inline-flex items-center px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary/90 transition-colors">
                                    <i data-lucide="shopping-cart" class="h-4 w-4 mr-2"></i>
                                    Mua Dịch Vụ
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Hidden form fields -->
                <input type="hidden" id="paymentItemId" name="paymentItemId" value="">
                <input type="hidden" id="therapistId" name="therapistId" value="">
                <input type="hidden" id="appointmentDate" name="appointmentDate" value="">
                <input type="hidden" id="appointmentTime" name="appointmentTime" value="">
                
                <!-- Step 2: Date Selection (Initially Hidden) -->
                <div class="booking-content bg-white rounded-xl shadow-md p-6 mb-6 hidden" id="dateSelection">
                    <h2 class="text-xl font-semibold text-spa-dark mb-4 flex items-center">
                        <i data-lucide="calendar" class="h-6 w-6 text-primary mr-2"></i>
                        Chọn Ngày Hẹn
                    </h2>
                    <div id="calendarContainer" class="max-w-md mx-auto">
                        <!-- Calendar will be generated by JavaScript -->
                    </div>
                </div>
                
                <!-- Step 3: Therapist Selection (Initially Hidden) -->
                <div class="booking-content bg-white rounded-xl shadow-md p-6 mb-6 hidden" id="therapistSelection">
                    <h2 class="text-xl font-semibold text-spa-dark mb-4 flex items-center">
                        <i data-lucide="user" class="h-6 w-6 text-primary mr-2"></i>
                        Chọn Kỹ Thuật Viên
                    </h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4" id="therapistGrid">
                        <c:forEach var="therapist" items="${therapists}">
                            <div class="therapist-card border-2 border-gray-200 rounded-lg p-4" 
                                 data-therapist-id="${therapist.userId}">
                                <div class="text-center">
                                    <div class="w-16 h-16 bg-primary/20 rounded-full flex items-center justify-center mx-auto mb-3">
                                        <i data-lucide="user" class="h-8 w-8 text-primary"></i>
                                    </div>
                                    <h3 class="font-semibold text-gray-900 mb-1">${therapist.fullName}</h3>
                                    <p class="text-gray-600 text-sm">${therapist.email}</p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                
                <!-- Step 4: Time Selection (Initially Hidden) -->
                <div class="booking-content bg-white rounded-xl shadow-md p-6 mb-6 hidden" id="timeSelection">
                    <h2 class="text-xl font-semibold text-spa-dark mb-4 flex items-center">
                        <i data-lucide="clock" class="h-6 w-6 text-primary mr-2"></i>
                        Chọn Giờ Hẹn
                    </h2>
                    <div class="grid grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-3" id="timeSlotGrid">
                        <!-- Time slots will be generated by JavaScript -->
                    </div>
                </div>
                
                <!-- Step 5: Confirmation (Initially Hidden) -->
                <div class="booking-content bg-white rounded-xl shadow-md p-6 mb-6 hidden" id="confirmationStep">
                    <h2 class="text-xl font-semibold text-spa-dark mb-4 flex items-center">
                        <i data-lucide="check-circle" class="h-6 w-6 text-primary mr-2"></i>
                        Xác Nhận Đặt Lịch
                    </h2>
                    
                    <div class="bg-gray-50 rounded-lg p-4 mb-4">
                        <h3 class="font-semibold mb-3">Thông Tin Đặt Lịch:</h3>
                        <div class="space-y-2">
                            <div class="flex justify-between">
                                <span class="text-gray-600">Dịch vụ:</span>
                                <span class="font-medium" id="confirmService">-</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">Ngày hẹn:</span>
                                <span class="font-medium" id="confirmDate">-</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">Giờ hẹn:</span>
                                <span class="font-medium" id="confirmTime">-</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">Kỹ thuật viên:</span>
                                <span class="font-medium" id="confirmTherapist">-</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">Thời gian:</span>
                                <span class="font-medium" id="confirmDuration">-</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label for="notes" class="block text-sm font-medium text-gray-700 mb-2">Ghi chú (tùy chọn):</label>
                        <textarea id="notes" name="notes" rows="3" 
                                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary"
                                  placeholder="Nhập ghi chú cho cuộc hẹn..."></textarea>
                    </div>
                    
                    <div class="flex gap-4">
                        <button type="button" id="backToTimeBtn" 
                                class="flex-1 px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors">
                            <i data-lucide="arrow-left" class="h-4 w-4 inline mr-2"></i>
                            Quay Lại
                        </button>
                        <button type="submit" 
                                class="flex-1 px-6 py-3 bg-primary text-white rounded-lg hover:bg-primary/90 transition-colors">
                            <i data-lucide="check" class="h-4 w-4 inline mr-2"></i>
                            Xác Nhận Đặt Lịch
                        </button>
                    </div>
                </div>
            </form>
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
            
            // Booking state
            let bookingState = {
                step: 1,
                selectedService: null,
                selectedDate: null,
                selectedTherapist: null,
                selectedTime: null
            };
            
            // Service selection
            $('.service-card').on('click', function() {
                $('.service-card').removeClass('selected');
                $(this).addClass('selected');
                
                bookingState.selectedService = {
                    id: $(this).data('service-id'),
                    name: $(this).data('service-name'),
                    duration: $(this).data('service-duration')
                };
                
                $('#paymentItemId').val(bookingState.selectedService.id);
                
                // Move to next step
                setTimeout(() => {
                    nextStep();
                }, 500);
            });
            
            // Therapist selection
            $(document).on('click', '.therapist-card', function() {
                $('.therapist-card').removeClass('selected');
                $(this).addClass('selected');
                
                bookingState.selectedTherapist = {
                    id: $(this).data('therapist-id'),
                    name: $(this).find('h3').text()
                };
                
                $('#therapistId').val(bookingState.selectedTherapist.id);
                
                // Move to next step
                setTimeout(() => {
                    nextStep();
                }, 500);
            });
            
            // Time slot selection
            $(document).on('click', '.time-slot:not(.unavailable)', function() {
                $('.time-slot').removeClass('selected');
                $(this).addClass('selected');
                
                bookingState.selectedTime = $(this).data('time');
                $('#appointmentTime').val(bookingState.selectedTime);
                
                // Move to next step
                setTimeout(() => {
                    nextStep();
                }, 500);
            });
            
            // Back button
            $('#backToTimeBtn').on('click', function() {
                previousStep();
            });
            
            // Step navigation functions
            function nextStep() {
                if (bookingState.step < 5) {
                    bookingState.step++;
                    updateStepDisplay();
                    
                    if (bookingState.step === 2) {
                        generateCalendar();
                    } else if (bookingState.step === 4) {
                        generateTimeSlots();
                    } else if (bookingState.step === 5) {
                        updateConfirmation();
                    }
                }
            }
            
            function previousStep() {
                if (bookingState.step > 1) {
                    bookingState.step--;
                    updateStepDisplay();
                }
            }
            
            function updateStepDisplay() {
                // Hide all content
                $('.booking-content').addClass('hidden');
                
                // Show current step content
                switch (bookingState.step) {
                    case 1:
                        $('#serviceSelection').removeClass('hidden');
                        break;
                    case 2:
                        $('#dateSelection').removeClass('hidden');
                        break;
                    case 3:
                        $('#therapistSelection').removeClass('hidden');
                        break;
                    case 4:
                        $('#timeSelection').removeClass('hidden');
                        break;
                    case 5:
                        $('#confirmationStep').removeClass('hidden');
                        break;
                }
                
                // Update step indicators
                for (let i = 1; i <= 5; i++) {
                    const stepEl = $(`#step${i}`);
                    const circle = stepEl.find('div').first();
                    
                    if (i < bookingState.step) {
                        stepEl.addClass('active');
                        circle.removeClass('bg-gray-300 text-gray-600').addClass('bg-green-500 text-white');
                        circle.html('<i data-lucide="check" class="h-4 w-4"></i>');
                    } else if (i === bookingState.step) {
                        stepEl.addClass('active');
                        circle.removeClass('bg-gray-300 text-gray-600 bg-green-500').addClass('bg-primary text-white');
                        circle.text(i);
                    } else {
                        stepEl.removeClass('active');
                        circle.removeClass('bg-primary text-white bg-green-500').addClass('bg-gray-300 text-gray-600');
                        circle.text(i);
                    }
                }
                
                // Update progress bar
                const progress = ((bookingState.step - 1) / 4) * 100;
                $('#progressBar').css('width', progress + '%');
                
                // Reinitialize Lucide icons
                if (typeof lucide !== 'undefined') {
                    lucide.createIcons();
                }
            }
            
            function generateCalendar() {
                const today = new Date();
                const currentMonth = today.getMonth();
                const currentYear = today.getFullYear();
                
                let calendarHtml = `
                    <div class="text-center mb-4">
                        <h3 class="text-lg font-semibold">${getMonthName(currentMonth)} ${currentYear}</h3>
                    </div>
                    <div class="grid grid-cols-7 gap-1 mb-2">
                        <div class="text-center text-sm font-medium text-gray-500 p-2">CN</div>
                        <div class="text-center text-sm font-medium text-gray-500 p-2">T2</div>
                        <div class="text-center text-sm font-medium text-gray-500 p-2">T3</div>
                        <div class="text-center text-sm font-medium text-gray-500 p-2">T4</div>
                        <div class="text-center text-sm font-medium text-gray-500 p-2">T5</div>
                        <div class="text-center text-sm font-medium text-gray-500 p-2">T6</div>
                        <div class="text-center text-sm font-medium text-gray-500 p-2">T7</div>
                    </div>
                    <div class="grid grid-cols-7 gap-1">
                `;
                
                const firstDay = new Date(currentYear, currentMonth, 1);
                const lastDay = new Date(currentYear, currentMonth + 1, 0);
                const startDate = new Date(firstDay);
                startDate.setDate(startDate.getDate() - firstDay.getDay());
                
                for (let i = 0; i < 42; i++) {
                    const date = new Date(startDate);
                    date.setDate(startDate.getDate() + i);
                    
                    const isCurrentMonth = date.getMonth() === currentMonth;
                    const isPast = date < today;
                    const isToday = date.toDateString() === today.toDateString();
                    
                    let classes = 'calendar-day text-center p-2 rounded-lg border';
                    
                    if (!isCurrentMonth || isPast) {
                        classes += ' disabled';
                    } else {
                        classes += ' hover:bg-primary/10 border-gray-200';
                    }
                    
                    if (isToday) {
                        classes += ' border-primary';
                    }
                    
                    const dateStr = date.toISOString().split('T')[0];
                    
                    calendarHtml += `
                        <div class="${classes}" data-date="${dateStr}">
                            ${date.getDate()}
                        </div>
                    `;
                }
                
                calendarHtml += '</div>';
                $('#calendarContainer').html(calendarHtml);
                
                // Add click handlers for calendar days
                $('.calendar-day:not(.disabled)').on('click', function() {
                    $('.calendar-day').removeClass('selected');
                    $(this).addClass('selected');
                    
                    bookingState.selectedDate = $(this).data('date');
                    $('#appointmentDate').val(bookingState.selectedDate);
                    
                    // Move to next step
                    setTimeout(() => {
                        nextStep();
                    }, 500);
                });
            }
            
            function generateTimeSlots() {
                const timeSlots = [
                    '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
                    '13:00', '13:30', '14:00', '14:30', '15:00', '15:30',
                    '16:00', '16:30', '17:00', '17:30', '18:00', '18:30'
                ];
                
                let slotsHtml = '';
                timeSlots.forEach(time => {
                    // For demo purposes, randomly make some slots unavailable
                    const isUnavailable = Math.random() < 0.3;
                    const classes = isUnavailable ? 
                        'time-slot unavailable px-4 py-2 text-center rounded-lg border' :
                        'time-slot px-4 py-2 text-center rounded-lg border border-gray-200 hover:border-primary';
                    
                    slotsHtml += `
                        <div class="${classes}" data-time="${time}">
                            ${time}
                        </div>
                    `;
                });
                
                $('#timeSlotGrid').html(slotsHtml);
            }
            
            function updateConfirmation() {
                $('#confirmService').text(bookingState.selectedService?.name || '-');
                $('#confirmDate').text(formatDate(bookingState.selectedDate) || '-');
                $('#confirmTime').text(bookingState.selectedTime || '-');
                $('#confirmTherapist').text(bookingState.selectedTherapist?.name || '-');
                $('#confirmDuration').text(bookingState.selectedService?.duration ? bookingState.selectedService.duration + ' phút' : '-');
            }
            
            function getMonthName(month) {
                const months = [
                    'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
                    'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
                ];
                return months[month];
            }
            
            function formatDate(dateStr) {
                if (!dateStr) return '';
                const date = new Date(dateStr);
                return date.toLocaleDateString('vi-VN');
            }
        });
    </script>
</body>
</html>
