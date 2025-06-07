<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Kết quả xác thực | BeautyZone</title>
        
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .auth-container {
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            .auth-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                padding: 40px;
                max-width: 500px;
                width: 100%;
            }
            .success-icon {
                width: 80px;
                height: 80px;
                background: #28a745;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px;
                color: white;
                font-size: 40px;
            }
            .error-icon {
                width: 80px;
                height: 80px;
                background: #dc3545;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px;
                color: white;
                font-size: 40px;
            }
        </style>
    </head>

    <body>
        <div class="auth-container">
            <div class="auth-card text-center">
                <% if (request.getAttribute("success") != null) { %>
                    <div class="success-icon">
                        ✓
                    </div>
                    <h2 class="mb-4 text-success">Xác thực thành công!</h2>
                    <div class="alert alert-success" role="alert">
                        <h5 class="alert-heading">Chúc mừng!</h5>
                        <p><%= request.getAttribute("success") %></p>
                        <% if (request.getAttribute("email") != null) { %>
                            <p class="mb-0">Email: <strong><%= request.getAttribute("email") %></strong></p>
                        <% } %>
                    </div>
                    <% if (request.getAttribute("canLogin") != null) { %>
                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-success me-2">Đăng nhập ngay</a>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary">Về trang chủ</a>
                        </div>
                    <% } else { %>
                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary">Về trang chủ</a>
                        </div>
                    <% } %>
                <% } else if (request.getAttribute("error") != null) { %>
                    <div class="error-icon">
                        ✗
                    </div>
                    <h2 class="mb-4 text-danger">Xác thực thất bại!</h2>
                    <div class="alert alert-danger" role="alert">
                        <h5 class="alert-heading">Có lỗi xảy ra</h5>
                        <p><%= request.getAttribute("error") %></p>
                    </div>
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary me-2">Đăng ký lại</a>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary">Về trang chủ</a>
                    </div>
                <% } else { %>
                    <div class="error-icon">
                        ?
                    </div>
                    <h2 class="mb-4">Không có thông tin</h2>
                    <div class="alert alert-warning" role="alert">
                        <p>Không có thông tin xác thực.</p>
                    </div>
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary">Về trang chủ</a>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html> 