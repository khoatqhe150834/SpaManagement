<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${pageTitle != null ? pageTitle : 'Chi Tiết Thanh Toán - Spa Hương Sen'}</title>

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
    <link
      href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Roboto:wght@300;400;500;600&display=swap"
      rel="stylesheet"
    />

    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.js"></script>

    <!-- Custom CSS -->
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>" />

    <!-- Custom styles for animations -->
    <style>
      @keyframes fadeIn {
        from {
          opacity: 0;
          transform: translateY(20px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
      .animate-fadeIn {
        animation: fadeIn 0.6s ease-out forwards;
      }
      .line-clamp-2 {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }

      /* Payment specific styles */
      .status-badge {
        display: inline-flex;
        align-items: center;
        padding: 0.25rem 0.75rem;
        border-radius: 9999px;
        font-size: 0.875rem;
        font-weight: 500;
        text-transform: uppercase;
        letter-spacing: 0.025em;
      }

      .status-paid { background-color: #d1fae5; color: #065f46; }
      .status-pending { background-color: #fef3c7; color: #92400e; }
      .status-failed { background-color: #fee2e2; color: #991b1b; }
      .status-refunded { background-color: #e0e7ff; color: #3730a3; }

      .usage-progress {
        height: 8px;
        background-color: #e5e7eb;
        border-radius: 4px;
        overflow: hidden;
      }

      .usage-fill {
        height: 100%;
        background-color: #10b981;
        transition: width 0.3s ease;
      }
    </style>
</head>

<body class="bg-spa-cream">
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <!-- Main Content -->
    <main class="min-h-screen pt-20">
        <!-- Page Header -->
        <section class="bg-gradient-to-r from-primary to-primary-dark text-white py-16">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="text-center">
                    <h1 class="text-4xl md:text-5xl font-serif mb-4">Chi Tiết Thanh Toán #${payment.paymentId}</h1>
                    <div class="flex items-center justify-center gap-2 text-white/80">
                        <a href="${pageContext.request.contextPath}/" class="hover:text-white transition-colors">Trang chủ</a>
                        <i data-lucide="chevron-right" class="h-4 w-4"></i>
                        <a href="${pageContext.request.contextPath}/dashboard" class="hover:text-white transition-colors">Dashboard</a>
                        <i data-lucide="chevron-right" class="h-4 w-4"></i>
                        <a href="${pageContext.request.contextPath}/customer/payments" class="hover:text-white transition-colors">Lịch sử thanh toán</a>
                        <i data-lucide="chevron-right" class="h-4 w-4"></i>
                        <span>Chi tiết thanh toán</span>
                    </div>
                </div>

                <c:if test="${customer != null}">
                    <div class="mt-8 text-center">
                        <div class="inline-flex items-center bg-white/10 backdrop-blur-sm rounded-lg px-6 py-3">
                            <i data-lucide="user" class="h-5 w-5 mr-3"></i>
                            <div class="text-left">
                                <div class="font-semibold">${customer.fullName}</div>
                                <div class="text-sm text-white/80">${customer.email}</div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </section>

        <c:if test="${payment != null}">
            <!-- Payment Information -->
            <section class="py-8">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div class="bg-white rounded-xl shadow-lg overflow-hidden animate-fadeIn">
                        <div class="bg-gradient-to-r from-gray-50 to-gray-100 p-6 border-b border-gray-200">
                            <h2 class="text-2xl font-serif text-spa-dark flex items-center">
                                <i data-lucide="credit-card" class="h-6 w-6 mr-3 text-primary"></i>
                                Thông Tin Thanh Toán
                            </h2>
                        </div>
                        <div class="p-6">
                            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                <div>
                                    <div class="text-sm text-gray-600 mb-1">Mã thanh toán</div>
                                    <div class="font-semibold text-lg text-spa-dark">#${payment.paymentId}</div>
                                </div>

                                <div>
                                <div>
                                    <div class="text-sm text-gray-600 mb-1">Phương thức thanh toán</div>
                                    <div class="font-semibold text-lg text-spa-dark">
                                        <c:choose>
                                            <c:when test="${payment.paymentMethod == 'BANK_TRANSFER'}">Chuyển khoản ngân hàng</c:when>
                                            <c:when test="${payment.paymentMethod == 'CREDIT_CARD'}">Thẻ tín dụng</c:when>
                                            <c:when test="${payment.paymentMethod == 'VNPAY'}">VNPay</c:when>
                                            <c:when test="${payment.paymentMethod == 'MOMO'}">MoMo</c:when>
                                            <c:when test="${payment.paymentMethod == 'ZALOPAY'}">ZaloPay</c:when>
                                            <c:when test="${payment.paymentMethod == 'CASH'}">Tiền mặt</c:when>
                                            <c:otherwise>${payment.paymentMethod}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div>
                                    <div class="text-sm text-gray-600 mb-1">Trạng thái</div>
                                    <span class="status-badge
                                        <c:choose>
                                            <c:when test="${payment.paymentStatus == 'PAID'}">status-paid</c:when>
                                            <c:when test="${payment.paymentStatus == 'PENDING'}">status-pending</c:when>
                                            <c:when test="${payment.paymentStatus == 'FAILED'}">status-failed</c:when>
                                            <c:when test="${payment.paymentStatus == 'REFUNDED'}">status-refunded</c:when>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${payment.paymentStatus == 'PAID'}">Đã thanh toán</c:when>
                                            <c:when test="${payment.paymentStatus == 'PENDING'}">Chờ xử lý</c:when>
                                            <c:when test="${payment.paymentStatus == 'FAILED'}">Thất bại</c:when>
                                            <c:when test="${payment.paymentStatus == 'REFUNDED'}">Đã hoàn tiền</c:when>
                                            <c:otherwise>${payment.paymentStatus}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <div>
                                    <div class="text-sm text-gray-600 mb-1">Tổng tiền</div>
                                    <div class="font-bold text-2xl text-primary"><fmt:formatNumber value="${payment.totalAmount}" pattern="#,##0" /> VNĐ</div>
                                </div>
                                <div>
                                   <div class="text-sm text-gray-600 mb-1">Mã tham chiếu</div>
                                   <div class="font-semibold text-lg text-spa-dark">${payment.referenceNumber}</div>
                                </div>
                                 <div>
                                   <div class="text-sm text-gray-600 mb-1">Ngày thanh toán</div>
                                   <div class="font-semibold text-lg text-spa-dark">
                                       <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                   </div>
                                 </div>

                                
                                </div>
                            </div>

                            <c:if test="${not empty payment.notes}">
                                <div class="mt-6 p-4 bg-yellow-50 border-l-4 border-yellow-400 rounded">
                                    <div class="flex items-start">
                                        <i data-lucide="info" class="h-5 w-5 text-yellow-600 mr-2 mt-0.5"></i>
                                        <div>
                                            <div class="font-medium text-yellow-800 mb-1">Ghi chú:</div>
                                            <div class="text-yellow-700">${payment.notes}</div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Payment Items -->
            <c:if test="${paymentItems != null && not empty paymentItems}">
                <section class="pb-8">
                    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                        <div class="bg-white rounded-xl shadow-lg overflow-hidden animate-fadeIn">
                            <div class="bg-gradient-to-r from-gray-50 to-gray-100 p-6 border-b border-gray-200">
                                <h2 class="text-2xl font-serif text-spa-dark flex items-center">
                                    <i data-lucide="shopping-bag" class="h-6 w-6 mr-3 text-primary"></i>
                                    Dịch Vụ Đã Mua (${payment.paymentItems.size()} dịch vụ)
                                </h2>  
                            </div>
                            <div class="p-6">
                                <div class="space-y-6">
                                    <c:forEach var="item" items="${paymentItems}">
                                        <div class="border border-gray-200 rounded-lg p-6 hover:shadow-md transition-shadow">
                                            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                                                <!-- Service Info -->
                                                <div class="lg:col-span-2">
                                                    <h3 class="text-xl font-semibold text-spa-dark mb-2">
                                                        ${item.serviceName != null ? item.serviceName : 'Dịch vụ không xác định'}
                                                    </h3>
                                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm text-gray-600">
                                                        <div>
                                                            <span class="font-medium">Số lượng:</span> ${item.quantity}
                                                        </div>
                                                        <div>
                                                            <span class="font-medium">Đơn giá:</span>
                                                            <fmt:formatNumber value="${item.unitPrice}" type="currency"
                                                                            currencySymbol="" pattern="#,##0"/> VNĐ
                                                        </div>
                                                        <div>
                                                            <span class="font-medium">Thành tiền:</span>
                                                            <span class="font-semibold text-primary">
                                                                <fmt:formatNumber value="${item.totalPrice}" type="currency"
                                                                                currencySymbol="" pattern="#,##0"/> VNĐ
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Usage Info -->
                                                <div class="lg:col-span-1">
                                                    <div class="bg-gray-50 rounded-lg p-4">
                                                        <h4 class="font-medium text-spa-dark mb-3 flex items-center">
                                                            <i data-lucide="activity" class="h-4 w-4 mr-2 text-primary"></i>
                                                            Tình trạng sử dụng
                                                        </h4>
                                                        <c:choose>
                                                            <c:when test="${item.usage != null}">
                                                                <div class="space-y-3">
                                                                    <div class="flex justify-between text-sm">
                                                                        <span>Đã sử dụng:</span>
                                                                        <span class="font-medium">${item.usage.bookedQuantity}/${item.usage.totalQuantity}</span>
                                                                    </div>
                                                                    <div class="usage-progress">
                                                                        <div class="usage-fill" style="width: ${item.usage.totalQuantity > 0 ? (item.usage.bookedQuantity * 100 / item.usage.totalQuantity) : 0}%"></div>
                                                                    </div>
                                                                    <div class="flex justify-between text-sm">
                                                                        <span>Còn lại:</span>
                                                                        <span class="font-medium text-green-600">${item.usage.remainingQuantity}</span>
                                                                    </div>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="text-sm text-gray-500 text-center py-2">
                                                                    Chưa có thông tin sử dụng
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Payment Summary -->
                                <div class="mt-8 pt-6 border-t border-gray-200">
                                    <div class="flex justify-end">
                                        <div class="w-96">
                                            <div class="space-y-3">
                                                <div class="flex justify-between text-gray-600">
                                                    <span>Tạm tính:</span>
                                                    <span><fmt:formatNumber value="${payment.subtotalAmount}" type="currency"
                                                                          currencySymbol="" pattern="#,##0"/> VNĐ</span>
                                                </div>
                                                <div class="flex justify-between text-gray-600">
                                                    <span>Thuế VAT:</span>
                                                    <span><fmt:formatNumber value="${payment.taxAmount}" type="currency"
                                                                          currencySymbol="" pattern="#,##0"/> VNĐ</span>
                                                </div>
                                                <div class="flex justify-between font-bold text-xl text-primary border-t pt-3">
                                                    <span>Tổng cộng:</span>
                                                    <span><fmt:formatNumber value="${payment.totalAmount}" type="currency"
                                                                          currencySymbol="" pattern="#,##0"/> VNĐ</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </c:if>
        </c:if>

        <!-- No Payment Found -->
        <c:if test="${payment == null}">
            <section class="py-16">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div class="text-center">
                        <div class="mx-auto w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mb-6">
                            <i data-lucide="alert-circle" class="h-12 w-12 text-gray-400"></i>
                        </div>
                        <h3 class="text-xl font-semibold text-spa-dark mb-2">Không tìm thấy thông tin thanh toán</h3>
                        <p class="text-gray-600 mb-6">Thanh toán này không tồn tại hoặc bạn không có quyền truy cập.</p>
                        <a href="${pageContext.request.contextPath}/customer/payments"
                           class="inline-flex items-center px-6 py-3 bg-primary hover:bg-primary-dark text-white rounded-lg font-medium transition-colors duration-200">
                            <i data-lucide="arrow-left" class="h-5 w-5 mr-2"></i>
                            Quay lại lịch sử thanh toán
                        </a>
                    </div>
                </div>
            </section>
        </c:if>

        <!-- Action Buttons -->
        <c:if test="${payment != null}">
            <section class="pb-16">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div class="flex justify-center gap-4">
                        <a href="${pageContext.request.contextPath}/customer/payments"
                           class="inline-flex items-center px-6 py-3 bg-gray-500 hover:bg-gray-600 text-white rounded-lg font-medium transition-colors duration-200">
                            <i data-lucide="arrow-left" class="h-5 w-5 mr-2"></i>
                            Quay lại
                        </a>
                        <button onclick="window.print()"
                                class="inline-flex items-center px-6 py-3 bg-primary hover:bg-primary-dark text-white rounded-lg font-medium transition-colors duration-200">
                            <i data-lucide="printer" class="h-5 w-5 mr-2"></i>
                            In hóa đơn
                        </button>
                    </div>
                </div>
            </section>
        </c:if>
    </main>

    <!-- Include Footer -->
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <!-- Initialize Lucide Icons -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            lucide.createIcons();
        });
    </script>
</body>
</html>
