<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng Quan Doanh Thu - Spa Hương Sen</title>
    
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
                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Tổng Quan Doanh Thu</span>
                    </div>
                </li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-spa-dark mb-2">Tổng Quan Doanh Thu</h1>
            <p class="text-gray-600">Phân tích chi tiết doanh thu và xu hướng tăng trưởng</p>
        </div>

        <!-- Revenue Summary Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Tổng Doanh Thu</p>
                        <p class="text-2xl font-bold text-spa-dark">
                            <fmt:formatNumber value="${revenueData.totalRevenue}" type="currency" currencySymbol="₫" />
                        </p>
                    </div>
                    <div class="p-3 bg-green-100 rounded-full">
                        <i data-lucide="trending-up" class="h-6 w-6 text-green-600"></i>
                    </div>
                </div>
                <div class="mt-4">
                    <span class="text-green-600 text-sm font-medium">+${revenueData.growthPercentage}%</span>
                    <span class="text-gray-500 text-sm ml-2">so với tháng trước</span>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Doanh Thu Tháng Này</p>
                        <p class="text-2xl font-bold text-spa-dark">
                            <fmt:formatNumber value="${revenueData.monthlyRevenue}" type="currency" currencySymbol="₫" />
                        </p>
                    </div>
                    <div class="p-3 bg-blue-100 rounded-full">
                        <i data-lucide="calendar" class="h-6 w-6 text-blue-600"></i>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Trung Bình/Giao Dịch</p>
                        <p class="text-2xl font-bold text-spa-dark">
                            <fmt:formatNumber value="${revenueData.averageTransaction}" type="currency" currencySymbol="₫" />
                        </p>
                    </div>
                    <div class="p-3 bg-yellow-100 rounded-full">
                        <i data-lucide="dollar-sign" class="h-6 w-6 text-yellow-600"></i>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Số Giao Dịch</p>
                        <p class="text-2xl font-bold text-spa-dark">${revenueData.totalTransactions}</p>
                    </div>
                    <div class="p-3 bg-purple-100 rounded-full">
                        <i data-lucide="credit-card" class="h-6 w-6 text-purple-600"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <!-- Monthly Revenue Chart -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <h3 class="text-lg font-semibold text-spa-dark mb-4">Doanh Thu Theo Tháng</h3>
                <canvas id="monthlyRevenueChart" width="400" height="200"></canvas>
            </div>

            <!-- Daily Revenue Chart -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <h3 class="text-lg font-semibold text-spa-dark mb-4">Doanh Thu 30 Ngày Gần Nhất</h3>
                <canvas id="dailyRevenueChart" width="400" height="200"></canvas>
            </div>
        </div>

        <!-- Revenue by Status -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <h3 class="text-lg font-semibold text-spa-dark mb-4">Doanh Thu Theo Trạng Thái</h3>
                <canvas id="revenueByStatusChart" width="400" height="200"></canvas>
            </div>

            <!-- Top Services by Revenue -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <h3 class="text-lg font-semibold text-spa-dark mb-4">Top 10 Dịch Vụ Theo Doanh Thu</h3>
                <div class="space-y-3">
                    <c:forEach var="service" items="${topServices}" varStatus="status">
                        <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                            <div class="flex items-center">
                                <span class="w-6 h-6 bg-primary text-white rounded-full flex items-center justify-center text-xs font-bold mr-3">
                                    ${status.index + 1}
                                </span>
                                <span class="font-medium text-gray-900">${service.serviceName}</span>
                            </div>
                            <div class="text-right">
                                <div class="font-semibold text-spa-dark">
                                    <fmt:formatNumber value="${service.revenue}" type="currency" currencySymbol="₫" />
                                </div>
                                <div class="text-sm text-gray-500">${service.transactionCount} giao dịch</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- Include Footer -->
    <jsp:include page="../../common/footer.jsp" />

    <script>
        // Initialize Lucide icons
        lucide.createIcons();

        // Monthly Revenue Chart
        const monthlyCtx = document.getElementById('monthlyRevenueChart').getContext('2d');
        new Chart(monthlyCtx, {
            type: 'line',
            data: {
                labels: [<c:forEach var="entry" items="${monthlyRevenue}" varStatus="status">'${entry.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
                datasets: [{
                    label: 'Doanh Thu (₫)',
                    data: [<c:forEach var="entry" items="${monthlyRevenue}" varStatus="status">${entry.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
                    borderColor: '#D4AF37',
                    backgroundColor: 'rgba(212, 175, 55, 0.1)',
                    tension: 0.4,
                    fill: true
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

        // Daily Revenue Chart
        const dailyCtx = document.getElementById('dailyRevenueChart').getContext('2d');
        new Chart(dailyCtx, {
            type: 'bar',
            data: {
                labels: [<c:forEach var="entry" items="${dailyRevenue}" varStatus="status">'${entry.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
                datasets: [{
                    label: 'Doanh Thu (₫)',
                    data: [<c:forEach var="entry" items="${dailyRevenue}" varStatus="status">${entry.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
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

        // Revenue by Status Chart
        const statusCtx = document.getElementById('revenueByStatusChart').getContext('2d');
        new Chart(statusCtx, {
            type: 'doughnut',
            data: {
                labels: [<c:forEach var="entry" items="${revenueByStatus}" varStatus="status">'${entry.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
                datasets: [{
                    data: [<c:forEach var="entry" items="${revenueByStatus}" varStatus="status">${entry.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
                    backgroundColor: ['#10B981', '#F59E0B', '#EF4444', '#8B5CF6'],
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
