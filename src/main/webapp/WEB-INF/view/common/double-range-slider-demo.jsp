<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Double Range Slider Demo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/home/css/double-range-slider.css">
</head>
<body>
    <div class="wrapper">
        <div class="values">
            <span id="range1">0</span>
            <span> &dash; </span>
            <span id="range2">100</span>
        </div>
        <div class="container">
            <div class="slider-track"></div>
            <input type="range" min="0" max="100" value="30" id="slider-1" oninput="slideOne()">
            <input type="range" min="0" max="100" value="70" id="slider-2" oninput="slideTwo()">
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/home/js/double-range-slider.js"></script>
</body>
</html> 