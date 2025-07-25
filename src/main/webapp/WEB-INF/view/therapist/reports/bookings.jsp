<%-- bookings.jsp: Thống kê số booking đã thực hiện --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/admin/images/favicon.png" sizes="16x16">
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              primary: "#D4AF37",
              "primary-dark": "#B8941F",
              secondary: "#FADADD",
              "spa-cream": "#FFF8F0",
              "spa-dark": "#333333",
            },
            fontFamily: {
              serif: ["Playfair Display", "serif"],
              sans: ["Roboto", "sans-serif"],
            },
          },
        },
      };
    </script>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <!-- Iconify -->
    <script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
</head>
<body class="bg-spa-cream font-sans min-h-screen">
    <div class="flex min-h-screen">
        <!-- Sidebar -->
        <div class="hidden md:block w-64 flex-shrink-0 h-full">
            <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        </div>
        <!-- Main dashboard content -->
        <main class="flex-1 flex flex-col bg-spa-cream">
            <div class="w-full mx-auto px-4 sm:px-6 lg:px-8 mt-8">
                <!-- Page Header -->
                <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
                    <h1 class="text-3xl font-serif text-spa-dark font-bold">Thống kê số booking đã thực hiện</h1>
                    <nav class="text-base text-gray-500 flex items-center gap-2">
                        <a href="${pageContext.request.contextPath}/manager-dashboard" class="hover:text-primary flex items-center gap-1"><iconify-icon icon="solar:home-smile-angle-outline" class="text-lg"></iconify-icon>Dashboard</a>
                        <span>/</span>
                        <a href="${pageContext.request.contextPath}/manager/staff-statistics/bookings" class="hover:text-primary">Thống kê nhân viên</a>
                        <span>/</span>
                        <span class="text-primary font-semibold">Booking</span>
                    </nav>
                </div>
                <!-- Stat cards row (5 card chính) -->
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-5 gap-6 mb-6">
                    <!-- Tổng số booking -->
                    <div class="bg-white border border-gray-100 rounded-2xl shadow-lg flex flex-col items-center p-6">
                        <iconify-icon icon="solar:calendar-check-bold" class="text-primary text-3xl mb-2"></iconify-icon>
                        <div class="text-3xl font-bold text-primary">${totalBookings}</div>
                        <div class="text-gray-600 mt-1 text-sm">Tổng số booking đã thực hiện</div>
                    </div>
                    <!-- Booking tháng này -->
                    <div class="bg-white border border-gray-100 rounded-2xl shadow-lg flex flex-col items-center p-6">
                        <iconify-icon icon="solar:calendar-bold" class="text-green-500 text-3xl mb-2"></iconify-icon>
                        <div class="text-3xl font-bold text-green-700">${monthlyBookings}</div>
                        <div class="text-gray-600 mt-1 text-sm">Booking trong tháng này</div>
                    </div>
                    <!-- Tổng khách hàng -->
                    <div class="bg-white border border-gray-100 rounded-2xl shadow-lg flex flex-col items-center p-6">
                        <iconify-icon icon="solar:users-group-rounded-bold" class="text-yellow-500 text-3xl mb-2"></iconify-icon>
                        <div class="text-3xl font-bold text-yellow-700">${totalCustomers}</div>
                        <div class="text-gray-600 mt-1 text-sm">Khách hàng đã phục vụ</div>
                    </div>
                    <!-- Tổng dịch vụ -->
                    <div class="bg-white border border-gray-100 rounded-2xl shadow-lg flex flex-col items-center p-6">
                        <iconify-icon icon="solar:star-bold" class="text-pink-500 text-3xl mb-2"></iconify-icon>
                        <div class="text-3xl font-bold text-pink-700">${totalServices}</div>
                        <div class="text-gray-600 mt-1 text-sm">Dịch vụ đã thực hiện</div>
                    </div>
                    <!-- Tổng doanh thu -->
                    <div class="bg-white border border-gray-100 rounded-2xl shadow-lg flex flex-col items-center p-6">
                        <iconify-icon icon="solar:wallet-bold" class="text-blue-500 text-3xl mb-2"></iconify-icon>
                        <div class="text-3xl font-bold text-blue-700">${totalRevenue}</div>
                        <div class="text-gray-600 mt-1 text-sm">Tổng doanh thu (VND)</div>
                    </div>
                </div>
                <!-- Stat cards row phụ (4 card phụ) -->
                <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-6 mb-8">
                    <!-- Booking chờ xử lý -->
                    <div class="bg-white border border-gray-100 rounded-2xl shadow flex flex-col items-center p-4">
                        <iconify-icon icon="solar:clock-bold" class="text-primary text-2xl mb-1"></iconify-icon>
                        <div class="text-xl font-bold text-primary">${pendingBookings}</div>
                        <div class="text-gray-600 text-xs">Đang chờ xử lý</div>
                    </div>
                    <!-- Booking bị hủy tháng này -->
                    <div class="bg-white border border-gray-100 rounded-2xl shadow flex flex-col items-center p-4">
                        <iconify-icon icon="solar:close-circle-bold" class="text-red-500 text-2xl mb-1"></iconify-icon>
                        <div class="text-xl font-bold text-red-600">${cancelledBookingsThisMonth}</div>
                        <div class="text-gray-600 text-xs">Bị hủy trong tháng</div>
                    </div>
                    <!-- Booking no-show -->
                    <div class="bg-white border border-gray-100 rounded-2xl shadow flex flex-col items-center p-4">
                        <iconify-icon icon="solar:user-x-bold" class="text-gray-500 text-2xl mb-1"></iconify-icon>
                        <div class="text-xl font-bold text-gray-700">${noShowBookings}</div>
                        <div class="text-gray-600 text-xs">Khách không đến</div>
                    </div>
                    <!-- Ngày cao điểm -->
                    <div class="bg-white border border-gray-100 rounded-2xl shadow flex flex-col items-center p-4">
                        <iconify-icon icon="solar:calendar-bold" class="text-green-500 text-2xl mb-1"></iconify-icon>
                        <div class="text-base font-bold text-green-700">${peakBookingDay}</div>
                        <div class="text-gray-600 text-xs">Ngày nhiều booking nhất</div>
                    </div>
                </div>
                <!-- Bảng tổng hợp therapist + highlight top/bottom -->
                <div class="bg-white rounded-2xl shadow-lg p-6 mb-8">
                    <h2 class="text-xl font-bold text-spa-dark mb-4">Bảng tổng hợp booking của tất cả nhân viên</h2>
                    <div class="overflow-x-auto">
                        <table class="min-w-full text-sm text-left">
                            <thead class="bg-gray-50 text-gray-700 uppercase">
                                <tr>
                                    <th class="px-4 py-3">#</th>
                                    <th class="px-4 py-3">Nhân viên</th>
                                    <th class="px-4 py-3">Chuyên môn</th>
                                    <th class="px-4 py-3 text-center">Tổng booking</th>
                                    <th class="px-4 py-3 text-center">Booking tháng này</th>
                                    <th class="px-4 py-3 text-center">Khách hàng</th>
                                    <th class="px-4 py-3 text-center">Dịch vụ</th>
                                    <th class="px-4 py-3 text-center">Top/Bottom</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="allZero" value="true" />
                                <c:forEach var="t" items="${therapistsStatsList}">
                                    <c:if test="${t.totalBookings > 0}">
                                        <c:set var="allZero" value="false" />
                                    </c:if>
                                </c:forEach>
                                <c:choose>
                                    <c:when test="${empty therapistsStatsList || allZero}">
                                        <tr>
                                            <td colspan="8" style="text-align:center; color: #888;">Không có dữ liệu</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="t" items="${therapistsStatsList}" varStatus="loop">
                                            <tr class="border-b hover:bg-gray-50">
                                                <td class="px-4 py-3">${loop.index + 1}</td>
                                                <td class="px-4 py-3 flex items-center gap-2">
                                                    <img src="${t.avatarUrl != null ? t.avatarUrl : pageContext.request.contextPath + '/assets/admin/images/avatar-default.png'}" class="w-9 h-9 rounded-full border object-cover" alt="avatar"/>
                                                    <span class="font-semibold text-spa-dark">${t.fullName}</span>
                                                </td>
                                                <td class="px-4 py-3">${t.serviceTypeName}</td>
                                                <td class="px-4 py-3 text-center font-bold text-primary">${t.totalBookings}</td>
                                                <td class="px-4 py-3 text-center text-green-700 font-semibold">${t.monthlyBookings}</td>
                                                <td class="px-4 py-3 text-center">${t.totalCustomers}</td>
                                                <td class="px-4 py-3 text-center">${t.totalServices}</td>
                                                <td class="px-4 py-3 text-center">
                                                    <c:choose>
                                                        <c:when test="${t.therapistId == topStaffId}">
                                                            <span class="inline-flex items-center px-2 py-1 bg-green-100 text-green-700 rounded text-xs font-bold">Top</span>
                                                        </c:when>
                                                        <c:when test="${t.therapistId == bottomStaffId}">
                                                            <span class="inline-flex items-center px-2 py-1 bg-red-100 text-red-700 rounded text-xs font-bold">Bottom</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-gray-400 text-xs">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- Box phụ: Top khách hàng quay lại nhiều nhất, tỷ lệ booking online/offline, booking theo loại dịch vụ, booking theo ca -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                    <!-- Top khách hàng quay lại nhiều nhất -->
                    <div class="bg-white rounded-2xl shadow-lg p-6 flex flex-col items-center">
                        <h3 class="text-lg font-bold mb-2 text-primary">Khách hàng trung thành nhất</h3>
                        <c:choose>
                            <c:when test="${topReturningCustomerId == 0}">
                                <div class="text-gray-500">Không có dữ liệu</div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-2xl font-bold text-primary mb-1">ID: ${topReturningCustomerId}</div>
                                <div class="text-gray-600 text-sm">(Số lần booking nhiều nhất)</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <!-- Tỷ lệ booking online/offline -->
                    <div class="bg-white rounded-2xl shadow-lg p-6 flex flex-col items-center">
                        <h3 class="text-lg font-bold mb-2 text-blue-700">Tỷ lệ booking online</h3>
                        <div class="text-2xl font-bold text-blue-700 mb-1">
                            <c:out value="${onlineBookingRate * 100}" />%
                        </div>
                        <div class="text-gray-600 text-sm">(So với tổng booking)</div>
                    </div>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                    <!-- Tỷ lệ booking theo loại dịch vụ -->
                    <div class="bg-white rounded-2xl shadow-lg p-6 flex flex-col items-center">
                        <h3 class="text-lg font-bold mb-2 text-pink-700">Tỷ lệ booking theo loại dịch vụ</h3>
                        <table class="min-w-full text-xs">
                            <thead>
                                <tr class="text-gray-500">
                                    <th class="px-2 py-1">Loại dịch vụ</th>
                                    <th class="px-2 py-1">Số booking</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="row" items="${serviceTypeBookingRate}">
                                    <tr>
                                        <td class="px-2 py-1">${row[0]}</td>
                                        <td class="px-2 py-1 text-center">${row[1]}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- Booking theo ca làm việc -->
                    <div class="bg-white rounded-2xl shadow-lg p-6 flex flex-col items-center">
                        <h3 class="text-lg font-bold mb-2 text-yellow-700">Booking theo ca làm việc</h3>
                        <div class="flex flex-row gap-6">
                            <div class="flex flex-col items-center">
                                <span class="text-sm text-gray-500">Sáng</span>
                                <span class="text-xl font-bold text-yellow-700">${morningBookings}</span>
                            </div>
                            <div class="flex flex-col items-center">
                                <span class="text-sm text-gray-500">Chiều</span>
                                <span class="text-xl font-bold text-yellow-700">${afternoonBookings}</span>
                            </div>
                            <div class="flex flex-col items-center">
                                <span class="text-sm text-gray-500">Tối</span>
                                <span class="text-xl font-bold text-yellow-700">${eveningBookings}</span>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Card chi tiết + filter -->
                <div class="bg-white rounded-2xl shadow-lg p-8 flex flex-col items-center">
                    <div class="flex items-center gap-2 mb-4">
                        <iconify-icon icon="solar:user-id-bold" class="text-primary text-2xl"></iconify-icon>
                        <span class="text-gray-600">Therapist ID:</span>
                        <span class="font-semibold text-primary">${therapistId}</span>
                    </div>
                    <form method="get" class="flex flex-col sm:flex-row gap-2 items-center mt-4 w-full justify-center">
                        <label for="therapistId" class="text-gray-700 font-medium">Xem cho Therapist ID:</label>
                        <input type="number" min="1" name="therapistId" id="therapistId" value="${therapistId}" class="border border-gray-300 rounded px-3 py-2 w-32 focus:ring-2 focus:ring-primary focus:outline-none" />
                        <button type="submit" class="bg-primary text-white px-5 py-2 rounded font-semibold hover:bg-primary-dark transition flex items-center gap-1">
                            <iconify-icon icon="solar:search-bold" class="text-lg"></iconify-icon> Xem
                        </button>
                    </form>
                </div>
            </div>
        </main>
    </div>
    <script>if (window.lucide) lucide.createIcons();</script>
</body>
</html> 