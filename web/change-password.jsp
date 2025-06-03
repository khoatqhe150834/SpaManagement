<%-- 
    Document   : reset-password
    Created on : Jun 2, 2025, 10:25:49 AM
    Author     : quang
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt Lại Mật Khẩu - Spa Management</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            
            .container {
                background: white;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 450px;
                text-align: center;
            }
            
            .header {
                margin-bottom: 30px;
            }
            
            .header h1 {
                color: #333;
                font-size: 28px;
                margin-bottom: 10px;
            }
            
            .header p {
                color: #666;
                font-size: 14px;
            }
            
            .user-info {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 25px;
                border-left: 4px solid #4CAF50;
            }
            
            .user-info p {
                color: #555;
                margin: 0;
                font-size: 14px;
            }
            
            .user-info strong {
                color: #333;
            }
            
            .form-group {
                margin-bottom: 20px;
                text-align: left;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #555;
                font-weight: 500;
                font-size: 14px;
            }
            
            .form-group input {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e1e1e1;
                border-radius: 8px;
                font-size: 16px;
                transition: border-color 0.3s ease;
                background-color: #fafafa;
            }
            
            .form-group input:focus {
                outline: none;
                border-color: #4CAF50;
                background-color: white;
            }
            
            .password-requirements {
                font-size: 12px;
                color: #666;
                margin-top: 5px;
            }
            
            .submit-btn {
                width: 100%;
                padding: 15px;
                background: linear-gradient(135deg, #4CAF50, #45a049);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-top: 10px;
            }
            
            .submit-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(76, 175, 80, 0.4);
            }
            
            .submit-btn:disabled {
                background: #ccc;
                cursor: not-allowed;
                transform: none;
                box-shadow: none;
            }
            
            .error {
                background: #ffebee;
                color: #c62828;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                border-left: 4px solid #e53935;
                font-size: 14px;
            }
            
            .success {
                background: #e8f5e8;
                color: #2e7d32;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                border-left: 4px solid #4caf50;
                font-size: 14px;
            }
            
            .back-link {
                margin-top: 25px;
                padding-top: 20px;
                border-top: 1px solid #eee;
            }
            
            .back-link a {
                color: #666;
                text-decoration: none;
                font-size: 14px;
                transition: color 0.3s ease;
            }
            
            .back-link a:hover {
                color: #4CAF50;
            }
            
            .password-strength {
                margin-top: 5px;
                font-size: 12px;
            }
            
            .strength-weak { color: #f44336; }
            .strength-medium { color: #ff9800; }
            .strength-strong { color: #4caf50; }
            
            .validation-message {
                font-size: 12px;
                margin-top: 5px;
            }
            
            .valid { color: #4caf50; }
            .invalid { color: #f44336; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Đặt Lại Mật Khẩu</h1>
                <p>Vui lòng nhập mật khẩu mới cho tài khoản của bạn</p>
            </div>
            
            <!-- Check if user email exists in session -->
            <c:if test="${empty sessionScope.resetEmail}">
                <div class="error">
                    Phiên làm việc đã hết hạn. Vui lòng yêu cầu đặt lại mật khẩu mới.
                </div>
                <div class="back-link">
                    <a href="${pageContext.request.contextPath}/reset-password">← Quay lại yêu cầu đặt lại mật khẩu</a>
                </div>
            </c:if>
            
            <c:if test="${not empty sessionScope.resetEmail}">
                <div class="user-info">
                    <p>Đặt lại mật khẩu cho: <strong>${sessionScope.resetEmail}</strong></p>
                </div>
                
                <!-- Display error/success messages -->
                <c:if test="${not empty error}">
                    <div class="error">${error}</div>
                </c:if>
                
                <c:if test="${not empty success}">
                    <div class="success">${success}</div>
                </c:if>
                
                <form action="change-password" method="POST" id="passwordChangeForm">
                    <div class="form-group">
                        <label for="newPassword">Mật khẩu mới *</label>
                        <input type="password" 
                               name="newPassword" 
                               id="newPassword" 
                               required 
                               minlength="6"
                               placeholder="Nhập mật khẩu mới">
                        <div class="password-requirements">
                            Mật khẩu phải có ít nhất 6 ký tự
                        </div>
                        <div id="passwordStrength" class="password-strength"></div>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">Xác nhận mật khẩu *</label>
                        <input type="password" 
                               name="confirmPassword" 
                               id="confirmPassword" 
                               required 
                               minlength="6"
                               placeholder="Nhập lại mật khẩu mới">
                        <div id="passwordMatch" class="validation-message"></div>
                    </div>
                    
                    <button type="submit" class="submit-btn" id="submitBtn">
                        Đặt Lại Mật Khẩu
                    </button>
                </form>
                
                <div class="back-link">
                    <a href="${pageContext.request.contextPath}/login">← Quay lại đăng nhập</a>
                </div>
            </c:if>
        </div>
        
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const newPassword = document.getElementById('newPassword');
                const confirmPassword = document.getElementById('confirmPassword');
                const submitBtn = document.getElementById('submitBtn');
                const passwordStrength = document.getElementById('passwordStrength');
                const passwordMatch = document.getElementById('passwordMatch');
                const form = document.getElementById('passwordChangeForm');
                
                // Password strength checker
                function checkPasswordStrength(password) {
                    let strength = 0;
                    let feedback = [];
                    
                    if (password.length >= 8) {
                        strength += 1;
                    } else {
                        feedback.push('Ít nhất 8 ký tự');
                    }
                    
                    if (/[a-z]/.test(password)) {
                        strength += 1;
                    } else {
                        feedback.push('Chữ thường');
                    }
                    
                    if (/[A-Z]/.test(password)) {
                        strength += 1;
                    } else {
                        feedback.push('Chữ hoa');
                    }
                    
                    if (/[0-9]/.test(password)) {
                        strength += 1;
                    } else {
                        feedback.push('Số');
                    }
                    
                    if (/[^A-Za-z0-9]/.test(password)) {
                        strength += 1;
                    } else {
                        feedback.push('Ký tự đặc biệt');
                    }
                    
                    return { strength, feedback };
                }
                
                // Update password strength display
                function updatePasswordStrength() {
                    const password = newPassword.value;
                    if (password.length === 0) {
                        passwordStrength.innerHTML = '';
                        return;
                    }
                    
                    const result = checkPasswordStrength(password);
                    let strengthText = '';
                    let strengthClass = '';
                    
                    if (result.strength <= 2) {
                        strengthText = 'Yếu';
                        strengthClass = 'strength-weak';
                    } else if (result.strength <= 3) {
                        strengthText = 'Trung bình';
                        strengthClass = 'strength-medium';
                    } else {
                        strengthText = 'Mạnh';
                        strengthClass = 'strength-strong';
                    }
                    
                    passwordStrength.innerHTML = `<span class="${strengthClass}">Độ mạnh: ${strengthText}</span>`;
                    
                    if (result.feedback.length > 0 && result.strength < 4) {
                        passwordStrength.innerHTML += `<br><span style="color: #666;">Thiếu: ${result.feedback.join(', ')}</span>`;
                    }
                }
                
                // Check password match
                function checkPasswordMatch() {
                    const password = newPassword.value;
                    const confirm = confirmPassword.value;
                    
                    if (confirm.length === 0) {
                        passwordMatch.innerHTML = '';
                        return false;
                    }
                    
                    if (password === confirm) {
                        passwordMatch.innerHTML = '<span class="valid">✓ Mật khẩu khớp</span>';
                        return true;
                    } else {
                        passwordMatch.innerHTML = '<span class="invalid">✗ Mật khẩu không khớp</span>';
                        return false;
                    }
                }
                
                // Validate form
                function validateForm() {
                    const password = newPassword.value;
                    const confirm = confirmPassword.value;
                    const isPasswordValid = password.length >= 6;
                    const isPasswordMatch = password === confirm && confirm.length > 0;
                    
                    submitBtn.disabled = !(isPasswordValid && isPasswordMatch);
                }
                
                // Event listeners
                newPassword.addEventListener('input', function() {
                    updatePasswordStrength();
                    checkPasswordMatch();
                    validateForm();
                });
                
                confirmPassword.addEventListener('input', function() {
                    checkPasswordMatch();
                    validateForm();
                });
                
                // Form submission
                form.addEventListener('submit', function(e) {
                    const password = newPassword.value;
                    const confirm = confirmPassword.value;
                    
                    if (password !== confirm) {
                        e.preventDefault();
                        alert('Mật khẩu xác nhận không khớp. Vui lòng kiểm tra lại.');
                        return;
                    }
                    
                    if (password.length < 6) {
                        e.preventDefault();
                        alert('Mật khẩu phải có ít nhất 6 ký tự.');
                        return;
                    }
                    
                    // Disable submit button to prevent double submission
                    submitBtn.disabled = true;
                    submitBtn.textContent = 'Đang xử lý...';
                });
                
                // Initial validation
                validateForm();
            });
        </script>
    </body>
</html>
