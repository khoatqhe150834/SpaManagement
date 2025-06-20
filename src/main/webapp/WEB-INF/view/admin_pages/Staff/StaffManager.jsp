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
        <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
            <style>
                .bio-wrap {
                    display: -webkit-box;
                    -webkit-line-clamp: 3;
                    -webkit-box-orient: vertical;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: normal;
                    max-width: 180px;
                    min-width: 120px;
                    position: relative;
                }
                .bio-wrap.expanded {
                    -webkit-line-clamp: unset;
                    max-height: none;
                    overflow: visible;
                }
                .see-more-link {
                    color: #1976d2;
                    cursor: pointer;
                    font-weight: 500;
                    margin-left: 4px;
                    font-size: 0.95em;
                }
                .table td, .table th {
                    white-space: normal !important;
                }
                /* Toast Styles */
                .toast {
                    min-width: 300px;
                    background-color: white;
                    border: none;
                    box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
                }

                .toast-header {
                    border-bottom: none;
                }

                .toast-body {
                    padding: 1rem;
                    font-size: 0.9rem;
                }

                /* Animation for toast */
                .toast.show {
                    animation: slideIn 0.5s ease-in-out;
                }

                @keyframes slideIn {
                    from {
                        transform: translateX(100%);
                        opacity: 0;
                    }
                    to {
                        transform: translateX(0);
                        opacity: 1;
                    }
                }

                .pagination .page-item .page-link {
                    border-radius: 8px !important;
                    border: 1px solid #e0e0e0;
                    color: #1976d2;
                    background: #fff;
                    min-width: 40px;
                    min-height: 40px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-weight: 500;
                    transition: background 0.2s, color 0.2s;
                }
                .pagination .page-item.active .page-link {
                    background: #1976d2;
                    color: #fff;
                    border-color: #1976d2;
                }
                .pagination .page-item.disabled .page-link {
                    color: #bdbdbd;
                    background: #f5f5f5;
                    border-color: #e0e0e0;
                    pointer-events: none;
                }
                .pagination .page-link:hover {
                    background: #e3f2fd;
                    color: #1976d2;
                }

                @media (min-width: 1024px) {
                    .dashboard-main-body,
                    .card-body,
                    .table-responsive {
                        overflow-x: visible !important;
                        max-width: 100% !important;
                    }
                    .table {
                        width: 100% !important;
                        min-width: 900px;
                        table-layout: auto !important;
                    }
                }
                .table td, .table th {
                    white-space: nowrap;
                    text-overflow: ellipsis;
                    overflow: hidden;
                    max-width: 180px;
                }
                .table td.bio-wrap, .table td.wrap-text {
                    white-space: normal;
                    max-width: 140px;
                }
                th.text-center, td.text-center {
                    text-align: center !important;
                }
                th.text-start, td.text-start {
                    text-align: left !important;
                }
            </style>
        </head>
        <body>
        <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>
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
                                <span class="text-md fw-medium text-secondary-light mb-0">Hiển thị số mục</span>
                                <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" id="limitSelect" onchange="changeLimit(this.value)">
                                <c:forEach var="i" begin="1" end="10">
                                    <option value="${i}" ${limit == i ? 'selected' : ''}>${i}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <form class="navbar-search d-flex gap-2 align-items-center" method="get" action="staff">
                            <input type="text" class="bg-base h-40-px w-auto" name="keyword" placeholder="Tìm Kiếm" value="${keyword}">
                            <select name="serviceTypeId" class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px">
                                <option value="">Tất cả loại dịch vụ</option>
                                <c:forEach var="stype" items="${serviceTypes}">
                                    <option value="${stype.serviceTypeId}" <c:if test="${serviceTypeId == stype.serviceTypeId}">selected</c:if>>
                                        ${stype.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <select name="status" class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px">
                                <option value="">Trạng thái</option>
                                <c:forEach var="s" items="${statusList}">
                                    <option value="${s}" <c:if test="${status == s}">selected</c:if>>
                                        <c:choose>
                                            <c:when test="${s == 'AVAILABLE'}">Available</c:when>
                                            <c:when test="${s == 'BUSY'}">Busy</c:when>
                                            <c:when test="${s == 'OFFLINE'}">Offline</c:when>
                                            <c:when test="${s == 'ON_LEAVE'}">On Leave</c:when>
                                            <c:otherwise>${s}</c:otherwise>
                                        </c:choose>
                                    </option>
                                </c:forEach>
                            </select>
                            <input type="hidden" name="service" value="search">
                            <input type="hidden" name="limit" value="${limit}" />
                            <button type="submit" class="btn btn-primary h-40-px radius-12">Tìm Kiếm</button>
                        </form>
                    </div>
                    <a href="staff?service=pre-insert" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2">
                        <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                        Thêm Nhân Viên
                    </a>
                </div>
                <div class="card-body p-24">
                    <div class="table-responsive scroll-sm">
                        <table class="table bordered-table sm-table mb-0" id="staffTable" style="table-layout: auto; width: 100%;">
                            <thead>
                                <tr>
                                    <th class="text-start">STT</th>
                                    <th class="text-center">Tên</th>
                                    <th class="text-center">Loại Dịch Vụ</th>
                                    <th class="text-center">Tiểu Sử</th>
                                    <th class="text-center" data-orderable="false">Trạng Thái</th>
                                    <th class="text-start">EXP (Năm)</th>
                                    <th class="text-center" data-orderable="false">Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="therapist" items="${staffList}" varStatus="status">
                                    <tr>
                                        <td class="text-start">${status.index + 1}</td>
                                        <td class="text-center"><div class="wrap-text">${therapist.user.fullName}</div></td>
                                        <td class="text-center">
                                            <c:if test="${not empty therapist.serviceType}">
                                                <div class="wrap-text">${therapist.serviceType.name}</div>
                                            </c:if>
                                        </td>
                                        <td class="text-center">
                                            <div class="bio-wrap" id="bio-${status.index}">
                                                ${therapist.bio}
                                            </div>
                                            <span class="see-more-link" onclick="toggleBio(${status.index}, this)" style="display:none">Xem thêm</span>
                                        </td>
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
                                        <td class="text-start">${therapist.yearsOfExperience}</td>
                                        <td class="text-center">
                                            <div class="d-flex align-items-center gap-10 justify-content-center">
                                                <a href="staff?service=viewById&id=${therapist.user.userId}" class="bg-info-focus text-info-600 w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Xem chi tiết">
                                                    <iconify-icon icon="majesticons:eye-line" class="icon text-xl"></iconify-icon>
                                                </a>
                                                <a href="staff?service=pre-update&id=${therapist.user.userId}" class="bg-success-focus text-success-600 w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Chỉnh sửa">
                                                    <iconify-icon icon="lucide:edit" class="menu-icon"></iconify-icon>
                                                </a>
                                                <a href="staff?service=deactiveById&id=${therapist.user.userId}" class="bg-warning-focus text-warning-600 w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Vô hiệu hóa" onclick="return confirm('Bạn có chắc chắn muốn vô hiệu hóa nhân viên này?');">
                                                    <iconify-icon icon="uil:calendar" class="menu-icon"></iconify-icon>
                                                </a>
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
                        <span>Hiển thị từ ${start} đến ${end} của ${totalEntries} mục</span>
                        <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="staff?service=list-all&page=1&limit=${limit}">
                                    <iconify-icon icon="ic:round-keyboard-double-arrow-left"></iconify-icon>
                                </a>
                            </li>
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="staff?service=list-all&page=${currentPage - 1}&limit=${limit}">
                                    <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                                </a>
                            </li>
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:if test="${i >= currentPage - 2 && i <= currentPage + 2}">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link"
                                           href="staff?service=list-all&page=${i}&limit=${limit}
                                           ${not empty keyword ? '&keyword='.concat(keyword) : ''}
                                           ${not empty status ? '&status='.concat(status) : ''}
                                           ${not empty serviceTypeId ? '&serviceTypeId='.concat(serviceTypeId) : ''}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:if>
                                <c:if test="${i == currentPage - 3 || i == currentPage + 3}">
                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                </c:if>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="staff?service=list-all&page=${currentPage + 1}&limit=${limit}">
                                    <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                                </a>
                            </li>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="staff?service=list-all&page=${totalPages}&limit=${limit}">
                                    <iconify-icon icon="ic:round-keyboard-double-arrow-right"></iconify-icon>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>

            <!-- Add Toast Container -->
            <div class="position-fixed top-0 end-0 p-3" style="z-index: 11">
            <c:if test="${not empty toastMessage}">
                <div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header ${toastType eq 'success' ? 'bg-success' : 'bg-danger'} text-white">
                        <strong class="me-auto">${toastType eq 'success' ? 'Success' : 'Error'}</strong>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                    <div class="toast-body">
                        ${toastMessage}
                    </div>
                </div>
            </c:if>
        </div>

        <script>
            function changeLimit(newLimit) {
                let currentUrl = new URL(window.location.href);
                let searchParams = currentUrl.searchParams;
                if (searchParams.has('keyword')) {
                    searchParams.set('service', 'search');
                } else {
                    searchParams.set('service', 'list-all');
                }
                searchParams.set('limit', newLimit);
                searchParams.set('page', '1');
                window.location.href = currentUrl.pathname + '?' + searchParams.toString();
            }

            // Auto hide toast after 3 seconds
            document.addEventListener("DOMContentLoaded", function () {
                const toast = document.querySelector('.toast');
                if (toast) {
                    setTimeout(() => {
                        toast.classList.remove('show');
                        setTimeout(() => toast.remove(), 500);
                    }, 3000);
                }
            });

            function toggleBio(index, link) {
                const bioDiv = document.getElementById('bio-' + index);
                if (bioDiv.classList.contains('expanded')) {
                    bioDiv.classList.remove('expanded');
                    link.textContent = 'Xem thêm';
                } else {
                    bioDiv.classList.add('expanded');
                    link.textContent = 'Ẩn bớt';
                }
            }

            // Chỉ hiện "Xem thêm" nếu thực sự bị cắt
            document.addEventListener("DOMContentLoaded", function () {
                document.querySelectorAll('.bio-wrap').forEach(function(bio, idx) {
                    // Tạo clone để đo chiều cao thực tế
                    const clone = bio.cloneNode(true);
                    clone.style.visibility = 'hidden';
                    clone.style.position = 'absolute';
                    clone.style.height = 'auto';
                    clone.style.webkitLineClamp = 'unset';
                    clone.classList.add('expanded');
                    document.body.appendChild(clone);

                    // So sánh chiều cao thực tế và chiều cao bị cắt
                    if (clone.offsetHeight > bio.offsetHeight) {
                        // Hiện "Xem thêm"
                        const seeMore = bio.nextElementSibling;
                        if (seeMore && seeMore.classList.contains('see-more-link')) {
                            seeMore.style.display = 'inline';
                        }
                    }
                    document.body.removeChild(clone);
                });
            });
        </script>
        <script src="${pageContext.request.contextPath}/assets/admin/js/lib/jquery-3.7.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/admin/js/lib/dataTables.min.js"></script>
        <script>
        // Hàm lấy chữ cái đầu tiên (bỏ qua khoảng trắng)
        function getFirstLetter(data) {
            if (!data) return '';
            // Nếu có thẻ HTML thì lấy text
            var div = document.createElement("div");
            div.innerHTML = data;
            var text = div.textContent || div.innerText || "";
            text = text.trim();
            return text.charAt(0).toUpperCase();
        }

        // Đăng ký sort custom cho DataTables
        jQuery.extend(jQuery.fn.dataTable.ext.type.order, {
            "first-letter-asc": function(a, b) {
                return getFirstLetter(a).localeCompare(getFirstLetter(b), 'vi', {sensitivity: 'base'});
            },
            "first-letter-desc": function(a, b) {
                return getFirstLetter(b).localeCompare(getFirstLetter(a), 'vi', {sensitivity: 'base'});
            }
        });

        $(document).ready(function() {
            $('#staffTable').DataTable({
                "paging": false,
                "info": false,
                "searching": false,
                "ordering": true,
                "order": [],
                "columnDefs": [
                    { "orderable": false, "targets": [4, 6] }, // Trạng Thái, Hành Động
                    { "type": "num", "targets": [0, 5] },      // STT, EXP
                    // Custom sort theo chữ cái đầu cho 3 cột: Tên (1), Loại dịch vụ (2), Tiểu sử (3)
                    { "type": "first-letter", "targets": [1, 2, 3] }
                ],
                "language": {
                    "emptyTable": "Không có dữ liệu"
                }
            });
        });
        </script>
    </body>
</html>
