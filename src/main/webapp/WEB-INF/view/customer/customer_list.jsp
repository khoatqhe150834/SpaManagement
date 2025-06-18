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
    <title>Customer List - Spa Management</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/favicon.png" sizes="16x16">
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>

    <div class="container-fluid py-4">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-4">
            <h4 class="fw-bold mb-0">Customer List</h4>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/" class="text-decoration-none">
                            <i class="fas fa-home me-1"></i>
                            Home
                        </a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Customers</li>
                </ol>
            </nav>
        </div>

        <div class="card shadow">
            <div class="card-header bg-white border-bottom d-flex align-items-center flex-wrap gap-3 justify-content-between">
                <div class="d-flex align-items-center flex-wrap gap-3">
                    <span class="fw-medium text-muted mb-0">Show</span>
                    <form action="${pageContext.request.contextPath}/customer" method="get" class="d-inline">
                        <select class="form-select form-select-sm" name="pageSize" onchange="this.form.submit()">
                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
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

                    <form class="d-flex" action="${pageContext.request.contextPath}/customer/search" method="get">
                        <div class="input-group">
                            <input type="text" class="form-control" name="searchValue" value="${searchValue}" placeholder="Search customers...">
                            <select class="form-select" name="searchType">
                                <option value="name" ${searchType == 'name' ? 'selected' : ''}>Name</option>
                                <option value="email" ${searchType == 'email' ? 'selected' : ''}>Email</option>
                                <option value="phone" ${searchType == 'phone' ? 'selected' : ''}>Phone</option>
                            </select>
                            <button type="submit" class="btn btn-outline-primary">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                        <input type="hidden" name="page" value="1">
                        <input type="hidden" name="pageSize" value="${pageSize}">
                        <c:if test="${not empty status}">
                            <input type="hidden" name="status" value="${status}"/>
                        </c:if>
                    </form>

                    <form action="${pageContext.request.contextPath}/customer" method="get" class="d-inline">
                        <select class="form-select form-select-sm" name="status" onchange="this.form.submit()">
                            <option value="" ${empty status ? 'selected' : ''}>All Status</option>
                            <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
                            <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Inactive</option>
                        </select>
                        <input type="hidden" name="page" value="1">
                        <input type="hidden" name="pageSize" value="${pageSize}">
                        <c:if test="${not empty searchType}">
                            <input type="hidden" name="searchType" value="${searchType}"/>
                            <input type="hidden" name="searchValue" value="${searchValue}"/>
                        </c:if>
                    </form>
                </div>

                <a href="${pageContext.request.contextPath}/customer/create" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>
                    Add New Customer
                </a>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger mx-3 mt-3">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${error}
                </div>
            </c:if>

            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th scope="col">
                                    <div class="d-flex align-items-center">
                                        <input class="form-check-input me-2" type="checkbox" id="selectAll">
                                        ID
                                    </div>
                                </th>
                                <th scope="col">Join Date</th>
                                <th scope="col">Name</th>
                                <th scope="col">Email</th>
                                <th scope="col">Phone</th>
                                <th scope="col">Gender</th>
                                <th scope="col">Birthday</th>
                                <th scope="col">Address</th>
                                <th scope="col" class="text-center">Status</th>
                                <th scope="col" class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="customer" items="${listCustomer}" varStatus="loop">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <input class="form-check-input me-2" type="checkbox" name="checkbox">
                                            <span class="fw-medium">${customer.customerId}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty customer.createdAt}">
                                                <fmt:formatDate value="${customer.createdAt}" pattern="dd MMM yyyy"/>
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${not empty customer.avatarUrl ? customer.avatarUrl : pageContext.request.contextPath + '/assets/images/avatar.png'}" 
                                                 alt="Avatar" class="rounded-circle me-2" width="32" height="32">
                                            <span class="fw-medium"><c:out value="${customer.fullName}"/></span>
                                        </div>
                                    </td>
                                    <td><c:out value="${customer.email}"/></td>
                                    <td><c:out value="${customer.phoneNumber}"/></td>
                                    <td><c:out value="${customer.gender}"/></td>
                                    <td>
                                        <c:if test="${not empty customer.birthday}">
                                            <fmt:formatDate value="${customer.birthday}" pattern="dd MMM yyyy"/>
                                        </c:if>
                                    </td>
                                    <td><c:out value="${customer.address}"/></td>
                                    <td class="text-center">
                                        <span class="badge ${customer.isActive ? 'bg-success' : 'bg-secondary'}">
                                            ${customer.isActive ? 'Active' : 'Inactive'}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <div class="btn-group" role="group">
                                            <a href="${pageContext.request.contextPath}/customer/view?id=${customer.customerId}" class="btn btn-sm btn-outline-info" title="View">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/customer/edit?id=${customer.customerId}" class="btn btn-sm btn-outline-success" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/customer/delete?id=${customer.customerId}" class="btn btn-sm btn-outline-danger remove-item-btn" title="Delete">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listCustomer}">
                                <tr>
                                    <td colspan="10" class="text-center py-4">
                                        <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No customers found</h5>
                                        <p class="text-muted">Try adjusting your search criteria or add a new customer.</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <c:if test="${not empty listCustomer}">
                    <div class="d-flex align-items-center justify-content-between p-3 border-top">
                        <span class="text-muted">
                            Showing ${(currentPage - 1) * pageSize + 1} to ${Math.min(currentPage * pageSize, totalCustomers)} of ${totalCustomers} entries
                        </span>
                        
                        <nav aria-label="Customer pagination">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/customer?page=${currentPage - 1}&pageSize=${pageSize}${not empty searchType ? '&searchType=' += searchType += '&searchValue=' += searchValue : ''}${not empty status ? '&status=' += status : ''}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:if test="${i <= 5 or (i >= currentPage - 2 and i <= currentPage + 2) or i >= totalPages - 2}">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/customer?page=${i}&pageSize=${pageSize}${not empty searchType ? '&searchType=' += searchType += '&searchValue=' += searchValue : ''}${not empty status ? '&status=' += status : ''}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:if>
                                    <c:if test="${i == 6 and currentPage > 8}">
                                        <li class="page-item disabled">
                                            <span class="page-link">...</span>
                                        </li>
                                    </c:if>
                                    <c:if test="${i == currentPage + 3 and currentPage < totalPages - 5}">
                                        <li class="page-item disabled">
                                            <span class="page-link">...</span>
                                        </li>
                                    </c:if>
                                </c:forEach>
                                
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/customer?page=${currentPage + 1}&pageSize=${pageSize}${not empty searchType ? '&searchType=' += searchType += '&searchValue=' += searchValue : ''}${not empty status ? '&status=' += status : ''}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
    <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>

    <script>
        $(document).ready(function() {
            // Select all checkbox functionality
            $('#selectAll').on('change', function() {
                $('input[name="checkbox"]').prop('checked', $(this).prop('checked'));
            });

            // Delete confirmation
            $('.remove-item-btn').on('click', function(e) {
                e.preventDefault();
                if (confirm('Are you sure you want to delete this customer?')) {
                    window.location.href = $(this).attr('href');
                }
            });

            // Auto-submit forms when select changes
            $('select[onchange="this.form.submit()"]').on('change', function() {
                $(this).closest('form').submit();
            });
        });
    </script>
</body>
</html> 