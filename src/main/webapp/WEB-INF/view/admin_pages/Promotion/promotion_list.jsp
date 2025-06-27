<%-- 
    Document   : promotion_list
    Created on : Jun 11, 2025
    Author     : Admin
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Promotions - Admin Dashboard</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
    <style>
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
        .table-responsive {
            overflow-x: auto;
        }
        .form-select-sm {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }
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
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/view/common/admin/toast.jsp"></jsp:include>

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Danh sách khuyến mãi</h6>
            <div class="d-flex align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary">
                    <iconify-icon icon="ic:round-home" class="me-1"></iconify-icon> Trang chủ
                </a>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary">
                    <iconify-icon icon="solar:home-smile-angle-outline" class="me-1"></iconify-icon> Bảng điều khiển
                </a>
            </div>
        </div>

        <%-- Display success message --%>
        <c:if test="${not empty sessionScope.successMessage}">
            <div id="toast-message" class="toast-message toast-success">
                <iconify-icon icon="mdi:check-circle" style="font-size: 1.6rem; color: #219653;"></iconify-icon>
                <span>Thành công!</span>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <%-- Display error message --%>
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
                    <form class="navbar-search d-flex gap-2 align-items-center" method="get" action="${pageContext.request.contextPath}/promotion/list">
                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="pageSize" onchange="this.form.submit()">
                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                            <option value="9999" ${pageSize == 9999 ? 'selected' : ''}>All</option>
                        </select>
                        
                        <input type="text" class="bg-base h-40-px w-auto" name="searchValue" placeholder="Tìm theo tiêu đề, mã khuyến mãi..." value="${searchValue}">
                        
                        <select class="form-select form-select-sm w-auto ps-12 py-6 radius-12 h-40-px" name="status">
                            <option value="">Tất cả trạng thái</option>
                            <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Đang áp dụng</option>
                            <option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>Ngừng áp dụng</option>
                            <option value="SCHEDULED" ${status == 'SCHEDULED' ? 'selected' : ''}>Sắp diễn ra</option>
                        </select>
                        <button type="submit" class="btn btn-primary h-40-px radius-12">Tìm kiếm</button>
                        <input type="hidden" name="page" value="1">
                    </form>
                </div>
                <a href="${pageContext.request.contextPath}/promotion/create" class="btn btn-primary text-sm btn-sm px-12 py-12 radius-8 d-flex align-items-center gap-2">
                    <iconify-icon icon="ic:baseline-plus" class="icon text-xl line-height-1"></iconify-icon>
                    Thêm khuyến mãi
                </a>
            </div>

            <c:if test="${not empty listPromotion}">
                <div class="card-body p-24">
                    <div class="table-responsive scroll-sm">
                        <table class="table bordered-table sm-table mb-0">
                            <thead>
                                <tr>
                                    <th scope="col">
                                        ID
                                        <a href="?sortBy=id&sortOrder=asc<c:if test='${not empty searchValue}'>&searchValue=${searchValue}</c:if><c:if test='${not empty status}'>&status=${status}</c:if>&page=${currentPage}" title="Sort Ascending">&#9650;</a>
                                        <a href="?sortBy=id&sortOrder=desc<c:if test='${not empty searchValue}'>&searchValue=${searchValue}</c:if><c:if test='${not empty status}'>&status=${status}</c:if>&page=${currentPage}" title="Sort Descending">&#9660;</a>
                                    </th>
                                    <th scope="col">Ảnh</th>
                                    <th scope="col">
                                        Tiêu đề
                                        <a href="?sortBy=title&sortOrder=asc<c:if test='${not empty searchValue}'>&searchValue=${searchValue}</c:if><c:if test='${not empty status}'>&status=${status}</c:if>&page=${currentPage}" title="Sort Ascending">&#9650;</a>
                                        <a href="?sortBy=title&sortOrder=desc<c:if test='${not empty searchValue}'>&searchValue=${searchValue}</c:if><c:if test='${not empty status}'>&status=${status}</c:if>&page=${currentPage}" title="Sort Descending">&#9660;</a>
                                    </th>
                                    <th scope="col">Mã khuyến mãi</th>
                                    <th scope="col">Giá trị</th>
                                    <th scope="col" class="text-center">Trạng thái</th>
                                    <th scope="col" class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="promotion" items="${listPromotion}">
                                    <tr>
                                        <td>${promotion.promotionId}</td>
                                        <td>
                                            <img src="${not empty promotion.imageUrl ? promotion.imageUrl : 'https://placehold.co/100x100/7C3AED/FFFFFF?text=PROMO'}" 
                                                 alt="${promotion.title}"
                                                 class="rounded"
                                                 style="width: 50px; height: 50px; object-fit: cover;">
                                        </td>
                                        <td>${promotion.title}</td>
                                        <td>${promotion.promotionCode}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${promotion.discountType eq 'PERCENTAGE'}">
                                                    ${promotion.discountValue}%
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${promotion.discountValue}" type="currency" currencyCode="VND"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${promotion.status eq 'ACTIVE'}">
                                                    <span class="bg-success-focus text-success-600 border border-success-main px-24 py-4 radius-4 fw-medium text-sm">Đang áp dụng</span>
                                                </c:when>
                                                <c:when test="${promotion.status eq 'SCHEDULED'}">
                                                    <span class="bg-warning-focus text-warning-600 border border-warning-main px-24 py-4 radius-4 fw-medium text-sm">Sắp diễn ra</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="bg-neutral-200 text-neutral-600 border border-neutral-400 px-24 py-4 radius-4 fw-medium text-sm">Ngừng áp dụng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex align-items-center gap-10 justify-content-center">
                                                <a href="${pageContext.request.contextPath}/promotion/view?id=${promotion.promotionId}" class="bg-info-focus text-info-600 bg-hover-info-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Xem">
                                                    <iconify-icon icon="majesticons:eye-line" class="menu-icon"></iconify-icon>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/promotion/edit?id=${promotion.promotionId}" class="bg-success-focus text-success-600 bg-hover-success-200 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Sửa">
                                                    <iconify-icon icon="lucide:edit" class="menu-icon"></iconify-icon>
                                                </a>
                                                <c:choose>
                                                    <c:when test="${promotion.status eq 'ACTIVE'}">
                                                        <c:url var="deactivateUrl" value="/promotion/deactivate">
                                                            <c:param name="id" value="${promotion.promotionId}" />
                                                            <c:param name="page" value="${currentPage}" />
                                                            <c:param name="searchValue" value="${searchValue}" />
                                                            <c:param name="status" value="${status}" />
                                                        </c:url>
                                                        <a href="${deactivateUrl}" onclick="confirmAction(event, this.href, 'Bạn muốn vô hiệu hóa khuyến mãi này?')" class="bg-warning-focus bg-hover-warning-200 text-warning-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Vô hiệu hóa">
                                                            <iconify-icon icon="fluent:presence-available-24-filled" class="menu-icon"></iconify-icon>
                                                        </a>
                                                    </c:when>
                                                    <c:when test="${promotion.status eq 'INACTIVE'}">
                                                        <c:url var="activateUrl" value="/promotion/activate">
                                                            <c:param name="id" value="${promotion.promotionId}" />
                                                            <c:param name="page" value="${currentPage}" />
                                                            <c:param name="searchValue" value="${searchValue}" />
                                                            <c:param name="status" value="${status}" />
                                                        </c:url>
                                                        <a href="${activateUrl}" onclick="confirmAction(event, this.href, 'Bạn muốn kích hoạt khuyến mãi này?')" class="bg-success-focus bg-hover-success-200 text-success-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Kích hoạt">
                                                            <iconify-icon icon="fluent:presence-blocked-20-regular" class="menu-icon"></iconify-icon>
                                                        </a>
                                                    </c:when>
                                                    <c:when test="${promotion.status eq 'SCHEDULED'}">
                                                        <c:url var="activateUrl" value="/promotion/activate">
                                                            <c:param name="id" value="${promotion.promotionId}" />
                                                            <c:param name="page" value="${currentPage}" />
                                                            <c:param name="searchValue" value="${searchValue}" />
                                                            <c:param name="status" value="${status}" />
                                                        </c:url>
                                                        <a href="${activateUrl}" onclick="confirmAction(event, this.href, 'Bạn muốn kích hoạt ngay khuyến mãi này?')" class="bg-success-focus bg-hover-success-200 text-success-600 fw-medium w-40-px h-40-px d-flex justify-content-center align-items-center rounded-circle" title="Activate Now">
                                                            <iconify-icon icon="material-symbols:schedule" class="menu-icon"></iconify-icon>
                                                        </a>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>

            <c:if test="${empty listPromotion}">
                <div class="p-24 text-center">No promotions found matching your criteria.</div>
            </c:if>

            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mt-24 p-24">
                <c:set var="start" value="${(currentPage - 1) * pageSize + 1}" />
                <c:set var="end" value="${start + fn:length(listPromotion) - 1}" />
                <span>
                    <c:if test="${totalPromotions > 0}">Showing ${start} to ${end} of ${totalPromotions} entries</c:if>
                    <c:if test="${totalPromotions == 0}">No entries found</c:if>
                </span>
                <ul class="pagination d-flex flex-wrap align-items-center gap-2 justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <c:url var="prevUrl" value="/promotion/list">
                            <c:param name="page" value="${currentPage - 1}"/>
                            <c:param name="searchValue" value="${searchValue}"/>
                            <c:param name="status" value="${status}"/>
                        </c:url>
                        <a class="page-link" href="${currentPage > 1 ? prevUrl : '#'}">
                            <iconify-icon icon="ep:d-arrow-left"></iconify-icon>
                        </a>
                    </li>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <c:url var="pageUrl" value="/promotion/list">
                            <c:param name="page" value="${i}"/>
                            <c:param name="searchValue" value="${searchValue}"/>
                            <c:param name="status" value="${status}"/>
                        </c:url>
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link radius-8 d-flex align-items-center justify-content-center h-32-px w-32-px" href="${pageUrl}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <c:url var="nextUrl" value="/promotion/list">
                            <c:param name="page" value="${currentPage + 1}"/>
                            <c:param name="searchValue" value="${searchValue}"/>
                            <c:param name="status" value="${status}"/>
                        </c:url>
                        <a class="page-link" href="${currentPage < totalPages ? nextUrl : '#'}">
                            <iconify-icon icon="ep:d-arrow-right"></iconify-icon>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>
    <script>
        function confirmAction(event, url, message) {
            event.preventDefault(); // Stop the link from navigating immediately
            Swal.fire({
                title: 'Bạn có chắc chắn?',
                text: message,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Đồng ý',
                cancelButtonText: 'Hủy bỏ'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = url;
                }
            });
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