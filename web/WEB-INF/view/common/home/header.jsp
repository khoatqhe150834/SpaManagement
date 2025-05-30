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
            
            <c:if test="${not empty sessionScope.user}">
              <div class="user-avatar-container">
                <button type="button" class="user-avatar-button" id="userAvatarButton" aria-haspopup="true" aria-expanded="false">
                  <c:choose>
                    <c:when test="${not empty sessionScope.user.avatarUrl}">
                      <img src="${pageContext.request.contextPath}${sessionScope.user.avatarUrl}" alt="User Avatar"
                           onerror="this.onerror=null; this.src='https://placehold.co/40x40/7C3AED/FFFFFF?text=U';">
                    </c:when>
                    <c:otherwise>
                      <img src="https://placehold.co/40x40/7C3AED/FFFFFF?text=U" alt="Default Avatar"
                           onerror="this.onerror=null; this.src='https://placehold.co/40x40/CCCCCC/FFFFFF?text=Error';">
                    </c:otherwise>
                  </c:choose>
                </button>
                <div class="avatar-dropdown" id="userAvatarDropdown" aria-labelledby="userAvatarButton">
                  <%-- Dropdown content is always generated if avatar is shown, as it's part of the logged-in state --%>
                  <c:if test="${not empty sessionScope.user.name}">
                     <div style="padding: 8px 15px; font-weight: bold; border-bottom: 1px solid #eee; margin-bottom: 5px;">Chào, ${sessionScope.user.name}</div>
                  </c:if>
                  <a href="${pageContext.request.contextPath}/user/profile">Hồ sơ của bạn</a>
                  <a href="${pageContext.request.contextPath}/user/bookings">Lịch sử đặt lịch</a>
                  <a href="${pageContext.request.contextPath}/user/settings">Cài đặt</a>
                  <div style="height: 1px; background-color: #eee; margin: 5px 0;"></div> <%-- Separator --%>
                  <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                </div>
              </div>
            </c:if>
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
    const userAvatarButton = document.getElementById('userAvatarButton');
    const userAvatarDropdown = document.getElementById('userAvatarDropdown');

    // Only attach event listeners if the avatar button (and thus dropdown) exists in the DOM
    if (userAvatarButton && userAvatarDropdown) {
      userAvatarButton.addEventListener('click', function(event) {
        event.stopPropagation(); // Prevent this click from immediately closing the dropdown via the window click listener
        const isExpanded = userAvatarButton.getAttribute('aria-expanded') === 'true';
        userAvatarDropdown.style.display = isExpanded ? 'none' : 'block';
        userAvatarButton.setAttribute('aria-expanded', !isExpanded);
      });

      // Close dropdown if clicked outside
      document.addEventListener('click', function(event) {
        // Check if dropdown is visible and click is outside both button and dropdown
        if (userAvatarDropdown.style.display === 'block' && 
            !userAvatarButton.contains(event.target) && 
            !userAvatarDropdown.contains(event.target)) {
          userAvatarDropdown.style.display = 'none';
          userAvatarButton.setAttribute('aria-expanded', 'false');
        }
      });

      // Optional: Close dropdown with Escape key
      document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape' && userAvatarDropdown.style.display === 'block') {
          userAvatarDropdown.style.display = 'none';
          userAvatarButton.setAttribute('aria-expanded', 'false');
        }
      });
    }
  });
</script>
