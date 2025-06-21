<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <title>Chọn Thời Gian - BeautyZone Spa</title>
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>
    
    <!-- FullCalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css" rel="stylesheet">
    
    <style>
        .time-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .services-list {
            display: grid;
            gap: 24px;
            margin-bottom: 32px;
        }
        
        .service-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }
        
        .service-card.completed {
            border-color: #c8945f;
            box-shadow: 0 8px 32px rgba(200, 148, 95, 0.2);
        }
        
        .service-header {
            background: linear-gradient(135deg, #c8945f 0%, #a67c4a 100%);
            color: white;
            padding: 20px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .calendar-icon-btn {
            background: rgba(255, 255, 255, 0.2);
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 8px;
            padding: 8px 12px;
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        .calendar-icon-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            border-color: rgba(255, 255, 255, 0.5);
            transform: translateY(-1px);
        }
        
        .service-info {
            flex: 1;
        }
        
        .service-name {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 4px;
        }
        
        .service-details {
            font-size: 0.875rem;
            opacity: 0.9;
            display: flex;
            gap: 16px;
            align-items: center;
        }
        
        .service-duration {
            display: flex;
            align-items: center;
            gap: 4px;
        }
        
        .service-price {
            display: flex;
            align-items: center;
            gap: 4px;
        }
        
        .service-status {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-pending {
            background: rgba(255, 255, 255, 0.2);
            color: white;
        }
        
        .status-completed {
            background: rgba(34, 197, 94, 0.2);
            color: #16a34a;
            background: white;
        }
        
        .service-content {
            padding: 24px;
        }
        
        /* Beautiful Calendar Modal Styles */
        .calendar-modal {
            position: fixed;
            inset: 0;
            z-index: 50;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 1rem;
        }

        .calendar-modal.open {
            display: flex;
        }

        .calendar-backdrop {
            position: absolute;
            inset: 0;
            background-color: rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(4px);
            transition: opacity 0.3s ease;
        }

        .calendar-container {
            position: relative;
            background: white;
            border-radius: 0.75rem;
            box-shadow: 0 20px 40px -12px rgba(0, 0, 0, 0.2);
            border: 1px solid #e5e7eb;
            max-width: 44rem;
            width: 95%;
            margin: 0.5rem;
            transform: scale(1);
            transition: all 0.3s ease;
            animation: fadeIn 0.3s ease-out;
            display: flex;
            flex-direction: column;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: scale(0.95);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
        
        .calendar-header {
            position: relative;
            padding: 1rem 1.25rem;
            padding-bottom: 0.75rem;
            background-color: #c8945f;
            border-radius: 0.75rem 0.75rem 0 0;
            color: white;
        }

        .close-btn {
            position: absolute;
            top: 0.75rem;
            right: 0.75rem;
            padding: 0.4rem;
            background-color: rgba(255, 255, 255, 0.2);
            border: none;
            border-radius: 50%;
            cursor: pointer;
            transition: background-color 0.2s ease;
            z-index: 10;
            color: white;
        }

        .close-btn:hover {
            background-color: rgba(255, 255, 255, 0.3);
            transform: scale(1.1);
        }

        .header-content {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding-right: 2.5rem;
        }

        .header-icon {
            padding: 0.5rem;
            background-color: rgba(255, 255, 255, 0.2);
            border-radius: 0.5rem;
            flex-shrink: 0;
        }

        .header-title {
            font-size: 1rem;
            font-weight: 600;
            line-height: 1.25;
            margin: 0;
        }
        
        .calendar-content {
            padding: 1rem;
            background: white;
            border-radius: 0 0 0.75rem 0.75rem;
            display: flex;
            gap: 1rem;
            flex: 1;
        }

        .calendar-left {
            flex: 1;
            min-width: 0;
        }

        .calendar-right {
            flex: 0 0 18rem;
            border-left: 1px solid #e5e7eb;
            padding-left: 1rem;
        }

        .date-input-section {
            margin-bottom: 1rem;
        }

        .date-input-label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            color: #374151;
            margin-bottom: 0.5rem;
        }

        .date-input-container {
            position: relative;
        }
        
        .date-input {
            width: 100%;
            padding: 0.75rem 1rem;
            padding-right: 3rem;
            border: 2px solid #e5e7eb;
            border-radius: 0.75rem;
            background-color: #f9fafb;
            transition: all 0.2s ease;
            font-size: 1rem;
        }

        .date-input:focus {
            outline: none;
            border-color: #c8945f;
            box-shadow: 0 0 0 3px rgba(200, 148, 95, 0.1);
        }

        .input-icon {
            position: absolute;
            right: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
        }
        
        .month-navigation {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }

        .nav-btn {
            padding: 0.5rem;
            background-color: #f3f4f6;
            border: none;
            border-radius: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
            color: #6b7280;
        }

        .nav-btn:hover {
            background-color: #e5e7eb;
            color: #374151;
        }

        .month-title {
            font-size: 1rem;
            font-weight: 600;
            color: #374151;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin: 0;
        }

        .month-title iconify-icon {
            color: #c8945f;
        }

        .calendar-grid-container {
            margin-bottom: 1rem;
        }

        .week-headers {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 0.125rem;
            margin-bottom: 0.25rem;
        }

        .week-day {
            text-align: center;
            font-size: 0.75rem;
            font-weight: 500;
            color: #6b7280;
            padding: 0.375rem;
            background-color: #f9fafb;
            border-radius: 0.25rem;
        }

        .calendar-days {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 0.125rem;
        }
        
        .calendar-day {
            aspect-ratio: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            border-radius: 0.375rem;
            transition: all 0.2s ease;
            position: relative;
            border: 1px solid transparent;
            background: white;
            cursor: pointer;
            font-weight: 500;
            min-height: 2rem;
        }

        .calendar-day:disabled {
            color: #d1d5db;
            cursor: not-allowed;
            opacity: 0.4;
        }

        .calendar-day:not(:disabled):hover {
            border-color: #c8945f;
            background-color: #fff7ed;
            color: #c8945f;
            transform: scale(1.05);
        }

        .calendar-day.selected {
            background-color: #c8945f;
            color: white;
            border-color: #c8945f;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            transform: scale(1.05);
        }

        .calendar-day.today:not(.selected) {
            background-color: #fef3c7;
            color: #d97706;
            font-weight: 600;
            border-color: #fcd34d;
        }

        .calendar-day.today:not(.selected)::after {
            content: '';
            position: absolute;
            bottom: -0.25rem;
            left: 50%;
            transform: translateX(-50%);
            width: 0.5rem;
            height: 0.5rem;
            background-color: #f59e0b;
            border-radius: 50%;
        }

        .calendar-day.selected::after {
            content: '';
            position: absolute;
            top: -0.25rem;
            right: -0.25rem;
            width: 1rem;
            height: 1rem;
            background-color: #c8945f;
            border: 2px solid white;
            border-radius: 50%;
            background-image: url("data:image/svg+xml,%3csvg viewBox='0 0 16 16' fill='white' xmlns='http://www.w3.org/2000/svg'%3e%3cpath d='m13.854 3.646-7.5 7.5a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L6 10.293l7.146-7.147a.5.5 0 0 1 .708.708z'/%3e%3c/svg%3e");
            background-size: 0.75rem;
            background-repeat: no-repeat;
            background-position: center;
        }

        /* Animation classes */
        .slide-left {
            animation: slideLeft 0.15s ease-out;
        }

        .slide-right {
            animation: slideRight 0.15s ease-out;
        }

        @keyframes slideLeft {
            from { transform: translateX(0); }
            to { transform: translateX(-10px); }
        }

        @keyframes slideRight {
            from { transform: translateX(0); }
            to { transform: translateX(10px); }
        }
        
        .time-slots-section {
            margin-top: 0;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        
        .time-slots-section h4 {
            margin-bottom: 0.75rem;
            color: #374151;
            font-size: 0.9rem;
            font-weight: 600;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .time-slots-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 0.5rem;
            flex: 1;
            align-content: start;
        }
        
        .time-slot {
            padding: 0.375rem 0.25rem;
            border: 1px solid #e5e7eb;
            background: white;
            border-radius: 0.375rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
            font-weight: 500;
            font-size: 0.7rem;
        }
        
        .time-slot:hover:not(.disabled) {
            border-color: #c8945f;
            background: rgba(200, 148, 95, 0.1);
            transform: translateY(-1px);
        }
        
        .time-slot.selected {
            background: #c8945f;
            border-color: #c8945f;
            color: white;
        }
        
        .time-slot.disabled {
            background: #f3f4f6;
            color: #9ca3af;
            cursor: not-allowed;
            border-color: #e5e7eb;
        }
        
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 0.75rem;
            margin-top: 1rem;
            padding: 1rem;
            border-top: 1px solid #e5e7eb;
            background: #f9fafb;
            border-radius: 0 0 0.75rem 0.75rem;
        }
        
        .btn {
            padding: 16px 32px;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            min-width: 160px;
            justify-content: center;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #c8945f 0%, #a67c4a 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(200, 148, 95, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(200, 148, 95, 0.4);
        }
        
        .btn-primary:disabled {
            background: #9ca3af;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #4b5563;
            transform: translateY(-2px);
        }
        
        /* Custom scrollbar for better UX */
        ::-webkit-scrollbar {
            width: 6px;
        }

        ::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 3px;
        }

        ::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 3px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #a1a1a1;
        }
        
        .progress-indicator {
            background: white;
            border-radius: 12px;
            padding: 16px 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .progress-text {
            font-size: 0.875rem;
            color: #6b7280;
            margin-bottom: 8px;
        }
        
        .progress-bar {
            width: 100%;
            height: 8px;
            background: #e5e7eb;
            border-radius: 4px;
            overflow: hidden;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(135deg, #c8945f 0%, #a67c4a 100%);
            border-radius: 4px;
            transition: width 0.3s ease;
        }
        
        /* Desktop optimizations */
        @media (min-width: 1024px) {
            .calendar-container {
                max-width: 48rem;
            }
            
            .calendar-right {
                flex: 0 0 20rem;
            }
            
            .time-slots-grid {
                grid-template-columns: repeat(4, 1fr);
                gap: 0.5rem;
            }
            
            .time-slot {
                padding: 0.5rem 0.375rem;
                font-size: 0.75rem;
            }
        }
        
        @media (max-width: 768px) {
            .time-container {
                padding: 16px;
            }
            
            .service-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
            }
            
            .service-details {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }
            

            
            .time-slots-grid {
                grid-template-columns: repeat(auto-fill, minmax(80px, 1fr));
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
            
            /* Additional mobile calendar optimizations */
            .calendar-container {
                max-width: 22rem;
                margin: 0.25rem;
                width: 98%;
            }
            
            .calendar-content {
                flex-direction: column;
                padding: 0.75rem;
                gap: 0.75rem;
            }
            
            .calendar-right {
                border-left: none;
                border-top: 1px solid #e5e7eb;
                padding-left: 0;
                padding-top: 0.75rem;
                flex: none;
            }
            
            .calendar-header {
                padding: 0.75rem 1rem;
                padding-bottom: 0.5rem;
            }
            
            .header-title {
                font-size: 0.9rem;
            }
            
            .month-title {
                font-size: 0.9rem;
            }
            
            .calendar-day {
                font-size: 0.75rem;
                min-height: 1.75rem;
            }
            
            .week-day {
                font-size: 0.7rem;
                padding: 0.25rem;
            }
            
            .calendar-grid-container {
                margin-bottom: 0.75rem;
            }
            
            .month-navigation {
                margin-bottom: 0.75rem;
            }
            
            .date-input-section {
                margin-bottom: 0.75rem;
            }
            
            .time-slots-grid {
                grid-template-columns: repeat(4, 1fr);
                gap: 0.375rem;
            }
        }
    </style>
</head>

<body id="bg">
    <div class="page-wraper">
        <!-- header -->
        <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>
        
        <!-- Content -->
        <div class="page-content bg-white">
            <!-- inner page banner -->
            <div class="dlab-bnr-inr overlay-primary bg-pt" 
                 style="background-image: url(${pageContext.request.contextPath}/assets/home/images/banner/bnr2.jpg);">
                <div class="container">
                    <div class="dlab-bnr-inr-entry">
                        <h1 class="text-white">Chọn Thời Gian</h1>
                        <nav aria-label="breadcrumb" class="breadcrumb-row">
                            <ul class="breadcrumb">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/process-booking/services">Đặt lịch</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Chọn thời gian</li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
            
            <!-- Time selection content -->
            <div class="section-full content-inner">
                <div class="container">
                    <!-- Step Indicator -->
                    <c:set var="currentStep" value="time" />
                    <jsp:include page="/WEB-INF/view/common/booking/step-indicator.jsp">
                        <jsp:param name="currentStep" value="${currentStep}" />
                        <jsp:param name="bookingSession" value="${bookingSession}" />
                    </jsp:include>
                    
                    <div class="time-container">
                        <%-- <!-- Progress Indicator -->
                        <div class="progress-indicator">
                            <div class="progress-text">Tiến độ đặt lịch</div>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: 50%;"></div>
                            </div>
                        </div> --%>
                        
                        <!-- Services List -->
                        <div class="services-list" id="servicesList">
                            <!-- Services will be populated by JavaScript -->
                        </div>
                        
                        <!-- Calendar Modal -->
                        <div id="calendarModal" class="calendar-modal">
                            <div class="calendar-backdrop"></div>
                            <div class="calendar-container">
                                <!-- Header -->
                                <div class="calendar-header">
                                    <button id="closeCalendarBtn" class="close-btn" onclick="closeCalendarModal()">
                                        <iconify-icon icon="material-symbols:close" width="20" height="20"></iconify-icon>
                                    </button>
                                    <div class="header-content">
                                        <div class="header-icon">
                                            <iconify-icon icon="material-symbols:calendar-month" width="20" height="20"></iconify-icon>
                                        </div>
                                        <h2 class="header-title" id="modalTitle">Chọn ngày cho dịch vụ</h2>
                                    </div>
                                </div>

                                <!-- Content -->
                                <div class="calendar-content">
                                    <!-- Left Side: Calendar -->
                                    <div class="calendar-left">
                                        <!-- Date Input -->
                                        <div class="date-input-section">
                                            <label class="date-input-label">Chọn ngày:</label>
                                            <div class="date-input-container">
                                                <input
                                                    type="text"
                                                    id="datePicker"
                                                    readonly
                                                    placeholder="Nhấn để chọn ngày..."
                                                    class="date-input"
                                                />
                                                <iconify-icon icon="material-symbols:calendar-today" class="input-icon" width="20" height="20"></iconify-icon>
                                            </div>
                                        </div>

                                        <!-- Month Navigation -->
                                        <div class="month-navigation">
                                            <button id="prevMonthBtn" class="nav-btn">
                                                <iconify-icon icon="material-symbols:chevron-left" width="20" height="20"></iconify-icon>
                                            </button>
                                            <h3 class="month-title">
                                                <iconify-icon icon="material-symbols:date-range" width="18" height="18"></iconify-icon>
                                                <span id="monthYear"></span>
                                            </h3>
                                            <button id="nextMonthBtn" class="nav-btn">
                                                <iconify-icon icon="material-symbols:chevron-right" width="20" height="20"></iconify-icon>
                                            </button>
                                        </div>

                                        <!-- Calendar Grid -->
                                        <div class="calendar-grid-container">
                                            <!-- Week Headers -->
                                            <div class="week-headers">
                                                <div class="week-day">T2</div>
                                                <div class="week-day">T3</div>
                                                <div class="week-day">T4</div>
                                                <div class="week-day">T5</div>
                                                <div class="week-day">T6</div>
                                                <div class="week-day">T7</div>
                                                <div class="week-day">CN</div>
                                            </div>

                                            <!-- Calendar Days -->
                                            <div id="calendarDays" class="calendar-days"></div>
                                        </div>
                                    </div>
                                    
                                    <!-- Right Side: Time Slots -->
                                    <div class="calendar-right">
                                        <div class="time-slots-section" id="modalTimeSlots" style="display: none;">
                                            <h4>Chọn giờ khả dụng</h4>
                                            <div class="time-slots-grid" id="modalTimeSlotsGrid">
                                                <!-- Time slots will be populated dynamically -->
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Action Buttons -->
                                <div class="action-buttons">
                                    <button type="button" class="btn btn-secondary" onclick="closeCalendarModal()">
                                        Hủy
                                    </button>
                                    <button type="button" id="modalConfirmBtn" class="btn btn-primary" onclick="confirmTimeSelection()" disabled>
                                        Xác nhận
                                    </button>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/process-booking/services" class="btn btn-secondary">
                                <iconify-icon icon="material-symbols:arrow-back"></iconify-icon>
                                Quay lại
                            </a>
                            <button type="button" id="continueBtn" class="btn btn-primary" disabled>
                                <iconify-icon icon="material-symbols:arrow-forward"></iconify-icon>
                                Tiếp tục
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Footer -->
        <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
    </div>
    
    <!-- JavaScript -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
    
    <!-- Custom Calendar Implementation -->
    
    <!-- Iconify for icons -->
    <script src="https://code.iconify.design/3/3.1.1/iconify.min.js"></script>
    
    <!-- Time Selection JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/home/js/time-selection.js"></script>
    
    <script>
        // Pass booking session data to JavaScript
        window.bookingData = {
            contextPath: '${pageContext.request.contextPath}',
            sessionData: <c:choose>
                <c:when test="${bookingSession.hasServices()}">
                    ${bookingSession.sessionData}
                </c:when>
                <c:otherwise>
                    {"selectedServices":[]}
                </c:otherwise>
            </c:choose>,
            sessionId: '${bookingSession.sessionId}',
            currentStep: '${currentStep}'
        };
        
        // Extract selected services for backward compatibility
        window.bookingData.selectedServices = window.bookingData.sessionData.selectedServices || [];
        
        // Initialize when DOM is loaded
        document.addEventListener('DOMContentLoaded', function() {
            console.log('📅 Time Selection Page Loading...');
            console.log('Booking Data:', window.bookingData);
            
            if (window.TimeSelection) {
                window.TimeSelection.init();
            }
        });
    </script>
</body>
</html> 