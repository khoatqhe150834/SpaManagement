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
            <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/home/css/auth/register.css" />

            <!-- PAGE TITLE HERE -->
            <title>BeautyZone : Beauty Spa Salon</title>

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
                                                <div class="alert alert-danger" style="margin-bottom: 1rem;">
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
                                                    <label class="font-weight-700">Họ tên *</label>
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
                                                        pattern="^[a-zA-Z\s]{6,}$"
                                                        />
                                                    
                                                </div>
                                                <div class="form-group">
                                                    <label class="font-weight-700">SĐT *</label>
                                                    <input
                                                        id="phone"
                                                        name="phone"
                                                        required="true"
                                                        class="form-control"
                                                        placeholder="0909090909"
                                                        type="text"
                                                        pattern="[0-9]{10,11}"
                                                        title="Số điện thoại phải là 10 hoặc 11 chữ số."
                                                        minlength="10"
                                                        maxlength="11"
                                                        />
                                                    
                                                </div>
                                                <div class="form-group">
                                                    <label class="font-weight-700">E-MAIL *</label>
                                                    <input
                                                        id="email"
                                                        name="email"
                                                        required="true"
                                                        class="form-control"
                                                        placeholder="email@gmail.com"
                                                        type="email"
                                                        maxlength="255"
                                                        title="Vui lòng nhập đúng định dạng email."
                                                        />
                                                    
                                                </div>
                                                <div class="form-group">
                                                    <label class="font-weight-700">MẬT KHẨU *</label>
                                                    <input
                                                        id="password"
                                                        name="password"
                                                        required="true"
                                                        class="form-control"
                                                        type="password"
                                                        minlength="6"
                                                        maxlength="30"
                                                        pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$"
                                                        title="Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt."
                                                        placeholder="******"
                                                        />
                                                    
                                                </div>

                                                <div class="form-group">
                                                    <label class="font-weight-700"
                                                           >NHẬP LẠI MẬT KHẨU *</label
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

                                                    <button class="site-button m-r5 button-lg radius-no">TẠO TÀI KHOẢN</button>
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
        </body>

    </html>
