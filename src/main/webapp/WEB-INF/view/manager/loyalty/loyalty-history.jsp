<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử cộng/trừ điểm thưởng</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <%-- THÊM 1: Cấu hình Tailwind để đồng bộ theme --%>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: "#D4AF37",
                        "primary-dark": "#B8941F",
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

    <%-- THÊM 2: Tải Google Fonts và Lucide Icons --%>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
</head>

<%-- THÊM 3: Áp dụng background và font chung --%>
<body class="bg-spa-cream font-sans">
    <%-- THÊM 4: Tích hợp vào layout chính với sidebar --%>
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="flex-1 py-12 lg:py-20 lg:ml-64">
            <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
                <%-- SỬA 1: Cập nhật màu tiêu đề cho nhất quán --%>
                <h1 class="text-3xl font-serif text-spa-dark font-bold mb-8 text-center">Lịch sử điểm thưởng</h1>
                
                <div class="bg-white rounded-2xl shadow-lg p-6 sm:p-8">
                    <c:if test="${not empty customer}">
                        <div class="mb-6 pb-6 border-b border-gray-200 flex items-center gap-4">
                            <div class="h-14 w-14 flex-shrink-0 bg-primary/10 rounded-full flex items-center justify-center">
                                <i data-lucide="user" class="w-7 h-7 text-primary"></i>
                            </div>
                            <div>
                                <div class="text-lg font-semibold text-gray-900">${customer.fullName}</div>
                                <div class="text-sm text-gray-500">${customer.email}</div>
                                <div class="text-sm text-gray-500 mt-1">
                                    Điểm hiện tại: <span class="font-bold text-primary"><fmt:formatNumber value="${customer.loyaltyPoints}" type="number"/></span> |
                                    Hạng: <span class="font-bold">${customer.tier}</span>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <div class="overflow-x-auto">
                        <table class="min-w-full bg-white">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Ngày</th>
                                    <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Thay đổi</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Ghi chú</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200">
                                <c:forEach var="item" items="${history}">
                                    <tr>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                                            <fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <%-- SỬA 2: Hiển thị điểm cộng/trừ với màu sắc để dễ phân biệt --%>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-semibold text-center">
                                            <c:choose>
                                                <c:when test="${item.points >= 0}">
                                                    <span class="text-green-600">+<fmt:formatNumber value="${item.points}" type="number"/></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-red-600"><fmt:formatNumber value="${item.points}" type="number"/></span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-800">${item.reason}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty history}">
                                    <tr><td colspan="3" class="text-center text-gray-500 py-8">Chưa có lịch sử giao dịch điểm nào.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <div class="mt-8 flex justify-center">
                        <%-- SỬA 3: Đồng bộ style nút "Quay lại" --%>
                        <a href="${pageContext.request.contextPath}/manager/loyalty-points" class="h-11 flex items-center justify-center gap-2 px-8 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 font-semibold shadow-sm transition-colors">
                            <i data-lucide="arrow-left" class="w-5 h-5"></i> Quay lại
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>

<script>
    // THÊM 5: Khởi tạo icons
    lucide.createIcons();
</script>
</body>
</html>