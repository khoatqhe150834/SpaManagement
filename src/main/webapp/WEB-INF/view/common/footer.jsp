<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%@page
contentType="text/html" pageEncoding="UTF-8"%>

<footer class="bg-gray-800 text-white">
  <div class="max-w-screen-xl px-4 py-8 mx-auto sm:px-6 lg:px-8">
    <div class="grid grid-cols-1 gap-8 lg:grid-cols-3">
      <div>
        <img
          src="../images/logo-white.png"
          class="h-10 mr-5"
          alt="Serenity Spa Logo"
        />
        <p class="max-w-xs mt-4 text-sm text-gray-400">
          Your sanctuary for peace and wellness. Experience ultimate relaxation
          with our professional spa services.
        </p>
        <div class="flex mt-8 space-x-6 text-gray-400">
          <a class="hover:opacity-75" href="#" target="_blank" rel="noreferrer">
            <span class="sr-only"> Facebook </span>
            <i data-lucide="facebook"></i>
          </a>
          <a class="hover:opacity-75" href="#" target="_blank" rel="noreferrer">
            <span class="sr-only"> Instagram </span>
            <i data-lucide="instagram"></i>
          </a>
          <a class="hover:opacity-75" href="#" target="_blank" rel="noreferrer">
            <span class="sr-only"> Twitter </span> <i data-lucide="twitter"></i>
          </a>
        </div>
      </div>
      <div class="grid grid-cols-2 gap-8 lg:col-span-2 sm:grid-cols-3">
        <div>
          <p class="font-medium">Services</p>
          <nav class="flex flex-col mt-4 space-y-2 text-sm text-gray-400">
            <a class="hover:opacity-75" href="services.html"> Massages </a>
            <a class="hover:opacity-75" href="services.html"> Facials </a>
            <a class="hover:opacity-75" href="services.html">
              Body Treatments
            </a>
            <a class="hover:opacity-75" href="booking.html"> Booking </a>
          </nav>
        </div>
        <div>
          <p class="font-medium">About Us</p>
          <nav class="flex flex-col mt-4 space-y-2 text-sm text-gray-400">
            <a class="hover:opacity-75" href="about.html"> Our Story </a>
            <a class="hover:opacity-75" href="blog.html"> Blog </a>
            <a class="hover:opacity-75" href="contact.html"> Contact Us </a>
            <a class="hover:opacity-75" href="promotions.html"> Promotions </a>
          </nav>
        </div>
        <div>
          <p class="font-medium">Contact Us</p>
          <div class="flex flex-col mt-4 space-y-4 text-sm text-gray-400">
            <a class="flex items-center" href="tel:123-456-7890">
              <i data-lucide="phone" class="w-4 h-4 mr-2"></i>
              <span>123-456-7890</span>
            </a>
            <a class="flex items-center" href="mailto:info@serenityspa.com">
              <i data-lucide="mail" class="w-4 h-4 mr-2"></i>
              <span>info@serenityspa.com</span>
            </a>
            <div class="flex items-start">
              <i data-lucide="map-pin" class="w-4 h-4 mr-2 mt-1"></i>
              <span>123 Wellness Ave, Tranquility City, ST 12345</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    <p class="mt-8 text-xs text-gray-500">
      &copy; 2024 Serenity Spa. All rights reserved.
    </p>
  </div>
  
    <%-- Global Flash Message Handler --%>
    <c:if test="${not empty sessionScope.flash_success}">
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                if (window.SpaApp && typeof window.SpaApp.showNotification === 'function') {
                    SpaApp.showNotification("${sessionScope.flash_success}", 'success');
                }
            });
        </script>
        <% session.removeAttribute("flash_success"); %>
    </c:if>

    <c:if test="${not empty sessionScope.flash_error}">
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                if (window.SpaApp && typeof window.SpaApp.showNotification === 'function') {
                    SpaApp.showNotification("${sessionScope.flash_error}", 'error');
                }
            });
        </script>
        <% session.removeAttribute("flash_error"); %>
    </c:if>
</footer>
