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
        
        .notification-card {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid var(--priority-color, #ddd);
            transition: all 0.3s ease;
        }
        
        .notification-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        }
        
        .notification-card.unread {
            background: linear-gradient(135deg, #fff9e6 0%, #fff3cd 100%);
            border-left-color: var(--spa-warning);
        }
        
        .notification-card.priority-high {
            --priority-color: var(--spa-danger);
        }
        
        .notification-card.priority-urgent {
            --priority-color: #dc143c;
            animation: pulse-urgent 2s infinite;
        }
        
        .notification-card.priority-medium {
            --priority-color: var(--spa-info);
        }
        
        .notification-card.priority-low {
            --priority-color: #6c757d;
        }
        
        @keyframes pulse-urgent {
            0%, 100% { border-left-color: #dc143c; }
            50% { border-left-color: #ff6b6b; }
        }
        
        .notification-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
        }
        
        .notification-icon.system-announcement {
            background: linear-gradient(135deg, var(--spa-info) 0%, #20c997 100%);
        }
        
        .notification-icon.promotion {
            background: linear-gradient(135deg, var(--spa-warning) 0%, #fd7e14 100%);
        }
        
        .notification-icon.booking-reminder {
            background: linear-gradient(135deg, var(--spa-success) 0%, #20c997 100%);
        }
        
        .notification-meta {
            font-size: 0.85rem;
            color: #6c757d;
        }
        
        .priority-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-weight: 600;
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
            gap: 0.5rem;
            margin-top: 1rem;
        }
        
        .btn-spa {
            background: linear-gradient(135deg, var(--spa-primary) 0%, var(--spa-secondary) 100%);
            border: none;
            color: white;
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.875rem;
            transition: all 0.3s ease;
        }
        
        .btn-spa:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            color: white;
        }
        
        .notification-filters {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .notification-summary {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .summary-item {
            text-align: center;
            padding: 0.5rem;
        }
        
        .summary-number {
            font-size: 2rem;
            font-weight: bold;
            color: var(--spa-primary);
        }
        
        .summary-label {
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
        
        .notification-image {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            margin: 1rem 0;
        }
        
        .action-button {
            display: inline-block;
            margin-top: 1rem;
            padding: 0.5rem 1rem;
            background: var(--spa-primary);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .action-button:hover {
            background: var(--spa-secondary);
            color: white;
            text-decoration: none;
            transform: translateY(-1px);
        }
    </style>
</head>
<body>
    <!-- Notification Header -->
    <div class="notification-header">
        <div class="container-fluid">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1><i class="fas fa-bell me-3"></i>Thông Báo</h1>
                    <p class="mb-0">Cập nhật thông tin và ưu đãi mới nhất</p>
                </div>
                <div class="col-md-4 text-end">
                    <small class="d-block">Khách hàng: ${sessionScope.customer.fullName}</small>
                    <a href="${pageContext.request.contextPath}/customer/dashboard" class="btn btn-outline-light btn-sm mt-2">
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
                <div class="col-md-6">
                    <div class="summary-item">
                        <div class="summary-number">${totalCount}</div>
                        <div class="summary-label">Tổng thông báo</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="summary-item">
                        <div class="summary-number text-warning">${unreadCount}</div>
                        <div class="summary-label">Chưa đọc</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Notification Filters -->
        <div class="notification-filters">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <div class="d-flex gap-2">
                        <a href="?filter=all" class="btn ${empty filter || filter == 'all' ? 'btn-spa' : 'btn-outline-secondary'} btn-sm">
                            <i class="fas fa-list me-1"></i>Tất cả
                        </a>
                        <a href="?filter=unread" class="btn ${filter == 'unread' ? 'btn-spa' : 'btn-outline-secondary'} btn-sm">
                            <i class="fas fa-envelope me-1"></i>Chưa đọc (${unreadCount})
                        </a>
                    </div>
                </div>
                <div class="col-md-6 text-end">
                    <button class="btn btn-outline-info btn-sm" onclick="refreshNotifications()">
                        <i class="fas fa-sync-alt me-1"></i>Làm mới
                    </button>
                </div>
            </div>
        </div>

        <!-- Notifications List -->
        <div class="row">
            <div class="col-12">
                <c:choose>
                    <c:when test="${empty notifications}">
                        <div class="empty-state">
                            <i class="fas fa-bell-slash"></i>
                            <h4>Không có thông báo</h4>
                            <p>Hiện tại không có thông báo nào để hiển thị.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="notification" items="${notifications}" varStatus="status">
                            <div class="notification-card ${notification.isReadByCurrentUser ? '' : 'unread'} priority-${notification.priority.toLowerCase()}" 
                                 data-notification-id="${notification.notificationId}">
                                <div class="row align-items-start">
                                    <div class="col-auto">
                                        <div class="notification-icon ${notification.notificationType.toLowerCase().replace('_', '-')}">
                                            <i class="${notification.typeIconClass}"></i>
                                        </div>
                                    </div>
                                    <div class="col">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h6 class="mb-1">${notification.title}</h6>
                                            <div class="d-flex gap-2 align-items-center">
                                                <span class="priority-badge priority-${notification.priority.toLowerCase()}">
                                                    ${notification.priorityDisplayText}
                                                </span>
                                                <c:if test="${!notification.isReadByCurrentUser}">
                                                    <span class="badge bg-warning">Mới</span>
                                                </c:if>
                                            </div>
                                        </div>
                                        
                                        <p class="mb-2">${notification.message}</p>
                                        
                                        <c:if test="${notification.hasImage()}">
                                            <img src="${notification.imageUrl}" alt="Notification Image" class="notification-image">
                                        </c:if>
                                        
                                        <div class="notification-meta">
                                            <i class="fas fa-clock me-1"></i>${notification.timeElapsed}
                                            <span class="mx-2">•</span>
                                            <i class="fas fa-tag me-1"></i>${notification.typeDisplayText}
                                        </div>
                                        
                                        <c:if test="${notification.hasAction()}">
                                            <a href="${notification.actionUrl}" class="action-button" target="_blank">
                                                ${notification.actionText != null ? notification.actionText : 'Xem chi tiết'}
                                            </a>
                                        </c:if>
                                        
                                        <div class="notification-actions">
                                            <c:if test="${!notification.isReadByCurrentUser}">
                                                <button class="btn btn-outline-primary btn-sm" 
                                                        onclick="markAsRead(${notification.notificationId})">
                                                    <i class="fas fa-eye me-1"></i>Đánh dấu đã đọc
                                                </button>
                                            </c:if>
                                            <c:if test="${!notification.isDismissedByCurrentUser}">
                                                <button class="btn btn-outline-secondary btn-sm" 
                                                        onclick="markAsDismissed(${notification.notificationId})">
                                                    <i class="fas fa-times me-1"></i>Bỏ qua
                                                </button>
                                            </c:if>
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

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Notification JavaScript -->
    <script src="${pageContext.request.contextPath}/js/general-notifications.js"></script>
</body>
</html>
