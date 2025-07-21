<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết phiếu nhập #${receipt.inventoryReceiptId}</title>
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
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12 lg:py-20">
        <!-- Header -->
        <div class="flex flex-wrap items-center justify-between gap-4 mb-8">
            <div>
                <h1 class="text-3xl font-serif text-spa-dark font-bold">Chi tiết phiếu nhập #${receipt.inventoryReceiptId}</h1>
                <nav class="text-sm text-gray-500 flex items-center space-x-2 mt-1">
                    <a href="${pageContext.request.contextPath}/dashboard" class="hover:text-primary">Dashboard</a>
                    <span>/</span>
                    <a href="../receipt" class="hover:text-primary">Phiếu nhập</a>
                    <span>/</span>
                    <span>Chi tiết</span>
                </nav>
            </div>
            <div class="flex gap-3">
                <a href="../receipt" class="inline-flex items-center gap-2 h-10 px-4 bg-gray-500 text-white font-semibold rounded-lg hover:bg-gray-600 transition-colors">
                    <i data-lucide="arrow-left" class="h-5 w-5"></i>
                    <span>Quay lại</span>
                </a>
            </div>
        </div>

        <!-- Receipt Info Card -->
        <div class="bg-white rounded-2xl shadow-lg mb-6">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                    <i data-lucide="file-text" class="h-6 w-6 text-primary"></i>
                    Thông tin phiếu nhập
                </h2>
            </div>
            <div class="p-6">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <!-- Receipt ID -->
                    <div class="space-y-2">
                        <label class="block text-sm font-medium text-gray-600">Mã phiếu nhập</label>
                        <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-lg">
                            <i data-lucide="hash" class="h-5 w-5 text-gray-400"></i>
                            <span class="font-semibold text-spa-dark">#${receipt.inventoryReceiptId}</span>
                        </div>
                    </div>

                    <!-- Receipt Date -->
                    <div class="space-y-2">
                        <label class="block text-sm font-medium text-gray-600">Ngày nhập</label>
                        <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-lg">
                            <i data-lucide="calendar" class="h-5 w-5 text-gray-400"></i>
                            <span class="font-semibold text-spa-dark">
                                    <fmt:formatDate value="${receipt.receiptDate}" pattern="dd/MM/yyyy" />
                                </span>
                        </div>
                    </div>

                    <!-- Supplier -->
                    <div class="space-y-2">
                        <label class="block text-sm font-medium text-gray-600">Nhà cung cấp</label>
                        <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-lg">
                            <i data-lucide="truck" class="h-5 w-5 text-gray-400"></i>
                            <span class="font-semibold text-spa-dark">ID: ${receipt.supplier.name}</span>
                        </div>
                    </div>

                    <!-- Created By -->
                    <div class="space-y-2">
                        <label class="block text-sm font-medium text-gray-600">Người tạo</label>
                        <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-lg">
                            <i data-lucide="user" class="h-5 w-5 text-gray-400"></i>
                            <span class="font-semibold text-spa-dark">ID: ${receipt.user.fullName}</span>
                        </div>
                    </div>

                    <!-- Created At -->
                    <div class="space-y-2">
                        <label class="block text-sm font-medium text-gray-600">Ngày tạo</label>
                        <div class="flex items-center gap-2 p-3 bg-gray-50 rounded-lg">
                            <i data-lucide="clock" class="h-5 w-5 text-gray-400"></i>
                            <span class="font-semibold text-spa-dark">
                                    <fmt:formatDate value="${receipt.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </span>
                        </div>
                    </div>

                </div>

                <!-- Note -->
                <c:if test="${not empty receipt.note}">
                    <div class="mt-6 space-y-2">
                        <label class="block text-sm font-medium text-gray-600">Ghi chú</label>
                        <div class="flex items-start gap-2 p-3 bg-gray-50 rounded-lg">
                            <i data-lucide="message-square" class="h-5 w-5 text-gray-400 mt-0.5"></i>
                            <span class="text-spa-dark">${receipt.note}</span>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Receipt Details Card -->
        <div class="bg-white rounded-2xl shadow-lg">
            <div class="p-6 border-b border-gray-200">
                <h2 class="text-xl font-semibold text-spa-dark flex items-center gap-2">
                    <i data-lucide="package" class="h-6 w-6 text-primary"></i>
                    Chi tiết phiếu nhập
                    <span class="ml-2 px-2 py-1 bg-primary text-white text-sm rounded-full">
                            ${receiptDetails.size()} mục
                        </span>
                </h2>
            </div>
            <div class="p-6">
                <c:choose>
                    <c:when test="${not empty receiptDetails}">
                        <div class="overflow-x-auto">
                            <table class="w-full text-sm">
                                <thead class="text-xs text-gray-700 uppercase bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left">STT</th>
                                    <th class="px-6 py-3 text-left">Vật tư</th>
                                    <th class="px-6 py-3 text-center">Số lượng</th>
                                    <th class="px-6 py-3 text-center">Đơn giá</th>
                                    <th class="px-6 py-3 text-center">Thành tiền</th>
                                    <th class="px-6 py-3 text-left">Ghi chú</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:set var="grandTotal" value="0" />
                                <c:forEach var="detail" items="${receiptDetails}" varStatus="status">
                                    <c:set var="lineTotal" value="${detail.quantity * detail.unitPrice}" />
                                    <c:set var="grandTotal" value="${grandTotal + lineTotal}" />
                                    <tr class="border-b hover:bg-gray-50">
                                        <td class="px-6 py-4 font-medium text-gray-900">${status.index + 1}</td>
                                        <td class="px-6 py-4">
                                            <div class="flex items-center gap-2">
                                                <i data-lucide="box" class="h-4 w-4 text-gray-400"></i>
                                                <span class="font-medium">ID: ${detail.inventoryItemId}</span>
                                            </div>
                                        </td>
                                        <td class="px-6 py-4 text-center font-medium">
                                            <fmt:formatNumber value="${detail.quantity}" pattern="#,##0" />
                                        </td>
                                        <td class="px-6 py-4 text-center font-medium">
                                            <fmt:formatNumber value="${detail.unitPrice}" pattern="#,##0.00" /> VNĐ
                                        </td>
                                        <td class="px-6 py-4 text-center font-bold text-primary">
                                            <fmt:formatNumber value="${lineTotal}" pattern="#,##0.00" /> VNĐ
                                        </td>
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${not empty detail.note}">
                                                    <span class="text-gray-700">${detail.note}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400 italic">Không có ghi chú</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                                <tfoot class="bg-primary text-white">
                                <tr>
                                    <td colspan="4" class="px-6 py-4 text-right font-bold text-lg">Tổng cộng:</td>
                                    <td class="px-6 py-4 text-center font-bold text-xl">
                                        <fmt:formatNumber value="${grandTotal}" pattern="#,##0.00" /> VNĐ
                                    </td>
                                    <td class="px-6 py-4"></td>
                                </tr>
                                </tfoot>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-12">
                            <div class="flex flex-col items-center gap-4">
                                <i data-lucide="package-x" class="h-16 w-16 text-gray-300"></i>
                                <div>
                                    <h3 class="text-lg font-medium text-gray-900">Không có chi tiết</h3>
                                    <p class="text-gray-500">Phiếu nhập này chưa có vật tư nào.</p>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Summary Card -->
        <c:if test="${not empty receiptDetails}">
            <div class="bg-gradient-to-r from-primary to-primary-dark rounded-2xl shadow-lg mt-6 text-white">
                <div class="p-6">
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 text-center">
                        <div>
                            <div class="text-2xl font-bold">${receiptDetails.size()}</div>
                            <div class="text-sm opacity-90">Loại vật tư</div>
                        </div>
                        <div>
                            <div class="text-2xl font-bold">
                                <c:set var="totalQuantity" value="0" />
                                <c:forEach var="detail" items="${receiptDetails}">
                                    <c:set var="totalQuantity" value="${totalQuantity + detail.quantity}" />
                                </c:forEach>
                                <fmt:formatNumber value="${totalQuantity}" pattern="#,##0" />
                            </div>
                            <div class="text-sm opacity-90">Tổng số lượng</div>
                        </div>
                        <div>
                            <div class="text-2xl font-bold">
                                <fmt:formatNumber value="${grandTotal}" pattern="#,##0" /> VNĐ
                            </div>
                            <div class="text-sm opacity-90">Tổng giá trị</div>
                        </div>
                    </div>
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