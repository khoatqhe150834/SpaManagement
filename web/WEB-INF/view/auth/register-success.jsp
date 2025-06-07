<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Đăng ký thành công | BeautyZone</title>
        
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
        </style>
    </head>

    <body>
        <div class="auth-container">
            <div class="auth-card text-center">
                <div class="success-icon">
                    ✓
                </div>
                <h2 class="mb-4">Đăng ký thành công!</h2>
                <div class="alert alert-success" role="alert">
                    <h5 class="alert-heading">Chào mừng bạn đến với BeautyZone!</h5>
                    <p>Chúng tôi đã gửi một email xác thực đến địa chỉ email <strong>${email}</strong>.</p>
                    <hr>
                    <p class="mb-0">Vui lòng kiểm tra hộp thư của bạn và nhấp vào liên kết xác thực để hoàn tất quá trình đăng ký.</p>
                </div>
                <div class="mt-4">
                    <p>Chưa nhận được email? <a href="#" class="text-primary" id="resendEmail">Gửi lại email xác thực</a></p>
                    <p>Hoặc <a href="${pageContext.request.contextPath}/login" class="text-primary">đăng nhập</a> nếu bạn đã xác thực tài khoản.</p>
                </div>
                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary">Về trang chủ</a>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.getElementById('resendEmail').addEventListener('click', function(e) {
                e.preventDefault();
                alert("Chức năng gửi lại email xác thực sẽ được triển khai sau!");
            });
        </script>
    </body>
</html> 