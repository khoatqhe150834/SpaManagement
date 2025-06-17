<%-- 
    Document   : booking-selection.jsp
    Created on : Customer Service Booking Selection
    Author     : G1_SpaManagement Team
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chọn Dịch Vụ - BeautyZone Spa</title>
    
    <!-- Include Home Framework Styles -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp" />
    
    <style>
        .booking-option-card {
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            background: #ffffff;
        }
        
        .booking-option-card:hover {
            border-color: #c8945f;
            box-shadow: 0 4px 12px rgba(200, 148, 95, 0.1);
            transform: translateY(-2px);
        }
        
        .booking-option-card.selected {
            border-color: #c8945f;
            background: #fcf8f1;
        }
        
        .booking-option-title {
            font-size: 18px;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 8px;
        }
        
        .booking-option-description {
            color: #6b7280;
            font-size: 14px;
            line-height: 1.5;
        }
        
        .booking-section-title {
            font-size: 24px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 24px;
            border-bottom: 2px solid #c8945f;
            padding-bottom: 8px;
        }
        
        .d-flex {
            display: flex;
        }
        
        .align-items-start {
            align-items: flex-start;
        }
        
        .me-3 {
            margin-right: 1rem;
        }
        
        .flex-grow-1 {
            flex: 1;
        }
        
        .ms-auto {
            margin-left: auto;
        }
        
        .mt-4 {
            margin-top: 1.5rem;
        }
        
        .text-primary-600 {
            color: #c8945f;
        }
        
        .text-warning-main {
            color: #f59e0b;
        }
        
        .text-success-main {
            color: #059669;
        }
        
        .text-info-main {
            color: #0ea5e9;
        }
        
        .form-check-input {
            margin-top: 0.25em;
        }
    </style>
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
        <div class="dlab-bnr-inr overlay-primary bg-pt" style="background-image: url(${pageContext.request.contextPath}/assets/home/images/banner/bnr2.jpg);">
          <div class="container">
            <div class="dlab-bnr-inr-entry">
              <h1 class="text-white">Đặt Dịch Vụ</h1>
              <!-- Breadcrumb row -->
              <div class="breadcrumb-row">
                <ul class="list-inline">
                  <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                  <li><a href="${pageContext.request.contextPath}/customer-dashboard">Bảng Điều Khiển</a></li>
                  <li>Đặt Dịch Vụ</li>
                </ul>
              </div>
              <!-- Breadcrumb row END -->
            </div>
          </div>
        </div>
        <!-- inner page banner END -->
        
        <!-- booking area -->
        <div class="section-full content-inner shop-account">
          <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-12 text-center">
                    <h3 class="font-weight-700 m-t0 m-b20">Chọn Loại Dịch Vụ</h3>
                </div>
            </div>
            <div class="row justify-content-center">
                <div class="col-lg-8 col-xl-6">
                        <div class="p-a30 border-1 seth">
                            <!-- Main Title -->
                            <h4 class="font-weight-700 text-center">CHỌN MỘT TÙY CHỌN</h4>
                            <p class="font-weight-600 text-center">
                                Vui lòng chọn loại dịch vụ mà bạn muốn đặt.
                            </p>
                
                <form id="bookingSelectionForm" action="${pageContext.request.contextPath}/booking/process" method="post">
                    <!-- Booking Section -->
                    <div class="booking-section-title">Đặt</div>
                    
                    <div class="booking-option-card" data-option="individual">
                        <div class="d-flex align-items-start">
                            <div class="me-3">
                                <iconify-icon icon="solar:user-circle-outline" class="text-primary-600" style="font-size: 32px;"></iconify-icon>
                            </div>
                            <div class="flex-grow-1">
                                <div class="booking-option-title">Đặt lịch hẹn</div>
                                <div class="booking-option-description">Đặt lịch nhận dịch vụ cho chính mình</div>
                            </div>
                            <div class="ms-auto">
                                <input type="radio" name="bookingType" value="individual" class="form-check-input">
                            </div>
                        </div>
                    </div>
                    
                    <div class="booking-option-card" data-option="group">
                        <div class="d-flex align-items-start">
                            <div class="me-3">
                                <iconify-icon icon="solar:users-group-rounded-outline" class="text-primary-600" style="font-size: 32px;"></iconify-icon>
                            </div>
                            <div class="flex-grow-1">
                                <div class="booking-option-title">Đặt lịch hẹn theo nhóm</div>
                                <div class="booking-option-description">Cho bạn thân và những người khác</div>
                            </div>
                            <div class="ms-auto">
                                <input type="radio" name="bookingType" value="group" class="form-check-input">
                            </div>
                        </div>
                    </div>
                    
                    <!-- Purchase Section -->
                    <div class="booking-section-title mt-4">Mua</div>
                    
                    <div class="booking-option-card" data-option="membership">
                        <div class="d-flex align-items-start">
                            <div class="me-3">
                                <iconify-icon icon="solar:crown-outline" class="text-warning-main" style="font-size: 32px;"></iconify-icon>
                            </div>
                            <div class="flex-grow-1">
                                <div class="booking-option-title">Gói hội viên</div>
                                <div class="booking-option-description">Thêm các dịch vụ của bạn vào gói hội viên</div>
                            </div>
                            <div class="ms-auto">
                                <input type="radio" name="bookingType" value="membership" class="form-check-input">
                            </div>
                        </div>
                    </div>
                    
                    <div class="booking-option-card" data-option="giftcard">
                        <div class="d-flex align-items-start">
                            <div class="me-3">
                                <iconify-icon icon="solar:gift-outline" class="text-success-main" style="font-size: 32px;"></iconify-icon>
                            </div>
                            <div class="flex-grow-1">
                                <div class="booking-option-title">Thẻ quà tặng</div>
                                <div class="booking-option-description">Hãy tự thưởng cho mình hoặc khao bạn bè bằng những buổi hẹn trong tương lai</div>
                            </div>
                            <div class="ms-auto">
                                <input type="radio" name="bookingType" value="giftcard" class="form-check-input">
                            </div>
                        </div>
                    </div>
                    
                    <div class="booking-option-card" data-option="products">
                        <div class="d-flex align-items-start">
                            <div class="me-3">
                                <iconify-icon icon="solar:bag-smile-outline" class="text-info-main" style="font-size: 32px;"></iconify-icon>
                            </div>
                            <div class="flex-grow-1">
                                <div class="booking-option-title">Sản phẩm</div>
                                <div class="booking-option-description">Mua sản phẩm trực tuyến</div>
                            </div>
                            <div class="ms-auto">
                                <input type="radio" name="bookingType" value="products" class="form-check-input">
                            </div>
                        </div>
                    </div>
                    
                                                          <!-- Continue Button -->
                              <div class="text-center">
                                  <button type="submit" class="button-lg radius-no" id="continueBtn" disabled
                                          style="background-color: #586BB4; color: white; border: none; padding: 12px 30px; font-weight: 600; text-transform: uppercase; margin-right: 5px; cursor: pointer; transition: all 0.3s ease;">
                                      Tiếp tục <i class="fa fa-arrow-right" style="margin-left: 10px;"></i>
                                  </button>
                              </div>
                        </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- booking area END -->
      </div>
      <!-- Content END-->
      
      <!-- Footer -->
      <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
      <!-- Footer END -->
      <button class="scroltop fa fa-chevron-up"></button>
    </div>
    
    <!-- Include Home Framework JavaScript -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp" />
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const bookingCards = document.querySelectorAll('.booking-option-card');
            const radioButtons = document.querySelectorAll('input[name="bookingType"]');
            const continueBtn = document.getElementById('continueBtn');
            
            // Handle card clicks
            bookingCards.forEach(card => {
                card.addEventListener('click', function() {
                    const option = this.getAttribute('data-option');
                    const radioButton = this.querySelector('input[type="radio"]');
                    
                    // Remove selected class from all cards
                    bookingCards.forEach(c => c.classList.remove('selected'));
                    
                    // Add selected class to clicked card
                    this.classList.add('selected');
                    
                    // Check the radio button
                    radioButton.checked = true;
                    
                    // Enable continue button
                    continueBtn.disabled = false;
                });
            });
            
            // Handle radio button changes
            radioButtons.forEach(radio => {
                radio.addEventListener('change', function() {
                    if (this.checked) {
                        continueBtn.disabled = false;
                        
                        // Update card selection
                        bookingCards.forEach(card => {
                            card.classList.remove('selected');
                            if (card.getAttribute('data-option') === this.value) {
                                card.classList.add('selected');
                            }
                        });
                    }
                });
            });
            
            // Handle form submission
            document.getElementById('bookingSelectionForm').addEventListener('submit', function(e) {
                const selectedOption = document.querySelector('input[name="bookingType"]:checked');
                if (!selectedOption) {
                    e.preventDefault();
                    alert('Vui lòng chọn một tùy chọn');
                    return;
                }
                
                // Allow form to submit normally
                // Server-side redirect will handle the routing
            });
        });
    </script>
</body>
</html> 