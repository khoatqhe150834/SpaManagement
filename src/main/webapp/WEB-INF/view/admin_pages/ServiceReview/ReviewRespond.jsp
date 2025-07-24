<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phản Hồi Đánh Giá Dịch Vụ</title>
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
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>
<body class="bg-spa-cream font-sans min-h-screen">
<jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
<main class="w-full md:w-[calc(100%-256px)] md:ml-64 bg-spa-cream min-h-screen transition-all main">
    <jsp:include page="/WEB-INF/view/admin_pages/Common/Header.jsp" />
    <div class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="mb-8 flex items-center justify-between">
            <h1 class="text-2xl font-serif text-spa-dark font-bold">Phản Hồi Đánh Giá Dịch Vụ</h1>
            <a href="${pageContext.request.contextPath}/manager/service-review" class="inline-flex items-center gap-2 h-10 px-4 bg-gray-200 text-spa-dark font-semibold rounded-lg hover:bg-gray-300 transition-colors">
                <i data-lucide="arrow-left" class="w-5 h-5"></i>
                <span>Quay lại</span>
            </a>
        </div>
        <form action="${pageContext.request.contextPath}/manager/service-review" method="post" class="bg-white rounded-2xl shadow-lg p-8 space-y-6">
            <input type="hidden" name="action" value="reply" />
            <input type="hidden" name="reviewId" value="${review.reviewId}" />
            <!-- Thông tin review -->
            <div class="grid grid-cols-1 gap-4">
                <div>
                    <label class="block text-sm font-medium text-spa-dark mb-1">Dịch vụ</label>
                    <div class="bg-gray-50 rounded px-4 py-2">${review.serviceName}</div>
                </div>
                <div>
                    <label class="block text-sm font-medium text-spa-dark mb-1">Khách hàng</label>
                    <div class="bg-gray-50 rounded px-4 py-2">${review.customerName}</div>
                </div>
                <div>
                    <label class="block text-sm font-medium text-spa-dark mb-1">Rating</label>
                    <div class="flex items-center gap-1 bg-gray-50 rounded px-4 py-2">
                        <span class="text-yellow-500 font-medium flex items-center">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 20 20" class="w-4 h-4 inline"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.967a1 1 0 00.95.69h4.175c.969 0 1.371 1.24.588 1.81l-3.38 2.455a1 1 0 00-.364 1.118l1.287 3.966c.3.922-.755 1.688-1.54 1.118l-3.38-2.455a1 1 0 00-1.176 0l-3.38 2.455c-.784.57-1.838-.196-1.54-1.118l1.287-3.966a1 1 0 00-.364-1.118L2.05 9.394c-.783-.57-.38-1.81.588-1.81h4.175a1 1 0 00.95-.69l1.286-3.967z"/></svg>
                            ${review.rating}
                        </span>
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-medium text-spa-dark mb-1">Tiêu đề</label>
                    <div class="bg-gray-50 rounded px-4 py-2">${review.title}</div>
                </div>
                <div>
                    <label class="block text-sm font-medium text-spa-dark mb-1">Nội dung</label>
                    <div class="bg-gray-50 rounded px-4 py-2">${review.comment}</div>
                </div>
                <div>
                    <label class="block text-sm font-medium text-spa-dark mb-1">Ngày tạo</label>
                    <div class="bg-gray-50 rounded px-4 py-2"><fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy"/></div>
                </div>
            </div>
            <!-- Phản hồi quản lý -->
            <div>
                <label for="managerReply" class="block text-sm font-medium text-spa-dark mb-1">Phản hồi của quản lý</label>
                <textarea id="managerReply" name="managerReply" rows="4" maxlength="500" class="block w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-primary" placeholder="Bạn có thể để trống nếu không muốn phản hồi">${review.managerReply}</textarea>
                <div class="flex justify-between items-center mt-1">
                    <small class="text-gray-400 ml-auto" id="replyCharCount">0/500</small>
                </div>
            </div>
            <!-- Action Buttons -->
            <div class="flex items-center justify-center gap-4 mt-6">
                <a href="${pageContext.request.contextPath}/manager/service-review" class="inline-flex items-center justify-center px-6 py-2 border border-gray-300 rounded-lg text-gray-700 bg-gray-100 hover:bg-gray-200 font-semibold">Hủy</a>
                <button type="submit" class="inline-flex items-center justify-center px-6 py-2 rounded-lg bg-primary text-white font-semibold hover:bg-primary-dark transition-colors">Lưu</button>
            </div>
        </form>
    </div>
</main>
<jsp:include page="/WEB-INF/view/common/footer.jsp" />
<script>
    window.addEventListener('DOMContentLoaded', () => {
        if (window.lucide) window.lucide.createIcons();
        // Đếm ký tự phản hồi
        const reply = document.getElementById('managerReply');
        const counter = document.getElementById('replyCharCount');
        if (reply && counter) {
            const updateCount = () => {
                const len = reply.value.length;
                counter.textContent = len + '/500';
                if (len > 400) counter.style.color = '#f59e0b';
                else counter.style.color = '#6b7280';
            };
            reply.addEventListener('input', updateCount);
            updateCount();
        }
    });
</script>
</body>
</html> 