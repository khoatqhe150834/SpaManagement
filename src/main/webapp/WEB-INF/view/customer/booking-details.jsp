<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${pageTitle} - Spa Hương Sen</title>

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

    <!-- Custom CSS -->
    <link rel="stylesheet" href="/spa/css/style.css" />

    <style>
        .detail-card {
            background: linear-gradient(135deg, #ffffff 0%, #f9fafb 100%);
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: 600;
        }
        
        .status-scheduled { background-color: #dbeafe; color: #1e40af; }
        .status-confirmed { background-color: #dcfce7; color: #166534; }
        .status-completed { background-color: #f3f4f6; color: #374151; }
        .status-cancelled { background-color: #fee2e2; color: #dc2626; }
        .status-in-progress { background-color: #fef3c7; color: #d97706; }
    </style>
</head>

<body class="bg-spa-cream">
    <!-- Include Header -->
    <jsp:include page="../common/header.jsp" />

    <main class="container mx-auto px-4 py-8 mt-20">
        <!-- DEBUG: Check if booking object exists -->
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
            <strong>DEBUG INFO:</strong><br/>
            Current URL: ${pageContext.request.requestURL}?${pageContext.request.queryString}<br/>
            Booking ID parameter: ${param.id}<br/>
            Booking object exists: <c:choose><c:when test="${booking != null}">✅ YES</c:when><c:otherwise>❌ NO - This is the problem!</c:otherwise></c:choose><br/>
            <c:if test="${booking != null}">
                Booking ID: ${booking.bookingId}<br/>
                Customer ID: ${booking.customerId}<br/>
                Service ID: ${booking.serviceId}<br/>
                Status: ${booking.bookingStatus}<br/>
                Service Name: ${booking.serviceName}<br/>
            </c:if>
            <c:if test="${booking == null}">
                <strong>ERROR:</strong> The booking object is null. Check:<br/>
                1. Is the URL correct? Should be: /customer/bookings/details?id=56<br/>
                2. Is the customer logged in?<br/>
                3. Does the booking belong to the logged-in customer?<br/>
                4. Check the controller logs for errors<br/>
                5. Try this URL: <a href="/customer/bookings/details?id=56" class="underline text-blue-600">/customer/bookings/details?id=56</a><br/>
            </c:if>
        </div>

        <!-- Page Header -->
        <div class="mb-8">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between">
                <div>
                    <h1 class="text-3xl font-bold text-spa-dark mb-2 flex items-center gap-3">
                        <i data-lucide="calendar-check" class="h-8 w-8 text-primary"></i>
                        Chi tiết đặt lịch #${booking.bookingId}
                    </h1>
                    <p class="text-gray-600">Thông tin chi tiết về lịch hẹn của bạn</p>
                </div>
                <div class="mt-4 sm:mt-0 flex gap-3">
                    <a href="${pageContext.request.contextPath}/customer/bookings" 
                       class="inline-flex items-center px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
                        <i data-lucide="arrow-left" class="h-4 w-4 mr-2"></i>
                        Quay lại
                    </a>
                    
                    <c:if test="${booking.bookingStatus == 'SCHEDULED' || booking.bookingStatus == 'CONFIRMED'}">
                        <button onclick="cancelBooking(${booking.bookingId})" 
                                class="inline-flex items-center px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors">
                            <i data-lucide="x-circle" class="h-4 w-4 mr-2"></i>
                            Hủy lịch hẹn
                        </button>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Booking Details -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Main Details -->
            <div class="lg:col-span-2 space-y-6">
                <!-- Service Information - Only show for active bookings -->
                <c:if test="${booking.bookingStatus == 'SCHEDULED' || booking.bookingStatus == 'CONFIRMED' || booking.bookingStatus == 'IN_PROGRESS'}">
                    <div class="detail-card p-6">
                        <h2 class="text-xl font-semibold text-spa-dark mb-4 flex items-center gap-2">
                            <i data-lucide="scissors" class="h-5 w-5 text-primary"></i>
                            Thông tin dịch vụ
                        </h2>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-medium text-gray-500 mb-1">Tên dịch vụ</label>
                                <p class="text-lg font-semibold text-spa-dark">
                                    ${booking.serviceName != null ? booking.serviceName : 'Dịch vụ không xác định'}
                                </p>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-500 mb-1">Thời gian thực hiện</label>
                                <p class="text-lg font-semibold text-spa-dark flex items-center gap-2">
                                    <i data-lucide="clock" class="h-4 w-4 text-primary"></i>
                                    ${booking.durationMinutes != null ? booking.durationMinutes : 0} phút
                                </p>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Appointment Information -->
                <div class="detail-card p-6">
                    <h2 class="text-xl font-semibold text-spa-dark mb-4 flex items-center gap-2">
                        <i data-lucide="calendar" class="h-5 w-5 text-primary"></i>
                        Thông tin lịch hẹn
                    </h2>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-medium text-gray-500 mb-1">Ngày hẹn</label>
                            <p class="text-lg font-semibold text-spa-dark">
                                <fmt:formatDate value="${booking.appointmentDate}" pattern="EEEE, dd/MM/yyyy" />
                            </p>
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-500 mb-1">Giờ hẹn</label>
                            <p class="text-lg font-semibold text-spa-dark">
                                <fmt:formatDate value="${booking.appointmentTime}" pattern="HH:mm" />
                            </p>
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-500 mb-1">Nhân viên phụ trách</label>
                            <p class="text-lg font-semibold text-spa-dark flex items-center gap-2">
                                <i data-lucide="user" class="h-4 w-4 text-primary"></i>
                                ${booking.therapistName != null ? booking.therapistName : 'Chưa phân công'}
                            </p>
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-500 mb-1">Phòng</label>
                            <p class="text-lg font-semibold text-spa-dark flex items-center gap-2">
                                <i data-lucide="map-pin" class="h-4 w-4 text-primary"></i>
                                <c:choose>
                                    <c:when test="${booking.roomId != null}">
                                        Phòng ${booking.roomId}
                                        <c:if test="${booking.bedId != null}"> - Giường ${booking.bedId}</c:if>
                                    </c:when>
                                    <c:otherwise>
                                        Chưa phân phòng
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Notes -->
                <c:if test="${booking.bookingNotes != null && !empty booking.bookingNotes}">
                    <div class="detail-card p-6">
                        <h2 class="text-xl font-semibold text-spa-dark mb-4 flex items-center gap-2">
                            <i data-lucide="message-circle" class="h-5 w-5 text-primary"></i>
                            Ghi chú
                        </h2>
                        <p class="text-gray-700 leading-relaxed">${booking.bookingNotes}</p>
                    </div>
                </c:if>

                <!-- Cancellation Information -->
                <c:if test="${booking.bookingStatus == 'CANCELLED'}">
                    <div class="detail-card p-6 border-red-200 bg-red-50">
                        <h2 class="text-xl font-semibold text-red-800 mb-4 flex items-center gap-2">
                            <i data-lucide="x-circle" class="h-5 w-5 text-red-600"></i>
                            Thông tin hủy lịch
                        </h2>
                        
                        <div class="space-y-3">
                            <c:if test="${booking.cancelledAt != null}">
                                <div>
                                    <label class="block text-sm font-medium text-red-600 mb-1">Thời gian hủy</label>
                                    <p class="text-red-800">
                                        <fmt:formatDate value="${booking.cancelledAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </p>
                                </div>
                            </c:if>
                            
                            <c:if test="${booking.cancellationReason != null && !empty booking.cancellationReason}">
                                <div>
                                    <label class="block text-sm font-medium text-red-600 mb-1">Lý do hủy</label>
                                    <p class="text-red-800">${booking.cancellationReason}</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- Status & Actions Sidebar -->
            <div class="space-y-6">
                <!-- Status Card -->
                <div class="detail-card p-6">
                    <h3 class="text-lg font-semibold text-spa-dark mb-4">Trạng thái</h3>
                    <div class="text-center">
                        <span class="status-badge status-${booking.bookingStatus.toString().toLowerCase().replace('_', '-')}">
                            <c:choose>
                                <c:when test="${booking.bookingStatus == 'SCHEDULED'}">Đã lên lịch</c:when>
                                <c:when test="${booking.bookingStatus == 'CONFIRMED'}">Đã xác nhận</c:when>
                                <c:when test="${booking.bookingStatus == 'IN_PROGRESS'}">Đang thực hiện</c:when>
                                <c:when test="${booking.bookingStatus == 'COMPLETED'}">Hoàn thành</c:when>
                                <c:when test="${booking.bookingStatus == 'CANCELLED'}">Đã hủy</c:when>
                                <c:otherwise>${booking.bookingStatus}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <!-- Booking Information -->
                <div class="detail-card p-6">
                    <h3 class="text-lg font-semibold text-spa-dark mb-4">Thông tin đặt lịch</h3>
                    <div class="space-y-3">
                        <div>
                            <label class="block text-sm font-medium text-gray-500 mb-1">Mã đặt lịch</label>
                            <p class="font-mono text-primary font-semibold">#${booking.bookingId}</p>
                        </div>
                        
                        <c:if test="${booking.createdAt != null}">
                            <div>
                                <label class="block text-sm font-medium text-gray-500 mb-1">Ngày đặt</label>
                                <p class="text-sm text-gray-700">
                                    <fmt:formatDate value="${booking.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </p>
                            </div>
                        </c:if>
                        
                        <c:if test="${booking.updatedAt != null}">
                            <div>
                                <label class="block text-sm font-medium text-gray-500 mb-1">Cập nhật lần cuối</label>
                                <p class="text-sm text-gray-700">
                                    <fmt:formatDate value="${booking.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                                </p>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="detail-card p-6">
                    <h3 class="text-lg font-semibold text-spa-dark mb-4">Thao tác nhanh</h3>
                    <div class="space-y-3">
                        <a href="${pageContext.request.contextPath}/customer/bookings" 
                           class="w-full inline-flex items-center justify-center px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
                            <i data-lucide="list" class="h-4 w-4 mr-2"></i>
                            Xem tất cả lịch hẹn
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/services" 
                           class="w-full inline-flex items-center justify-center px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors">
                            <i data-lucide="plus" class="h-4 w-4 mr-2"></i>
                            Đặt dịch vụ mới
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/customer-dashboard" 
                           class="w-full inline-flex items-center justify-center px-4 py-2 bg-blue-100 text-blue-700 rounded-lg hover:bg-blue-200 transition-colors">
                            <i data-lucide="home" class="h-4 w-4 mr-2"></i>
                            Về Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Include Footer -->
    <jsp:include page="../common/footer.jsp" />

    <script>
        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }

        // Cancel booking function
        function cancelBooking(bookingId) {
            if (!confirm('Bạn có chắc chắn muốn hủy lịch hẹn này không?')) {
                return;
            }
            
            const reason = prompt('Vui lòng nhập lý do hủy lịch (tùy chọn):');
            
            // Send cancellation request
            fetch('${pageContext.request.contextPath}/customer/cancel-booking/' + bookingId + '?reason=' + encodeURIComponent(reason || ''), {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message || 'Đã hủy lịch hẹn thành công');
                    location.reload(); // Reload to show updated status
                } else {
                    alert(data.message || 'Không thể hủy lịch hẹn');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Lỗi kết nối. Vui lòng thử lại sau.');
            });
        }
    </script>
</body>
</html>
