<%-- 
    Document   : customer_list
    Created on : Jun 4, 2025
    Author     : Admin
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer List - Wowdash</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp"></jsp:include>
    <style>
        .search-section {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 24px;
        }
        .search-input {
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        .search-input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        .search-btn {
            background: #3b82f6;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 20px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .search-btn:hover {
            background: #2563eb;
        }
        .custom-select {
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 14px;
            background: white;
            cursor: pointer;
        }
        .action-btn {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            border: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            cursor: pointer;
            margin: 0 4px;
            transition: all 0.3s ease;
        }
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .btn-view {
            background: #dbeafe;
            color: #1d4ed8;
        }
        .btn-edit {
            background: #fef3c7;
            color: #d97706;
        }
        .btn-delete {
            background: #fee2e2;
            color: #dc2626;
        }

        /* Customer name - no truncation */
        .customer-name {
            /* Let names display fully */
        }

        /* Responsive table - no horizontal scroll */
        .table {
            table-layout: auto;
            width: 100%;
        }
        
        .table-responsive {
            overflow-x: visible;
        }
        
        /* Compact form selects */
        .form-select-sm {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
            min-width: 40px;
        }

    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/admin/sidebar.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/view/common/admin/header.jsp"></jsp:include>

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Customer List</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="${pageContext.request.contextPath}/dashboard" class="d-flex align-items-center gap-1 hover-text-primary text-decoration-none">
                        🏠 Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium text-muted">Customer List</li>
            </ul>
        </div>

        <!-- Search and Filter Section -->
        <div class="search-section">
            <div class="row">
                <div class="col-lg-8">
                    <form class="d-flex gap-3 align-items-center flex-wrap" action="${pageContext.request.contextPath}/customer/search" method="get">
                        <div class="flex-grow-1" style="min-width: 300px;">
                            <input type="text" 
                                   class="form-control search-input" 
                                   name="searchValue" 
                                   value="${searchValue}" 
                                   placeholder="🔍 Search by name, email or phone number...">
                        </div>
                        
                        <select class="form-select custom-select" name="searchType" style="width: auto;">
                            <option value="name" ${searchType == 'name' ? 'selected' : ''}>👤 Name</option>
                            <option value="email" ${searchType == 'email' ? 'selected' : ''}>📧 Email</option>
                            <option value="phone" ${searchType == 'phone' ? 'selected' : ''}>📱 Phone</option>
                        </select>
                        
                        <button type="submit" class="btn search-btn">
                            🔍 Search
                        </button>
                        
                        <input type="hidden" name="page" value="1">
                        <input type="hidden" name="pageSize" value="${pageSize}">
                        <c:if test="${not empty status}">
                            <input type="hidden" name="status" value="${status}"/>
                        </c:if>
                    </form>
                </div>
                
                <div class="col-lg-4">
                    <div class="d-flex gap-3 justify-content-lg-end align-items-center flex-wrap">
                        <div class="d-flex align-items-center gap-2">
                            <span class="text-sm fw-medium">Show:</span>
                            <form action="${pageContext.request.contextPath}/customer" method="get">
                                <select class="form-select custom-select" name="pageSize" onchange="this.form.submit()" style="width: auto;">
                                    <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                    <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                    <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
                                    <option value="999999" ${pageSize >= 999999 ? 'selected' : ''}>🌟 All</option>
                                </select>
                                <input type="hidden" name="page" value="1">
                                <c:if test="${not empty searchType}">
                                    <input type="hidden" name="searchType" value="${searchType}"/>
                                    <input type="hidden" name="searchValue" value="${searchValue}"/>
                                </c:if>
                                <c:if test="${not empty status}">
                                    <input type="hidden" name="status" value="${status}"/>
                                </c:if>
                            </form>
                        </div>
                        

                        

                        
                        <a href="${pageContext.request.contextPath}/customer/create" class="btn search-btn text-decoration-none">
                            ➕ Add New
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="card h-100 p-0 radius-12">
            <c:if test="${not empty error}">
                <div class="alert alert-danger mx-24 mt-16">
                    <c:out value="${error}"/>
                </div>
            </c:if>

            <div class="card-body p-24">
                <div class="table-responsive">
                    <table class="table bordered-table mb-0">
                        <thead>
                            <!-- Filter/Sort Row -->
                            <tr class="bg-light">
                                <th class="p-2">
                                    <form action="${pageContext.request.contextPath}/customer" method="get">
                                        <select class="form-select form-select-sm" name="sortOrder" onchange="this.form.submit()">
                                            <option value="" ${empty sortOrder ? 'selected' : ''}>↕️</option>
                                            <option value="asc" ${sortOrder == 'asc' ? 'selected' : ''}>↗️</option>
                                            <option value="desc" ${sortOrder == 'desc' ? 'selected' : ''}>↘️</option>
                                        </select>
                                        <input type="hidden" name="sortBy" value="id">
                                        <input type="hidden" name="page" value="1">
                                        <input type="hidden" name="pageSize" value="${pageSize}">
                                        <c:if test="${not empty searchType}">
                                            <input type="hidden" name="searchType" value="${searchType}"/>
                                            <input type="hidden" name="searchValue" value="${searchValue}"/>
                                        </c:if>
                                        <c:if test="${not empty status}">
                                            <input type="hidden" name="status" value="${status}"/>
                                        </c:if>
                                    </form>
                                </th>
                                <th class="p-2"></th>
                                <th class="p-2"></th>
                                <th class="text-center p-2">
                                    <form action="${pageContext.request.contextPath}/customer" method="get">
                                        <select class="form-select form-select-sm" name="status" onchange="this.form.submit()">
                                            <option value="" ${empty status ? 'selected' : ''}>🔄</option>
                                            <option value="active" ${status == 'active' ? 'selected' : ''}>✅</option>
                                            <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>❌</option>
                                        </select>
                                        <input type="hidden" name="page" value="1">
                                        <input type="hidden" name="pageSize" value="${pageSize}">
                                        <c:if test="${not empty searchType}">
                                            <input type="hidden" name="searchType" value="${searchType}"/>
                                            <input type="hidden" name="searchValue" value="${searchValue}"/>
                                        </c:if>
                                        <c:if test="${not empty sortBy}">
                                            <input type="hidden" name="sortBy" value="${sortBy}"/>
                                            <input type="hidden" name="sortOrder" value="${sortOrder}"/>
                                        </c:if>
                                    </form>
                                </th>
                                <th class="text-center p-2"></th>
                            </tr>
                            <!-- Header Row -->
                            <tr>
                                <th>ID</th>
                                <th>👤 Customer Name</th>
                                <th>📧 Email</th>
                                <th class="text-center">📊 Status</th>
                                <th class="text-center">⚙️ Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="customer" items="${listCustomer}">
                                <tr>
                                    <td>
                                        <span class="fw-semibold text-primary fs-6">#${customer.customerId}</span>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${pageContext.request.contextPath}/assets/admin/images/avatar/avatar1.png" alt="avatar" class="w-40-px h-40-px rounded-circle me-3">
                                            <div class="customer-name">
                                                <h6 class="mb-0 fw-semibold">${customer.fullName}</h6>
                                                <small class="text-muted">ID: #${customer.customerId}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="text-muted">${customer.email}</span>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${customer.isActive}">
                                                <span class="badge bg-success">✅ Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">❌ Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/customer/view?id=${customer.customerId}" 
                                           class="action-btn btn-view" title="View Details">👁️</a>
                                        <a href="${pageContext.request.contextPath}/customer/edit?id=${customer.customerId}" 
                                           class="action-btn btn-edit" title="Edit">✏️</a>
                                        <button onclick="confirmDelete(${customer.customerId}, this.getAttribute('data-name'))" 
                                               class="action-btn btn-delete" title="Delete" data-name="${customer.fullName}">🗑️</button>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty listCustomer}">
                                <tr>
                                    <td colspan="5" class="text-center py-5">
                                        <div>
                                            <div style="font-size: 64px;">👥</div>
                                            <h6 class="mt-3">No customers found</h6>
                                            <p class="text-muted">Try adjusting your search filters or add new customers</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="d-flex align-items-center justify-content-between mt-4">
                        <span>Showing ${(currentPage - 1) * pageSize + 1} to ${Math.min(currentPage * pageSize, totalCustomers)} of ${totalCustomers} entries</span>
                        <nav>
                            <ul class="pagination mb-0">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/customer?page=${currentPage - 1}&pageSize=${pageSize}">←</a>
                                    </li>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/customer?page=${i}&pageSize=${pageSize}">${i}</a>
                                    </li>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/customer?page=${currentPage + 1}&pageSize=${pageSize}">→</a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/admin/js.jsp"></jsp:include>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <script>
        function confirmDelete(customerId, customerName) {
            // Delete any customer - no order checking required
            Swal.fire({
                title: '🗑️ Confirm Delete',
                html: 'Are you sure you want to delete customer:<br><strong>"' + customerName + '"</strong><br>ID: #' + customerId + '?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: '✅ Yes, delete it!',
                cancelButtonText: '❌ Cancel',
                reverseButtons: true,
                focusCancel: true
            }).then((result) => {
                if (result.isConfirmed) {
                    // Show loading
                    Swal.fire({
                        title: '🔄 Deleting...',
                        text: 'Please wait a moment',
                        icon: 'info',
                        allowOutsideClick: false,
                        showConfirmButton: false,
                        willOpen: () => {
                            Swal.showLoading();
                        }
                    });
                    
                    fetch('${pageContext.request.contextPath}/customer/delete?id=' + customerId)
                    .then(response => {
                        if (response.ok) {
                            Swal.fire({
                                title: '🎉 Deleted Successfully!',
                                text: 'Customer "' + customerName + '" has been removed from the system.',
                                icon: 'success',
                                timer: 2500,
                                showConfirmButton: false
                            }).then(() => {
                                window.location.reload();
                            });
                        } else {
                            Swal.fire({
                                title: '❌ Delete Failed!',
                                text: 'Unable to delete customer. Please try again.',
                                icon: 'error',
                                confirmButtonText: 'OK'
                            });
                        }
                    })
                    .catch(error => {
                        console.error('Delete error:', error);
                        Swal.fire({
                            title: '⚠️ System Error!',
                            text: 'An error occurred while deleting customer. Please try again.',
                            icon: 'error',
                            confirmButtonText: 'OK'
                        });
                    });
                }
            });
        }
        
        // Enhanced pagination with sorting preservation
        function goToPage(page) {
            const params = new URLSearchParams();
            params.set('page', page);
            params.set('pageSize', '${pageSize}');
            
            // Preserve sorting
            <c:if test="${not empty sortBy}">
                params.set('sortBy', '${sortBy}');
                params.set('sortOrder', '${sortOrder}');
            </c:if>
            
            // Preserve search
            <c:if test="${not empty searchType}">
                params.set('searchType', '${searchType}');
                params.set('searchValue', '${searchValue}');
            </c:if>
            
            // Preserve status
            <c:if test="${not empty status}">
                params.set('status', '${status}');
            </c:if>
            
            window.location.href = '${pageContext.request.contextPath}/customer?' + params.toString();
        }
    </script>
</body>
</html>