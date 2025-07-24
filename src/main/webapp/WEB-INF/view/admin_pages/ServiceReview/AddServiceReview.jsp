<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh Giá Dịch Vụ</title>
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
              sans: ["Roboto", "sans-serif"],
            },
          },
        },
      };
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
</head>
<body class="bg-spa-cream font-sans min-h-screen">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="mb-8 flex items-center justify-between">
                    <h1 class="text-2xl font-bold text-spa-dark">Đánh Giá Dịch Vụ</h1>
                    <a href="${pageContext.request.contextPath}/customer/booking-history"
                       class="inline-flex items-center gap-2 h-10 px-4 bg-gray-200 text-spa-dark font-semibold rounded-lg hover:bg-gray-300 transition-colors">
                        <i data-lucide="arrow-left" class="w-5 h-5"></i>
                        <span>Quay lại</span>
                    </a>
                </div>
                <!-- Thông tin booking -->
                <div class="bg-white rounded-xl shadow-md p-6 mb-8">
                    <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2">
                        <i data-lucide="info" class="h-5 w-5"></i> Thông tin lịch hẹn
                    </h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <div class="text-gray-500 text-sm">Dịch vụ</div>
                            <div class="font-medium text-spa-dark">${booking.service.name}</div>
                        </div>
                        <div>
                            <div class="text-gray-500 text-sm">Kỹ thuật viên</div>
                            <div class="font-medium text-spa-dark">${booking.therapist.fullName}</div>
                        </div>
                        <div>
                            <div class="text-gray-500 text-sm">Ngày hẹn</div>
                            <div class="font-medium text-spa-dark"><fmt:formatDate value="${booking.appointmentDate}" pattern="dd/MM/yyyy"/></div>
                        </div>
                        <div>
                            <div class="text-gray-500 text-sm">Giờ hẹn</div>
                            <div class="font-medium text-spa-dark"><fmt:formatDate value="${booking.appointmentTime}" pattern="HH:mm"/></div>
                        </div>
                        <div>
                            <div class="text-gray-500 text-sm">Trạng thái</div>
                            <span class="inline-block px-3 py-1 rounded-full text-xs font-semibold
                                <c:choose>
                                    <c:when test="${booking.bookingStatus == 'COMPLETED'}">bg-green-100 text-green-700</c:when>
                                    <c:when test="${booking.bookingStatus == 'SCHEDULED'}">bg-blue-100 text-blue-700</c:when>
                                    <c:when test="${booking.bookingStatus == 'CANCELLED'}">bg-red-100 text-red-700</c:when>
                                    <c:otherwise>bg-gray-100 text-gray-700</c:otherwise>
                                </c:choose>">
                                <c:choose>
                                    <c:when test="${booking.bookingStatus == 'COMPLETED'}">Đã hoàn thành</c:when>
                                    <c:when test="${booking.bookingStatus == 'SCHEDULED'}">Đã lên lịch</c:when>
                                    <c:when test="${booking.bookingStatus == 'CANCELLED'}">Đã hủy</c:when>
                                    <c:otherwise>${booking.bookingStatus}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div>
                            <div class="text-gray-500 text-sm">Ghi chú</div>
                            <div class="font-medium text-spa-dark">${booking.bookingNotes}</div>
                        </div>
                    </div>
                </div>
                <!-- Form đánh giá -->
                <form action="${pageContext.request.contextPath}/customer/service-review/add" method="post" class="bg-white rounded-2xl shadow-lg p-8 space-y-6">
                    <input type="hidden" name="bookingId" value="${booking.bookingId}" />
                    <input type="hidden" name="serviceId" value="${booking.service.serviceId}" />
                    <input type="hidden" name="therapistUserId" value="${booking.therapist.userId}" />
                    <h2 class="text-lg font-semibold text-primary mb-4 flex items-center gap-2">
                        <i data-lucide="star" class="h-5 w-5"></i> Đánh giá dịch vụ
                    </h2>
                    <div class="grid grid-cols-1 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-spa-dark mb-2">Số sao</label>
                            <select name="rating" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary">
                                <option value="">Chọn số sao</option>
                                <option value="5" <c:if test="${review != null && review.rating == 5}">selected</c:if>>5 - Xuất sắc</option>
                                <option value="4" <c:if test="${review != null && review.rating == 4}">selected</c:if>>4 - Tốt</option>
                                <option value="3" <c:if test="${review != null && review.rating == 3}">selected</c:if>>3 - Bình thường</option>
                                <option value="2" <c:if test="${review != null && review.rating == 2}">selected</c:if>>2 - Trung bình</option>
                                <option value="1" <c:if test="${review != null && review.rating == 1}">selected</c:if>>1 - Kém</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-spa-dark mb-2">Tiêu đề</label>
                            <input type="text" name="title" maxlength="100" placeholder="Nhập tiêu đề đánh giá" class="block w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-primary" value="<c:out value='${review != null ? review.title : ""}'/>" />
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-spa-dark mb-2">Nội dung</label>
                            <textarea name="comment" rows="4" maxlength="500" placeholder="Nhập nội dung đánh giá..." class="block w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-primary"><c:out value='${review != null ? review.comment : ""}'/></textarea>
                            <small class="text-gray-400">Tối đa 500 ký tự. Bạn có thể bỏ qua nếu không muốn đánh giá.</small>
                        </div>
                    </div>
                    <div class="flex items-center justify-end gap-4 mt-6">
                        <a href="${pageContext.request.contextPath}/customer/booking-history"
                           class="inline-flex items-center justify-center px-6 py-2 border border-gray-300 rounded-lg text-gray-700 bg-gray-100 hover:bg-gray-200 font-semibold">Quay lại</a>
                        <button type="submit" class="inline-flex items-center justify-center px-6 py-2 rounded-lg bg-primary text-white font-semibold hover:bg-primary-dark transition-colors">
                            <c:choose>
                                <c:when test="${review != null}">Cập nhật đánh giá</c:when>
                                <c:otherwise>Lưu đánh giá</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    <script>
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }
    </script>
</body>
</html> 