<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử đổi điểm - BeautyZone Spa</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-spa-cream font-sans">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    <div class="flex">
        <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />
        <main class="flex-1 py-12 lg:py-20 ml-64">
            <div class="max-w-3xl mx-auto bg-white rounded-2xl shadow-lg p-8">
                <h1 class="text-2xl font-serif font-bold text-spa-dark mb-6">Lịch sử đổi điểm</h1>
                <div class="overflow-x-auto">
                    <table class="min-w-full bg-white rounded-lg">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Thời gian</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Số điểm đã dùng</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Mã giảm giá</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Trạng thái</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Ghi chú</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                            <c:forEach var="item" items="${redemptionHistory}">
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                        <fmt:formatDate value="${item.redeemedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${item.pointsUsed}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${item.rewardValue}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm">
                                        <c:choose>
                                            <c:when test="${item.status eq 'SUCCESS'}">
                                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">Thành công</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">${item.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${item.note}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty redemptionHistory}">
                                <tr>
                                    <td colspan="5" class="px-6 py-4 text-center text-gray-500">Chưa có lịch sử đổi điểm nào.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                <div class="mt-6 text-center">
                    <a href="${pageContext.request.contextPath}/redeem" class="text-primary hover:underline">Quay lại trang đổi điểm</a>
                </div>
            </div>
        </main>
    </div>
</body>
</html> 