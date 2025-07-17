<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống Kê Theo Thời Gian - Spa Hương Sen</title>
    
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
                        <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Thống Kê Theo Thời Gian</span>
                    </div>
                </li>
            </ol>
        </nav>

        <!-- Page Header -->
        <div class="mb-8">
            <h1 class="text-3xl font-bold text-spa-dark mb-2">Thống Kê Theo Thời Gian</h1>
            <p class="text-gray-600">Phân tích xu hướng giao dịch và doanh thu theo thời gian</p>
        </div>

        <!-- Peak Analysis Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Giờ Cao Điểm</p>
                        <p class="text-2xl font-bold text-spa-dark">${peakAnalysis.peakHour}:00</p>
                        <p class="text-sm text-gray-500">${peakAnalysis.peakHourTransactions} giao dịch</p>
                    </div>
                    <div class="p-3 bg-orange-100 rounded-full">
                        <i data-lucide="clock" class="h-6 w-6 text-orange-600"></i>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Ngày Cao Điểm</p>
                        <p class="text-2xl font-bold text-spa-dark">${peakAnalysis.peakDay}</p>
                        <p class="text-sm text-gray-500">${peakAnalysis.peakDayTransactions} giao dịch</p>
                    </div>
                    <div class="p-3 bg-blue-100 rounded-full">
                        <i data-lucide="calendar-days" class="h-6 w-6 text-blue-600"></i>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Tăng Trưởng Tháng</p>
                        <p class="text-2xl font-bold text-spa-dark">+${growthTrends.monthlyGrowth}%</p>
                        <p class="text-sm text-gray-500">so với tháng trước</p>
                    </div>
                    <div class="p-3 bg-green-100 rounded-full">
                        <i data-lucide="trending-up" class="h-6 w-6 text-green-600"></i>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-600">Tăng Trưởng Năm</p>
                        <p class="text-2xl font-bold text-spa-dark">+${growthTrends.yearlyGrowth}%</p>
                        <p class="text-sm text-gray-500">so với năm trước</p>
                    </div>
                    <div class="p-3 bg-purple-100 rounded-full">
                        <i data-lucide="bar-chart-3" class="h-6 w-6 text-purple-600"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Row 1 -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <!-- Daily Transactions -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <h3 class="text-lg font-semibold text-spa-dark mb-4">Giao Dịch Theo Ngày (30 ngày gần nhất)</h3>
                <canvas id="dailyTransactionsChart" width="400" height="200"></canvas>
            </div>

            <!-- Hourly Transactions -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <h3 class="text-lg font-semibold text-spa-dark mb-4">Giao Dịch Theo Giờ</h3>
                <canvas id="hourlyTransactionsChart" width="400" height="200"></canvas>
            </div>
        </div>

        <!-- Monthly Transactions Chart -->
        <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6 mb-8">
            <h3 class="text-lg font-semibold text-spa-dark mb-4">Xu Hướng Giao Dịch Theo Tháng</h3>
            <canvas id="monthlyTransactionsChart" width="800" height="300"></canvas>
        </div>

        <!-- Time Analysis Tables -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Peak Hours Analysis -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <h3 class="text-lg font-semibold text-spa-dark mb-4">Phân Tích Giờ Cao Điểm</h3>
                <div class="space-y-3">
                    <c:forEach var="hour" items="${hourlyTransactions}" varStatus="status" begin="0" end="4">
                        <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                            <div class="flex items-center">
                                <span class="w-8 h-8 bg-primary text-white rounded-full flex items-center justify-center text-sm font-bold mr-3">
                                    ${status.index + 1}
                                </span>
                                <div>
                                    <div class="font-medium text-gray-900">${hour.key}:00 - ${hour.key + 1}:00</div>
                                    <div class="text-sm text-gray-500">Khung giờ</div>
                                </div>
                            </div>
                            <div class="text-right">
                                <div class="font-semibold text-spa-dark">${hour.value}</div>
                                <div class="text-sm text-gray-500">giao dịch</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Weekly Pattern -->
            <div class="bg-white rounded-xl shadow-md border border-primary/10 p-6">
                <h3 class="text-lg font-semibold text-spa-dark mb-4">Mẫu Hình Theo Tuần</h3>
                <div class="space-y-3">
                    <c:set var="weekDays" value="Thứ 2,Thứ 3,Thứ 4,Thứ 5,Thứ 6,Thứ 7,Chủ nhật" />
                    <c:set var="weekData" value="45,52,48,55,62,38,28" />
                    <c:forTokens items="${weekDays}" delims="," var="day" varStatus="status">
                        <c:forTokens items="${weekData}" delims="," var="count" varStatus="dataStatus">
                            <c:if test="${status.index == dataStatus.index}">
                                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                                    <div class="flex items-center">
                                        <div class="w-3 h-3 bg-primary rounded-full mr-3"></div>
                                        <span class="font-medium text-gray-900">${day}</span>
                                    </div>
                                    <div class="flex items-center">
                                        <div class="w-20 bg-gray-200 rounded-full h-2 mr-3">
                                            <div class="bg-primary h-2 rounded-full" style="width: ${count}%"></div>
                                        </div>
                                        <span class="text-sm font-semibold text-spa-dark">${count}</span>
                                    </div>
                                </div>
                            </c:if>
                        </c:forTokens>
                    </c:forTokens>
                </div>
            </div>
        </div>
    </div>

    <!-- Include Footer -->
    <jsp:include page="../../common/footer.jsp" />

    <script>
        // Initialize Lucide icons
        lucide.createIcons();

        // Daily Transactions Chart
        const dailyCtx = document.getElementById('dailyTransactionsChart').getContext('2d');
        new Chart(dailyCtx, {
            type: 'line',
            data: {
                labels: [<c:forEach var="entry" items="${dailyTransactions}" varStatus="status">'${entry.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
                datasets: [{
                    label: 'Số giao dịch',
                    data: [<c:forEach var="entry" items="${dailyTransactions}" varStatus="status">${entry.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
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
                        beginAtZero: true
                    }
                }
            }
        });

        // Hourly Transactions Chart
        const hourlyCtx = document.getElementById('hourlyTransactionsChart').getContext('2d');
        new Chart(hourlyCtx, {
            type: 'bar',
            data: {
                labels: [<c:forEach var="entry" items="${hourlyTransactions}" varStatus="status">'${entry.key}h'<c:if test="${!status.last}">,</c:if></c:forEach>],
                datasets: [{
                    label: 'Số giao dịch',
                    data: [<c:forEach var="entry" items="${hourlyTransactions}" varStatus="status">${entry.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
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
                        beginAtZero: true
                    }
                }
            }
        });

        // Monthly Transactions Chart
        const monthlyCtx = document.getElementById('monthlyTransactionsChart').getContext('2d');
        new Chart(monthlyCtx, {
            type: 'line',
            data: {
                labels: [<c:forEach var="entry" items="${monthlyTransactions}" varStatus="status">'${entry.key}'<c:if test="${!status.last}">,</c:if></c:forEach>],
                datasets: [{
                    label: 'Số giao dịch',
                    data: [<c:forEach var="entry" items="${monthlyTransactions}" varStatus="status">${entry.value}<c:if test="${!status.last}">,</c:if></c:forEach>],
                    borderColor: '#D4AF37',
                    backgroundColor: 'rgba(212, 175, 55, 0.1)',
                    tension: 0.4,
                    fill: true,
                    pointBackgroundColor: '#D4AF37',
                    pointBorderColor: '#B8941F',
                    pointRadius: 5
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
                        title: {
                            display: true,
                            text: 'Số giao dịch'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: 'Tháng'
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
