<%-- Document : index4.jsp Created on : May 29, 2025, 10:45:37 AM Author : quang --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi"> <%-- Changed lang to Vietnamese --%>
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="keywords" content="" />
    <meta name="author" content="" />
    <meta name="robots" content="" />
    <meta
      name="description"
      content="BeautyZone : Mẫu HTML Spa Thẩm Mỹ Viện" <%-- Translated --%>
    />
    <meta
      property="og:title"
      content="BeautyZone : Mẫu HTML Spa Thẩm Mỹ Viện" <%-- Translated --%>
    />
    <meta
      property="og:description"
      content="BeautyZone : Mẫu HTML Spa Thẩm Mỹ Viện" <%-- Translated --%>
    />
    <meta
      property="og:image"
      content="../../beautyzone.dexignzone.com/xhtml/social-image.png"
    />
    <meta name="format-detection" content="telephone=no" />

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

    <title>BeautyZone : Mẫu HTML Spa Thẩm Mỹ Viện</title> <%-- Translated --%>

    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!--[if lt IE 9]>
      <script src="js/html5shiv.min.js"></script>
      <script src="js/respond.min.js"></script>
    <![endif]-->

    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>

    <style>
      /* Styles for price list alignment */
      .spa-price-tbl li {
          display: flex;
          align-items: flex-start; /* Align image and text content to the top */
          margin-bottom: 30px; /* Increased margin for better separation */
          padding-bottom: 20px; /* Padding for content before border */
          border-bottom: 1px solid #f0f0f0; /* Lighter border for separation */
      }
      .spa-price-tbl li:last-child {
          margin-bottom: 0;
          padding-bottom: 0;
          border-bottom: none; /* No border for the last item in each list */
      }

      .spa-price-thumb {
          flex-shrink: 0; /* Prevent image from shrinking */
          margin-right: 20px; /* More space between image and text */
          width: 80px; 
          height: 80px;
      }
      .spa-price-thumb img {
          width: 100%;
          height: 100%;
          object-fit: cover; /* Ensure image covers the area well */
          border-radius: 4px; /* Slightly rounded corners for image */
      }

      .spa-price-content {
          display: flex;
          flex-direction: column; /* Stack title/price and description vertically */
          flex-grow: 1; /* Allow content area to take remaining space */
      }

      .spa-price-content h4 {
          display: flex; /* Enable flex for title and price alignment */
          justify-content: space-between; /* Push price to the right */
          align-items: flex-start; /* Align top of title and price */
          width: 100%;
          margin-top: 0; 
          margin-bottom: 8px; /* Space below title/price line */
      }

      .spa-price-content h4 a {
          margin-right: 10px; /* Space between title and price */
          font-size: 1.1em; 
          color: #333333; 
          font-weight: 600; 
          text-decoration: none; /* Remove underline from links */
      }
       .spa-price-content h4 a:hover {
          color: #c59952; /* Example hover color, adjust to your theme's primary color */
       }

      .spa-price-content .spa-price {
          white-space: nowrap; /* Prevent price from wrapping */
          font-size: 1.1em; 
          font-weight: 600; 
          color: #c59952; /* Example primary color, adjust to your theme */
      }

      .spa-price-content p {
          margin-top: 0;
          line-height: 1.6; /* For readability */
          color: #555555; 
          font-size: 0.95em;
          /* Line clamping for consistent paragraph height */
          display: -webkit-box;
          -webkit-line-clamp: 3; /* Limit to 3 lines */
          -webkit-box-orient: vertical;
          overflow: hidden;
          text-overflow: ellipsis;
          /* Set a min-height that accommodates 3 lines to prevent shorter paragraphs from collapsing too much */
          /* Adjust 1.6em * 3 based on your actual font-size and line-height for p */
          min-height: calc(1.6em * 3 * 0.95); /* (line-height * number of lines * font-size-multiplier) */
      }
    </style>

    </head>
  <body id="bg">
    <div class="page-wraper">
      <div id="loading-area"></div>
      <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>
      <div class="page-content bg-white">
        <div class="rev-slider">
          <div
            id="rev_slider_1164_1_wrapper"
            class="rev_slider_wrapper fullscreen-container"
            data-alias="exploration-header"
            data-source="gallery"
            style="background-color: transparent; padding: 0px"
          >
            <div
              id="rev_slider_1164_1"
              class="rev_slider fullscreenbanner"
              style="display: none"
              data-version="5.4.1"
            >
              <ul>
                <li
                  data-index="rs-3204"
                  data-transition="slideoververtical"
                  data-slotamount="default"
                  data-hideafterloop="0"
                  data-hideslideonmobile="off"
                  data-easein="default"
                  data-easeout="default"
                  data-masterspeed="default"
                  data-thumb="${pageContext.request.contextPath}/assets/home/images/main-slider/slide6.jpg"
                  data-rotate="0"
                  data-fstransition="fade"
                  data-fsmasterspeed="2000"
                  data-fsslotamount="7"
                  data-saveperformance="off"
                  data-title="" <%-- Assuming this is not for direct display or is dynamic --%>
                  data-param1="Những gì đội ngũ của chúng tôi đã tìm thấy trong tự nhiên" <%-- Translated --%>
                  data-param2=""
                  data-param3=""
                  data-param4=""
                  data-param5=""
                  data-param6=""
                  data-param7=""
                  data-param8=""
                  data-param9=""
                  data-param10=""
                  data-description="" <%-- Assuming this is not for direct display or is dynamic --%>
                >
                  <img
                    src="${pageContext.request.contextPath}/assets/home/images/main-slider/slide6.jpg"
                    alt="Hình ảnh slide chính" <%-- Translated alt text --%>
                    data-lazyload="${pageContext.request.contextPath}/assets/home/images/main-slider/slide6.jpg"
                    data-bgposition="center center"
                    data-bgfit="cover"
                    data-bgrepeat="no-repeat"
                    data-bgparallax="6"
                    class="rev-slidebg"
                    data-no-retina
                  />
                  <div
                    class="tp-caption tp-shape tp-shapewrapper"
                    id="slide-101-layer-14"
                    data-x="['center','center','center','center']"
                    data-hoffset="['0','0','0','0']"
                    data-y="['middle','middle','middle','middle']"
                    data-voffset="['0','0','0','0']"
                    data-width="full"
                    data-height="full"
                    data-whitespace="nowrap"
                    data-type="shape"
                    data-basealign="slide"
                    data-responsive_offset="off"
                    data-responsive="off"
                    data-frames='[{"delay":10,"speed":1000,"frame":"0","from":"opacity:0;","to":"o:1;","ease":"Power3.easeInOut"},{"delay":"wait","speed":1500,"frame":"999","to":"opacity:0;","ease":"Power4.easeIn"}]'
                    data-textAlign="['inherit','inherit','inherit','inherit']"
                    data-paddingtop="[0,0,0,0]"
                    data-paddingright="[0,0,0,0]"
                    data-paddingbottom="[0,0,0,0]"
                    data-paddingleft="[0,0,0,0]"
                    style="
                      z-index: 5;
                      font-family: Open Sans;
                      background-color: rgba(0, 0, 0, 0.15);
                      background-image: url(${pageContext.request.contextPath}/assets/home/images/background/bg6.png);
                      background-size: 100%;
                      background-repeat: no-repeat;
                      background-position: bottom;
                    "
                  ></div>

                  <div
                    class="tp-caption"
                    id="slide-3204-layer-1"
                    data-x="['center','center','center','center']"
                    data-hoffset="['0','0','0','0']"
                    data-y="['middle','middle','middle','middle']"
                    data-voffset="['-35','-35','-10','-35']"
                    data-fontsize="['170','170','100','60']"
                    data-lineheight="['190','45','35','30']"
                    data-width="['1000','1000','600','360']"
                    data-height="none"
                    data-whitespace="normal"
                    data-type="text"
                    data-basealign="slide"
                    data-responsive_offset="off"
                    data-responsive="off"
                    data-frames='[{"from":"y:50px;opacity:0;","speed":1500,"to":"o:1;","delay":500,"ease":"Power4.easeOut"},{"delay":"wait","speed":300,"to":"opacity:0;","ease":"nothing"}]'
                    data-textAlign="['center','center','center','center']"
                    data-paddingtop="[0,0,0,0]"
                    data-paddingright="[0,0,0,0]"
                    data-paddingbottom="[0,0,0,0]"
                    data-paddingleft="[0,0,0,0]"
                    style="
                      z-index: 5;
                      white-space: normal;
                      color: #fff;
                      font-family: 'Great Vibes', cursive;
                      border-width: 0px;
                    "
                  >
                    Spa Salon
                  </div>

                  <div
                    class="tp-caption"
                    id="slide-3204-layer-2"
                    data-x="['center','center','center','center']"
                    data-hoffset="['0','0','0','0']"
                    data-y="['middle','middle','middle','middle']"
                    data-voffset="['90','90','70','40']"
                    data-width="['600','600','600','260']"
                    data-fontsize="['50','50','40','30']"
                    data-lineheight="['65','45','35','30']"
                    data-height="none"
                    data-whitespace="normal"
                    data-type="text"
                    data-basealign="slide"
                    data-responsive_offset="off"
                    data-responsive="off"
                    data-frames='[{"from":"y:50px;opacity:0;","speed":1500,"to":"o:1;","delay":650,"ease":"Power4.easeOut"},{"delay":"wait","speed":300,"to":"opacity:0;","ease":"nothing"}]'
                    data-textAlign="['center','center','center','center']"
                    data-paddingtop="[0,0,0,0]"
                    data-paddingright="[0,0,0,0]"
                    data-paddingbottom="[0,0,0,0]"
                    data-paddingleft="[0,0,0,0]"
                    style="
                      z-index: 7;
                      white-space: normal;
                      color: #fff;
                      font-family: 'Montserrat', sans-serif;
                      border-width: 0px;
                      text-transform: uppercase;
                      font-weight: 600;
                    "
                  >
                    SẮC ĐẸP & THƯ GIÃN <%-- Translated --%>
                  </div>

                  <div
                    class="tp-caption"
                    id="slide-3204-layer-3"
                    data-x="['center','center','center','center']"
                    data-hoffset="['0','0','0','0']"
                    data-y="['middle','middle','middle','middle']"
                    data-voffset="['150','150','110','100']"
                    data-width="['600','560','340','260']"
                    data-fontsize="['18','18','18','16']"
                    data-lineheight="['26','26','26','24']"
                    data-height="none"
                    data-whitespace="normal"
                    data-type="text"
                    data-basealign="slide"
                    data-responsive_offset="off"
                    data-responsive="off"
                    data-frames='[{"from":"y:50px;opacity:0;","speed":2000,"to":"o:1;","delay":750,"ease":"Power4.easeOut"},{"delay":"wait","speed":300,"to":"opacity:0;","ease":"nothing"}]'
                    data-textAlign="['center','center','center','center']"
                    data-paddingtop="[0,0,0,0]"
                    data-paddingright="[0,0,0,0]"
                    data-paddingbottom="[0,0,0,0]"
                    data-paddingleft="[0,0,0,0]"
                    style="
                      z-index: 7;
                      white-space: normal;
                      color: #fff;
                      font-family: 'Montserrat', sans-serif;
                      border-width: 0px;
                      text-transform: uppercase;
                      font-weight: 600;
                    "
                  >
                    Trải Nghiệm Bền Lâu <%-- Translated --%>
                  </div>
                </li>
              </ul>
              <div
                class="tp-bannertimer tp-bottom"
                style="visibility: hidden !important"
              ></div>
            </div>
          </div>
          </div>
        <div class="section-full bg-white content-inner-2 spa-about-bx">
          <div class="container">
            <div class="row d-flex align-items-center">
              <div class="col-lg-6 col-md-6">
                <div class="spa-bx-img">
                  <img
                    src="${pageContext.request.contextPath}/assets/home/images/about/img4.jpg"
                    alt="Về chúng tôi" <%-- Translated alt text --%>
                  />
                </div>
              </div>
              <div class="col-lg-6 col-md-6 spa-about-content">
                <h2>Không Chỉ Là <br />Một Spa Thông Thường</h2> <%-- Already Vietnamese --%>
                <p>
                  Chào mừng bạn đến với dịch vụ spa cao cấp của chúng tôi, nơi
                  mang đến trải nghiệm thư giãn và làm đẹp toàn diện. Với đội
                  ngũ chuyên gia giàu kinh nghiệm cùng các liệu pháp hiện đại
                  kết hợp tinh hoa từ thiên nhiên, chúng tôi cam kết mang đến
                  cho bạn những phút giây thư thái cho cả thể chất lẫn tinh
                  thần. Hãy để chúng tôi chăm sóc và nuông chiều bạn theo cách
                  riêng biệt nhất.
                </p> <%-- Already Vietnamese --%>
                <a
                  href="about-us.html"
                  class="site-button radius-no button-effect1"
                  >Xem Thêm<span></span
                ></a> <%-- Already Vietnamese --%>
              </div>
            </div>
          </div>
        </div>
        <div class="section-full content-inner-3 spa-price-bx">
          <div class="container">
            <div class="section-head text-black text-center">
              
              <h2 class="m-b10">Bảng Giá Đặc Biệt</h2> <%-- Already Vietnamese --%>
            </div>
            <div class="row">
              <div class="col-lg-6 col-md-12 col-sm-12">
                <ul class="spa-price-tbl">
                  <li>
                    <div class="spa-price-thumb">
                      <img
                        src="${pageContext.request.contextPath}/assets/home/images/gallery/thumb/pic1.jpg"
                        alt="Massage cho bà bầu" <%-- Translated alt text --%>
                      />
                    </div>
                    <div class="spa-price-content">
                      <h4>
                        <a href="booking.html">Massage Cho Bà Bầu</a> <%-- Translated --%>
                        <span class="spa-price ml-auto text-primary"
                          >350.000 VNĐ</span <%-- Updated currency --%>
                        >
                      </h4>
                      <p>
                        Liệu pháp massage nhẹ nhàng dành riêng cho mẹ bầu, giúp giảm căng thẳng, cải thiện lưu thông máu và mang lại cảm giác thư thái. <%-- Updated content --%>
                      </p>
                    </div>
                  </li>
                  <li>
                    <div class="spa-price-thumb">
                      <img
                        src="${pageContext.request.contextPath}/assets/home/images/gallery/thumb/pic2.jpg"
                        alt="Massage bấm huyệt" <%-- Translated alt text --%>
                      />
                    </div>
                    <div class="spa-price-content">
                      <h4>
                        <a href="booking.html">Massage Bấm Huyệt</a> <%-- Translated --%>
                        <span class="spa-price ml-auto text-primary"
                          >500.000 VNĐ</span <%-- Updated currency --%>
                        >
                      </h4>
                      <p>
                        Kỹ thuật bấm huyệt chuyên sâu tác động lên các điểm huyệt đạo, giúp đả thông kinh mạch, giảm đau nhức và phục hồi năng lượng. <%-- Updated content --%>
                      </p>
                    </div>
                  </li>
                  <li>
                    <div class="spa-price-thumb">
                      <img
                        src="${pageContext.request.contextPath}/assets/home/images/gallery/thumb/pic3.jpg"
                        alt="Massage thư giãn toàn thân" <%-- Updated alt text --%>
                      />
                    </div>
                    <div class="spa-price-content">
                      <h4>
                        <a href="booking.html">Massage Thư Giãn Toàn Thân</a> <%-- Updated --%>
                        <span class="spa-price ml-auto text-primary"
                          >800.000 VNĐ</span <%-- Updated currency --%>
                        >
                      </h4>
                      <p>
                        Tận hưởng sự thư giãn tuyệt đối với liệu pháp massage toàn thân, giải tỏa mọi mệt mỏi, giúp cơ thể nhẹ nhàng và tràn đầy sức sống. <%-- Updated content --%>
                      </p>
                    </div>
                  </li>
                </ul>
              </div>
              <div class="col-lg-6 col-md-12 col-sm-12">
                <ul class="spa-price-tbl">
                  <li>
                    <div class="spa-price-thumb">
                      <img
                        src="${pageContext.request.contextPath}/assets/home/images/gallery/thumb/pic4.jpg"
                        alt="Chăm sóc da mặt chuyên sâu" <%-- Updated alt text --%>
                      />
                    </div>
                    <div class="spa-price-content">
                      <h4>
                        <a href="booking.html">Chăm Sóc Da Mặt</a> <%-- Updated --%>
                        <span class="spa-price ml-auto text-primary"
                          >600.000 VNĐ</span <%-- Updated currency --%>
                        >
                      </h4>
                      <p>
                        Liệu trình chăm sóc da mặt chuyên sâu giúp làm sạch, cung cấp dưỡng chất, mang lại làn da căng bóng. <%-- Updated content --%>
                      </p>
                    </div>
                  </li>
                  <li>
                    <div class="spa-price-thumb">
                      <img
                        src="${pageContext.request.contextPath}/assets/home/images/gallery/thumb/pic5.jpg"
                        alt="Xông hơi thảo dược" <%-- Updated alt text --%>
                      />
                    </div>
                    <div class="spa-price-content">
                      <h4>
                        <a href="booking.html">Xông Hơi Thảo Dược</a> <%-- Updated --%>
                        <span class="spa-price ml-auto text-primary"
                          >450.000 VNĐ</span <%-- Updated currency --%>
                        >
                      </h4>
                      <p>
                        Thư giãn và thanh lọc cơ thể với liệu pháp xông hơi bằng các loại thảo dược quý, giúp đào thải độc tố và cải thiện sức khỏe. <%-- Updated content --%>
                      </p>
                    </div>
                  </li>
                  <li>
                    <div class="spa-price-thumb">
                      <img
                        src="${pageContext.request.contextPath}/assets/home/images/gallery/thumb/pic6.jpg"
                        alt="Gói trị liệu cặp đôi" <%-- Updated alt text --%>
                      />
                    </div>
                    <div class="spa-price-content">
                      <h4>
                        <a href="booking.html">Gói Trị Liệu Cặp Đôi</a> <%-- Updated --%>
                        <span class="spa-price ml-auto text-primary"
                          >1.500.000 VNĐ</span <%-- Updated currency --%>
                        >
                      </h4>
                      <p>
                        Cùng người thương tận hưởng những phút giây thư giãn lãng mạn với gói trị liệu đặc biệt dành cho các cặp đôi. <%-- Updated content --%>
                      </p>
                    </div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <div
          class="section-full content-inner-2 spa-our-portfolio"
          style="
            background-image: url(${pageContext.request.contextPath}/assets/home/images/background/bg9.jpg);
            background-size: cover;
          "
        >
          <div class="container">
            <div class="section-head text-black text-center">
              
              <h2 class="m-b10">Portfolio Của Chúng Tôi</h2> <%-- Translated --%>
            </div>
            <div class="row">
              <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="site-filters style1 clearfix center">
                  <ul class="filters" data-toggle="buttons">
                    <li data-filter="" class="btn active">
                      <input type="radio" /><a href="#"><span>Tất Cả</span></a> <%-- Translated --%>
                    </li>
                    <li data-filter="massage" class="btn">
                      <input type="radio" /><a href="#"><span>Massage</span></a>
                    </li>
                    <li data-filter="aroma" class="btn">
                      <input type="radio" /><a href="#"><span>Hương Liệu</span></a> <%-- Translated --%>
                    </li>
                    <li data-filter="salt-aroma" class="btn">
                      <input type="radio" /><a href="#"
                        ><span>Muối & Hương Liệu</span></a <%-- Translated --%>
                      >
                    </li>
                  </ul>
                </div>
              </div>
            </div>
            <div class="clearfix">
              <ul
                id="masonry"
                class="portfolio-box row dlab-gallery-listing gallery-grid-4 gallery lightgallery"
              >
                <li
                  class="aroma card-container col-lg-4 col-md-6 col-sm-6 m-b30"
                >
                  <div class="dlab-box">
                    <div class="dlab-media">
                      <img
                        src="${pageContext.request.contextPath}/assets/home/images/gallery/image-1.jpg"
                        alt="Hình ảnh portfolio" <%-- Translated alt text --%>
                      />
                      <div class="overlay-bx">
                        <div class="spa-port-bx">
                          <div>
                            <h4>
                              <a href="services-details.html"
                                >Massage Tẩy Tế Bào Chết Muối</a <%-- Translated --%>
                              >
                            </h4>
                            <p>
                              Trải nghiệm làn da mịn màng, tươi sáng với liệu pháp tẩy tế bào chết bằng muối khoáng tự nhiên. <%-- Updated content --%>
                            </p>
                            <span
                              data-exthumbimage="${pageContext.request.contextPath}/assets/home/images/gallery/thumb/image-1.jpg"
                              data-src="${pageContext.request.contextPath}/assets/home/images/gallery/image-1.jpg"
                              class="icon-bx-xs check-km"
                              title="Thư viện ảnh Lưới 1" <%-- Translated --%>
                            >
                              <i class="ti-fullscreen"></i>
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </li>
                <li
                  class="massage image-4 card-container col-lg-4 col-md-6 col-sm-6 m-b30"
                >
                  <div class="dlab-box">
                    <div class="dlab-media">
                      <img
                        src="${pageContext.request.contextPath}/assets/home/images/gallery/image-6.jpg"
                        alt="Hình ảnh portfolio" <%-- Translated alt text --%>
                      />
                      <div class="overlay-bx">
                        <div class="spa-port-bx">
                          <div>
                            <h4>
                              <a href="services-details.html"
                                >Massage Đá Nóng Thư Giãn</a <%-- Updated --%>
                              >
                            </h4>
                            <p>
                              Hơi ấm từ đá nóng kết hợp kỹ thuật massage chuyên nghiệp giúp xua tan mệt mỏi, lưu thông khí huyết. <%-- Updated content --%>
                            </p>
                            <span
                              data-exthumbimage="images/gallery/thumb/image-6.jpg"
                              data-src="${pageContext.request.contextPath}/assets/home/images/gallery/image-6.jpg"
                              class="icon-bx-xs check-km"
                              title="Thư viện ảnh Lưới 1" <%-- Translated --%>
                            >
                              <i class="ti-fullscreen"></i>
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </li>
                <li
                  class="massage image-4 card-container col-lg-4 col-md-6 col-sm-6 m-b30"
                >
                  <div class="dlab-box">
                    <div class="dlab-media">
                      <img
                        src="${pageContext.request.contextPath}/assets/home/images/gallery/image-5.jpg"
                        alt="Hình ảnh portfolio" <%-- Translated alt text --%>
                      />
                      <div class="overlay-bx">
                        <div class="spa-port-bx">
                          <div>
                            <h4>
                              <a href="services-details.html"
                                >Liệu Pháp Hương Thơm Dịu Nhẹ</a <%-- Updated --%>
                              >
                            </h4>
                            <p>
                              Đắm mình trong không gian ngập tràn hương thơm tinh dầu thiên nhiên, giúp tinh thần thư thái, giảm stress. <%-- Updated content --%>
                            </p>
                            <span
                              data-exthumbimage="${pageContext.request.contextPath}/assets/home/images/gallery/thumb/image-5.jpg"
                              data-src="${pageContext.request.contextPath}/assets/home/images/gallery/image-5.jpg"
                              class="icon-bx-xs check-km"
                              title="Thư viện ảnh Lưới 1" <%-- Translated --%>
                            >
                              <i class="ti-fullscreen"></i>
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </li>
                <li
                  class="salt-aroma image-4 card-container col-lg-4 col-md-6 col-sm-6 m-b30"
                >
                  <div class="dlab-box">
                    <div class="dlab-media">
                      <img
                        src="${pageContext.request.contextPath}/assets/home/images/gallery/image-7.jpg"
                        alt="Hình ảnh portfolio" <%-- Translated alt text --%>
                      />
                      <div class="overlay-bx">
                        <div class="spa-port-bx">
                          <div>
                            <h4>
                              <a href="services-details.html"
                                >Chăm Sóc Toàn Diện Với Muối Khoáng</a <%-- Updated --%>
                              >
                            </h4>
                            <p>
                              Kết hợp muối khoáng và hương liệu tự nhiên để thanh lọc và nuôi dưỡng làn da, mang lại vẻ đẹp rạng ngời. <%-- Updated content --%>
                            </p>
                            <span
                              data-exthumbimage="${pageContext.request.contextPath}/assets/home/images/gallery/thumb/image-7.jpg"
                              data-src="${pageContext.request.contextPath}/assets/home/images/gallery/image-7.jpg"
                              class="icon-bx-xs check-km"
                              title="Thư viện ảnh Lưới 1" <%-- Translated --%>
                            >
                              <i class="ti-fullscreen"></i>
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </li>
                <li
                  class="aroma image-4 card-container col-lg-4 col-md-6 col-sm-6 m-b30"
                >
                  <div class="dlab-box">
                    <div class="dlab-media">
                      <img
                        src="${pageContext.request.contextPath}/assets/home/images/gallery/image-8.jpg"
                        alt="Hình ảnh portfolio" <%-- Translated alt text --%>
                      />
                      <div class="overlay-bx">
                        <div class="spa-port-bx">
                          <div>
                            <h4>
                              <a href="services-details.html"
                                >Không Gian Spa Yên Tĩnh</a <%-- Updated --%>
                              >
                            </h4>
                            <p>
                              Thiết kế không gian sang trọng, ấm cúng và yên tĩnh, mang đến trải nghiệm thư giãn trọn vẹn. <%-- Updated content --%>
                            </p>
                            <span
                              data-exthumbimage="${pageContext.request.contextPath}/assets/home/images/gallery/thumb/image-8.jpg"
                              data-src="${pageContext.request.contextPath}/assets/home/images/gallery/image-8.jpg"
                              class="icon-bx-xs check-km"
                              title="Thư viện ảnh Lưới 1" <%-- Translated --%>
                            >
                              <i class="ti-fullscreen"></i>
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </li>
                <li
                  class="salt-aroma image-4 card-container col-lg-4 col-md-6 col-sm-6 m-b30"
                >
                  <div class="dlab-box">
                    <div class="dlab-media">
                      <img
                        src="${pageContext.request.contextPath}/assets/home/images/gallery/image-4.jpg"
                        alt="Hình ảnh portfolio" <%-- Translated alt text --%>
                      />
                      <div class="overlay-bx">
                        <div class="spa-port-bx">
                          <div>
                            <h4>
                              <a href="services-details.html"
                                >Sản Phẩm Chăm Sóc Cao Cấp</a <%-- Updated --%>
                              >
                            </h4>
                            <p>
                              Chúng tôi sử dụng các sản phẩm chăm sóc da và cơ thể cao cấp, chiết xuất từ thiên nhiên, an toàn cho mọi loại da. <%-- Updated content --%>
                            </p>
                            <span
                              data-exthumbimage="${pageContext.request.contextPath}/assets/home/images/gallery/thumb/image-4.jpg"
                              data-src="${pageContext.request.contextPath}/assets/home/images/gallery/image-4.jpg"
                              class="icon-bx-xs check-km"
                              title="Thư viện ảnh Lưới 1" <%-- Translated --%>
                            >
                              <i class="ti-fullscreen"></i>
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </li>
              </ul>
            </div>
          </div>
        </div>
        <div class="section-full content-inner-3 spa-price-bx">
          <div class="container">
            <div class="section-head text-black text-center">
              
              <h2 class="m-b0">Dịch Vụ Của Chúng Tôi</h2> <%-- Translated --%>
            </div>
            <div
              class="carousel-service owl-carousel owl-btn-center-lr owl-btn-3 owl-theme owl-dots-primary-full owl-loaded owl-drag"
            >
              <div class="item">
                <div class="dlab-box spa-ser-bx">
                  <div class="dlab-media">
                    <a href="services-details.html"
                      ><img
                        src="${pageContext.request.contextPath}/assets/home/images/blog/grid/pic1.jpg"
                        alt="Hình ảnh dịch vụ" <%-- Translated alt text --%>
                    /></a>
                  </div>
                  <div class="dlab-info">
                    <div class="dlab-info-bx">
                      <h6 class="dlab-title m-t0">
                        <a href="services-details.html">Trị Liệu Da Mặt</a> <%-- Updated --%>
                      </h6>
                      <a
                        href="booking.html"
                        class="site-button radius-no ml-auto"
                        >Đặt Ngay</a <%-- Translated --%>
                      >
                    </div>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="dlab-box spa-ser-bx">
                  <div class="dlab-media">
                    <a href="services-details.html"
                      ><img
                        src="${pageContext.request.contextPath}/assets/home/images/blog/grid/pic4.jpg"
                        alt="Hình ảnh dịch vụ" <%-- Translated alt text --%>
                    /></a>
                  </div>
                  <div class="dlab-info">
                    <div class="dlab-info-bx">
                      <h6 class="dlab-title m-t0">
                        <a href="services-details.html">Massage Toàn Thân</a> <%-- Updated --%>
                      </h6>
                      <a
                        href="booking.html"
                        class="site-button radius-no ml-auto"
                        >Đặt Ngay</a <%-- Translated --%>
                      >
                    </div>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="dlab-box spa-ser-bx">
                  <div class="dlab-media">
                    <a href="services-details.html"
                      ><img
                        src="${pageContext.request.contextPath}/assets/home/images/blog/grid/pic1.jpg"
                        alt="Hình ảnh dịch vụ" <%-- Translated alt text --%>
                    /></a>
                  </div>
                  <div class="dlab-info">
                    <div class="dlab-info-bx">
                      <h6 class="dlab-title m-t0">
                        <a href="services-details.html">Chăm Sóc Móng</a> <%-- Updated --%>
                      </h6>
                      <a
                        href="booking.html"
                        class="site-button radius-no ml-auto"
                        >Đặt Ngay</a <%-- Translated --%>
                      >
                    </div>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="dlab-box spa-ser-bx">
                  <div class="dlab-media">
                    <a href="services-details.html"
                      ><img
                        src="${pageContext.request.contextPath}/assets/home/images/blog/grid/pic4.jpg"
                        alt="Hình ảnh dịch vụ" <%-- Translated alt text --%>
                    /></a>
                  </div>
                  <div class="dlab-info">
                    <div class="dlab-info-bx">
                      <h6 class="dlab-title m-t0">
                        <a href="services-details.html">Trang Điểm Chuyên Nghiệp</a> <%-- Updated --%>
                      </h6>
                      <a
                        href="booking.html"
                        class="site-button radius-no ml-auto"
                        >Đặt Ngay</a <%-- Translated --%>
                      >
                    </div>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="dlab-box spa-ser-bx">
                  <div class="dlab-media">
                    <a href="services-details.html"
                      ><img
                        src="${pageContext.request.contextPath}/assets/home/images/blog/grid/pic1.jpg"
                        alt="Hình ảnh dịch vụ" <%-- Translated alt text --%>
                    /></a>
                  </div>
                  <div class="dlab-info">
                    <div class="dlab-info-bx">
                      <h6 class="dlab-title m-t0">
                        <a href="services-details.html">Tạo Kiểu Tóc</a> <%-- Updated --%>
                      </h6>
                      <a
                        href="booking.html"
                        class="site-button radius-no ml-auto"
                        >Đặt Ngay</a <%-- Translated --%>
                      >
                    </div>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="dlab-box spa-ser-bx">
                  <div class="dlab-media">
                    <a href="services-details.html"
                      ><img
                        src="${pageContext.request.contextPath}/assets/home/images/blog/grid/pic4.jpg"
                        alt="Hình ảnh dịch vụ" <%-- Translated alt text --%>
                    /></a>
                  </div>
                  <div class="dlab-info">
                    <div class="dlab-info-bx">
                      <h6 class="dlab-title m-t0">
                        <a href="services-details.html">Gói Spa Thư Giãn</a> <%-- Updated --%>
                      </h6>
                      <a
                        href="booking.html"
                        class="site-button radius-no ml-auto"
                        >Đặt Ngay</a <%-- Translated --%>
                      >
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="section-full content-inner-2 spa-testimonial">
          <div class="container">
            <div class="section-head text-black text-center">
              
              <h2 class="m-b0">Đánh Giá Của Khách Hàng</h2> <%-- Translated --%>
            </div>
            <div class="">
              <div
                class="testimonial-one owl-carousel owl-btn-center-lr owl-btn-3 owl-theme owl-dots-primary-full owl-loaded owl-drag"
              >
                <div class="item">
                  <div class="testimonial-1">
                    <div class="testimonial-pic radius shadow">
                      <img
                        src="${pageContext.request.contextPath}/assets/home/images/testimonials/pic1.jpg"
                        width="100"
                        height="100"
                        alt="Ảnh khách hàng" <%-- Translated alt text --%>
                      />
                    </div>
                    <div class="testimonial-text">
                      <p>
                        "Dịch vụ ở BeautyZone thật tuyệt vời! Tôi đã có một buổi massage thư giãn và cảm thấy như được tái tạo năng lượng. Nhân viên rất chuyên nghiệp và không gian thì vô cùng sang trọng. Chắc chắn tôi sẽ quay lại!" <%-- Updated content --%>
                      </p>
                    </div>
                    <div class="testimonial-detail">
                      <strong class="testimonial-name">Nguyễn Lan Anh</strong> <%-- Updated --%>
                      <span class="testimonial-position">Khách Hàng Thân Thiết</span> <%-- Updated --%>
                    </div>
                  </div>
                </div>
                <div class="item">
                  <div class="testimonial-1">
                    <div class="testimonial-pic radius shadow">
                      <img
                        src="${pageContext.request.contextPath}/assets/home/images/testimonials/pic2.jpg"
                        width="100"
                        height="100"
                        alt="Ảnh khách hàng" <%-- Translated alt text --%>
                      />
                    </div>
                    <div class="testimonial-text">
                      <p>
                        "Tôi rất hài lòng với liệu trình chăm sóc da mặt tại đây. Da tôi cải thiện rõ rệt, trở nên mịn màng và sáng hơn. Các bạn kỹ thuật viên rất tận tâm và tư vấn nhiệt tình. Cảm ơn BeautyZone!" <%-- Updated content --%>
                      </p>
                    </div>
                    <div class="testimonial-detail">
                      <strong class="testimonial-name">Trần Thị Linh</strong> <%-- Updated --%>
                      <span class="testimonial-position">Khách Hàng Mới</span> <%-- Updated --%>
                    </div>
                  </div>
                </div>
                <div class="item">
                  <div class="testimonial-1">
                    <div class="testimonial-pic radius shadow">
                      <img
                        src="${pageContext.request.contextPath}/assets/home/images/testimonials/pic3.jpg"
                        width="100"
                        height="100"
                        alt="Ảnh khách hàng" <%-- Translated alt text --%>
                      />
                    </div>
                    <div class="testimonial-text">
                      <p>
                        "Không gian spa rất đẹp và yên tĩnh, đúng là nơi lý tưởng để thư giãn sau những ngày làm việc căng thẳng. Tôi đã thử dịch vụ xông hơi thảo dược và cảm thấy cơ thể nhẹ nhõm hẳn. Sẽ giới thiệu cho bạn bè." <%-- Updated content --%>
                      </p>
                    </div>
                    <div class="testimonial-detail">
                      <strong class="testimonial-name">Lê Thu Hà</strong> <%-- Updated --%>
                      <span class="testimonial-position">Khách Hàng</span> <%-- Translated --%>
                    </div>
                  </div>
                </div>
                    
                    
              </div>
            </div>
          </div>
        </div>
        </div>
      <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
      <button class="scroltop fa fa-chevron-up"></button>
    </div>
    <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>

    <script>
      jQuery(document).ready(function () {
        "use strict";
        dz_rev_slider_4();
      }); /*ready*/
    </script>
  </body>
  </html>
