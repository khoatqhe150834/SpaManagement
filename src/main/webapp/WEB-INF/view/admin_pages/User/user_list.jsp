<%--
    Document   : user_list
    Created on : Jun 4, 2025
    Author     : Admin
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">

    <head>
        <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Users - Admin Dashboard</title>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
        <style>
            /* CSS cho các nút phân trang */
            .pagination .page-item a {
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .pagination .page-item.active a {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
            }
             .pagination .page-item.disabled a {
                color: #6c757d;
                pointer-events: none;
                background-color: #fff;
                border-color: #dee2e6;
            }
            .toast-message {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                position: fixed;
                top: 80px;
                left: 50%;
                transform: translateX(-50%);
                min-width: 240px;
                max-width: 90vw;
                padding: 16px 32px;
                border-radius: 10px;
                font-size: 1.1rem;
                z-index: 9999;
                opacity: 0;
                pointer-events: none;
                transition: opacity 0.3s;
            }
            .toast-message.show {
                opacity: 1;
                pointer-events: auto;
            }
            .toast-success {
                background: #e6f4ea;
                color: #219653;
                border: 1px solid #b7e4c7;
            }
            .toast-error {
                background: #fdecea;
                color: #d32f2f;
                border: 1px solid #f5c6cb;
            }
        </style>
    </head>

    <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp" />
        <jsp:include page="/WEB-INF/view/common/admin/header.jsp" />

        <div class="dashboard-main-body">
            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
                <h6 class="fw-semibold mb-0">Danh sách người dùng</h6>
                <div class="d-flex align-items-center gap-2">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary">
                        <iconify-icon icon="ic:round-home" class="me-1"></iconify-icon> Trang chủ
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="me-1"></iconify-icon> Bảng điều khiển
                    </a>
                </div>
            </div>
            
            <%-- Hiển thị thông báo thành công --%>
            <c:if test="${not empty sessionScope.successMessage}">
                <div id="toast-message" class="toast-message toast-success">
                    <iconify-icon icon="mdi:check-circle" style="font-size: 1.6rem; color: #219653;"></iconify-icon>
                    <span>Thành công!</span>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <%-- Hiển thị thông báo lỗi --%>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div id="toast-message" class="toast-message toast-error">
                    <iconify-icon icon="mdi:close-circle" style="font-size: 1.6rem; color: #d32f2f;"></iconify-icon>
                    <span>Thất bại!</span>
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <div class="card h-100 p-0 radius-12">
                <div class="card-header border-bottom bg-base py-16 px-24 d-flex align-items-center flex-wrap gap-3 justify-content-between">
                    <div class="d-flex align-items-center flex-wrap gap-3">
                        <%-- Form tìm kiếm và lọc --%>
                        <form class="navbar-search d-flex gap-2 align-items-center" method="get" action="${pageContext.request.contextPath}/user/list">
                            <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="pageSize" onchange="this.form.submit()">
                                <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                <option value="1000" ${pageSize >= 1000 ? 'selected' : ''}>All</option>
                            </select>
                            <input type="text" class="bg-base h-40-px w-auto" name="searchValue" placeholder="Tìm theo tên, email..." value="${searchValue}">
                            <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="status">
                                <option value="">Tất cả trạng thái</option>
                                <option value="active" ${status == 'active' ? 'selected' : ''}>Đang hoạt động</option>
                                <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Ngừng hoạt động</option>
                            </select>
                            <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="role">
                                <option value="">Tất cả vai trò</option>
                                <option value="1" ${role == '1' ? 'selected' : ''}>Quản trị viên</option>
                                <option value="2" ${role == '2' ? 'selected' : ''}>Quản lý</option>
                                <option value="3" ${role == '3' ? 'selected' : ''}>Kỹ thuật viên</option>
                                <option value="4" ${role == '4' ? 'selected' : ''}>Lễ tân</option>
                            </select>
                            <button type="submit" class="btn btn-primary h-40-px radius-12">Tìm kiếm</button>
                            <input type="hidden" name="page" value="1">
                        </form>
                    </div>
                    <div class="d-flex align-items-center gap-3">
                        <span class="text-muted small">
                            <c:choose>
                                <c:when test="${pageSize >= 1000}">
                                    Showing All Users (${totalUsers} total)
                                </c:when>
                                <c:otherwise>
                                    Showing ${fn:length(users)} of ${totalUsers} users
                                </c:otherwise>
                            </c:choose>
                        </span>
                        <a href="${pageContext.request.contextPath}/user/create" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2"> 
                            <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                            Thêm người dùng
                        </a>
                    </div>
                </div>

                <c:if test="${not empty users}">
                    <div class="card-body p-24">
                        <div class="table-responsive scroll-sm">
                            <table class="table bordered-table sm-table mb-0">
                                <thead>
                                    <tr>
                                        <th scope="col">Mã ND
                                            <a href="?sortBy=id&sortOrder=asc&pageSize=${pageSize}&searchValue=${searchValue}&status=${status}&role=${role}&page=${currentPage}" title="Sort Ascending">&#9650;</a>
                                            <a href="?sortBy=id&sortOrder=desc&pageSize=${pageSize}&searchValue=${searchValue}&status=${status}&role=${role}&page=${currentPage}" title="Sort Descending">&#9660;</a>
                                        </th>
                                        <th scope="col">Họ và tên
                                            <a href="?sortBy=name&sortOrder=asc&pageSize=${pageSize}&searchValue=${searchValue}&status=${status}&role=${role}&page=${currentPage}" title="Sort Name Ascending">&#9650;</a>
                                            <a href="?sortBy=name&sortOrder=desc&pageSize=${pageSize}&searchValue=${searchValue}&status=${status}&role=${role}&page=${currentPage}" title="Sort Name Descending">&#9660;</a>
                                        </th>
                                        <th scope="col">Vai trò</th>
                                        <th scope="col" class="text-center">Trạng thái</th>
                                        <th scope="col" class="text-center">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td>${user.userId}</td>
                                            <td>${user.fullName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.roleId == 1}">
                                                        <span class="badge bg-primary">Quản trị viên</span>
                                                    </c:when>
                                                    <c:when test="${user.roleId == 2}">
                                                        <span class="badge bg-info">Quản lý</span>
                                                    </c:when>
                                                    <c:when test="${user.roleId == 3}">
                                                        <span class="badge bg-success">Kỹ thuật viên</span>
                                                    </c:when>
                                                    <c:when test="${user.roleId == 4}">
                                                        <span class="badge bg-warning">Lễ tân</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Unknown</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${user.isActive}">
                                                        <span class="bg-success-focus text-success-600 border border-success-main px-24 py-4 radius-4 fw-medium text-sm">Đang hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="bg-neutral-200 text-neutral-600 border border-neutral-400 px-24 py-4 radius-4 fw-medium text-sm">Ngừng hoạt động</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            
                                            <td class="text-center">
                                                <div class="d-flex align-items-center gap-10 justify-content-center">
                                                    <a href="${pageContext.request.contextPath}/user/view?id=${user.userId}" class="bg-info-focus text-info-600 bg-hover-info-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Xem">
                                                        <iconify-icon icon="majesticons:eye-line" class="menu-icon"></iconify-icon>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/user/edit?id=${user.userId}" class="bg-success-focus text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Sửa">
                                                        <iconify-icon icon="lucide:edit" class="menu-icon"></iconify-icon>
                                                    </a>
                                                    <c:if test="${user.isActive}">
                                                        <c:url var="deactivateUrl" value="/user/deactivate">
                                                            <c:param name="id" value="${user.userId}" />
                                                            <c:param name="page" value="${currentPage}" />
                                                            <c:param name="pageSize" value="${pageSize}" />
                                                            <c:param name="searchValue" value="${searchValue}" />
                                                            <c:param name="status" value="${status}" />
                                                            <c:param name="role" value="${role}" />
                                                        </c:url>
                                                        <a href="#" onclick="return confirmAction('${deactivateUrl}', 'Bạn có chắc chắn muốn vô hiệu hóa người dùng này?');" class="bg-warning-focus bg-hover-warning-200 text-warning-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Vô hiệu hóa">
                                                          <iconify-icon icon="fluent:presence-available-24-filled" class="menu-icon"></iconify-icon>
                                                        </a>
                                                    </c:if>
                                                    <c:if test="${not user.isActive}">
                                                        <c:url var="activateUrl" value="/user/activate">
                                                            <c:param name="id" value="${user.userId}" />
                                                            <c:param name="page" value="${currentPage}" />
                                                            <c:param name="pageSize" value="${pageSize}" />
                                                            <c:param name="searchValue" value="${searchValue}" />
                                                            <c:param name="status" value="${status}" />
                                                            <c:param name="role" value="${role}" />
                                                        </c:url>
                                                        <a href="#" onclick="return confirmAction('${activateUrl}', 'Bạn có chắc chắn muốn kích hoạt người dùng này?');" class="bg-success-focus bg-hover-success-200 text-success-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Kích hoạt">
                                                          <iconify-icon icon="fluent:presence-blocked-20-regular" class="menu-icon"></iconify-icon>
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:if>
                <c:if test="${empty users}">
                    <div class="p-24 text-center">No users found matching your criteria.</div>
                </c:if>

                <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24 p-24">
                     <c:set var="start" value="${(currentPage - 1) * pageSize + 1}" />
                     <c:set var="end" value="${start + fn:length(users) - 1}" />
                     <span>
                        <c:if test="${totalUsers > 0}">Showing ${start} to ${end} of ${totalUsers} entries</c:if>
                        <c:if test="${totalUsers == 0}">No entries found</c:if>
                    </span>
                    <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                           <c:url var="prevUrl" value="/user/list"><c:param name="page" value="${currentPage - 1}"/><c:param name="pageSize" value="${pageSize}"/><c:param name="searchValue" value="${searchValue}"/><c:param name="status" value="${status}"/><c:param name="role" value="${role}"/></c:url>
                           <a class="page-link" href="${currentPage > 1 ? prevUrl : '#'}"><iconify-icon icon="ep:d-arrow-left"></iconify-icon></a>
                        </li>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <c:url var="pageUrl" value="/user/list"><c:param name="page" value="${i}"/><c:param name="pageSize" value="${pageSize}"/><c:param name="searchValue" value="${searchValue}"/><c:param name="status" value="${status}"/><c:param name="role" value="${role}"/></c:url>
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${pageUrl}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                           <c:url var="nextUrl" value="/user/list"><c:param name="page" value="${currentPage + 1}"/><c:param name="pageSize" value="${pageSize}"/><c:param name="searchValue" value="${searchValue}"/><c:param name="status" value="${status}"/><c:param name="role" value="${role}"/></c:url>
                           <a class="page-link" href="${currentPage < totalPages ? nextUrl : '#'}"><iconify-icon icon="ep:d-arrow-right"></iconify-icon></a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
        <script>
            function confirmAction(url, message) {
                if (confirm(message)) {
                    window.location.href = url;
                }
                return false;
            }

            document.addEventListener("DOMContentLoaded", function () {
                const toast = document.getElementById("toast-message");
                if (toast) {
                    toast.classList.add("show");
                    setTimeout(() => {
                        toast.classList.remove("show");
                        setTimeout(() => toast.remove(), 500);
                    }, 3000);
                }
            });
        </script>
    </body>
</html> 