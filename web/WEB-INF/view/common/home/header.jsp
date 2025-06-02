<%-- Document : header Created on : May 25, 2025, 4:22:29 PM Author : quang --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<style>
  /* Basic styling for the avatar and dropdown */
  /* You should integrate this with your theme's CSS */
  .user-avatar-container {
    position: relative;
    display: inline-block; /* Aligns with the button */
    vertical-align: middle; /* Aligns with the button */
    margin-left: 15px; /* Space between button and avatar */
  }

  .user-avatar-button {
    background: transparent;
    border: none;
    padding: 0;
    cursor: pointer;
    display: block; /* Ensures image is block for consistent behavior */
  }

  .user-avatar-button img {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid #fff; /* Example border, adjust to your theme */
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
  }

  .avatar-dropdown {
    display: none; /* Hidden by default */
    position: absolute;
    right: 0;
    top: 100%;
    margin-top: 8px; /* Space below avatar */
    background-color: #ffffff;
    border: 1px solid #e0e0e0; /* Theme-like border */
    border-radius: 4px; /* Rounded corners */
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    z-index: 1050; /* Ensure it's above other elements, Bootstrap's dropdown z-index is often 1000+ */
    min-width: 180px; /* Minimum width for dropdown items */
    padding-top: 5px;
    padding-bottom: 5px;
  }

  .avatar-dropdown a {
    display: block;
    padding: 8px 15px;
    color: #333; /* Standard text color */
    text-decoration: none;
    font-size: 14px;
    white-space: nowrap;
  }

  .avatar-dropdown a:hover {
    background-color: #f5f5f5; /* Hover effect */
    color: #000;
  }

  /* Ensure the extra-cell items are aligned nicely */
  .extra-nav .extra-cell {
    display: flex;
    align-items: center;
  }
</style>

<header class="site-header header header-transparent mo-left spa-header">
  <div class="sticky-header main-bar-wraper navbar-expand-lg">
    <div class="main-bar clearfix">
      <div class="container clearfix">
        <div class="logo-header mostion">
          <a href="${pageContext.request.contextPath}/" class="dez-page">
            <img src="${pageContext.request.contextPath}/assets/home/images/logo-4.png" alt="Site Logo" />
          </a>
        </div>
        <button
          class="navbar-toggler collapsed navicon justify-content-end"
          type="button"
          data-toggle="collapse"
          data-target="#navbarNavDropdown"
          aria-controls="navbarNavDropdown"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          <span></span>
          <span></span>
          <span></span>
        </button>

        <div class="extra-nav">
          <div class="extra-cell">
            <a href="booking.html" class="site-button radius-no">ĐẶT LỊCH NGAY</a>
            
            <c:choose>
    <%-- Customer is logged in --%>
    <c:when test="${not empty sessionScope.customer}">
        <div class="user-avatar-container">
            <button type="button" class="user-avatar-button" id="customerAvatarButton" aria-haspopup="true" aria-expanded="false">
                <img src="https://placehold.co/40x40/7C3AED/FFFFFF?text=C" alt="Customer Avatar">
            </button>
            <div class="avatar-dropdown" id="customerAvatarDropdown" aria-labelledby="customerAvatarButton">
                <c:if test="${not empty sessionScope.customer.fullName}">
                    <div style="padding: 8px 15px; font-weight: bold; border-bottom: 1px solid #eee; margin-bottom: 5px;">Chào, ${sessionScope.customer.fullName}</div>
                </c:if>
                <a href="${pageContext.request.contextPath}/customer/profile">Hồ sơ của bạn</a>
                <a href="${pageContext.request.contextPath}/customer/bookings">Lịch sử đặt lịch</a>
                <a href="${pageContext.request.contextPath}/customer/settings">Cài đặt</a>
                <div style="height: 1px; background-color: #eee; margin: 5px 0;"></div>
                <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
            </div>
        </div>
        <button type="button" class="user-notification-button" style="background: transparent; border: none; margin-left: 10px; position: relative;">
            <i class="fa fa-bell" style="font-size: 22px; color: #7C3AED;"></i>
            <%-- <span class="notification-badge">3</span> --%>
        </button>
    </c:when>
    <%-- User (admin/manager/staff) is logged in --%>
    <c:when test="${not empty sessionScope.user}">
        <div class="user-avatar-container">
            <button type="button" class="user-avatar-button" id="userAvatarButton" aria-haspopup="true" aria-expanded="false">
                <img src="https://placehold.co/40x40/DC2626/FFFFFF?text=U" alt="User Avatar">
            </button>
            <div class="avatar-dropdown" id="userAvatarDropdown" aria-labelledby="userAvatarButton">
                <c:if test="${not empty sessionScope.user.fullName}">
                    <div style="padding: 8px 15px; font-weight: bold; border-bottom: 1px solid #eee; margin-bottom: 5px;">Chào, ${sessionScope.user.fullName}</div>
                </c:if>
                <a href="${pageContext.request.contextPath}/admin/profile">Hồ sơ cá nhân</a>
                <a href="${pageContext.request.contextPath}/admin/dashboard">Bảng điều khiển</a>
                <a href="${pageContext.request.contextPath}/admin/settings">Cài đặt</a>
                <div style="height: 1px; background-color: #eee; margin: 5px 0;"></div>
                <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
            </div>
        </div>
        <button type="button" class="user-notification-button" style="background: transparent; border: none; margin-left: 10px; position: relative;">
            <i class="fa fa-bell" style="font-size: 22px; color: #DC2626;"></i>
            <%-- <span class="notification-badge">5</span> --%>
        </button>
    </c:when>
    <%-- No one is logged in --%>
    <c:otherwise>
        <a href="${pageContext.request.contextPath}/login" class=" site-button radius-no" style="margin-left: 10px; width: 120px;">Đăng nhập</a>
        <a href="${pageContext.request.contextPath}/register" class="site-button radius-no" style="margin-left: 5px; width: 120px;">Đăng ký</a>
    </c:otherwise>
</c:choose>
          </div>
        </div>

        <div class="header-nav navbar-collapse collapse justify-content-end" id="navbarNavDropdown">
          <ul class="nav navbar-nav">
            <%-- Your existing menu items --%>
            <li>
              <a href="javascript:void(0);">Pages <i class="fa fa-chevron-down"></i></a>
              <ul class="sub-menu">
                <li>
                  <a href="${pageContext.request.contextPath}/login" class="dez-page">ĐĂNG NHẬP</a>
<!--                  <ul class="sub-menu">
                    <li><a href="header-1.html" class="dez-page">Header 1</a></li>
                    <li><a href="header-2.html" class="dez-page">Header 2</a></li>
                  </ul>-->
                </li>
                <li><a href="${pageContext.request.contextPath}/register" class="dez-page">ĐĂNG KÝ</a></li>
                <%-- Add other page links here --%>
              </ul>
            </li>
            <li>
              <a href="javascript:void(0);">Dịch Vụ <i class="fa fa-chevron-down"></i></a>
              <ul class="sub-menu">
                <li><a href="service.html" class="dez-page">Services</a></li>
                <li><a href="services-details.html" class="dez-page">Services Details</a></li>
              </ul>
            </li>
            <li class="sub-menu-down">
              <a href="javascript:void(0);">Blog <i class="fa fa-chevron-down"></i></a>
              <ul class="sub-menu">
                <li>
                  <a href="javascript:void();">Page Layout <i class="fa fa-angle-right"></i></a>
                  <ul class="sub-menu">
                    <li><a href="blog-list.html">Blog List</a></li>
                  </ul>
                </li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
  </header>

<script>
  // JavaScript for Avatar Dropdown Toggle
  document.addEventListener('DOMContentLoaded', function() {
    // Handle Customer Avatar Dropdown
    const customerAvatarButton = document.getElementById('customerAvatarButton');
    const customerAvatarDropdown = document.getElementById('customerAvatarDropdown');

    if (customerAvatarButton && customerAvatarDropdown) {
      customerAvatarButton.addEventListener('click', function(event) {
        event.stopPropagation();
        const isExpanded = customerAvatarButton.getAttribute('aria-expanded') === 'true';
        customerAvatarDropdown.style.display = isExpanded ? 'none' : 'block';
        customerAvatarButton.setAttribute('aria-expanded', !isExpanded);
      });
    }

    // Handle User Avatar Dropdown
    const userAvatarButton = document.getElementById('userAvatarButton');
    const userAvatarDropdown = document.getElementById('userAvatarDropdown');

    if (userAvatarButton && userAvatarDropdown) {
      userAvatarButton.addEventListener('click', function(event) {
        event.stopPropagation();
        const isExpanded = userAvatarButton.getAttribute('aria-expanded') === 'true';
        userAvatarDropdown.style.display = isExpanded ? 'none' : 'block';
        userAvatarButton.setAttribute('aria-expanded', !isExpanded);
      });
    }

    // Close dropdown if clicked outside (for both customer and user)
    document.addEventListener('click', function(event) {
      // Close customer dropdown
      if (customerAvatarDropdown && customerAvatarDropdown.style.display === 'block' && 
          !customerAvatarButton.contains(event.target) && 
          !customerAvatarDropdown.contains(event.target)) {
        customerAvatarDropdown.style.display = 'none';
        customerAvatarButton.setAttribute('aria-expanded', 'false');
      }
      
      // Close user dropdown
      if (userAvatarDropdown && userAvatarDropdown.style.display === 'block' && 
          !userAvatarButton.contains(event.target) && 
          !userAvatarDropdown.contains(event.target)) {
        userAvatarDropdown.style.display = 'none';
        userAvatarButton.setAttribute('aria-expanded', 'false');
      }
    });

    // Close dropdown with Escape key (for both customer and user)
    document.addEventListener('keydown', function(event) {
      if (event.key === 'Escape') {
        if (customerAvatarDropdown && customerAvatarDropdown.style.display === 'block') {
          customerAvatarDropdown.style.display = 'none';
          customerAvatarButton.setAttribute('aria-expanded', 'false');
        }
        if (userAvatarDropdown && userAvatarDropdown.style.display === 'block') {
          userAvatarDropdown.style.display = 'none';
          userAvatarButton.setAttribute('aria-expanded', 'false');
        }
      }
    });
  });
</script>
