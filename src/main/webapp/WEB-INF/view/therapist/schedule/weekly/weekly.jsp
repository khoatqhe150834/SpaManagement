<%-- 
    Document   : weekly.jsp
    Created on : Therapist Weekly Schedule Page
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
    <title>Lịch Hàng Tuần - Therapist Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />

</head>
<body>
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Lịch Hàng Tuần</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Bảng Điều Khiển
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Lịch Hàng Tuần</li>
                </ul>
            </div>

            <!-- Week Navigation -->
            <div class="card mb-24">
                <div class="card-body">
                    <div class="d-flex align-items-center justify-content-between">
                        <div class="d-flex align-items-center gap-16">
                            <button type="button" class="btn btn-outline-primary btn-sm">
                                <iconify-icon icon="solar:alt-arrow-left-outline"></iconify-icon>
                                Tuần Trước
                            </button>
                            <h5 class="mb-0">Tuần 16/12/2024 - 22/12/2024</h5>
                            <button type="button" class="btn btn-outline-primary btn-sm">
                                Tuần Sau
                                <iconify-icon icon="solar:alt-arrow-right-outline"></iconify-icon>
                            </button>
                        </div>
                        <button type="button" class="btn btn-primary btn-sm">
                            <iconify-icon icon="solar:calendar-outline"></iconify-icon>
                            Hôm Nay
                        </button>
                    </div>
                </div>
            </div>

            <!-- Weekly Calendar -->
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th scope="col" style="width: 100px;">Giờ</th>
                                    <th scope="col" class="text-center">Thứ 2<br><small class="text-secondary-light">16/12</small></th>
                                    <th scope="col" class="text-center">Thứ 3<br><small class="text-secondary-light">17/12</small></th>
                                    <th scope="col" class="text-center">Thứ 4<br><small class="text-secondary-light">18/12</small></th>
                                    <th scope="col" class="text-center">Thứ 5<br><small class="text-secondary-light">19/12</small></th>
                                    <th scope="col" class="text-center">Thứ 6<br><small class="text-secondary-light">20/12</small></th>
                                    <th scope="col" class="text-center">Thứ 7<br><small class="text-secondary-light">21/12</small></th>
                                    <th scope="col" class="text-center">Chủ Nhật<br><small class="text-secondary-light">22/12</small></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="fw-medium">08:00</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td>
                                        <div class="bg-primary-focus text-primary-main p-8 rounded text-xs">
                                            <strong>Nguyễn Thị Lan</strong><br>
                                            Massage Thư Giãn
                                        </div>
                                    </td>
                                    <td></td>
                                    <td class="bg-light text-center text-secondary-light">
                                        <span class="text-xs">Nghỉ</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-medium">09:00</td>
                                    <td>
                                        <div class="bg-success-focus text-success-main p-8 rounded text-xs">
                                            <strong>Trần Văn Nam</strong><br>
                                            Chăm Sóc Da Mặt
                                        </div>
                                    </td>
                                    <td></td>
                                    <td>
                                        <div class="bg-warning-focus text-warning-main p-8 rounded text-xs">
                                            <strong>Lê Thị Hoa</strong><br>
                                            Tẩy Tế Bào Chết
                                        </div>
                                    </td>
                                    <td></td>
                                    <td></td>
                                    <td>
                                        <div class="bg-info-focus text-info-main p-8 rounded text-xs">
                                            <strong>Phạm Văn Đức</strong><br>
                                            Massage Đá Nóng
                                        </div>
                                    </td>
                                    <td class="bg-light text-center text-secondary-light">
                                        <span class="text-xs">Nghỉ</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-medium">10:00</td>
                                    <td></td>
                                    <td>
                                        <div class="bg-danger-focus text-danger-main p-8 rounded text-xs">
                                            <strong>Hoàng Thị Mai</strong><br>
                                            Massage Body
                                        </div>
                                    </td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td class="bg-light text-center text-secondary-light">
                                        <span class="text-xs">Nghỉ</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-medium">11:00</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td>
                                        <div class="bg-purple-focus text-purple-main p-8 rounded text-xs">
                                            <strong>Vũ Thị Linh</strong><br>
                                            Điều Trị Mụn
                                        </div>
                                    </td>
                                    <td></td>
                                    <td></td>
                                    <td class="bg-light text-center text-secondary-light">
                                        <span class="text-xs">Nghỉ</span>
                                    </td>
                                </tr>
                                <!-- Additional time slots -->
                                <tr>
                                    <td class="fw-medium">12:00</td>
                                    <td colspan="7" class="bg-secondary text-center text-light">
                                        <span class="fw-medium">Giờ Nghỉ Trưa</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-medium">13:00</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td class="bg-light text-center text-secondary-light">
                                        <span class="text-xs">Nghỉ</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-medium">14:00</td>
                                    <td>
                                        <div class="bg-teal-focus text-teal-main p-8 rounded text-xs">
                                            <strong>Ngô Văn Hùng</strong><br>
                                            Massage Thái
                                        </div>
                                    </td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td>
                                        <div class="bg-orange-focus text-orange-main p-8 rounded text-xs">
                                            <strong>Đặng Thị Lan</strong><br>
                                            Gội Đầu Dưỡng Sinh
                                        </div>
                                    </td>
                                    <td></td>
                                    <td class="bg-light text-center text-secondary-light">
                                        <span class="text-xs">Nghỉ</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Statistics Summary -->
            <div class="row gy-4 mt-24">
                <div class="col-xl-3 col-sm-6">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center justify-content-between">
                                <div>
                                    <span class="text-secondary-light mb-4 fw-medium">Tổng Lịch Hẹn</span>
                                    <h6 class="mb-0">23</h6>
                                </div>
                                <div class="w-50-px h-50-px bg-primary-focus text-primary-main rounded-circle d-flex justify-content-center align-items-center">
                                    <iconify-icon icon="solar:calendar-outline" class="text-2xl mb-0"></iconify-icon>
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
                                    <span class="text-secondary-light mb-4 fw-medium">Giờ Làm Việc</span>
                                    <h6 class="mb-0">42h</h6>
                                </div>
                                <div class="w-50-px h-50-px bg-success-focus text-success-main rounded-circle d-flex justify-content-center align-items-center">
                                    <iconify-icon icon="solar:clock-circle-outline" class="text-2xl mb-0"></iconify-icon>
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
                                    <span class="text-secondary-light mb-4 fw-medium">Khách Hàng</span>
                                    <h6 class="mb-0">18</h6>
                                </div>
                                <div class="w-50-px h-50-px bg-info-focus text-info-main rounded-circle d-flex justify-content-center align-items-center">
                                    <iconify-icon icon="solar:users-group-rounded-outline" class="text-2xl mb-0"></iconify-icon>
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
                                    <span class="text-secondary-light mb-4 fw-medium">Đánh Giá TB</span>
                                    <h6 class="mb-0">4.8/5</h6>
                                </div>
                                <div class="w-50-px h-50-px bg-warning-focus text-warning-main rounded-circle d-flex justify-content-center align-items-center">
                                    <iconify-icon icon="solar:star-bold" class="text-2xl mb-0"></iconify-icon>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html> 


