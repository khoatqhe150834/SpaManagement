<%--
  Created by IntelliJ IDEA.
  User: quang
  Date: 18/06/2025
  Time: 6:56 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>Services</title>
</head>
<body>

    <!-- Service selection page heading -->
    <h1>Vui lòng chọn dịch vụ</h1>

    <!-- Service booking form -->
    <form action="booking" method="post">
    
    <!-- Search functionality -->
    <div class="search-bar">
        <%-- Search bar here --%>
        <input type="search" id="searchInput" name="search" placeholder="Tìm kiếm dịch vụ" oninput="handleSearchInput()">
        <button type="button" onclick="clearSearch()">Xóa</button>
    </div>

    <!-- Service type filter buttons -->
    <div class="service-types-container">

    </div>

    <!-- Price range filter -->
    <div class="price-range-slider">
      <%-- show price range slider here --%>
      <!-- Min price slider -->
      <label>Giá từ: </label>
      <input type="range" id="minPriceSlider" name="minPrice" step="200000" value="0" min="0" max="10000000" oninput="updatePriceRange()">
      <span id="minPriceValue">0 ₫</span>
      
      <!-- Max price slider -->
      <label>đến: </label>
      <input type="range" id="maxPriceSlider" name="maxPrice" step="200000" value="10000000" min="0" max="10000000" oninput="updatePriceRange()">
      <span id="maxPriceValue">10,000,000 ₫</span>
    </div>

    <!-- Main services display area -->
    <div class="services-container">
      <%-- show list of all services here --%>
    </div>

    <!-- Submit button -->
    <div style="margin-top: 20px;">
        <button type="submit">Tiếp tục</button>
    </div>

    </form>

    <!-- Include external JavaScript file -->
    <script src="${pageContext.request.contextPath}/assets/home/js/services-selection.js"></script>

</body>
</html>
