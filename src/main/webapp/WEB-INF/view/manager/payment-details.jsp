<%-- 
    Document   : payment-details
    Created on : Dec 17, 2024
    Author     : G1_SpaManagement Team
    Description: Manager payment details page
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%-- Authorization Check: Only Manager and Admin can access this page --%>
<%
    String userType = (String) session.getAttribute("userType");
    if (userType == null || (!userType.equals("MANAGER") && !userType.equals("ADMIN"))) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Manager or Admin privileges required.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chi Tiết Thanh Toán #${payment.paymentId} - Spa Hương Sen</title>

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
              "spa-gray": "#F3F4F6",
            },
            fontFamily: {
              sans: ["Roboto", "sans-serif"],
            },
          },
        },
      };
    </script>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>
    
    <style>
        .payment-header {
            background: linear-gradient(135deg, #D4AF37 0%, #B8941F 100%);
            color: white;
            border-radius: 8px;
            padding: 2rem;
            margin-bottom: 2rem;
        }
        
        .status-badge {
            font-size: 0.875rem;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 600;
        }
        
        .status-paid { background-color: #dcfce7; color: #166534; }
        .status-pending { background-color: #fef3c7; color: #92400e; }
        .status-failed { background-color: #fee2e2; color: #dc2626; }
        .status-refunded { background-color: #e0e7ff; color: #3730a3; }
        
        .info-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            margin-bottom: 1.5rem;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #374151;
        }
        
        .info-value {
            color: #6b7280;
        }
        
        .amount-highlight {
            font-size: 1.25rem;
            font-weight: 700;
            color: #059669;
        }
        
        .service-item {
            background: #f9fafb;
            border-radius: 6px;
            padding: 1rem;
            margin-bottom: 0.75rem;
            border-left: 4px solid #D4AF37;
        }
    </style>
</head>
<body class="bg-spa-cream font-sans text-spa-dark">

    <!-- Include Sidebar -->
    <jsp:include page="/WEB-INF/view/common/sidebar.jsp" />

    <main class="w-full md:w-[calc(100%-256px)] md:ml-64 bg-white min-h-screen transition-all main">
        <!-- Modern Navbar -->
        <div class="h-16 px-6 bg-spa-cream flex items-center shadow-sm border-b border-primary/10 sticky top-0 left-0 z-30">
            <button type="button" class="text-lg text-spa-dark font-semibold sidebar-toggle hover:text-primary transition-colors duration-200 hidden">
                <i class="ri-menu-line"></i>
            </button>

            <ul class="ml-auto flex items-center">
                <li class="dropdown ml-3">
                    <button type="button" class="dropdown-toggle flex items-center hover:bg-primary/10 rounded-lg p-2 transition-all duration-200">
                        <div class="flex-shrink-0 w-10 h-10 relative">
                            <div class="p-1 bg-white rounded-full focus:outline-none focus:ring-2 focus:ring-primary/20">
                                <img class="w-8 h-8 rounded-full object-cover" src="https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=100" alt="Manager Avatar"/>
                                <div class="top-0 left-7 absolute w-3 h-3 bg-green-400 border-2 border-white rounded-full animate-ping"></div>
                                <div class="top-0 left-7 absolute w-3 h-3 bg-green-500 border-2 border-white rounded-full"></div>
                            </div>
                        </div>
                        <div class="p-2 md:block text-left">
                            <h2 class="text-sm font-semibold text-spa-dark">${sessionScope.user.fullName}</h2>
                            <p class="text-xs text-primary/70">Quản lý</p>
                        </div>
                    </button>
                    <ul class="dropdown-menu shadow-lg shadow-black/10 z-30 hidden py-2 rounded-lg bg-white border border-primary/20 w-full max-w-[160px]">
                        <li>
                            <a href="${pageContext.request.contextPath}/profile" class="flex items-center text-sm py-2 px-4 text-spa-dark hover:text-primary hover:bg-spa-cream transition-all duration-200">
                                <i data-lucide="user" class="h-4 w-4 mr-2"></i>
                                Hồ sơ
                            </a>
                        </li>
                        <li class="border-t border-primary/10 mt-1 pt-1">
                            <a href="${pageContext.request.contextPath}/logout" class="flex items-center text-sm py-2 px-4 text-red-600 hover:bg-red-50 cursor-pointer transition-all duration-200">
                                <i data-lucide="log-out" class="h-4 w-4 mr-2"></i>
                                Đăng xuất
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>

        <!-- Content -->
        <div class="p-6 bg-spa-cream min-h-screen">

            <!-- Breadcrumb -->
            <div class="mb-6">
                <nav class="flex" aria-label="Breadcrumb">
                    <ol class="inline-flex items-center space-x-1 md:space-x-3">
                        <li class="inline-flex items-center">
                            <a href="${pageContext.request.contextPath}/dashboard" class="inline-flex items-center text-sm font-medium text-spa-dark hover:text-primary">
                                <i data-lucide="home" class="h-4 w-4 mr-2"></i>
                                Dashboard
                            </a>
                        </li>
                        <li>
                            <div class="flex items-center">
                                <i data-lucide="chevron-right" class="h-4 w-4 text-gray-400"></i>
                                <a href="${pageContext.request.contextPath}/manager/payments-management" class="ml-1 text-sm font-medium text-spa-dark hover:text-primary md:ml-2">
                                    Quản Lý Thanh Toán
                                </a>
                            </div>
                        </li>
                        <li aria-current="page">
                            <div class="flex items-center">
                                <i data-lucide="chevron-right" class="h-4 w-4 text-gray-400"></i>
                                <span class="ml-1 text-sm font-medium text-gray-500 md:ml-2">Chi Tiết #${payment.paymentId}</span>
                            </div>
                        </li>
                    </ol>
                </nav>
            </div>

            <!-- Payment Header -->
            <div class="payment-header">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h3 class="mb-2">Thanh Toán #${payment.paymentId}</h3>
                        <p class="mb-0 opacity-75">
                            <c:if test="${not empty payment.referenceNumber}">
                                Mã tham chiếu: ${payment.referenceNumber}
                            </c:if>
                        </p>
                    </div>
                    <div class="col-md-4 text-end">
                        <span class="status-badge 
                            <c:choose>
                                <c:when test="${payment.paymentStatus == 'PAID'}">status-paid</c:when>
                                <c:when test="${payment.paymentStatus == 'PENDING'}">status-pending</c:when>
                                <c:when test="${payment.paymentStatus == 'FAILED'}">status-failed</c:when>
                                <c:when test="${payment.paymentStatus == 'REFUNDED'}">status-refunded</c:when>
                                <c:otherwise>status-pending</c:otherwise>
                            </c:choose>">
                            <c:choose>
                                <c:when test="${payment.paymentStatus == 'PAID'}">Đã thanh toán</c:when>
                                <c:when test="${payment.paymentStatus == 'PENDING'}">Chờ thanh toán</c:when>
                                <c:when test="${payment.paymentStatus == 'FAILED'}">Thất bại</c:when>
                                <c:when test="${payment.paymentStatus == 'REFUNDED'}">Đã hoàn tiền</c:when>
                                <c:otherwise>${payment.paymentStatus}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </div>

            <div class="row">
                <!-- Customer Information -->
                <div class="col-md-6">
                    <div class="info-card">
                        <h5 class="mb-3">
                            <iconify-icon icon="solar:user-outline" class="me-2"></iconify-icon>
                            Thông Tin Khách Hàng
                        </h5>
                        <div class="info-row">
                            <span class="info-label">Họ tên:</span>
                            <span class="info-value">${payment.customer.fullName}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Email:</span>
                            <span class="info-value">${payment.customer.email}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Số điện thoại:</span>
                            <span class="info-value">${payment.customer.phoneNumber}</span>
                        </div>
                    </div>
                </div>

                <!-- Payment Information -->
                <div class="col-md-6">
                    <div class="info-card">
                        <h5 class="mb-3">
                            <iconify-icon icon="solar:credit-card-outline" class="me-2"></iconify-icon>
                            Thông Tin Thanh Toán
                        </h5>
                        <div class="info-row">
                            <span class="info-label">Ngày thanh toán:</span>
                            <span class="info-value">
                                <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Phương thức:</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${payment.paymentMethod == 'BANK_TRANSFER'}">Chuyển khoản</c:when>
                                    <c:when test="${payment.paymentMethod == 'CREDIT_CARD'}">Thẻ tín dụng</c:when>
                                    <c:when test="${payment.paymentMethod == 'VNPAY'}">VNPay</c:when>
                                    <c:when test="${payment.paymentMethod == 'MOMO'}">MoMo</c:when>
                                    <c:when test="${payment.paymentMethod == 'ZALOPAY'}">ZaloPay</c:when>
                                    <c:when test="${payment.paymentMethod == 'CASH'}">Tiền mặt</c:when>
                                    <c:otherwise>${payment.paymentMethod}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Ngày giao dịch:</span>
                            <span class="info-value">
                                <fmt:formatDate value="${payment.transactionDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Payment Amount Details -->
            <div class="info-card">
                <h5 class="mb-3">
                    <iconify-icon icon="solar:calculator-outline" class="me-2"></iconify-icon>
                    Chi Tiết Số Tiền
                </h5>
                <div class="row">
                    <div class="col-md-4">
                        <div class="info-row">
                            <span class="info-label">Tạm tính:</span>
                            <span class="info-value">
                                <fmt:formatNumber value="${payment.subtotalAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                            </span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="info-row">
                            <span class="info-label">Thuế:</span>
                            <span class="info-value">
                                <fmt:formatNumber value="${payment.taxAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                            </span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="info-row">
                            <span class="info-label">Tổng cộng:</span>
                            <span class="info-value amount-highlight">
                                <fmt:formatNumber value="${payment.totalAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Payment Items -->
            <div class="info-card">
                <h5 class="mb-3">
                    <iconify-icon icon="solar:list-outline" class="me-2"></iconify-icon>
                    Dịch Vụ Đã Thanh Toán
                </h5>
                <c:choose>
                    <c:when test="${not empty payment.paymentItems}">
                        <c:forEach var="item" items="${payment.paymentItems}">
                            <div class="service-item">
                                <div class="row align-items-center">
                                    <div class="col-md-6">
                                        <h6 class="mb-1">${item.service.serviceName}</h6>
                                        <small class="text-muted">
                                            Thời gian: ${item.serviceDuration} phút
                                        </small>
                                    </div>
                                    <div class="col-md-2 text-center">
                                        <span class="fw-semibold">SL: ${item.quantity}</span>
                                    </div>
                                    <div class="col-md-2 text-center">
                                        <span class="text-muted">
                                            <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                        </span>
                                    </div>
                                    <div class="col-md-2 text-end">
                                        <span class="fw-bold text-success">
                                            <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                        </span>
                                    </div>
                                </div>
                                
                                <!-- Usage Information -->
                                <c:if test="${not empty item.usage}">
                                    <div class="mt-2 pt-2 border-top">
                                        <small class="text-info">
                                            <iconify-icon icon="solar:info-circle-outline" class="me-1"></iconify-icon>
                                            Đã sử dụng: ${item.usage.usedQuantity}/${item.quantity} lần
                                            <c:if test="${not empty item.usage.lastUsedDate}">
                                                - Lần cuối: <fmt:formatDate value="${item.usage.lastUsedDate}" pattern="dd/MM/yyyy"/>
                                            </c:if>
                                        </small>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-3 text-muted">
                            <iconify-icon icon="solar:inbox-outline" style="font-size: 2rem;"></iconify-icon>
                            <p class="mt-2">Không có thông tin dịch vụ</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Notes -->
            <c:if test="${not empty payment.notes}">
                <div class="info-card">
                    <h5 class="mb-3">
                        <iconify-icon icon="solar:note-outline" class="me-2"></iconify-icon>
                        Ghi Chú
                    </h5>
                    <p class="mb-0">${payment.notes}</p>
                </div>
            </c:if>

            <!-- Action Buttons -->
            <div class="flex gap-3 justify-end">
                <a href="${pageContext.request.contextPath}/manager/payments-management" class="inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors duration-200">
                    <i data-lucide="arrow-left" class="h-4 w-4 mr-2"></i>
                    Quay lại
                </a>

                <c:if test="${payment.paymentStatus == 'PENDING'}">
                    <button onclick="editPayment(${payment.paymentId})" class="inline-flex items-center px-4 py-2 text-sm font-medium text-yellow-700 bg-yellow-100 border border-yellow-300 rounded-lg hover:bg-yellow-200 transition-colors duration-200">
                        <i data-lucide="edit" class="h-4 w-4 mr-2"></i>
                        Chỉnh sửa
                    </button>
                </c:if>

                <c:if test="${payment.paymentStatus == 'PAID'}">
                    <button onclick="refundPayment(${payment.paymentId})" class="inline-flex items-center px-4 py-2 text-sm font-medium text-red-700 bg-red-100 border border-red-300 rounded-lg hover:bg-red-200 transition-colors duration-200">
                        <i data-lucide="rotate-ccw" class="h-4 w-4 mr-2"></i>
                        Hoàn tiền
                    </button>
                </c:if>

                <button onclick="printReceipt(${payment.paymentId})" class="inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-primary border border-primary rounded-lg hover:bg-primary-dark transition-colors duration-200">
                    <i data-lucide="printer" class="h-4 w-4 mr-2"></i>
                    In hóa đơn
                </button>
            </div>
        </div>
    </main>

    <script>
        // Initialize Lucide icons
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }

        function editPayment(paymentId) {
            if (confirm('Bạn có chắc chắn muốn chỉnh sửa thanh toán #' + paymentId + '?')) {
                // TODO: Implement edit functionality
                alert('Chức năng chỉnh sửa thanh toán đang được phát triển.');
            }
        }

        function refundPayment(paymentId) {
            if (confirm('Bạn có chắc chắn muốn hoàn tiền cho thanh toán #' + paymentId + '? Hành động này không thể hoàn tác.')) {
                // TODO: Implement refund functionality
                alert('Chức năng hoàn tiền đang được phát triển.');
            }
        }

        function printReceipt(paymentId) {
            // TODO: Implement print receipt functionality
            alert('Chức năng in hóa đơn đang được phát triển.');
        }
    </script>
</body>
</html>
