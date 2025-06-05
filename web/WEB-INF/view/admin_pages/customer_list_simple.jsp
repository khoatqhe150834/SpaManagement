<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer List - Spa Management</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .table th { background-color: #f8f9fa; font-weight: 600; }
        .badge-active { background-color: #d4edda; color: #155724; }
        .badge-inactive { background-color: #f8d7da; color: #721c24; }
        .btn-action { width: 32px; height: 32px; border-radius: 50%; }
    </style>
</head>
<body>
    <div class="container-fluid p-4">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-1">Customer List</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Dashboard</a></li>
                        <li class="breadcrumb-item active">Customer List</li>
                    </ol>
                </nav>
            </div>
            <a href="${pageContext.request.contextPath}/customer/create" class="btn btn-primary">
                <i class="ri-add-line me-1"></i>Add New Customer
            </a>
        </div>

        <!-- Filters -->
        <div class="card mb-4">
            <div class="card-body">
                <div class="row g-3 align-items-end">
                    <div class="col-md-2">
                        <label class="form-label">Show</label>
                        <form action="${pageContext.request.contextPath}/customer" method="get" class="d-inline">
                            <select class="form-select" name="pageSize" onchange="this.form.submit()">
                                <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                            </select>
                            <input type="hidden" name="page" value="1">
                            <c:if test="${not empty searchType}">
                                <input type="hidden" name="searchType" value="${searchType}"/>
                                <input type="hidden" name="searchValue" value="${searchValue}"/>
                            </c:if>
                            <c:if test="${not empty param.status}">
                                <input type="hidden" name="status" value="${param.status}"/>
                            </c:if>
                        </form>
                    </div>
                    
                    <div class="col-md-4">
                        <label class="form-label">Search</label>
                        <form action="${pageContext.request.contextPath}/customer/search" method="get" class="d-flex">
                            <input type="text" class="form-control me-2" name="searchValue" value="${searchValue}" placeholder="Search by Name, Email, or Phone">
                            <select class="form-select me-2" name="searchType" style="max-width: 120px;">
                                <option value="name" ${searchType == 'name' ? 'selected' : ''}>Name</option>
                                <option value="email" ${searchType == 'email' ? 'selected' : ''}>Email</option>
                                <option value="phone" ${searchType == 'phone' ? 'selected' : ''}>Phone</option>
                            </select>
                            <button type="submit" class="btn btn-outline-primary">
                                <i class="ri-search-line"></i>
                            </button>
                            <input type="hidden" name="page" value="1">
                            <input type="hidden" name="pageSize" value="${pageSize}">
                            <c:if test="${not empty param.status}">
                                <input type="hidden" name="status" value="${param.status}"/>
                            </c:if>
                        </form>
                    </div>
                    
                    <div class="col-md-2">
                        <label class="form-label">Status</label>
                        <form action="${pageContext.request.contextPath}/customer" method="get">
                            <select class="form-select" name="status" onchange="this.form.submit()">
                                <option value="" ${empty param.status ? 'selected' : ''}>All Status</option>
                                <option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                            <input type="hidden" name="page" value="1">
                            <input type="hidden" name="pageSize" value="${pageSize}">
                            <c:if test="${not empty searchType}">
                                <input type="hidden" name="searchType" value="${searchType}"/>
                                <input type="hidden" name="searchValue" value="${searchValue}"/>
                            </c:if>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Error Display -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                ${error}
            </div>
        </c:if>

        <!-- Customer Table -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Join Date</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Gender</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="customer" items="${listCustomer}" varStatus="loop">
                                <tr>
                                    <td>${customer.customerId}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${customer.createdAt != null}">
                                                <fmt:formatDate value="${customer.createdAt}" pattern="dd MMM yyyy"/>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><c:out value="${customer.fullName}"/></td>
                                    <td><c:out value="${customer.email}"/></td>
                                    <td><c:out value="${customer.phoneNumber}"/></td>
                                    <td><c:out value="${customer.gender}"/></td>
                                    <td>
                                        <span class="badge ${customer.isActive ? 'badge-active' : 'badge-inactive'}">
                                            ${customer.isActive ? 'Active' : 'Inactive'}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="d-flex gap-1">
                                            <a href="${pageContext.request.contextPath}/customer/view?id=${customer.customerId}" 
                                               class="btn btn-outline-info btn-sm" title="View">
                                                <i class="ri-eye-line"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/customer/edit?id=${customer.customerId}" 
                                               class="btn btn-outline-success btn-sm" title="Edit">
                                                <i class="ri-edit-line"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/customer/delete?id=${customer.customerId}" 
                                               class="btn btn-outline-danger btn-sm" title="Delete">
                                                <i class="ri-delete-bin-line"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listCustomer}">
                                <tr>
                                    <td colspan="8" class="text-center text-muted py-4">No customers found</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination Info -->
                <div class="mt-3">
                    <span class="text-muted">
                        Showing ${(currentPage - 1) * pageSize + 1} to ${Math.min(currentPage * pageSize, totalCustomers)} of ${totalCustomers} entries
                    </span>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 