<%-- 
    Document   : stats.jsp
    Created on : Therapist Performance Stats
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống Kê Hiệu Suất - Therapist Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
</head>
<body>
    <jsp:include page="/WEB-INF/view/therapist/shared/sidebar.jsp" />
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Thống Kê Hiệu Suất</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/therapist-dashboard" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Hiệu Suất</li>
                <li>-</li>
                <li class="fw-medium">Thống Kê</li>
            </ul>
        </div>

        <!-- Performance Overview Cards -->
        <div class="row gy-4 mb-24">
            <div class="col-md-3">
                <div class="card shadow-none border bg-gradient-start-1 h-100">
                    <div class="card-body p-20">
                        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                            <div>
                                <p class="fw-medium text-primary-light mb-1">Khách Hàng Hôm Nay</p>
                                <h6 class="mb-0">12</h6>
                            </div>
                            <div class="w-50-px h-50-px bg-cyan rounded-circle d-flex justify-content-center align-items-center">
                                <iconify-icon icon="fa-solid:user-friends" class="text-white text-2xl mb-0"></iconify-icon>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow-none border bg-gradient-start-2 h-100">
                    <div class="card-body p-20">
                        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                            <div>
                                <p class="fw-medium text-primary-light mb-1">Liệu Pháp Hoàn Thành</p>
                                <h6 class="mb-0">8</h6>
                            </div>
                            <div class="w-50-px h-50-px bg-purple rounded-circle d-flex justify-content-center align-items-center">
                                <iconify-icon icon="material-symbols:spa" class="text-white text-2xl mb-0"></iconify-icon>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow-none border bg-gradient-start-3 h-100">
                    <div class="card-body p-20">
                        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                            <div>
                                <p class="fw-medium text-primary-light mb-1">Đánh Giá Trung Bình</p>
                                <h6 class="mb-0">4.8/5</h6>
                            </div>
                            <div class="w-50-px h-50-px bg-info rounded-circle d-flex justify-content-center align-items-center">
                                <iconify-icon icon="material-symbols:star" class="text-white text-2xl mb-0"></iconify-icon>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card shadow-none border bg-gradient-start-4 h-100">
                    <div class="card-body p-20">
                        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                            <div>
                                <p class="fw-medium text-primary-light mb-1">Doanh Thu Tháng</p>
                                <h6 class="mb-0">45.2M</h6>
                            </div>
                            <div class="w-50-px h-50-px bg-success-main rounded-circle d-flex justify-content-center align-items-center">
                                <iconify-icon icon="solar:dollar-minimalistic-outline" class="text-white text-2xl mb-0"></iconify-icon>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row gy-4">
            <!-- Weekly Performance Chart -->
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">Hiệu Suất Tuần Này</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="row gy-3">
                            <div class="col-12">
                                <div class="d-flex align-items-center gap-2 mb-3">
                                    <div class="w-8-px h-8-px bg-primary-600 rounded-circle"></div>
                                    <span class="text-sm">Số liệu pháp hoàn thành</span>
                                </div>
                                <div style="height: 250px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 8px; position: relative; display: flex; align-items-end; padding: 20px;">
                                    <div style="display: flex; align-items-end; gap: 10px; width: 100%; height: 100%;">
                                        <div style="width: 40px; height: 60%; background: rgba(255,255,255,0.3); border-radius: 4px;"></div>
                                        <div style="width: 40px; height: 80%; background: rgba(255,255,255,0.5); border-radius: 4px;"></div>
                                        <div style="width: 40px; height: 70%; background: rgba(255,255,255,0.4); border-radius: 4px;"></div>
                                        <div style="width: 40px; height: 90%; background: rgba(255,255,255,0.6); border-radius: 4px;"></div>
                                        <div style="width: 40px; height: 75%; background: rgba(255,255,255,0.45); border-radius: 4px;"></div>
                                        <div style="width: 40px; height: 85%; background: rgba(255,255,255,0.55); border-radius: 4px;"></div>
                                        <div style="width: 40px; height: 95%; background: rgba(255,255,255,0.7); border-radius: 4px;"></div>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between mt-2 text-sm text-secondary-light">
                                    <span>T2</span>
                                    <span>T3</span>
                                    <span>T4</span>
                                    <span>T5</span>
                                    <span>T6</span>
                                    <span>T7</span>
                                    <span>CN</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Reviews -->
            <div class="col-lg-4">
                <div class="card">
                    <div class="card-header border-bottom bg-base py-16 px-24">
                        <h6 class="text-lg fw-semibold mb-0">Đánh Giá Gần Đây</h6>
                    </div>
                    <div class="card-body p-24">
                        <div class="d-flex flex-column gap-3">
                            <div class="d-flex align-items-start gap-3 p-3 bg-neutral-50 rounded-8">
                                <div class="flex-shrink-0">
                                    <div class="w-40-px h-40-px bg-primary-100 rounded-circle d-flex align-items-center justify-content-center">
                                        <span class="text-primary-600 fw-semibold">LA</span>
                                    </div>
                                </div>
                                <div class="flex-grow-1">
                                    <h6 class="text-sm fw-semibold mb-1">Lan Anh</h6>
                                    <div class="d-flex gap-1 mb-2">
                                        <iconify-icon icon="material-symbols:star" class="text-warning-main"></iconify-icon>
                                        <iconify-icon icon="material-symbols:star" class="text-warning-main"></iconify-icon>
                                        <iconify-icon icon="material-symbols:star" class="text-warning-main"></iconify-icon>
                                        <iconify-icon icon="material-symbols:star" class="text-warning-main"></iconify-icon>
                                        <iconify-icon icon="material-symbols:star" class="text-warning-main"></iconify-icon>
                                    </div>
                                    <p class="text-xs text-secondary-light">Dịch vụ tuyệt vời, rất chuyên nghiệp!</p>
                                </div>
                            </div>
                            
                            <div class="d-flex align-items-start gap-3 p-3 bg-neutral-50 rounded-8">
                                <div class="flex-shrink-0">
                                    <div class="w-40-px h-40-px bg-success-100 rounded-circle d-flex align-items-center justify-content-center">
                                        <span class="text-success-600 fw-semibold">VM</span>
                                    </div>
                                </div>
                                <div class="flex-grow-1">
                                    <h6 class="text-sm fw-semibold mb-1">Văn Minh</h6>
                                    <div class="d-flex gap-1 mb-2">
                                        <iconify-icon icon="material-symbols:star" class="text-warning-main"></iconify-icon>
                                        <iconify-icon icon="material-symbols:star" class="text-warning-main"></iconify-icon>
                                        <iconify-icon icon="material-symbols:star" class="text-warning-main"></iconify-icon>
                                        <iconify-icon icon="material-symbols:star" class="text-warning-main"></iconify-icon>
                                        <iconify-icon icon="material-symbols:star-outline" class="text-secondary-light"></iconify-icon>
                                    </div>
                                    <p class="text-xs text-secondary-light">Kỹ thuật tốt, sẽ quay lại.</p>
                                </div>
                            </div>

                            <div class="d-flex align-items-start gap-3 p-3 bg-neutral-50 rounded-8">
                                <div class="flex-shrink-0">
                                    <div class="w-40-px h-40-px bg-info-100 rounded-circle d-flex align-items-center justify-content-center">
                                        <span class="text-info-600 fw-semibold">TM</span>
                                    </div>
                                </div>
                                <div class="flex-grow-1">
                                    <h6 class="text-sm fw-semibold mb-1">Thị Mai</h6>
                                    <div class="d-flex gap-1 mb-2">
                                        <iconify-icon icon="material-symbols:star" class="text-warning-main"></iconify-icon>
                                        <iconify-icon icon="material-symbols:star" class="text-warning-main"></iconify-icon>
                                        <iconify-icon icon="material-symbols:star" class="text-warning-main"></iconify-icon>
                                        <iconify-icon icon="material-symbols:star" class="text-warning-main"></iconify-icon>
                                        <iconify-icon icon="material-symbols:star" class="text-warning-main"></iconify-icon>
                                    </div>
                                    <p class="text-xs text-secondary-light">Liệu pháp đá nóng rất thư giãn.</p>
                                </div>
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


