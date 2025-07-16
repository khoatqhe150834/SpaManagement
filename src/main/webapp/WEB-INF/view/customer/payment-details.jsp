<%-- 
    Document   : payment-details.jsp
    Created on : Payment Details View
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${pageTitle != null ? pageTitle : 'Chi Tiết Thanh Toán - BeautyZone Spa'}</title>
    
    <!-- Include Common Styles -->
    <jsp:include page="/WEB-INF/view/common/admin/stylesheet.jsp" />
    
    <style>
        .payment-details-container {
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
            min-height: 100vh;
            background-color: #f8fafc;
        }
        
        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
            padding: 1.5rem 2rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .page-title {
            font-size: 2rem;
            font-weight: 600;
            margin: 0;
        }
        
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        .breadcrumb a {
            color: white;
            text-decoration: none;
        }
        
        .breadcrumb a:hover {
            text-decoration: underline;
        }
        
        .payment-detail-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 2rem;
        }
        
        .card-header {
            padding: 1.5rem;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            border-bottom: 1px solid #e5e7eb;
        }
        
        .card-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
            color: #1f2937;
        }
        
        .card-body {
            padding: 1.5rem;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .info-item {
            display: flex;
            flex-direction: column;
        }
        
        .info-label {
            font-size: 0.9rem;
            color: #6b7280;
            font-weight: 500;
            margin-bottom: 0.5rem;
        }
        
        .info-value {
            font-weight: 600;
            color: #1f2937;
            font-size: 1.1rem;
        }
        
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-block;
            width: fit-content;
        }
        
        .status-paid { background: #d1fae5; color: #065f46; }
        .status-pending { background: #fef3c7; color: #92400e; }
        .status-failed { background: #fee2e2; color: #991b1b; }
        .status-refunded { background: #e0e7ff; color: #3730a3; }
        
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }
        
        .items-table th,
        .items-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .items-table th {
            background: #f9fafb;
            font-weight: 600;
            color: #374151;
        }
        
        .usage-progress {
            width: 100px;
            height: 8px;
            background: #e5e7eb;
            border-radius: 4px;
            overflow: hidden;
            margin: 0.25rem 0;
        }
        
        .usage-fill {
            height: 100%;
            background: #10b981;
            transition: width 0.3s;
        }
        
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            background: #6b7280;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: background 0.2s;
        }
        
        .back-button:hover {
            background: #4b5563;
        }
        
        @media (max-width: 768px) {
            .payment-details-container {
                padding: 1rem;
            }
            
            .page-header {
                flex-direction: column;
                text-align: center;
                gap: 1rem;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .items-table {
                font-size: 0.9rem;
            }
            
            .items-table th,
            .items-table td {
                padding: 0.75rem 0.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="/WEB-INF/view/common/header.jsp" />
    
    <div class="payment-details-container">
        <!-- Page Header -->
        <div class="page-header">
            <div>
                <h1 class="page-title">Chi Tiết Thanh Toán #${payment.paymentId}</h1>
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                    <span>›</span>
                    <a href="${pageContext.request.contextPath}/customer/dashboard">Dashboard</a>
                    <span>›</span>
                    <a href="${pageContext.request.contextPath}/customer/payment-history">Lịch sử thanh toán</a>
                    <span>›</span>
                    <span>Chi tiết thanh toán</span>
                </div>
            </div>
            <div class="customer-info">
                <c:if test="${customer != null}">
                    <div style="text-align: right;">
                        <div style="font-size: 1.1rem; font-weight: 500;">${customer.fullName}</div>
                        <div style="opacity: 0.8;">${customer.email}</div>
                    </div>
                </c:if>
            </div>
        </div>
        
        <c:if test="${payment != null}">
            <!-- Payment Information -->
            <div class="payment-detail-card">
                <div class="card-header">
                    <h2 class="card-title">Thông Tin Thanh Toán</h2>
                </div>
                <div class="card-body">
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">Mã thanh toán</span>
                            <span class="info-value">#${payment.paymentId}</span>
                        </div>
                        
                        <div class="info-item">
                            <span class="info-label">Mã tham chiếu</span>
                            <span class="info-value">${payment.referenceNumber}</span>
                        </div>
                        
                        <div class="info-item">
                            <span class="info-label">Ngày thanh toán</span>
                            <span class="info-value">
                                <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </span>
                        </div>
                        
                        <div class="info-item">
                            <span class="info-label">Phương thức thanh toán</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${payment.paymentMethod == 'BANK_TRANSFER'}">Chuyển khoản ngân hàng</c:when>
                                    <c:when test="${payment.paymentMethod == 'CREDIT_CARD'}">Thẻ tín dụng</c:when>
                                    <c:when test="${payment.paymentMethod == 'VNPAY'}">VNPay</c:when>
                                    <c:when test="${payment.paymentMethod == 'MOMO'}">MoMo</c:when>
                                    <c:when test="${payment.paymentMethod == 'ZALOPAY'}">ZaloPay</c:when>
                                    <c:when test="${payment.paymentMethod == 'CASH'}">Tiền mặt</c:when>
                                    <c:otherwise>${payment.paymentMethod}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        
                        <div class="info-item">
                            <span class="info-label">Trạng thái</span>
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
                        
                        <div class="info-item">
                            <span class="info-label">Tổng tiền</span>
                            <span class="info-value" style="color: #059669; font-size: 1.3rem;">
                                <fmt:formatNumber value="${payment.totalAmount}" type="currency" 
                                                currencySymbol="" pattern="#,##0"/> VNĐ
                            </span>
                        </div>
                    </div>
                    
                    <c:if test="${not empty payment.notes}">
                        <div style="margin-top: 1.5rem; padding: 1rem; background: #f9fafb; border-radius: 8px; border-left: 4px solid #fbbf24;">
                            <div style="font-weight: 500; margin-bottom: 0.5rem; color: #92400e;">Ghi chú:</div>
                            <div style="color: #6b7280;">${payment.notes}</div>
                        </div>
                    </c:if>
                </div>
            </div>
            
            <!-- Payment Items -->
            <c:if test="${payment.paymentItems != null && not empty payment.paymentItems}">
                <div class="payment-detail-card">
                    <div class="card-header">
                        <h2 class="card-title">Dịch Vụ Đã Mua (${payment.paymentItems.size()} dịch vụ)</h2>
                    </div>
                    <div class="card-body">
                        <table class="items-table">
                            <thead>
                                <tr>
                                    <th>Dịch vụ</th>
                                    <th>Số lượng</th>
                                    <th>Đơn giá</th>
                                    <th>Thành tiền</th>
                                    <th>Tình trạng sử dụng</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${payment.paymentItems}">
                                    <tr>
                                        <td>
                                            <div style="font-weight: 500;">${item.serviceName != null ? item.serviceName : 'Dịch vụ không xác định'}</div>
                                            <c:if test="${item.serviceDuration != null}">
                                                <div style="color: #6b7280; font-size: 0.9rem;">Thời gian: ${item.serviceDuration} phút</div>
                                            </c:if>
                                        </td>
                                        <td>${item.quantity}</td>
                                        <td>
                                            <fmt:formatNumber value="${item.unitPrice}" type="currency" 
                                                            currencySymbol="" pattern="#,##0"/> VNĐ
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${item.totalPrice}" type="currency" 
                                                            currencySymbol="" pattern="#,##0"/> VNĐ
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.usage != null}">
                                                    <div>Đã sử dụng: ${item.usage.bookedQuantity}/${item.usage.totalQuantity}</div>
                                                    <div class="usage-progress">
                                                        <div class="usage-fill" style="width: ${item.usage.totalQuantity > 0 ? (item.usage.bookedQuantity * 100 / item.usage.totalQuantity) : 0}%"></div>
                                                    </div>
                                                    <div style="color: #059669; font-size: 0.9rem;">Còn lại: ${item.usage.remainingQuantity}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div style="color: #6b7280;">Chưa có thông tin sử dụng</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        
                        <!-- Payment Summary -->
                        <div style="margin-top: 2rem; padding-top: 1rem; border-top: 2px solid #e5e7eb;">
                            <div style="display: grid; grid-template-columns: 1fr auto; gap: 2rem;">
                                <div></div>
                                <div style="min-width: 300px;">
                                    <div style="display: grid; gap: 0.75rem; font-size: 1rem;">
                                        <div style="display: flex; justify-content: space-between;">
                                            <span>Tạm tính:</span>
                                            <span><fmt:formatNumber value="${payment.subtotalAmount}" type="currency" 
                                                                  currencySymbol="" pattern="#,##0"/> VNĐ</span>
                                        </div>
                                        <div style="display: flex; justify-content: space-between;">
                                            <span>Thuế VAT:</span>
                                            <span><fmt:formatNumber value="${payment.taxAmount}" type="currency" 
                                                                  currencySymbol="" pattern="#,##0"/> VNĐ</span>
                                        </div>
                                        <div style="display: flex; justify-content: space-between; font-weight: 700; font-size: 1.2rem; color: #059669; border-top: 1px solid #e5e7eb; padding-top: 0.75rem;">
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
            </c:if>
        </c:if>
        
        <!-- Back Button -->
        <div style="margin-top: 2rem;">
            <a href="${pageContext.request.contextPath}/customer/payment-history" class="back-button">
                <i class="fas fa-arrow-left"></i>
                Quay lại lịch sử thanh toán
            </a>
        </div>
    </div>
    
    <!-- Include Footer -->
    <jsp:include page="/WEB-INF/view/common/footer.jsp" />
    
    <!-- Include Common JS -->
    <jsp:include page="/WEB-INF/view/common/admin/js.jsp" />
</body>
</html>
