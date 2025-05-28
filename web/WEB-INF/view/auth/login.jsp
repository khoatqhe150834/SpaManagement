<%-- Document : login Created on : May 27, 2025, 7:34:53 AM Author : quang --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@page
contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <!-- Mirrored from www.beautyzone.dexignzone.com/xhtml/login.html by HTTrack Website Copier/3.x [XR&CO'2014], Sat, 24 May 2025 16:40:31 GMT -->
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
    <link rel="icon" href="images/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" type="image/x-icon" href="images/favicon.png" />

    <!-- PAGE TITLE HERE -->
    <title>BeautyZone : Beauty Spa Salon HTML Template</title>

    <!-- MOBILE SPECIFIC -->
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!--[if lt IE 9]>
      <script src="js/html5shiv.min.js"></script>
      <script src="js/respond.min.js"></script>
    <![endif]-->

    <!-- STYLESHEETS -->
    <jsp:include page="/WEB-INF/view/common/stylesheet.jsp"></jsp:include>
  </head>
  <body id="bg">
    <div class="page-wraper">
      <div id="loading-area"></div>
      <!-- header -->
      <jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

      <!-- header END -->
      <!-- Content -->
      <div class="page-content bg-white">
        <!-- inner page banner -->
        <div
          class="dlab-bnr-inr overlay-primary bg-pt"
          style="background-image: url(images/banner/bnr2.jpg)"
        >
          <div class="container">
            <div class="dlab-bnr-inr-entry">
              <h1 class="text-white">Đăng nhập</h1>
              <!-- Breadcrumb row -->
              <div class="breadcrumb-row">
                <ul class="list-inline">
                  <li><a href="index.html">Trang chủ</a></li>
                  <li>Đăng nhập</li>
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
                <h3 class="font-weight-700 m-t0 m-b20">Đăng nhập tài khoản</h3>
              </div>
            </div>
            <div>
              <div class="max-w500 m-auto m-b30">
                <div class="p-a30 border-1 seth">
                  <div class="tab-content nav">
                      <form id="loginForm" method="post" action="login"  class="tab-pane active col-12 p-a0" >
                      <h4 class="font-weight-700">ĐĂNG NHẬP</h4>
                      <p class="font-weight-600">
                        Nếu bạn đã có tài khoản, vui lòng đăng nhập.
                      </p>
                      <div class="form-group">
                        <label class="font-weight-700">E-MAIL *</label>
                        <input
                          name="email"
                          required="true"
                          class="form-control"
                          placeholder="example@gmail.com"
                          type="email"
                        />
                      </div>
                      <div class="form-group">
                        <label class="font-weight-700">MẬT KHẨU *</label>
                        <input
                          name="password"
                          required="true"
                          class="form-control"
                          placeholder="******"
                          type="password"
                        />
                      </div>
                      <div class="text-left">
                       <button class="site-button m-r5 button-lg radius-no">ĐĂNG NHẬP</button>
                        <a
                          data-toggle="tab"
                          href="#forgot-password"
                          class="m-l5"
                          ><i class="fa fa-unlock-alt"></i> Quên mật khẩu</a
                        >
                      </div>
                    </form>
                    <form
                      id="forgot-password"
                      class="tab-pane fade col-12 p-a0"
                    >
                      <h4 class="font-weight-700">QUÊN MẬT KHẨU ?</h4>
                      <p class="font-weight-600">
                        Chúng tôi sẽ gửi cho bạn một email để đặt lại mật khẩu
                        của bạn.
                      </p>
                      <div class="form-group">
                        <label class="font-weight-700">E-MAIL *</label>
                        <input
                          name="dzName"
                          required=""
                          class="form-control"
                          placeholder="Email của bạn"
                          type="email"
                        />
                      </div>
                      <div class="text-left">
                        <a
                          class="site-button outline gray button-lg radius-no"
                          data-toggle="tab"
                          href="#login"
                          >Quay lại</a
                        >
                        <button class="site-button m-r5 button-lg radius-no">Gửi</button>
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
      <jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
      <!-- Footer END -->
      <button class="scroltop fa fa-chevron-up"></button>
    </div>
    <!-- JAVASCRIPT FILES ========================================= -->
    <jsp:include page="/WEB-INF/view/common/js.jsp"></jsp:include>
  </body>

  <!-- Mirrored from www.beautyzone.dexignzone.com/xhtml/login.html by HTTrack Website Copier/3.x [XR&CO'2014], Sat, 24 May 2025 16:40:31 GMT -->
</html>
