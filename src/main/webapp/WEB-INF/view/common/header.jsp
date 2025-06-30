<%@ page import="model.MenuService" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MenuService.MenuItem" %>
<%@ page import="model.RoleConstants" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%@page
contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Determine the current page's path for active link highlighting
    String currentPath = request.getServletPath();

    // Get the main navigation menu items
    List<MenuItem> mainNavItems = MenuService.getMainNavigationMenuItems(request.getContextPath());
    pageContext.setAttribute("mainNavItems", mainNavItems);

    // Get user-specific menu items if logged in
    List<MenuItem> userMenuItems = null;
    String userRole = null;
    if (session.getAttribute("authenticated") != null && (Boolean)session.getAttribute("authenticated")) {
        if (session.getAttribute("customer") != null) {
            userRole = "CUSTOMER";
        } else if (session.getAttribute("user") != null) {
            model.User user = (model.User) session.getAttribute("user");
            userRole = RoleConstants.getUserTypeFromRole(user.getRoleId());
        }
        if (userRole != null) {
            userMenuItems = MenuService.getMenuItemsByRole(userRole, request.getContextPath());
        }
    }
    pageContext.setAttribute("userMenuItems", userMenuItems);
    pageContext.setAttribute("currentPath", currentPath);
%>

<!-- Header -->
    <header
      id="header"
      class="fixed top-0 left-0 w-full bg-white/95 backdrop-blur-sm border-b border-gray-200 z-50 transition-all duration-300"
    >
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center py-4">
          <!-- Logo -->
          <div class="flex items-center">
            <div class="text-2xl font-serif font-bold text-primary">
              Spa Hương Sen
            </div>
          </div>

          <!-- Navigation -->
          <nav class="hidden md:flex space-x-8">
            <c:forEach var="item" items="${mainNavItems}">
              <a
                href="${item.url}"
                class="text-spa-dark hover:text-primary transition-colors font-medium <c:if test='${item.url.endsWith(currentPath)}'>border-b-2 border-primary</c:if>"
                >${item.label}</a>
            </c:forEach>
          </nav>

          <!-- User Actions -->
          <div class="flex items-center space-x-4">
            
            <c:choose>
              <c:when test="${not empty sessionScope.authenticated and sessionScope.authenticated}">
                  
                  <!-- User Avatar Dropdown -->
                  <div class="relative" id="user-dropdown">
                    <button type="button" class="flex items-center space-x-2 text-sm rounded-full focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary" id="user-menu-button" aria-expanded="false">
                      <span class="sr-only">Mở menu người dùng</span>
                      <!-- Avatar -->
                      <div class="relative">
                        <c:choose>
                          <%-- Check for customer avatar safely --%>
                          <c:when test="${not empty sessionScope.customer and not empty sessionScope.customer.avatarUrl}">
                            <img class="h-8 w-8 rounded-full object-cover border-2 border-primary" 
                                 src="<c:url value='${sessionScope.customer.avatarUrl}'/>" 
                                 alt="Avatar">
                          </c:when>
                          <%-- Check for user avatar safely --%>
                          <c:when test="${not empty sessionScope.user and not empty sessionScope.user.avatarUrl}">
                            <img class="h-8 w-8 rounded-full object-cover border-2 border-primary" 
                                 src="<c:url value='${sessionScope.user.avatarUrl}'/>" 
                                 alt="Avatar">
                          </c:when>
                          <%-- Otherwise, show default initial --%>
                          <c:otherwise>
                            <div class="h-8 w-8 rounded-full bg-primary flex items-center justify-center text-white font-semibold text-sm border-2 border-primary">
                              <c:choose>
                                <c:when test="${not empty sessionScope.customer and not empty sessionScope.customer.fullName}">
                                  ${sessionScope.customer.fullName.substring(0,1).toUpperCase()}
                                </c:when>
                                <c:when test="${not empty sessionScope.user and not empty sessionScope.user.fullName}">
                                  ${sessionScope.user.fullName.substring(0,1).toUpperCase()}
                                </c:when>
                                <c:otherwise>U</c:otherwise>
                              </c:choose>
                            </div>
                          </c:otherwise>
                        </c:choose>
                        <!-- Online status indicator -->
                        <span class="absolute bottom-0 right-0 block h-2 w-2 rounded-full bg-green-400 ring-2 ring-white"></span>
                      </div>
                      <!-- User name and chevron -->
                      <div class="hidden sm:flex items-center space-x-1">
                        <span class="text-spa-dark font-medium">
                          <c:choose>
                            <c:when test="${not empty sessionScope.customer}">
                              ${sessionScope.customer.fullName}
                            </c:when>
                            <c:when test="${not empty sessionScope.user}">
                              ${sessionScope.user.fullName}
                            </c:when>
                            <c:otherwise>Người dùng</c:otherwise>
                          </c:choose>
                        </span>
                        <i data-lucide="chevron-down" class="h-4 w-4 text-gray-400"></i>
                      </div>
                    </button>

                    <!-- Dropdown menu -->
                    <div class="absolute right-0 z-10 mt-2 w-56 origin-top-right rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none hidden" id="user-dropdown-menu" role="menu" aria-orientation="vertical" aria-labelledby="user-menu-button" tabindex="-1">
                      <div class="py-1" role="none">
                        <!-- User info section -->
                        <div class="px-4 py-3 border-b border-gray-200">
                          <p class="text-sm text-gray-900 font-medium">
                            <c:choose>
                              <c:when test="${not empty sessionScope.customer}">
                                ${sessionScope.customer.fullName}
                              </c:when>
                              <c:when test="${not empty sessionScope.user}">
                                ${sessionScope.user.fullName}
                              </c:when>
                            </c:choose>
                          </p>
                          <p class="text-sm text-gray-500 truncate">
                            <c:choose>
                              <c:when test="${not empty sessionScope.customer}">
                                ${sessionScope.customer.email}
                              </c:when>
                              <c:when test="${not empty sessionScope.user}">
                                ${sessionScope.user.email}
                              </c:when>
                            </c:choose>
                          </p>
                          <p class="text-xs text-primary font-medium mt-1">
                            <c:choose>
                              <c:when test="${not empty sessionScope.customer}">
                                Khách hàng
                              </c:when>
                              <c:when test="${not empty sessionScope.user}">
                                <c:set var="userRoleName" value="<%= RoleConstants.getUserTypeFromRole(((model.User)session.getAttribute(\"user\")).getRoleId()) %>" />
                                <c:choose>
                                  <c:when test="${userRoleName == 'ADMIN'}">Quản trị viên</c:when>
                                  <c:when test="${userRoleName == 'MANAGER'}">Quản lý</c:when>
                                  <c:when test="${userRoleName == 'THERAPIST'}">Nhân viên</c:when>
                                  <c:when test="${userRoleName == 'MARKETING'}">Marketing</c:when>
                                  <c:otherwise>Nhân viên</c:otherwise>
                                </c:choose>
                              </c:when>
                            </c:choose>
                          </p>
        </div>
                        
                        <!-- Menu items -->
                        <c:forEach var="item" items="${userMenuItems}">
                          <c:choose>
                            <c:when test="${item.divider}">
                              <div class="border-t border-gray-200 my-1"></div>
                            </c:when>
                            <c:otherwise>
                              <a href="${item.url}" class="flex items-center px-4 py-2 text-sm text-gray-700 hover:bg-gray-100" role="menuitem">
                                <i data-lucide="${item.icon}" class="mr-3 h-4 w-4"></i>
                                ${item.label}
                              </a>
                            </c:otherwise>
                          </c:choose>
                        </c:forEach>
                      </div>
                    </div>
      </div>
              </c:when>
              <c:otherwise>
                <a
                  href="<c:url value='/login'/>"
                  class="text-spa-dark hover:text-primary transition-colors"
                  >Đăng nhập</a
                >
                <a
                  href="<c:url value='/register'/>"
                  class="bg-primary text-white px-4 py-2 rounded-full hover:bg-primary-dark transition-colors"
                  >Đăng ký</a
                >
              </c:otherwise>
            </c:choose>

            <!-- Cart Icon -->
            <a href="<c:url value='/cart'/>" class="relative p-2 text-spa-dark hover:text-primary transition-colors">
              <i data-lucide="shopping-cart" class="w-6 h-6"></i>
              <span class="absolute inline-flex items-center justify-center w-5 h-5 text-xs font-bold text-white bg-red-500 border-2 border-white rounded-full -top-1 -right-1">3</span>
            </a>

            <!-- Mobile menu button -->
            <button id="mobile-menu-btn" class="md:hidden">
              <i data-lucide="menu" class="h-6 w-6"></i>
      </button>
    </div>
        </div>

        <!-- Mobile Navigation -->
        <div
          id="mobile-menu"
          class="md:hidden hidden border-t border-gray-200 py-4"
        >
          <nav class="space-y-2">
            <c:forEach var="item" items="${mainNavItems}">
              <a href="${item.url}" class="block py-2 text-spa-dark hover:text-primary">${item.label}</a>
            </c:forEach>
            
            <div class="border-t border-gray-200 pt-4 mt-4 space-y-2">
              <c:choose>
                <c:when test="${not empty sessionScope.authenticated and sessionScope.authenticated}">
                  <!-- Mobile User Info -->
                  <div class="px-2 py-2 border-b border-gray-200 mb-2">
                    <div class="flex items-center space-x-3">
                      <c:choose>
                        <%-- Check for customer avatar safely --%>
                        <c:when test="${not empty sessionScope.customer and not empty sessionScope.customer.avatarUrl}">
                          <img class="h-10 w-10 rounded-full object-cover border-2 border-primary" 
                               src="<c:url value='${sessionScope.customer.avatarUrl}'/>" 
                               alt="Avatar">
                        </c:when>
                        <%-- Check for user avatar safely --%>
                        <c:when test="${not empty sessionScope.user and not empty sessionScope.user.avatarUrl}">
                          <img class="h-10 w-10 rounded-full object-cover border-2 border-primary" 
                               src="<c:url value='${sessionScope.user.avatarUrl}'/>" 
                               alt="Avatar">
                        </c:when>
                        <%-- Otherwise, show default initial --%>
                        <c:otherwise>
                          <div class="h-10 w-10 rounded-full bg-primary flex items-center justify-center text-white font-semibold border-2 border-primary">
                            <c:choose>
                              <c:when test="${not empty sessionScope.customer and not empty sessionScope.customer.fullName}">
                                ${sessionScope.customer.fullName.substring(0,1).toUpperCase()}
                              </c:when>
                              <c:when test="${not empty sessionScope.user and not empty sessionScope.user.fullName}">
                                ${sessionScope.user.fullName.substring(0,1).toUpperCase()}
                              </c:when>
                              <c:otherwise>U</c:otherwise>
                            </c:choose>
                          </div>
                        </c:otherwise>
                      </c:choose>
                      <div>
                        <p class="text-sm font-medium text-spa-dark">
                          <c:choose>
                            <c:when test="${not empty sessionScope.customer}">
                              ${sessionScope.customer.fullName}
                            </c:when>
                            <c:when test="${not empty sessionScope.user}">
                              ${sessionScope.user.fullName}
                            </c:when>
                          </c:choose>
                        </p>
                        <p class="text-xs text-primary">
                          <c:choose>
                            <c:when test="${not empty sessionScope.customer}">
                              Khách hàng
                            </c:when>
                            <c:when test="${not empty sessionScope.user}">
                              <c:set var="userRoleName" value="<%= RoleConstants.getUserTypeFromRole(((model.User)session.getAttribute(\"user\")).getRoleId()) %>" />
                              <c:choose>
                                <c:when test="${userRoleName == 'ADMIN'}">Quản trị viên</c:when>
                                <c:when test="${userRoleName == 'MANAGER'}">Quản lý</c:when>
                                <c:when test="${userRoleName == 'THERAPIST'}">Nhân viên</c:when>
                                <c:when test="${userRoleName == 'MARKETING'}">Marketing</c:when>
                                <c:otherwise>Nhân viên</c:otherwise>
                              </c:choose>
                            </c:when>
                          </c:choose>
                        </p>
                      </div>
    </div>
                  </div>
                  
                  <c:forEach var="item" items="${userMenuItems}">
                    <c:if test="${not item.divider}">
                      <a href="${item.url}" class="block py-2 text-spa-dark hover:text-primary">${item.label}</a>
                    </c:if>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <a href="<c:url value='/login'/>" class="block py-2 text-spa-dark hover:text-primary">Đăng nhập</a>
                  <a href="<c:url value='/register'/>" class="block py-2 text-spa-dark hover:text-primary">Đăng ký</a>
                </c:otherwise>
              </c:choose>
  </div>
</nav>
        </div>
      </div>
    </header>

    <script>
      document.addEventListener("DOMContentLoaded", function () {
        const header = document.getElementById("header");
        const mobileMenuBtn = document.getElementById("mobile-menu-btn");
        const mobileMenu = document.getElementById("mobile-menu");

        // Header scroll effect
        window.addEventListener("scroll", function () {
          if (window.scrollY > 50) {
            header.classList.add("shadow-md");
          } else {
            header.classList.remove("shadow-md");
          }
        });

        // Mobile menu toggle
        mobileMenuBtn.addEventListener("click", function () {
          mobileMenu.classList.toggle("hidden");
        });

        // User Dropdown Toggle
        const userMenuButton = document.getElementById("user-menu-button");
        const userDropdownMenu = document.getElementById("user-dropdown-menu");

        if (userMenuButton && userDropdownMenu) {
          userMenuButton.addEventListener("click", function () {
            const isExpanded = userMenuButton.getAttribute("aria-expanded") === "true";
            userMenuButton.setAttribute("aria-expanded", !isExpanded);
            userDropdownMenu.classList.toggle("hidden");
            // Re-initialize icons if they are in the dropdown
            if(!isExpanded) {
              lucide.createIcons();
            }
          });

          // Close dropdown when clicking outside
          document.addEventListener("click", function (event) {
            if (userMenuButton && !userMenuButton.contains(event.target) && !userDropdownMenu.contains(event.target)) {
              userMenuButton.setAttribute("aria-expanded", "false");
              userDropdownMenu.classList.add("hidden");
            }
          });
        }
        
        // Initial call to create icons
        lucide.createIcons();
      });
    </script>
  </body>
</html>

