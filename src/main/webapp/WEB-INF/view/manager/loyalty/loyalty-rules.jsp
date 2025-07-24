<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quy tắc quy đổi điểm thưởng</title>
    
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
    
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
</head>

<body class="bg-spa-cream font-sans">
<div class="flex">
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
    <main class="flex-1 py-12 lg:py-20 lg:ml-64">
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between mb-8">
                 <h1 class="text-3xl font-serif text-spa-dark font-bold">Quy tắc quy đổi điểm</h1>
            </div>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded-lg" role="alert">
                    <p>${sessionScope.successMessage}</p>
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-lg" role="alert">
                    <p>${sessionScope.errorMessage}</p>
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>
            
            <div class="bg-white rounded-2xl shadow-lg">
                <div class="overflow-x-auto">
                    <table class="min-w-full bg-white">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Số tiền / 1 điểm (VND)</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Hiệu lực</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Ghi chú</th>
                                <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Hành động</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                            <c:forEach var="rule" items="${rules}">
                                <tr class="align-middle">
                                    <form method="post" action="${pageContext.request.contextPath}/manager/loyalty-points/rules">
                                        <input type="hidden" name="ruleId" value="${rule.ruleId}" />
                                        <td class="px-6 py-4 font-medium text-gray-700">${rule.ruleId}</td>
                                        <td class="px-6 py-4">
                                            <%-- SỬA 1: Hiện đại hóa ô input số tiền --%>
                                            <input type="number" name="moneyPerPoint" 
                                                   value="<fmt:formatNumber value="${rule.moneyPerPoint}" groupingUsed="false" />" 
                                                   min="1000" step="1000" 
                                                   class="h-10 w-full border border-gray-300 rounded-lg px-3 focus:ring-2 focus:ring-primary focus:border-primary transition" required />
                                        </td>
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${rule.isActive}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">Đang áp dụng</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-200 text-gray-800">Không hiệu lực</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4">
                                            <%-- SỬA 2: Hiện đại hóa ô input ghi chú --%>
                                            <input type="text" name="note" value="${rule.note}" 
                                                   class="h-10 w-full border border-gray-300 rounded-lg px-3 focus:ring-2 focus:ring-primary focus:border-primary transition" />
                                        </td>
                                        <td class="px-6 py-4 text-center">
                                            <%-- SỬA 3: Đồng bộ nút "Lưu" với icon --%>
                                            <button type="submit" class="h-10 inline-flex items-center justify-center gap-2 px-4 bg-primary text-white rounded-lg hover:bg-primary-dark font-semibold shadow-sm transition-colors">
                                                <i data-lucide="save" class="w-4 h-4"></i>
                                                <span>Lưu</span>
                                            </button>
                                        </td>
                                    </form>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty rules}">
                                <tr><td colspan="5" class="text-center text-gray-500 py-8">Chưa có quy tắc nào được thiết lập.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                 <div class="p-6 border-t border-gray-200 flex justify-end">
                    <%-- SỬA 4: Đồng bộ nút "Quay lại" --%>
                    <a href="${pageContext.request.contextPath}/manager/loyalty-points" class="h-11 flex items-center justify-center gap-2 px-6 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 font-semibold shadow-sm transition-colors">
                        <i data-lucide="arrow-left" class="w-5 h-5"></i> Quay lại
                    </a>
                </div>
            </div>
        </div>
    </main>
</div>
<%-- THÊM 2: Khởi tạo Lucide Icons --%>
<script>lucide.createIcons();</script>
</body>
</html>