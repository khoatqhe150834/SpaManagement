<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@page
contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <!-- Mirrored from www.beautyzone.dexignzone.com/xhtml/register.html by HTTrack Website Copier/3.x [XR&CO'2014], Sat, 24 May 2025 16:40:31 GMT -->
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="keywords" content="" />
    <meta name="author" content="" />
    <meta name="robots" content="" />
    <meta
      name="description"
      content="BeautyZone : Beauty Spa Salon HTML Template"
    />
    <meta
      property="og:title"
      content="BeautyZone : Beauty Spa Salon HTML Template"
    />
    <meta
      property="og:description"
      content="BeautyZone : Beauty Spa Salon HTML Template"
    />
    <meta
      property="og:image"
      content="../../beautyzone.dexignzone.com/xhtml/social-image.png"
    />
    <meta name="format-detection" content="telephone=no" />

    <!-- FAVICONS ICON -->
    <link
      rel="icon"
      href="${pageContext.request.contextPath}/assets/home/images/favicon.ico"
      type="image/x-icon"
    />
    <link
      rel="shortcut icon"
      type="image/x-icon"
      href="${pageContext.request.contextPath}/assets/home/images/favicon.png"
    />

    <!-- Add CSS for validation styling -->
    <link
      rel="stylesheet"
      type="text/css"
      href="${pageContext.request.contextPath}/assets/home/css/auth/register.css"
    />

    <!-- PAGE TITLE HERE -->
    <title>BeautyZone : Beauty Spa Salon</title>
    
    <!-- Context path for JavaScript -->
    <meta name="context-path" content="${pageContext.request.contextPath}" />

    <!-- Custom styles for form -->
    <style>
        /* Make required field asterisks red */
        .font-weight-700:contains('*')::after,
        .font-weight-700 {
            color: inherit;
        }
        
        /* Target asterisks specifically */
        .required-asterisk {
            color: #dc3545 !important;
            font-weight: bold;
        }
    </style>

    <!-- MOBILE SPECIFIC -->
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!--[if lt IE 9]>
      <script src="js/html5shiv.min.js"></script>
      <script src="js/respond.min.js"></script>
    <![endif]-->

    <!-- STYLESHEETS -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>
  </head>
  <body id="bg">
    <div class="page-wraper">
      <div id="loading-area"></div>
      <!-- header -->
      <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>
      <!-- header END -->
      <!-- Content -->
      <div class="page-content bg-white">
        <!-- inner page banner -->
        <div
          class="dlab-bnr-inr overlay-primary bg-pt"
          style="
            background-image: url(${pageContext.request.contextPath}/assets/home/images/banner/bnr2.jpg);
          "
        >
          <div class="container">
            <div class="dlab-bnr-inr-entry">
              <h1 class="text-white">Đăng ký tài khoản</h1>
              <!-- Breadcrumb row -->
              <div class="breadcrumb-row">
                <ul class="list-inline">
                  <li>
                    <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                  </li>
                  <li>Đăng ký</li>
                </ul>
              </div>
              <!-- Breadcrumb row END -->
            </div>
          </div>
        </div>
        <!-- inner page banner END -->
        <!-- contact area -->
        <div class="section-full content-inner shop-account">
          <!-- Product -->
          <div class="container">
            <div class="row">
              <div class="col-md-12 text-center">
                <h3 class="font-weight-700 m-t0 m-b20">Tạo tài khoản</h3>
              </div>
            </div>
            <div class="row">
              <div class="col-md-12 m-b30">
                <div class="p-a30 border-1 max-w500 m-auto">
                  <div class="tab-content">
                    <c:if test="${not empty error}">
                      <div
                        class="alert alert-danger"
                        style="margin-bottom: 1rem"
                      >
                        ${error}
                      </div>
                    </c:if>

                    <form
                      id="registerForm"
                      class="tab-pane active"
                      method="post"
                      action="${pageContext.request.contextPath}/register"
                    >
                      <h4 class="font-weight-700">THÔNG TIN CÁ NHÂN</h4>
                      <p class="font-weight-600">
                        Nếu bạn đã có tài khoản với chúng tôi, vui lòng đăng
                        nhập.
                      </p>
                      <div class="form-group">
                        <label class="font-weight-700">Họ tên <span class="required-asterisk">*</span></label>
                        <input
                          id="fullName"
                          name="fullName"
                          required="true"
                          class="form-control"
                          placeholder="Trần Văn A"
                          type="text"
                          minlength="6"
                          maxlength="100"
                          title="Họ tên phải có ít nhất 6 ký tự và không chứa ký tự đặc biệt."
                          pattern="^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s]{6,}$"
                        />
                      </div>
                      <div class="form-group">
                        <label class="font-weight-700">SĐT <span class="required-asterisk">*</span></label>
                        <input
                          id="phone"
                          name="phone"
                          required="true"
                          class="form-control"
                          placeholder="0909090909"
                          type="text"
                          pattern="0[1-9][0-9]{8}"
                          title="Số điện thoại phải bắt đầu bằng 0, số thứ 2 từ 1-9, và có đúng 10 chữ số."
                          minlength="10"
                          maxlength="10"
                        />
                      </div>
                      <div class="form-group">
                        <label class="font-weight-700">E-MAIL <span class="required-asterisk">*</span></label>
                        <input
                          id="email"
                          name="email"
                          required="true"
                          class="form-control"
                          placeholder="email@gmail.com"
                          type="email"
                          maxlength="255"
                          pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                          title="Vui lòng nhập đúng định dạng email (không chứa khoảng trắng)."
                        />
                      </div>
                      <div class="form-group">
                        <label class="font-weight-700">MẬT KHẨU <span class="required-asterisk">*</span></label>
                        <input
                          id="password"
                          name="password"
                          required="true"
                          class="form-control"
                          type="password"
                          minlength="6"
                          maxlength="30"
                          pattern=".{6,}"
                          title="Mật khẩu phải có ít nhất 6 ký tự."
                          placeholder="******"
                        />
                        <div class="form-text text-muted" style="font-size: 14px; color: #666; margin-top: 8px; line-height: 1.4;">
                          <strong>Yêu cầu mật khẩu:</strong><br>
                          • Tối thiểu 6 ký tự, tối đa 30 ký tự<br>
                          • Nên sử dụng kết hợp chữ cái, số và ký tự đặc biệt<br>
                          • Không sử dụng thông tin cá nhân dễ đoán
                        </div>
                      </div>

                      <div class="form-group">
                        <label class="font-weight-700"
                          >NHẬP LẠI MẬT KHẨU <span class="required-asterisk">*</span></label
                        >
                        <input
                          name="confirmPassword"
                          id="confirmPassword"
                          required="true"
                          class="form-control"
                          type="password"
                          minlength="6"
                          maxlength="30"
                          title="Mật khẩu phải khớp với mật khẩu đã nhập."
                          placeholder="******"
                        />
                      </div>
                      <div class="text-left">
                        <button
                          type="submit"
                          style="
                            background-color: #586BB4;
                            color: white;
                            border: none;
                            border-radius: 0;
                            padding: 12px 20px;
                            width: 180px;
                            font-size: 16px;
                            font-weight: 600;
                            text-align: center;
                            cursor: pointer;
                            display: inline-block;
                            text-transform: none;
                            line-height: 1.42857;
                            outline: none;
                          "
                          onmouseover="this.style.backgroundColor='#455790'"
                          onmouseout="this.style.backgroundColor='#586BB4'"
                        >
                          TẠO TÀI KHOẢN
                        </button>
                      </div>
                    </form>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- Product END -->
        </div>

        <!-- contact area  END -->
      </div>
      <!-- Content END-->
      <!-- Footer -->
      <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
      <!-- Footer END -->
      <button type="button" class="scroltop" aria-label="Scroll to top">
        <i class="fa fa-chevron-up" aria-hidden="true"></i>
      </button>
    </div>
    <!-- JAVASCRIPT FILES ========================================= -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
    
    <!-- REGISTRATION VALIDATION SCRIPT -->
    <script src="${pageContext.request.contextPath}/assets/home/js/auth/register-validation.js"></script>
    
    <!-- Auto-focus on full name field -->
    <script>
        // Focus on full name field when page loads
        document.addEventListener('DOMContentLoaded', function() {
            const fullNameField = document.getElementById('fullName');
            if (fullNameField) {
                fullNameField.focus();
            }
            
            // Phone number input restriction - only allow numbers
            const phoneField = document.getElementById('phone');
            if (phoneField) {
                // Prevent non-numeric characters on keydown
                phoneField.addEventListener('keydown', function(e) {
                    // Allow: backspace, delete, tab, escape, enter, home, end, left, right
                    if ([8, 9, 27, 13, 46, 35, 36, 37, 39].indexOf(e.keyCode) !== -1 ||
                        // Allow Ctrl+A, Ctrl+C, Ctrl+V, Ctrl+X
                        (e.keyCode === 65 && e.ctrlKey === true) || 
                        (e.keyCode === 67 && e.ctrlKey === true) || 
                        (e.keyCode === 86 && e.ctrlKey === true) || 
                        (e.keyCode === 88 && e.ctrlKey === true)) {
                        return;
                    }
                    // Ensure that it is a number and stop the keypress
                    if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                        e.preventDefault();
                    }
                });
                
                // Clean pasted content - remove non-numeric characters
                phoneField.addEventListener('paste', function(e) {
                    setTimeout(() => {
                        let value = this.value.replace(/[^0-9]/g, '');
                        if (value.length > 10) {
                            value = value.substring(0, 10);
                        }
                        this.value = value;
                    }, 0);
                });
                
                // Also prevent non-numeric input on input event (backup)
                phoneField.addEventListener('input', function(e) {
                    let value = this.value.replace(/[^0-9]/g, '');
                    if (value.length > 10) {
                        value = value.substring(0, 10);
                    }
                    this.value = value;
                });
            }
        });
    </script>
  </body>
</html>
