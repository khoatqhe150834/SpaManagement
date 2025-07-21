<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        :root {
            --spa-primary: #D4AF37;
            --spa-secondary: #8B7355;
            --spa-success: #28a745;
            --spa-danger: #dc3545;
            --spa-warning: #ffc107;
            --spa-info: #17a2b8;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .test-header {
            background: linear-gradient(135deg, var(--spa-primary) 0%, var(--spa-secondary) 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .time-slot-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 15px;
            margin-bottom: 2rem;
        }
        
        .time-slot {
            padding: 15px 10px;
            border: 2px solid #ddd;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
            position: relative;
            min-height: 80px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .time-slot.available {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border-color: var(--spa-success);
            color: #155724;
        }
        
        .time-slot.available:hover {
            background: linear-gradient(135deg, #c3e6cb 0%, #b1dfbb 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        
        .time-slot.booked {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            border-color: var(--spa-danger);
            color: #721c24;
            cursor: not-allowed;
        }
        
        .time-slot.selected {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border-color: var(--spa-warning);
            color: #856404;
            animation: pulse 1.5s infinite;
        }
        
        .time-slot.just-booked {
            background: linear-gradient(135deg, #fd7e14 0%, #e55100 100%);
            border-color: #fd7e14;
            color: white;
            animation: flash 2s ease-in-out;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        @keyframes flash {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }
        
        .user-simulation {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        
        .console-log {
            background: #1e1e1e;
            color: #00ff00;
            border-radius: 8px;
            padding: 1rem;
            height: 300px;
            overflow-y: auto;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            margin-top: 1rem;
        }
        
        .status-indicator {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 8px;
        }
        
        .status-indicator.connected {
            background: var(--spa-success);
            animation: pulse 2s infinite;
        }
        
        .status-indicator.disconnected {
            background: var(--spa-danger);
        }
        
        .legend {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 2rem;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .legend-color {
            width: 20px;
            height: 20px;
            border-radius: 4px;
            border: 2px solid #ddd;
        }
        
        .btn-spa {
            background: linear-gradient(135deg, var(--spa-primary) 0%, var(--spa-secondary) 100%);
            border: none;
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-spa:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            color: white;
        }
        
        .service-info {
            background: #f8f9fa;
            border-left: 4px solid var(--spa-primary);
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 0 8px 8px 0;
        }
    </style>
</head>
<body>
    <!-- Test Header -->
    <div class="test-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1><i class="fas fa-vial me-3"></i>WebSocket Booking Test System</h1>
                    <p class="mb-0">Kiểm tra tính năng đặt lịch thời gian thực - Ngăn chặn đặt trùng lịch</p>
                </div>
                <div class="col-md-4 text-end">
                    <div class="d-flex align-items-center justify-content-end">
                        <span class="status-indicator" id="connectionStatus"></span>
                        <span id="connectionText">Đang kết nối...</span>
                    </div>
                    <small class="d-block mt-1">Người dùng: ${currentUser.fullName}</small>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Service Information -->
        <div class="row mb-4">
            <div class="col-12">
                <h3><i class="fas fa-spa me-2"></i>Dịch Vụ Spa</h3>
                <div class="row">
                    <c:forEach var="service" items="${services}" varStatus="status">
                        <c:if test="${status.index < 4}">
                            <div class="col-md-6 col-lg-3 mb-3">
                                <div class="service-info">
                                    <h6 class="mb-1">${service.name}</h6>
                                    <small class="text-muted">${service.durationMinutes} phút</small>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- Legend -->
        <div class="legend">
            <div class="legend-item">
                <div class="legend-color" style="background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%); border-color: var(--spa-success);"></div>
                <span>Có thể đặt</span>
            </div>
            <div class="legend-item">
                <div class="legend-color" style="background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%); border-color: var(--spa-warning);"></div>
                <span>Đang chọn</span>
            </div>
            <div class="legend-item">
                <div class="legend-color" style="background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%); border-color: var(--spa-danger);"></div>
                <span>Đã đặt</span>
            </div>
            <div class="legend-item">
                <div class="legend-color" style="background: linear-gradient(135deg, #fd7e14 0%, #e55100 100%); border-color: #fd7e14;"></div>
                <span>Vừa được đặt</span>
            </div>
        </div>

        <!-- Time Slots Grid -->
        <div class="row">
            <div class="col-12">
                <h3><i class="fas fa-clock me-2"></i>Khung Giờ Đặt Lịch</h3>
                <div class="time-slot-grid" id="timeSlotsGrid">
                    <c:forEach var="slot" items="${timeSlots}">
                        <div class="time-slot available" 
                             data-time="${slot.time}" 
                             data-slot-id="${slot.slotId}"
                             onclick="selectTimeSlot('${slot.time}', '${slot.slotId}')">
                            <div class="time-display">${slot.displayTime}</div>
                            <small class="slot-status">Có thể đặt</small>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- User Simulation Controls -->
        <div class="row">
            <div class="col-md-6">
                <div class="user-simulation">
                    <h4><i class="fas fa-users me-2"></i>Điều Khiển Test</h4>
                    <div class="mb-3">
                        <label class="form-label">Mô phỏng người dùng:</label>
                        <select class="form-select" id="userSimulation">
                            <option value="user1">Người dùng 1 (${currentUser.fullName})</option>
                            <option value="user2">Người dùng 2 (Test User)</option>
                            <option value="user3">Người dùng 3 (Demo User)</option>
                        </select>
                    </div>
                    <div class="d-flex gap-2 flex-wrap">
                        <button class="btn btn-spa" onclick="resetTest()">
                            <i class="fas fa-redo me-1"></i>Reset Test
                        </button>
                        <button class="btn btn-outline-primary" onclick="simulateMultipleUsers()">
                            <i class="fas fa-users me-1"></i>Mô phỏng nhiều user
                        </button>
                        <button class="btn btn-outline-success" onclick="reconnectWebSocket()">
                            <i class="fas fa-plug me-1"></i>Kết nối lại
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="user-simulation">
                    <h4><i class="fas fa-terminal me-2"></i>Console Log</h4>
                    <div class="console-log" id="consoleLog">
                        <div>[SYSTEM] WebSocket Booking Test System khởi động...</div>
                        <div>[INFO] Đang kết nối WebSocket...</div>
                    </div>
                    <button class="btn btn-outline-secondary btn-sm mt-2" onclick="clearConsole()">
                        <i class="fas fa-trash me-1"></i>Xóa log
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- WebSocket Booking Test Script -->
    <script src="${pageContext.request.contextPath}/js/websocket-booking-test.js"></script>
</body>
</html>
