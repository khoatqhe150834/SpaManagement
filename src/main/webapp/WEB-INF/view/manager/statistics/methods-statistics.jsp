<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phân Tích Phương Thức Thanh Toán - Spa Hương Sen</title>
    
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
                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Phân Tích Phương Thức</span>
                    </div>
                </li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-spa-dark mb-2">Phân Tích Phương Thức Thanh Toán</h1>
            <p class="text-gray-600">Thống kê chi tiết các phương thức thanh toán và xu hướng sử dụng</p>
        </div>

        <!-- Payment Method Summary Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <c:forEach var="method" items="${paymentMethodCounts}" varStatus="status">
                <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-600">${method.key}</p>
                            <p class="text-2xl font-bold text-spa-dark">${method.value}</p>
                            <p class="text-sm text-gray-500">giao dịch</p>
                        </div>
                        <div class="p-3 bg-primary/10 rounded-full">
                            <c:choose>
                                <c:when test="${method.key == 'CASH'}">
                                    <i data-lucide="banknote" class="h-6 w-6 text-primary"></i>
                                </c:when>
                                <c:when test="${method.key == 'CARD'}">
                                    <i data-lucide="credit-card" class="h-6 w-6 text-primary"></i>
                                </c:when>
                                <c:when test="${method.key == 'BANK_TRANSFER'}">
                                    <i data-lucide="building-2" class="h-6 w-6 text-primary"></i>
                                </c:when>
                                <c:otherwise>
                                    <i data-lucide="smartphone" class="h-6 w-6 text-primary"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="mt-4">
                        <div class="text-sm font-medium text-spa-dark">
                            <fmt:formatNumber value="${paymentMethodRevenue[method.key]}" type="currency" currencySymbol="₫" />
                        </div>
                        <div class="text-sm text-gray-500">
                            Trung bình: <fmt:formatNumber value="${avgAmountByMethod[method.key]}" type="currency" currencySymbol="₫" />
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Charts Row -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <!-- Payment Method Distribution -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <h3 class="text-lg font-semibold text-spa-dark mb-4">Phân Bố Phương Thức Thanh Toán</h3>
                <canvas id="paymentMethodChart" width="400" height="200"></canvas>
            </div>

            <!-- Revenue by Payment Method -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <h3 class="text-lg font-semibold text-spa-dark mb-4">Doanh Thu Theo Phương Thức</h3>
                <canvas id="revenueByMethodChart" width="400" height="200"></canvas>
            </div>
        </div>

        <!-- Payment Method Trends -->
        <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6 mb-8">
            <h3 class="text-lg font-semibold text-spa-dark mb-4">Xu Hướng Phương Thức Thanh Toán Theo Thời Gian</h3>
            <canvas id="methodTrendsChart" width="800" height="300"></canvas>
        </div>

        <!-- Detailed Analysis Table -->
        <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
            <h3 class="text-lg font-semibold text-spa-dark mb-4">Phân Tích Chi Tiết</h3>
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Phương Thức
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Số Giao Dịch
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Tổng Doanh Thu
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Trung Bình/Giao Dịch
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Tỷ Lệ %
                            </th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <c:set var="totalTransactions" value="0" />
                        <c:forEach var="method" items="${paymentMethodCounts}">
                            <c:set var="totalTransactions" value="${totalTransactions + method.value}" />
                        </c:forEach>
                        
                        <c:forEach var="method" items="${paymentMethodCounts}">
                            <tr class="hover:bg-gray-50">
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <c:choose>
                                            <c:when test="${method.key == 'CASH'}">
                                                <i data-lucide="banknote" class="h-5 w-5 text-primary mr-3"></i>
                                                <span class="text-sm font-medium text-gray-900">Tiền mặt</span>
                                            </c:when>
                                            <c:when test="${method.key == 'CARD'}">
                                                <i data-lucide="credit-card" class="h-5 w-5 text-primary mr-3"></i>
                                                <span class="text-sm font-medium text-gray-900">Thẻ tín dụng</span>
                                            </c:when>
                                            <c:when test="${method.key == 'BANK_TRANSFER'}">
                                                <i data-lucide="building-2" class="h-5 w-5 text-primary mr-3"></i>
                                                <span class="text-sm font-medium text-gray-900">Chuyển khoản</span>
                                            </c:when>
                                            <c:otherwise>
                                                <i data-lucide="smartphone" class="h-5 w-5 text-primary mr-3"></i>
                                                <span class="text-sm font-medium text-gray-900">Ví điện tử</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                    ${method.value}
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                    <fmt:formatNumber value="${paymentMethodRevenue[method.key]}" type="currency" currencySymbol="₫" />
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                    <fmt:formatNumber value="${avgAmountByMethod[method.key]}" type="currency" currencySymbol="₫" />
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <c:set var="percentage" value="${(method.value * 100) / totalTransactions}" />
                                    <div class="flex items-center">
                                        <div class="w-16 bg-gray-200 rounded-full h-2 mr-2">
                                            <div class="bg-primary h-2 rounded-full" style="width: ${percentage}%"></div>
                                        </div>
                                        <span class="text-sm text-gray-900">
                                            <fmt:formatNumber value="${percentage}" maxFractionDigits="1" />%
                                        </span>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Include Footer -->
    <jsp:include page="../../common/footer.jsp" />

    <script>
        // Initialize Lucide icons
        lucide.createIcons();

        // Payment Method Distribution Chart
        const methodCtx = document.getElementById('paymentMethodChart').getContext('2d');
        new Chart(methodCtx, {
            type: 'pie',
            data: {
                labels: [<c:forEach var="method" items="${paymentMethodCounts}" varStatus="status">'${method.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
                datasets: [{
                    data: [<c:forEach var="method" items="${paymentMethodCounts}" varStatus="status">${method.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
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

        // Revenue by Payment Method Chart
        const revenueMethodCtx = document.getElementById('revenueByMethodChart').getContext('2d');
        new Chart(revenueMethodCtx, {
            type: 'bar',
            data: {
                labels: [<c:forEach var="method" items="${paymentMethodRevenue}" varStatus="status">'${method.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
                datasets: [{
                    label: 'Doanh Thu (₫)',
                    data: [<c:forEach var="method" items="${paymentMethodRevenue}" varStatus="status">${method.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
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

        // Method Trends Chart (placeholder - would need actual trend data)
        const trendsCtx = document.getElementById('methodTrendsChart').getContext('2d');
        new Chart(trendsCtx, {
            type: 'line',
            data: {
                labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6'],
                datasets: [
                    {
                        label: 'Tiền mặt',
                        data: [30, 35, 32, 28, 25, 22],
                        borderColor: '#D4AF37',
                        backgroundColor: 'rgba(212, 175, 55, 0.1)',
                        tension: 0.4
                    },
                    {
                        label: 'Thẻ tín dụng',
                        data: [25, 28, 30, 35, 38, 42],
                        borderColor: '#10B981',
                        backgroundColor: 'rgba(16, 185, 129, 0.1)',
                        tension: 0.4
                    },
                    {
                        label: 'Chuyển khoản',
                        data: [20, 22, 25, 28, 30, 28],
                        borderColor: '#3B82F6',
                        backgroundColor: 'rgba(59, 130, 246, 0.1)',
                        tension: 0.4
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Số giao dịch'
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
