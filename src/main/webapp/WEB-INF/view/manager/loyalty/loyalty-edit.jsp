<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cộng/Trừ điểm thưởng cho khách hàng</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <%-- Thêm Tailwind config để đồng bộ theme màu sắc và font chữ --%>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: "#D4AF37", // A rich gold color
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
</head>

<body class="bg-spa-cream font-sans">
<div class="flex">
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
    <main class="flex-1 py-12 lg:py-20 lg:ml-64">
        <div class="max-w-xl mx-auto px-4 sm:px-6 lg:px-8">
            <%-- Thay đổi màu heading cho nhất quán với trang chính --%>
            <h1 class="text-3xl font-serif text-spa-dark font-bold mb-8 text-center">Cộng/Trừ điểm thưởng</h1>
            
            <div class="bg-white rounded-2xl shadow-lg p-8 max-w-lg mx-auto">
                <c:if test="${not empty customer}">
                    <div class="mb-6 flex items-center gap-4">
                        <div class="h-14 w-14 flex-shrink-0 bg-primary/10 rounded-full flex items-center justify-center">
                            <i data-lucide="user" class="w-7 h-7 text-primary"></i>
                        </div>
                        <div>
                            <div class="text-lg font-semibold text-gray-900">${customer.fullName}</div>
                            <div class="text-sm text-gray-500">${customer.email}</div>
                            <div class="text-sm text-gray-500">Điểm hiện tại: <span class="font-bold text-primary"><fmt:formatNumber value="${customer.loyaltyPoints}" type="number"/></span> | Hạng: <span class="font-bold">${customer.tier}</span></div>
                        </div>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/manager/loyalty-points/edit" method="post" class="space-y-6">
                    <input type="hidden" name="customerId" value="${customer.customerId}" />
                    <div>
                        <label for="points" class="block mb-2 font-semibold text-spa-dark">Số điểm (+ để cộng, - để trừ):</label>
                        <%-- Cập nhật style cho input để đồng bộ và đẹp hơn --%>
                        <input type="number" id="points" name="points" class="h-11 w-full border border-gray-300 rounded-lg px-4 focus:ring-2 focus:ring-primary focus:border-primary transition" required placeholder="Ví dụ: 100 hoặc -50" />
                    </div>
                    <div>
                        <label for="note" class="block mb-2 font-semibold text-spa-dark">Ghi chú (lý do):</label>
                        <input type="text" id="note" name="note" class="h-11 w-full border border-gray-300 rounded-lg px-4 focus:ring-2 focus:ring-primary focus:border-primary transition" placeholder="Ví dụ: Thưởng thêm, trừ do vi phạm..." />
                    </div>
                    <div class="flex gap-4 pt-4">
                        <%-- Cập nhật style nút "Lưu" --%>
                        <button type="submit" class="w-full h-11 flex items-center justify-center gap-2 px-6 bg-primary text-white rounded-lg hover:bg-primary-dark font-semibold shadow transition-colors">
                            <i data-lucide="save" class="w-5 h-5"></i> Lưu thay đổi
                        </button>
                        <%-- Cập nhật style nút "Quay lại" để rõ ràng, chuyên nghiệp hơn --%>
                        <a href="${pageContext.request.contextPath}/manager/loyalty-points" class="w-full h-11 flex items-center justify-center gap-2 px-6 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 font-semibold shadow transition-colors">
                            <i data-lucide="arrow-left" class="w-5 h-5"></i> Quay lại
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
<script>lucide.createIcons();</script>
</body>
</html>