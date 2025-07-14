<%-- Document : header Created on : May 25, 2025, 4:22:29 PM Author : quang --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.MenuService" %>
<%@ page import="model.RoleConstants" %>
<%@ page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%-- Header-specific CSS has been moved to /assets/home/css/header-custom.css for better maintainability --%>

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
            <c:choose>
                <%-- Customer is logged in --%>
                <c:when test="${not empty sessionScope.customer}">
                    <%-- Show "Đặt lịch ngay" button for customers --%>
                    <div class="booking-button-container">
                        <a href="${pageContext.request.contextPath}/process-booking/resume" class="site-button radius-no">ĐẶT LỊCH NGAY</a>
                        <span class="booking-service-badge" id="bookingServiceBadge" style="display: none;">0</span>
                    </div>
                    
                    <%
                        // Get customer menu items using MenuService
                        List<MenuService.MenuItem> customerMenuItems = MenuService.getCustomerMenuItems(pageContext.getServletContext().getContextPath());
                        request.setAttribute("menuItems", customerMenuItems);
                    %>
                    <div class="user-avatar-container">
                        <button type="button" class="user-avatar-button icon-avatar customer-avatar" id="customerAvatarButton" aria-haspopup="true" aria-expanded="false">
                            <i class="fa fa-user"></i>
                        </button>
                        <div class="avatar-dropdown admin-style-dropdown" id="customerAvatarDropdown" aria-labelledby="customerAvatarButton">
                            <c:if test="${not empty sessionScope.customer.fullName}">
                                <div class="dropdown-header-admin">
                                    <div class="d-flex align-items-center gap-2">
                                        <div>
                                            <h6 class="mb-0 fw-semibold text-neutral-900">Chào, ${sessionScope.customer.fullName}</h6>
                                            <span class="text-xs text-secondary-light">Khách hàng</span>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:forEach var="menuItem" items="${menuItems}">
                                <c:choose>
                                    <c:when test="${menuItem.divider}">
                                        <div class="dropdown-divider-admin"></div>
                                    </c:when>
                                    <%-- Skip section headers (items with null URL) and only show actual menu items --%>
                                    <c:when test="${not empty menuItem.url and not empty menuItem.label}">
                                        <a href="${menuItem.url}" class="dropdown-item-admin">
                                            <div class="d-flex align-items-center gap-3">
                                                <iconify-icon icon="${menuItem.icon}" class="text-lg text-secondary-light"></iconify-icon>
                                                <span class="fw-medium text-neutral-900">${menuItem.label}</span>
                                            </div>
                                        </a>
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                        </div>
                    </div>
                    <button type="button" class="user-notification-button">
                        <i class="fa fa-bell"></i>
                    </button>
                </c:when>
                
                <%-- User (admin/manager/staff) is logged in --%>
                <c:when test="${not empty sessionScope.user}">
                    <%-- No booking button for staff members --%>
                    <%
                        // Get user role name and menu items using MenuService
                        model.User user = (model.User) session.getAttribute("user");
                        String roleName = null;
                        if (user != null && user.getRoleId() != null) {
                            switch (user.getRoleId()) {
                                case RoleConstants.ADMIN_ID:
                                    roleName = "ADMIN";
                                    break;
                                case RoleConstants.MANAGER_ID:
                                    roleName = "MANAGER";
                                    break;
                                case RoleConstants.THERAPIST_ID:
                                    roleName = "THERAPIST";
                                    break;
                                case RoleConstants.RECEPTIONIST_ID:
                                    roleName = "RECEPTIONIST";
                                    break;
                                default:
                                    roleName = "ADMIN"; // Default fallback
                            }
                        }
                        
                        List<MenuService.MenuItem> userMenuItems = MenuService.getMenuItemsByRole(roleName, pageContext.getServletContext().getContextPath());
                        request.setAttribute("userMenuItems", userMenuItems);
                        
                        // Set avatar color and role display text based on role
                        String avatarColor = "#DC2626"; // Default red
                        String avatarText = "U";
                        String roleDisplayText = "Nhân viên"; // Default
                        if (roleName != null) {
                            switch (roleName) {
                                case "ADMIN":
                                    avatarColor = "#DC2626"; // Red
                                    avatarText = "A";
                                    roleDisplayText = "Quản trị viên";
                                    break;
                                case "MANAGER":
                                    avatarColor = "#2563EB"; // Blue
                                    avatarText = "M";
                                    roleDisplayText = "Quản lý";
                                    break;
                                case "THERAPIST":
                                    avatarColor = "#059669"; // Green
                                    avatarText = "T";
                                    roleDisplayText = "Nhân viên trị liệu";
                                    break;
                                case "RECEPTIONIST":
                                    avatarColor = "#7C3AED"; // Purple
                                    avatarText = "R";
                                    roleDisplayText = "Nhân viên lễ tân";
                                    break;
                            }
                        }
                        request.setAttribute("avatarColor", avatarColor);
                        request.setAttribute("avatarText", avatarText);
                        request.setAttribute("roleDisplayText", roleDisplayText);
                    %>
                    <div class="user-avatar-container">
                        <button type="button" class="user-avatar-button icon-avatar user-avatar" id="userAvatarButton" aria-haspopup="true" aria-expanded="false" data-role="${roleName}">
                            <%
                                // Use same user icon for all roles
                                String roleIcon = "fa-user";
                                request.setAttribute("roleIcon", roleIcon);
                            %>
                            <i class="fa ${roleIcon}"></i>
                        </button>
                        <div class="avatar-dropdown admin-style-dropdown" id="userAvatarDropdown" aria-labelledby="userAvatarButton">
                            <c:if test="${not empty sessionScope.user.fullName}">
                                <div class="dropdown-header-admin">
                                    <div class="d-flex align-items-center gap-2">
                                        <div>
                                            <h6 class="mb-0 fw-semibold text-neutral-900">Chào, ${sessionScope.user.fullName}</h6>
                                            <span class="text-xs text-secondary-light">${roleDisplayText}</span>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            
                            <c:forEach var="menuItem" items="${userMenuItems}">
                                <c:choose>
                                    <c:when test="${menuItem.divider}">
                                        <div class="dropdown-divider-admin"></div>
                                    </c:when>
                                    <%-- Skip section headers (items with null URL) and only show actual menu items --%>
                                    <c:when test="${not empty menuItem.url and not empty menuItem.label}">
                                        <a href="${menuItem.url}" class="dropdown-item-admin">
                                            <div class="d-flex align-items-center gap-3">
                                                <iconify-icon icon="${menuItem.icon}" class="text-lg text-secondary-light"></iconify-icon>
                                                <span class="fw-medium text-neutral-900">${menuItem.label}</span>
                                            </div>
                                        </a>
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                        </div>
                    </div>
                    <button type="button" class="user-notification-button">
                        <i class="fa fa-bell"></i>
                    </button>
                </c:when>
                
                <%-- No one is logged in (guests) --%>
                <c:otherwise>
                    <%-- Show "Đặt lịch ngay" button for guests --%>
                    <div class="booking-button-container">
                        <a href="${pageContext.request.contextPath}/process-booking/resume" class="site-button radius-no">ĐẶT LỊCH NGAY</a>
                        <span class="booking-service-badge booking-service-badge-guest" style="display: none;">0</span>
                    </div>
                    
                    <a href="${pageContext.request.contextPath}/login" class="site-button radius-no" style="margin-left: 10px; width: 120px;">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register" class="site-button radius-no" style="margin-left: 5px; width: 120px;">Đăng ký</a>
                </c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="header-nav navbar-collapse collapse justify-content-end" id="navbarNavDropdown">
          <ul class="nav navbar-nav">
            <%-- Your existing menu items --%>

            <li>
              <a href="${pageContext.request.contextPath}/spa-info">About us</a>
              
            </li>


            <li>
              <%-- <a href="javascript:void(0);">Pages <i class="fa fa-chevron-down"></i></a> --%>
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

<%-- Header JavaScript has been moved to /assets/home/js/header-custom.js for better maintainability --%>
