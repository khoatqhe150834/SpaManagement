<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en" data-theme="light">
    <head>
        <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Staff - Admin Dashboard</title>
        <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">
        <!-- CSS here -->
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
        <style>
            .bio-wrap {
                white-space: pre-line;
                word-break: break-word;
                max-width: 260px;
                min-width: 120px;
            }
            .table td, .table th {
                white-space: normal !important;
            }
        </style>
    </head>
    <body>
        <!-- SIDEBAR here -->
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>

        <!-- HEADER here -->
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Danh sách Nhân Viên</h6>
                <ul class="d-flex align-items-center gap-2">
                    <li class="fw-medium">
                        <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                            <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                            Dashboard
                        </a>
                    </li>
                    <li>-</li>
                    <li class="fw-medium">Danh sách Nhân Viên</li>
                </ul>
            </div>

            <div class="card h-100 p-0 radius-12">
                <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center flex-wrap gap-3 justify-content-between">
                    <div class="d-flex align-items-center flex-wrap gap-3">
                        <div class="d-flex align-items-center gap-2">
                            <span class="text-md fw-medium text-secondary-light mb-0">Hiển thị</span>
                            <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" id="limitSelect" onchange="changeLimit(this.value)">
                                <c:forEach var="i" begin="1" end="10">
                                    <option value="${i}" ${limit == i ? 'selected' : ''}>${i}</option>
                                </c:forEach>
                            </select>
                            <span class="text-md fw-medium text-secondary-light mb-0">mục</span>
                        </div>
                        <form class="navbar-search d-flex gap-2 align-items-center" method="get" action="staff">
                            <input type="text" class="bg-base h-40-px w-auto" name="keyword" placeholder="Tìm kiếm theo tên hoặc loại dịch vụ" value="${keyword}">
                            <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="status">
                                <option value="">Trạng thái</option>
                                <option value="available" ${status=='available' ? 'selected' : '' }>Available</option>
                                <option value="busy" ${status=='busy' ? 'selected' : '' }>Busy</option>
                                <option value="offline" ${status=='offline' ? 'selected' : '' }>Offline</option>
                                <option value="on_leave" ${status=='on_leave' ? 'selected' : '' }>On Leave</option>
                            </select>
                            <input type="hidden" name="service" value="search" />
                            <input type="hidden" name="limit" value="${limit}" />
                            <button type="submit" class="btn btn-primary h-40-px radius-12">Tìm kiếm</button>
                        </form>
                    </div>
                    <a href="staff?service=pre-insert" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2">
                        <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                        Thêm Nhân Viên Mới
                    </a>
                </div>

                <div class="card-body p-24">
                    <div class="table-responsive">
                        <table class="table bordered-table sm-table mb-0 responsive-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tên</th>
                                    <th>Loại Dịch Vụ</th>
                                    <th>Tiểu Sử</th>
                                    <th>Trạng Thái</th>
                                    <th>Kinh Nghiệm (Năm)</th>
                                    <th>Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="staff" items="${staffList}">
                                    <tr>
                                        <td>${staff.user.userId}</td>
                                        <td>${staff.user.fullName}</td>
                                        <td>${staff.serviceType.name}</td>
                                        <td>
                                            <div class="limit-description" data-bs-toggle="tooltip" data-bs-title="${staff.bio}">
                                                ${staff.bio}
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <span class="bg-${staff.availabilityStatus == 'AVAILABLE' ? 'success-focus text-success-600 border border-success-main' : staff.availabilityStatus == 'BUSY' ? 'warning-focus text-warning-600 border border-warning-main' : staff.availabilityStatus == 'OFFLINE' ? 'neutral-200 text-neutral-600 border border-neutral-400' : 'danger-focus text-danger-600 border border-danger-main'} px-24 py-4 radius-4 fw-medium text-sm">
                                                ${staff.availabilityStatus}
                                            </span>
                                        </td>
                                        <td class="text-center">${staff.yearsOfExperience}</td>
                                        <td class="text-center">
                                            <div class="d-flex align-items-center gap-10 justify-content-center">
                                                <a href="staff?service=view&id=${staff.user.userId}" class="bg-info-focus text-info-600 bg-hover-info-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" data-bs-toggle="tooltip" data-bs-title="Xem chi tiết">
                                                    <iconify-icon icon="solar:eye-bold"></iconify-icon>
                                                </a>
                                                <a href="staff?service=pre-update&id=${staff.user.userId}" class="bg-success-focus text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" data-bs-toggle="tooltip" data-bs-title="Chỉnh sửa">
                                                    <iconify-icon icon="lucide:edit"></iconify-icon>
                                                </a>
                                                <button onclick="deleteStaff(${staff.user.userId})" class="bg-danger-focus bg-hover-danger-200 text-danger-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" data-bs-toggle="tooltip" data-bs-title="Xóa">
                                                    <iconify-icon icon="solar:trash-bin-trash-bold"></iconify-icon>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24">
                        <c:set var="start" value="${(currentPage - 1) * limit + 1}" />
                        <c:set var="end" value="${currentPage * limit > totalEntries ? totalEntries : currentPage * limit}" />
                        <span>
                            Hiển thị ${start} đến ${end} của ${totalEntries} mục
                        </span>
                        <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                            <!-- Previous -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <c:choose>
                                    <c:when test="${currentPage == 1}">
                                        <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px disabled">
                                            <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px"
                                           href="staff?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${currentPage - 1}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}">
                                            <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                            <!-- Page numbers -->
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px
                                        ${i == currentPage ? 'bg-primary-600 text-white' : 'bg-neutral-200 text-secondary-light'}"
                                       href="staff?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${i}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}">
                                        ${i}
                                    </a>
                                </li>
                            </c:forEach>
                            <!-- Next -->
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <c:choose>
                                    <c:when test="${currentPage == totalPages}">
                                        <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px disabled">
                                            <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px"
                                           href="staff?service=${param.service != null && param.service != '' ? param.service : 'list-all'}&page=${currentPage + 1}&limit=${limit}${not empty keyword ? '&keyword='.concat(keyword) : ''}${not empty status ? '&status='.concat(status) : ''}">
                                            <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- JS here -->
        <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>

        <!-- Toast Message Script -->
        <c:if test="${not empty toastMessage}">
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    const toast = document.createElement("div");
                    toast.textContent = "${toastMessage}";
                    toast.className = "toast-message ${toastType eq 'success' ? 'toast-success' : 'toast-error'}";
                    document.body.appendChild(toast);

                    setTimeout(() => toast.classList.add("show"), 100);
                    setTimeout(() => toast.classList.remove("show"), 4000);
                });
            </script>
        </c:if>

    </body>
</html>
