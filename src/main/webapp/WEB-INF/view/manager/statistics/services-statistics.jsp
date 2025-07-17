<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doanh Thu Dịch Vụ - Spa Hương Sen</title>
    
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
                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Doanh Thu Dịch Vụ</span>
                    </div>
                </li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-spa-dark mb-2">Doanh Thu Dịch Vụ</h1>
            <p class="text-gray-600">Phân tích hiệu suất và doanh thu từng dịch vụ spa</p>
        </div>

        <!-- Service Performance Summary -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Tổng Dịch Vụ</p>
                        <p class="text-2xl font-bold text-spa-dark">${servicePerformance.size()}</p>
                    </div>
                    <div class="p-3 bg-blue-100 rounded-full">
                        <i data-lucide="package" class="h-6 w-6 text-blue-600"></i>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Dịch Vụ Phổ Biến Nhất</p>
                        <p class="text-lg font-bold text-spa-dark">${servicePerformance[0].serviceName}</p>
                        <p class="text-sm text-gray-500">${servicePerformance[0].bookingCount} lượt đặt</p>
                    </div>
                    <div class="p-3 bg-green-100 rounded-full">
                        <i data-lucide="star" class="h-6 w-6 text-green-600"></i>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Doanh Thu Cao Nhất</p>
                        <p class="text-lg font-bold text-spa-dark">${servicePerformance[0].serviceName}</p>
                        <p class="text-sm text-gray-500">
                            <fmt:formatNumber value="${servicePerformance[0].totalRevenue}" type="currency" currencySymbol="₫" />
                        </p>
                    </div>
                    <div class="p-3 bg-yellow-100 rounded-full">
                        <i data-lucide="trending-up" class="h-6 w-6 text-yellow-600"></i>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Tỷ Lệ Sử Dụng TB</p>
                        <c:set var="totalUtilization" value="0" />
                        <c:forEach var="rate" items="${utilizationRates}">
                            <c:set var="totalUtilization" value="${totalUtilization + rate.value}" />
                        </c:forEach>
                        <p class="text-2xl font-bold text-spa-dark">
                            <fmt:formatNumber value="${totalUtilization / utilizationRates.size()}" maxFractionDigits="1" />%
                        </p>
                    </div>
                    <div class="p-3 bg-purple-100 rounded-full">
                        <i data-lucide="activity" class="h-6 w-6 text-purple-600"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <!-- Service Revenue Chart -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <h3 class="text-lg font-semibold text-spa-dark mb-4">Doanh Thu Theo Dịch Vụ</h3>
                <canvas id="serviceRevenueChart" width="400" height="200"></canvas>
            </div>

            <!-- Service Utilization Chart -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <h3 class="text-lg font-semibold text-spa-dark mb-4">Tỷ Lệ Sử Dụng Dịch Vụ</h3>
                <canvas id="utilizationChart" width="400" height="200"></canvas>
            </div>
        </div>

        <!-- Service Performance Table -->
        <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6 mb-8">
            <h3 class="text-lg font-semibold text-spa-dark mb-4">Hiệu Suất Chi Tiết Từng Dịch Vụ</h3>
            <div class="overflow-x-auto">
                <table id="servicePerformanceTable" class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Dịch Vụ
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Số Lượt Đặt
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Tổng Doanh Thu
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Doanh Thu TB
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Tỷ Lệ Sử Dụng
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Xu Hướng
                            </th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <c:forEach var="service" items="${servicePerformance}" varStatus="status">
                            <tr class="hover:bg-gray-50">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-10 w-10">
                                            <div class="h-10 w-10 rounded-full bg-primary/10 flex items-center justify-center">
                                                <i data-lucide="package" class="h-5 w-5 text-primary"></i>
                                            </div>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-900">${service.serviceName}</div>
                                            <div class="text-sm text-gray-500">Mã: ${service.serviceId}</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                    ${service.bookingCount}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                    <fmt:formatNumber value="${service.totalRevenue}" type="currency" currencySymbol="₫" />
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                    <fmt:formatNumber value="${service.averageRevenue}" type="currency" currencySymbol="₫" />
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="w-16 bg-gray-200 rounded-full h-2 mr-2">
                                            <div class="bg-primary h-2 rounded-full" style="width: ${utilizationRates[service.serviceName]}%"></div>
                                        </div>
                                        <span class="text-sm text-gray-900">
                                            <fmt:formatNumber value="${utilizationRates[service.serviceName]}" maxFractionDigits="1" />%
                                        </span>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <c:choose>
                                        <c:when test="${service.growthRate > 0}">
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                <i data-lucide="trending-up" class="w-3 h-3 mr-1"></i>
                                                +${service.growthRate}%
                                            </span>
                                        </c:when>
                                        <c:when test="${service.growthRate < 0}">
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                <i data-lucide="trending-down" class="w-3 h-3 mr-1"></i>
                                                ${service.growthRate}%
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                <i data-lucide="minus" class="w-3 h-3 mr-1"></i>
                                                0%
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Seasonal Analysis -->
        <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
            <h3 class="text-lg font-semibold text-spa-dark mb-4">Phân Tích Theo Mùa</h3>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                <c:set var="seasons" value="Xuân,Hạ,Thu,Đông" />
                <c:set var="seasonColors" value="bg-green-100 text-green-800,bg-yellow-100 text-yellow-800,bg-orange-100 text-orange-800,bg-blue-100 text-blue-800" />
                <c:forTokens items="${seasons}" delims="," var="season" varStatus="seasonStatus">
                    <c:forTokens items="${seasonColors}" delims="," var="colorClass" varStatus="colorStatus">
                        <c:if test="${seasonStatus.index == colorStatus.index}">
                            <div class="text-center p-4 bg-gray-50 rounded-lg">
                                <div class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium ${colorClass} mb-2">
                                    ${season}
                                </div>
                                <div class="text-2xl font-bold text-spa-dark mb-1">
                                    ${(seasonStatus.index + 1) * 150 + 200}
                                </div>
                                <div class="text-sm text-gray-600">lượt đặt</div>
                            </div>
                        </c:if>
                    </c:forTokens>
                </c:forTokens>
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
            $('#servicePerformanceTable').DataTable({
                language: {
                    url: 'https://cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json'
                },
                pageLength: 10,
                order: [[2, 'desc']], // Sort by total revenue
                columnDefs: [
                    { type: 'num-fmt', targets: [1, 2, 3] } // Numeric columns
                ]
            });
        });

        // Service Revenue Chart
        const revenueCtx = document.getElementById('serviceRevenueChart').getContext('2d');
        new Chart(revenueCtx, {
            type: 'bar',
            data: {
                labels: [<c:forEach var="service" items="${serviceRevenue}" varStatus="status">'${service.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
                datasets: [{
                    label: 'Doanh Thu (₫)',
                    data: [<c:forEach var="service" items="${serviceRevenue}" varStatus="status">${service.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
                    backgroundColor: '#D4AF37',
                    borderColor: '#B8941F',
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
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND'
                                }).format(value);
                            }
                        }
                    }
                }
            }
        });

        // Utilization Chart
        const utilizationCtx = document.getElementById('utilizationChart').getContext('2d');
        new Chart(utilizationCtx, {
            type: 'doughnut',
            data: {
                labels: [<c:forEach var="rate" items="${utilizationRates}" varStatus="status">'${rate.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
                datasets: [{
                    data: [<c:forEach var="rate" items="${utilizationRates}" varStatus="status">${rate.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
                    backgroundColor: ['#D4AF37', '#10B981', '#3B82F6', '#F59E0B', '#EF4444', '#8B5CF6'],
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
    </script>
</body>
</html>
