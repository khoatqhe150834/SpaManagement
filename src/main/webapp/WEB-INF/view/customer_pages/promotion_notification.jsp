<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông Báo Khuyến Mãi - Spa Hương Sen</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        .notification-card {
            background: white;
            border-radius: 8px;
            border-left: 4px solid #28a745;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }
        .notification-header {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 20px;
            text-align: center;
        }
        .notification-body {
            padding: 25px;
        }
        .promotion-highlight {
            background: #e7f3ff;
            border: 1px solid #bee5eb;
            border-radius: 8px;
            padding: 15px;
            margin: 15px 0;
        }
        .promo-code {
            background: #17a2b8;
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: bold;
            display: inline-block;
            margin: 10px 5px;
        }
        .cta-button {
            background: #007bff;
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            margin: 10px 5px;
            transition: all 0.3s ease;
        }
        .cta-button:hover {
            background: #0056b3;
            color: white;
            transform: translateY(-2px);
        }
        .benefit-list {
            list-style: none;
            padding: 0;
        }
        .benefit-list li {
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        .benefit-list li:last-child {
            border-bottom: none;
        }
        .discount-badge {
            background: #fd7e14;
            color: white;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/view/common/header.jsp" />

    <div class="container mt-4">
        <!-- Page Header -->
        <div class="text-center mb-4">
            <h2><i class="fas fa-bell text-warning"></i> Thông Báo Khuyến Mãi</h2>
            <p class="text-muted">Những ưu đãi đặc biệt dành riêng cho bạn</p>
        </div>

        <!-- Main Notification -->
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="notification-card">
                    <div class="notification-header">
                        <i class="fas fa-gift fa-3x mb-3"></i>
                        <h3>🎉 Bạn Có Mã Giảm Giá Mới!</h3>
                        <p class="mb-0">Spa Hương Sen dành tặng những ưu đãi đặc biệt cho bạn</p>
                    </div>

                    <div class="notification-body">
                        <c:choose>
                            <c:when test="${not empty newPromotions}">
                                <div class="text-center mb-4">
                                    <h5 class="text-primary">
                                        <i class="fas fa-stars"></i> 
                                        Chúc mừng! Bạn có ${fn:length(newPromotions)} mã khuyến mãi mới
                                    </h5>
                                </div>

                                <!-- Danh sách mã mới -->
                                <c:forEach var="promotion" items="${newPromotions}">
                                    <div class="promotion-highlight">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="mb-1 text-primary">${promotion.title}</h6>
                                                <span class="promo-code">${promotion.promotionCode}</span>
                                            </div>
                                            <div class="text-end">
                                                <span class="discount-badge">
                                                    <c:choose>
                                                        <c:when test="${promotion.discountType == 'PERCENTAGE'}">
                                                            Giảm ${promotion.discountValue}%
                                                        </c:when>
                                                        <c:otherwise>
                                                            Giảm <fmt:formatNumber value="${promotion.discountValue}" type="currency" currencySymbol=""/>đ
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </div>
                                        <p class="text-muted mt-2 mb-1">${promotion.description}</p>
                                        <small class="text-info">
                                            <i class="fas fa-clock"></i>
                                            Có hiệu lực đến: ${promotion.endDate.toString().substring(0,10)}
                                        </small>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <!-- Thông báo chung về khuyến mãi -->
                                <div class="text-center mb-4">
                                    <h5 class="text-success">
                                        <i class="fas fa-heart"></i> 
                                        Cảm ơn bạn đã tin tướng Spa Hương Sen!
                                    </h5>
                                    <p class="text-muted">Chúng tôi có những ưu đãi đặc biệt đang chờ bạn</p>
                                </div>

                                <div class="promotion-highlight">
                                    <h6 class="text-primary">✨ Những lợi ích dành cho bạn:</h6>
                                    <ul class="benefit-list">
                                        <li><i class="fas fa-check text-success"></i> Giảm giá lên đến 30% cho dịch vụ spa</li>
                                        <li><i class="fas fa-check text-success"></i> Ưu đãi đặc biệt cho khách hàng thân thiết</li>
                                        <li><i class="fas fa-check text-success"></i> Quà tặng miễn phí khi sử dụng dịch vụ</li>
                                        <li><i class="fas fa-check text-success"></i> Thông báo sớm về các chương trình mới</li>
                                    </ul>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- Call to Action -->
                        <div class="text-center mt-4">
                            <h6 class="mb-3">🚀 Hành động ngay để không bỏ lỡ ưu đãi!</h6>
                            
                            <a href="${pageContext.request.contextPath}/promotions/available" class="cta-button">
                                <i class="fas fa-tags"></i> Xem Tất Cả Khuyến Mãi
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/services" class="cta-button">
                                <i class="fas fa-spa"></i> Đặt Dịch Vụ Ngay
                            </a>
                        </div>

                        <!-- Tips -->
                        <div class="alert alert-light mt-4">
                            <h6><i class="fas fa-lightbulb text-warning"></i> Mẹo sử dụng mã khuyến mãi:</h6>
                            <ul class="mb-0">
                                <li>Sao chép mã khuyến mãi trước khi đặt dịch vụ</li>
                                <li>Kiểm tra điều kiện áp dụng (giá trị tối thiểu, thời hạn)</li>
                                <li>Áp dụng mã tại bước thanh toán</li>
                                <li>Một đơn hàng chỉ sử dụng được 1 mã khuyến mãi</li>
                            </ul>
                        </div>

                        <!-- Contact Info -->
                        <div class="text-center mt-4 pt-3 border-top">
                            <p class="text-muted mb-2">
                                <i class="fas fa-question-circle"></i> 
                                Cần hỗ trợ? Liên hệ ngay với chúng tôi
                            </p>
                            <p class="mb-0">
                                <i class="fas fa-phone text-success"></i> Hotline: 
                                <strong>1900-xxxx</strong>
                                |
                                <i class="fas fa-envelope text-primary"></i> Email: 
                                <strong>info@spahuongsen.com</strong>
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Additional Actions -->
                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">
                        <i class="fas fa-home"></i> Về Trang Chủ
                    </a>
                    
                    <button class="btn btn-outline-info" onclick="sharePromotion()">
                        <i class="fas fa-share"></i> Chia Sẻ Với Bạn Bè
                    </button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/view/common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function sharePromotion() {
            const text = 'Spa Hương Sen đang có khuyến mãi đặc biệt! Cùng nhau đến trải nghiệm dịch vụ spa tuyệt vời nhé! 🌸';
            const url = window.location.origin + '${pageContext.request.contextPath}/promotions/available';
            
            if (navigator.share) {
                // Sử dụng Web Share API nếu có
                navigator.share({
                    title: 'Khuyến Mãi Spa Hương Sen',
                    text: text,
                    url: url
                }).catch(console.error);
            } else {
                // Fallback: copy to clipboard
                const fullText = text + ' ' + url;
                navigator.clipboard.writeText(fullText).then(() => {
                    alert('Đã sao chép link chia sẻ! Hãy gửi cho bạn bè nhé 😊');
                }).catch(() => {
                    // Fallback cuối cùng
                    prompt('Sao chép link này để chia sẻ:', fullText);
                });
            }
        }

        // Auto redirect sau 30 giây (nếu muốn)
        // setTimeout(() => {
        //     window.location.href = '${pageContext.request.contextPath}/promotions/available';
        // }, 30000);
    </script>
</body>
</html> 
 
 