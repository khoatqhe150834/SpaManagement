<%-- 
    Document   : dashboard.jsp
    Created on : Customer Dashboard Overview
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Bảng Điều Khiển Khách Hàng - BeautyZone Spa</title>
    
    <!-- Include Admin Framework Styles -->
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    
    <style>
        /* Essential Layout Styles - Using Admin Framework Variables */
        .dashboard-container {
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto;
            min-height: 100vh;
        }
        
        .dashboard-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
            padding: 1.5rem 2rem;
        }
        
        .next-appointment {
            text-align: right;
        }
        
        /* Grid Layouts */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .quick-actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .two-column-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        /* Stat Cards */
        .stat-card {
            padding: 1.5rem;
        }
        
        .stat-content {
            display: flex;
            align-items: center;
        }
        
        .stat-icon {
            padding: 0.75rem;
            margin-right: 1rem;
            font-size: 1.5rem;
        }
        
        /* Promotion Banner */
        .promotion-banner {
            padding: 2rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }
        
        .promotion-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .promotion-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
        }
        
        .promotion-discount {
            text-align: right;
        }
        
        /* Card Headers */
        .card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }
        
        /* List Items */
        .list-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.75rem;
            margin-bottom: 0.75rem;
        }
        
        .list-item:last-child {
            margin-bottom: 0;
        }
        
        /* Custom Utilities */
        .btn-full {
            width: 100%;
            margin-top: 1rem;
        }
        
        .notification-dot {
            width: 0.5rem;
            height: 0.5rem;
            border-radius: 50%;
            margin-top: 0.5rem;
            flex-shrink: 0;
        }
        
        .dot-coral { background: var(--danger-600); }
        .dot-emerald { background: var(--success-600); }
        .dot-sage { background: var(--primary-600); }
        
        /* Responsive */
        @media (max-width: 768px) {
            .dashboard-container {
                padding: 1rem;
            }
            
            .dashboard-header {
                flex-direction: column;
                align-items: flex-start;
                padding: 1rem;
            }
            
            .next-appointment {
                text-align: left;
            }
            
            .promotion-content {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .promotion-discount {
                text-align: left;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .quick-actions-grid {
                grid-template-columns: 1fr;
            }
            
            .two-column-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

</head>
<body>
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />
    
    <div class="dashboard-main-body">
        <div class="dashboard-container bg-base">
        <!-- Header Section -->
        <div class="dashboard-header card bg-base border-neutral-200 radius-12 shadow-1">
            <div class="welcome-section">
                <h2 class="text-neutral-900">Chào mừng trở lại, ${sessionScope.customer.fullName != null ? sessionScope.customer.fullName : 'Khách Hàng Thân Thiết'}!</h2>
                <p class="text-neutral-600">Đây là tổng quan hành trình spa của bạn</p>
            </div>
            <div class="next-appointment">
                <p class="text-neutral-600">Lịch Hẹn Tiếp Theo</p>
                <p class="text-neutral-900">Ngày mai lúc 2:00 PM</p>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card sage card bg-base border-neutral-200 radius-12 shadow-1">
                <div class="stat-content">
                    <div class="stat-icon sage">
                        <iconify-icon icon="solar:calendar-bold"></iconify-icon>
                    </div>
                    <div class="stat-info">
                        <p class="text-neutral-600">Sắp Tới</p>
                        <p class="text-neutral-900">2</p>
                        <p class="text-neutral-500">lịch hẹn</p>
                    </div>
                </div>
            </div>

            <div class="stat-card coral card bg-base border-neutral-200 radius-12 shadow-1">
                <div class="stat-content">
                    <div class="stat-icon coral">
                        <iconify-icon icon="solar:gift-bold"></iconify-icon>
                    </div>
                    <div class="stat-info">
                        <p class="text-neutral-600">Điểm Thưởng</p>
                        <p class="text-neutral-900">${sessionScope.customer.loyaltyPoints != null ? sessionScope.customer.loyaltyPoints : 1240}</p>
                        <p class="text-neutral-500">có thể đổi thưởng</p>
                    </div>
                </div>
            </div>

            <div class="stat-card stone card bg-base border-neutral-200 radius-12 shadow-1">
                <div class="stat-content">
                    <div class="stat-icon stone">
                        <iconify-icon icon="solar:clock-circle-bold"></iconify-icon>
                    </div>
                    <div class="stat-info">
                        <p class="text-neutral-600">Giờ Thư Giãn</p>
                        <p class="text-neutral-900">24</p>
                        <p class="text-neutral-500">năm nay</p>
                    </div>
                </div>
            </div>

            <div class="stat-card emerald card bg-base border-neutral-200 radius-12 shadow-1">
                <div class="stat-content">
                    <div class="stat-icon emerald">
                        <iconify-icon icon="solar:chart-2-bold"></iconify-icon>
                    </div>
                    <div class="stat-info">
                        <p class="text-neutral-600">Thành Viên</p>
                        <p class="text-neutral-900" style="font-size: 1.5rem;">Vàng</p>
                        <p class="text-neutral-500">hạng thành viên</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Current Promotion -->
        <div class="promotion-banner bg-danger-gradient text-white radius-12">
            <div class="promotion-content">
                <div class="promotion-text">
                    <h3 class="text-white"><iconify-icon icon="solar:leaf-bold" style="margin-right: 0.5rem;"></iconify-icon>Ưu Đãi Mùa Xuân Đặc Biệt</h3>
                    <p class="text-light-100">Đặt bất kỳ liệu pháp massage 90 phút và nhận miễn phí dịch vụ chăm sóc da mặt</p>
                    <div class="promotion-actions">
                        <span class="promotion-badge bg-light-100 bg-opacity-20 text-white radius-50">Có hiệu lực đến 31 tháng 3</span>
                        <a href="${pageContext.request.contextPath}/customer-dashboard/appointments/booking" class="promotion-button btn btn-light-100 text-danger-600 radius-8">Đặt Ngay</a>
                    </div>
                </div>
                <div class="promotion-discount">
                    <p class="text-white">25%</p>
                    <p class="text-light-100">GIẢM</p>
                </div>
            </div>
        </div>

        <!-- Quick Actions Grid -->
        <div class="quick-actions-grid">
            <!-- Upcoming Appointments -->
            <div class="card bg-base border-neutral-200 radius-12 shadow-1">
                <div class="card-header">
                    <h3 class="text-neutral-900">Lịch Hẹn Sắp Tới</h3>
                    <iconify-icon icon="solar:calendar-bold" class="card-icon text-neutral-600"></iconify-icon>
                </div>
                <div class="appointments-list">
                    <div class="list-item bg-neutral-50 radius-8">
                        <div>
                            <p class="fw-medium text-neutral-900 m-0">Massage Mô Sâu</p>
                            <p class="text-sm text-neutral-600 m-0">với Emma Thompson</p>
                        </div>
                        <div class="text-end">
                            <p class="text-sm fw-medium text-neutral-900 m-0">Ngày Mai</p>
                            <p class="text-sm text-neutral-600 m-0">2:00 PM</p>
                        </div>
                    </div>
                    <div class="list-item bg-neutral-50 radius-8">
                        <div>
                            <p class="fw-medium text-neutral-900 m-0">Liệu Pháp Hương Thơm</p>
                            <p class="text-sm text-neutral-600 m-0">với Sarah Wilson</p>
                        </div>
                        <div class="text-end">
                            <p class="text-sm fw-medium text-neutral-900 m-0">28 tháng 3</p>
                            <p class="text-sm text-neutral-600 m-0">10:00 AM</p>
                        </div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/customer-dashboard/appointments/booking" class="btn btn-primary-600 text-white btn-full radius-8">Đặt Lịch Hẹn Mới</a>
            </div>

            <!-- Available Rewards -->
            <div class="card bg-base border-neutral-200 radius-12 shadow-1">
                <div class="card-header">
                    <h3 class="text-neutral-900">Phần Thưởng Có Sẵn</h3>
                    <iconify-icon icon="solar:gift-bold" class="card-icon text-neutral-600"></iconify-icon>
                </div>
                <div class="rewards-list">
                    <div class="list-item bg-neutral-50 radius-8">
                        <div>
                            <p class="fw-medium text-neutral-900 m-0">Massage Miễn Phí 30 Phút</p>
                            <p class="text-sm text-neutral-600 m-0">800 điểm</p>
                        </div>
                        <button class="btn btn-danger-600 text-white radius-8">Đổi Thưởng</button>
                    </div>
                    <div class="list-item bg-neutral-50 radius-8">
                        <div>
                            <p class="fw-medium text-neutral-900 m-0">Chăm Sóc Da Mặt</p>
                            <p class="text-sm text-neutral-600 m-0">1200 điểm</p>
                        </div>
                        <button class="btn btn-danger-600 text-white radius-8">Đổi Thưởng</button>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/customer-dashboard/rewards/rewards-list" class="btn btn-danger-600 text-white btn-full radius-8">Xem Tất Cả Phần Thưởng</a>
            </div>

            <!-- Quick Book Favorites -->
            <div class="card bg-base border-neutral-200 radius-12 shadow-1">
                <div class="card-header">
                    <h3 class="text-neutral-900">Dịch Vụ Yêu Thích</h3>
                    <iconify-icon icon="solar:star-bold" class="card-icon text-neutral-600"></iconify-icon>
                </div>
                <div class="favorites-list">
                    <div class="list-item bg-neutral-50 radius-8">
                        <div>
                            <p class="fw-medium text-neutral-900 m-0">Massage Mô Sâu</p>
                            <p class="text-sm text-neutral-600 m-0">với Emma Thompson</p>
                        </div>
                        <button class="btn btn-success-600 text-white radius-8">Đặt Lịch</button>
                    </div>
                    <div class="list-item bg-neutral-50 radius-8">
                        <div>
                            <p class="fw-medium text-neutral-900 m-0">Liệu Pháp Hương Thơm</p>
                            <p class="text-sm text-neutral-600 m-0">với Emma Thompson</p>
                        </div>
                        <button class="btn btn-success-600 text-white radius-8">Đặt Lịch</button>
                    </div>
                </div>
                <a href="#" class="btn btn-success-600 text-white btn-full radius-8">Quản Lý Yêu Thích</a>
            </div>
        </div>

        <!-- Recent Activity & Recommendations -->
        <div class="two-column-grid">
            <!-- Recent Treatments -->
            <div class="card bg-base border-neutral-200 radius-12 shadow-1">
                <div class="card-header">
                    <h3 class="text-neutral-900">Liệu Pháp Gần Đây</h3>
                    <iconify-icon icon="solar:document-text-bold" class="card-icon text-neutral-600"></iconify-icon>
                </div>
                <div class="treatments-list">
                    <div class="list-item bg-neutral-50 radius-8">
                        <div class="d-flex align-items-center gap-16">
                            <div class="dot-emerald notification-dot"></div>
                            <div>
                                <p class="fw-medium text-neutral-900 m-0">Massage Thụy Điển</p>
                                <p class="text-sm text-neutral-600 m-0">với Emma Thompson</p>
                            </div>
                        </div>
                        <div class="text-end">
                            <p class="text-sm fw-medium text-neutral-900 m-0">15 tháng 3</p>
                            <p class="text-sm text-neutral-600 m-0">120.000đ</p>
                        </div>
                    </div>
                    <div class="list-item bg-neutral-50 radius-8">
                        <div class="d-flex align-items-center gap-16">
                            <div class="dot-emerald notification-dot"></div>
                            <div>
                                <p class="fw-medium text-neutral-900 m-0">Chăm Sóc Da Mặt</p>
                                <p class="text-sm text-neutral-600 m-0">với Sarah Wilson</p>
                            </div>
                        </div>
                        <div class="text-end">
                            <p class="text-sm fw-medium text-neutral-900 m-0">10 tháng 3</p>
                            <p class="text-sm text-neutral-600 m-0">85.000đ</p>
                        </div>
                    </div>
                    <div class="list-item bg-neutral-50 radius-8">
                        <div class="d-flex align-items-center gap-16">
                            <div class="dot-emerald notification-dot"></div>
                            <div>
                                <p class="fw-medium text-neutral-900 m-0">Liệu Pháp Hương Thơm</p>
                                <p class="text-sm text-neutral-600 m-0">với Emma Thompson</p>
                            </div>
                        </div>
                        <div class="text-end">
                            <p class="text-sm fw-medium text-neutral-900 m-0">5 tháng 3</p>
                            <p class="text-sm text-neutral-600 m-0">95.000đ</p>
                        </div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/customer-dashboard/treatments/history" class="btn btn-text text-primary-600 btn-full">Xem Lịch Sử Đầy Đủ</a>
            </div>

            <!-- Product Recommendations -->
            <div class="card bg-base border-neutral-200 radius-12 shadow-1">
                <div class="card-header">
                    <h3 class="text-neutral-900">Đề Xuất Cho Bạn</h3>
                    <iconify-icon icon="solar:bag-smile-bold" class="card-icon text-neutral-600"></iconify-icon>
                </div>
                <div class="products-list">
                    <div class="list-item bg-neutral-50 radius-8 border border-neutral-200">
                        <div>
                            <p class="fw-medium text-neutral-900 m-0">Tinh Dầu Hoa Oải Hương</p>
                            <p class="text-sm text-neutral-600 m-0">Dựa trên liệu pháp hương thơm của bạn</p>
                        </div>
                        <div class="text-end">
                            <p class="fw-semibold text-neutral-900 m-0">45.000đ</p>
                            <button class="btn btn-text text-primary-600 text-sm p-0">Thêm Vào Giỏ</button>
                        </div>
                    </div>
                    <div class="list-item bg-neutral-50 radius-8 border border-neutral-200">
                        <div>
                            <p class="fw-medium text-neutral-900 m-0">Mặt Nạ Dưỡng Ẩm</p>
                            <p class="text-sm text-neutral-600 m-0">Hoàn hảo cho loại da của bạn</p>
                        </div>
                        <div class="text-end">
                            <p class="fw-semibold text-neutral-900 m-0">32.000đ</p>
                            <button class="btn btn-text text-primary-600 text-sm p-0">Thêm Vào Giỏ</button>
                        </div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/customer-dashboard/recommendations/services" class="btn btn-primary-600 text-white btn-full radius-8">Xem Tất Cả Đề Xuất</a>
            </div>
        </div>

        <!-- Notifications -->
        <div class="card bg-base border-neutral-200 radius-12 shadow-1">
            <div class="card-header">
                <h3 class="text-neutral-900">Thông Báo Gần Đây</h3>
                <iconify-icon icon="solar:bell-bold" class="card-icon text-neutral-600"></iconify-icon>
            </div>
            <div class="notifications-list">
                <div class="d-flex align-items-start gap-12 p-12 bg-neutral-50 radius-8 mb-12">
                    <div class="notification-dot dot-coral"></div>
                    <div class="flex-grow-1">
                        <p class="text-sm text-neutral-900 m-0 mb-4">Nhắc nhở lịch hẹn: Massage Thụy Điển ngày mai lúc 2:00 PM</p>
                        <p class="text-xxs text-neutral-600 m-0">2 giờ trước</p>
                    </div>
                </div>
                <div class="d-flex align-items-start gap-12 p-12 bg-neutral-50 radius-8 mb-12">
                    <div class="notification-dot dot-emerald"></div>
                    <div class="flex-grow-1">
                        <p class="text-sm text-neutral-900 m-0 mb-4">Chương trình khuyến mãi mùa xuân mới - Giảm 25% dịch vụ chăm sóc da mặt</p>
                        <p class="text-xxs text-neutral-600 m-0">1 ngày trước</p>
                    </div>
                </div>
                <div class="d-flex align-items-start gap-12 p-12 bg-neutral-50 radius-8">
                    <div class="notification-dot dot-sage"></div>
                    <div class="flex-grow-1">
                        <p class="text-sm text-neutral-900 m-0 mb-4">Bạn đã nhận được 120 điểm thưởng từ lần ghé thăm gần nhất</p>
                        <p class="text-xxs text-neutral-600 m-0">3 ngày trước</p>
                    </div>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/customer-dashboard/dashboard/notifications" class="btn btn-text text-primary-600 btn-full">Xem Tất Cả Thông Báo</a>
        </div>
        </div>
    </div>
    
    <!-- Include Admin Framework JavaScript -->
    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 