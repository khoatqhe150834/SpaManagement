<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Không có quyền truy cập - Beauty Zone Spa</title>
    
    <!-- Bootstrap CSS -->
    <link href="${pageContext.request.contextPath}/assets/home/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/home/css/style.css" rel="stylesheet">
    
    <style>
        .error-container {
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
        }
        
        .error-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            padding: 3rem;
            text-align: center;
            max-width: 600px;
            width: 100%;
        }
        
        .error-code {
            font-size: 6rem;
            font-weight: bold;
            color: #e74c3c;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
        }
        
        .error-title {
            font-size: 2rem;
            color: #2c3e50;
            margin-bottom: 1.5rem;
            font-weight: 600;
        }
        
        .error-message {
            font-size: 1.1rem;
            color: #7f8c8d;
            margin-bottom: 2rem;
            line-height: 1.6;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .icon-container {
            background: linear-gradient(135deg, #ff6b6b, #ee5a52);
            width: 120px;
            height: 120px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
        }
        
        .icon-container i {
            font-size: 3rem;
            color: white;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <%@ include file="../header.jsp" %>
    
    <main class="error-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="error-card">
                        <div class="icon-container">
                            <i class="fas fa-ban"></i>
                        </div>
                        
                        <div class="error-code">403</div>
                        
                        <h1 class="error-title">Không có quyền truy cập</h1>
                        
                        <div class="error-message">
                            <c:choose>
                                <c:when test="${not empty errorMessage}">
                                    ${errorMessage}
                                </c:when>
                                <c:otherwise>
                                    Bạn không có quyền truy cập vào trang này. Vui lòng liên hệ quản trị viên nếu bạn cho rằng đây là một lỗi.
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <c:if test="${not empty requestedPath}">
                            <p class="text-muted mb-3">
                                <small>Đường dẫn yêu cầu: ${requestedPath}</small>
                            </p>
                        </c:if>
                        
                        <div class="d-flex justify-content-center gap-3 flex-wrap">
                            <a href="javascript:history.back()" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                                <i class="fas fa-home me-2"></i>Về trang chủ
                            </a>
                            
                            <c:if test="${empty sessionScope.user and empty sessionScope.customer}">
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-success">
                                    <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                                </a>
                            </c:if>
                        </div>
                        
                        <div class="mt-4">
                            <small class="text-muted">
                                Cần hỗ trợ? Liên hệ: 
                                <a href="tel:+84123456789" class="text-decoration-none">0123 456 789</a> 
                                hoặc 
                                <a href="mailto:support@beautyzone.com" class="text-decoration-none">support@beautyzone.com</a>
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <!-- Footer -->
    <%@ include file="../footer.jsp" %>
    
    <!-- FontAwesome -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
</body>
</html> 