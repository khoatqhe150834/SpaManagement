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
                        <span class="text-md fw-medium text-secondary-light mb-0">Hiển thị</span>
                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px">
                            <option>1</option>
                            <option>2</option>
                            <option>3</option>
                            <option>4</option>
                            <option>5</option>
                            <option>6</option>
                            <option>7</option>
                            <option>8</option>
                            <option>9</option>
                            <option>10</option>
                        </select>
                        <form class="navbar-search" method="get" action="staff">
                            <input type="text" class="bg-base h-40-px w-auto" name="search" value="${param.search}" placeholder="Tìm kiếm">
                            <iconify-icon icon="ion:search-outline" class="icon"></iconify-icon>
                        </form>
                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="availabilityStatus">
                            <option>Status</option>
                            <option value="Available" ${availabilityStatus == 'Available' ? 'selected' : ''}>Available</option>
                            <option value="Busy" ${availabilityStatus == 'Busy' ? 'selected' : ''}>Busy</option>
                            <option value="OffLine" ${availabilityStatus == 'OffLine' ? 'selected' : ''}>Offline</option>
                            <option value="On Leave" ${availabilityStatus == 'On Leave' ? 'selected' : ''}>On Leave</option>
                        </select>
                    </div>
                    <a href="staff?service=pre-insert" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2">
                        <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                        Thêm Nhân Viên Mới
                    </a>
                </div>

                <div class="card-body p-24">
                    <div class="table-responsive scroll-sm">
                        <table class="table bordered-table sm-table mb-0">
                            <thead>
                                <tr>
                                    <th scope="col">
                                        <div class="d-flex align-items-center gap-10">
                                            <div class="form-check style-check d-flex align-items-center">
                                                <input class="form-check-input radius-4 border input-form-dark" type="checkbox" name="checkbox" id="selectAll">
                                            </div>
                                            ID
                                        </div>
                                    </th>
                                    <th scope="col">Tên</th>
                                    <th scope="col">Loại Dịch Vụ</th>
                                    <th scope="col">Tiểu Sử</th>
                                    <th scope="col" class="text-center">Trạng Thái</th>
                                    <th scope="col">Kinh Nghiệm (Năm)</th>
                                    <th scope="col" class="text-center">Hành Động</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="therapist" items="${staffList}" varStatus="status">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-10">
                                                <div class="form-check style-check d-flex align-items-center">
                                                    <input class="form-check-input radius-4 border input-form-dark" type="checkbox" name="checkbox" value="${therapist.user.userId}">
                                                </div>
                                                ${status.index + 1} <!-- Hiển thị số thứ tự -->
                                            </div>
                                        </td>

                                        <td>${therapist.user.fullName}</td> <!-- Tên Nhân Viên -->

                                        <td>
                                            <c:if test="${not empty therapist.serviceType}">
                                                ${therapist.serviceType.name} <!-- Loại Dịch Vụ -->
                                            </c:if>
                                        </td>

                                        <td>${therapist.bio}</td> <!-- Tiểu Sử -->

                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${therapist.availabilityStatus == 'AVAILABLE'}">
                                                    <span class="bg-success-focus text-success-600 border border-success-main px-24 py-4 radius-4 fw-medium text-sm">Available</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="bg-neutral-200 text-neutral-600 border border-neutral-400 px-24 py-4 radius-4 fw-medium text-sm">${therapist.availabilityStatus}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>${therapist.yearsOfExperience}</td> <!-- Kinh Nghiệm -->

                                        <td class="text-center">
                                            <div class="d-flex align-items-center gap-10 justify-content-center">
                                                <!-- View button -->
                                                <a href="staff?service=viewById&id=${therapist.user.userId}" class="bg-info-focus text-info-600 w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                    <iconify-icon icon="majesticons:eye-line" class="icon text-xl"></iconify-icon>
                                                </a>

                                                <!-- Edit button -->
                                                <a href="staff?service=pre-update&id=${therapist.user.userId}" class="bg-success-focus text-success-600 w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle">
                                                    <iconify-icon icon="lucide:edit" class="menu-icon"></iconify-icon>
                                                </a>

                                                <!-- Deactivate button -->
                                                <a href="staff?service=deactiveById&id=${therapist.user.userId}" class="remove-item-btn bg-warning-focus bg-hover-warning-200 text-warning-600 w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" onclick="return confirm('Bạn có chắc chắn muốn vô hiệu hóa nhân viên này?');">
                                                    <iconify-icon icon="uil:calendar" class="menu-icon"></iconify-icon> <!-- Calendar icon -->
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24">
                        <span>Hiển thị từ ${start} đến ${end} của ${totalEntries} mục</span>
                        <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                            <!-- Previous button -->
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="staff?service=list-all&page=${currentPage - 1}&limit=${limit}">
                                    <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                                </a>
                            </li>

                            <!-- Page numbers -->
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="staff?service=list-all&page=${i}&limit=${limit}">${i}</a>
                                </li>
                            </c:forEach>

                            <!-- Next button -->
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="staff?service=list-all&page=${currentPage + 1}&limit=${limit}">
                                    <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                                </a>
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
