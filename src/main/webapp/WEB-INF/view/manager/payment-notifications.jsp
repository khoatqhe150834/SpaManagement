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
        
        .notification-header {
            background: linear-gradient(135deg, var(--spa-primary) 0%, var(--spa-secondary) 100%);
            color: white;
            padding: 1.5rem 0;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .payment-notification-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border-left: 5px solid var(--priority-color, #ddd);
            transition: all 0.3s ease;
            position: relative;
        }
        
        .payment-notification-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .payment-notification-card.unread {
            background: linear-gradient(135deg, #fff9e6 0%, #fff3cd 100%);
            border-left-color: var(--spa-warning);
        }
        
        .payment-notification-card.priority-high {
            --priority-color: var(--spa-danger);
        }
        
        .payment-notification-card.priority-urgent {
            --priority-color: #dc143c;
            animation: pulse-urgent 2s infinite;
        }
        
        .payment-notification-card.priority-medium {
            --priority-color: var(--spa-info);
        }
        
        .payment-notification-card.priority-low {
            --priority-color: #6c757d;
        }
        
        @keyframes pulse-urgent {
            0%, 100% { border-left-color: #dc143c; }
            50% { border-left-color: #ff6b6b; }
        }
        
        .payment-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            background: linear-gradient(135deg, var(--spa-success) 0%, #20c997 100%);
            margin-right: 1rem;
        }
        
        .payment-details {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin: 1rem 0;
        }
        
        .payment-amount {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--spa-primary);
        }
        
        .service-list {
            background: white;
            border-radius: 6px;
            padding: 0.75rem;
            margin-top: 0.5rem;
            border: 1px solid #e9ecef;
        }
        
        .priority-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .priority-high {
            background: var(--spa-danger);
            color: white;
        }
        
        .priority-urgent {
            background: #dc143c;
            color: white;
            animation: blink 1.5s infinite;
        }
        
        .priority-medium {
            background: var(--spa-info);
            color: white;
        }
        
        .priority-low {
            background: #6c757d;
            color: white;
        }
        
        @keyframes blink {
            0%, 50% { opacity: 1; }
            51%, 100% { opacity: 0.7; }
        }
        
        .notification-actions {
            display: flex;
            gap: 0.75rem;
            margin-top: 1.5rem;
            flex-wrap: wrap;
        }
        
        .btn-spa {
            background: linear-gradient(135deg, var(--spa-primary) 0%, var(--spa-secondary) 100%);
            border: none;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .btn-spa:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            color: white;
        }
        
        .btn-schedule {
            background: linear-gradient(135deg, var(--spa-success) 0%, #20c997 100%);
            border: none;
            color: white;
            padding: 0.5rem 1.25rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .btn-schedule:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            color: white;
        }
        
        .notification-filters {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .notification-summary {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .summary-item {
            text-align: center;
            padding: 1rem;
        }
        
        .summary-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: var(--spa-primary);
        }
        
        .summary-label {
            font-size: 1rem;
            color: #6c757d;
            margin-top: 0.5rem;
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 5rem;
            margin-bottom: 1.5rem;
            opacity: 0.5;
        }
        
        .status-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-weight: 600;
        }
        
        .status-unread {
            background: var(--spa-warning);
            color: #856404;
        }
        
        .status-read {
            background: var(--spa-info);
            color: white;
        }
        
        .status-acknowledged {
            background: var(--spa-success);
            color: white;
        }
        
        .customer-info {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .customer-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--spa-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            margin-right: 0.75rem;
        }
        
        .time-elapsed {
            font-size: 0.85rem;
            color: #6c757d;
            margin-top: 0.5rem;
        }
        
        .websocket-indicator {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
            display: none;
        }
        
        .websocket-connected {
            background: var(--spa-success);
            color: white;
        }
        
        .websocket-disconnected {
            background: var(--spa-danger);
            color: white;
        }
    </style>
</head>
<body>
    <!-- WebSocket Status Indicator -->
    <div id="websocketIndicator" class="websocket-indicator">
        <i class="fas fa-wifi"></i> <span id="websocketStatus">Đang kết nối...</span>
    </div>

    <!-- Notification Header -->
    <div class="notification-header">
        <div class="container-fluid">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1><i class="fas fa-credit-card me-3"></i>Thông Báo Thanh Toán</h1>
                    <p class="mb-0">Quản lý lịch hẹn từ thanh toán hoàn tất</p>
                </div>
                <div class="col-md-4 text-end">
                    <small class="d-block">Quản lý: ${sessionScope.user.fullName}</small>
                    <a href="${pageContext.request.contextPath}/manager/dashboard" class="btn btn-outline-light btn-sm mt-2">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container-fluid">
        <!-- Notification Summary -->
        <div class="notification-summary">
            <div class="row">
                <div class="col-md-3">
                    <div class="summary-item">
                        <div class="summary-number">${totalCount}</div>
                        <div class="summary-label">Tổng thông báo</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="summary-item">
                        <div class="summary-number text-warning">${unreadCount}</div>
                        <div class="summary-label">Chưa đọc</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="summary-item">
                        <div class="summary-number text-danger">${unacknowledgedCount}</div>
                        <div class="summary-label">Chưa xử lý</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="summary-item">
                        <div class="summary-number text-success" id="processedCount">${totalCount - unacknowledgedCount}</div>
                        <div class="summary-label">Đã xử lý</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Notification Filters -->
        <div class="notification-filters">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <div class="d-flex gap-2 flex-wrap">
                        <a href="?filter=all" class="btn ${empty filter || filter == 'all' ? 'btn-spa' : 'btn-outline-secondary'} btn-sm">
                            <i class="fas fa-list me-1"></i>Tất cả
                        </a>
                        <a href="?filter=unread" class="btn ${filter == 'unread' ? 'btn-spa' : 'btn-outline-secondary'} btn-sm">
                            <i class="fas fa-envelope me-1"></i>Chưa đọc (${unreadCount})
                        </a>
                        <button class="btn btn-outline-info btn-sm" onclick="refreshNotifications()">
                            <i class="fas fa-sync-alt me-1"></i>Làm mới
                        </button>
                        <button class="btn btn-outline-success btn-sm" onclick="markAllAsRead()">
                            <i class="fas fa-check-double me-1"></i>Đánh dấu tất cả đã đọc
                        </button>
                    </div>
                </div>
                <div class="col-md-4 text-end">
                    <div class="form-check form-switch d-inline-block me-3">
                        <input class="form-check-input" type="checkbox" id="autoRefresh" checked>
                        <label class="form-check-label" for="autoRefresh">Tự động làm mới</label>
                    </div>
                    <div class="form-check form-switch d-inline-block">
                        <input class="form-check-input" type="checkbox" id="soundAlerts" checked>
                        <label class="form-check-label" for="soundAlerts">Âm thanh</label>
                    </div>
                </div>
            </div>
        </div>

        <!-- Notifications List -->
        <div class="row">
            <div class="col-12">
                <c:choose>
                    <c:when test="${empty notifications}">
                        <div class="empty-state">
                            <i class="fas fa-credit-card"></i>
                            <h4>Không có thông báo thanh toán</h4>
                            <p>Hiện tại không có thông báo thanh toán nào cần xử lý.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="notification" items="${notifications}" varStatus="status">
                            <div class="payment-notification-card ${notification.isRead ? '' : 'unread'} priority-${notification.priority.toLowerCase()}" 
                                 data-notification-id="${notification.notificationId}"
                                 data-payment-id="${notification.paymentId}">
                                
                                <div class="status-badge ${notification.statusCssClass}">
                                    ${notification.statusText}
                                </div>
                                
                                <div class="row">
                                    <div class="col-auto">
                                        <div class="payment-icon">
                                            <i class="${notification.typeIconClass}"></i>
                                        </div>
                                    </div>
                                    <div class="col">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h5 class="mb-1">${notification.title}</h5>
                                            <div class="d-flex gap-2 align-items-center">
                                                <span class="priority-badge priority-${notification.priority.toLowerCase()}">
                                                    ${notification.priorityDisplayText}
                                                </span>
                                                <c:if test="${notification.isUrgent()}">
                                                    <i class="fas fa-exclamation-triangle text-danger" title="Khẩn cấp"></i>
                                                </c:if>
                                            </div>
                                        </div>
                                        
                                        <div class="customer-info">
                                            <div class="customer-avatar">
                                                ${notification.customerName.substring(0, 1).toUpperCase()}
                                            </div>
                                            <div>
                                                <strong>${notification.customerName}</strong>
                                                <div class="time-elapsed">
                                                    <i class="fas fa-clock me-1"></i>${notification.timeElapsed}
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <p class="mb-2">${notification.message}</p>
                                        
                                        <div class="payment-details">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="payment-amount">
                                                        ${notification.formattedPaymentAmount}
                                                    </div>
                                                    <small class="text-muted">
                                                        Phương thức: ${notification.paymentMethodFromData}
                                                    </small>
                                                </div>
                                                <div class="col-md-6">
                                                    <div>
                                                        <strong>${notification.serviceCountFromData} dịch vụ</strong>
                                                    </div>
                                                    <small class="text-muted">
                                                        Mã: ${notification.referenceNumberFromData}
                                                    </small>
                                                </div>
                                            </div>
                                            
                                            <div class="service-list">
                                                <i class="fas fa-spa me-2"></i>
                                                ${notification.serviceListFromData}
                                            </div>
                                        </div>
                                        
                                        <div class="notification-actions">
                                            <c:if test="${!notification.isRead}">
                                                <button class="btn btn-outline-primary btn-sm" 
                                                        onclick="markAsRead(${notification.notificationId})">
                                                    <i class="fas fa-eye me-1"></i>Đánh dấu đã đọc
                                                </button>
                                            </c:if>
                                            
                                            <c:if test="${!notification.isAcknowledged}">
                                                <button class="btn btn-schedule" 
                                                        onclick="openSchedulingModal(${notification.paymentId}, ${notification.notificationId})">
                                                    <i class="fas fa-calendar-plus me-1"></i>Lên lịch hẹn
                                                </button>
                                                
                                                <button class="btn btn-outline-success btn-sm" 
                                                        onclick="markAsAcknowledged(${notification.notificationId})">
                                                    <i class="fas fa-check me-1"></i>Đánh dấu đã xử lý
                                                </button>
                                            </c:if>
                                            
                                            <button class="btn btn-outline-info btn-sm" 
                                                    onclick="viewPaymentDetails(${notification.paymentId})">
                                                <i class="fas fa-info-circle me-1"></i>Chi tiết thanh toán
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Scheduling Modal -->
    <div class="modal fade" id="schedulingModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-calendar-plus me-2"></i>Lên lịch hẹn
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="schedulingModalBody">
                    <!-- Scheduling form will be loaded here -->
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Payment Scheduling JavaScript -->
    <script src="${pageContext.request.contextPath}/js/payment-scheduling-notifications.js"></script>
</body>
</html>
