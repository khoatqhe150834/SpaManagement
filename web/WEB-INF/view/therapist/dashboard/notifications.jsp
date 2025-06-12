<%-- 
    Document   : notifications.jsp
    Created on : Therapist Notifications Page
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông Báo - Therapist Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/therapist/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Thông Báo</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Bảng Điều Khiển
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Thông Báo</li>
            </ul>
        </div>

        <div class="row gy-4">
            <!-- Notification Actions -->
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center justify-content-between flex-wrap gap-3">
                            <h6 class="mb-0">Quản Lý Thông Báo</h6>
                            <div class="d-flex align-items-center gap-2">
                                <button type="button" class="btn btn-outline-primary btn-sm">
                                    <iconify-icon icon="solar:check-read-outline"></iconify-icon>
                                    Đánh Dấu Tất Cả Đã Đọc
                                </button>
                                <button type="button" class="btn btn-outline-danger btn-sm">
                                    <iconify-icon icon="solar:trash-bin-trash-outline"></iconify-icon>
                                    Xóa Đã Đọc
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Notifications List -->
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <div class="notification-list">
                            <!-- New Appointment Notification -->
                            <div class="notification-item border-bottom pb-16 mb-16">
                                <div class="d-flex align-items-start gap-12">
                                    <div class="w-40-px h-40-px bg-success-focus text-success-main rounded-circle d-flex justify-content-center align-items-center flex-shrink-0">
                                        <iconify-icon icon="solar:calendar-add-outline" class="text-lg"></iconify-icon>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="d-flex align-items-start justify-content-between mb-8">
                                            <h6 class="text-md mb-0">Lịch Hẹn Mới</h6>
                                            <div class="d-flex align-items-center gap-8">
                                                <span class="bg-success-focus text-success-main px-8 py-2 rounded-pill fw-medium text-xs">Mới</span>
                                                <span class="text-secondary-light text-sm">5 phút trước</span>
                                            </div>
                                        </div>
                                        <p class="text-secondary-light mb-12">
                                            Khách hàng <strong>Nguyễn Thị Lan</strong> đã đặt lịch hẹn 
                                            <strong>Massage Thư Giãn</strong> vào ngày 18/12/2024 lúc 14:00
                                        </p>
                                        <div class="d-flex align-items-center gap-8">
                                            <button type="button" class="btn btn-outline-primary btn-sm">
                                                <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                                Xem Chi Tiết
                                            </button>
                                            <button type="button" class="btn btn-outline-success btn-sm">
                                                <iconify-icon icon="solar:check-circle-outline"></iconify-icon>
                                                Xác Nhận
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Schedule Change Notification -->
                            <div class="notification-item border-bottom pb-16 mb-16">
                                <div class="d-flex align-items-start gap-12">
                                    <div class="w-40-px h-40-px bg-warning-focus text-warning-main rounded-circle d-flex justify-content-center align-items-center flex-shrink-0">
                                        <iconify-icon icon="solar:calendar-outline" class="text-lg"></iconify-icon>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="d-flex align-items-start justify-content-between mb-8">
                                            <h6 class="text-md mb-0">Thay Đổi Lịch Trình</h6>
                                            <span class="text-secondary-light text-sm">1 giờ trước</span>
                                        </div>
                                        <p class="text-secondary-light mb-12">
                                            Lịch hẹn của <strong>Trần Văn Nam</strong> đã được thay đổi 
                                            từ 10:00 sang 15:00 ngày 17/12/2024
                                        </p>
                                        <div class="d-flex align-items-center gap-8">
                                            <button type="button" class="btn btn-outline-primary btn-sm">
                                                <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                                Xem Chi Tiết
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Supply Request Approved -->
                            <div class="notification-item border-bottom pb-16 mb-16">
                                <div class="d-flex align-items-start gap-12">
                                    <div class="w-40-px h-40-px bg-info-focus text-info-main rounded-circle d-flex justify-content-center align-items-center flex-shrink-0">
                                        <iconify-icon icon="solar:box-outline" class="text-lg"></iconify-icon>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="d-flex align-items-start justify-content-between mb-8">
                                            <h6 class="text-md mb-0">Yêu Cầu Vật Tư Được Duyệt</h6>
                                            <span class="text-secondary-light text-sm">3 giờ trước</span>
                                        </div>
                                        <p class="text-secondary-light mb-12">
                                            Yêu cầu <strong>20 chiếc khăn massage</strong> của bạn đã được duyệt 
                                            và sẽ được giao trong hôm nay
                                        </p>
                                        <div class="d-flex align-items-center gap-8">
                                            <button type="button" class="btn btn-outline-primary btn-sm">
                                                <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                                Xem Chi Tiết
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Training Reminder -->
                            <div class="notification-item border-bottom pb-16 mb-16">
                                <div class="d-flex align-items-start gap-12">
                                    <div class="w-40-px h-40-px bg-purple-focus text-purple-main rounded-circle d-flex justify-content-center align-items-center flex-shrink-0">
                                        <iconify-icon icon="solar:book-outline" class="text-lg"></iconify-icon>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="d-flex align-items-start justify-content-between mb-8">
                                            <h6 class="text-md mb-0">Nhắc Nhở Đào Tạo</h6>
                                            <span class="text-secondary-light text-sm">1 ngày trước</span>
                                        </div>
                                        <p class="text-secondary-light mb-12">
                                            Khóa đào tạo <strong>"Kỹ thuật Massage Hot Stone"</strong> 
                                            sẽ bắt đầu vào ngày 20/12/2024. Vui lòng chuẩn bị trước
                                        </p>
                                        <div class="d-flex align-items-center gap-8">
                                            <button type="button" class="btn btn-outline-primary btn-sm">
                                                <iconify-icon icon="solar:calendar-add-outline"></iconify-icon>
                                                Thêm Vào Lịch
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Customer Review -->
                            <div class="notification-item">
                                <div class="d-flex align-items-start gap-12">
                                    <div class="w-40-px h-40-px bg-primary-focus text-primary-main rounded-circle d-flex justify-content-center align-items-center flex-shrink-0">
                                        <iconify-icon icon="solar:star-outline" class="text-lg"></iconify-icon>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="d-flex align-items-start justify-content-between mb-8">
                                            <h6 class="text-md mb-0">Đánh Giá Mới</h6>
                                            <span class="text-secondary-light text-sm">2 ngày trước</span>
                                        </div>
                                        <p class="text-secondary-light mb-12">
                                            <strong>Lê Thị Hoa</strong> đã đánh giá dịch vụ của bạn 
                                            <strong>5 sao</strong> và để lại nhận xét tích cực
                                        </p>
                                        <div class="d-flex align-items-center gap-8">
                                            <button type="button" class="btn btn-outline-primary btn-sm">
                                                <iconify-icon icon="solar:eye-outline"></iconify-icon>
                                                Xem Đánh Giá
                                            </button>
                                            <button type="button" class="btn btn-outline-info btn-sm">
                                                <iconify-icon icon="solar:chat-round-outline"></iconify-icon>
                                                Trả Lời
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Load More -->
                        <div class="text-center mt-24">
                            <button type="button" class="btn btn-outline-primary">
                                <iconify-icon icon="solar:refresh-outline"></iconify-icon>
                                Tải Thêm Thông Báo
                            </button>
                        </div>

                        <!-- Empty State -->
                        <div class="text-center py-5" style="display: none;">
                            <iconify-icon icon="solar:bell-off-outline" class="text-secondary-light mb-16" style="font-size: 64px;"></iconify-icon>
                            <h6 class="mb-8">Không có thông báo mới</h6>
                            <p class="text-secondary-light mb-0">Bạn đã xem hết tất cả thông báo</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 