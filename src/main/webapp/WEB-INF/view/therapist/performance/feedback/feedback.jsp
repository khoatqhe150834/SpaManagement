<%-- 
    Document   : feedback.jsp
    Created on : Therapist Performance Feedback Page
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
    <title>Phản Hồi Khách Hàng - Therapist Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />

</head>
<body>
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Phản Hồi Khách Hàng</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Bảng Điều Khiển
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Phản Hồi Khách Hàng</li>
                </ul>
            </div>

            <!-- Summary Cards -->
            <div class="row gy-4 mb-24">
                <div class="col-xl-3 col-sm-6">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <span class="text-secondary-light mb-4 fw-medium">Đánh Giá Trung Bình</span>
                                    <h6 class="mb-0">4.8/5</h6>
                                </div>
                                <div class="w-50-px h-50-px bg-warning-focus text-warning-main rounded-circle d-flex justify-content-center align-items-center">
                                    <iconify-icon icon="solar:star-bold" class="text-2xl mb-0"></iconify-icon>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <span class="text-secondary-light mb-4 fw-medium">Tổng Đánh Giá</span>
                                    <h6 class="mb-0">156</h6>
                                </div>
                                <div class="w-50-px h-50-px bg-primary-focus text-primary-main rounded-circle d-flex justify-content-center align-items-center">
                                    <iconify-icon icon="solar:chat-round-dots-outline" class="text-2xl mb-0"></iconify-icon>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <span class="text-secondary-light mb-4 fw-medium">Hài Lòng</span>
                                    <h6 class="mb-0">94%</h6>
                                </div>
                                <div class="w-50-px h-50-px bg-success-focus text-success-main rounded-circle d-flex justify-content-center align-items-center">
                                    <iconify-icon icon="solar:like-outline" class="text-2xl mb-0"></iconify-icon>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <span class="text-secondary-light mb-4 fw-medium">Phản Hồi Mới</span>
                                    <h6 class="mb-0">3</h6>
                                </div>
                                <div class="w-50-px h-50-px bg-info-focus text-info-main rounded-circle d-flex justify-content-center align-items-center">
                                    <iconify-icon icon="solar:bell-outline" class="text-2xl mb-0"></iconify-icon>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Feedback List -->
            <div class="card">
                <div class="card-header">
                    <h6 class="card-title mb-0">Phản Hồi Gần Đây</h6>
                </div>
                <div class="card-body">
                    <div class="row gy-4">
                        <!-- Feedback Item -->
                        <div class="col-12">
                            <div class="card border">
                                <div class="card-body">
                                    <div class="d-flex align-items-start justify-content-between mb-16">
                                        <div class="d-flex align-items-center gap-12">
                                            <img src="${pageContext.request.contextPath}/assets/admin/images/avatar/avatar-1.png" alt="Avatar" class="w-50-px h-50-px rounded-circle flex-shrink-0">
                                            <div>
                                                <h6 class="mb-4">Nguyễn Thị Lan</h6>
                                                <span class="text-secondary-light text-sm">Massage Thư Giãn • 15/12/2024</span>
                                            </div>
                                        </div>
                                        <div class="d-flex align-items-center gap-8">
                                            <div class="d-flex align-items-center gap-1">
                                                <iconify-icon icon="solar:star-bold" class="text-warning-main text-lg"></iconify-icon>
                                                <iconify-icon icon="solar:star-bold" class="text-warning-main text-lg"></iconify-icon>
                                                <iconify-icon icon="solar:star-bold" class="text-warning-main text-lg"></iconify-icon>
                                                <iconify-icon icon="solar:star-bold" class="text-warning-main text-lg"></iconify-icon>
                                                <iconify-icon icon="solar:star-bold" class="text-warning-main text-lg"></iconify-icon>
                                            </div>
                                            <span class="fw-medium">5.0</span>
                                        </div>
                                    </div>
                                    <p class="text-secondary-light mb-16">
                                        "Dịch vụ massage rất tuyệt vời! Kỹ thuật của therapist rất chuyên nghiệp và chu đáo. 
                                        Tôi cảm thấy rất thư giãn sau buổi điều trị. Chắc chắn sẽ quay lại!"
                                    </p>
                                    <div class="d-flex align-items-center gap-8">
                                        <button type="button" class="btn btn-outline-primary btn-sm">
                                            <iconify-icon icon="solar:heart-outline"></iconify-icon>
                                            Thích
                                        </button>
                                        <button type="button" class="btn btn-outline-info btn-sm">
                                            <iconify-icon icon="solar:chat-round-outline"></iconify-icon>
                                            Trả Lời
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Another Feedback Item -->
                        <div class="col-12">
                            <div class="card border">
                                <div class="card-body">
                                    <div class="d-flex align-items-start justify-content-between mb-16">
                                        <div class="d-flex align-items-center gap-12">
                                            <img src="${pageContext.request.contextPath}/assets/admin/images/avatar/avatar-2.png" alt="Avatar" class="w-50-px h-50-px rounded-circle flex-shrink-0">
                                            <div>
                                                <h6 class="mb-4">Trần Văn Nam</h6>
                                                <span class="text-secondary-light text-sm">Chăm Sóc Da Mặt • 14/12/2024</span>
                                            </div>
                                        </div>
                                        <div class="d-flex align-items-center gap-8">
                                            <div class="d-flex align-items-center gap-1">
                                                <iconify-icon icon="solar:star-bold" class="text-warning-main text-lg"></iconify-icon>
                                                <iconify-icon icon="solar:star-bold" class="text-warning-main text-lg"></iconify-icon>
                                                <iconify-icon icon="solar:star-bold" class="text-warning-main text-lg"></iconify-icon>
                                                <iconify-icon icon="solar:star-bold" class="text-warning-main text-lg"></iconify-icon>
                                                <iconify-icon icon="solar:star-outline" class="text-warning-main text-lg"></iconify-icon>
                                            </div>
                                            <span class="fw-medium">4.0</span>
                                        </div>
                                    </div>
                                    <p class="text-secondary-light mb-16">
                                        "Dịch vụ tốt, nhân viên nhiệt tình. Tuy nhiên thời gian chờ hơi lâu. 
                                        Hy vọng spa sẽ cải thiện về vấn đề này."
                                    </p>
                                    <div class="d-flex align-items-center gap-8">
                                        <button type="button" class="btn btn-outline-primary btn-sm">
                                            <iconify-icon icon="solar:heart-outline"></iconify-icon>
                                            Thích
                                        </button>
                                        <button type="button" class="btn btn-outline-info btn-sm">
                                            <iconify-icon icon="solar:chat-round-outline"></iconify-icon>
                                            Trả Lời
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Empty State -->
                        <div class="col-12">
                            <div class="text-center py-5">
                                <iconify-icon icon="solar:chat-round-dots-outline" class="text-secondary-light mb-16" style="font-size: 64px;"></iconify-icon>
                                <h6 class="mb-8">Chưa có phản hồi nào</h6>
                                <p class="text-secondary-light mb-0">Phản hồi từ khách hàng sẽ xuất hiện ở đây</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 


