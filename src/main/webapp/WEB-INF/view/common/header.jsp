<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%@page
contentType="text/html" pageEncoding="UTF-8"%>

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
            <a
              href="<c:url value='/index'/>"
              class="text-spa-dark hover:text-primary transition-colors font-medium border-b-2 border-primary"
              >Trang chủ</a
            >
            <a
              href="<c:url value='/about'/>"
              class="text-spa-dark hover:text-primary transition-colors font-medium"
              >Giới thiệu</a
            >
            <a
              href="<c:url value='/services'/>"
              class="text-spa-dark hover:text-primary transition-colors font-medium"
              >Dịch vụ</a
            >
            <a
              href="<c:url value='/promotions'/>"
              class="text-spa-dark hover:text-primary transition-colors font-medium"
              >Khuyến mãi</a
            >
            <a
              href="<c:url value='/booking'/>"
              class="text-spa-dark hover:text-primary transition-colors font-medium"
              >Đặt lịch</a
            >
            <a
              href="<c:url value='/contact'/>"
              class="text-spa-dark hover:text-primary transition-colors font-medium"
              >Liên hệ</a
            >
          </nav>

          <!-- User Actions -->
          <div class="flex items-center space-x-4">
            
            <c:choose>
              <c:when test="${not empty sessionScope.authenticated and sessionScope.authenticated}">
                  
                  <c:choose>
                      <c:when test="${not empty sessionScope.customer}">
                          <a href="<c:url value='/customer/dashboard'/>" class="text-spa-dark hover:text-primary transition-colors font-medium">Tài khoản</a>
                      </c:when>
                      <c:when test="${not empty sessionScope.user}">
                           <a href="<c:url value='/admin/dashboard'/>" class="text-spa-dark hover:text-primary transition-colors font-medium">Dashboard</a>
                      </c:when>
                      <c:otherwise>
                          <a href="#" class="text-spa-dark hover:text-primary transition-colors font-medium">Tài khoản</a>
                      </c:otherwise>
                  </c:choose>
                  
                  <a href="<c:url value='/logout'/>" class="bg-primary text-white px-4 py-2 rounded-full hover:bg-primary-dark transition-colors">Đăng xuất</a>

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
            <a
              href="<c:url value='/index'/>"
              class="block py-2 text-spa-dark hover:text-primary"
              >Trang chủ</a
            >
            <a
              href="<c:url value='/about'/>"
              class="block py-2 text-spa-dark hover:text-primary"
              >Giới thiệu</a
            >
            <a
              href="<c:url value='/services'/>"
              class="block py-2 text-spa-dark hover:text-primary"
              >Dịch vụ</a
            >
            <a
              href="<c:url value='/promotions'/>"
              class="block py-2 text-spa-dark hover:text-primary"
              >Khuyến mãi</a
            >
            <a
              href="<c:url value='/booking'/>"
              class="block py-2 text-spa-dark hover:text-primary"
              >Đặt lịch</a
            >
            <a
              href="<c:url value='/contact'/>"
              class="block py-2 text-spa-dark hover:text-primary"
              >Liên hệ</a
            >
            <div class="border-t border-gray-200 pt-4 mt-4 space-y-2">
                 <c:choose>
                    <c:when test="${not empty sessionScope.authenticated and sessionScope.authenticated}">
                        <c:choose>
                            <c:when test="${not empty sessionScope.customer}">
                                <a href="<c:url value='/customer/dashboard'/>" class="block py-2 text-spa-dark hover:text-primary">Tài khoản</a>
                            </c:when>
                             <c:when test="${not empty sessionScope.user}">
                                <a href="<c:url value='/admin/dashboard'/>" class="block py-2 text-spa-dark hover:text-primary">Dashboard</a>
                            </c:when>
                        </c:choose>
                        <a href="<c:url value='/logout'/>" class="block py-2 text-spa-dark hover:text-primary">Đăng xuất</a>
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