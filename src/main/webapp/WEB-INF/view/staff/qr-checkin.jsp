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
        
        .checkin-header {
            background: linear-gradient(135deg, var(--spa-primary) 0%, var(--spa-secondary) 100%);
            color: white;
            padding: 1.5rem 0;
            margin-bottom: 2rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .checkin-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            border: 1px solid #e9ecef;
        }
        
        .qr-scanner-container {
            text-align: center;
            padding: 2rem;
            border: 3px dashed #ddd;
            border-radius: 15px;
            margin-bottom: 2rem;
            background: #f8f9fa;
        }
        
        .qr-scanner-icon {
            font-size: 4rem;
            color: var(--spa-primary);
            margin-bottom: 1rem;
        }
        
        .manual-input-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-top: 2rem;
        }
        
        .booking-details-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-top: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border-left: 5px solid var(--spa-success);
        }
        
        .customer-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: var(--spa-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            font-weight: bold;
            margin-right: 1rem;
        }
        
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
        }
        
        .status-scheduled {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-confirmed {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .status-in-progress {
            background: #d4edda;
            color: #155724;
        }
        
        .btn-spa {
            background: linear-gradient(135deg, var(--spa-primary) 0%, var(--spa-secondary) 100%);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-spa:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            color: white;
        }
        
        .btn-checkin {
            background: linear-gradient(135deg, var(--spa-success) 0%, #20c997 100%);
            border: none;
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }
        
        .btn-checkin:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            color: white;
        }
        
        .alert-custom {
            border-radius: 10px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .loading-spinner {
            display: none;
            text-align: center;
            padding: 2rem;
        }
        
        .success-animation {
            animation: successPulse 0.6s ease-in-out;
        }
        
        @keyframes successPulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .qr-input-group {
            position: relative;
        }
        
        .qr-input-group .form-control {
            padding-right: 50px;
        }
        
        .qr-scan-btn {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: var(--spa-primary);
            color: white;
            border-radius: 6px;
            padding: 0.5rem;
            width: 40px;
            height: 40px;
        }
        
        .recent-checkins {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-top: 2rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .checkin-item {
            display: flex;
            align-items: center;
            padding: 1rem;
            border-bottom: 1px solid #e9ecef;
            transition: background-color 0.3s ease;
        }
        
        .checkin-item:hover {
            background-color: #f8f9fa;
        }
        
        .checkin-item:last-child {
            border-bottom: none;
        }
        
        .checkin-time {
            font-size: 0.85rem;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <!-- Check-in Header -->
    <div class="checkin-header">
        <div class="container-fluid">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1><i class="fas fa-qrcode me-3"></i>QR Check-in</h1>
                    <p class="mb-0">Quét mã QR để check-in khách hàng</p>
                </div>
                <div class="col-md-4 text-end">
                    <small class="d-block">Nhân viên: ${currentUser.fullName}</small>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-light btn-sm mt-2">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container-fluid">
        <div class="row">
            <!-- QR Scanner Section -->
            <div class="col-lg-8">
                <div class="checkin-card">
                    <h3 class="mb-4">
                        <i class="fas fa-qrcode me-2"></i>Quét mã QR
                    </h3>
                    
                    <!-- QR Scanner Area -->
                    <div class="qr-scanner-container" id="qrScannerContainer">
                        <div class="qr-scanner-icon">
                            <i class="fas fa-qrcode"></i>
                        </div>
                        <h4>Quét mã QR của khách hàng</h4>
                        <p class="text-muted">Hướng camera về phía mã QR trên điện thoại khách hàng</p>
                        <button class="btn btn-spa" onclick="startQRScanner()">
                            <i class="fas fa-camera me-2"></i>Bắt đầu quét
                        </button>
                    </div>
                    
                    <!-- Manual QR Input -->
                    <div class="manual-input-section">
                        <h5><i class="fas fa-keyboard me-2"></i>Nhập mã QR thủ công</h5>
                        <p class="text-muted">Nếu không thể quét được, hãy nhập mã QR thủ công</p>
                        
                        <div class="row">
                            <div class="col-md-8">
                                <div class="qr-input-group">
                                    <input type="text" class="form-control form-control-lg" 
                                           id="qrCodeInput" placeholder="Nhập mã QR hoặc ID booking">
                                    <button class="qr-scan-btn" onclick="validateQRCode()" title="Kiểm tra mã">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <button class="btn btn-checkin w-100" onclick="processQRCheckIn()">
                                    <i class="fas fa-check me-2"></i>Check-in
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Loading Spinner -->
                    <div class="loading-spinner" id="loadingSpinner">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Đang xử lý...</span>
                        </div>
                        <p class="mt-2">Đang xử lý check-in...</p>
                    </div>
                    
                    <!-- Alert Messages -->
                    <div id="alertContainer"></div>
                </div>
                
                <!-- Booking Details Display -->
                <div id="bookingDetailsContainer" style="display: none;">
                    <!-- Booking details will be populated here -->
                </div>
            </div>
            
            <!-- Recent Check-ins Sidebar -->
            <div class="col-lg-4">
                <div class="recent-checkins">
                    <h4><i class="fas fa-history me-2"></i>Check-in gần đây</h4>
                    <div id="recentCheckinsContainer">
                        <div class="text-center text-muted py-3">
                            <i class="fas fa-clock fa-2x mb-2"></i>
                            <p>Chưa có check-in nào hôm nay</p>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="checkin-card mt-3">
                    <h5><i class="fas fa-tools me-2"></i>Thao tác nhanh</h5>
                    <div class="d-grid gap-2">
                        <button class="btn btn-outline-primary" onclick="refreshPage()">
                            <i class="fas fa-sync-alt me-2"></i>Làm mới trang
                        </button>
                        <button class="btn btn-outline-info" onclick="viewTodayBookings()">
                            <i class="fas fa-calendar-day me-2"></i>Xem lịch hẹn hôm nay
                        </button>
                        <button class="btn btn-outline-secondary" onclick="manualCheckInModal()">
                            <i class="fas fa-user-plus me-2"></i>Check-in thủ công
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Manual Check-in Modal -->
    <div class="modal fade" id="manualCheckInModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-user-plus me-2"></i>Check-in thủ công
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="manualBookingId" class="form-label">ID Booking</label>
                        <input type="number" class="form-control" id="manualBookingId" 
                               placeholder="Nhập ID booking">
                    </div>
                    <div class="mb-3">
                        <label for="manualCustomerName" class="form-label">Tên khách hàng (để xác nhận)</label>
                        <input type="text" class="form-control" id="manualCustomerName" 
                               placeholder="Nhập tên khách hàng">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-checkin" onclick="processManualCheckIn()">
                        <i class="fas fa-check me-1"></i>Check-in
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- QR Check-in JavaScript -->
    <script src="${pageContext.request.contextPath}/js/qr-checkin.js"></script>
</body>
</html>
