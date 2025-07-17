<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Khách Hàng - Spa Hương Sen</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#D4AF37',
                        'primary-dark': '#B8941F',
                        'spa-cream': '#FAF7F0',
                        'spa-dark': '#2C3E50'
                    }
                }
            }
        }
    </script>
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- DataTables -->
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.13.6/css/dataTables.tailwindcss.min.css">
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.13.6/js/dataTables.tailwindcss.min.js"></script>
    
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
</head>
<body class="bg-spa-cream min-h-screen">
    <!-- Include Header -->
    <jsp:include page="../../common/header.jsp" />
    
    <!-- Include Sidebar -->
    <jsp:include page="../../common/sidebar.jsp" />
    
    <!-- Main Content -->
    <div class="ml-64 pt-16 p-6">
        <!-- Breadcrumb -->
        <nav class="flex mb-6" aria-label="Breadcrumb">
            <ol class="inline-flex items-center space-x-1 md:space-x-3">
                <li class="inline-flex items-center">
                    <a href="${pageContext.request.contextPath}/dashboard" class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-primary">
                        <i data-lucide="home" class="w-4 h-4 mr-2"></i>
                        Dashboard
                    </a>
                </li>
                <li>
                    <div class="flex items-center">
                        <i data-lucide="chevron-right" class="w-4 h-4 text-gray-400"></i>
                        <a href="${pageContext.request.contextPath}/manager/payment-statistics" class="ml-1 text-sm font-medium text-gray-700 hover:text-primary md:ml-2">Thống Kê Thanh Toán</a>
                    </div>
                </li>
                <li aria-current="page">
                    <div class="flex items-center">
                        <i data-lucide="chevron-right" class="w-4 h-4 text-gray-400"></i>
                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Báo Cáo Khách Hàng</span>
                    </div>
                </li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-spa-dark mb-2">Báo Cáo Khách Hàng</h1>
            <p class="text-gray-600">Phân tích hành vi và giá trị khách hàng</p>
        </div>

        <!-- Customer Summary Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Tổng Khách Hàng</p>
                        <p class="text-2xl font-bold text-spa-dark">${customerBehavior.totalCustomers}</p>
                    </div>
                    <div class="p-3 bg-blue-100 rounded-full">
                        <i data-lucide="users" class="h-6 w-6 text-blue-600"></i>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Khách Hàng Mới</p>
                        <p class="text-2xl font-bold text-spa-dark">${customerTypes.newCustomers}</p>
                        <p class="text-sm text-gray-500">tháng này</p>
                    </div>
                    <div class="p-3 bg-green-100 rounded-full">
                        <i data-lucide="user-plus" class="h-6 w-6 text-green-600"></i>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Khách Hàng Quay Lại</p>
                        <p class="text-2xl font-bold text-spa-dark">${customerTypes.returningCustomers}</p>
                        <p class="text-sm text-gray-500">tháng này</p>
                    </div>
                    <div class="p-3 bg-purple-100 rounded-full">
                        <i data-lucide="repeat" class="h-6 w-6 text-purple-600"></i>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">LTV Trung Bình</p>
                        <p class="text-2xl font-bold text-spa-dark">
                            <fmt:formatNumber value="${customerBehavior.averageLTV}" type="currency" currencySymbol="₫" />
                        </p>
                    </div>
                    <div class="p-3 bg-yellow-100 rounded-full">
                        <i data-lucide="trending-up" class="h-6 w-6 text-yellow-600"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <!-- Customer Segments -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <h3 class="text-lg font-semibold text-spa-dark mb-4">Phân Khúc Khách Hàng</h3>
                <canvas id="customerSegmentsChart" width="400" height="200"></canvas>
            </div>

            <!-- New vs Returning Customers -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <h3 class="text-lg font-semibold text-spa-dark mb-4">Khách Hàng Mới vs Quay Lại</h3>
                <canvas id="customerTypesChart" width="400" height="200"></canvas>
            </div>
        </div>

        <!-- Top Customers Table -->
        <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6 mb-8">
            <h3 class="text-lg font-semibold text-spa-dark mb-4">Top 20 Khách Hàng VIP</h3>
            <div class="overflow-x-auto">
                <table id="topCustomersTable" class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Hạng
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Khách Hàng
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Tổng Chi Tiêu
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Số Giao Dịch
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Trung Bình/Giao Dịch
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Lần Cuối
                            </th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <c:forEach var="customer" items="${topCustomers}" varStatus="status">
                            <tr class="hover:bg-gray-50">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <c:choose>
                                            <c:when test="${status.index < 3}">
                                                <span class="w-8 h-8 bg-primary text-white rounded-full flex items-center justify-center text-sm font-bold">
                                                    ${status.index + 1}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="w-8 h-8 bg-gray-200 text-gray-600 rounded-full flex items-center justify-center text-sm font-bold">
                                                    ${status.index + 1}
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-10 w-10">
                                            <div class="h-10 w-10 rounded-full bg-primary/10 flex items-center justify-center">
                                                <i data-lucide="user" class="h-5 w-5 text-primary"></i>
                                            </div>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-900">${customer.customerName}</div>
                                            <div class="text-sm text-gray-500">${customer.email}</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                    <fmt:formatNumber value="${customer.totalSpent}" type="currency" currencySymbol="₫" />
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                    ${customer.transactionCount}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                    <fmt:formatNumber value="${customer.averageSpent}" type="currency" currencySymbol="₫" />
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    ${customer.lastVisit}
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Customer Lifetime Value Analysis -->
        <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
            <h3 class="text-lg font-semibold text-spa-dark mb-4">Phân Tích Giá Trị Khách Hàng (LTV)</h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <c:forEach var="segment" items="${customerLTV}">
                    <div class="text-center p-4 bg-gray-50 rounded-lg">
                        <div class="text-2xl font-bold text-spa-dark mb-2">
                            <fmt:formatNumber value="${segment.averageLTV}" type="currency" currencySymbol="₫" />
                        </div>
                        <div class="text-sm font-medium text-gray-600 mb-1">${segment.segmentName}</div>
                        <div class="text-xs text-gray-500">${segment.customerCount} khách hàng</div>
                        <div class="mt-2">
                            <div class="w-full bg-gray-200 rounded-full h-2">
                                <div class="bg-primary h-2 rounded-full" style="width: ${segment.percentage}%"></div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Include Footer -->
    <jsp:include page="../../common/footer.jsp" />

    <script>
        // Initialize Lucide icons
        lucide.createIcons();

        // Initialize DataTables
        $(document).ready(function() {
            $('#topCustomersTable').DataTable({
                language: {
                    url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json'
                },
                pageLength: 10,
                order: [[2, 'desc']], // Sort by total spent
                columnDefs: [
                    { orderable: false, targets: 0 } // Disable sorting for rank column
                ]
            });
        });

        // Customer Segments Chart
        const segmentsCtx = document.getElementById('customerSegmentsChart').getContext('2d');
        new Chart(segmentsCtx, {
            type: 'doughnut',
            data: {
                labels: [<c:forEach var="segment" items="${customerSegments}" varStatus="status">'${segment.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
                datasets: [{
                    data: [<c:forEach var="segment" items="${customerSegments}" varStatus="status">${segment.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
                    backgroundColor: ['#D4AF37', '#10B981', '#3B82F6', '#F59E0B', '#EF4444'],
                    borderWidth: 2,
                    borderColor: '#ffffff'
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // Customer Types Chart
        const typesCtx = document.getElementById('customerTypesChart').getContext('2d');
        new Chart(typesCtx, {
            type: 'bar',
            data: {
                labels: ['Khách hàng mới', 'Khách hàng quay lại'],
                datasets: [{
                    label: 'Số lượng',
                    data: [${customerTypes.newCustomers}, ${customerTypes.returningCustomers}],
                    backgroundColor: ['#10B981', '#D4AF37'],
                    borderColor: ['#059669', '#B8941F'],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html>
