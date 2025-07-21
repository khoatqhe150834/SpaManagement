<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết phiếu xuất</title>
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
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />
</head>
<body class="bg-spa-cream font-sans">

<jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

<main class="w-full md:w-[calc(100%-256px)] md:ml-64 min-h-screen transition-all">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 lg:py-20">
        <!-- Page Header -->
        <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
            <div>
                <h1 class="text-3xl font-serif text-spa-dark font-bold">Chi tiết phiếu xuất #${issue.inventoryIssueId}</h1>
                <nav class="text-sm text-gray-500 flex items-center space-x-2 mt-1">
                    <a href="${pageContext.request.contextPath}/dashboard" class="hover:text-primary">Dashboard</a>
                    <span>/</span>
                    <a href="${pageContext.request.contextPath}/admin/inventory/issue" class="hover:text-primary">Phiếu xuất</a>
                    <span>/</span>
                    <span>Chi tiết</span>
                </nav>
            </div>
            <div class="flex items-center gap-3">
                <a href="${pageContext.request.contextPath}/admin/inventory/issue"
                   class="inline-flex items-center gap-2 h-10 px-4 bg-gray-100 text-gray-700 font-semibold rounded-lg hover:bg-gray-200 transition-colors">
                    <i data-lucide="arrow-left" class="h-5 w-5"></i>
                    <span>Quay lại</span>
                </a>
                <button onclick="window.print()"
                        class="inline-flex items-center gap-2 h-10 px-4 bg-primary text-white font-semibold rounded-lg hover:bg-primary-dark transition-colors">
                    <i data-lucide="printer" class="h-5 w-5"></i>
                    <span>In phiếu</span>
                </button>
            </div>
        </div>

        <!-- Issue Information Card -->
        <div class="bg-white rounded-2xl shadow-lg mb-8">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-xl font-serif font-semibold text-spa-dark">Thông tin phiếu xuất</h2>
            </div>
            <div class="p-6">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Mã phiếu xuất</label>
                        <p class="text-lg font-semibold text-spa-dark">#${issue.inventoryIssueId}</p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Ngày xuất</label>
                        <p class="text-lg text-spa-dark">
                            <fmt:formatDate value="${issue.issueDate}" pattern="dd/MM/yyyy HH:mm" />
                        </p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Cuộc hẹn</label>
                        <p class="text-lg text-spa-dark">
                            <c:choose>
                                <c:when test="${not empty issue.bookingAppointmentId}">
                                    #${issue.bookingAppointmentId}
                                </c:when>
                                <c:otherwise>
                                    <span class="text-gray-500">Không có</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Người yêu cầu</label>
                        <p class="text-lg text-spa-dark">
                            <c:choose>
                                <c:when test="${not empty issue.requestedByUser}">
                                    ${issue.requestedByUser.fullName}
                                </c:when>
                                <c:otherwise>
                                    <span class="text-gray-500">Chưa xác định</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Người phê duyệt</label>
                        <p class="text-lg text-spa-dark">
                            <c:choose>
                                <c:when test="${not empty issue.approvedByUser}">
                                    ${issue.approvedByUser.fullName}
                                </c:when>
                                <c:otherwise>
                                    <span class="text-gray-500">Chưa phê duyệt</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Trạng thái</label>
                        <div class="mt-1">
                            <c:choose>
                                <c:when test="${issue.status == 'APPROVED'}">
                                    <span class="inline-block px-3 py-1 text-sm font-semibold text-green-700 bg-green-100 rounded-full">Đã phê duyệt</span>
                                </c:when>
                                <c:when test="${issue.status == 'PENDING'}">
                                    <span class="inline-block px-3 py-1 text-sm font-semibold text-yellow-800 bg-yellow-100 rounded-full">Chờ phê duyệt</span>
                                </c:when>
                                <c:when test="${issue.status == 'REJECTED'}">
                                    <span class="inline-block px-3 py-1 text-sm font-semibold text-red-700 bg-red-100 rounded-full">Từ chối</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="inline-block px-3 py-1 text-sm font-semibold text-gray-700 bg-gray-100 rounded-full">${issue.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <c:if test="${not empty issue.note}">
                    <div class="mt-6">
                        <label class="block text-sm font-medium text-gray-700 mb-2">Ghi chú</label>
                        <div class="bg-gray-50 rounded-lg p-4">
                            <p class="text-spa-dark">${issue.note}</p>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Issue Details Card -->
        <div class="bg-white rounded-2xl shadow-lg">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-xl font-serif font-semibold text-spa-dark">Chi tiết vật tư xuất</h2>
            </div>
            <div class="p-6">
                <c:choose>
                    <c:when test="${not empty issueDetails}">
                        <div class="overflow-x-auto">
                            <table class="w-full text-sm text-left text-gray-500">
                                <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3">STT</th>
                                    <th scope="col" class="px-6 py-3">Mã vật tư</th>
                                    <th scope="col" class="px-6 py-3">Số lượng</th>
                                    <th scope="col" class="px-6 py-3">Ghi chú</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="detail" items="${issueDetails}" varStatus="status">
                                    <tr class="bg-white border-b hover:bg-gray-50">
                                        <td class="px-6 py-4 font-medium text-gray-900">${status.index + 1}</td>
                                        <td class="px-6 py-4 font-medium text-gray-900">#${detail.inventoryItemId}</td>
                                        <td class="px-6 py-4">
                        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800">
                                ${detail.quantity}
                        </span>
                                        </td>
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${not empty detail.note}">
                                                    ${detail.note}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400 italic">Không có ghi chú</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <!-- Summary -->
                        <div class="mt-6 bg-gray-50 rounded-lg p-4">
                            <div class="flex justify-between items-center">
                                <span class="text-sm font-medium text-gray-700">Tổng số loại vật tư:</span>
                                <span class="text-lg font-semibold text-spa-dark">${fn:length(issueDetails)} loại</span>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12">
                            <i data-lucide="package-x" class="h-16 w-16 text-gray-300 mx-auto mb-4"></i>
                            <h3 class="text-lg font-medium text-gray-900 mb-2">Không có chi tiết vật tư</h3>
                            <p class="text-gray-500">Phiếu xuất này chưa có thông tin chi tiết về vật tư được xuất.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Timestamps -->
        <c:if test="${not empty issue.createdAt or not empty issue.updatedAt}">
            <div class="mt-6 bg-white rounded-2xl shadow-lg p-6">
                <h3 class="text-lg font-serif font-semibold text-spa-dark mb-4">Thông tin thời gian</h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm text-gray-600">
                    <c:if test="${not empty issue.createdAt}">
                        <div>
                            <span class="font-medium">Ngày tạo:</span>
                            <fmt:formatDate value="${issue.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                        </div>
                    </c:if>
                    <c:if test="${not empty issue.updatedAt}">
                        <div>
                            <span class="font-medium">Cập nhật lần cuối:</span>
                            <fmt:formatDate value="${issue.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                        </div>
                    </c:if>
                </div>
            </div>
        </c:if>
    </div>
</main>

<script>
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
</script>

</body>
</html>