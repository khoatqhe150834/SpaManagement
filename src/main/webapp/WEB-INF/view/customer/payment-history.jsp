<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${pageTitle != null ? pageTitle : 'Lịch Sử Thanh Toán - Spa Hương Sen'}</title>

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
      .payment-card {
        transition: all 0.3s ease;
      }
      .payment-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
      }

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
        height: 6px;
        background-color: #e5e7eb;
        border-radius: 3px;
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
                    <h1 class="text-4xl md:text-5xl font-serif mb-4">Lịch Sử Thanh Toán</h1>
                   
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

        <!-- Filter Section -->
        <section class="py-8">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="bg-white rounded-xl shadow-lg p-6 animate-fadeIn">
                    <h2 class="text-xl font-semibold text-spa-dark mb-4 flex items-center">
                        <i data-lucide="filter" class="h-5 w-5 mr-2 text-primary"></i>
                        Bộ lọc tìm kiếm
                    </h2>

                    <form method="GET" action="${pageContext.request.contextPath}/customer/payments" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4">
                        <div>
                            <label for="status" class="block text-sm font-medium text-spa-dark mb-1">Trạng thái</label>
                            <select name="status" id="status" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent">
                                <option value="ALL" ${statusFilter == 'ALL' || statusFilter == null ? 'selected' : ''}>Tất cả</option>
                                <option value="PAID" ${statusFilter == 'PAID' ? 'selected' : ''}>Đã thanh toán</option>
                                <option value="PENDING" ${statusFilter == 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                                <option value="FAILED" ${statusFilter == 'FAILED' ? 'selected' : ''}>Thất bại</option>
                                <option value="REFUNDED" ${statusFilter == 'REFUNDED' ? 'selected' : ''}>Đã hoàn tiền</option>
                            </select>
                        </div>

                        <div>
                            <label for="paymentMethod" class="block text-sm font-medium text-spa-dark mb-1">Phương thức</label>
                            <select name="paymentMethod" id="paymentMethod" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent">
                                <option value="ALL" ${paymentMethodFilter == 'ALL' || paymentMethodFilter == null ? 'selected' : ''}>Tất cả</option>
                                <option value="BANK_TRANSFER" ${paymentMethodFilter == 'BANK_TRANSFER' ? 'selected' : ''}>Chuyển khoản</option>
                                <option value="CREDIT_CARD" ${paymentMethodFilter == 'CREDIT_CARD' ? 'selected' : ''}>Thẻ tín dụng</option>
                                <option value="VNPAY" ${paymentMethodFilter == 'VNPAY' ? 'selected' : ''}>VNPay</option>
                                <option value="MOMO" ${paymentMethodFilter == 'MOMO' ? 'selected' : ''}>MoMo</option>
                                <option value="ZALOPAY" ${paymentMethodFilter == 'ZALOPAY' ? 'selected' : ''}>ZaloPay</option>
                                <option value="CASH" ${paymentMethodFilter == 'CASH' ? 'selected' : ''}>Tiền mặt</option>
                            </select>
                        </div>

                        <div>
                            <label for="startDate" class="block text-sm font-medium text-spa-dark mb-1">Từ ngày</label>
                            <input type="date" name="startDate" id="startDate" value="${startDate}"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent">
                        </div>

                        <div>
                            <label for="endDate" class="block text-sm font-medium text-spa-dark mb-1">Đến ngày</label>
                            <input type="date" name="endDate" id="endDate" value="${endDate}"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent">
                        </div>

                        <div>
                            <label for="search" class="block text-sm font-medium text-spa-dark mb-1">Tìm kiếm</label>
                            <input type="text" name="search" id="search" value="${searchQuery}"
                                   placeholder="Mã tham chiếu, ghi chú..."
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent">
                        </div>

                        <div class="flex items-end gap-2">
                            <button type="submit" class="flex-1 bg-primary hover:bg-primary-dark text-white px-4 py-2 rounded-lg font-medium transition-colors duration-200 flex items-center justify-center">
                                <i data-lucide="search" class="h-4 w-4 mr-2"></i>
                                Lọc
                            </button>
                            <a href="${pageContext.request.contextPath}/customer/payments"
                               class="bg-gray-500 hover:bg-gray-600 text-white px-4 py-2 rounded-lg font-medium transition-colors duration-200 flex items-center justify-center">
                                <i data-lucide="x" class="h-4 w-4"></i>
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </section>

        <!-- Payment History Content -->
        <section class="pb-16">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <c:choose>
                    <c:when test="${payments != null && not empty payments}">
                        <div class="grid gap-6">
                            <c:forEach var="payment" items="${payments}">
                                <div class="payment-card bg-white rounded-xl shadow-lg overflow-hidden animate-fadeIn">
                                    <!-- Payment Header -->
                                    <div class="bg-gradient-to-r from-gray-50 to-gray-100 p-6 border-b border-gray-200">
                                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-4">
                                            <div>
                                                <div class="text-sm text-gray-600 mb-1">Mã thanh toán</div>
                                                <div class="font-semibold text-spa-dark">#${payment.paymentId}</div>
                                            </div>

                                            <div>
                                                <div class="text-sm text-gray-600 mb-1">Mã tham chiếu</div>
                                                <div class="font-semibold text-spa-dark">${payment.referenceNumber}</div>
                                            </div>

                                            <div>
                                                <div class="text-sm text-gray-600 mb-1">Ngày thanh toán</div>
                                                <div class="font-semibold text-spa-dark">
                                                    <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </div>
                                            </div>

                                            <div>
                                                <div class="text-sm text-gray-600 mb-1">Phương thức</div>
                                                <div class="font-semibold text-spa-dark">
                                                    <c:choose>
                                                        <c:when test="${payment.paymentMethod == 'BANK_TRANSFER'}">Chuyển khoản</c:when>
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
                                                <div class="font-bold text-lg text-primary">
                                                    <fmt:formatNumber value="${payment.totalAmount}" type="currency"
                                                                    currencySymbol="" pattern="#,##0"/> VNĐ
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Payment Items -->
                                    <c:if test="${payment.paymentItems != null && not empty payment.paymentItems}">
                                        <div class="p-6">
                                            <h3 class="text-lg font-semibold text-spa-dark mb-4 flex items-center">
                                                <i data-lucide="shopping-bag" class="h-5 w-5 mr-2 text-primary"></i>
                                                Dịch vụ đã mua (${payment.paymentItems.size()} dịch vụ)
                                            </h3>

                                            <div class="grid gap-4">
                                                <c:forEach var="item" items="${payment.paymentItems}">
                                                    <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                                                        <div class="flex-1">
                                                            <div class="font-medium text-spa-dark">
                                                                ${item.serviceName != null ? item.serviceName : 'Dịch vụ không xác định'}
                                                            </div>
                                                            <div class="text-sm text-gray-600">Số lượng: ${item.quantity}</div>
                                                        </div>

                                                        <div class="text-right mr-4">
                                                            <div class="font-semibold text-primary">
                                                                <fmt:formatNumber value="${item.totalPrice}" type="currency"
                                                                                currencySymbol="" pattern="#,##0"/> VNĐ
                                                            </div>
                                                        </div>

                                                        <div class="text-center min-w-[120px]">
                                                            <c:choose>
                                                                <c:when test="${item.usage != null}">
                                                                    <div class="text-sm text-gray-600 mb-1">
                                                                        Đã sử dụng: ${item.usage.bookedQuantity}/${item.usage.totalQuantity}
                                                                    </div>
                                                                    <div class="usage-progress mb-1">
                                                                        <div class="usage-fill" style="width: ${item.usage.totalQuantity > 0 ? (item.usage.bookedQuantity * 100 / item.usage.totalQuantity) : 0}%"></div>
                                                                    </div>
                                                                    <div class="text-xs text-green-600 font-medium">
                                                                        Còn lại: ${item.usage.remainingQuantity}
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="text-sm text-gray-500">Chưa có thông tin sử dụng</div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>

                                            <!-- Payment Summary -->
                                            <div class="mt-6 pt-4 border-t border-gray-200">
                                                <div class="flex justify-end">
                                                    <div class="w-80">
                                                        <div class="space-y-2 text-sm">
                                                            <div class="flex justify-between">
                                                                <span>Tạm tính:</span>
                                                                <span><fmt:formatNumber value="${payment.subtotalAmount}" type="currency"
                                                                                      currencySymbol="" pattern="#,##0"/> VNĐ</span>
                                                            </div>
                                                            <div class="flex justify-between">
                                                                <span>Thuế VAT:</span>
                                                                <span><fmt:formatNumber value="${payment.taxAmount}" type="currency"
                                                                                      currencySymbol="" pattern="#,##0"/> VNĐ</span>
                                                            </div>
                                                            <div class="flex justify-between font-bold text-lg text-primary border-t pt-2">
                                                                <span>Tổng cộng:</span>
                                                                <span><fmt:formatNumber value="${payment.totalAmount}" type="currency"
                                                                                      currencySymbol="" pattern="#,##0"/> VNĐ</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Notes -->
                                            <c:if test="${not empty payment.notes}">
                                                <div class="mt-4 p-4 bg-yellow-50 border-l-4 border-yellow-400 rounded">
                                                    <div class="flex items-start">
                                                        <i data-lucide="info" class="h-5 w-5 text-yellow-600 mr-2 mt-0.5"></i>
                                                        <div>
                                                            <div class="font-medium text-yellow-800 mb-1">Ghi chú:</div>
                                                            <div class="text-yellow-700">${payment.notes}</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>

                                            <!-- Action Button -->
                                            <div class="mt-4 text-right">
                                                <a href="${pageContext.request.contextPath}/customer/payment-details?id=${payment.paymentId}"
                                                   class="inline-flex items-center px-4 py-2 bg-primary hover:bg-primary-dark text-white rounded-lg font-medium transition-colors duration-200">
                                                    <i data-lucide="eye" class="h-4 w-4 mr-2"></i>
                                                    Xem chi tiết
                                                </a>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="mt-8 flex justify-center">
                                <nav class="flex items-center space-x-2">
                                    <!-- Previous Page -->
                                    <c:choose>
                                        <c:when test="${hasPreviousPage}">
                                            <a href="?page=${currentPage - 1}&pageSize=${pageSize}&status=${statusFilter}&paymentMethod=${paymentMethodFilter}&startDate=${startDate}&endDate=${endDate}&search=${searchQuery}"
                                               class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700">
                                                <i data-lucide="chevron-left" class="h-4 w-4"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="px-3 py-2 text-sm font-medium text-gray-300 bg-white border border-gray-300 rounded-md cursor-not-allowed">
                                                <i data-lucide="chevron-left" class="h-4 w-4"></i>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Page Numbers -->
                                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                        <c:choose>
                                            <c:when test="${pageNum == currentPage}">
                                                <span class="px-3 py-2 text-sm font-medium text-white bg-primary border border-primary rounded-md">${pageNum}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="?page=${pageNum}&pageSize=${pageSize}&status=${statusFilter}&paymentMethod=${paymentMethodFilter}&startDate=${startDate}&endDate=${endDate}&search=${searchQuery}"
                                                   class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700">${pageNum}</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>

                                    <!-- Next Page -->
                                    <c:choose>
                                        <c:when test="${hasNextPage}">
                                            <a href="?page=${currentPage + 1}&pageSize=${pageSize}&status=${statusFilter}&paymentMethod=${paymentMethodFilter}&startDate=${startDate}&endDate=${endDate}&search=${searchQuery}"
                                               class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-md hover:bg-gray-50 hover:text-gray-700">
                                                <i data-lucide="chevron-right" class="h-4 w-4"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="px-3 py-2 text-sm font-medium text-gray-300 bg-white border border-gray-300 rounded-md cursor-not-allowed">
                                                <i data-lucide="chevron-right" class="h-4 w-4"></i>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </nav>
                            </div>

                            <div class="mt-4 text-center text-sm text-gray-600">
                                Hiển thị ${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize > totalRecords ? totalRecords : currentPage * pageSize}
                                trong tổng số ${totalRecords} kết quả
                            </div>
                        </c:if>

                    </c:when>
                    <c:otherwise>
                        <!-- Empty State -->
                        <div class="text-center py-16">
                            <div class="mx-auto w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mb-6">
                                <i data-lucide="receipt" class="h-12 w-12 text-gray-400"></i>
                            </div>
                            <h3 class="text-xl font-semibold text-spa-dark mb-2">Chưa có lịch sử thanh toán</h3>
                            <p class="text-gray-600 mb-6">Bạn chưa thực hiện thanh toán nào. Hãy đặt dịch vụ để bắt đầu trải nghiệm spa!</p>
                            <a href="${pageContext.request.contextPath}/"
                               class="inline-flex items-center px-6 py-3 bg-primary hover:bg-primary-dark text-white rounded-lg font-medium transition-colors duration-200">
                                <i data-lucide="sparkles" class="h-5 w-5 mr-2"></i>
                                Khám phá dịch vụ
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </main>

    <!-- Include Footer -->
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <!-- Initialize Lucide Icons -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            lucide.createIcons();

            // Set max date for date inputs to today
            const today = new Date().toISOString().split('T')[0];
            const startDateInput = document.getElementById('startDate');
            const endDateInput = document.getElementById('endDate');

            if (startDateInput) startDateInput.setAttribute('max', today);
            if (endDateInput) endDateInput.setAttribute('max', today);

            // Validate date range
            if (startDateInput) {
                startDateInput.addEventListener('change', function() {
                    const startDate = this.value;
                    if (startDate && endDateInput) {
                        endDateInput.setAttribute('min', startDate);
                    }
                });
            }

            if (endDateInput) {
                endDateInput.addEventListener('change', function() {
                    const endDate = this.value;
                    if (endDate && startDateInput) {
                        startDateInput.setAttribute('max', endDate);
                    }
                });
            }
        });
    </script>
</body>
</html>
