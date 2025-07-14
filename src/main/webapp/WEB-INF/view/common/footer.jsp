<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<footer class="bg-[#333333] text-white pl-64">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
    <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
      <!-- Logo and Description -->
      <div class="col-span-1 md:col-span-2">
        <div class="flex items-center mb-4">
          <i data-lucide="heart" class="h-8 w-8 text-[#D4AF37] mr-2"></i>
          <span class="text-xl font-bold font-serif">Spa Hương Sen</span>
        </div>
        <p class="text-gray-300 mb-4 leading-relaxed">
          Spa cao cấp dành riêng cho phụ nữ Việt Nam. Chúng tôi mang đến trải nghiệm thư giãn 
          và chăm sóc sắc đẹp tự nhiên với các liệu pháp truyền thống và hiện đại.
        </p>
        <div class="flex space-x-4">
          <a href="#" class="text-gray-300 hover:text-[#D4AF37] transition-colors">
            <i data-lucide="facebook" class="h-6 w-6"></i>
          </a>
          <a href="#" class="text-gray-300 hover:text-[#D4AF37] transition-colors">
            <i data-lucide="instagram" class="h-6 w-6"></i>
          </a>
          <a href="#" class="text-gray-300 hover:text-[#D4AF37] transition-colors">
            <i data-lucide="message-circle" class="h-6 w-6"></i>
          </a>
        </div>
      </div>

      <!-- Quick Links -->
      <div>
        <h3 class="text-lg font-semibold mb-4 text-[#D4AF37]">Liên kết nhanh</h3>
        <ul class="space-y-2">
          <li><a href="${pageContext.request.contextPath}/services" class="text-gray-300 hover:text-white transition-colors">Dịch vụ spa</a></li>
          <li><a href="${pageContext.request.contextPath}/services" class="text-gray-300 hover:text-white transition-colors">Chăm sóc da mặt</a></li>
          <li><a href="${pageContext.request.contextPath}/services" class="text-gray-300 hover:text-white transition-colors">Massage thư giãn</a></li>
          <li><a href="${pageContext.request.contextPath}/promotions" class="text-gray-300 hover:text-white transition-colors">Ưu đãi đặc biệt</a></li>
          <li><a href="${pageContext.request.contextPath}/customer/loyalty" class="text-gray-300 hover:text-white transition-colors">Thành viên VIP</a></li>
        </ul>
      </div>

      <!-- Contact Info -->
      <div>
        <h3 class="text-lg font-semibold mb-4 text-[#D4AF37]">Thông tin liên hệ</h3>
        <ul class="space-y-3">
          <li class="flex items-center">
            <i data-lucide="phone" class="h-4 w-4 mr-2 text-[#D4AF37]"></i>
            <span class="text-gray-300">0901 234 567</span>
          </li>
          <li class="flex items-center">
            <i data-lucide="mail" class="h-4 w-4 mr-2 text-[#D4AF37]"></i>
            <span class="text-gray-300">info@spahuongsen.vn</span>
          </li>
          <li class="flex items-start">
            <i data-lucide="map-pin" class="h-4 w-4 mr-2 text-[#D4AF37] mt-1"></i>
            <span class="text-gray-300">
              123 Nguyễn Văn Linh<br />
              Quận 7, TP. Hồ Chí Minh
            </span>
          </li>
        </ul>
      </div>
    </div>

    <div class="border-t border-gray-600 mt-8 pt-8 text-center">
      <p class="text-gray-400">
        © <%= new SimpleDateFormat("yyyy").format(new Date()) %> Spa Hương Sen. Tất cả quyền được bảo lưu.
      </p>
     
    </div>
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

<!-- Chatbot Widget - Included globally -->
<jsp:include page="/WEB-INF/includes/chatbot.jsp" />

<!-- Load chatbot functionality -->
<script src="${pageContext.request.contextPath}/js/chatbot.js"></script>
