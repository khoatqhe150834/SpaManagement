<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ nhân viên</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
    <style>
        .profile-body {
            background-color: #f4f7fa;
        }
        .page-title {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0;
        }
        .profile-card {
            background-color: #ffffff;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            height: 100%;
        }
        .avatar-section {
            text-align: center;
            margin-bottom: 24px;
        }
        .avatar-section .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #e0e7ff;
            margin-bottom: 16px;
        }
        .avatar-section .user-name {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 4px;
        }
        .avatar-section .user-email {
            color: #6c757d;
            margin-bottom: 24px;
        }
        .personal-info-list {
            list-style: none;
            padding-left: 0;
        }
        .personal-info-list li {
            display: flex;
            align-items: center;
            margin-bottom: 16px;
            font-size: 0.95rem;
        }
        .personal-info-list iconify-icon {
            font-size: 20px;
            color: #673ab7;
            margin-right: 12px;
            width: 24px;
            text-align: center;
        }
        .professional-info .info-section {
            margin-bottom: 24px;
        }
        .professional-info .info-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 16px;
            color: #343a40;
        }
        .professional-info .info-label {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 8px;
        }
        .professional-info .bio-content {
            background-color: #f8f9fa;
            padding: 12px;
            border-radius: 8px;
            min-height: 160px; /* Adjusted height */
            color: #495057;
            white-space: pre-wrap;
            overflow-wrap: break-word;
            font-size: 0.95rem;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
        }
        .info-grid-item .value {
            font-weight: 600;
            font-size: 1rem;
        }
        .status-badge {
            padding: 4px 12px;
            border-radius: 16px;
            font-size: 0.9rem;
            font-weight: 500;
            display: inline-block;
        }
        .status-available { background-color: #e6f9f0; color: #28a745; }
        .status-busy { background-color: #fff0e6; color: #ff6f00; }
        .status-offline { background-color: #f2f2f2; color: #6c757d; }
        .status-on-leave { background-color: #e6f2ff; color: #007bff; }
    </style>
</head>
<body class="profile-body">
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>
    <div class="main-content">
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>
        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h4 class="page-title">Hồ sơ nhân viên</h4>
                <a href="staff" class="btn btn-light d-flex align-items-center gap-1">
                    <iconify-icon icon="solar:arrow-left-outline" class="icon text-lg"></iconify-icon>
                    Quay lại danh sách nhân viên
                </a>
            </div>

            <div class="row gy-4">
                <!-- Cột thông tin cá nhân (trái) -->
                <div class="col-lg-4">
                    <div class="profile-card">
                        <div class="avatar-section">
                            <img src="${not empty staff.user.avatarUrl ? staff.user.avatarUrl : pageContext.request.contextPath.concat('/assets/images/user-grid/user-grid-img14.png')}"
                                 alt="Avatar" class="profile-avatar">
                            <h4 class="user-name">${staff.user.fullName}</h4>
                            <p class="user-email">${staff.user.email}</p>
                        </div>
                        <hr class="my-24">
                        <ul class="personal-info-list">
                            <li>
                                <iconify-icon icon="solar:card-2-bold-duotone"></iconify-icon>
                                <span>Mã nhân viên: ${staff.user.userId}</span>
                            </li>
                            <li>
                                <iconify-icon icon="solar:phone-bold-duotone"></iconify-icon>
                                <span>Số điện thoại: ${staff.user.phoneNumber}</span>
                            </li>
                            <li>
                                <iconify-icon icon="solar:user-bold-duotone"></iconify-icon>
                                <span>Giới tính: ${staff.user.gender}</span>
                            </li>
                            <li>
                                <iconify-icon icon="solar:calendar-bold-duotone"></iconify-icon>
                                <span>Ngày sinh: <fmt:formatDate value="${staff.user.birthday}" pattern="dd/MM/yyyy"/></span>
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Cột thông tin chuyên môn (phải) -->
                <div class="col-lg-8">
                    <div class="profile-card professional-info">
                        <h5 class="info-title">Thông tin chuyên môn</h5>
                        <div class="info-section">
                            <p class="info-label">Tiểu sử</p>
                            <div class="bio-content">${staff.bio}</div>
                        </div>

                        <div class="info-grid">
                            <div class="info-grid-item">
                                <p class="info-label">Loại dịch vụ</p>
                                <p class="value">${staff.serviceType.name}</p>
                            </div>
                            <div class="info-grid-item">
                                <p class="info-label">Trạng thái</p>
                                <div class="value">
                                    <c:choose>
                                        <c:when test="${staff.availabilityStatus == 'AVAILABLE'}">
                                            <span class="status-badge status-available">Sẵn sàng</span>
                                        </c:when>
                                        <c:when test="${staff.availabilityStatus == 'BUSY'}">
                                            <span class="status-badge status-busy">Bận</span>
                                        </c:when>
                                        <c:when test="${staff.availabilityStatus == 'ON_LEAVE'}">
                                            <span class="status-badge status-on-leave">Đang nghỉ</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-offline">Ngoại tuyến</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="info-grid-item">
                                <p class="info-label">Số năm kinh nghiệm</p>
                                <p class="value">${staff.yearsOfExperience} năm</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>
</body>
</html>